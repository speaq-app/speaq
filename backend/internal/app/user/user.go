package user

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/dgrijalva/jwt-go"
	"golang.org/x/crypto/bcrypt"
	"log"
	"net/http"
	"time"

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
	hash, id, err := s.DataService.PasswordHashByUsername(req.Username)
	if err != nil {
		return nil, err
	}

	passwordValid := CheckPasswordHash(hash, req.Password)
	if !passwordValid {
		return nil, errors.New("wrong password")
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
		return "", errors.New("token couldn't be generated")
	}
	return tokenString, nil
}

/*func verifyToken(token string) (string, error) {

}
*/
func IsAuthorized(handler http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {

		if r.Header["Token"] == nil {

			err := errors.New("no Token Found")
			json.NewEncoder(w).Encode(err)
			return
		}

		var mySigningKey = []byte("Sheeesh")

		token, err := jwt.Parse(r.Header["Token"][0], func(token *jwt.Token) (interface{}, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, fmt.Errorf("there was an error in parsing")
			}
			return mySigningKey, nil
		})

		if err != nil {
			err := errors.New("your Token has been expired")
			json.NewEncoder(w).Encode(err)
			return
		}

		if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
			if claims["role"] == "admin" {

				r.Header.Set("Role", "admin")
				handler.ServeHTTP(w, r)
				return

			} else if claims["role"] == "user" {

				r.Header.Set("Role", "user")
				handler.ServeHTTP(w, r)
				return
			}
		}

		err = errors.New("not Authorized")
		json.NewEncoder(w).Encode(err)
	}
}
