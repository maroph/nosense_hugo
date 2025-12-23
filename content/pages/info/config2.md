+++
date = '2025-12-21T11:33:00+01:00'
draft = true
title = 'Hugo Site Configuration'
tags = ['hugo']
+++

## Hugo URLs

* <https://maroph.github.io/nosense>
  main site
* <https://maroph.github.io/nosense/categories>
  list of categories
* <https://maroph.github.io/nosense/tags>
  list of tags
* <https://maroph.github.io/nosense/index.xml>
  RSS feed
* <https://maroph.github.io/nosense/sitemap.xml>
  Sitemap

## Hugo Configuration
I use [Hugo](https://gohugo.io/) to build my site with the
[beautifulhugo](https://github.com/halogenica/beautifulhugo)
theme.

```
$ hugo new site nosense
$ cd nosense
$ mkdir content/pages content/posts static/images/
$ git init
$ git submodule add https://github.com/halogenica/beautifulhugo themes/beautifulhugo
$ echo "theme = 'beautifulhugo'" >> hugo.toml
```

### Clone the Repository
```
$ git clone --recurse-submodules https://github.com/maroph/nosense.git
```

### Status/Update of the theme
```
$ git submodule status
e69e25d4ca0d3c737f0677995d2bf9541ffb4926 themes/beautifulhugo (heads/master)
```

```
$ git submodule update --remote

or

$ cd themes/beautifulhugo
$ git submodule update
$ git fetch --all
$ git pull (git pull origin master)
```

## Deploy Files to the gh-pages Branch
I use the following Python module for this purpose:

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

You can publish the current branch with the following command:

```
ghp-import --no-jekyll --push --no-history ./public
```

## Additions
### Homepage

```
$ touch content/_index.md
$ chmod 640 content/_index.md
```

### File robots.txt
```
$ touch static/robots.txt
$ chmod 640 static/robots.txt

# content of file robots.txt
$ cat static/robots.txt
User-agent: *
Disallow: /
```

### Image files

* static/images/cc-by_88x31.png
* static/images/favicon_hugo-32x32.png
* static/images/great_wave_off_kanagawa_200x200.jpg

### Directory .well-known
```
mkdir -p static/.well-known
chmod 750 static/.well-known
```

#### File .well-known/security*.txt
```
$ chmod 640 static/.well-known/security_unsigned.txt
$ cat static/.well-known/security_unsigned.txt
Contact: mailto:maroph@pm.me
Expires: 2025-12-31T22:59:00.000Z
Encryption: https://maroph.github.io/info/openpgp/pub_maroph_at_pm.me_20251218.asc
Preferred-Languages: de, en, nl
Canonical: https://maroph.github.io/nosense/.well-known/security.txt

$ chmod 640 static/.well-known/security.txt
$ cat static/.well-known/security.txt
Contact: mailto:maroph@pm.me
Expires: 2025-12-31T22:59:00.000Z
Preferred-Languages: de, en, nl
Canonical: https://maroph.github.io/nosense/.well-known/security.txt
-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEA5j4H/oU4tBbTbZpE11zypMCpZcFAmiuuUUACgkQE11zypMC
pZe81Q/+KhzkNFmDGUx5+WNcHsuhWvNLJR70MgM1+6ZFAV9ETWk8nhzwloKfB3TG
vJ/1RteGKoq5yWTudL7snz5WKyiHsMJjghAXpREkK5I4Y1RWMLZifNK87ICyiyMQ
7VKW5Aw9ItD45pOfSoRyS7gWsKqROFz9W9OS+6cxkSABAkrtrUR6mPHpoV0H27Ru
mddhZ2dzPQtkXkgDMoXMSL22VT4rKndHdnzgw8bmuW4JjzB1YviyPeopFChAIi+p
ytt06aKrsbe7mehwQUCqMLgjD0uTg6F5FXhR6cnu6FWDBWN53a4sIUMa3ywPOZ8+
6deodKS4IgV37VFVQfB6LB447xRmk/26Mh/yG1uy0F4KzLvXP8efXUQjLQHbbct8
Id9tMWn4jwtVSXihbUbD76p1PuFECaJtXOCXJT5x8h1YpFAPsyr08JkuhTKHJwNk
FgBz7ji4VmRVHCw5BMFytaXqyDJCxS9Fbz2Wju555ZxcEk6G3knmDecQXrq7xku4
mMCDJWfEL9EM0k9cwwTdLtqJw2rkFheo2OVrqbtbzszTeBFtjcBva80AYn0Q/ft5
rECPmFN9k5KXHyZ45dKOHxKrDe7CUmPk6hqBdHMVoekMkW+RGQfmjZGRYoSJcg2u
CYI1/dMAAULGW6Jd/sNla1GZSGeyHFAWmdfvfK0Y4FLNFoJ9T+Y=
=Muuk
-----END PGP SIGNATURE-----
```

#### File .well-known/webfinger
**Not used at the moment.**

```
$ curl https://mastodon.social/.well-known/webfinger?resource=acct%3Amaroph%40mastodon.social >./static/.well-known/webfinger
$ chmod 640 ./static/.well-known/webfinger
$ cat ./static/.well-known/webfinger
{"subject":"acct:maroph@mastodon.social","aliases":["https://mastodon.social/@maroph","https://mastodon.social/users/maroph"],"links":[{"rel":"http://webfinger.net/rel/profile-page","type":"text/html","href":"https://mastodon.social/@maroph"},{"rel":"self","type":"application/activity+json","href":"https://mastodon.social/users/maroph"},{"rel":"http://ostatus.org/schema/1.0/subscribe","template":"https://mastodon.social/authorize_interaction?uri={uri}"},{"rel":"http://webfinger.net/rel/avatar","type":"image/png","href":"https://files.mastodon.social/accounts/avatars/111/708/673/709/924/092/original/55d984c54f10241d.png"}]}
```

### Custom header/footer files
* layouts/partials/head_custom.html
* layouts/partials/footer_custom.html

The beautifulhugo theme supports custom header/footer files. I use this
files to make some small changes to the theme layout.

#### File head_custom.html
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

#### File footer_custom.html
```
<div style="display: block; margin: 5px;">
License: <a href="https://creativecommons.org/licenses/by/4.0/">CC-BY 4.0</a>
<a rel="me" href="https://mastodon.social/@maroph"></a>
</div>
```

