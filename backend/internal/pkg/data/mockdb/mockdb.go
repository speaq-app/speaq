package mockdb

import (
	"errors"
	"io/ioutil"
	"log"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

type service struct {
	resources map[int64]data.Resource
	users     map[int64]data.User
}

func New() data.Service {
	bb, err := ioutil.ReadFile("testImage.txt")
	if err != nil {
		log.Fatal(err)
	}
	return service{
		resources: map[int64]data.Resource{
			1: {ID: 1,
				Data:     string(bb),
				Name:     "testImage",
				MIMEType: "image/jpeg",
				Size:     83935,
			},
			2: {},
			3: {},
		},
		users: map[int64]data.User{
			1: {
				Profile: data.UserProfile{
					Name:                   "Hendrik Schlehlein",
					Username:               "schlehlein",
					Description:            "Test Description 1",
					Website:                "Test Website 1",
					ProfileImageBlurHash:   "LKD0Jy_4_3xv4TMcR4wu?bR-bwIo",
					ProfileImageResourceID: 1,
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
	}
}

func (s service) ResourceByID(id int64) (data.Resource, error) {
	r, ok := s.resources[id]
	if !ok {
		return r, errors.New("not workin 1")
	}
	r.ID = id
	return r, nil
}

func (s service) UserByID(id int64) (data.User, error) {
	u, ok := s.users[id]
	if !ok {
		return u, errors.New("not workin 2")
	}
	u.ID = id
	return u, nil
}

func (s service) UpdateUserProfile(id int64, profile data.UserProfile) error {
	u, err := s.UserByID(id)
	if err != nil {
		return err
	}

	u.Profile = profile
	s.users[id] = u

	return nil
}

func (s service) UserProfileByID(id int64) (data.UserProfile, error) {
	u, err := s.UserByID(id)
	if err != nil {
		return data.UserProfile{}, err
	}

	return u.Profile, nil
}
