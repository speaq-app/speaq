package resource

import (
	"context"
	"log"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

type Server struct {
	DataService data.Service
	UnimplementedResourceServer
}

func (s Server) GetResource(ctx context.Context, req *GetResourceRequest) (*GetResourceResponse, error) {
	log.Println(req.Id)
	r, err := s.DataService.ResourceByID(req.Id)
	if err != nil {
		return nil, err
	}

	return &GetResourceResponse{
		Data:     r.Data,
		Name:     r.Name,
		MimeType: r.MIMEType,
		Size:     r.Size,
	}, nil
}
