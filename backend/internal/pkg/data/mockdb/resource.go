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
		return r, errors.New("not workin 1")
	}
	r.ID = id
	return r, nil
}

func (s service) nextResourceID() int64 {
	var nextID int64 = 1
	for id := range s.resources {
		if id >= nextID {
			nextID = id + 1
		}
	}
	return nextID
}

func (s service) CreateResource(dataa string, mimeType string) (data.Resource, error) {
	time.Sleep(s.delay)
	resourceID := s.nextResourceID()
	resource := data.Resource{
		ID:       resourceID,
		Data:     dataa,
		MIMEType: mimeType,
		Size:     int64(len(dataa)),
	}

	s.resources[resourceID] = resource

	return resource, nil
}
