set -e
INDEX_BASE=RapiDoc/dist
INDEX_FILE=$INDEX_BASE/index.html
sed -i -e "s|%PAGE_TITLE%|$PAGE_TITLE|g" $INDEX_FILE
sed -i -e "s|%PAGE_FAVICON%|$PAGE_FAVICON|g" $INDEX_FILE
sed -i -e "s|%RAPIDOC_OPTIONS%|${RAPIDOC_OPTIONS}|g" $INDEX_FILE

sed -i -e "s|</rapi-doc>|<header slot='header' style='margin:auto 0;font-size:small;'></rapi-doc>|" $INDEX_FILE
for service in $(cd $INDEX_BASE/et-api-doc; find . -maxdepth 1 -type d -not -name '.' -not -name dist -not -name sample -print | sort)
do
  service=$(basename "$service")
  sed -i -e "s|</rapi-doc>| <a href='/$service/' style='margin-right:1em;color:white;'>$service</a></rapi-doc>|" $INDEX_FILE
done
sed -i -e "s|</rapi-doc>|</header></rapi-doc>|" $INDEX_FILE

for service in $(cd $INDEX_BASE/et-api-doc; find . -maxdepth 1 -type d -not -name '.' -not -name dist -not -name sample -print)
do
  service=$(basename "$service")
  mkdir "$INDEX_BASE/$service"
  cp  $INDEX_FILE "$INDEX_BASE/$service/index.html"
  sed -i -e "s|%SPEC_URL%|../et-api-doc/$service/index.yaml|" "$INDEX_BASE/$service/index.html"
  sed -i -e 's|"rapidoc-min.js"|"../rapidoc-min.js"|' "$INDEX_BASE/$service/index.html"
done

cat <<'EOS' >$INDEX_FILE
<!DOCTYPE html>
<html>
<body>
<ul>
EOS

for service in $(cd $INDEX_BASE/et-api-doc; find . -maxdepth 1 -type d -not -name '.' -not -name dist -not -name sample -print | sort)
do
  service=$(basename "$service")
  echo "<li><a href='./$service/'>$service</a></li>" >> $INDEX_FILE
done

cat <<'EOS' >> $INDEX_FILE
</ul>
</body>
EOS
