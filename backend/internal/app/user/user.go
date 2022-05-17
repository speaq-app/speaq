package user

import (
	"context"
	"log"

	"github.com/golang/protobuf/ptypes/empty"
	"github.com/speaq-app/speaq/internal/pkg/data"
	"google.golang.org/protobuf/types/known/emptypb"
)

type Server struct {
	DataService data.Service
	UnimplementedUserServer
}

func (s Server) UpdateUserProfile(ctx context.Context, req *UpdateUserProfileRequest) (*empty.Empty, error) {
	log.Printf("User with ID %d should be updated", req.UserId)

	p := data.UserProfile{
		Name:        req.Name,
		Username:    req.Username,
		Description: req.Description,
		Website:     req.Website,
	}

	log.Println(p)
	err := s.DataService.UpdateUserProfile(req.UserId, p)
	if err != nil {
		return nil, err
	}

	return &emptypb.Empty{}, nil
}

func (s Server) GetUserProfile(ctx context.Context, req *GetUserProfileRequest) (*GetUserProfileResponse, error) {
	log.Printf("User Profile with ID %d should be loaded", req.UserId)

	p, err := s.DataService.UserProfileByID(req.UserId)
	if err != nil {
		return nil, err
	}
	log.Println(p)

	return &GetUserProfileResponse{
		Name:                   p.Name,
		Username:               p.Username,
		Description:            p.Description,
		Website:                p.Website,
		ProfileImageBlurHash:   p.ProfileImageBlurHash,
		ProfileImageResourceId: p.ProfileImageResourceID,
	}, nil
}

func (s Server) Login(ctx context.Context, req *LoginRequest) (*LoginResponse, error) {
	p, err := s.DataService.Login(req.username, req.password)

	if err != nil {
		return nil, err
	}

	return &LoginResponse{
		ID: p.ID
		Profile: p.UserProfile
	}, nil
}

