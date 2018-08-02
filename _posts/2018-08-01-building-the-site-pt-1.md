---
layout: post
title: Building a GitHub Pages website, part 1
---

## Step by step

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

```bash
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
my laptop.  (Testing locally is trivial:  `bundle exec jekyll serve`.

### Set up Jekyll

Now, this is where it gets a little complicated.  The theme in question,
although we found it in a gallery of Jekyll themes, isn't hosted on GitHub.
It also doesn't have any Jekyll (liquid) templates in it -- one might have to
hack the `index.html` page into layouts.  So it's not really a Jekyll theme at
all; just some CSS and javascript code that one could, presumably, use on a
Jekyll site.

For that matter, it's not entirely clear to me that I _want_ my main site to
be hosted on GitHub, so another possibility would be to add the template to my
existing site.  It's really tempting to track down a command-line
[Liquid](https://shopify.github.io/liquid/) 
template expander and incorporate it into
[MakeStuff](https://github.com/ssavitzky/MakeStuff).  One consideration that
may be the deciding factor is that my current site includes my resume.  Of
course, I could build that offline.

Anyway, let's proceed.  If nothing else, I'll get an article
out of it.

In any case, there's a _lot_ of undocumented stuff involved in setting up a
Ruby development directory.  The quick-start guide says:

```bash
gem install jekyll bundler
```

But you also need `--user-install`, and that says

```bash
gem install --user-install jekyll bundler
WARNING:  You don't have /home/steve/.gem/ruby/2.5.0/bin in your PATH,
	  gem executables will not run.
```

By the way there's a gem called github-pages that's supposed to install the
complete environment and keep it in sync with GitHub.  It doesn't work
either.  So...

```bash
gem install --user-install jekyll bundler
bundle exec jekyll new --force --user-install .
bundle install --path vendor/bundle
bundle exec jekyll serve
```

At that point, you have a working (though empty) Jekyll site.

### Adding Content

Making the pages I've already written (about-me, hire-me, and this article)
show up in the navigation is mainly a matter of giving them YAML frontmatter.
