#!/bin/bash
lessc assets/includes/css/haxe-nav.css assets/includes/css/haxe-nav.min.css --clean-css="--s1 --advanced"
lessc assets/includes/css/styles.css assets/includes/css/styles.min.css --clean-css="--s1 --advanced"
rm -rf output
mkdir output
neko CodeCookBook.n
