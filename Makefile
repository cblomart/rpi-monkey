#
# Libraries:
# this suppose that you have the necessary libraries and build system
# they can be installed via:
# $ sudo apt-get install build-essential cmake
#
# Utilities:
# this uses dockerize which can be installed with
# $ sudo apt-get python-pip
# $ sudo pip install https://github.com/larsks/dockerize/archive/master.zip
#
# or you could use the deps target of the makefile
#


DOCKER_IMAGE_VERSION=0.0.2
DOCKER_IMAGE_NAME=cblomart/rpi-monkey
DOCKER_IMAGE_TAGNAME=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)
MONKEY_VERSION=1.6.7

default: build

src:
	if [ ! -d src ]; then mkdir src; fi

tmp:
	if [ ! -d tmp ]; then mkdir tmp; fi

src/monkey-$(MONKEY_VERSION).tar.gz: src
	if [ ! -e src/monkey-$(MONKEY_VERSION).tar.gz ]; then wget http://monkey-project.com/releases/1.6/monkey-$(MONKEY_VERSION).tar.gz -P src; fi

src/monkey-$(MONKEY_VERSION): src/monkey-$(MONKEY_VERSION).tar.gz
	if [ ! -d src/monkey-$(MONKEY_VERSION) ]; then tar -zxf src/monkey-$(MONKEY_VERSION).tar.gz -C src; fi

src/monkey-$(MONKEY_VERSION)/build/monkey: src/monkey-$(MONKEY_VERSION)
	if [ ! -d src/monkey-$(MONKEY_VERSION)/build ]; then cd src/monkey-$(MONKEY_VERSION) && CFLAGS="-Os -march=native" ./configure --local --static-lib-mode --static-plugins=auth,fastcgi,tls,dirlisting,cheetah,liana,logger --disable-plugins=cgi,cheetah,mandril; fi
	if [ ! -x src/monkey-$(MONKEY_VERSION)/build/monkey ]; then make -C src/monkey-$(MONKEY_VERSION); fi
	strip --strip-all src/monkey-$(MONKEY_VERSION)/build/monkey

build: src/monkey-$(MONKEY_VERSION)/build/monkey tmp
	sudo cp src/monkey-$(MONKEY_VERSION)/build/monkey /usr/local/bin/
	dockerize -t $(DOCKER_IMAGE_NAME) -L copy-unsafe -a etc/monkey/. /etc/monkey/. -a var/. /var/. --entrypoint "/usr/local/bin/monkey -c /etc/monkey/" /usr/local/bin/monkey
	cp Dockerfile tmp/
	docker build -t $(DOCKER_IMAGE_NAME) tmp
	docker tag -f $(DOCKER_IMAGE_NAME) $(DOCKER_IMAGE_NAME):latest
	docker tag -f $(DOCKER_IMAGE_NAME) $(DOCKER_IMAGE_TAGNAME)

clean:
	rm -rf src
	rm -rf tmp

deps:
	sudo apt-get install -y build-essential cmake python-pip
	sudo pip install https://github.com/larsks/dockerize/archive/master.zip 

push:
	docker push $(DOCKER_IMAGE_NAME)

test:
	docker run --rm $(DOCKER_IMAGE_NAME) --version
