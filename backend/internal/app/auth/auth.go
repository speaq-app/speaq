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

//Register takes a Password and Username from the RegisterRequest, 
//encrypts the password and creates a new account.
//Returns an error "AlreadyExists" in case an account with the same username is already taken.
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

//Login takes a Password and Username from the LoginRequest.
//First it gets the encrypted password via username.
//Then it encrypts the given password and compares it with the saved one.
//Lastly it gets the user by username, creates a Login-Token and returns it in LoginResponse.
//Returns an error "NotFound" if the username doesnt exist.
//Returns an error "InvalidArgument" if the password is wrong.
//Returns an error "Unauthenticated" if authentical metadata is invalid.
func (s Server) Login(ctx context.Context, req *LoginRequest) (*LoginResponse, error) {
	hash, err := s.UserService.PasswordHashByUsername(req.Username)
	if err != nil {
		log.Println(err)
		return nil, status.Error(codes.NotFound, err.Error())
	}

	passwordValid := s.EncryptionService.CompareHashAndPassword(hash, []byte(req.Password))
	if !passwordValid {
		log.Println(err)
		return nil, status.Error(codes.InvalidArgument, errors.New("wrong password").Error())
	}

	u, err := s.UserService.UserByUsername(req.Username)
	if err != nil {
		log.Println(err)
		return nil, status.Error(codes.NotFound, err.Error())
	}

	token, err := s.TokenService.GenerateForUserID(u.ID)
	if err != nil {
		log.Println(err)
		return nil, status.Error(codes.Unauthenticated, err.Error())
	}

	return &LoginResponse{
		Token: token,
	}, nil
}
