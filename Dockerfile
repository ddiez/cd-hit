FROM debian:testing AS build

LABEL maintainer Diego Diez <diego10ruiz@gmail.com>

ENV VERSION=4.6.8

RUN apt-get update -y
RUN apt-get install -y \
      curl \
      make \
      g++

RUN cd /tmp && \
    curl -L https://github.com/weizhongli/cdhit/archive/V$VERSION.tar.gz > V$VERSION.tar.gz && \
    tar xfzv V$VERSION.tar.gz && \
    cd cdhit-$VERSION && \
    mkdir /opt/cdhit && \
    make && make install PREFIX=/opt/cdhit

FROM debian:testing

RUN apt-get update -y
RUN apt-get install -y \
    libgomp1
RUN mkdir /opt/bin
COPY --from=build /opt/cdhit/* /opt/bin/

ENV PATH /opt/bin:$PATH

# User.
RUN useradd -ms /bin/bash biodev
RUN echo 'biodev:biodev' | chpasswd
USER biodev
WORKDIR /home/biodev

CMD ["/bin/bash"]
