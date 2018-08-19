### Honu/Makefile
#
# Targets:
#	draft	make a draft post -- requires name=SLUG
#	post	move draft to _posts
#	publish	push to GitHub
#

###
SHELL=/bin/bash
GIT = git

.PHONY: draft post publish report-vars name-required draft-required

ifdef name
    DRAFT:=$(subst .md.md,.md,_drafts/$(name).md)
else ifneq (x$(wildcard _drafts/*),x)
        DRAFT:=$(strip $(wildcard _drafts/*))
	ifneq ($(firstword $(DRAFT)),$(lastword $(DRAFT)))
	    # There's more than one file in _drafts -- make it something distinctive
	    # so that we can complain if we need $(DRAFTS) defined.
	    DRAFT:=multiple-drafts
	endif
endif


# In Jekyll, a post is _posts/yyyy-mm-dd-name.md
DATESTAMP = $(shell date "+%Y-%m-%d")
POST = _posts/$(DATESTAMP)-$(subst _drafts/,,$(DRAFT))

draft:  name-required $(DRAFT)
$(DRAFT): 
	echo '---' 		 > $@
	echo title: $(TITLE)	>> $@
	echo layout: post	>> $@
	echo '---'		>> $@
	$(GIT) add $@
	$(GIT) commit -m "created $@" $@

post: 	draft-required $(POST)
$(POST):
	$(GIT) mv $(DRAFT) $(ENTRY)
	$(GIT) commit -m "posted $(ENTRY)" $(ENTRY)

name-required:
	@if [ -z $(name) ]; then \
	   echo '$$(name) not defined."'; false; \
	fi

draft-required:
	@if [ -e "$(DRAFT)" ]; then 	\
	   echo draft found;				\
	elif [ -z $(DRAFT) ]; then 	\
	   echo '$$(name) not defined.'; false; \
	elif [ "multiple-drafts" == "$(DRAFT)" ]; then \
	   echo 'More than one file in _drafts; specify one by name'; false; \
	elif [ ! -f $(DRAFT) ]; then 	\
	   echo '$(DRAFT) not found.'; false; \
	fi

# make publish will fail if there are modified files present
publish:
	$(GIT) push github

### If we're using the MakeStuff package, chain in its Makefile
#	This is optional -- it doesn't affect basic functionality -- but it
#	brings in a lot of useful extras like "make push", recursive "make all",
#	and so on.  Note that include does the right thing if the file list is
#	empty, so we don't have to test for that.
#
#	Normally Makefile is a symlink to Makestuff/Makefile, and
#	local dependencies go into depends.make.  We do it differently
#	here because we want 
#
CHAIN = $(wildcard ../MakeStuff/Makefile)
include $(CHAIN)

### report-vars
#	report-vars is also defined in the MakeStuff package, so you can use it to
#	see whether MakeStuff/Makefile is properly chained in.  It's also a very
#	handy way to see whether your make variables are defined properly.
report-vars::
	@echo DRAFT=$(DRAFT)
	@echo ENTRY=$(ENTRY)
	@echo CHAIN=$(CHAIN)
