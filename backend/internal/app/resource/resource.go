package resource

import (
	"context"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

type Server struct {
	ResourceService data.ResourceService
	UnimplementedResourceServer
}

func (s Server) GetResource(ctx context.Context, req *GetResourceRequest) (*GetResourceResponse, error) {
	r, err := s.ResourceService.ResourceByID(req.Id)
	if err != nil {
		return nil, err
	}

	return &GetResourceResponse{
		Data:          r.Data,
		MimeType:      r.MIMEType,
		AudioDuration: r.AudioDuration,
	}, nil
}
