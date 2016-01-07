# rpi-monkey

This image is build form a  staticaly compiled monkey server via dockerize. Thus reducing the size of the image to 3MB, including default website.

Many thanks to hypriots for its work and posts... it obviously inspired most of this work.

**Compose**

Simply use "make"...But

To be able to compile haproxy staticaly a few dependencies must be met. So you can first:

> make deps

An then you can build the image
This will download monkey sources and compiles... If you run on a pi1 this might be the right time to go to the restaurant...
The monkey binary will be installed in /usr/local/bin.
> make

Test the image

> make test

And push it to the docker hub

> make push

The erase the sources and builds

> make clean

**Usage**

> docker run -d -p 80:80 cblomart/rpi-monkey

**Customizing Haproxy**

> docker run -d -p 80:80 -v \<config-dir\>:/etc/monkey -v \<data-dir\>:/var/www cblomart/rpi-monkey

where:

  \<config-dir\> is an absolute path of a directory containing the monkey config folder.

  \<data-dir\> is an absolute path of a directory containing the web site.

# License

The MIT License (MIT)

Copyright (c) 2016 cblomart

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
