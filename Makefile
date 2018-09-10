### Makefile for Jekyll blogs
#
# Targets:
#	draft	make a draft post -- requires name=SLUG
#	post	move draft to _posts
#	publish	push to GitHub
#	serve	serve on localhost (with drafts)
#	build	build the site
#	imports	copy in files from outside the tree
#

###
SHELL=/bin/bash

# Are we using real jekyll, or gojekyll?
ifeq ($(wildcard .bundle),.bundle)
  JEKYLL = bundle exec jekyll
else
  JEKYLL = gojekyll
endif

# TARGETS has all of the targets a user is likely to make
#	  there are some internal ones not listed here.
TARGETS = draft post publish serve build imports upload

all::
	@echo targets: $(TARGETS)
	@echo usage:  'make draft name=SLUG title="TITLE"; edit; make post'

.PHONY:  $(TARGETS) report-vars name-required draft-required 

### Drafting and posting blog entries

ifdef name
    DRAFT:=$(subst .md.md,.md,_drafts/$(name).md)
else ifneq (x$(wildcard _drafts/*),x)
        DRAFT:=$(strip $(wildcard _drafts/*))
	ifneq ($(firstword $(DRAFT)),$(lastword $(DRAFT)))
	    # There's more than one file in _drafts -- make it something distinctive
	    # so that we can complain if we need $(DRAFTS) defined.
	    DRAFT:=multiple-drafts
	endif
	name := $(subst .md,,$(notdir $(DRAFT)))
endif

# In Jekyll, a post is _posts/yyyy-mm-dd-name.m544d
DATESTAMP = $(shell date "+%Y-%m-%d")
POST = _posts/$(DATESTAMP)-$(subst _drafts/,,$(DRAFT))

draft:  name-required $(DRAFT)
$(DRAFT): 
	echo '---' 		 > $@
	echo title: $(TITLE)	>> $@
	echo tags:  '[ ]'	>> $@
	echo layout: post	>> $@
	echo '---'		>> $@
	git add $@
	git commit -m "created $@" $@

post: 	draft-required $(POST)
$(POST):
	git mv $(DRAFT) $(POST)
	git commit -m "posted $(ENTRY)" $(POST)

name-required:
	@if [ -z $(name) ]; then 			\
	   echo '$$(name) not defined."'; false; 	\
	fi

draft-required:
	@if [ -e "$(DRAFT)" ]; then 			\
	   echo draft found;				\
	elif [ -z $(DRAFT) ]; then 			\
	   echo '$$(name) not defined.'; false; 	\
	elif [ "multiple-drafts" == "$(DRAFT)" ]; then	\
	   echo 'More than one file in _drafts;'	\
		'Specify one with name='; false; 	\
	elif [ ! -f $(DRAFT) ]; then 			\
	   echo '$(DRAFT) not found.'; false; 		\
	fi

### Building

# If jekyll serve is running, you need to stop it before building.  Otherwise
#	it will clobber _site if it notices that something has changed.
#
SERVER_PID = $(firstword $(shell ps x | grep '[j]ekyll serve'))
kill-server:
	@pid=$(SERVER_PID); if [ ! -z $$pid ]; then		\
	    echo "Stopping jekyll server process.";		\
	    kill $$pid;						\
	fi

# make serve includes drafts.
#	This does a build as a side effect, but it's not a production build
serve:
	$(JEKYLL) serve --drafts

# build with JEKYLL_ENV=production.
#
#	gojekyll neither copies nor keeps the .well-known subdirectory,
#	so just copy it from here if we have one.  It's used by our web
#	host for renewing Let's Encrypt certs.  It also contains an empty
#	subdirectory, so we can't easily keep it in git either, since I'm
#	reluctant to mess with it.
#
build:	kill-server
	JEKYLL_ENV=production $(JEKYLL) build
	if [ ! -d _site/.well-known ] && [ -d .well-known ]; then \
		cp -r .well-known _site;			  \
	fi

### Publishing (uploading)

# Publish, either to github or somewhere else.
#	If PUBLISH_TO_GITHUB is defined, all we have to do is push.
#	Otherwise, we switch to the prod branch, merge master, build, and push.
#	The server is presumed to be origin in this case.  Either define a
#	suitable hook, or "ssh server git -C path/to/working/tree/ push"
#
ifdef PUBLISH_TO_GITHUB
# publishing to github.
#	TODO:  parametrize branch?
publish:
	@[ -z "`git status --short`" ] || (git status --short; false)
	git push github
else
# publishing a production branch to (non-github) server
#	Fail if: there are modified files present,
#		 "jekyll serve" is running,
#		 or there is no prod branch to check out.
publish:
	@[ -z "`git status --short`" ] || (git status --short; false)
	git checkout prod
	git merge --ff-only --no-commit master
	$(MAKE) build
	git commit -a -m "production build `date`"
	git push
	git checkout master
endif

# upload _site to a website that doesn't run Jekyll
#	This is much simpler than publishing into and pushing a git branch.
#
upload: build
	rsync -a _site savitzky.net:vv/web/computer-curmudgeon.com


### If we're using the MakeStuff package, chain in its Makefile
#	This is optional -- it doesn't affect basic functionality -- but it
#	brings in a lot of useful extras like "make push", recursive "make all",
#	and so on.  Note that include does the right thing if the file list is
#	empty, so we don't have to test for that.
#
#	Normally Makefile is a symlink to Makestuff/Makefile, and
#	local dependencies go into depends.make.  We do it differently
#	here because we want this to be stand-alone.
#
CHAIN = $(wildcard ../MakeStuff/Makefile)
include $(CHAIN)

### report-vars
#	report-vars is also defined in the MakeStuff package, so you can use it to
#	see whether MakeStuff/Makefile is properly chained in.  It's also a very
#	handy way to see whether your make variables are defined properly.
report-vars::
	@echo -ne "" $(foreach v,SERVER_PID name DRAFT ENTRY,$(v)=$($(v)) "\n")
	@echo " " CHAIN=$(CHAIN)
