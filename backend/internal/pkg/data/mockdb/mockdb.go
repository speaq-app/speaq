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
	audio, err := ioutil.ReadFile("testdata/testAudio.txt")
	if err != nil {
		log.Fatal(err)
	}
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
		log.Fatal(err)
	}
	imageEric, err := ioutil.ReadFile("testdata/testEricImage.txt")
	if err != nil {
		log.Fatal(err)
	}
	imageSven, err := ioutil.ReadFile("testdata/testSvenImage.txt")
	if err != nil {
		log.Fatal(err)
	}
	imageNosa, err := ioutil.ReadFile("testdata/testNosaImage.txt")
	if err != nil {
		log.Fatal(err)
	}
	imageHendrik, err := ioutil.ReadFile("testdata/testHendrikImage.txt")
	if err != nil {
		log.Fatal(err)
	}

	return &service{
		resources: map[int64]data.Resource{
			1: {
				ID:            1,
				Data:          string(audio),
				MIMEType:      "audio/mp3",
				AudioDuration: 26000,
			},
			2: {
				ID:            2,
				Data:          string(imageDaniel),
				MIMEType:      "image/png",
				AudioDuration: 0,
			},
			3: {
				ID:            3,
				Data:          string(imageDavid),
				MIMEType:      "image/png",
				AudioDuration: 0,
			},
			4: {
				ID:            4,
				Data:          string(imageEric),
				MIMEType:      "image/png",
				AudioDuration: 0,
			},
			5: {
				ID:            5,
				Data:          string(imageNosa),
				MIMEType:      "image/png",
				AudioDuration: 0,
			},
			6: {
				ID:            6,
				Data:          string(imageSven),
				MIMEType:      "image/png",
				AudioDuration: 0,
			},
			7: {
				ID:            7,
				Data:          string(imageHendrik),
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
					ProfileImageResourceID: 2,
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
					ProfileImageResourceID: 5,
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
					ProfileImageResourceID: 3,
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
					ProfileImageResourceID: 4,
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
					ProfileImageResourceID: 6,
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
					ProfileImageResourceID: 7,
				},
				Password:     passHash,
				FollowerIDs:  []int64{1},
				FollowingIDs: []int64{1},
				CreatedAt:    time.Now().Add(time.Hour * -3),
			},
		},
		posts: map[int64]data.Post{
			1: {
				ID:          1,
				OwnerID:     1,
				CreatedAt:   time.Now(),
				Description: "Ein Einwohner aus Stockholm fährt zur Entenjagd aufs Land. Als er eine Ente sieht, zielt er und schießt. Doch der Vogel fällt auf den Hof eines Bauern, und der rückt die Beute nicht heraus. „Das ist mein Vogel“, besteht der Städter auf seinem Recht. Der Bauer schlägt vor, den Streit, wie auf dem Land üblich, mit einem Tritt in den Unterleib beizulegen. „Wer weniger schreit, kriegt den Vogel.“ Der Städter ist einverstanden. Der Bauer holt aus und landet einen gewaltigen Tritt in den Weichteilen des Mannes. Der bricht zusammen und bleibt 20 Minuten am Boden liegen. Als er wieder aufstehen kann, keucht er: „Okay, jetzt bin ich dran.“ „Nee“, sagt der Bauer im Weggehen. „Hier, nehmen Sie die Ente.",
				ResourceID:  0,
				LikeIDs: []int64{
					1,
					2,
					3,
				},
				CommentIDs: []int64{
					1,
					2,
				},
				ResourceMimeType: "text",
			},
			2: {
				ID:          2,
				OwnerID:     1,
				CreatedAt:   time.Now().Add(time.Minute * -1),
				Description: "Selfie-Time! #GutenMorgen",
				ResourceID:  2,
				LikeIDs: []int64{
					1,
					2,
				},
				CommentIDs: []int64{
					1,
					2,
				},
				ResourceMimeType: "image",
			},
			3: {
				ID:          3,
				OwnerID:     2,
				CreatedAt:   time.Now().Add(time.Minute * -60),
				Description: "Ich wäre gern so hübsch wie der!",
				ResourceID:  3,
				LikeIDs:     []int64{},
				CommentIDs: []int64{
					1,
					2,
				},
				ResourceMimeType: "gif",
			},
			4: {
				ID:          4,
				OwnerID:     2,
				CreatedAt:   time.Now().Add(time.Minute * -180),
				Description: "Ich hab dir vertrut!",
				ResourceID:  1,
				LikeIDs: []int64{
					1,
					2,
					3,
				},
				CommentIDs:       []int64{},
				ResourceMimeType: "audio/mp3",
			},
		},
	}
}
