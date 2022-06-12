package mockdb

import (
	"errors"
	"io/ioutil"
	"log"
	"time"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

type service struct {
	resources map[int64]data.Resource
	users     map[int64]data.User
	post      map[int64]data.Post
	delay     time.Duration
}

func New() data.Service {
	bb, err := ioutil.ReadFile("testImage.txt")
	if err != nil {
		log.Fatal(err)
	}
	bc, err := ioutil.ReadFile("testImage2.txt")
	if err != nil {
		log.Fatal(err)
	}
	return service{
		delay: time.Second,
		resources: map[int64]data.Resource{
			1: {ID: 1,
				Data:     string(bb),
				Name:     "testImage",
				MIMEType: "image/jpeg",
				Size:     83935,
			},
			2: {ID: 2,
				Data:     string(bc),
				Name:     "testImageKarl",
				MIMEType: "image/png",
				Size:     1111111,
			},
			3: {},
		},
		users: map[int64]data.User{
			1: {
				Profile: data.UserProfile{
					Name:        "Hendrik Schlehlein",
					Username:    "schlehlein",
					Description: "Test Description 1",
					Website:     "Test Website 1",
					//ProfileImageBlurHash:   "LKD0Jy_4_3xv4TMcR4wu?bR-bwIo", //ID 1

					ProfileImageBlurHash:   "U.N0^|WB~qjZ_3ofM|ae%MayWBayM{fkWBay", //ID 2
					ProfileImageResourceID: 2,
				},
			},
			2: {
				Profile: data.UserProfile{
					Name:                   "Daniel Holzwarth",
					Username:               "dholzwarth",
					Description:            "Test Description 2",
					Website:                "Test Website 2",
					ProfileImageBlurHash:   "LKD0Jy_4_3xv4TMcR4wu?bR-bwIo",
					ProfileImageResourceID: 1,
				},
			},
			3: {
				Profile: data.UserProfile{
					Name:                   "Nosakhare",
					Username:               "nomoruyi",
					Description:            "Test Description 3",
					Website:                "Test Website 3",
					ProfileImageBlurHash:   "LKD0Jy_4_3xv4TMcR4wu?bR-bwIo",
					ProfileImageResourceID: 1,
				},
			},
		},
		post: map[int64]data.Post{
			1: {
				ID:          1,
				OwnerID:     1,
				Date:        time.Now(),
				Description: "Mein erster Post",
				ResourceID:  1,
				LikeIDs: []int64{
					1,
					2,
					3,
				},
				CommentIDs: []int64{
					1,
					2,
				},
			},

			2: {
				ID:          2,
				OwnerID:     1,
				Date:        time.Now().Add(1 * time.Hour),
				Description: "Mein zweiter Post",
				ResourceID:  1,
				LikeIDs: []int64{
					1,
					2,
					3,
				},
				CommentIDs: []int64{
					1,
					2,
				},
			},

			3: {
				ID:          3,
				OwnerID:     2,
				Date:        time.Now().Add(5 * time.Hour),
				Description: "Mein dritter Post",
				ResourceID:  1,
				LikeIDs: []int64{
					1,
					2,
					3,
				},
				CommentIDs: []int64{
					1,
					2,
				},
			},
		},
	}
}

func (s service) ResourceByID(id int64) (data.Resource, error) {
	time.Sleep(s.delay)
	r, ok := s.resources[id]
	if !ok {
		return r, errors.New("not workin 1")
	}
	r.ID = id
	return r, nil
}

func (s service) UserByID(id int64) (data.User, error) {
	time.Sleep(s.delay)
	u, ok := s.users[id]
	if !ok {
		return u, errors.New("not workin 2")
	}
	u.ID = id
	return u, nil
}

func (s service) UpdateUserProfile(id int64, profile data.UserProfile) error {
	time.Sleep(s.delay)
	u, err := s.UserByID(id)
	if err != nil {
		return err
	}

	profile.ProfileImageBlurHash = u.Profile.ProfileImageBlurHash
	profile.ProfileImageResourceID = u.Profile.ProfileImageResourceID
	u.Profile = profile
	s.users[id] = u

	return nil
}

func (s service) UserProfileByID(id int64) (data.UserProfile, error) {
	time.Sleep(s.delay)
	u, err := s.UserByID(id)
	if err != nil {
		return data.UserProfile{}, err
	}

	return u.Profile, nil
}

func (s service) PostsByID(id int64) ([]data.Post, error) {
	time.Sleep(s.delay)
	
	postList := []data.Post{}

	p, ok := s.post[id]
	if !ok {
		return postList, errors.New("not workin 17")
	}

	postList = append(postList, p)

	return postList, nil
}

func (s service) CreatePost(id int64, post data.Post) error {
	time.Sleep(s.delay)
	/*
	c, err := s.PostByID(id)
	if err != nil {
		return err
	}
	s.post[id] = c

	log.Println(c)
	*/
	return nil
}
