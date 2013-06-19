BASENAME    = psnapshot

SRC_DIR     = $(PWD)/src
LIB_DIR     = $(PWD)/lib
TEST_DIR    = $(PWD)/tests
TEST_EXEC   = $(LIB_DIR)/shunit2

PROG        = $(BASENAME)
MANPAGE     = $(BASENAME:%=%.1)
EXAMPLES    = $(patsubst $(SRC_DIR)/%.example,install-example-%,$(wildcard $(SRC_DIR)/*.example))
TESTS       = $(patsubst $(TEST_DIR)/%.sh,test-%,$(wildcard $(TEST_DIR)/*.sh))
DISTFILES   = $(filter-out $(SRC_DIR) $(TEST_DIR) $(LIB_DIR),$(wildcard $(PWD)/*)) \
              $(SRC_DIR)/* $(TEST_DIR)/* $(LIB_DIR)/*

prefix     ?= /usr/local
bindir     ?= $(prefix)/bin
datadir    ?= $(prefix)/share
mandir     ?= $(datadir)/man
sysconfdir ?= $(prefix)/etc

distdir     = $(BASENAME)-$(word 2,$(shell sh $(SRC_DIR)/$(BASENAME) -V))

all:
	@echo "Usage: make [options] <target>"
	@echo
	@echo "Options: [defaults in brackets after descriptions]"
	@echo "  prefix=PREFIX   install in PREFIX [$(prefix)]"
	@echo "  bindir=DIR      install script in DIR [PREFIX/bin => $(prefix)/bin]"
	@echo "  datadir=DIR     install data files in DIR [PREFIX/share => $(prefix)/share]"
	@echo "  mandir=DIR      install man page in DIR [DATADIR/man => $(datadir)/man]"
	@echo "  sysconfdir=DIR  install system configuration files in DIR [PREFIX/etc => $(prefix)/etc]"
	@echo
	@echo "Targets:"
	@echo "  clean               clean build left overs"	
	@echo "  dist                create a distribution"	
	@echo "  install             install all files"
	@echo "  install-script      install only the script"
	@echo "  install-man         install only the man page"
	@echo "  install-examples    install only the examples"	
	@echo "  uninstall           uninstall all files"
	@echo "  uninstall-script    uninstall only the script"
	@echo "  uninstall-man       uninstall only the man page"
	@echo "  uninstall-examples  uninstall only the examples"	
	@echo "  tests               execute all tests"	
	@for t in $(TESTS); do printf "  %-19s execute tests for %s\\n" $$t $${t#test-}; done

clean:
	@rm -rf $(distdir)
	@rm -rf $(distdir).tar.gz

distdir:
	@rm -rf $(distdir)
	@mkdir -p $(addprefix $(distdir)/,$(sort $(dir $(patsubst $(PWD)/%,%,$(DISTFILES)))))
	@for f in $(patsubst $(PWD)/%,%,$(DISTFILES)); do \
	    cp -p $(PWD)/$$f $(distdir)/$$f; \
	done

dist-gzip: distdir
	@tar c $(distdir) | gzip -c >$(distdir).tar.gz
	@rm -rf $(distdir)

dist dist-all: dist-gzip

install: install-script install-man install-examples

install-script:
	@mkdir -p $(bindir)
	@cp $(SRC_DIR)/$(PROG) $(bindir)
	@chmod 755 $(bindir)/$(PROG)

install-man:
	@mkdir -p $(mandir)/man1
	@cp $(SRC_DIR)/$(MANPAGE) $(mandir)/man1
	@chown root:root $(mandir)/man1/$(MANPAGE)
	@chmod 644 $(mandir)/man1/$(MANPAGE)

install-example-%:
	@mkdir -p $(sysconfdir)
	@cp $(SRC_DIR)/$*.example $(sysconfdir)
	@chmod 644 $(sysconfdir)/$*.example 

install-examples: $(EXAMPLES)

uninstall: uninstall-script uninstall-man uninstall-examples

uninstall-script:
	@rm -f $(bindir)/$(PROG)

uninstall-man:
	@rm -f $(mandir)/man1/$(MANPAGE).gz
	@rm -f $(mandir)/man1/$(MANPAGE)

uninstall-example-%:
	@rm -f $(sysconfdir)/$*.example 

uninstall-examples: $(addprefix un,$(EXAMPLES))

test-%:
	@echo "===> Testing $*"
	@cd $(TEST_DIR) && $(TEST_EXEC) $*.sh

tests: $(TESTS)

