package auth

import (
	"context"

	"github.com/golang/protobuf/ptypes/empty"
	"github.com/speaq-app/speaq/internal/pkg/data"
	"github.com/speaq-app/speaq/internal/pkg/encryption"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type Server struct {
	EncryptionService encryption.Service
	UserService       data.UserService
	UnimplementedAuthServer
}

func (s Server) Register(ctx context.Context, req *RegisterRequest) (*empty.Empty, error) {
	hash, err := s.EncryptionService.GenerateFromPassword([]byte(req.Password))
	if err != nil {
		return nil, err
	}

	_, err = s.UserService.CreateUser(req.Username, hash)
	if err != nil {
		return nil, status.Error(codes.AlreadyExists, err.Error())
	}

	return &empty.Empty{}, nil
}
