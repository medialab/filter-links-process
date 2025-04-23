#!/bin/bash
# Requires médialab's xan, the CSV magician
# https://github.com/medialab/xan

OUTDIR=migrants-KT-exports
mkdir -p $OUTDIR

# For every monthly dataset of the tweets "filter:links lang:fr"
ls monthly_export_20*.csv.gz | while read MONTHFILE; do

  OUTFILE=$(echo $MONTHFILE | sed -r 's/^(monthly_export_20.....).*.csv.gz$/\1_migrants.csv.gz/')
  echo $MONTHFILE '->' $OUTDIR/$OUTFILE

  # Keep only those including migrants issues in the tweet's text
  xan search -s text -r "\b((im)?migra(t(ion|oire)|nts?)|\S*asile|mineur\S*\s+isol[eé]\S*|r[eé]fugi[eé]s?)\b" $MONTHFILE |
    # Remove all retweets
    xan search -s retweeted_id --empty                      |
    # Remove tweets with no actual link (tweets with images/videos are considered within filter:links)
    xan search -s links --non-empty                         |
    # Split tweets with multiple links across multiple lines
    xan explode --singularize links,domains                 |
    # Remove links that are just links to other tweets
    xan search -s domain --exact twitter.com --invert-match |
    # Regroup splitted tweets into single lines
    xan implode --cmp id --pluralize link,domain            |
    # Keep only pertinent fields
    xan select "id,url,local_time,like_count,retweet_count,user_id,user_screen_name,user_followers,user_description,links,domains,text" |
    # Recompress
    gzip > $OUTDIR/$OUTFILE && echo "Finished processing $MONTHFILE" || echo "Failed processing $MONTHFILE" &

done

# Wait reasonable time for all files to be processed
sleep 1800

# Finally assemble all monthly files between Jan 22 and Sept 22 into a single zipped one
xan cat rows $OUTDIR/monthly_export_2022-0* | gzip > $OUTDIR/tweets_filter-links_2022-01-09_migrants.csv.gz
