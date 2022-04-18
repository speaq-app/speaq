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
SELECT username, profile_picture_id
FROM users
WHERE id = $1;
`, id).Scan(&u.Username, &u.ProfilePictureID); err != nil {
		return u, err
	}

	return u, nil
}
