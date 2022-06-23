package post

import (
	"context"
	"log"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

type Server struct {
	DataService data.Service
	UnimplementedPostServer
}

func (s Server) CreatePost(ctx context.Context, req *CreatePostRequest) (*CreatePostResponse, error) {
	log.Printf("Post of User with ID %d should be created.", req.OwnerId)

	p := data.Post{
		ID:            req.Post.PostId,
		OwnerID:       req.OwnerId,
		Description:   req.Post.Description,
		MimeType:      req.Post.MimeType,
		ResourceID:    req.Post.ResourceId,
		OwnerName:     req.Post.OwnerName,
		OwnerUsername: req.Post.OwnerUsername,
	}

	log.Println(p)
	err := s.DataService.CreatePost(req.OwnerId, &p)

	if err != nil {
		return nil, err
	}

	return &CreatePostResponse{
		CreatedPost: &SinglePost{
			PostId:           p.ID,
			OwnerId:          p.OwnerID,
			Date:             p.Date.Unix(),
			Description:      p.Description,
			ResourceId:       p.ResourceID,
			NumberOfLikes:    int64(len(p.LikeIDs)),
			NumberOfComments: int64(len(p.CommentIDs)),
			MimeType:         p.MimeType,
		},
	}, nil
}

func (s Server) GetPosts(ctx context.Context, req *GetPostsRequest) (*GetPostsResponse, error) {
	log.Printf("Post of Feed of User with ID %d should be returned.", req.UserId)

	posts, err := s.DataService.PostsByID(req.UserId)
	if err != nil {
		return nil, err
	}

	postList := []*SinglePost{}

	for _, post := range posts {
		postList = append(postList, &SinglePost{
			PostId:           post.ID,
			OwnerId:          post.OwnerID,
			Date:             post.Date.Unix(),
			Description:      post.Description,
			ResourceId:       post.ResourceID,
			NumberOfLikes:    int64(len(post.LikeIDs)),
			NumberOfComments: int64(len(post.CommentIDs)),
			OwnerName:        post.OwnerName,
			OwnerUsername:    post.OwnerUsername,
			MimeType:         post.MimeType,
		})
	}

	return &GetPostsResponse{
		PostList: postList,
	}, nil
}
