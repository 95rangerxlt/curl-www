ROOT=.

# the latest stable version is:
STABLE= 7.48.0
RELDATE = "23rd of March 2016"

# name of the dir to tempoary unpack and build zip files in:
TEMPDIR=tempzip

# generated file with binary package stats
STAT = packstat.t

# generated file with release info (STABLE and RELDATE)
RELEASE = release.t

include mainparts.mk
include setup.mk

MAINPARTS += _menu.html

all: index.html feedback.html mirrors.html libs.html help.html	      \
 download.html changes.html about.html support.html newslog.html news.html    \
 head.html foot.html oldnews.html info web-editing.html ad.html donation.html \
 search.html sflogo.html sponsors.html source.html
	cd docs && make
	cd libcurl && make
	cd mail && make
	cd mirror && make
	cd legal && make
	cd rfc && make
	cd dev && make

head.html: _head.html $(MAINPARTS)
	$(ACTION)

donation.html: _donation.html docs/_menu.html $(MAINPARTS)
	$(ACTION)

version7.html: _version7.html $(MAINPARTS)
	$(ACTION)

search.html: _search.html $(MAINPARTS) sitesearch.t
	$(ACTION)

web-editing.html: _web-editing.html $(MAINPARTS)
	$(ACTION)

foot.html: _foot.html $(MAINPARTS)
	$(ACTION)

index.html: _index.html $(MAINPARTS) release.t packstat.t
	$(ACTION)

newslog.html: _newslog.html $(MAINPARTS)
	$(ACTION)

press.html: _press.html $(MAINPARTS)
	$(ACTION)

news2.html: _news2.html $(MAINPARTS)
	$(ACTION)

news.html: news2.html newslog.html
	rm -f $@
	./filter.pl < $< > $@

olddata.html: _oldnews.html $(MAINPARTS)
	$(ACTION)

oldnews.html: olddata.html
	rm -f $@
	./filter.pl < $< > $@

info: _info packstat.t
	$(ACTION)

$(RELEASE): Makefile
	@echo "fixing $(RELEASE)"
	@echo "#define __STABLE $(STABLE)" >$(RELEASE)
	@echo "#define __RELDATE $(RELDATE)" >>$(RELEASE)
	@echo "#define __STABLETAG $(STABLE)" | sed 's/\./_/g' >> $(RELEASE)

$(STAT): download.html Makefile
	@echo "fixing $(STAT)"
	@echo "#define __CURR "`grep -c "^.tr.class=.latest" $<` >$(STAT)
	@echo "#define __PACKS `grep -c \"^<tr c\" $<`" >>$(STAT)

download.html: _download.html $(MAINPARTS) $(RELEASE) dl/files.html
	$(ACTION)

download2.html: _download2.html $(MAINPARTS) $(RELEASE) dl/files.html
	$(ACTION)

dl/files.html: dl/data/databas.db
	cd dl; make

changes.html: _changes.html docs/_menu.html $(MAINPARTS)
	$(ACTION)

source.html: _source.html $(MAINPARTS)
	$(ACTION)

help.html: _help.html $(MAINPARTS)
	$(ACTION)

mirrors.html: _mirrors.html $(MAINPARTS)
	$(ACTION)

about.html: _about.html docs/_menu.html $(MAINPARTS)
	$(ACTION)

sponsors.html: _sponsors.html docs/_menu.html $(MAINPARTS)
	$(ACTION)

feedback.html: _feedback.html $(MAINPARTS)
	$(ACTION)

libs.html: _libs.html $(MAINPARTS)
	$(ACTION)

support.html: _support.html $(MAINPARTS)
	$(ACTION)

ad.html: _ad.html ad.t
	$(ACTION)

sflogo.html : sflogo.t
	$(ACTION)

full: all
	@cd libcurl; make

release:
	cd download; ls -1 *curl* >curldist.txt;
	@echo done

clean:
	rm -f *~
