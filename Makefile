SHELL := bash

export GOPATH := $(shell pwd)/go-server

THRIFT ?= $(shell which thrift)
GO     ?= $(shell which go)
GIT    ?= $(shell which git)
THRIFT_VERSION := $(shell $(THRIFT) --version | egrep -o '[0-9.]+')

BINS := go-server/bin/go-service \
        go-server/bin/guitars-remote

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
	@echo GIT = $(GIT)
	@echo GIT_VERSION = $(shell $(GIT) --version)
	@echo
	@echo BINS = $(BINS)
	@echo --------------------

.PHONY: build
build: $(BINS)

.PHONY: clean
clean:
	rm -rf go-server/{bin,pkg}
	rm -rf go-server/src/gen-go

.PHONY: clobber
clobber: clean
	rm -rf go-server/src/git.apache.org

$(BINS): go-server/src/git.apache.org/thrift.git go-server/src/gen-go

go-server/bin/guitars-remote:
	$(GO) install -v gen-go/guitars/guitars-remote
	@echo OUTPUT: $(@)

go-server/bin/go-service: go-server/src/go-service/*.go
	$(GO) install -v go-service
	@echo OUTPUT: $(@)

go-server/src/gen-go: thrift-defs/*.thrift Makefile
	$(THRIFT) -strict \
		-recurse \
		--gen go:package_prefix="gen-go/" \
		-o "go-server/src" \
		"thrift-defs/guitars.thrift"
	find go-server/src/gen-go -name '*.go' | xargs gofmt -w
	touch $(@)

go-server/src/git.apache.org/thrift.git: go-server/src/gen-go
	$(GO) get -v -d gen-go/guitars/guitars-remote
	cd go-server/src/git.apache.org/thrift.git && $(GIT) checkout -q $(THRIFT_VERSION)
	touch $(@)
