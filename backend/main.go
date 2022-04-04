package main

import (
	"log"
	"net"
	"time"

	"github.com/speak-app/speak/internal/app/resource"
	"github.com/speak-app/speak/internal/pkg/data/postgres"
	"google.golang.org/grpc"
)

func main() {
	db, err := postgres.Open("", time.Second*5)
	if err != nil {
		log.Fatal("failed to connect to database")
	}

	if err := db.MigrateSchema(); err != nil {
		log.Fatal("failed to migrate schema")
	}

	srv := grpc.NewServer()
	resourceSrv := resource.Server{
		DataService: db,
	}
	resource.RegisterResourceServer(srv, resourceSrv)

	l, err := net.Listen("tcp", ":8080")
	if err != nil {
		log.Fatal("port already in use")
	}

	log.Println(srv.Serve(l))
}
