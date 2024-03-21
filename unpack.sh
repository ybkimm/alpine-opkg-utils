#!/bin/sh

set -e

orig=$1

if [ -z "$orig" ]; then
	echo "Usage: build.sh package.ipk"
	exit 1
fi

if [ ! -e "$orig" ]; then
	echo "Error: File ${orig} not exists"
	exit 2
fi

tmpdir=$(mktemp -d)
tar -C "${tmpdir}" -xzf "${orig}"

ctr_dir="${tmpdir}/_control_files"

mkdir -p "${ctr_dir}"
tar -C "${ctr_dir}" -xzf "${tmpdir}/control.tar.gz"
rm "${tmpdir}/control.tar.gz"

echo "${orig}" > "${tmpdir}/.orig"
echo "${tmpdir}"
