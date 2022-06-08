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
func (s Service) FollowerIDsByID(userID int64) ([]int64, error) {
	return []int64{}, nil
}
func (s Service) FollowingIDsByID(userID int64) ([]int64, error) {
	return []int64{}, nil
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
