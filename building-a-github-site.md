# Building a GitHub Pages website
## Step by step.

### Create the repository on GitHub.

Create a repositoy on GitHub with (in my case) the name
[ssavitzky.github.io](https://github.com/ssavitzky/ssavitzky.github.io.git)

### Make shared repo and working tree on my web host.

```bash
ssh savitzky.net
cd git/web   # all my website repositories live here.
git clone --bare git@github.com:ssavitzky/ssavitzky.github.io.git
cd ../../vv/web
git clone ../../git/web/ssavitzky.github.io.git/

```

On my web host, bare git repositories live in `~/git`, and working trees live
in corresponding directories under `~/vv`.  The web subdirectory of each one
is where websites live; their name is (usually) the domain name of the site.
Eventually I'm going to use the site on my web host as a staging area.

### Make a working directory on my laptop

```
cd ~/vv/web
git clone savitzky@savitzky.net:git/web/ssavitzky.github.io.git
cd ssavitzky.github.io.git
git remote add github git@github.com:ssavitzky/ssavitzky.github.io.git
git remote set-head github master
```

At this point, a simple `git push` will push to the bare repo on my web host,
and `git push github` will push to github.  Eventually I'll set up a hook that
deploys to the staging tree whenever I push to origin.  Maybe.  It remains to
be seen whether I can get Jekyll running there; I may have to test the site on
my laptop.

### Set up Jekyll

Now, this is where it gets a little complicated.  The theme in question,
although we found it in a gallery of Jekyll themes, isn't hosted on GitHub.
It also doesn't have any Jekyll (liquid) templates in it -- one would have to
hack the `index.html` page.

For that matter, it's not entirely clear to me that I _want_ my main site to
be hosted on GitHub.  So another possibility would be to add the template to
my existing site.  Anyway, let's proceed.  If nothing else, I'll get an
article out of it.


