set -e
INDEX_BASE=RapiDoc/dist
INDEX_FILE=$INDEX_BASE/index.html
sed -i -e "s|%PAGE_TITLE%|$PAGE_TITLE|g" $INDEX_FILE
sed -i -e "s|%PAGE_FAVICON%|$PAGE_FAVICON|g" $INDEX_FILE
sed -i -e "s|%RAPIDOC_OPTIONS%|${RAPIDOC_OPTIONS}|g" $INDEX_FILE

sed -i -e "s|</rapi-doc>|<header slot='header' style='margin:auto 0;font-size:small;'></rapi-doc>|" $INDEX_FILE
for branch in $(cd $INDEX_BASE; find . -maxdepth 1 -type d -not -name '.' -not -name dist -not -name sample -print | sort)
do 
  branch=$(basename "$branch")
  sed -i -e "s|</rapi-doc>| <button class='branch-button' data-branch='$branch' style='background: none!important;border: none;padding: 0!important;text-decoration: underline;cursor: pointer;margin-right:1em;color:white;font-weight:bold'>$branch</button></rapi-doc>|" $INDEX_FILE
done

for branch in $(cd $INDEX_BASE; find . -maxdepth 1 -type d -not -name '.' -not -name dist -not -name sample -print | sort)
do
  branch=$(basename "$branch")
  BRANCH_INDEX_BASE=$INDEX_BASE/$branch
  BRANCH_INDEX_FILE=$BRANCH_INDEX_BASE/index.html
  cp $INDEX_FILE $BRANCH_INDEX_FILE
  for service in $(cd $BRANCH_INDEX_BASE/et-api-doc; find . -maxdepth 1 -type d -not -name '.' -not -name dist -not -name sample -print | sort)
  do
    service=$(basename "$service")
    sed -i -e "s|</rapi-doc>| <a href='../$service/' style='margin-right:1em;color:white;'>$service</a></rapi-doc>|" $BRANCH_INDEX_FILE
  done
  sed -i -e "s|</rapi-doc>|</header></rapi-doc>|" $BRANCH_INDEX_FILE
  sed -i -e "s|</rapi-doc>|<h1 slot='overview'>$branch</h1></rapi-doc>|" $BRANCH_INDEX_FILE

  for service in $(cd $BRANCH_INDEX_BASE/et-api-doc; find . -maxdepth 1 -type d -not -name '.' -not -name dist -not -name sample -print)
  do
    service=$(basename "$service")
    mkdir "$BRANCH_INDEX_BASE/$service"
    cp  $BRANCH_INDEX_FILE "$BRANCH_INDEX_BASE/$service/index.html"
    sed -i -e "s|%SPEC_URL%|../et-api-doc/$service/index.yaml|" "$BRANCH_INDEX_BASE/$service/index.html"
    sed -i -e 's|"rapidoc-min.js"|"../../rapidoc-min.js"|' "$BRANCH_INDEX_BASE/$service/index.html"
  done

cat <<'EOS' >$BRANCH_INDEX_FILE
<!DOCTYPE html>
<html>
<body>
<ul>
EOS

for service in $(cd $BRANCH_INDEX_BASE/et-api-doc; find . -maxdepth 1 -type d -not -name '.' -not -name dist -not -name sample -print | sort)
do
  service=$(basename "$service")
  echo "<li><a href='./$service/'>$service</a></li>" >> $BRANCH_INDEX_FILE
done

cat <<'EOS' >> $BRANCH_INDEX_FILE
</ul>
</body>
EOS

done

cat <<'EOS' >$INDEX_FILE
<!DOCTYPE html>
<html>
<body>
<ul>
EOS

for branch in $(cd $INDEX_BASE; find . -maxdepth 1 -type d -not -name '.' -not -name dist -not -name sample -print | sort)
do
  branch=$(basename "$branch")
  echo "<li><a href='./$branch/'>$branch</a></li>" >> $INDEX_FILE
done

cat <<'EOS' >> $INDEX_FILE
</ul>
</body>
EOS
