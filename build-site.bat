@echo off
call lessc assets/includes/css/github.css assets/includes/css/github.min.css --clean-css="--s1 --advanced"
call lessc assets/includes/css/haxe-nav.css assets/includes/css/haxe-nav.min.css --clean-css="--s1 --advanced"
call lessc assets/includes/css/styles.css assets/includes/css/styles.min.css --clean-css="--s1 --advanced"
rmdir "output" /S /Q
mkdir "output"
neko CodeCookBook.n