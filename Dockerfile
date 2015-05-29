FROM ubuntu:14.04
MAINTAINER Mike Halagan <mhalagan@nmdp.org>

RUN apt-get update -q && apt-get dist-upgrade -qy
RUN apt-get install -qyy openjdk-7-jre-headless
RUN apt-get install -qyy curl build-essential git
RUN curl -OL http://search.maven.org/remotecontent?filepath=org/nmdp/ngs/ngs-tools/1.8/ngs-tools-1.8.deb
RUN dpkg --install /ngs-tools-1.8.deb && rm /ngs-tools-1.8.deb
# TODO update to 1.8.1
RUN PERL_MM_USE_DEFAULT=1 cpan Getopt::Long Data::Dumper LWP::UserAgent Test::More HTML::TreeBuilder
RUN apt-get install -qyy perl-doc
RUN export PATH=/opt/ngs-tools/bin:$PATH && cd /opt && git clone https://github.com/nmdp-bioinformatics/pipeline \
    && cd /opt/pipeline/validation \
    && perl Makefile.PL \
RUN apt-get purge -qy build-essentials git curl
RUN cd /opt/pipeline/validation && perl Makefile.PL && make && make test && make install
ENV PATH /opt/ngs-tools/bin:$PATH
CMD ["/bin/bash"]
