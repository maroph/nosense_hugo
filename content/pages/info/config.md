+++
date = '2025-11-29T15:56:00+01:00'
draft = false
title = 'Config'
+++

## Introduction
I intend is to create a simple blog that I want to host as GitHub Pages. 
Further, I would like to add some note pages to this site.

I want to write my text in Markdown, so I need some software to
create the website data.

The static site generator [Hugo](https://gohugo.io/) seems to
be just what I need - let's give it a try in this prototype repository.

All the Hugo site data are located in the branch _main_ of my GitHub repository
[maro/nosense_hugo](https://github.com/maroph/nosense_hugo).

The created site data are stored in the branch _gh-pages_, to be served
as GitHub Pages at

* <https://maroph.github.io/nosense_hugo>  
  main site
* <https://maroph.github.io/nosense_hugo/categories>  
  list of categories
* <https://maroph.github.io/nosense_hugo/tags>  
  list of tags
* <https://maroph.github.io/nosense_hugo/index.xml>  
  RSS feed

I use the Python module [ghp-import](https://github.com/c-w/ghp-import)
to copy the data to this branch.

## Installation
Download the proper archive from the 
[Hugo Releases Page](https://github.com/gohugoio/hugo/releases).

The following Python module is needed:

* [PyPi:ghp-import](https://pypi.org/project/ghp-import/)

```bash
python3 -m venv --prompt ghp-import ./venv
chmod 700 ./venv || exit 1
source ./venv/bin/activate || exit 1
#
python -m pip install --upgrade pip
python -m pip install --upgrade setuptools
python -m pip install --upgrade wheel
#
python -m pip install --upgrade ghp-import
```

To keep things simple, I use an own virtual environment for this installation.

## Documentation

https://gohugo.io/

https://gohugo.io/documentation/

https://github.com/gohugoio/hugo

https://github.com/gohugoio/hugo/releases

https://github.com/git-buch/my-blog

https://github.com/git-compendium/simple-blog


## Themes
I use the the theme 
[beautifulhugo](https://github.com/halogenica/beautifulhugo)
for my site.

You will find more themes at the 
Hugo [Themes](https://themes.gohugo.io/)
site.

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

## Adapt the Configuration
My configuration in use is store in the Hugo configuration file 
[hugo.toml](https://raw.githubusercontent.com/maroph/nosense_hugo/refs/heads/main/hugo.toml).

### Content Data

_content/pages_
_content/posts_

### Logo Files
I added these image files

* static/images/cc-by_88x31.png
* static/images/favicon_hugo-32x32.png
* static/images/great_wave_off_kanagawa_200x200.jpg

### HTML/CSS
I added the following files to the directory  _layouts/partials_:

 * head_custom.html
 * footer_custom.html

#### head_custom.html
Content:

```

<meta name="fediverse:creator" content="@maroph@mastodon.social" />
<style>
body {
  background: #fcfcfc;
}
.pages-heading, .posts-heading {
  text-align: center;
}
</style>
```

#### footer_custom.html
Content:

```
<div style="display: block; margin: 5px;">
License: <a href="https://creativecommons.org/licenses/by/4.0/">CC-BY 4.0</a>
<a rel="me" href="https://mastodon.social/@maroph"></a>
</div>
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

