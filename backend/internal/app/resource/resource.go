package resource

import (
	"context"
	"log"

	"github.com/speak-app/speak/internal/pkg/data"
)

type Server struct {
	DataService data.Service
	UnimplementedResourceServer
}

func (s Server) GetResource(ctx context.Context, req *ResourceRequest) (*ResourceResponse, error) {
	log.Printf("Resource with ID %d was requested", req.ID)

	r, err := s.DataService.ResourceByID(req.ID)
	if err != nil {
		return nil, err
	}

	return &ResourceResponse{
		Data:     r.Data,
		Name:     r.Name,
		MIMEType: r.MIMEType,
		Size:     r.Size,
	}, nil
}
