package data

type UserService interface {
	UserByID(id int64) (User, error)
	UserByUsername(username string) (User, error)
	UpdateUserProfile(userID int64, profile UserProfile) error
	UserProfileByID(userID int64) (UserProfile, error)
	PasswordHashByUsername(username string) ([]byte, error)
	FollowerIDsByID(userID int64) ([]int64, error)
	FollowingIDsByID(userID int64) ([]int64, error)
	CreateUser(username string, passwordHash []byte) (User, error)

	CheckIfFollowing(userID int64, followerID int64) (bool, int, error)
	FollowUnfollow(userID int64, followerID int64) (bool, error)

	FollowerByIDs(userIDs []int64) ([]User, error)
	FollowingByIDs(userIDs []int64) ([]User, error)
}

type User struct {
	ID       int64
	Profile  UserProfile
	Password []byte
	//Settings    UserSettings
	FollowerIDs  []int64
	FollowingIDs []int64
}

type UserProfile struct {
	Name                   string
	Username               string
	Description            string
	Website                string
	ProfileImageBlurHash   string
	ProfileImageResourceID int64
}

/*type UserLogin struct {
	Username string
	Password string
}*/

/*type UserSettings struct {
	Darkmode bool
	Language string
}*/
