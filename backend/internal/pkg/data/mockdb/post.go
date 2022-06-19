package mockdb

import (
	"log"
	"time"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

func (s service) PostsByID(id int64) ([]data.Post, error) {
	time.Sleep(s.delay)

	postList := []data.Post{}

	for _, dbpost := range s.posts {
		owner, err := s.UserByID(dbpost.OwnerID)
		if err != nil {
			return nil, err
		}

		dbpost.OwnerName = owner.Profile.Name
		dbpost.OwnerUsername = owner.Profile.Username

		log.Printf("Loading Post %v", dbpost)

		postList = append(postList, dbpost)
	}

	return postList, nil
}

func (s service) CreatePost(ownerID int64, post *data.Post) error {
	time.Sleep(s.delay)

	var nextID int64 = 1

	for id := range s.posts {
		if id >= nextID {
			nextID = id + 1
		}
	}

	post.ID = nextID
	post.Date = time.Now()
	post.OwnerID = ownerID

	s.posts[nextID] = *post

	log.Printf("Saved Post: %v", post)
	return nil

}
