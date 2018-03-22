package main

import (
	"context"
	"fmt"
	"os"

	"gen-go/guitars"

	"git.apache.org/thrift.git/lib/go/thrift"
)

type guitarsHandler struct {
}

func newGuitarsHandler() *guitarsHandler {
	return &guitarsHandler{}
}

func (p *guitarsHandler) Create(ctx context.Context, brand string, model string) (r *guitars.Guitar, err error) {
	return guitars.NewGuitar(), nil
}

func (p *guitarsHandler) Show(ctx context.Context, id int64) (r *guitars.Guitar, err error) {
	return guitars.NewGuitar(), nil
}

func (p *guitarsHandler) Remove(ctx context.Context, id int64) (r *guitars.Guitar, err error) {
	return guitars.NewGuitar(), nil
}

func (p *guitarsHandler) All(ctx context.Context) (r []*guitars.Guitar, err error) {
	return []*guitars.Guitar{guitars.NewGuitar()}, nil
}

func main() {
	addr := "localhost:9090"
	exitCode := 0

	serverTransport, err := thrift.NewTServerSocket(addr)

	if err == nil {
		transportFactory := thrift.NewTTransportFactory()
		protocolFactory := thrift.NewTJSONProtocolFactory()
		handler := newGuitarsHandler()
		processor := guitars.NewGuitarsProcessor(handler)
		server := thrift.NewTSimpleServer4(processor, serverTransport, transportFactory, protocolFactory)

		fmt.Println("Starting the simple server ... on ", addr)

		if err := server.Serve(); err != nil {
			fmt.Println("error running server:", err)
			exitCode = 1
		}
	} else {
		fmt.Println("error creating TServerSocket:", err)
		exitCode = 1
	}

	os.Exit(exitCode)
}
