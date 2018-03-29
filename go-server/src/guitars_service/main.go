package main

import (
	"fmt"
	"os"

	"thrift_generated/guitars"

	"git.apache.org/thrift.git/lib/go/thrift"
)

func main() {
	addr := "localhost:9090"
	exitCode := 0

	serverTransport, err := thrift.NewTServerSocket(addr)

	if err == nil {
		transportFactory := thrift.NewTFramedTransportFactory(thrift.NewTTransportFactory())
		protocolFactory := thrift.NewTBinaryProtocolFactoryDefault()
		handler := newGuitarsHandler()
		processor := guitars.NewGuitarsServiceProcessor(handler)
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
