function checkEnvironment(){
    type gcsplit >/dev/null 2>&1 || { echo "Install 'gcsplit' first (e.g. via 'brew install coreutils')." >&2 && exit 1 ; }
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
    for f in $(ls -tr | grep Chapter_ | sort -V); do
        local firstLine=$(sed -n '1p' $f)
        local cleanTitle=$(echo $firstLine | cut -c 3-)
        echo "- [$cleanTitle](./$f)" >> SUMMARY.md;
    done
    cd ..
}


checkEnvironment
cleanupBeforeStarting
splitIntoChapters
moveChaptersToSrcDir
createSummary