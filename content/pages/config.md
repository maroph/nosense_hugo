+++
date = '2025-08-22T12:30:57+02:00'
draft = false
title = 'Config'
+++
Config Page.

## Introduction
My idea of is to create a simple blog that I want to host as GitHub Pages.

I want to write my text in Markdown, so I need some software to
create the web site data.

The static site generator [Hugo](https://gohugo.io/) seems to
be just what I need - lets give it a try.

All the Hugo site data are located in the branch _main_ of my GitHub repository
[maro/nosense_hugo](https://github.com/maroph/nosense_hugo).

The created site data are stored in the branch _gh-pages_, to be served
as GitHub Pages. I use the Python module
[ghp-import](https://github.com/c-w/ghp-import)
to copy the data to this branch.

## Installation
Download the proper archive from the 
[Hugo Releases Page](https://github.com/gohugoio/hugo/releases).

The following Python module is needed:

* [PyPi:ghp-import](https://pypi.org/project/ghp-import/)

```bash
python3 -m venv --prompt ghp-import --without-pip ./venv
chmod 700 ./venv || exit 1
source ./venv/bin/activate || exit 1
#
python -m pip install --upgrade pip
python -m pip install --upgrade setuptools
python -m pip install --upgrade wheel
#
python -m pip install --upgrade ghp-import
```

To keep things simple, I use an own virtual environment for the installation.

## Documentation

https://gohugo.io/

https://gohugo.io/documentation/

https://github.com/gohugoio/hugo

https://github.com/gohugoio/hugo/releases

https://github.com/git-buch/my-blog

https://github.com/git-compendium/simple-blog


## Themes
TODO

## Plugins
TODO

## Create the Hugo Site

```bash
hugo new site nosense_hugo
cd nosense_hugo
mkdir content/pages content/posts static/images/
git init
git submodule add https://github.com/halogenica/beautifulhugo themes/beautifulhugo
echo "theme = 'beautifulhugo'" >> hugo.toml
```

Update the theme related submodule:

```bash
git submodule update --remote
```

## Create the First Page
```bas
hugo new content pages/about.md
```

## Create the First Post
```bas
hugo new content posts/my-first-post.md
```

## Build/Test Commands
### Build the Local Site
```bash
hugo build
```

### Run the Local Site
```bash
hugo server
```

The local site is available at <http://localhost:1313/nosense_hugo/>

### Deploy the Site
```bash
hugo build
ghp-import --no-jekyll --push --no-history ./public
```

