package user

import (
	"context"
	"errors"
	"github.com/dgrijalva/jwt-go"
	"golang.org/x/crypto/bcrypt"
	"log"
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
func (s Server) GetUserFollowerIDs(ctx context.Context, req *GetUserProfileRequest) (*GetUserFollowerIDsResponse, error) {
	log.Printf("Follower with ID %d should be loaded", req.UserId)

	er, err := s.DataService.FollowerIDsByID(req.UserId)
	if err != nil {
		return nil, err
	}
	log.Println(er)

	return &GetUserFollowerIDsResponse{
		FollowerIds: er,
	}, nil
}

func (s Server) GetUserFollowingIDs(ctx context.Context, req *GetUserProfileRequest) (*GetUserFollowingIDsResponse, error) {
	log.Printf("Follower with ID %d should be loaded", req.UserId)

	ing, err := s.DataService.FollowingIDsByID(req.UserId)
	if err != nil {
		return nil, err
	}
	log.Println(ing)

	return &GetUserFollowingIDsResponse{
		FollowingIds: ing,
	}, nil
}

func (s Server) GetUserFollower(ctx context.Context, req *GetUserFollowerRequest) (*GetUserFollowerResponse, error) {
	log.Printf("Follower with ID %d should be loaded", req.FollowerIds)

	us, err := s.DataService.FollowerByIDs(req.FollowerIds)
	if err != nil {
		return nil, err
	}
	log.Println(us)

	var fu []*FollowUser

	for _, u := range us {

		fu = append(fu, &FollowUser{
			Id:       u.ID,
			Name:     u.Profile.Name,
			Username: u.Profile.Username,
		})
	}

	return &GetUserFollowerResponse{
		Follower: fu,
	}, nil
}

func (s Server) GetUserFollowing(ctx context.Context, req *GetUserFollowingRequest) (*GetUserFollowingResponse, error) {

	us, err := s.DataService.FollowingByIDs(req.FollowingIds)
	if err != nil {
		return nil, err
	}
	log.Println(us)

	var fu []*FollowUser

	for _, u := range us {

		fu = append(fu, &FollowUser{
			Id:       u.ID,
			Name:     u.Profile.Name,
			Username: u.Profile.Username,
		})
	}

	return &GetUserFollowingResponse{
		Following: fu,
	}, nil
}

func (s Server) CheckIfFollowing(ctx context.Context, req *CheckIfFollowingRequest) (*CheckIfFollowingResponse, error) {
	f, _, err := s.DataService.CheckIfFollowing(req.UserId, req.FollowerId)

	if err != nil {
		return nil, err
	}

	return &CheckIfFollowingResponse{
		IsFollowing: f,
	}, nil
}

func (s Server) FollowUnfollow(ctx context.Context, req *FollowUnfollowRequest) (*FollowUnfollowResponse, error) {
	f, err := s.DataService.FollowUnfollow(req.UserId, req.FollowerId)

	if err != nil {
		return nil, err
	}

	return &FollowUnfollowResponse{
		IsFollowing: f,
	}, nil
}

func (s Server) Login(ctx context.Context, req *LoginRequest) (*LoginResponse, error) {
	hash, id, err := s.DataService.PasswordHashAndIDByUsername(req.Username)
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
