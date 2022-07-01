package mockdb

import (
	"errors"
	"strings"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

//FollowerIDsByID takes an userID and returns a list of IDs which are following the given ID.
func (s service) FollowerIDsByID(userID int64) ([]int64, error) {
	u, ok := s.users[userID]
	if !ok {
		return nil, errors.New("followers by ID not working")
	}
	u.ID = userID
	return u.FollowerIDs, nil
}

//FollowingIDsByID takes an userID and returns a list of IDs whom the given ID is following.
func (s service) FollowingIDsByID(userID int64) ([]int64, error) {
	u, ok := s.users[userID]
	if !ok {
		return nil, errors.New("following by ID not working")
	}
	u.ID = userID
	return u.FollowingIDs, nil
}


//UserByUserIDs takes a list of userIDs and returns a list of users matching the given IDs.
func (s service) UserByUserIDs(userIDs []int64) ([]data.User, error) {
	var ul []data.User
	for _, u := range userIDs {
		ul = append(ul, s.users[u])
	}

	return ul, nil
}

func (s service) UserByID(id int64) (data.User, error) {
	u, ok := s.users[id]
	if !ok {
		return u, errors.New("UserByID - user not found")
	}
	u.ID = id
	return u, nil
}

//UserByUsername takes an username and returns the user with the given username.
func (s service) UserByUsername(username string) (data.User, error) {
	for _, u := range s.users {
		if u.Profile.Username == username {
			return u, nil
		}
	}
	return data.User{}, errors.New("UserByUsername - user not found")
}

//SearchUser takes an userID and a term and returns a list of users which contain the given term in their username.
//The user with the given userID must not be in the returned list.
func (s service) SearchUser(userID int64, term string) ([]data.User, error) {
	var u []data.User

	for _, user := range s.users {
		if user.ID != userID {
			if strings.Contains(strings.ToLower(user.Profile.Username), strings.ToLower(term)) || strings.Contains(strings.ToLower(user.Profile.Name), strings.ToLower(term)) {
				u = append(u, user)
			}
		}
	}

	return u, nil
}

//UpdateUserProfile takes an ID and a profile and updates the profile in the databse with the given one.
//However the imageBlurHash and imageResourceID stay the same since for now changing the profile picture is not implemented.
func (s service) UpdateUserProfile(id int64, profile data.UserProfile) error {
	u, err := s.UserByID(id)
	if err != nil {
		return err
	}

	profile.ProfileImageBlurHash = u.Profile.ProfileImageBlurHash
	profile.ProfileImageResourceID = u.Profile.ProfileImageResourceID
	u.Profile = profile
	s.users[id] = u

	return nil
}

func (s service) UserProfileByID(id int64) (data.UserProfile, error) {
	u, err := s.UserByID(id)
	if err != nil {
		return data.UserProfile{}, err
	}

	return u.Profile, nil
}

//nextUserID returns the next free userID from the database.
func (s service) nextUserID() int64 {
	var nextID int64 = 1
	for id := range s.users {
		if id >= nextID {
			nextID = id + 1
		}
	}
	return nextID
}

//isDuplicateUsername takes an username and checks whether the username is already used or not.
func (s service) isDuplicateUsername(username string) bool {
	for _, u := range s.users {
		if u.Profile.Username == username {
			return true
		}
	}
	return false
}

//CreateUser takes an username and passwordHash and creates, if the username is not already taken, a new user
//with the next free userID and the given parameters.
//It will also set the users name to the username which can be changed later in EditProfile.
func (s service) CreateUser(username string, passwordHash []byte) (data.User, error) {
	if s.isDuplicateUsername(username) {
		return data.User{}, errors.New("CreateUser - username already taken")
	}

	userID := s.nextUserID()
	user := data.User{
		ID: userID,
		Profile: data.UserProfile{
			Name:     username,
			Username: username,
		},
		Password: passwordHash,
	}
	s.users[userID] = user
	return user, nil
}

//PasswordHashByUsername takes an username and returns if the username is existing the matching passwordHash.
func (s service) PasswordHashByUsername(username string) ([]byte, error) {
	for _, u := range s.users {
		if u.Profile.Username == username {
			return u.Password, nil
		}
	}

	return nil, errors.New("PasswordHashByUsername - no user found")
}

//CheckIfFollowing takes an userID and a followerID.
//It returns true or false whether the user with the followingID is following the user of userID.
func (s service) CheckIfFollowing(userID int64, followerID int64) (bool, int, error) {

	u, err := s.UserByID(userID)

	if err != nil {
		return false, -1, errors.New("CheckIfFollowing - no User found")
	}

	for i, f := range u.FollowingIDs {
		if f == followerID {
			return true, i, nil
		}
	}

	return false, -1, nil
}

//GetFollowerIndex takes an userID and a followerID.
//It returns the index of the user of followerID in the follower list of the user of userID.
func (s service) GetFollowerIndex(userID int64, followerID int64) (bool, int, error) {

	f, err := s.UserByID(followerID)

	if err != nil {
		return false, -1, errors.New("GetFollowerIndex - no User found")
	}

	for i, u := range f.FollowerIDs {
		if u == userID {
			return true, i, nil
		}
	}

	return false, -1, nil
}

//FollowUnfollow takes an userID and a followerID.
//It checks whether the user of followerID is following the user of userID or not.
//In case the follower was not following it follows the user, otherwise it unfollows.
func (s service) FollowUnfollow(userID int64, followerID int64) (bool, error) {
	u, err := s.UserByID(userID)
	if err != nil {
		return false, errors.New("FollowUnfollow - user not found")
	}

	f, err := s.UserByID(followerID)
	if err != nil {
		return false, errors.New("FollowUnfollow - follower not found")
	}

	c, i, err := s.CheckIfFollowing(userID, followerID)
	if err != nil {
		return false, err
	}

	_, j, err := s.GetFollowerIndex(userID, followerID)
	if err != nil {
		return false, err
	}

	if c {
		u.FollowingIDs = append(u.FollowingIDs[:i], u.FollowingIDs[i+1:]...)
		f.FollowerIDs = append(f.FollowerIDs[:j], f.FollowerIDs[j+1:]...)
	} else {
		u.FollowingIDs = append(u.FollowingIDs, followerID)
		f.FollowerIDs = append(f.FollowerIDs, userID)
	}

	s.users[userID] = u
	s.users[followerID] = f

	return !c, nil
}
