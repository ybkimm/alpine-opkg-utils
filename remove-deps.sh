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

tmpdir="$(./unpack.sh "${orig}")"
ctr_dir="${tmpdir}/_control_files"
version=$(date "+%Y-%m-%d-%H%M%S")

sed -i -E 's/^Version: (.+)$/Version: \1-'"${version}"'/' "${ctr_dir}/control"
sed -i -E 's/^Depends: .+$/Depends:/' "${ctr_dir}/control"
sed -i -E 's/^Source: (.+)\/.+\/(.+)$/Source: \1\/_dummy\/\2/' "${ctr_dir}/control"
cat "${ctr_dir}/control"

out=$(echo ${orig} | sed -E 's/(.+).ipk$/\1_nodep_'"${version}"'.ipk/')
./repack.sh "${tmpdir}" "${out}"
