package data

import "time"

type PostService interface {
	CreatePost(ownerID int64, description string, resiourceID int64, resourceMIMEType string) (Post, error)
	PostFeedForUserID(userID int64) ([]Post, error)
}

type Post struct {
	ID               int64
	OwnerID          int64
	CreatedAt        time.Time
	Description      string
	ResourceID       int64
	ResourceMimeType string
	LikeIDs          []int64
	CommentIDs       []int64
}
