#!/bin/bash

mkdir -p light_exports/

SALT=$RANDOM$RANDOM$RANDOM

ls monthly_export_20*.csv.gz | while read monthfile; do

  outfile=$(echo $monthfile | sed -r 's/^(monthly_export_20.....).*.csv.gz$/\1_timestamp_user_url.csv.gz/')
  echo $monthfile '->' light_exports/$outfile

  xan search -s retweeted_id --empty $monthfile 				|
    xan search -s links --non-empty			    				|
    xan select -e "local_time as france_datetime, md5(concat(user_id, '$SALT')) as hash_user, links, domains, retweet_count as retweets_count, md5(concat(to_userid, '$SALT')) as to_hash_user" |
    xan explode --singularize links,domains 					|
    xan search -s domain --exact --invert-match twitter.com 	|
    gzip > light_exports/$outfile && echo "Finished processing $monthfile" || echo "Failed processing $monthfile" &

done

