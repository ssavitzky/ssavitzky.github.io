---
title: Setting up gojekyll
tags: [jekyll, off-github ]
layout: post
---

My shared hosting service doesn't like users to install their own copy of Ruby
unless they have their own virtual host -- Ruby tends to be a memory hog,
especially when it's running something like Jekyll.  Fortunately, there's an
alternative:  `gojekyll`, a Jekyll clone written in `go`.  (That's a
programming language -- it's often called "golang" to distinguish it from the
Japanese board game.)  It's extremely fast and lightweight.  My shared
hosting service doesn't have go installed, but getting it up and running is
_easy_. 

Here's how: 

``` bash
  mkdir golang  # This is where go gets installed
  mkdir go      # This is where other go programs live
  cd golang
  wget https://dl.google.com/go/go1.11.linux-amd64.tar.gz
  tar -xzf go1.11.linux-amd64.tar.gz 
  export GOHOME=$HOME/golang/go
  PATH=$GOHOME/bin:$HOME/go/bin:$PATH
  which go
  # we don't have to set GOPATH because ~/go is the default
  go get github.com/osteele/gojekyll
  gojekyll --help
```

Total time about five minutes.  It helps if you already have the necessary
setup commands in your `.bashrc` file:

``` bash
if [ -d $HOME/golang/go ]; then
    export GOHOME=$HOME/golang/go
    prependToPath $GOHOME/bin
fi

if [ -d $HOME/go ]; then
    # we don't have to set GOPATH because ~/go is the default
    prependToPath $HOME/go/bin
fi
```
