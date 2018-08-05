---
title: Building a GitHub Pages website, part 5
layout: post
---

### CSS notes

[Learn web development |
MDN](https://developer.mozilla.org/en-US/docs/Learn/CSS) is an excellent
resource. 

It looks like I want to do something like the following:

* Outer container with `display: flex;` and
  `flex-direction: row;`.  It will have a maximum width (in em) to keep it
  from sprawling all across the screen on large monitors, and a minimum width
  that is probably three times the sidebar width.
* A pair of column containers for the scrollable body and the sidebar.
* The sidebar has a fixed width (in em).
* The topnav bar has sticky positioning so that it will stay on top once the
  banner has scrolled off.
* The sidebar nav is separate from the logo, and also gets sticky
  positioning. 
  
