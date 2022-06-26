package mockdb

import (
	"time"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

func (s service) PostFeedForUserID(userID int64) ([]data.Post, error) {
	var posts []data.Post
	for _, post := range s.posts {
		posts = append(posts, post)
	}
	return posts, nil
}

func (s service) PostFeedFromFollowerIDs(followerIDs []int64) ([]data.Post, error) {
	var posts []data.Post
	for _, post := range s.posts {
		for _, followerID := range followerIDs {
			if followerID == post.OwnerID {
				posts = append(posts, post)
			}
		}
	}
	return posts, nil
}

func (s service) nextPostID() int64 {
	var nextID int64 = 1
	for id := range s.posts {
		if id >= nextID {
			nextID = id + 1
		}
	}
	return nextID
}

func (s service) CreatePost(ownerID int64, description string, resourceID int64, resourceMIMEType string) (data.Post, error) {
	postID := s.nextPostID()
	post := data.Post{
		ID:               postID,
		OwnerID:          ownerID,
		CreatedAt:        time.Now(),
		Description:      description,
		ResourceID:       resourceID,
		ResourceMimeType: resourceMIMEType,
		LikeIDs:          []int64{},
		CommentIDs:       []int64{},
	}
	s.posts[postID] = post

	return post, nil
}
