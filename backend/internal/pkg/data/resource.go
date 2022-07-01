package data

type ResourceService interface {
	ResourceByID(id int64) (Resource, error)
	CreateResource(data []byte, mimeType string, audioDuration int64) (Resource, error)
}

type Resource struct {
	ID            int64
	Data          []byte
	MIMEType      string
	AudioDuration int64
}
