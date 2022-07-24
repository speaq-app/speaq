package data

import (
	"time"
)

type UserService interface {
	UserByID(id int64) (User, error)
	//UserByUsername takes an username and returns the user with the given username.
	UserByUsername(username string) (User, error)
	//UpdateUserProfile takes an ID and a profile and updates the profile in the databse with the given one.
	//However the imageBlurHash and imageResourceID stay the same since for now changing the profile picture is not implemented.
	UpdateUserProfile(userID int64, profile UserProfile) error
	UserProfileByID(userID int64) (UserProfile, error)
	//PasswordHashByUsername takes an username and returns if the username is existing the matching passwordHash.
	PasswordHashByUsername(username string) ([]byte, error)

	//FollowerIDsByID takes an userID and returns a list of IDs which are following the given ID.
	FollowerIDsByID(userID int64) ([]int64, error)
	//FollowingIDsByID takes an userID and returns a list of IDs whom the given ID is following.
	FollowingIDsByID(userID int64) ([]int64, error)
	//CreateUser takes an username and passwordHash and creates, if the username is not already taken, a new user
	//with the next free userID and the given parameters.
	//It will also set the users name to the username which can be changed later in EditProfile.
	CreateUser(username string, passwordHash []byte) (User, error)

	//CheckIfFollowing takes an userID and a followerID.
	//It returns true or false whether the user with the followingID is following the user of userID.
	CheckIfFollowing(userID int64, followerID int64) (bool, int, error)
	//FollowUnfollow takes an userID and a followerID.
	//It checks whether the user of followerID is following the user of userID or not.
	//In case the follower was not following it follows the user, otherwise it unfollows.
	FollowUnfollow(userID int64, followerID int64) (bool, error)

	//UserByUserIDs takes a list of userIDs and returns a list of users matching the given IDs.
	UserByUserIDs(userIDs []int64) ([]User, error)

	//SearchUser takes an userID and a term and returns a list of users which contain the given term in their username.
	//The user with the given userID must not be in the returned list.
	SearchUser(userID int64, term string) ([]User, error)
}

type User struct {
	ID           int64
	Profile      UserProfile
	Password     []byte
	FollowerIDs  []int64
	FollowingIDs []int64
	ChatIDs      []int64
	CreatedAt    time.Time
}

type UserProfile struct {
	Name                   string
	Username               string
	Description            string
	Website                string
	ProfileImageBlurHash   string
	ProfileImageResourceID int64
	IsOwnProfile           bool
}
