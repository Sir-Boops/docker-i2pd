FROM alpine:3.7

ENV I2PD_VER="2.19.0"

RUN addgroup i2p && \
    adduser -D -h /opt -G i2p i2p && \
    echo "i2p:`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 | mkpasswd -m sha256`" | chpasswd

RUN apk add -U --virtual deps \
        gcc g++ cmake make \
        openssl-dev boost-dev && \
    apk add boost-filesystem \
        boost-program_options \
        boost-date_time \
        libssl1.0 libstdc++ && \
    cd ~ && \
    wget https://github.com/PurpleI2P/i2pd/archive/$I2PD_VER.tar.gz && \
    tar xf $I2PD_VER.tar.gz && \
    cd ~/i2pd-$I2PD_VER/build && \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/i2pd \
        -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc) && \
    make install && \
    rm -rf ~/* && \
    apk del --purge deps && \
    chown i2p:i2p -R /opt/*

USER i2p
CMD /opt/i2pd/bin/i2pd --http.enabled=1 --http.address=0.0.0.0 --http.port=8080 --httpproxy.enabled=1 --httpproxy.address=0.0.0.0 --httpproxy.port=4444
