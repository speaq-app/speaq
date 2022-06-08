package resource

import (
	"context"
	"github.com/speaq-app/speaq/internal/pkg/data"
	"log"
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
func (s Server) UploadResource(ctx context.Context, req *UploadResourceRequest) (*UploadResourceResponse, error) {
	r := data.Resource{
		Data:     req.Data,
		Name:     req.Name,
		MIMEType: req.MimeType,
		Size:     req.Size,
	}

	i, err := s.DataService.UploadResource(r)

	if err != nil {
		return nil, err
	}

	return &UploadResourceResponse{Id: i}, nil

}
