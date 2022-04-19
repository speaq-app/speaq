package data

type ResourceService interface {
	ResourceByID(id int64) (Resource, error)
}

type Resource struct {
	ID       int64
	Data     []byte
	Name     string
	MIMEType string
	Size     int64
}
