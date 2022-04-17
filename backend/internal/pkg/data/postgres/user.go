package postgres

import (
	"context"

	"github.com/speak-app/speak/internal/pkg/data"
)


func (s Service) UserByID(id int64) (data.User, error) {
	ctx, cancel := context.WithTimeout(context.Background(), s.timeout)
	defer cancel()

	var u data.User
	if err := s.QueryRow(ctx, `
SELECT name, username, description, website, profile_picture_id
FROM users
WHERE id = $1;
`, id).Scan(&u.Name, &u.Username, &u.Description, &u.Website, &u.ProfilePictureID); err != nil {
		return u, err
	}

	return u, nil
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
