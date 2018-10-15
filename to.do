Notes:  Where to go with ssavitzky.github.com

  * GitHub is way behind master, and there's some messy stuff at the branch point.  If we
    can figure out where we want to go with it, the right thing is to chop it off at that
    point and cherry-pick/rebase -i to get the parts we want to keep.

    git log --oneline --since=2018-08-28 -- _config.yml _data _includes _layouts _sass | wc
      18     109     723  # adding assets only adds one commit, and we don't need it.
    git log --oneline --since=2018-08-28 -- _config.yml _includes _layouts _sass | wc -l
      15 # drops changes in _data that we're going to throw out anyway
    671  git log --pretty=email --reverse --full-index --binary --since=2018-08-28 \
         -- _config.yml _includes _layouts _sass > patch
    672  git checkout github
    675  git branch -m github github-before-cherry-pick # could have picked a better name
    678  git tag -a diverge-from-curmudgeon
    680  git am patch
    683  git am --skip       # one of the commits was empty
    686  git branch -D master
    687  git branch -m github-before-cherry-pick master

  * And it's not clear whether to keep the blog (cross-posting from curmudgeon), convert
    it to a collection of articles, both, or abandon it altogether.  For articles we
    probably need to slugify the titles.
    -> articles.  Note the source.

  o We _need_ to put in links to any GitHub project sites we set up, starting with
    hyperviewer and, probably, PIA papers.  That means we actually have to _make_ project
    pages for those projects.

  o Wanting to make a theme out of it complicates things a bit.  It would be nice if we
    could keep all the Jekyll pieces in one place.  Clearing the deadwood out of here
    would help.
