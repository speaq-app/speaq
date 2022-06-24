package auth

import (
	"context"
	"errors"
	"log"

	"github.com/golang/protobuf/ptypes/empty"
	"github.com/speaq-app/speaq/internal/pkg/data"
	"github.com/speaq-app/speaq/internal/pkg/encryption"
	"github.com/speaq-app/speaq/internal/pkg/token"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type Server struct {
	TokenService      token.Service
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

func (s Server) Login(ctx context.Context, req *LoginRequest) (*LoginResponse, error) {
	hash, err := s.UserService.PasswordHashByUsername(req.Username)
	if err != nil {
		log.Println(err)
		return nil, status.Error(codes.NotFound, err.Error())
	}

	passwordValid := s.EncryptionService.CompareHashAndPassword(hash, []byte(req.Password))
	if !passwordValid {
		log.Println(err)
		log.Println("1")
		return nil, status.Error(codes.PermissionDenied, errors.New("password invalid").Error())
	}

	u, err := s.UserService.UserByUsername(req.Username)
	if err != nil {
		log.Println(err)
		log.Println("2")
		return nil, status.Error(codes.NotFound, err.Error())
	}

	userToken, err := s.TokenService.GenerateForUserID(u.ID)
	if err != nil {
		log.Println(err)
		log.Println("3")

		return nil, status.Error(codes.Unauthenticated, err.Error())
	}

	return &LoginResponse{
		UserId: u.ID,
		Token:  userToken,
	}, nil
}
