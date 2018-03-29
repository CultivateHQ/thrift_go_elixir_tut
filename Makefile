SHELL := bash

export GOPATH := $(shell pwd)/go-server

THRIFT ?= $(shell which thrift)
GO     ?= $(shell which go)
GIT    ?= $(shell which git)
MIX    ?= $(shell which mix)

define ensure_found
ifeq ($$($(1)),)
$$(error Could not find the "$(2)" command. Please install it and make sure it is on your system PATH.)
endif
endef

$(eval $(call ensure_found,THRIFT,thrift))
$(eval $(call ensure_found,GO,go))
$(eval $(call ensure_found,GIT,git))
$(eval $(call ensure_found,MIX,mix))

THRIFT_VERSION := $(shell $(THRIFT) --version | egrep -o '[0-9.]+')

GO_BINS := go-server/bin/guitars_service \
           go-server/bin/guitars_service-remote

EX_BINS := ex-client/guitars_client

.PHONY: all
all: build

.PHONY: env
env:
	@echo --------------------
	@echo THRIFT = $(THRIFT)
	@echo THRIFT_VERSION = $(THRIFT_VERSION)
	@echo
	@echo GO = $(GO)
	@echo GO_VERSION = $(shell $(GO) version)
	@echo -n "GOPATH = "; $(GO) env GOPATH
	@echo
	@echo MIX = $(MIX)
	@echo MIX_VERSION = "$(shell $(MIX) --version | grep ^Mix)"
	@echo
	@echo GIT = $(GIT)
	@echo GIT_VERSION = $(shell $(GIT) --version)
	@echo
	@echo GO_BINS = $(GO_BINS)
	@echo --------------------

.PHONY: build build-go build-ex
build: build-go
build-go: $(GO_BINS)
build-ex: $(EX_BINS)

.PHONY: clean clean-go clean-ex
clean: clean-go clean-ex
clean-go:
	rm -rf go-server/{bin,pkg}
	rm -rf go-server/src/thrift_generated
clean-ex:
	cd ex-client && $(MIX) clean
	rm -rf $(EX_BINS) ex-client/lib/thrift

.PHONY: clobber clobber-go clobber-ex
clobber: clobber-go
clobber-go: clean-go
	rm -rf go-server/src/git.apache.org
clobber-ex: clean-ex
	rm -rf ex-client/{_build,deps}

.PHONY: test test-go test-ex
test: test-go
test-go: $(GO_BINS)
	$(GO) test guitars_service
test-ex: ex-client/deps
	cd ex-client && \
		$(MIX) test

$(GO_BINS): go-server/src/git.apache.org/thrift.git go-server/src/thrift_generated

go-server/bin/guitars_service-remote:
	$(GO) install -v thrift_generated/guitars/guitars_service-remote
	@echo OUTPUT: $(@)

go-server/bin/guitars_service: go-server/src/guitars_service/*.go
	$(GO) install -v guitars_service
	@echo OUTPUT: $(@)

go-server/src/thrift_generated: thrift-defs/*.thrift Makefile
	mkdir -p $(@)
	$(THRIFT) -strict \
		-recurse \
		--gen go:package_prefix="thrift_generated/" \
		-out "$(@)/" \
		"thrift-defs/guitars.thrift"
	find $(@)/ -name '*.go' | xargs gofmt -w
	touch $(@)

go-server/src/git.apache.org/thrift.git: go-server/src/thrift_generated
	$(GO) get -v -d thrift_generated/guitars/guitars_service-remote
	cd go-server/src/git.apache.org/thrift.git && $(GIT) checkout -q $(THRIFT_VERSION)
	touch $(@)

ex-client/deps:
	cd ex-client && \
		$(MIX) deps.get

ex-client/guitars_client: ex-client/deps
	cd ex-client && \
		$(MIX) escript.build
