package post

import (
	"bytes"
	"context"
	"image/jpeg"

	"github.com/buckket/go-blurhash"
	"github.com/speaq-app/speaq/internal/pkg/data"
	"github.com/speaq-app/speaq/internal/pkg/middleware"
)

type Server struct {
	DataService data.Service
	UnimplementedPostServer
}

func (s Server) CreatePost(ctx context.Context, req *CreatePostRequest) (*CreatePostResponse, error) {
	r, err := s.DataService.CreateResource(req.ResourceData, req.ResourceMimeType, req.AudioDuration)
	if err != nil {
		return nil, err
	}

	userID, err := middleware.GetUserIDFromContext(ctx)
	if err != nil {
		return nil, err
	}

	var blurHash string
	if r.MIMEType == "image" {
		img, err := jpeg.Decode(bytes.NewReader(req.ResourceData))
		if err != nil {
			return nil, err
		}
		blurHash, err = blurhash.Encode(4, 3, img)
		if err != nil {
			return nil, err
		}
	}

	p, err := s.DataService.CreatePost(userID, req.Description, r.ID, r.MIMEType, blurHash)
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
			ResourceBlurHash: p.ResourceBlurHash,
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

	followerIDs, err := s.DataService.FollowingIDsByID(userID)
	if err != nil {
		return nil, err
	}

	followerIDs = append(followerIDs, userID)

	posts, err := s.DataService.PostFeedFromFollowerIDs(followerIDs)
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
			ResourceBlurHash: post.ResourceBlurHash,
			NumberOfLikes:    int64(len(post.LikeIDs)),
			NumberOfComments: int64(len(post.CommentIDs)),
		})
	}

	return &GetPostFeedResponse{
		PostList: postList,
	}, nil
}
