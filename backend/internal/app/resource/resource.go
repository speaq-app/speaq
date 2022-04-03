package resource

import (
	"context"
	"log"
)

type Server struct {
	UnimplementedResourceServer
}

func (s Server) GetResource(ctx context.Context, req *ResourceRequest) (*ResourceResponse, error) {
	log.Printf("Resource with ID %d was requested", req.ID)
	return &ResourceResponse{
		Resource: []byte(""),
		MIMEType: "",
		Size:     0,
	}, nil
}
