#!/bin/sh

name=$1
arch=$2

if [ -z "$name" ]; then
	echo "Usage: build.sh package-name [arch=x86_64]"
	exit 1
fi

if [ -z "$arch" ]; then
	arch=x86_64
fi

timestamp=$(date "+%s")
version=$(date "+%Y-%m-%d-%H%M%S")
tmpdir=$(mktemp -d)

cp -R emptyPackage/* ${tmpdir}

cat << EOF > ${tmpdir}/control
Package: ${name}
Version: ${version}
Depends:
Source: feeds/base/package/_dummy/${name}
SourceName: ${name}
License: ISC
Section: base
SourceDateEpoch: ${timestamp}
Maintainer: Hello <world@example.com>
Architecture: ${arch}
Installed-Size: 0
Description: dummy package for ${name}
EOF

tar -C ${tmpdir}/ -czf ${tmpdir}/control.tar.gz control
rm ${tmpdir}/control
mkdir -p bin
tar -C ${tmpdir}/ -czf "bin/${name}_${version}.ipk" control.tar.gz data.tar.gz debian-binary
rm -rf ${tmpdir}
