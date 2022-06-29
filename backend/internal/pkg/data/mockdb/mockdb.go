package mockdb

import (
	"io/ioutil"
	"log"
	"time"

	"golang.org/x/crypto/bcrypt"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

type service struct {
	resources map[int64]data.Resource
	users     map[int64]data.User
	posts     map[int64]data.Post
}

func New() data.Service {
	passHash, err := bcrypt.GenerateFromPassword([]byte("password"), 10)
	if err != nil {
		log.Fatal(err)
	}

	imageDaniel, err := ioutil.ReadFile("testdata/testDanielImage.txt")
	if err != nil {
		log.Fatal(err)
	}

	imageDavid, err := ioutil.ReadFile("testdata/testDavidImage.txt")
	if err != nil {
	}

	imageEric, err := ioutil.ReadFile("testdata/eric.jpg")
	if err != nil {
		log.Fatal(err)
	}

	imageSven, err := ioutil.ReadFile("testdata/sven.jpg")
	if err != nil {
		log.Fatal(err)
	}

	imageNosa, err := ioutil.ReadFile("testdata/nosa.jpg")
	if err != nil {
		log.Fatal(err)
	}

	imageHendrik, err := ioutil.ReadFile("testdata/hendrik.jpg")
	if err != nil {
		log.Fatal(err)
	}

	return &service{
		resources: map[int64]data.Resource{
			1: {
				ID:            1,
				Data:          imageDaniel,
				MIMEType:      "image/png",
				AudioDuration: 0,
			},
			2: {
				ID:            2,
				Data:          imageDavid,
				MIMEType:      "image/png",
				AudioDuration: 0,
			},
			3: {
				ID:            3,
				Data:          imageEric,
				MIMEType:      "image/png",
				AudioDuration: 0,
			},
			4: {
				ID:            4,
				Data:          imageNosa,
				MIMEType:      "image/png",
				AudioDuration: 0,
			},
			5: {
				ID:            5,
				Data:          imageSven,
				MIMEType:      "image/png",
				AudioDuration: 0,
			},
			6: {
				ID:            6,
				Data:          imageHendrik,
				MIMEType:      "image/png",
				AudioDuration: 0,
			},
		},
		users: map[int64]data.User{
			1: {
				ID: 1,
				Profile: data.UserProfile{
					Name:                   "Daniel Holzwarth",
					Username:               "dholzwarth",
					Description:            "Test Description 2",
					Website:                "Test Website 2",
					ProfileImageBlurHash:   "LKD0Jy_4_3xv4TMcR4wu?bR-bwIo",
					ProfileImageResourceID: 1,
				},
				Password:     passHash,
				FollowerIDs:  []int64{2},
				FollowingIDs: []int64{2, 3},
				CreatedAt:    time.Now().Add(time.Hour * -3),
			},
			2: {
				ID: 2,
				Profile: data.UserProfile{
					Name:                   "Nosakhare Omoruyi",
					Username:               "nomoruyi",
					Description:            "Test Description 3",
					Website:                "Test Website 3",
					ProfileImageBlurHash:   "LKD0Jy_4_3xv4TMcR4wu?bR-bwIo",
					ProfileImageResourceID: 4,
				},
				Password:     passHash,
				FollowerIDs:  []int64{1, 3, 5},
				FollowingIDs: []int64{1, 4},
				CreatedAt:    time.Now().Add(time.Hour * -3),
			},
			3: {
				ID: 3,
				Profile: data.UserProfile{
					Name:                   "David Löwe",
					Username:               "dloewe",
					Description:            "Test Description 4",
					Website:                "Test Website 4",
					ProfileImageBlurHash:   "LKD0Jy_4_3xv4TMcR4wu?bR-bwIo",
					ProfileImageResourceID: 2,
				},
				Password:     passHash,
				FollowerIDs:  []int64{1, 2},
				FollowingIDs: []int64{1, 2, 4, 5},
				CreatedAt:    time.Now().Add(time.Hour * -3),
			},
			4: {
				ID: 4,
				Profile: data.UserProfile{
					Name:                   "Eric Eisemann",
					Username:               "eeisemann",
					Description:            "Test Description 5",
					Website:                "Test Website 5",
					ProfileImageBlurHash:   "LKD0Jy_4_3xv4TMcR4wu?bR-bwIo",
					ProfileImageResourceID: 3,
				},
				Password:     passHash,
				FollowerIDs:  []int64{1, 3},
				FollowingIDs: []int64{1, 6},
				CreatedAt:    time.Now().Add(time.Hour * -3),
			},
			5: {
				ID: 5,
				Profile: data.UserProfile{
					Name:                   "Sven Gatnar",
					Username:               "sgatnar",
					Description:            "Test Description 6",
					Website:                "Test Website 6",
					ProfileImageBlurHash:   "LKD0Jy_4_3xv4TMcR4wu?bR-bwIo",
					ProfileImageResourceID: 5,
				},
				Password:     passHash,
				FollowerIDs:  []int64{},
				FollowingIDs: []int64{},
				CreatedAt:    time.Now().Add(time.Hour * -3),
			},
			6: {
				ID: 6,
				Profile: data.UserProfile{
					Name:                   "Hedrick Schlehlein",
					Username:               "schlehlein",
					Description:            "Test Description 7",
					Website:                "Test Website 7",
					ProfileImageBlurHash:   "LKD0Jy_4_3xv4TMcR4wu?bR-bwIo",
					ProfileImageResourceID: 6,
				},
				Password:     passHash,
				FollowerIDs:  []int64{1},
				FollowingIDs: []int64{1},
				CreatedAt:    time.Now().Add(time.Hour * -3),
			},
		},
		posts: map[int64]data.Post{},
	}
}
