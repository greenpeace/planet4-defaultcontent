#!/usr/bin/env bash
set -e

function quote_and_join() {
  items=("$@")
  printf "'%s'," "${items[@]}" | rev | cut -c2- | rev
}

readarray -t names <./test_content_urls
test_names=$(quote_and_join "${names[@]}")
echo "$test_names"
query="SELECT id FROM wp_posts WHERE post_type IN ('post','page','campaign') AND post_name IN ($test_names)"
echo $query

# WP CLI db query supports only one format, as a formatted table. Pardon my messy bash that deals with that.
test_post_ids=$(wp db query --skip-column-names "$query" | tr '\n' ',' | sed 's/[^0-9,]*//g' | rev | cut -c2- | rev)

echo $test_post_ids
IFS=',' read -r -a id_array <<< "$test_post_ids"

for i in "${id_array[@]}"
do
   echo "$i"
   wp post meta update $i test-content 1
done

wp export --dir=/tmp/probe-output --filename_format="test-content.xml" --post__in="$test_post_ids"

