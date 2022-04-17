package data

type UserService interface {
	UserByID(id int64) (User, error)
	UpdateUserProfile(id int64, profile UserProfile) error
}

type User struct {
	ID int64
	ProfilePictureID int64

	UserProfile
}

type UserProfile struct {
	Name        string
	Username    string
	Description string
	Website     string
}
