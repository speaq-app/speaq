package data

type ResourceService interface {
	ResourceByID(id int64) (Resource, error)
	CreateResource(data []byte, mimeType string) (Resource, error)
}

type Resource struct {
	ID       int64
	Data     string
	MIMEType string
	Size     int64
}
