#!/bin/bash

OUTDIR=fixed_domains
CSVFILE=$1
OUTFILE=$(echo $CSVFILE | sed 's/\.csv.gz$/_fixed_domains.csv.gz/')

echo "$CSVFILE -> $OUTDIR/$OUTFILE"

mkdir -p $OUTDIR

HEADERS=$(xan headers -j $CSVFILE | tr '\n' ',' | sed 's/,$//')

xan drop domains $CSVFILE                                                                       |
  xan explode links --singularize                                                               |
  xan map "replace(first(split(last(split(link, '://', 1)), '/', 1)), /^www./i, '')" domain     |
  xan implode link,domain --pluralize                                                           |
  xan select "$HEADERS"                                                                         |
  gzip > $OUTDIR/$OUTFILE
