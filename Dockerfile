FROM ubuntu:24.04
LABEL maintainer="andreas.steffen@strongswan.org"

ENV VERSION="6.0.3"
ARG IPERF_VER=3.19.1
ARG NUTTCP_VER=8.2.2

RUN \
  # install packages
  DEV_PACKAGES="wget bzip2 make gcc libssl-dev pkg-config" && \
  apt-get -y update && \
  apt-get -y install iproute2 iputils-ping nano tcpdump $DEV_PACKAGES && \
  \
  # download and build strongSwan
  mkdir /strongswan-build && \
  cd /strongswan-build && \
  wget https://download.strongswan.org/strongswan-$VERSION.tar.bz2 && \
  tar xfj strongswan-$VERSION.tar.bz2 && \
  cd strongswan-$VERSION && \
  ./configure --prefix=/usr --sysconfdir=/etc --disable-defaults \
    --enable-charon \
    --enable-ikev2 --enable-ikev1 --enable-curve25519 \
    --enable-nonce --enable-random --enable-openssl --enable-pem \
    --enable-x509 --enable-pubkey --enable-constraints --enable-pki \
    --enable-socket-default --enable-kernel-netlink --enable-swanctl \
    --enable-resolve --enable-eap-identity --enable-eap-md5 \
    --enable-eap-dynamic --enable-eap-tls --enable-updown --enable-vici \
    --enable-ml --enable-silent-rules && \
  make -j"$(nproc)" && make install && \
  cd / && rm -R /strongswan-build && \
  ln -s /usr/libexec/ipsec/charon /charon && \
  \
  cd /tmp && \
  wget -O iperf.tgz https://downloads.es.net/pub/iperf/iperf-${IPERF_VER}.tar.gz && \
  tar xzf iperf.tgz && cd iperf-${IPERF_VER} && \
  ./configure --prefix=/usr && \
  make -j"$(nproc)" && make install && cd / && rm -rf /tmp/iperf* && \
  \
  cd /tmp && \
  wget https://nuttcp.net/nuttcp/nuttcp-${NUTTCP_VER}.tar.bz2 && \
  tar xjf nuttcp-${NUTTCP_VER}.tar.bz2 && \
  cd nuttcp-${NUTTCP_VER} && \
  make && install -m 0755 nuttcp-${NUTTCP_VER} /usr/bin/nuttcp && \
  cd / && rm -rf /tmp/nuttcp-* && \
  \
  # clean up
  apt-get -y remove $DEV_PACKAGES && \
  apt-get -y autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

EXPOSE 500/udp 4500/udp 5201/tcp 5201/udp 5000/tcp 5001/tcp 5001/udp
