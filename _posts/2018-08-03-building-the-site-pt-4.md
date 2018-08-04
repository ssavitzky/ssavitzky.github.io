---
title: Building a GitHub Pages website, part 4
layout: post
---
### Overriding a theme

It turns out that if you follow these instructions in the `Gemfile`
Pages, it sucks in _all_ of the Pages-specific themes.

```ruby# 
If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
gem "github-pages", group: :jekyll_plugins

```

... so you can play some mix-and-match games.  I also noticed that you can
chain layouts.  In particular, `minima`'s home, page, and post layouts all
chain off of `default`.  So let's copy some:

```bash
minima=vendor/bundle/ruby/2.5.0/gems/minima-2.5.0/
minimal=vendor/bundle/ruby/2.5.0/gems/jekyll-theme-minimal-0.1.1/
cp $minimal/_layouts/* _layouts
cp $minima/_layouts/{home,page}.html _layouts
```

Minima's `post` layout fails because it tries to override the header -- that
results in the page title sitting on top of the content.  So go back to
minimal for that one (for now).

### Hacking in style

The next problem is moving the sidebar over to the right, and making it a bit
narrower.  That requires looking at some SCSS code.  Let's go over to
[pages-themes/minimal](https://github.com/pages-themes/minimal) and look at
the instructions.  Under the Stylesheet heading we find out how to add custom
styles, by creating `/assets/css/style.scss` and inporting the theme style.

... and of course it doesn't work.  It simply isn't overriding things that
have already been set.  Heck with it.  We're going to simply copy _all_ of
Minima (which seems to be the best of a bad lot), rename it so that this
eventually might become a theme, and add a sidebar.  Leave the topnav but make
it extend only over the content, under the banner, and stick at the top of the
page when we scroll.

```
cd ..; git clone git@github.com:jekyll/minima.git
cd savitzky.github.io
cp -r ../minima/{_includes,_layouts,_sass,assets,LICENSE.txt} .

```

_That_ works fine.  When the time comes to make a theme out of it, we can
clone minima again (to get the history), rename the origin remote to upstream
(to get updates), make a patch set for the changes we're making to the
directories we've copied, and we'll be good to go.

### Frustration

It doesn't help that I'm still learning my around CSS and SASS (which compiles
into CSS).  It _didn't_ help that bugs involving missing punctuation (dollar signs,
semicolons, etc.) and misplaced prefixes (`sb-` prefixing sidebar variables)
are hard to find.

It also didn't help one bit that I didn't realize that the browser was caching
style sheets, so _of course_ many of the changes I made while experimenting
didn't seem to make any difference.  :P

Turns out there's a clever workaround:  append a question mark and time stamp
to the stylesheet's URL.  In this site's `_includes/head.html` it looks like:

{% raw %}
```html
  <!-- timestamp tricks the browser into reloading scss on every refresh -->
  <link rel="stylesheet" 
        href="{{ "/assets/main.css" | relative_url 
              }}?{{ site.time | date: "%Y-%m-%dt%H:%M" }}">
```
{% endraw %}

As for the CSS, I finally managed to cobble up something that almost worked,
but it's going to require more work tomorrow.
