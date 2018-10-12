---
title: Why Singly-Linked Lists Win
tags: [ programming, lisp, java, articles ]
date: 2018-09-19
---

Singly-linked lists, like the ones found in Lisp, have a lot of advantages.
But first, let's back up a little and start with doubly-linked lists, of the
sort that one finds in Java and most other object-oriented languages.

## Double, Double, Toil and Trouble

A doubly-linked list is a collection of "List Elements" that look
something like this:

    class Element<T> {
          T       value;
          Element next;
          Element previous;
    }

You never actually *see* list elements. Lists are always accessed
through a `LinkedList` object, which implements the `List` interface,
and has a lot of methods on it, including `getFirst`, `getLast`,
`addFirst`, and `addLast`.

In order to operate on the first and last elements of the list, the
LinkedList object has to contain a *list head* which is itself an
element. That means that the list head's `next` field is pointing at the
first element of the list, and in turn is pointed at by that element's
`previous` field. And of course, the list head's `previous` field points
to the *last* element in the list, which in turn has its `next` field
pointing back at the head. All very symmetrical.

So a doubly-linked list is actually a ring -- you can follow pointers
all the way around and back again. This symmetry is what makes
operations like `getLast` and `addLast` efficient, but it comes at a
terrible cost.

-   An element can only belong to one list. That may not seem like a
    problem now, but bear with me.
-   Adding an element anywhere in the list requires modifying the `next`
    and `previous` fields of the elements on either side of the
    insertion point, as well as storing into the element being added.
    Removing an element also requires modifying the next and previous
    elements.
-   Because the element objects are hidden, a program can't simply
    follow links: in order to traverse a list it has to request an
    *Iterator* from the list.
-   Finally, and somewhat subtly, a `LinkedList` object isn't an
    `Element`. You can't get at the elements directly.

It gets worse, because these facts have *consequences:*

-   Lists aren't thread-safe. If two threads were to try to modify a
    list at the same time, there would be a strong chance of the
    elements' pointers getting into an inconsistent state. So locking is
    necessary.
-   Lists are inherently mutable. Unless you're very careful not to
    change them, you can't use them as keys in a hash table, or put them
    into a `HashSet`, because adding or deleting an element would change
    the list's hash code, and it would no longer be in the right place.
    And Java doesn't even attempt to help you be careful.
-   If you made yourself an immutable version of a linked list, the only
    way you could add to it would be by copying the whole list.
-   The way you test to see if a list is empty is to either keep track
    of the number of elements in it, or compare the `next` and
    `previous` elements of the list head. In both cases, you have to
    call the `isEmpty()` method on the list.
-   In fact, the only way you can do *any* operation on a `LinkedList` is
    indirectly, by asking the `LinkedList` to do it.
