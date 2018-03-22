SHELL := bash

export GOPATH := $(shell pwd)/go-server

THRIFT_VERSION := $(shell thrift --version | egrep -o '[0-9.]+')

BINS := go-server/bin/go-service \
        go-server/bin/guitars-remote

.PHONY: all
all: build

.PHONY: env
env:
	@echo BINS = $(BINS)
	@echo THRIFT_VERSION = $(THRIFT_VERSION)
	go env

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
	go install -v gen-go/guitars/guitars-remote

go-server/bin/go-service: go-server/src/go-service/*.go
	go install -v go-service

go-server/src/gen-go: thrift-defs/*.thrift
	thrift -strict \
		-recurse \
		--gen go:package_prefix="gen-go/" \
		-o "go-server/src" \
		"thrift-defs/guitars.thrift"
	find go-server/src/gen-go -name '*.go' | xargs gofmt -w
	touch $(@)

go-server/src/git.apache.org/thrift.git: go-server/src/gen-go
	go get -v -d gen-go/guitars/guitars-remote
	cd go-server/src/git.apache.org/thrift.git && git checkout -q $(THRIFT_VERSION)
	touch $(@)
