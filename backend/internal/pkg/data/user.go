package data

type UserService interface {
	UserByID(id int64) (User, error)
	UpdateUserProfile(userID int64, profile UserProfile) error
	UserProfileByID(userID int64) (UserProfile, error)
	FollowerIDsByID(userID int64) ([]int64, error)
	FollowingIDsByID(userID int64) ([]int64, error)

	FollowerByIDs(userIDs []int64) ([]User, error)
	FollowingByIDs(userIDs []int64) ([]User, error)
}

type User struct {
	ID int64

	Profile UserProfile
	//Settings    UserSettings
	FollowerIDs  []int64
	FollowingIDs []int64

	//FolloweeIDs []int64
	//PostIDs     []int64
}

type UserProfile struct {
	Name                   string
	Username               string
	Description            string
	Website                string
	ProfileImageBlurHash   string
	ProfileImageResourceID int64
}

/*type UserSettings struct {
	Darkmode bool
	Language string
}*/
