#!/bin/bash
# Build, Minify and Push to github after version update
REASON="$1"
echo "Build and Deploy v1.0 by DJS"

echo "-> Checking if all commandline tools are installed"
echo "--> Checking if git is installed"
if ! command -v git &> /dev/null
then
    echo "git could not be found"
    exit
fi
echo "--> Checking if uglifyjs is installed"
if ! command -v uglifyjs &> /dev/null
then
    echo "uglifyjs could not be found"
    echo "Install: npm install uglifyjs -g"
    exit
fi
echo "--> Checking if cleancss is installed"
if ! command -v cleancss &> /dev/null
then
    echo "cleancss could not be found"
    echo "Install: npm install clean-css-cli -g"
    exit
fi
echo "--> Checking if html-minifier is installed"
if ! command -v html-minifier &> /dev/null
then
    echo "cleancss could not be found"
    echo "Install: npm install html-minifier -g"
    exit
fi

echo "-> Version Update"
echo "--> Reading version from version.txt"
VERSION=$(cat version.txt)
NEWVERSION=$(echo ${VERSION} | awk -F. -v OFS=. '{$NF += 1 ; print}')
echo "--> Updating version.txt"
echo ${NEWVERSION} > version.txt
echo "--> Updating index.js"
sed -i'' -e "s/var version = '$VERSION'/var version = '$NEWVERSION'/g" js/index.js
rm -f js/index.js-e
echo "--> Updating images/site.manifest"
sed -i'' -e "s/\"version\": \"$VERSION\"/\"version\": \"$NEWVERSION\"/g" images/site.webmanifest
rm -f images/site.webmanifest-e
echo "-> Done, Version updated to ${NEWVERSION}"

echo "-> Create folder 'dist'"
mkdir -p dist
mkdir -p dist/css
mkdir -p dist/js
mkdir -p dist/images

echo "-> Copy images to 'dist'"
cp -r images dist/images

echo "-> Minification"
echo "--> Minifying JS"
uglifyjs --compress --mangle --output dist/js/index.min.js js/*.js
echo "--> Minifying CSS"
cleancss -o dist/css/index.min.css css/index.css
echo "--> Fixing relative paths in html"
cp index.html dist/index.tmp.html
sed -i'' -e "s/index.css/index.min.css/g" dist/index.tmp.html
sed -i'' -e "s/index.js/index.min.js/g" dist/index.tmp.html
sed -i'' -e "s/<script type=\"text\/javascript\" src=\"js\/verbs.js\"><\/script>//g" dist/index.tmp.html
sed -i'' -e "s/<script type=\"text\/javascript\" src=\"js\/strings.js\"><\/script>//g" dist/index.tmp.html
rm -f dist/index.tmp.html-e
echo "--> Minifing HTML"
html-minifier --collapse-whitespace --remove-comments --remove-optional-tags --remove-redundant-attributes --remove-script-type-attributes --remove-tag-whitespace --use-short-doctype dist/index.tmp.html > dist/index.html
rm -f dist/index.tmp.html

echo "-> Done"

echo "-> Git Add, Commit and Push"
git add .
git commit -m "$REASON to $NEWVERSION"
git tag -a "$NEWVERSION" -m "$REASON to $NEWVERSION"
git push --follow-tags
echo "-> Done"

echo "Done."
exit 0