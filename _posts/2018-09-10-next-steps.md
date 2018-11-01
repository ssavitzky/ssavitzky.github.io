---
title: Next steps
tags: [ planning, meta, curmudgeon, dev ]
layout: post
---

It's time to figure out what to do next, in particular about
[ssavitzky.github.io](https://ssavitzky.github.io/) (ss.g.io for short) and
[computer-curmudgeon.com](https://computer-curmudgeon.com) (c-c.com).  Right
now they are simply mirroring one another; it's time to differentiate them, so
that Curmudgeon is about my (incipient) consulting business, and the GitHub
site is about software development.  Some provision also has to be made for my
"resume" site, [Stephen.Savitzky.net](https://Stephen.Savitzky.net) (S.S.net
-- the capital letters distinguish it from my "personal" site,
[steve.savitzky.net](https://steve.savitzky.net)).  This post is me thinking
out loud about what to do about that.

### Factors to consider

* Any project pages on GitHub are going to appear as subdirectories of
  ss.g.io.  That suggests using ss.g.io to tie all of my projects together.
  The blog there should be about software development, possibly including
  stream-of-consciousness stuff like this and the "building the site" series. 
  
* The blog at c-c.com should be focused on the business, which includes more
  instructive posts like the ones tagged "curmudgeon" over on Dreamwidth.
  
* The Makefile and theme are duplicated.  The theme should go into a separate
  stand-alone theme package, and the common parts of the Makefile should go
  into [MakeStuff/blogging](https://github.com/ssavitzky/MakeStuff/blogging/),
  with the site-specific stuff in `.config.make`.
  
* It really isn't clear what to do with actual "articles" (like the
  programming languages series).  It's tempting to put them into a separate
  repo, and simply _reference_ them from the blog(s), although that might make
  it harder to keep separate categories.  Another possibility is simply
  cross-posting, taking advantage of the current trend toward putting almost
  everything into blog form.  Not sure I like that, though.

### Things to do

(These will probably get re-arranged at some point.)

* Move the common parts of the Makefiles into
  [MakeStuff/blogging](https://github.com/ssavitzky/MakeStuff/blogging/).
  That's trivial.  Make it into a post.
  
* Split out the theme.  Call it ReadMostly.  (Blog that process, too.)  At
  that point, it will be easier to let the two sites' git histories diverge.

* Split the blog posts, and figure out how to crosspost among Jekyll and DW
  blogs.  It might be hard to keep things in sync.  At some point it would
  really be useful to make a combined blog archive.
  
* Collect the articles, rewriting as necessary (including new titles for
  some).  Figure out where they go -- it's obviously a separate repo, and may
  very well want to be a MakeStuff site.
  
Note that this list does not include marketing stuff for the business.  That
has to get done ASAP (with new posts on c-c.com), so it would be good to put
after the blog post split.
