#!/bin/bash

VERSION=2.8.18
URL=http://download.redis.io/releases/redis-${VERSION}.tar.gz

which wget > /dev/null
if [ $? -ne 0 ]; then
  echo "Aborting. Cannot continue without wget."
  exit 1
fi

which rpmbuild > /dev/null
if [ $? -ne 0 ]; then
  echo "Aborting. Cannot continue without rpmbuild. Please install the rpmdevtools package."
  exit 1
fi

# Let's get down to business
TOPDIR=$(pwd)

if [ -e rpmbuild ]; then
  rm -rf rpmbuild/* 2>&1 > /dev/null
fi

echo "Creating RPM build path structure..."
mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS,tmp}

echo "Building Redis RPM ..."
cp 000* redis* sources ${TOPDIR}/rpmbuild/SOURCES/
cp redis.spec ${TOPDIR}/rpmbuild/SPECS/

cd ${TOPDIR}/rpmbuild/SOURCES/
wget ${URL}

cd ${TOPDIR}/rpmbuild/
rpmbuild --define "_topdir ${TOPDIR}/rpmbuild" -ba "SPECS/redis.spec"
