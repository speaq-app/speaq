package mockdb

import (
	"errors"
	"time"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

func (s service) FollowerIDsByID(userID int64) ([]int64, error) {
	time.Sleep(s.delay)
	u, ok := s.users[userID]
	if !ok {
		return nil, errors.New("followers by ID not working")
	}
	u.ID = userID
	return u.FollowerIDs, nil
}

func (s service) FollowingIDsByID(userID int64) ([]int64, error) {
	time.Sleep(s.delay)
	u, ok := s.users[userID]
	if !ok {
		return nil, errors.New("following by ID not working")
	}
	u.ID = userID
	return u.FollowingIDs, nil
}

func (s service) FollowerByIDs(userIDs []int64) ([]data.User, error) {
	time.Sleep(s.delay)
	var ul []data.User
	for _, u := range userIDs {
		ul = append(ul, s.users[u])
	}

	return ul, nil
}

func (s service) FollowingByIDs(userIDs []int64) ([]data.User, error) {
	time.Sleep(s.delay)
	var ul []data.User
	for _, u := range userIDs {
		ul = append(ul, s.users[u])
	}

	return ul, nil
}

func (s service) UserByID(id int64) (data.User, error) {
	// time.Sleep(s.delay)
	u, ok := s.users[id]
	if !ok {
		return u, errors.New("not workin 2")
	}
	u.ID = id
	return u, nil
}

func (s service) UpdateUserProfile(id int64, profile data.UserProfile) error {
	time.Sleep(s.delay)
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
	time.Sleep(s.delay)
	u, err := s.UserByID(id)
	if err != nil {
		return data.UserProfile{}, err
	}

	return u.Profile, nil
}

func (s service) PasswordHashByUsername(username string) ([]byte, int64, error) {

	//passwort hash getten
	//TODO implement me
	//Get user by username (for loop). If doesn't exists, ERROR
	//Compare entered password with user password. If not identical, ERROR
	//Return User
	//panic("implement me")

	/*	var password []byte
		var id int64*/

	for _, u := range s.users {
		if u.Profile.Username == username {
			password := u.Password

			return password, u.ID, nil
		}
	}

	return nil, 0, errors.New("no user found")
}

func (s service) nextUserID() int64 {
	var nextID int64 = 1
	for id := range s.users {
		if id >= nextID {
			nextID = id + 1
		}
	}
	return nextID
}

func (s service) isDuplicateUsername(username string) bool {
	for _, u := range s.users {
		if u.Profile.Username == username {
			return true
		}
	}
	return false
}

func (s service) CreateUser(username string, passwordHash []byte) (data.User, error) {
	time.Sleep(s.delay)
	if s.isDuplicateUsername(username) {
		return data.User{}, errors.New("username already taken")
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

func (s service) PasswordHashAndIDByUsername(username string) ([]byte, int64, error) {

	for _, u := range s.users {
		if u.Profile.Username == username {
			password := u.Password

			return password, u.ID, nil
		}
	}

	return nil, 0, errors.New("no user found")
}

func (s service) CheckIfFollowing(userID int64, followerID int64) (bool, int, error) {

	u, ok := s.users[userID]

	if !ok {
		return false, -1, errors.New("no User found")
	}

	for i, f := range u.FollowingIDs {
		if f == followerID {
			return true, i, nil
		}
	}

	return false, -1, nil
}

func (s service) FollowUnfollow(userID int64, followID int64) (bool, error) {

	u, ok := s.users[userID]

	if !ok {
		return false, errors.New("no User found")
	}
	c, i, err := s.CheckIfFollowing(userID, followID)

	if err != nil {
		return false, err
	}

	if c {
		u.FollowingIDs = append(u.FollowingIDs[:i], u.FollowingIDs[i+1:]...)
	} else {
		u.FollowingIDs = append(u.FollowingIDs, followID)
	}

	s.users[userID] = u

	return !c, nil

}
