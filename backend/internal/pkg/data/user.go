package data

type UserService interface {
	UserByID(id int64) (User, error)
}

type User struct {
	ID               int64
	Username         string
	ProfilePictureID int64
}
