package post

import (
	"context"
	"log"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

type Server struct {
	DataService data.Service
	UnimplementedPostServer
}

func (s Server) CreatePost(ctx context.Context, req *CreatePostRequest) (*CreatePostResponse, error) {
	log.Printf("Post with ID %d should be updated", req.UserId)

	p := data.Post{
		ID:          req.Id,
		UserID:      req.UserId,
		Description: req.Description,
		Date:        req.Date,
	}

	log.Println(p)
	err := s.DataService.CreatePost(req.UserId, p)

	if err != nil {
		return nil, err
	}

	return &CreatePostResponse{
		Id:          p.ID,
		UserId:      p.UserID,
		Description: p.Description,
		Date:        p.Date,
	}, nil
}