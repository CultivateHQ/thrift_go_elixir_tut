SHELL := bash

export GOPATH := $(shell pwd)/go-server

THRIFT_SRC := go-server/src/git.apache.org/thrift.git
GO_GEN_SRC := go-server/src/gen-go
THRIFT_VERSION := $(shell thrift --version | egrep -o '[0-9.]+')
BINS := go-server/bin/guitars-remote

.PHONY: all
all: build

.PHONY: env
env:
	@echo THRIFT_VERSION = $(THRIFT_VERSION)
	go env

.PHONY: generate
generate: $(GO_GEN_SRC)

.PHONY: deps
deps: $(THRIFT_SRC)

.PHONY: build
build: $(BINS)

.PHONY: clean
clean:
	rm -rf go-server/{bin,pkg}

.PHONY: clobber
clobber: clean
	rm -rf go-server/src/gen-go
	rm -rf go-server/src/git.apache.org

go-server/bin/guitars-remote: $(THRIFT_SRC)
	go install -v gen-go/guitars/guitars-remote

$(GO_GEN_SRC): thrift-defs/*.thrift
	thrift -strict \
		-recurse \
		--gen go:package_prefix="gen-go/" \
		-o "go-server/src" \
		"thrift-defs/guitars.thrift"
	find $(@) -name '*.go' | xargs gofmt -w
	touch $(@)


$(THRIFT_SRC): $(GO_GEN_SRC)
	go get -v -d gen-go/guitars/guitars-remote
	touch $(@)
	cd $(@) && git checkout -q $(THRIFT_VERSION)
