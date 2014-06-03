Hello World!
############

:date: 2014-06-03 17:11
:tags: pelican, python, github, jekyll
:category: blogging, programming
:slug: hello-world
:author: Matthew Gidden
:summary: My first blog post!

Well, hi there!
---------------

This is one of those 'I've been meaning to do this forever' kind of things. I
feel like I've had all the tools in my toolbox, but never the exact amount of
time or motivation. But here it is. I decided to make my first post a little
meta: some of the nuts and bolts of how I actually came to develop this blog.

First of all, I needed somewhere to host this thing. As luck turned out, I
recently went through the work of developing my `website
<http://mattgidden.com>`_. Using Github's `pages <https://pages.github.com/>`_
feature was a natural choice. I'm still a bit of a website noob, so (at the time
of writing), I'm just using the extended domain `mattgidden.com/blog
<http://mattgidden.com/blog>`_. One day I'll get a better grasp on subdomains
and look to make it rather ``blog.mattgidden.com`` or some such. I have the
feeling that the ghpages-all-in-one-website approach may be limiting there.

How do you say 'notebook' in French?
------------------------------------

In any case, the next question was what blog static website generator service to
use. I really only looked at two:

#. `Jekyll <http://jekyllrb.com/>`_
#. `Pelican <http://docs.getpelican.com/en/3.3.0/>`_

My initial thought was "Why not Jekyll? You get automatic ghpages support!", but
(un)fortunately, my use case was a bit more complicated. Since I'm using Github
as my only (free) webhosting service, I need it to support *all* of my
websites. Not only was I interested in having a blog, but I also wanted to host
my `Sphinx-generated <http://sphinx-doc.org/>`_ `Cyclopts
<http://github.com/gidden/cyclopts>`_ project `documentation
<http://mattgidden.com/cyclopts>`_. This ran afoul of a major design decision in
Jekyll and the way Sphinx generates websites: Jekyll doesn't publish directories
that start with a `_`, and Sphinx generates websites with exactly those kinds of
directories. The answer? `Bypass Jekyll
<https://github.com/blog/572-bypassing-jekyll-on-github-pages>`_. The
consequence? We bypassed Jekyll.

But, lo, we get a nice benefit. You see, Jekyll has no native `ReST
<http://sphinx-doc.org/rest.html>`_ support. It has a `plugin
<https://github.com/xdissent/jekyll-rst>`_, but I found it hard to use. I happen
to write a lot of ReST, and I wanted to write this blog in ReST.

Enter Pelican. It had everything I wanted: an easy build system, easy content
discovery, a getting started executable, and an html layout that fits in
seamlessly with a ghpages repo with a ``.nojekyll`` file in it.

Makefiles are amazing things
----------------------------

I actually keep my `blog repository <github.com/gidden/blog>`_ separate from my
`website repo <github.com/gidden/gidden.github.io>`_, and I only keep html in my
website repository. My local copy of each is in ``~/personal/site`` and
``~/personal/blog``, respectively. Accordingly, I had to update the blog repos
Makefile with the following lines: ::

  # override default output dir
  OUTPUTDIR=$(BASEDIR)/build

  # doc publishing variables
  BUILDDIR        = $(OUTPUTDIR)
  DOCREPOURL      = git@github.com:gidden/gidden.github.io
  DOCREPODIR      = ~/personal/site
  DOCUPDATENAME   = blog
  DOCHTMLDIR      = $(DOCREPODIR)/blog
  TMPDOCDIR       = $(DOCREPODIR)/.$(DOCUPDATENAME)tmpdocs

  # this should likely go at the end -- other targets use OUTPUTDIR
  publish:
	  @echo
	  @echo "Updating $(DOCHTMLDIR) with current documentation."
	  test -d $(DOCREPODIR) || git clone $(DOCREPOURL) $(DOCREPONAME) && \
	  test ! -d $(TMPDOCDIR) || rm -r $(TMPDOCDIR) && \
	  mkdir -p $(TMPDOCDIR) && \
	  cp -r $(BUILDDIR)/* $(TMPDOCDIR) && \
	  cd $(DOCREPODIR) && git pull origin master && \
	  test ! -d $(DOCHTMLDIR) || rm -r $(DOCHTMLDIR) && \
	  mkdir -p $(DOCHTMLDIR) && mv $(TMPDOCDIR)/* $(DOCHTMLDIR) && \
	  rm -r $(TMPDOCDIR)/ && \
	  cd $(DOCREPODIR) && git add $(DOCHTMLDIR) && \
	  if [ -n "$$(git status $(DOCHTMLDIR) --porcelain)" ]; \
	  then git commit -m "updated $(DOCUPDATENAME) html" && git push origin master; \
	  fi
	  @echo
	  @echo "$(DOCHTMLDIR) updated and pushed to $(DOCREPOURL)."
  .PHONY: publish

Now, any time I write a new blog post, I can publish it with a simple

.. code-block:: bash

  $ make html && make publish

I need an interior decorator
----------------------------

Or some time and a desire more front-end design practice. The css they give you
is pretty ugly. But I have frisbee to play, so I'll leave that for another time!
