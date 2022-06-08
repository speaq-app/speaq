package data

type PostService interface {
	CreatePost(post Post) error
	PostByID(id int64) (Post, error)
}

type Post struct {
	ID          int64
	UserID      int64
	Description string
	ResourceID  int64
	Date        string
}
