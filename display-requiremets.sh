#/bin/bash

set -e

for a in `find . -name requirements.txt`
do
    echo ====================== $a
    cat $a
done | sort | uniq

