# python-ssl-deprecated
python recompiled with vulnerable OpenSSL including weak protocols and weak ciphers enabled (including GOST).

**This is for testing and legal PT only.**

## OpenSSL code base: 1.0.2u
## Vulnurabilities backported from previous releases of OpenSSL:
* Heartbleed (CVE-2014-0160)
* CCS (CVE-2014-0224)
* SWEET32 (CVE-2016-2183)
* CRIME, TLS (CVE-2012-4929)
* LOGJAM (CVE-2015-4000)
* Include NULL ciphers by default
* Export protocols enabled by default

## Backported weak protocols
* SSLv2

## Docker images
* https://hub.docker.com/repository/docker/yurkao/openssl
* https://hub.docker.com/repository/docker/yurkao/python-openssl


