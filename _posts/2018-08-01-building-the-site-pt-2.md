---
title: Building a GitHub Pages website, part 2
layout: post
---
## ... and one step back

### Theme

Unfortunately, the theme I want to use, [HTML5 UP's Read
Only](https://html5up.net/read-only), isn't a Jekyll theme, and on
investigation it looks like converting it will be a nightmare.  So let's just
copy the design.  Here's what we need:

  * The nav is a large green rectangle on the right-hand side of the screen.
    * it has a large round avatar image at the top, 
	* the page title
	* nav links.  The nav links scroll the main page, but I don't want that --
	  I want separate pages.  That makes it easy.
  * The nav stays put when the page scrolls.  That may cause trouble if I have
	a lot of links -- which I probably will.
  * The nav has a different presentation for active links.  Marking links
	active can probably be done in the appropriate template rather than using
	JS. 
  * I want a top nav, too.  It should start out under the image, but stick at
	the top of the page as it scrolls down.
  * There is a full-width image at the top of the page.  Looks like its height
	is roughly equal to the nav's width.  I may want to replace that with
	actual text similar to the header on the current
	[https://stephen.savitzky.net](S.S.net) site.
	
#### AHA!

Found it by searching _GitHub_ and finding [mattvh/jekyllthemes: A directory
of the best-looking themes for Jekyll
blogs](https://github.com/mattvh/jekyllthemes).  The corresponding Google
Pages site has 100 _pages_ of thumbnails, so the (eventually) obvious thing to
do was search the `_posts` directory, which is the _source_ for that gallery.
Bingo: [jekyllthemes/2015-08-20-read-only.markdown at master ·
mattvh/jekyllthemes](https://github.com/mattvh/jekyllthemes/blob/master/_posts/2015-08-20-read-only.markdown),
which points to
[old-jekyll-templates/Read-Only-Jekyll-Theme](https://github.com/old-jekyll-templates/Read-Only-Jekyll-Theme)
	
The instructions for actually _using_ it are pretty well hidden, but
[benbalter/jekyll-remote-theme: Jekyll plugin for building Jekyll sites with
any GitHub-hosted theme](https://github.com/benbalter/jekyll-remote-theme) 	
appears to be the place for it.  Of course it doesn't work.

There are 50-odd forks.  All of them appear to have simply built a blog on top
of it.  Most are ancient.
[LiberLibrum/LiberLibrum.github.io](https://github.com/LiberLibrum/LiberLibrum.github.io)
has a working site, but my guess is that it's using an older version of Jekyll
(styles in /sass rather than _sass).  The only layouts are post and
landing-page, and the styles are in `/sass` instead of `/_sass`.  Only way to
salvage it is to fork it and take an axe to it.  Real hackers use an axe.

#### Ugh

I did some further experimentation; not all of the standard gem themes have a
"page" layout!  Flipping between themes seems to be something you can only do
reliably if all you have is a blog.  In particular,
[Minimal](https://github.com/pages-themes/minimal), which has a logo on the
side so it looks easy to modify, does not.  (The only layouts are default and
post.  Doesn't even have home.  Many of the others only have default.)

### However...

Alternatively, I might just say "inspired by" and fake it.  How hard can it be to
style a green rectangle?  (Famous last words?)  The _right_ thing is, almost
certainly, to clone (e.g.) Minima or Minimal, and hack it.  Or Read-Only,
since the CSS in that thing is complicated.

For reference, though, here's the css that makes the round avatar:

```scss
		&.avatar {
			border-radius: 100%;
			overflow: hidden;
			
			img {
				border-radius: 100%;
				display: block;
				width: 100%;
			}
		}
```

