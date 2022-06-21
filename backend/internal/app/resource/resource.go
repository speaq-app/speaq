package resource

import (
	"context"
	"log"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

type Server struct {
	ResourceService data.ResourceService
	UnimplementedResourceServer
}

func (s Server) GetResource(ctx context.Context, req *GetResourceRequest) (*GetResourceResponse, error) {
	log.Println(req.Id)
	r, err := s.ResourceService.ResourceByID(req.Id)
	if err != nil {
		return nil, err
	}

	return &GetResourceResponse{
		Data:     r.Data,
		MimeType: r.MIMEType,
		Size:     r.Size,
	}, nil
}
