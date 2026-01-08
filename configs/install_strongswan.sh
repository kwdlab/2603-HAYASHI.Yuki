wget https://download.strongswan.org/strongswan-6.0.3.tar.gz
tar xzf strongswan-6.0.3.tar.gz
cd strongswan-6.0.3
 
 
cd ~/strongswan-6.0.3
make clean
 
./configure \
  --prefix=/usr \
  --sysconfdir=/etc \
  --disable-defaults \
  --enable-charon \
  --enable-ikev2 \
  --enable-swanctl \
  --enable-vici \
  --enable-pki \
  --enable-x509 \
  --enable-pubkey \
  --enable-pem \
  --enable-nonce \
  --enable-random \
  --enable-drbg \
  --enable-openssl \
  --enable-kernel-netlink \
  --enable-socket-default \
  --enable-resolve \
  --enable-updown \
  --enable-eap-identity
 
make -j$(nproc)
sudo make install
