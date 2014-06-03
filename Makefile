
JEKYLLBUILD   = jekyll build
BUILDDIR      = build

html:
	$(JEKYLLBUILD) -d $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."