-   If you have a list, there's no good way to separately refer to the first
    element (head) and the rest of the list (tail).  That absolutely *kills*
    the ability to do recursion, by doing something to the head and calling
    yourself recursively on the tail. (You can do it by defining slices, but
    those won't behave exactly like lists.)

Why Singly-Linked Lists Win
---------------------------

In contrast, a singly-linked list is simplicity itself:

    class List<T> {
          final T first;
          final List<T> rest;
          List(T first, List<T> rest) {
              this.first = first;
              this.rest = rest;
          }
    }

That's it. The whole thing. No separate, hidden `Element` object. No
list head. What you see is what you get. And *you can't change it.*

> Brief digression: in this article we are talking about pure, immutable
> lists. Lisp actually has operations that modify the `rest` or `first`
> links of a list, but that's considered cheating.
>
> Also, of course, if we were really implementing this in Java, we would
> might be tempted to hide the `first` and `rest` fields and provide
> access functions. In the interest of both readability and efficiency,
> we don't do that. In a functional language, they would both be
> functions anyway, not methods, and their implementation as fields
> would be hidden.

In Lisp, the operation that *cons*tructs a List object is called `cons`,
and the resulting objects are called "cons cells". Out of respect for
tradition, and because `new List` is terribly clumsy, we're going to
define `cons` as follows:

    static List<T> cons(T first, List rest) {
           return new List<T>(first, rest);
	}

And what about the *empty* list? Well, you only need one of them,
because all empty lists are the same. There is no value associated with
them, so they don't have any specific type. So take some arbitrary
`List` instance, ignore the fact that it has a `value` field (because
there's nothing *in* an empty list, and we're never going to look at
it), and store it as the value of a well-known constant conventionally
called either `nil` or (using Lisp's notation for lists) `()` -- which
the compiler quietly converts to the appropriate object. In any case, we
can add the following definition to our class:

    private static final List NIL = cons(null, null);

The way you test to see if a `List`-valued variable contains the empty
list is to compare it to `NIL`. You can use identity (the `==`
operation), because there's only one empty list. That means that testing
whether a list is empty is reduced from a method call to a single
machine-language comparison instruction. So the `isEmpty` method just
looks like

    boolean isEmpty() { return this == NIL; }

And how does one add an element to a list? Strictly speaking, one
doesn't. One simply constructs a *new* `List` with its `rest` field
pointing to the list you're adding onto.

... and now, we really *are* done defining `List`. We don't need
anything else. But the real fun has just begun.

More Joy
--------

So let's look at some of the advantages of singly-linked lists:

First of all, we can see that adding an element to the front of a
singly-linked list is marvelously efficient, because you don't have to
change any links. But there's more: because you don't have to change any
links, *lists are immutable.*. (I know, I already said that. I'll keep
saying it until it sinks in.)

What that means is that the whole "copy vs. reference" problem goes
away. You never have to copy a list -- you just copy the reference. That
also means that *many lists can share a common tail piece.*.

Because the `rest` field is, as the name suggests, a reference to the
rest of the list, recursion becomes the obvious and natural way to
operate on lists. If your compiler is smart enough to recognize tail
recursion, most recursive operations on lists become as efficient as
iteration.

Because lists are immutable, they are also thread-safe - if you have a
variable that refers to a List object, nothing going on elsewhere in the
program is going to change it. This is one reason why functional
languages are great for high-throughput applications with a lot of
concurrency.

 

I'm not going to say that there aren't a few disadvantages to
singly-linked lists. You can't add onto the end, for example, or go
backwards if you have a reference to the middle of some list. But that's
not a fatal flaw, thanks to a clever trick called a "zipper". Here's how
you reverse a list:

    List<T> reverse(List<T> list) {
        return reverse2(list, NIL);
    }
    List<T> reverse2(List<T> list, List<T> list2) {
        if (list == NIL) {
            return list2;
        } else {
            return reverse2(list.rest, cons(list.first, list2.rest));
        }
    }

It's called a zipper because you can use the same kind of
forward-and-reverse pairing to go up and down the list, modifying or
adding elements as you go.

    Class Zipper<T> {
        final List<T> forward;
        final List<T> reverse;
        Zipper<T> insert(T v) {
             return new Zipper(cons(point, forward), reverse);
        }
        Zipper<T> previous() {
             return new Zipper(reverse.next, cons(reverse.first, forwward));
        }
        boolean atTop() {
             return reverse == NIL;
        }
        List<T> unzip() {
             return atTop()? forward : previous();
        }
    }

The atBottom, next, and zip operations are left as an exercise for the
reader. You will also notice that `Zipper` is also immutable!

An equivalent structure, using an array of characters with a "gap" in it
between the forward and reverse pieces, was used by Richard Stallman for
Emacs\[Stallman 1981\].

------------------------------------------------------------------------

Notes and References
--------------------

 \[Stallman 1981\] 
:   Stallman, Richard, "[EMACS: The Extensible, Customizable Display
    Editor](https://www.gnu.org/software/emacs/emacs-paper.html#SEC31)", 1981.
	
* This is a cleaned-up version of an article first published in 2016 on
  [Stephen.Savitzky.net](https://stephen.savitzky.net).

------------------------------------------------------------------------

