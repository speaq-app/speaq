package mockdb

import (
	"errors"
	"time"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

func (s service) ResourceByID(id int64) (data.Resource, error) {
	time.Sleep(s.delay)
	r, ok := s.resources[id]
	if !ok {
		return r, errors.New("not workin resource load")
	}
	r.ID = id
	return r, nil
}
