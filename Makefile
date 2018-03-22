SHELL := bash

export GOPATH := $(shell pwd)/go-server

THRIFT_VERSION := $(shell thrift --version | egrep -o '[0-9.]+')

.PHONY: all
all: build

.PHONY: env
env:
	@echo THRIFT_VERSION = $(THRIFT_VERSION)
	go env

.PHONY: generate
generate:
	thrift -strict \
		-recurse \
		--gen go:package_prefix="gen-go/" \
		-o "go-server/src" \
		"thrift-defs/guitars.thrift"
	find go-server/src/gen-go -name '*.go' | xargs gofmt -w

.PHONY: deps
deps: generate
	go get -v -d gen-go/guitars/guitars-remote
	cd go-server/src/git.apache.org/thrift.git && git checkout -q $(THRIFT_VERSION)

.PHONY: build
build: deps
	go install -v gen-go/guitars/guitars-remote

.PHONY: clean
clean:
	rm -rf go-server/{bin,pkg}
	rm -rf go-server/src/gen-go

.PHONY: clobber
clobber: clean
	rm -rf go-server/src/git.apache.org
