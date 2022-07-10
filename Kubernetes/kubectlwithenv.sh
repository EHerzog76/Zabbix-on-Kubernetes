#!/bin/bash

set -e
dry=0
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -f|--file) fname="$2"; shift ;;
        -d|--dry) dry=1 ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

echo "Deploy file: ${fname}"

#cmd = "kubectl apply -f -"
if [ ${dry} == 1 ]; then
   echo "Dry only..."
   eval "cat <<EOF
$(<${fname})
EOF
"
else
   eval "cat <<EOF
$(<${fname})
EOF
" | kubectl apply -f -
fi
