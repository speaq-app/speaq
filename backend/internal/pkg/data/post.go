package data

import "time"

type PostService interface {
	CreatePost(ownerID int64, post Post) error
	PostsByID(userID int64) ([]Post, error)
}

type Post struct {
	ID            int64
	OwnerID       int64
	Date          time.Time
	Description   string
	ResourceID    int64
	LikeIDs       []int64
	CommentIDs    []int64
	OwnerName     string
	OwnerUsername string
}
