package user

import (
	"context"
	"log"

	"github.com/golang/protobuf/ptypes/empty"
	"github.com/speaq-app/speaq/internal/pkg/data"
	"github.com/speaq-app/speaq/internal/pkg/middleware"
	"google.golang.org/protobuf/types/known/emptypb"
)

type Server struct {
	DataService data.Service
	UnimplementedUserServer
}

func (s Server) UpdateUserProfile(ctx context.Context, req *UpdateUserProfileRequest) (*empty.Empty, error) {
	p := data.UserProfile{
		Name:        req.Name,
		Username:    req.Username,
		Description: req.Description,
		Website:     req.Website,
	}

	userID, err := middleware.GetUserIDFromContext(ctx)
	if err != nil {
		return nil, err
	}

	err = s.DataService.UpdateUserProfile(userID, p)
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

func (s Server) GetUserFollower(ctx context.Context, req *GetUserFollowerRequest) (*CondensedUserListResponse, error) {
	log.Printf("Follower with ID %d should be loaded", req.FollowerIds)

	us, err := s.DataService.FollowerByIDs(req.FollowerIds)
	if err != nil {
		return nil, err
	}
	log.Println(us)

	var fu []*CondensedUser

	for _, u := range us {

		fu = append(fu, &CondensedUser{
			Id:                     u.ID,
			Name:                   u.Profile.Name,
			Username:               u.Profile.Username,
			ProfileImageBlurHash:   u.Profile.ProfileImageBlurHash,
			ProfileImageResourceId: u.Profile.ProfileImageResourceID,
		})
	}

	return &CondensedUserListResponse{
		Users: fu,
	}, nil
}

func (s Server) GetUserFollowing(ctx context.Context, req *GetUserFollowingRequest) (*CondensedUserListResponse, error) {

	us, err := s.DataService.FollowingByIDs(req.FollowingIds)
	if err != nil {
		return nil, err
	}
	log.Println(us)

	var fu []*CondensedUser

	for _, u := range us {

		fu = append(fu, &CondensedUser{
			Id:                     u.ID,
			Name:                   u.Profile.Name,
			Username:               u.Profile.Username,
			ProfileImageBlurHash:   u.Profile.ProfileImageBlurHash,
			ProfileImageResourceId: u.Profile.ProfileImageResourceID,
		})
	}

	return &CondensedUserListResponse{
		Users: fu,
	}, nil
}

func (s Server) CheckIfFollowing(ctx context.Context, req *CheckIfFollowingRequest) (*IsFollowingResponse, error) {
	f, _, err := s.DataService.CheckIfFollowing(req.UserId, req.FollowerId)

	if err != nil {
		return nil, err
	}

	return &IsFollowingResponse{
		IsFollowing: f,
	}, nil
}

func (s Server) FollowUnfollow(ctx context.Context, req *FollowUnfollowRequest) (*IsFollowingResponse, error) {
	f, err := s.DataService.FollowUnfollow(req.UserId, req.FollowerId)

	if err != nil {
		return nil, err
	}

	return &IsFollowingResponse{
		IsFollowing: f,
	}, nil
}

func (s Server) UsersByUsername(ctx context.Context, req *SearchUserRequest) (*CondensedUserListResponse, error) {
	u, err := s.DataService.UsersByUsername(req.Term)

	if err != nil {
		return nil, err
	}

	var cu []*CondensedUser

	for _, user := range u {
		cu = append(cu, &CondensedUser{
			Id:                     user.ID,
			Name:                   user.Profile.Name,
			Username:               user.Profile.Username,
			ProfileImageBlurHash:   user.Profile.ProfileImageBlurHash,
			ProfileImageResourceId: user.Profile.ProfileImageResourceID,
		})
	}

	return &CondensedUserListResponse{
		Users: cu,
	}, nil
}

/*func verifyToken(token string) (string, error) {

}
*/
