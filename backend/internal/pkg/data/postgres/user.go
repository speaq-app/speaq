package postgres

import (
	"context"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

func (s Service) UserByID(id int64) (data.User, error) {
	ctx, cancel := context.WithTimeout(context.Background(), s.timeout)
	defer cancel()

	var u data.User
	if err := s.QueryRow(ctx, `
SELECT name, username, description, website, profile_picture_id
FROM users
WHERE id = $1;
`, id).Scan(&u.Profile.Name, &u.Profile.Username, &u.Profile.Description, &u.Profile.Website); err != nil {
		return u, err
	}

	return u, nil
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

	return []int64{}, nil
}
func (s Service) FollowingIDsByID(userID int64) ([]int64, error) {
	panic("implement me")

	return []int64{}, nil
}

func (s Service) FollowerByIDs(userIDs []int64) ([]data.User, error) {
	//TODO implement me
	panic("implement me")
	return []data.User{}, nil
}

func (s Service) FollowingByIDs(userIDs []int64) ([]data.User, error) {
	//TODO implement me
	panic("implement me")
	return []data.User{}, nil
}

func (s Service) CheckIfFollowing(userID int64, followerID int64) (bool, int, error) {
	panic("implement me")

	return false, 0, nil
}

func (s Service) FollowUnfollow(userID int64, followID int64) (bool, error) {
	panic("implement me")

	return false, nil
}

func remove(s []int64, i int) []int64 {
	s[i] = s[len(s)-1]
	return s[:len(s)-1]
}

func (s Service) UpdateUserProfile(id int64, u data.UserProfile) error {

	// UPDATE user
	// SET 	name = u.name,
	// 		username = u.Username
	// 		description = u.Description
	// 		website = u.Website
	// WHERE id = id;

	return nil
}

func (s Service) UserProfileByID(id int64) (data.UserProfile, error) {
	return data.UserProfile{}, nil
}
func (s Service) PasswordHashAndIDByUsername(username string) ([]byte, int64, error) {

	//TODO implement me
	panic("implement me")

	return nil, 0, nil
}

func (s Service) CreateUser(username string, passwordHash []byte) (data.User, error) {
	return data.User{}, nil
}
