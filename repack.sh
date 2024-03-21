#!/bin/bash

set -e

tmpdir=$1
out=$2

if [ -z "$tmpdir" ]; then
	echo "Usage: build.sh /path/to/tmp/dir [/path/to/out/file]"
	exit 1
fi

if [[ ! -d "$tmpdir" || ! -f "${tmpdir}/.orig" ]]; then
	echo "Error: ${tmpdir} is not exists or not regular directory"
	exit 2
fi

orig=$(cat "${tmpdir}/.orig")
rm "${tmpdir}/.orig"

if [[ -z "$out" ]]; then
	out=$(echo ${orig} | sed -E 's/(.+).ipk$/\1_'$(date "+%Y-%m-%d-%H%M%S")'.ipk/')
fi

tar -C "${tmpdir}/_control_files" -czf "${tmpdir}/control.tar.gz" $(find "${tmpdir}/_control_files" -type f -printf '%f\n')
rm -rf "${tmpdir}/_control_files"

mkdir -p bin
tar -C ${tmpdir}/ -czf "bin/${out}" control.tar.gz data.tar.gz debian-binary

rm -rf ${tmpdir}
