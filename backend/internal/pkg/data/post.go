package data

type PostService interface {
	UserByID(id int64) (User, error)
	SavePost(userID int64, post PostInfo) error
	PostByID(userID int64) (PostInfo, error)
}

type Post struct {
	ID int64

	Post PostInfo
}

type PostInfo struct {
	UserID         int64
	PostResourceID int64
	Description    string
	Date           string
}
