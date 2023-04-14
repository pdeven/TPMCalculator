# Base Image
FROM ubuntu:20.04

# Metadata
LABEL base.image="ubuntu:20.04"
LABEL software="TPMCalculator"
LABEL software.version="0.0.3.1"
LABEL description="This program calculates the TPM (Transcript per Millions) values for the exons and introns from NGS RNA-Seq aligned reads (BAM files)"
LABEL website="https://github.com/pdeven/TPMCalculator"
LABEL documentation="https://github.com/pdeven/TPMCalculator"
LABEL license="http://www.gnu.org/licenses/"
LABEL tags="RNA-seq"

# Maintainer
MAINTAINER Roberto Vera Alvarez <r78v10a07@gmail.com>

ENV URL=https://github.com/pdeven/TPMCalculator
ENV BAMTOOLS_URL=https://github.com/pezmaster31/bamtools
ENV FOLDER=TPMCalculator
ENV BAMTOOLS_FOLDER=bamtools
ENV DST=/tmp
ENV BAMTOOLS_DIR=/usr/local
ENV CPPFLAGS="-I $BAMTOOLS_DIR/include/bamtools"
ENV LDFLAGS="-L $BAMTOOLS_DIR/lib/bamtools -Wl,-rpath,$BAMTOOLS_DIR/lib/bamtools"

USER root

RUN apt-get clean all
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y apt-utils
RUN apt-get install -y tzdata
RUN apt-get install -y software-properties-common
RUN apt-get install -y gcc g++ perl wget zip make
RUN apt-get install -y unzip cmake git libjsoncpp-dev zlib1g-dev
RUN apt-get clean
RUN apt-get purge
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd $DST && \
        git clone $BAMTOOLS_URL && \
        cd $BAMTOOLS_FOLDER && \
        mkdir build && \
        cd build && \
        cmake .. && \
        make && \
        make install && \
        cd $DST && \
        rm -rf $BAMTOOLS_FOLDER        

RUN cd $DST && \
        git clone $URL && \
        cd $FOLDER && \
	make && \
	mv $DST/$FOLDER/bin/* /usr/local/bin/ && \
        rm -rf $DST/$FOLDER

RUN adduser --disabled-password --gecos '' ubuntu
RUN chmod a+rwx /home/ubuntu/
RUN mkdir /home/ubuntu/bin
RUN chown -R ubuntu /home/ubuntu
USER ubuntu

WORKDIR /data/

CMD ["TPMCalculator"]
