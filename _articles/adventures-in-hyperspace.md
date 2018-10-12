---
title: Adventures in hyperspace (and JavaScript)
tags: [ javascript, hyperviewer, 4-d, math, programming, development ]
date: 2018-10-08
---

This post is about [Hyperviewer](http://github.com/ssavitzky/hyperviewer), an
update of a [very old demo program of
mine](https://github.com/ssavitzky/ncube/) from 1988 that displays wireframe
objects rotating in hyperspace.  (Actually, anywhere between four and six
dimensions.)  Since this is 2018, I naturally decided to write it in
JavaScript, using [Inferno](https://infernojs.org/) and
[SVG](https://developer.mozilla.org/en-US/docs/Web/SVG), and put it on the
web.  It was a learning experience, in more ways than one.

## Getting started

I had been doing a little work with [React](https://reactjs.org/), which is
pretty good and very popular, and had recently read about
[Inferno](https://infernojs.org/), which is a lighter-weight, faster framework
that's almost completely interchangeable with React.  Sounded good, especially
since I wanted high performance for something that's going to be doing
thousands of floating-point matrix multiplies per second.  (A hypercube in N
dimensions has 2^N vertices, and a rotation matrix has N^2 entries -- do the
math).  (It turns out I really didn't have to worry -- Moore's Law over three
decades gives a speedup by a factor of a million, give or take a few orders of
magnitude, so even using an partially-interpreted language speed isn't a
problem.  Perhaps I'm showing my age.) 

To keep things simple -- and make it possible to eventually save pictures -- I
decided to use SVG: the web standard for [Scalable Vector
Graphics](https://developer.mozilla.org/en-US/docs/Web/SVG), rather than
trying to draw them out using an HTML5
[Canvas](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API) tag.
It's a perfect match for something that's nothing but a bunch of vectors.  SVG
is XML-based, and you can simply drop it into the middle of an HTML page.  SVG
is also <em>really</em> easy to generate using the new JSX format, which is
basically XML tags embedded in a JavaScript file.

Modern JavaScript uses a program called a "transpiler" -- the most common one
is [Babel](https://babeljs.io/) -- that compiles shiny new JavaScript
constructs (and even some new languages like TypeScript and CoffeeScript,
which I want to learn soon) into the kind of plain old JavaScript that almost
any browser can understand.  (There are still some people using Microsoft
Exploiter from the turn of the ~~century~~ _millennium_; if you're reading
this blog it's safe for me to assume that you aren't one of them.)

Anyway, let's get started:

```bash
npx run create-inferno-app hyperviewer
cd hyperviewer
git init
git add .
git commit -m "hyperviewer - initial commit" \
           -m 'Project created with create-inferno-app'
npm start &
firefox http://localhost:3000/ &

```

Congratulations -- you are now looking at the Inferno equivalent of "Hello
World."  Total time a couple of minutes to download all the pieces.

JavaScript is a general-purpose programming language, in spite of the fact
that it was originally designed (sort of) for use in browsers, and you can use
it on your desktop thanks to a program called
`[node.js](https://nodejs.org/en/)`.  It has an easy-to-use package manager
called `[npm](https://www.npmjs.com/)`, that makes it so easy to publish a
package that over 800,000 people have done it.  That's a _really big haystack_
to look through if all you need is a needle.  I mostly rely on blog posts and
reviews. 

That first command, `[npx](https://www.npmjs.com/package/npx)`, goes out to
the npm package repository, finds a package, downloads it, downloads
_everything that it depends on_, and runs it.  Slick.  NPM, like other package
managers including the ones behind Linux distributions like Debian and Ubuntu,
keeps track of dependencies _and all of their version history_, so once you
get something working anyone else can download it, fire it up, and be certain
that they're using the same code that you were.

The git part of it you probably already know, and if you don't -- and don't
want to wait for my future post on it -- you can get the details
[here](https://git-scm.com/).  The only trick that might be of interest there
is that you can add additional lines to your commit message by using
additional `-m` options.  The `npm start`  finds the start-up script that was
downloaded with the package, and runs it to start a web server.  The ampersand
at the end of that line puts it into the background so that you can keep
typing commands at your shell.  You want to do that with your browser, too.

The next thing you want to do is type 

```bash
npm test
```
preferably in a different terminal window.  That looks in your project's source
directory (sensibly called `src`) for files called `foo.test.js` -- the
convention is for that to contain the tests for `foo.js`.  When you get
started there's only one, called `App.test.js`, which tests your web app.
When you start, it just looks like:

```javascript
import { render } from 'inferno';
import App from './App';

it('renders without crashing', () => {
  const div = document.createElement('div');
  render(<App />, div);
});
```

I like the format, by the way.  The `it` function is defined in the test
runner, and it's designed to make it easy to read a test and see at a glance
what it's testing.  Later you can add things like

```javascript
it('makes cubes with the right number of vertices and edges', () => {
    for (let dim = 2; dim < 6; ++dim) {
		let theCube = new cube(dim);
		expect(theCube.dimension).toBe(dim);
		expect(theCube.nVertices).toBe(1<<dim);
		expect(theCube.vertices.length).toBe(1 << dim);
		expect(theCube.edges.length).toBe(theCube.nEdges);
    }
});
```

Both `npm test` and `npm start` watch your files and run again if you change
anything.  For this project I decided to use testing from the beginning;
whenever something didn't work or I wasn't completely sure about whether it
would work, I wrote a test.  _Real_ test-driven development has you writing
the tests _first_.  I mostly didn't do that.

## Moving into hyperspace

There are four main components to this app:  `App.js`, which displays things,
`polytopes.js`, which makes the shapes, `transforms.js`, which does the
rotation and perspective transforms, and `transform-stack.js`, which lets you
stack up a series of transforms and apply them in sequence to the vertices of
your polytopes.  I made two major simplifying decisions that got me off the
ground quickly:

1. To do the perspective transform "by hand" as a function rather than try to
   figure out how to do it with projective geometry and homogeneous
   coordinates.  That was a fun little exercise in trigonometry that ended up
   working a lot better than the original had.
2. To use a package called [scijs](https://github.com/scijs), which implements
   n-dimensional arrays for use as matrices and vectors.  It got me going,
   then turned around and bit me four days later.
   
Anyway, I started last Monday evening, and by late Tuesday night I was able to
write 

```
commit 69be375101d32074485d77c904c6f7ce3dcbf4dd
Author: Steve Savitzky <steve@savitzky.net>
Date:   Tue Oct 2 22:04:48 2018 -0700

    Things are mostly working in the display pathway.
    
    * there are no controls yet
    * rotationStates aren't updated (no timer events)
    * the perspective transform is broken.
```

"No controls" meant that the only way I had of changing any parameters was to
edit the code, but since node was watching I was able to make quite a lot of
progress.   By Thursday I had rotation and perspective working, and sliders to
control dimensionality and shape.

## Then things started to unravel

There were two glitches.  One was that whenever I tried to switch the shape to
a simplex (triangle in two dimensions, tetrahedron in three), the program
crashed.  I didn't mind too much because I didn't have the locations of the
vertices in the right places, and I figured I could handle it later.  The more
serious one was that it didn't work at all when I did a production build and
tried to load the resulting page in my browser.  The HTML worked fine, but no
edges showed up in the SVG.  But... but... _it passes all the tests_.  One of
the classic excuses that doesn't really get you off the hook is "It works on
_my_ machine."

I worked on both problems most of Saturday, and by Saturday afternoon I had
figured out that matrix multiplication _simply wasn't working_ in the
production build.  I did some research, and eventually got around to looking
at [the list of issues](https://github.com/scijs/ndarray/issues) on GitHub.
And found [this](https://github.com/scijs/ndarray/issues/11):

> String concatentation to build up functions is very awkward.

They're _writing functions on the fly, at run time,_ to make them as efficient
as possible.  It's not quite self-modifying code, but it's close, and it
sounds like the kind of thing a modern browser would want to keep a web page
-- which can come from _anywhere_ -- from getting away with.  In development
mode apparently node and Firefox (and Chrome -- I tried both of them) _does_
let you get away with it; but the production build is applying some kind of
optimization, or sandboxing, or something.

And that issue has been around since 2014.  Okay, I can fix this.  It only
took me a couple of hours, and by bed-time Saturday I had my own shiny set of
matrix and vector classes, plus a compatibility layer so that I could
transition my code gradually.

That left the glitch with simplexes.  Simplices?  It seemed that the _second_
time the program tried to make one, it ended up with a whole bunch of "ghost
edges".  Something like 42, for four dimensions, instead of 10.  It was
consistent, too, and _it was happening between two statements that couldn't
possibly not work_.  Something in my code -- I don't think I can blame a
library package for this one -- is walking off the end of some array (which I
didn't think was possible in JavaScript) and clobbering my simplex.

I'll work on it later.  For now, the patch was to make all the polytopes I'm
going to need up front, before the program starts.  That will have some
advantages later this week, when I put in a drop-down selection box to pick
the shape.  But sometime I'm going to have to track the bug down and stomp on
it.  I'm guessing it has to do with something in the `transform-stack` that
isn't thread-safe.  That means it can't safely do two things at once.

## Behind the scenes

If you're still with me, let's go behind the scenes and look at how Inferno
and React get their speed.

When your browser gets a web page, the first thing it does is convert it to a
massive collection of objects called a DOM, which stands for Domain Object
Model.  It's kind of a nightmare -- and I've [implemented
it](https://github.com/ssavitzky/pia-server/tree/master/src/java/org/risource/dps/tree),
so I know -- because it's trying to provide all the functionality a programmer
might want.  That makes it slow.

What Inferno et. al. do is have your program create a _virtual DOM_ that just
has the minimum it needs to be built in a single pass, with each component
building its own little piece and passing it up to the next higher level
component to splice together and wrap up.  This process is called "rendering".
What the behind-the-scenes Inferno "run-time" does is tell your top-level
component -- called App -- to render itself; it then calls _its_ components to
do the same.

It's basically functional programming (I'll get to that in a later post, I
promise!  (Please ignore the fact that promises are a feature recently added
to JavaScript.))  You don't have to do it exactly this way, but the _right_
way is to have your higher-level components -- ideally the top one -- have all
of the program's state.  Then pieces of the state get passed down to the
lower-level components, which are pure functions.  Pure functions have no side
effects; they always return the same output given the same inputs.

Anyway, your program builds a virtual DOM.  React then _compares it to the
real DOM_, and does the minimum amount of work required to go from what's
already there to what you asked for.

When something like the user interface or a timer wants to change the
program's state (like changing the dimensionality or performing the next
incremental rotation), it doesn't just reach in and change it directly by
calling methods on the object that holds the state.  Instead, it tells
_Inferno_ to change it, by calling a method called setState, that's
implemented on the Component class that all stateful components are subclasses
of.  If the state is something simple like the time, you just pass `setState`
the new value and Inferno will change it and then immediately tell the class
in question to re-render itself.

If you have a state with lots of pieces, like rotation matrices and polytopes,
you pass `setState` a _function_ that takes the old state, _copies it_ with
your changes, and returns the new state.  And it's _Inferno_ that calls this
function, so that it can tell your component to re-render immediately
afterward.  It's all very clean and efficient, and works beautifully, as long
as nothing gets changed except by calling `setState`, and _that_ doesn't
actually _change_ the state.  It just _replaces_ it with a completely new
one.  States are always supposed to be immutable.

Functional languages use pure functions and immutable objects; it means that
you don't have to worry about locking things to keep other processes from
changing them.  I strongly suspect that somewhere, probably in
`transform-stack`, I'm cheating in an effort to be more efficient.  See
Moore's Law.

I'll work on it later this week.
