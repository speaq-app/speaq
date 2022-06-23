package postgres

import (
	"github.com/speaq-app/speaq/internal/pkg/data"
)

func (s Service) UserByID(id int64) (data.User, error) {
	panic("implement me")
}

func (s Service) UserByUsername(username string) (data.User, error) {
	panic("implement me")
}

func (s Service) FollowerIDsByID(userID int64) ([]int64, error) {
	panic("implement me")
}

func (s Service) FollowingIDsByID(userID int64) ([]int64, error) {
	panic("implement me")
}

func (s Service) FollowerByIDs(userIDs []int64) ([]data.User, error) {
	panic("implement me")
}

func (s Service) FollowingByIDs(userIDs []int64) ([]data.User, error) {
	panic("implement me")
}

func (s Service) CheckIfFollowing(userID int64, followerID int64) (bool, int, error) {
	panic("implement me")
}

func (s Service) FollowUnfollow(userID int64, followID int64) (bool, error) {
	panic("implement me")
}

func (s Service) UpdateUserProfile(id int64, u data.UserProfile) error {
	panic("implement me")
}

func (s Service) UserProfileByID(id int64) (data.UserProfile, error) {
	panic("implement me")
}

func (s Service) PasswordHashByUsername(username string) ([]byte, error) {
	panic("implement me")
}

func (s Service) CreateUser(username string, passwordHash []byte) (data.User, error) {
	panic("implement me")
}
