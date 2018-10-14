#!/bin/sh
SCRIPT=$(readlink -f "$0")
BASE_DIR=$(dirname $SCRIPT)
EXEC_DIR=$BASE_DIR/jekyll
MD_FNAME=$1

echo "converting $MD_FNAME"
CONVERTED_FNAME="convert.md"

TITLE=`head -1 $MD_FNAME| tr -d "#" `
echo "Title : $TITLE"

cat <<EOF > $EXEC_DIR/$CONVERTED_FNAME
---
layout: default
title: $TITLE
---
EOF
echo "appending content to file"
cat $1 >> $EXEC_DIR/$CONVERTED_FNAME
touch $BASE_DIR/jekyll-log.txt
cd $EXEC_DIR && jekyll serve > $BASE_DIR/jekyll-log.txt &

while ! grep "Auto-regeneration" < $BASE_DIR/jekyll-log.txt ; do
  sleep 2
done

echo "page loaded"
wget --convert-links\
     --page-requisites\
     -P $BASE_DIR/      http://127.0.0.1:4000/

PDF_FNAME=`echo $MD_FNAME | cut  -f 1 -d '.'`
wkhtmltopdf $BASE_DIR/127.0.0.1:4000/index.html  $PDF_FNAME.pdf
