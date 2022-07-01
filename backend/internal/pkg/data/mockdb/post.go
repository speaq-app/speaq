package mockdb

import (
	"sort"
	"time"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

func (s *service) PostFeedForUserID(userID int64) ([]data.Post, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	var posts []data.Post
	for _, post := range s.posts {
		posts = append(posts, post)
	}
	return posts, nil
}

func (s *service) PostFeedFromFollowerIDs(followerIDs []int64) ([]data.Post, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	var posts []data.Post
	for _, post := range s.posts {
		for _, followerID := range followerIDs {
			if followerID == post.OwnerID {
				posts = append(posts, post)
			}
		}
	}

	sort.Slice(posts, func(i, j int) bool {
		return posts[i].CreatedAt.After(posts[j].CreatedAt)
	})

	return posts, nil
}

func (s *service) nextPostID() int64 {
	var nextID int64 = 1
	for id := range s.posts {
		if id >= nextID {
			nextID = id + 1
		}
	}
	return nextID
}

func (s *service) CreatePost(ownerID int64, description string, resourceID int64, resourceMIMEType, resourceBlurHash string) (data.Post, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	postID := s.nextPostID()
	post := data.Post{
		ID:               postID,
		OwnerID:          ownerID,
		CreatedAt:        time.Now(),
		Description:      description,
		ResourceID:       resourceID,
		ResourceMimeType: resourceMIMEType,
		ResourceBlurHash: resourceBlurHash,
		LikeIDs:          []int64{},
		CommentIDs:       []int64{},
	}
	s.posts[postID] = post

	return post, nil
}