package post

import (
	"context"

	"github.com/speaq-app/speaq/internal/pkg/data"
	"github.com/speaq-app/speaq/internal/pkg/middleware"
)

type Server struct {
	DataService data.Service
	UnimplementedPostServer
}

func (s Server) CreatePost(ctx context.Context, req *CreatePostRequest) (*CreatePostResponse, error) {
	r, err := s.DataService.CreateResource(req.ResourceData, req.ResourceMimeType)
	if err != nil {
		return nil, err
	}

	userID, err := middleware.GetUserIDFromContext(ctx)
	if err != nil {
		return nil, err
	}

	p, err := s.DataService.CreatePost(userID, req.Description, r.ID, r.MIMEType)
	if err != nil {
		return nil, err
	}

	return &CreatePostResponse{
		CreatedPost: &SinglePost{
			PostId:           p.ID,
			OwnerId:          p.OwnerID,
			Date:             p.CreatedAt.Unix(),
			Description:      p.Description,
			ResourceId:       r.ID,
			ResourceMimeType: r.MIMEType,
			NumberOfLikes:    int64(len(p.LikeIDs)),
			NumberOfComments: int64(len(p.CommentIDs)),
		},
	}, nil
}

func (s Server) GetPostFeed(ctx context.Context, req *GetPostFeedRequest) (*GetPostFeedResponse, error) {
	userID, err := middleware.GetUserIDFromContext(ctx)
	if err != nil {
		return nil, err
	}

	posts, err := s.DataService.PostFeedForUserID(userID)
	if err != nil {
		return nil, err
	}

	postList := []*SinglePost{}

	for _, post := range posts {
		postList = append(postList, &SinglePost{
			PostId:           post.ID,
			OwnerId:          post.OwnerID,
			Date:             post.CreatedAt.Unix(),
			Description:      post.Description,
			ResourceId:       post.ResourceID,
			ResourceMimeType: post.ResourceMimeType,
			NumberOfLikes:    int64(len(post.LikeIDs)),
			NumberOfComments: int64(len(post.CommentIDs)),
		})
	}

	return &GetPostFeedResponse{
		PostList: postList,
	}, nil
}
