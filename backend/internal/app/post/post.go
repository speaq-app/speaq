package post

import (
	"context"
	"log"

	"github.com/speaq-app/speaq/internal/pkg/data"
	"google.golang.org/protobuf/types/known/emptypb"
)

type Server struct {
	DataService data.Service
	UnimplementedPostServer
}

func (s Server) CreatePost(ctx context.Context, req *CreatePostRequest) (*CreatePostResponse, error) {
	log.Printf("Post with ID %d should be updated", req.UserId)

	p := data.Post{
		ID:   req.UserId,
		Post: req.PostInfo{},
	}

	log.Println(p)
	err := s.DataService.CreatePost(req.UserId, p)
	if err != nil {
		return nil, err
	}

	return &emptypb.Empty{}, nil
}
