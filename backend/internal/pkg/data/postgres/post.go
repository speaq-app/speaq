package postgres

import "github.com/speaq-app/speaq/internal/pkg/data"

func (s Service) CreatePost(ownerID int64, description string, resourceID int64, resourceMIMEType, resourceBlurHash string) (data.Post, error) {
	panic("implement me")
}

func (s Service) PostFeedFromFollowerIDs(userID []int64) ([]data.Post, error) {
	panic("implement me")
}

