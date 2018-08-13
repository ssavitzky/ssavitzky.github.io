---
title: Building a GitHub Pages website, part 6
layout: post
tags: [ software, blogging, web, jekyll, github ]
---
Wherein our intrepid blogger reflects on the current state of the site.
At this point, things are pretty much the way he wants them.

- There's space for a fixed-size banner (with height equal to the sidebar's
  width) on the home page, and a (presumably shorter) banner elsewhere.  These
  ought to be includes instead of trying to cons them up from strings in the
  metadata, but still...
- The top nav bar is sticky, so that it starts out under the header, but when
  you scroll down it stops at the top of the page.  So is the sidebar nav
  area, which starts out under the avatar/logo area.
- I've tested the site with [osteele/gojekyll: A fast clone of the Jekyll
  blogging engine, in Go](https://github.com/osteele/gojekyll).  Close, but no
  cigar -- it doesn't do syntax coloring, at least not in a compatible way,
  and doesn't sort blog pages if they're on the same day.  There is, however,
  a [Liquid template engine in Go](https://github.com/osteele/liquid) that
  goes with it, which I will be able to use in
  [MakeSuff](https://github.com/ssavitzky/MakeStuff).  I need to write up how
  that works, sometime.

There is, of course still a fair amount left to do:

- Make include files for the page headers and the sidebar.
- Make the layout reactive.  The top nav is, but the sidebar doesn't work the
  way it should yet -- I want it to slide over to the right, leaving a stripe
  that you can click to slide it back out.
- Finish getting the CSS right -- things like making the nav and sidebar links
  show up differently for the page you're on.
- Make collections for writing and software projects.
- Decide whether this is to become my main page, and if so...
- Pull over the rest of the content from
  [Stephen.Savitzky.net](https://stephen.savitzky.net).  I'll probably do it
  with `git subtree`.
- Change DNS for S.S.net to point at it.

Further down the pike,

- Turn the guts of this into a Jekyll theme.  It will be a little complicated
  because the changes I've made will need to be rebased on top of Minima.
  Fortunately I'm a `git` expert.  I can teach _you_ how to do it, too.
- Add blog posts from my Dreamwidth blog.  That will want a script.
- Rewrite some of those as articles.
- Add blog navigation and archives.  There's a gem for the archives, at least,
  but at this point I don't know whether it's whitelisted on GitHub.
