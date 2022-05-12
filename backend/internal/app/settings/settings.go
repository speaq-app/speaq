package settings

import (
	context "context"

	"github.com/golang/protobuf/ptypes/empty"
)

type Server struct {
	ImprintURL string
	UnimplementedSettingsServer
}

func (s Server) GetImprintURL(ctx context.Context, req *empty.Empty) (*GetImprintResponse, error) {
	return &GetImprintResponse{
		Url: s.ImprintURL,
	}, nil
}
