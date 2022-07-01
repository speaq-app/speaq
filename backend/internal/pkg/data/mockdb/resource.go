package mockdb

import (
	"errors"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

//ResourceByID takes an ID and returns the Post with the same PostID from the database.
func (s service) ResourceByID(id int64) (data.Resource, error) {
	r, ok := s.resources[id]
	if !ok {
		return r, errors.New("not workin resource load")
	}
	r.ID = id
	return r, nil
}

//CreateResource takes the resourceData as bytes, a mimeType and audioDuration and creates depending on 
//nextResourceID() a new resource in the database.
func (s service) CreateResource(bb []byte, mimeType string, audioDuration int64) (data.Resource, error) {
	resourceID := s.nextResourceID()
	resource := data.Resource{
		ID:            resourceID,
		Data:          bb,
		MIMEType:      mimeType,
		AudioDuration: audioDuration,
	}

	s.resources[resourceID] = resource

	return resource, nil
}

//nextResoureID returns the next free resourceID in the database.
func (s service) nextResourceID() int64 {
	var nextID int64 = 1
	for id := range s.resources {
		if id >= nextID {
			nextID = id + 1
		}
	}
	return nextID
}
