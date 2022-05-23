package post

import "context"

type Server struct {
	UnimplementedPostServer
}

func (s Server) CreatePost(ctx context.Context, req *CreatePostRequest) (*CreatePostResponse, error) {

	return &CreatePostResponse{
		Id: 1,
	}, nil
}