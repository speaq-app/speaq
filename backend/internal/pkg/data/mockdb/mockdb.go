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
		delay: time.Second * 1,
		resources: map[int64]data.Resource{
			1: {ID: 1,
				Data:     string(bb),
				Name:     "testImage",
				MIMEType: "jpeg",
				Size:     83935,
			},
			2: {ID: 2,
				Data:     string(bc),
				Name:     "testImageKarl",
				MIMEType: "png",
				Size:     1111111,
			},
			3: {ID: 3,
				Data:     string(bc),
				Name:     "testGifPokemon",
				MIMEType: "gif",
				Size:     1111111},
			4: {ID: 4,
				Data:     string(bc),
				Name:     "testAudio",
				MIMEType: "audio",
				Size:     1111111},
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
		posts: map[int64]data.Post{
			1: {
				ID:          1,
				OwnerID:     1,
				Date:        time.Now(),
				Description: "Now",
				ResourceID:  3,
				LikeIDs: []int64{
					1,
					2,
					3,
				},
				CommentIDs: []int64{
					1,
					2,
				},
				MimeType: "gif",
			},

			2: {
				ID:          1,
				OwnerID:     1,
				Date:        time.Now().Add(time.Minute * -1),
				Description: "Eine Minute",
				ResourceID:  3,
				LikeIDs: []int64{
					1,
					2,
					3,
				},
				CommentIDs: []int64{
					1,
					2,
				},
				MimeType: "gif",
			},

			3: {
				ID:          1,
				OwnerID:     1,
				Date:        time.Now().Add(time.Minute * -3),
				Description: "Drei Minuten",
				ResourceID:  -1,
				LikeIDs: []int64{
					1,
					2,
					3,
				},
				CommentIDs: []int64{
					1,
					2,
				},
				MimeType: "text",
			},

			4: {
				ID:          1,
				OwnerID:     1,
				Date:        time.Now().Add(time.Minute * -60),
				Description: "1 Stunde",
				ResourceID:  -1,
				LikeIDs: []int64{
					1,
					2,
					3,
				},
				CommentIDs: []int64{
					1,
					2,
				},
				MimeType: "text",
			},

			5: {
				ID:          1,
				OwnerID:     1,
				Date:        time.Now().Add(time.Minute * -180),
				Description: "Drei Stunden",
				ResourceID:  1,
				LikeIDs: []int64{
					1,
					2,
					3,
				},
				CommentIDs: []int64{
					1,
					2,
				},
				MimeType: "image",
			},

			6: {
				ID:          1,
				OwnerID:     1,
				Date:        time.Now().Add(time.Minute * -1440),
				Description: "Einen Tag",
				ResourceID:  1,
				LikeIDs: []int64{
					1,
					2,
					3,
				},
				CommentIDs: []int64{
					1,
					2,
				},
				MimeType: "image",
			},

			7: {
				ID:          1,
				OwnerID:     1,
				Date:        time.Now().Add(time.Minute * -4320),
				Description: "Drei Tage",
				ResourceID:  1,
				LikeIDs: []int64{
					1,
					2,
					3,
				},
				CommentIDs: []int64{
					1,
					2,
				},
				MimeType: "image",
			},

			8: {
				ID:          1,
				OwnerID:     1,
				Date:        time.Now().Add(time.Minute * -10080),
				Description: "Eine Woche",
				ResourceID:  4,
				LikeIDs: []int64{
					1,
					2,
					3,
				},
				CommentIDs: []int64{
					1,
					2,
				},
				MimeType: "audio",
			},

			9: {
				ID:          1,
				OwnerID:     1,
				Date:        time.Now().Add(time.Minute * -30240),
				Description: "Drei Wochen",
				ResourceID:  4,
				LikeIDs: []int64{
					1,
					2,
					3,
				},
				CommentIDs: []int64{
					1,
					2,
				},
				MimeType: "audio",
			},

			10: {
				ID:          1,
				OwnerID:     1,
				Date:        time.Now().Add(time.Minute * -525600),
				Description: "Ein Jahr",
				ResourceID:  -1,
				LikeIDs: []int64{
					1,
					2,
					3,
				},
				CommentIDs: []int64{
					1,
					2,
				},
				MimeType: "text",
			},
		},
	}
}
