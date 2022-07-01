package user

import (
	"context"

	"github.com/golang/protobuf/ptypes/empty"
	"github.com/speaq-app/speaq/internal/pkg/data"
	"github.com/speaq-app/speaq/internal/pkg/middleware"
	"google.golang.org/protobuf/types/known/emptypb"
)

type Server struct {
	DataService data.Service
	UnimplementedUserServer
}

//UpdateUserProfile takes a name, username, description and website and creates a UserProfile with it.
//Then it gets the userID of the logged in user from context.
//After getting the userID it updates the UserProfile taking the userID and created profile.
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

//GetUSerProfile takes a userID.
//First it gets the userID of the logged in user from context.
//Then it checks whether or not the profile of the logged in user is requested.
//Lastly it gets the profile with the userID and returns it in GetUserProfileResponse with a parameter indicating if its the logged in user or not.
func (s Server) GetUserProfile(ctx context.Context, req *GetUserProfileRequest) (*GetUserProfileResponse, error) {
	var op bool

	var reqUserID int64

	appUserID, err := middleware.GetUserIDFromContext(ctx)
	if err != nil {
		return nil, err
	}

	if req.UserId <= 0 || req.UserId == appUserID {
		reqUserID = appUserID
		op = true
	} else {
		reqUserID = req.UserId
		op = false
	}

	p, err := s.DataService.UserProfileByID(reqUserID)
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
		IsOwnProfile:           op,
	}, nil
}

//GetUserFollowerIDs takes a userID and checks whether its the logged in user or not.
//In case its the logged in user it gets the corresponding userID from the database.
//Finally it gets a List of IDs whom the user is following and returns it in GetUserFollowerIDsResponse.
func (s Server) GetUserFollowerIDs(ctx context.Context, req *GetUserProfileRequest) (*GetUserFollowerIDsResponse, error) {
	userID := req.UserId

	if userID <= 0 {
		var err error
		userID, err = middleware.GetUserIDFromContext(ctx)
		if err != nil {
			return nil, err
		}
	}

	er, err := s.DataService.FollowerIDsByID(userID)
	if err != nil {
		return nil, err
	}

	return &GetUserFollowerIDsResponse{
		FollowerIds: er,
	}, nil
}

//GetUserFollowingIDs takes a userID and checks whether its the logged in user or not.
//In case its the logged in user it gets the corresponding userID from the database.
//Then it gets the List of users the user is following to and returns it in GetUserFollowingIDsResponse.
func (s Server) GetUserFollowingIDs(ctx context.Context, req *GetUserProfileRequest) (*GetUserFollowingIDsResponse, error) {
	userID := req.UserId

	if userID <= 0 {
		var err error
		userID, err = middleware.GetUserIDFromContext(ctx)
		if err != nil {
			return nil, err
		}
	}

	ing, err := s.DataService.FollowingIDsByID(userID)
	if err != nil {
		return nil, err
	}

	return &GetUserFollowingIDsResponse{
		FollowingIds: ing,
	}, nil
}

//GetUserFollower takes takes a list of followerIDs which are used to get the users of the corresponding given ids.
//Based on the data CondensedUsers are created and returned in CondensedUserListResponse.
func (s Server) GetUserFollower(ctx context.Context, req *GetUserFollowerRequest) (*CondensedUserListResponse, error) {
	us, err := s.DataService.UserByUserIDs(req.FollowerIds)
	if err != nil {
		return nil, err
	}

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

//GetUserFollowing takes takes a list of followingIDs which are used to get the users of the corresponding given ids.
//Based on the data CondensedUsers are created and returned in CondensedUserListResponse.
func (s Server) GetUserFollowing(ctx context.Context, req *GetUserFollowingRequest) (*CondensedUserListResponse, error) {
	us, err := s.DataService.UserByUserIDs(req.FollowingIds)
	if err != nil {
		return nil, err
	}

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

//CheckIfFollowing takes a userID and followerID and checks whether userID is the logged in user or not.
//In case its the logged in user it gets the corresponding userID from the database.
//Then it checks if the user of followerID is following the user of userID and returns true or false.
func (s Server) CheckIfFollowing(ctx context.Context, req *CheckIfFollowingRequest) (*IsFollowingResponse, error) {
	userID := req.UserId

	if userID <= 0 {
		var err error
		userID, err = middleware.GetUserIDFromContext(ctx)
		if err != nil {
			return nil, err
		}
	}

	f, _, err := s.DataService.CheckIfFollowing(userID, req.FollowerId)
	if err != nil {
		return nil, err
	}

	return &IsFollowingResponse{
		IsFollowing: f,
	}, nil
}

//FollowUnfollow takes a userID and followerID and checks whether userID is the logged in user or not.
//In case its the logged in user it gets the corresponding userID from the database.
//After that it checks wheteher the user of followerID is following the user of userID, changes its state and returns the value (true/false).
func (s Server) FollowUnfollow(ctx context.Context, req *FollowUnfollowRequest) (*IsFollowingResponse, error) {
	userID := req.UserId

	if userID <= 0 {
		var err error
		userID, err = middleware.GetUserIDFromContext(ctx)
		if err != nil {
			return nil, err
		}
	}

	f, err := s.DataService.FollowUnfollow(userID, req.FollowerId)
	if err != nil {
		return nil, err
	}

	return &IsFollowingResponse{
		IsFollowing: f,
	}, nil
}

//SearchUser takes a string in SearchUserRequest.
//First it gets the logged in user from context.
//Then it searches for all users matching the given term using regex ignoring the logged in user himself.
//The list of CondensedUsers is than returned in CondensedUserListResponse.
func (s Server) SearchUser(ctx context.Context, req *SearchUserRequest) (*CondensedUserListResponse, error) {
	userID, err := middleware.GetUserIDFromContext(ctx)
	if err != nil {
		return nil, err
	}

	u, err := s.DataService.SearchUser(userID, req.Term)
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
