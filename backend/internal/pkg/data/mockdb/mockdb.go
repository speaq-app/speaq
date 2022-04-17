package mockdb

import (
	"errors"

	"github.com/speak-app/speak/internal/pkg/data"
)

type service struct {
	resources map[int64]data.Resource
	users     map[int64]data.User
}

func New() data.Service {
	return service{
		resources: map[int64]data.Resource{
			1: {},
			2: {},
			3: {},
		},
		users: map[int64]data.User{
			1: {
				ProfilePictureID: 1,
				UserProfile: data.UserProfile{
					Name:        "Hendrik Schlehlein",
					Username:    "Hendrigo",
					Description: "Test Description 1",
					Website:     "Test Website 1",
				},
			},
			2: {
				ProfilePictureID: 2,
				UserProfile: data.UserProfile{
					Name:        "Daniel Holzwarth",
					Username:    "dholzwarth",
					Description: "Test Description 1",
					Website:     "Test Website 1",
				},
			},
			3: {
				ProfilePictureID: 3,
				UserProfile: data.UserProfile{
					Name:        "Nosakhare",
					Username:    "nomoruyi",
					Description: "Test Description 1",
					Website:     "Test Website 1",
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
	return nil
}
