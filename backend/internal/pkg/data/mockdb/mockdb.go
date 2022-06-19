package mockdb

import (
	"errors"
	"golang.org/x/crypto/bcrypt"
	"io/ioutil"
	"log"
	"time"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

type service struct {
	resources map[int64]data.Resource
	users     map[int64]data.User
	post      map[int64]data.Post
	delay     time.Duration
}

func New() data.Service {
	bb, err := ioutil.ReadFile("testImage.txt")
	if err != nil {
		log.Fatal(err)
	}
	bc, err := ioutil.ReadFile("testImage2.txt")
	if err != nil {
		log.Fatal(err)
	}
	passHash, err := bcrypt.GenerateFromPassword([]byte("password"), 10)
	if err != nil {
		log.Fatal(err)
	}

	return &service{
		delay: time.Second,
		resources: map[int64]data.Resource{
			1: {ID: 1,
				Data:     string(bb),
				Name:     "testImage",
				MIMEType: "image/jpeg",
				Size:     83935,
			},
			2: {ID: 2,
				Data:     string(bc),
				Name:     "testImageKarl",
				MIMEType: "image/png",
				Size:     1111111,
			},
			3: {},
		},
		users: map[int64]data.User{
			1: {
				ID: 1,
				Profile: data.UserProfile{
					Name:        "Karl Ess",
					Username:    "essiggurke",
					Description: "Leude ihr müsst husteln! Macht erscht mal die Basics!",
					Website:     "ess.com",
					//ProfileImageBlurHash: "LKD0Jy_4_3xv4TMcR4wu?bR-bwIo", //ID 1
					ProfileImageBlurHash:   "U.N0^|WB~qjZ_3ofM|ae%MayWBayM{fkWBay", //ID 2
					ProfileImageResourceID: 2,
				},
				Password:     passHash,
				FollowerIDs:  []int64{2, 3, 4, 5, 6, 7},
				FollowingIDs: []int64{2, 4, 7},
			},
			2: {
				ID: 2,
				Profile: data.UserProfile{
					Name:                   "Daniel Holzwarth",
					Username:               "dholzwarth",
					Description:            "Test Description 2",
					Website:                "Test Website 2",
					ProfileImageBlurHash:   "LKD0Jy_4_3xv4TMcR4wu?bR-bwIo",
					ProfileImageResourceID: 1,
				},
				Password:     passHash,
				FollowerIDs:  []int64{1, 3},
				FollowingIDs: []int64{1, 3},
			},
			3: {
				ID: 3,
				Profile: data.UserProfile{
					Name:                   "Nosakhare Omoruyi",
					Username:               "nomoruyi",
					Description:            "Test Description 3",
					Website:                "Test Website 3",
					ProfileImageBlurHash:   "LKD0Jy_4_3xv4TMcR4wu?bR-bwIo",
					ProfileImageResourceID: 1,
				},
				FollowerIDs:  []int64{1, 2, 5, 6},
				FollowingIDs: []int64{1, 2, 4, 7},
				Password:     passHash,
			},
			4: {
				ID: 4,
				Profile: data.UserProfile{
					Name:                   "David Löwe",
					Username:               "dloewe",
					Description:            "Test Description 4",
					Website:                "Test Website 4",
					ProfileImageBlurHash:   "U.N0^|WB~qjZ_3ofM|ae%MayWBayM{fkWBay",
					ProfileImageResourceID: 2,
				},
				Password: passHash,
			},
			5: {
				ID: 5,
				Profile: data.UserProfile{
					Name:                   "Eric Eisemann",
					Username:               "eeisemann",
					Description:            "Test Description 5",
					Website:                "Test Website 5",
					ProfileImageBlurHash:   "U.N0^|WB~qjZ_3ofM|ae%MayWBayM{fkWBay",
					ProfileImageResourceID: 2,
				},
				Password: passHash,
			},
			6: {
				ID: 6,
				Profile: data.UserProfile{
					Name:                   "Sven Gatnar",
					Username:               "sgatnar",
					Description:            "Test Description 6",
					Website:                "Test Website 6",
					ProfileImageBlurHash:   "U.N0^|WB~qjZ_3ofM|ae%MayWBayM{fkWBay",
					ProfileImageResourceID: 2,
				},
				Password: passHash,
			},
			7: {
				ID: 7,
				Profile: data.UserProfile{
					Name:                   "Hedrick Schlehlein",
					Username:               "schlehlein",
					Description:            "Test Description 7",
					Website:                "Test Website 7",
					ProfileImageBlurHash:   "U.N0^|WB~qjZ_3ofM|ae%MayWBayM{fkWBay",
					ProfileImageResourceID: 2,
				},
				Password: passHash,
			},
		},
		post: map[int64]data.Post{
			1: {
				ID:          1,
				UserID:      1,
				Description: "Mein erster Post",
				Date:        "22/02/2022",
			},

			2: {
				ID:          2,
				UserID:      2,
				Description: "Mein zweiter Post",
				Date:        "22/02/2023",
			},

			3: {
				ID:          3,
				UserID:      3,
				Description: "Mein dritter Post",
				Date:        "22/02/2024",
			},
		},
	}
}

func (s service) ResourceByID(id int64) (data.Resource, error) {
	time.Sleep(s.delay)
	r, ok := s.resources[id]
	if !ok {
		return r, errors.New("not workin 1")
	}
	r.ID = id
	return r, nil
}
func (s service) FollowerIDsByID(userID int64) ([]int64, error) {
	time.Sleep(s.delay)
	u, ok := s.users[userID]
	if !ok {
		return nil, errors.New("id not found")
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
	time.Sleep(s.delay)
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

func (s service) PasswordHashAndIDByUsername(username string) ([]byte, int64, error) {

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

func (s service) PostByID(id int64) (data.Post, error) {
	time.Sleep(s.delay)
	p, ok := s.post[id]
	if !ok {
		return p, errors.New("not workin 3")
	}
	p.ID = id

	return p, nil
}

func (s service) CreatePost(id int64, post data.Post) error {
	time.Sleep(s.delay)
	c, err := s.PostByID(id)
	if err != nil {
		return err
	}
	s.post[id] = c

	log.Println(c)

	return nil

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

func (s *service) FollowUnfollow(userID int64, followID int64) (bool, error) {

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

func remove(l []int64, index int) []int64 {
	ret := make([]int64, 0)
	ret = append(ret, l[:index]...)
	return append(ret, l[index+1:]...)
}
