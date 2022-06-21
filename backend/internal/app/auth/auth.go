package auth

import (
	"context"
	"github.com/dgrijalva/jwt-go"
	"golang.org/x/crypto/bcrypt"
	"time"

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

func (s Server) Login(ctx context.Context, req *LoginRequest) (*LoginResponse, error) {
	hash, id, err := s.UserService.PasswordHashAndIDByUsername(req.Username)
	if err != nil {
		return nil, status.Error(codes.NotFound, err.Error())
	}

	passwordValid := CheckPasswordHash(hash, req.Password)
	if !passwordValid {
		return nil, status.Error(codes.Unauthenticated, err.Error())
	}

	/*	if err := bcrypt.CompareHashAndPassword(hash, []byte(req.Password)); err != nil {
			return nil, errors.New("wrong password")
		}
	*/
	token, err := GenerateJWT(req.Username, "User")
	if err != nil {
		return nil, err
	}

	return &LoginResponse{
		UserId: id,
		Token:  token,
	}, nil
}

func CheckPasswordHash(hash []byte, password string) bool {
	err := bcrypt.CompareHashAndPassword(hash, []byte(password))
	return err == nil
}

func GenerateJWT(username, role string) (string, error) {
	mySigningKey := []byte("Sheeesh")
	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)

	claims["authorized"] = true
	claims["username"] = username
	claims["role"] = role
	claims["exp"] = time.Now().Add(time.Hour * 24 * 7).Unix()

	tokenString, err := token.SignedString(mySigningKey)

	if err != nil {
		return "", status.Error(codes.Internal, err.Error())
	}
	return tokenString, nil
}
