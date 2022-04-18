package mockdb

import (
	"errors"

	"github.com/speaq-app/speaq/internal/pkg/data"
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
				Username:         "Hendrik",
				ProfilePictureID: 1,
			},
			2: {
				Username:         "Daniel",
				ProfilePictureID: 2,
			},
			3: {
				Username:         "Nosa",
				ProfilePictureID: 3,
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
