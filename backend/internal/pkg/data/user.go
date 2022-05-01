package data

type UserService interface {
	UserByID(id int64) (User, error)
	UpdateUserProfile(userID int64, profile UserProfile) error
	UserProfileByID(userID int64) (UserProfile, error)
}

type User struct {
	ID int64

	Profile UserProfile
}

type UserProfile struct {
	Name                   string
	Username               string
	Description            string
	Website                string
	ProfileImageBlurHash   string
	ProfileImageResourceID int64
}
