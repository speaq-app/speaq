package data

type PostService interface {
	CreatePost(userID int64, post Post) error
	PostByID(userID int64) (Post, error)
}

type Post struct {
	ID          int64
	UserID      int64
	Description string
	Resource    Resource
	Date        string
}
