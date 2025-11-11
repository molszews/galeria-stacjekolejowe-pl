#!/bin/bash

[[ -z $SHA ]] && SHA=${1}
MSG=$(git log -1 --pretty="%B" "${SHA}")

(( LIMIT=1000 ))
(( COUNT=0 ))

# Read filenames line-by-line (newline-delimited). Spaces are preserved; avoid word-splitting by not using a for loop.
while IFS= read -r FILE; do
  echo "Adding ${FILE} to git"
  git add -- "${FILE}"
  (( COUNT=COUNT+1 ))
  if (( COUNT == LIMIT )); then
    echo "Making partial commit # ${COUNT}"
    git commit -m "PARTIAL COMMIT: ${MSG}"
    COUNT=0
  fi
done < <(git ls-files --others --deleted --modified)

git commit -m "PARTIAL COMMIT: ${MSG}"
