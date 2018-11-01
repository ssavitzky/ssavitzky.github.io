---
title: Further Adventures in Hyperspace
tags: [ javascript, hyperviewer, 4-d, math, programming, strong-typing ]
layout: post
---

You may remember from [my previous post about
Hyperviewer](2018-10-08-adventures-in-hyperspace.md) that I'd been plagued by
a mysterious bug.  The _second_ time the program tried to make a simplex (the
N-dimensional version of a triangle (N=2) or tetrahedron (N=3), a whole batch
of "ghost edges" appeared and the program (quite understandably) blew up.  I
didn't realize it until somewhat later, but there were ghost _vertices_ as
well, and that was somewhat more fundamental.  Basically, `nVertices`, the
field that holds the number of vertices in the polytope, was wildly wrong.

## Chasing ghosts

Eventually I narrowed things down to someplace around here, which is where
things stood at the end of the previous post.

```javascript
	let vertices = [];
	/* something goes massively wrong, right here. */
	for (let i = 0; i < dim; ++i) {
	    vertices.push(new vector(dim).fill((j) => i === j? 1.0 : 0));
	}
```

I found this by throwing an error, with a big data dump, right in the middle
if `nVertices` was wrong (it's supposed to be `dim+`), or if the length of the
list of vertices was different from `nVertices`.

```javascript
	let vertices = [];
	/* something goes massively wrong, right here. */
	if (this.nVertices !== (dim + 1) || this.nEdges !== ((dim + 1) * dim / 2) ||
	    this.vertices.length !== 0 || this.edges.length !== 0 ) {
	    throw new Error("nEdges = " + this.nEdges + " want " +  ((dim + 1) * dim / 2) +
			    "; nVertices = " + this.nVertices + " want " + dim +
			    "; vertices.length = " + this.vertices.length +
			    ' at this point in the initialization, where dim = ' + dim +
			    " in " + this.dimensions + '-D ' + this.name 
			   );
	} 
	for (let i = 0; i < dim; ++i) {
```

It appeared that `nVertices` was wildly wrong at that point.  If I'd looked
carefully and thought about what `nVertices` actually _was_, I would probably
have found the bug at that point.  Or even earlier.  Instead, what clinched it
was this:

```javascript
	this.vertices = vertices;
	this.nVertices = vertices.length;  // setting this to dim+1 FAILS:
	// in other words, this.nVertices is getting changed between these two statements!
	if (this.vertices.length !== this.nVertices || this.edges.length !== 0) {
	    throw new Error("expect " + this.nVertices + " verts, have " + this.vertices.length +
			    " in " + this.dimensions + '-D ' + this.name +
			    "; want " + this.nEdges + " edges into " + this.edges.length
			   );
	}
```

The code that creates the list of vertices produces the right number of
vertices.  If I set `nVertices` equal to the length of that list, everything
was fine.

If instead I set

```javascript
	this.nVertices = dim+1;
```

it was wrong.  Huh?  For example, in four dimensions, the number of vertices
is supposed to be five, and that was the length of the list.  When is `4+1`
not equal to `5`?

At this point a light bulb went off, because it was clear that `dim+1` was
coming out equal to 41.  In three dimensions it was 21.  When is `4+1` not
equal to 5?  When it's actually `"4"+1`.  In other words, `dim` was a string.
JavaScript "helpfully" converts a string to a number when you do anything
arithmetical to it, like multiply it by something or raise it to a power.  But
`+` isn't always an arithmetic operation!  In JavaScript (and many other
languages) it's also used for _string concatenation_.

## What went wrong, and a rant

The problem was that, the _second_ time I tried to create a simplex, the
number of dimensions was coming from the user interface.  From an `<input`
element in a web form.  And every value that you get from a web form is a
string.  HTML knows nothing about numbers, and it has no way to know what
you're going to do with the input you get.

So the fix was simple (and you can see it [here on
GitHub](https://github.com/ssavitzky/hyperviewer/commit/8bef087648d403a9ba432058fc4641e582b27250):
convert the value from a string to a number right off before trying to use it
as a number of dimensions.  But... But...  But cubes and octohedrons were
_right!_

That's because the number of vertices in a N-cube is `2**N`, and in an
N-orthoplex (octohedron in three dimensions) it's `N*2` (and multiplication is
always an arithmetic operator in JavaScript).  And it worked when I
was creating the simplex's vertices because it was being compared against in a
`for` loop.  And so on.

**If I'd been using a strongly-typed language, the compiler would have found
this two weeks ago.**

There are two main ways of dealing with data in a programming language, called
"strong typing" and "dynamic typing".  In a strongly-typed language, both
values and variables (the boxes you put values into) have types (like "string"
or "integer"), and the types have to match.  You can't put a string into a
variable with a type of integer.  Java is like that (mostly).

Some people find this burdensome, and they prefer dynamically-typed languages
like JavaScript.  In JavaScript, _values_ have types, but variables don't.
It's called "dynamic" typing because a variable can hold anything, and its
type is that of the last thing that was put into it.

You can write code very quickly in a language where you don't have to declare
your variables and make sure they're the right type for the kind of values you
want to put into them.  You can also shoot yourself in the foot much more
easily. 

There are a couple of strongly-typed variants on JavaScript, for example
CoffeeScript and TypeScript, and a type-checker called "Flow".  I'm going to
try one of those next.

## There was one more problem with simplexes

(simplices?) ... but that was purely geometrical, and just because I was
trying to do all the geometry in my head instead of on paper, and wasn't
thinking things through.

If you're in N dimensions, you can create an N-1 dimensional simplex by simply
connecting the points with coordinates like `[1,0,0]`, `[0,1,0]`, and
`[0,0,1]` (in three dimensions -- it's pretty easy to see that that gives you
an equilateral triangle).  Moreover, all the vertices are on the unit sphere,
which is where we want them.  The last vertex is a bit of a problem.

A fair amount of googling around (or DuckDuckGoing around, in my case) will
eventually turn up [this answer on
mathoverflow.net](mathoverflow.net/questions/38724/coordinates-of-vertices-of-regular-simplex),
which says that in N dimensions, the last vertex has to be at `[x,...,x]`
where `x=-1/(1+sqrt(1+N))`.  Cool!  And it works.  Except that it's not
centered -- that last vertex is a lot closer to the origin than the others.
It took me longer than it should have to get this right, but the center of the
simplex is its "center of mass", which is simply the average of all the
vertices.  So that's at `y=(1+x)/(N+1)` because there are N+1 vertices.  Now
we just have to subtract y from all the coordinates to shift it over until the
center is at the origin.

Then of course we have to scale it so that all the vertices are back on the
unit sphere.  You can find the code [here, on
GitHub](https://github.com/ssavitzky/hyperviewer/blob/794f406d8de7af4dd55ded5f21d46237bf76a5bd/src/polytopes.js#L128-L140).



