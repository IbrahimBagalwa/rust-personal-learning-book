#!/usr/bin/env bash


function checkEnvironment(){
    type pandoc >/dev/null 2>&1 || { echo "Install 'pandoc' first (e.g. via 'brew install pandoc' or 'apt-get install pandoc')." >&2 && exit 1 ; }
    type xelatex >/dev/null 2>&1 || { echo "Install 'xelatex' first" >&2 && exit 1 ; }
}


function cleanupBeforeStarting(){
    rm -rf ./latex
    mkdir latex
}



function convertToLatex(){
    cd ./latex
    cp ../*.png .  
    pandoc ../README.md ../pdf_metadata.yaml -s -o easy_rust.tex 
    echo "Generated easy_rust.tex file."


   
    xelatex --interaction=nonstopmode easy_rust.tex 
    
    
    echo "Generated PDF file easy_rust.pdf"    
    cd ..
}



checkEnvironment
cleanupBeforeStarting
convertToLatex