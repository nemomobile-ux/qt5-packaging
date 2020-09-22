#!/bin/bash

# Script for updating OBS copy of Qt for Nemo

# Run from local folder with the checked out OBS repository, as
# ~/home:neochapay:nemo:qt/

set -e

# set MIRROR with trailing /
MIRROR=http://www.nic.funet.fi/pub/mirrors/fedora.redhat.com/pub/fedora/linux/updates/32/Everything/SRPMS/Packages/q/

ROOT=`pwd`
LIST=`pwd`/list-q.html
PKGDIR=`pwd`/packages
PATCHDIR=`dirname $0 | xargs realpath`/patches
echo $PATCHDIR

curl $MIRROR > $LIST

VERSION=`cat $LIST | grep qt5-qtbase | awk '{split($0,a,"-"); print a[3]}'`

echo
echo Qt version: $VERSION
echo

rm -rf $PKGDIR
mkdir $PKGDIR

cd $PKGDIR
cat $LIST | grep qt5- | grep 5.14.2 | sed -n 's/.*href="\([^"]*\).*/\1/p' | xargs printf -- "$MIRROR%s " | xargs -n 1 wget

for i in *.rpm; do
    echo $i
    BN=`basename $i .src.rpm`
    SHORT=`echo $i | awk '{split($0,a,"-$VERSION"); print a[1]}'`
    SHORT=${i%-$VERSION*}

    # unpack
    rm -rf $BN
    rpmunpack $i

    # make new folder and/or replace with the new package
    mkdir -p $ROOT/$SHORT
    rm $ROOT/$SHORT/* || true
    mv $BN/* $ROOT/$SHORT/

    # remove unpacked empty folder
    rm -rf $BN

    # patch if needed
    if [ -d $PATCHDIR/$SHORT ]; then
        for p in $PATCHDIR/$SHORT/*.patch; do
            echo Applying $p
            (cd $ROOT/$SHORT/ && patch -p1 < $p)
        done
    fi

    # update local copy
    (cd $ROOT/$SHORT && osc ar)
done
