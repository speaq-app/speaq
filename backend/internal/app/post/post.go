package post

import (
	"context"
	"log"
	"time"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

type Server struct {
	DataService data.Service
	UnimplementedPostServer
}

func (s Server) CreatePost(ctx context.Context, req *CreatePostRequest) (*CreatePostResponse, error) {
	log.Printf("Post with ID %d should be updated", req.UserId)

	p := data.Post{
		UserID:      req.UserId,
		Description: req.Description,
		ResourceID:  req.ResourceId,
		Date:        time.Now().String(),
	}

	log.Println(p)
	err := s.DataService.CreatePost(p)

	if err != nil {
		return nil, err
	}

	return &CreatePostResponse{
		Id:          p.ID,
		UserId:      p.UserID,
		Description: p.Description,
		ResourceId:  p.ResourceID,
		Date:        p.Date,
	}, nil
}

func (s Server) GetPost(ctx context.Context, req *GetPostRequest) (*GetPostResponse, error) {
	log.Printf("Getting post with ID %d", req.Id)

	p, err := s.DataService.PostByID(req.Id)
	log.Println(p)

	if err != nil {
		return nil, err
	}

	return &GetPostResponse{
		Id:          p.ID,
		UserId:      p.UserID,
		Description: p.Description,
		ResourceId:  p.ResourceID,
		Date:        p.Date,
	}, nil
}
