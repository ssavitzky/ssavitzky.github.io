---
layout: post
---
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

But you also need --user-install, and that says
```(cygnus ssavitzky.github.io 552) gem install --user-install jekyll bundler
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

### Theme

Unfortunately, the theme I want to use isn't a Jekyll theme, and on
investigation it looks like converting it will be a nightmare.  So let's just
copy the design.  Here's what we need:

  * The nav is a large green rectangle on the right-hand side of the screen.
    * it has a large round avatar image at the top, 
	* the page title
	* nav links.  The nav links scroll the main page, but I don't want that --
	  I want separate pages.  That makes it easy.
  * The nav stays put when the page scrolls.  That may cause trouble if I have
	a lot of links -- which I probably will.
  * There is a full-width image at the top of the page.  Looks like its height
	is roughly equal to the nav's width.  I may want to replace that with
	actual text similar to the header on the current
	[https://stephen.savitzky.net](S.S.net) site.
	
#### AHA!

Found it by searching _GitHub_ and finding [mattvh/jekyllthemes: A directory
of the best-looking themes for Jekyll
blogs](https://github.com/mattvh/jekyllthemes).  The corresponding Google
Pages site has 100 _pages_ of thumbnails, so the obvious thing to do was
search the `_posts` directory, which is the _source_ for that gallery.
Bingo: [jekyllthemes/2015-08-20-read-only.markdown at master ·
mattvh/jekyllthemes](https://github.com/mattvh/jekyllthemes/blob/master/_posts/2015-08-20-read-only.markdown),
which points to
[old-jekyll-templates/Read-Only-Jekyll-Theme](https://github.com/old-jekyll-templates/Read-Only-Jekyll-Theme) 
	
The instructions for actually _using_ it are pretty well hidden, but
[benbalter/jekyll-remote-theme: Jekyll plugin for building Jekyll sites with
any GitHub-hosted theme](https://github.com/benbalter/jekyll-remote-theme) 	
appears to be the place for it.  Of course it doesn't work.

There are 50-odd forks.  All of them appear tothave simply built a blog on top
of it.  Most are ancient.
[LiberLibrum/LiberLibrum.github.io](https://github.com/LiberLibrum/LiberLibrum.github.io)
has a working site, but my guess is that it's using an older version of Jekyll
(styles in /sass rather than _sass).  The only layouts are post and
landing-page, and the styles are in `/sass` instead of `/_sass`.  Only way to
salvage it is to fork it and take an axe to it.  Real hackers use an axe.

