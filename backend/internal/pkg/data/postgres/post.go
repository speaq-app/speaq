package postgres

import "github.com/speaq-app/speaq/internal/pkg/data"

func (s Service) CreatePost(post data.Post) error {

	return nil
}

func (s Service) PostByID(userID int64) (data.Post, error) {

	return data.Post{}, nil
}
