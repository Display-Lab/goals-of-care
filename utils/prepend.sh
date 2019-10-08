#!/usr/bin/env bash

DATE_STR=$(date -I)

for FNAME in *.pdf
do
  mv "${FNAME}" "${DATE_STR}_${FNAME}"
done
