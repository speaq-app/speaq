package data

type ResourceService interface {
	ResourceByID(id int64) (Resource, error)
	UploadResource(res Resource) (int64, error)
}

type Resource struct {
	ID       int64
	Data     string
	Name     string
	MIMEType string
	Size     int64
}
