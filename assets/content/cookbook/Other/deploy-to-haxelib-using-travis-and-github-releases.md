[tags]: / "haxelib,github,travis,libraries,git"

# Publish to Haxelib using Travis using Github Releases

This tutorial will help you publish your library automatically to [lib.haxe.org](https://lib.haxe.org/) when you create a release on GitHub.

## Motivation

This may seen as quite some steps, in reality it will make your life much easier and has great advantages:

- Collaborators on GitHub can help publish on haxelib without the need of sharing/knowing _your_ password.
- It automatically tests your project (even on each build, even for each pull request you might get), this helps to not accidentally publish broken builds.
- You can just make a release using the GitHub website.
- It makes sure you have tagged your projects. Because that's what GitHub does for you when doing a release. 
- It is more transparent for collaborators/users what goes into the haxelib package zip file.
- It will make you look 36% more professional.

## What do you need

- [GitHub](https://github.com/) account and basic knowledge how to use Git. 
- A [Travis account](https://travis-ci.org/). You can create one by linking your GitHub profile. 
- A [Haxelib account](https://lib.haxe.org/). If you have Haxe installed, you can run command-line: `haxelib register`. Remember your password. 

## Getting started

Create a (useful) project and push it to GitHub.

#### Add haxelib.json
Create and push `haxelib.json`. This is your configuration for Haxelib projects.
```json
{
"name": "LIBNAME",
"url": "https://github.com/GITHUB_USERNAME/LIBNAME",
"license": "MIT",
"tags": [],
"description": "Cool Project",
"version": "0.0.1",
"classPath": "src/",
"releasenote": "Initial release",
"contributors": [
	"markknol"
],
"dependencies": {

}
}
```
#### Add .travis.yml
Create and push `.travis.yml`. This is your configuration for Travis.
```bash
sudo: required
dist: trusty

language: haxe

haxe:
 - "3.4.7"
 - "development"

matrix:
 allow_failures:
   - haxe: development

install:
 - haxelib dev LIBNAME .

script:
 - haxe test.hxml

deploy:
 - provider: script
   haxe: 3.4.7
   script: bash ./release_haxelib.sh $HAXELIB_PWD
   on:
	 tags: true
```
#### Add release_haxelib.sh
Create and push `release_haxelib.sh`. This is a bash file that Travis will run to deploy to Haxelib. 

> Leave `$HAXELIB_PWD` like this, we will give Travis the password in a private/secure way. 

As you can see, it creates a zip which will be send to Haxelib. This zip includes the src-folder, all markdown files, json files and hxml files and run file (if present). You can customize this to your needs.
```bash
#!/bin/sh
rm -f library.zip
zip -r library.zip src *.md *.json *.hxml run.n
haxelib submit library.zip $HAXELIB_PWD --always
```

#### On GitHub: Enable travis  

 - Go to <https://github.com/GITHUB_USERNAME/LIBNAME/settings/installations>
 - Add service: "Travis CI"
 - You can skip the details (user, token, domain), just press the green button "Add service". 
	
#### On Travis: Enable travis for project  

 - You need to have your GitHub account synced to Travis.
 - Go to <https://travis-ci.org/profile/GITHUB_USERNAME>
 - Press "Sync account" this will update the repositories list.
 - Find the GitHub repository in the list, enable the project (make option &#10003;)

#### On Travis: Configure the settings

 - Go to the project settings <https://travis-ci.org/GITHUB_USERNAME/LIBNAME/settings>
 - Add a line to "Environment Variables":
   - name: HAXELIB_PWD
   - value: **************** (Strong password, don't tell anyone)
   - Disable "Display value in build log" (_needs_ to be off, guess why)

## Publish to Haxelib 

Assuming your project is good to go, you can now publish to Haxelib.

### New Haxelib users

If you never ever published to Haxelib before; welcome to haxelib! Unfortunatly, your first release should be done by hand.


Run from commandline (bash):
```bash
zip -r library.zip src *.md *.json *.hxml run.n
haxelib submit library.zip
```

> If you are using Git Bash on Windows, [install Zip for Git Bash extension](https://ranxing.wordpress.com/2016/12/13/add-zip-into-git-bash-on-windows/) first.  
> If the zip command doesn't work for you, just create the zip however you want. As you can see, it includes the src-folder and some other file extensions. Customize it to your needs.

### Release steps

These are the release steps you need to take from now on:

<p><img src="assets/deploy-haxelib-using-travis-and-github.gif" style="box-shadow:0 0 10px #DDD" /></p>

0. Update haxelib.json: Raise the `version` ([Haxelib uses a simplified version of SemVer](https://lib.haxe.org/documentation/creating-a-haxelib-package/#versioning) and change `releasenotes`.
0. GitHub > Releases > Make new release <https://github.com/GITHUB_USERNAME/LIBNAME/releases/new>
0. Enter release information:  

    - Tag name should be same as `version` in haxelib.json
    - Add release notes 
    - Press "Publish release"

0. Wait for Travis 
0. Check if it actually released the project <https://lib.haxe.org/recent/>. Congrats, your library is published.

## Optional fun

- Add a Travis badge to your README.md. This is the markdown you need for that.

```
[![Build Status](https://travis-ci.org/GITHUB_USERNAME/LIBNAME.svg?branch=master)](https://travis-ci.org/GITHUB_USERNAME/LIBNAME)
```

- Since you now have automatic deployment, you also have automated testing. You can add more tests.

Enjoy automated deploys!