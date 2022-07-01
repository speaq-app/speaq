package data

import "time"

type PostService interface {
	CreatePost(ownerID int64, description string, resourceID int64, resourceMIMEType, resourceBlurHash string) (Post, error)
	PostFeedFromFollowerIDs(followerIDs []int64) ([]Post, error)
}

type Post struct {
	ID               int64
	OwnerID          int64
	CreatedAt        time.Time
	Description      string
	ResourceID       int64
	ResourceMimeType string
	ResourceBlurHash string
	LikeIDs          []int64
	CommentIDs       []int64
}
