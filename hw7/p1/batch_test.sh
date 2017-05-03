#!/bin/bash
FILES=./tests/*

for f in $FILES
do
  echo "==================================================================="
  echo "Processing $f ..."
  krun $f
done
