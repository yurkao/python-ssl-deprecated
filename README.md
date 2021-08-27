# python-ssl-deprecated
python recompiled with vulnerable OpenSSL including weak protocols and weak ciphers enabled (including GOST).
**This is for testing and legal PT only.**

## Vulnurabilities backported (in openssl 1.0.2u):
* Heartbleed (CVE-2014-0160)
* CCS (CVE-2014-0224)
* SWEET32 (CVE-2016-2183)
* CRIME, TLS (CVE-2012-4929)
* Include NULL ciphers by default

## Backported weak protocols
* SSLv2

## Docker images
* https://hub.docker.com/repository/docker/yurkao/openssl
* https://hub.docker.com/repository/docker/yurkao/python-openssl


