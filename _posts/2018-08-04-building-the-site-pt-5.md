---
title: Building a GitHub Pages website, part 5
layout: post
---

Wherein our intrepid programmer gets a nice feeling of accomplishment.  There
is a sidebar, and he explains how to make one of your own.  Sort of.

### CSS notes

[Learn web development |
MDN](https://developer.mozilla.org/en-US/docs/Learn/CSS) is an excellent
resource. 

It looks like I want to do something like the following:

* Outer container to limit the width on large monitors.
* A pair of column containers for the scrollable body and the sidebar.
* The sidebar has a fixed width.
* The topnav bar has sticky positioning so that it will stay on top once the
  banner has scrolled off.
* The sidebar nav is separate from the logo, and also gets sticky
  positioning. 
  

### At this point

The gross layout is working; the sidebar logo and layout hasn't been done yet
but I don't expect it to be difficult.  Logic to identify the active nav link
for special styling would be nice.

The main part of the CSS looks like:

```sass
/**
 * Overall layout with sidebar and main column.
 */

body {
    align-items: center;
}

.outer-box {
    min-height: 100%;
    align: center;
    display: flex;
    flex-direction: row;
    max-width: 960px;
    width: 100%;
    border: 2px solid green;
}

.content-column {
    width: 100%;
    display: flex;
    flex-direction: column;
}

.sidebar-column {
    display: flex;
    flex-direction: column;
    width: $sb-width;
    float: right;
}

/**
 * Site header
 */
.site-header {
  border-top: 1px solid $grey-color-dark;
  border-bottom: 1px solid $grey-color-light;
  min-height: $spacing-unit * 1.865;
  z-index: 2;
  position: sticky;
  top: 0px;
  // if we don't set a background color it ends up transparent!
  background-color: $background-color;
}

/**
 * Sidebar
 */
.sidebar {
  border-top: 1px solid $grey-color-dark;
  border-bottom: 1px solid $grey-color-light;
  height: 100%;
  background-color: $sb-background-color;
  color: $sb-text-color;
  text-align: center;
  display: block;
  flex-direction: column;
}
```
