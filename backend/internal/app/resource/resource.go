package resource

import (
	"context"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

type Server struct {
	DataService data.Service
	UnimplementedResourceServer
}

func (s Server) GetResource(ctx context.Context, req *GetResourceRequest) (*GetResourceResponse, error) {
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
