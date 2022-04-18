package user

import (
	"context"
	"log"

	"github.com/golang/protobuf/ptypes/empty"
	"github.com/speak-app/speak/internal/pkg/data"
	"google.golang.org/protobuf/types/known/emptypb"
)

type Server struct {
	DataService data.Service
	UnimplementedUserServer
}

func (s Server) UpdateUserProfile(ctx context.Context, req *UpdateUserProfileRequest) (*empty.Empty, error) {
	log.Printf("User with ID %d should be updated", req.UserId)

	p := data.UserProfile{
		Name: req.Name, 
		Username: req.Username, 
		Description: req.Description, 
		Website: req.Website,
	}
	log.Println(p)
	err := s.DataService.UpdateUserProfile(req.UserId, p)
	if err != nil {
		return nil, err
	}

	return &emptypb.Empty{}, nil
}

