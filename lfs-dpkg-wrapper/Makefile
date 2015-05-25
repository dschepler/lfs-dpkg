PREFIX = /usr
BINDIR = $(PREFIX)/bin
PACKAGE = lfs-dpkg-wrapper
VERSION = 0.1
LIBDIR = $(PREFIX)/lib
PACKAGE_LIBDIR = $(LIBDIR)/$(PACKAGE)
DESTDIR =
USE_TOOLS_SCRIPTS = 0

all: buildpkg

buildpkg: buildpkg.in
	sed -e 's|@PACKAGE_LIBDIR@|$(PACKAGE_LIBDIR)|g' < $< > $@
	chmod a+x $@

clean:
	rm -f buildpkg
	find -name \*~ -delete

install: all
	install -d $(DESTDIR)$(BINDIR)
	install buildpkg $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(PACKAGE_LIBDIR)
ifeq ($(USE_TOOLS_SCRIPTS),0)
	install -m 644 fixups/*.sh $(DESTDIR)$(PACKAGE_LIBDIR)
else
	install -m 644 fixups-tools/*.sh $(DESTDIR)$(PACKAGE_LIBDIR)
endif
	install -m 644 fixups-common/*.sh $(DESTDIR)$(PACKAGE_LIBDIR)
