FROM ubuntu:14.04
MAINTAINER Mike Halagan <mhalagan@nmdp.org>

RUN PERL_MM_USE_DEFAULT=1 apt-get update -q \
    && apt-get dist-upgrade -qy \
    && apt-get install -qyy openjdk-7-jre-headless perl-doc curl build-essential git \
    && curl -OL http://search.maven.org/remotecontent?filepath=org/nmdp/ngs/ngs-tools/1.8.1/ngs-tools-1.8.1.deb \
    && dpkg --install /ngs-tools-1.8.1.deb && rm /ngs-tools-1.8.1.deb \
    && cpan Getopt::Long Data::Dumper LWP::UserAgent Test::More HTML::TreeBuilder \
    && export PATH=/opt/ngs-tools/bin:$PATH \
    && cd /opt && git clone https://github.com/nmdp-bioinformatics/pipeline \cd 
    && cd /opt/pipeline/validation && perl Makefile.PL \
    && make && make test && make install \
    && apt-get purge -qy build-essentials git curl \
    && cd /opt && wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.2.30+-x64-linux.tar.gz \
    && tar -xzvf ncbi-blast-2.2.30+-x64-linux.tar.gz && export PATH=/opt/ncbi-blast-2.2.30+/bin:$PATH \
    && rm ncbi-blast-2.2.30+-x64-linux.tar.gz && mkdir /opt/imgt-db \
    && ngs-imgt-db -o /opt/imgt-db -c -r -f \

ENV PATH /opt/ngs-tools/bin:$PATH

CMD ["/bin/bash"]
