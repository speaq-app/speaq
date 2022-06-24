package data

type ResourceService interface {
	ResourceByID(id int64) (Resource, error)
	CreateResource(resourceData string, mimeType string, audioDuration int64) (Resource, error)
}

type Resource struct {
	ID            int64
	Data          string
	MIMEType      string
	AudioDuration int64
}
