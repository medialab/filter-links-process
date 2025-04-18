#!/bin/bash

OUTDIR=light_exports
mkdir -p $OUTDIR

SALT=$RANDOM$RANDOM$RANDOM

ls monthly_export_20*.csv.gz | while read MONTHFILE; do

  OUTFILE=$(echo $MONTHFILE | sed -r 's/^(monthly_export_20.....).*.csv.gz$/\1_timestamp_user_url.csv.gz/')
  echo $MONTHFILE '->' $OUTDIR/$OUTFILE

  xan search -s retweeted_id --empty $MONTHFILE 				|
    xan search -s links --non-empty			    				|
    xan select -e "local_time as france_datetime, md5(concat(user_id, '$SALT')) as hash_user, links, domains, retweet_count as retweets_count, md5(concat(to_userid, '$SALT')) as to_hash_user" |
    xan explode --singularize links,domains 					|
    xan search -s domain --exact --invert-match twitter.com 	|
    gzip > $OUTDIR/$OUTFILE && echo "Finished processing $MONTHFILE" || echo "Failed processing $MONTHFILE" &

done
