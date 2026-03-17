FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Base build requirements
RUN apt-get update -y && apt-get install -y \
    build-essential libtool autotools-dev automake pkg-config \
    bsdmainutils python3 \
    libevent-dev libboost-dev \
    libsqlite3-dev \
    libminiupnpc-dev libnatpmp-dev \
    libzmq3-dev \
    git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY . /digibyte
WORKDIR /digibyte

RUN ./autogen.sh
RUN ./configure \
    --without-gui \
    --disable-tests \
    --disable-bench \
    --disable-man \
    --with-incompatible-bdb \
    CXXFLAGS="-O2"
RUN make -j$(nproc)
RUN make install
RUN strip /usr/local/bin/digibyted /usr/local/bin/digibyte-cli

EXPOSE 12024 14022 28332 28333

CMD ["digibyted", "-printtoconsole"]
