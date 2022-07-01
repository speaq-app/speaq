package mockdb

import (
	"errors"
	"fmt"
	"strings"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

func (s *service) FollowerIDsByID(userID int64) ([]int64, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	u, ok := s.users[userID]
	if !ok {
		return nil, errors.New("followers by ID not working")
	}
	u.ID = userID
	return u.FollowerIDs, nil
}

func (s *service) FollowingIDsByID(userID int64) ([]int64, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	u, ok := s.users[userID]
	if !ok {
		return nil, errors.New("following by ID not working")
	}
	u.ID = userID
	return u.FollowingIDs, nil
}

func (s *service) UserByUserIDs(userIDs []int64) ([]data.User, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	var ul []data.User
	for _, u := range userIDs {
		ul = append(ul, s.users[u])
	}

	return ul, nil
}

func (s *service) FollowingByIDs(userIDs []int64) ([]data.User, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	var ul []data.User
	for _, u := range userIDs {
		ul = append(ul, s.users[u])
	}

	return ul, nil
}

func (s *service) UserByID(id int64) (data.User, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	u, ok := s.users[id]
	if !ok {
		return u, errors.New("UserByID - user not found")
	}
	u.ID = id
	return u, nil
}

func (s *service) UserByUsername(username string) (data.User, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	for _, u := range s.users {
		if u.Profile.Username == username {
			return u, nil
		}
	}
	return data.User{}, errors.New("UserByUsername - user not found")
}

func (s *service) SearchUser(userID int64, term string) ([]data.User, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	var u []data.User
	for _, user := range s.users {
		if user.ID == userID {
			continue
		}

		if term == "" {
			u = append(u, user)
		} else if strings.Contains(strings.ToLower(user.Profile.Username), strings.ToLower(term)) || strings.Contains(strings.ToLower(user.Profile.Name), strings.ToLower(term)) {
			u = append(u, user)
		}
	}
	return u, nil
}

func (s *service) UpdateUserProfile(id int64, profile data.UserProfile) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	u, ok := s.users[id]
	if !ok {
		return fmt.Errorf("user with ID %d not found", id)
	}

	profile.ProfileImageBlurHash = u.Profile.ProfileImageBlurHash
	profile.ProfileImageResourceID = u.Profile.ProfileImageResourceID
	u.Profile = profile
	s.users[id] = u

	return nil
}

func (s *service) UserProfileByID(id int64) (data.UserProfile, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	u, ok := s.users[id]
	if !ok {
		return data.UserProfile{}, fmt.Errorf("user with ID %d not found", id)
	}

	return u.Profile, nil
}

func (s *service) nextUserID() int64 {
	var nextID int64 = 1
	for id := range s.users {
		if id >= nextID {
			nextID = id + 1
		}
	}
	return nextID
}

func (s *service) isDuplicateUsername(username string) bool {
	for _, u := range s.users {
		if u.Profile.Username == username {
			return true
		}
	}
	return false
}

func (s *service) CreateUser(username string, passwordHash []byte) (data.User, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

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

func (s *service) PasswordHashByUsername(username string) ([]byte, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	for _, u := range s.users {
		if u.Profile.Username == username {
			return u.Password, nil
		}
	}

	return nil, errors.New("PasswordHashByUsername - no user found")
}

func (s *service) checkIfFollowing(userID int64, followerID int64) (bool, int, error) {
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

func (s *service) CheckIfFollowing(userID int64, followerID int64) (bool, int, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	return s.checkIfFollowing(userID, followerID)
}

func (s *service) getFollowerIndex(userID int64, followerID int64) (bool, int, error) {
	u, ok := s.users[followerID]
	if !ok {
		return false, -1,errors.New("GetFollowerIndex - no User found")
	}

	for i, u := range u.FollowerIDs {
		if u == userID {
			return true, i, nil
		}
	}

	return false, -1, nil
}

func (s *service) GetFollowerIndex(userID int64, followerID int64) (bool, int, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	return s.getFollowerIndex(userID, followerID)
}

func (s *service) FollowUnfollow(userID int64, followerID int64) (bool, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	u, ok := s.users[userID]
	if !ok {
		return false, errors.New("FollowUnfollow - user not found")
	}

	f, ok := s.users[followerID]
	if !ok {
		return false, errors.New("FollowUnfollow - follower not found")
	}
	
	c, i, err := s.checkIfFollowing(userID, followerID)
	if err != nil {
		return false, err
	}
	
	_, j, err := s.getFollowerIndex(userID, followerID)
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
