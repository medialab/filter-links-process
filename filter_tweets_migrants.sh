#!/bin/bash

OUTDIR=migrants-KT-exports
mkdir -p $OUTDIR

ls monthly_export_20*.csv.gz | while read MONTHFILE; do

  OUTFILE=$(echo $MONTHFILE | sed -r 's/^(monthly_export_20.....).*.csv.gz$/\1_migrants.csv.gz/')
  echo $MONTHFILE '->' $OUTDIR/$OUTFILE

  xan search -s text -r "\b((im)?migra(t(ion|oire)|nts?)|\S*asile|mineur\S*\s+isol[eé]\S*|r[eé]fugi[eé]s?)\b" $MONTHFILE 	|
    gzip > $OUTDIR/$OUTFILE && echo "Finished processing $MONTHFILE" || echo "Failed processing $MONTHFILE" &

done
