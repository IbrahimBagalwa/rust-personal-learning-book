#!/usr/bin/env bash


function checkEnvironment(){
    type gcsplit >/dev/null 2>&1 || { echo "Install 'gcsplit' first (e.g. via 'brew install coreutils')." >&2 && exit 1 ; }
    type mdbook >/dev/null 2>&1 || { echo "Install 'mdbook' first (e.g. via 'cargo install mdbook')." >&2 && exit 1 ; }
}


function cleanupBeforeStarting(){
    rm -rf ./src
    mkdir src
}


function splitIntoChapters(){
    gcsplit --prefix='Chapter_' --suffix-format='%d.md' --elide-empty-files README.md '/^## /' '{*}' -q
}


function moveChaptersToSrcDir(){
    for f in Chapter_*.md; do 
        mv $f src/$f
    done
}


function createSummary(){
    cd ./src
    touch SUMMARY.md
    echo '# Summary' > SUMMARY.md
    echo "" >> SUMMARY.md
    for f in $(ls -tr | grep Chapter_); do
        local firstLine=$(sed -n '1p' $f)
        local cleanTitle=$(echo $firstLine | cut -c 3-)
        echo "- [$cleanTitle](./$f)" >> SUMMARY.md;
    done
    cd ..
}


function buildAndServeBookLocally(){
    mdbook build && mdbook serve --open
}


checkEnvironment
cleanupBeforeStarting
splitIntoChapters
moveChaptersToSrcDir
createSummary
buildAndServeBookLocally