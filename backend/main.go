package main

import (
	"log"
	"net"

	"github.com/speak-app/speak/internal/app/resource"
	"google.golang.org/grpc"
)

func main() {
	srv := grpc.NewServer()
	resourceSrv := resource.Server{}
	resource.RegisterResourceServer(srv, resourceSrv)

	l, err := net.Listen("tcp", ":8080")
	if err != nil {
		log.Fatal("port already in use")
	}

	log.Println(srv.Serve(l))
}
