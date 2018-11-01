---
title: Jekyll without GitHub
tags: [ jekyll, site, off-github, make, git ]
layout: post
---

Jekyll works just fine on my laptop.  If I continue hosting this site on my
own web host, I don't have to restrict my Jekyll configuration to what GitHub
gives me -- that opens up the full range of available plugins.  It also means
that I can drag over some content from other places on the server, if I want
to.   Like my resume?  Yeah, that.

## uploading with rsync

So, what does it take to deploy from my laptop?  Not much:  two lines in my
Makefile.

```make
upload: build
	rsync -a _site savitzky.net:vv/web/computer-curmudgeon.com
```

Well, I ought to add the build recipe, too, but that's been in there for a
while.

```make
build:
	JEKYLL_ENV=production $(JEKYLL) build
	if [ ! -d _site/.well-known ] && [ -d .well-known ]; then \
		cp -r .well-known _site;			  \
	fi
```

This is doing two things.  First, it builds the site with the `JEKYLL_ENV`
environment set to "production", which changes a few things in the page
heads.  It also makes sure that the `.well-known` directory is still there,
and copies it from the current directory if it isn't.  It's used for renewing
the site's [Let's Encrypt](https://letsencrypt.org/) certificate, so we really
want to make sure it's there.

Anyway, now I can say `make upload` at the command line and the site will get
rebuilt and uploaded.

There's another way:  do it with git.

### uploading with git

Git is actually a very efficient way of transferring files.  You can even use
it for file-sharing: [SparkleShare](http://www.sparkleshare.org/) uses it to
make what amounts to a private Dropbox clone.  It's also the _only_ way I know
of to get build products onto GitHub.  So let's do that.

First, we need a branch.  We'll call it "prod", build the site again, and this
time add Jekyll's build destination to it.

```bash
git checkout -b prod
make build
git add -f _site
git commit -m "start of prod branch"
git push origin prod
```

We need to use `add -f` because the `_site` directory is in the master
branch's `.gitignore` file; we only have to do that the first time.

Now I can ssh to my web host and set up the website's working tree there:

```bash
cd vv/web/computer-curmudgeon.com/
git fetch origin prod
git checkout prod
```

From there on it's pretty simple, because the branch structure is already set
up.  All I have to do is `git push` on the laptop, and `git pull` on the host.

```bash
git checkout prod
git merge -s recursive -X theirs master
make build
git commit -a -m "prod build `date`"
git push
ssh savitzky.net git -C vv/web/computer-curmudgeon.com pull
git checkout master
```

I probably won't need the `-s recursive -X theirs` options the next time I
merge.  They were needed this time because I forgot to go back to the master
branch before I made changes.  Oops!  (What those options do is avoid
conflicts by simply dropping any local changes.  I can get away with it
because the prod branch is supposed to be _only_ for builds.)

The ssh command is only needed until I install a suitable hook on the server.
You'll note the `-C` option, which changes to the given directory before
running the subcommand.  You'll also notice that you _can_ run a command with
ssh -- you don't have to log in and do things by hand.

The one problem with this scheme is that it leaves your history looking rather
messy, but the master branch still stays clean, and the merges give you a good
record of which changes go with which build.

You might think that you could make things simpler by _rebasing_ the prod
branch rather than merging into it.  You'd be wrong.  I tried that, just once,
and it made things even more of a mess, requiring a `push -f` to get the code
onto the server, and a hard reset instead of a pull to update the prod branch
on the server.  No thanks.  See the section "RECOVERING FROM UPSTREAM REBASE"
in the man page for
[git-rebase](https://mirrors.edge.kernel.org/pub/software/scm/git/docs/git-rebase.html).

