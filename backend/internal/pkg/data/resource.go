package data

type ResourceService interface {
	ResourceByID(id int64) (Resource, error)
	CreateResource(data string, mimeType string) (Resource, error)
}

type Resource struct {
	ID       int64
	Data     string
	MIMEType string
	Size     int64
}
