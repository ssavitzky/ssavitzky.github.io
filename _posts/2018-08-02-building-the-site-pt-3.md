---
title: Building a GitHub Pages website, part 3
layout: post
---
**Read-Mostly** Wherein our intrepid programmer begins to get a bad feeling
about this.

So... the way forward appears to be re-building Read-Only as a gem-based
theme.  I'm mostly following the instructions in [Creating Gem Based Themes
For Jekyll |
Chrisanthropic](https://www.chrisanthropic.com/blog/2016/creating-gem-based-themes-for-jekyll/)

The start is easy:

```bash
 jekyll new-theme --safe Read-Mostly-Jekyll-Theme
 cd !$
 git commit -m "initial commit after jekyll new-theme"
 RM=`pwd`
```

I'm going to be flipping back and forth a lot between here and Read-Only, so
I'm making shell variables RM and RO.  Note the upper case.  I don't want to
inadvertantly type `rm` and messs stuff up.


```bash
 cd ../Read-Only-Jekyll-Theme
 RM=`pwd`
```

### I'm wondering...

... whether it's going to be simpler to add to the freshly-created theme, or
take an axe to the old one.  My guess is the latter, actually.  The main thing
you need for a gem-based theme is a gemspec, and that copies over just fine.


### As it turns out...

... neither option gets one anyplace useful.  It's evidently a lot of work
converting an old template into a new one, and minima (the default) appears to
be way different from even the other GitHub Pages themes.  Using it tempts one
to actually _use_ its layouts.
