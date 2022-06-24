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

func (s Service) UsersByUsername(term string) ([]data.User, error) {
	/*
			ctx, cancel := context.WithTimeout(context.Background(), s.timeout)
			defer cancel()

			var u []data.User

			if err := s.QueryRow(ctx, `
		SELECT name, username, description, website, profile_picture_id
		FROM users
		WHERE username LIKE $1;
		`, username).Scan(&u.Profile.Name, &u.Profile.Username, &u.Profile.Description, &u.Profile.Website); err != nil {
				return u, err
			}
		return u, nil
	*/

	panic("implement me")

	return []data.User{}, nil

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
