---
title: Building a GitHub Pages website, part 7
layout: post
tags: [ software, blogging, web, jekyll, github, planning ]
---
Wherein we speak of tags, categories, and content.  We also touch briefly on
the general inadequacy of GitHub's implementation of Jekyll, and at greater
length on the need for a build system.

## Progress:

The site is actually beginning to come together.  The "news" category has been
created, so that the home page can show only a limited set of blog entries.
There is a generic include file for blog entry metadata -- in Liquid, include
files take the place of functions -- you can pass parameters to them.  But if
you want to pass the current page (for example) you have to assign it to a
variable first.  Liquid isn't the ugliest programming language I've seen (you
don't want to know--really), but it leans in that direction.

I've also added post navigation in the form of "next" and "previous" links.
Jekyll really is fairly blog-aware.  With one major exception:  tag pages.

## Regress:

One would really like a page for each tag used in one's blog, that lists all
the posts with that tag.  The problem is that Liquid has no way to construct
pages on the fly.  There are apparently some plugins that can do that, but
GitHub doesn't support them.  People have developed three solutions:

* The pure Liquid solution (pun acknowledged) is to generate a page that
  simply lists _all_ posts, grouped by tag.  Not too bad, actually, and with
  this site's current meager set of posts, probably the simplest.
* Manually make a page for each new tag.  It doesn't have to have any actual
  content, just front matter with the layout and the tag name.
* Grovel (that's a technical term -- it's in the Jargon File) over the site
  with a Python or Ruby script, find all the tags, and build the pages on
  the development machine.

There are a couple of other reasons why one might want a proper build system
in the development environment -- it would be useful, for example, for
creating posts.  It's not as if I haven't done that before!

Another reason to have either a build system or some utility scripts would be
to suck over content from other places; e.g. the old site, various other
places where I have relevant documents stashed, and my Dreamwidth post
archive.  (That currently has nearly 13,000 posts in it.  I suspect that
Jekyll would have a hard time handling it, since every tag page will involve
iterating over the entire set to filter by tag.)
