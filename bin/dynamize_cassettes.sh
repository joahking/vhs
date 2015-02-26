#!/bin/sh

# replaces all sandboxes rest urls in cassettes with <%= api_host %>

for file in `find $1 -name "*.yml"`
do
  sed -i -e 's/uri: http:\/\/.*.env.xing.com:3007\/rest/uri: <%= api_host %>/g' $file
  rm "$file-e"
done

