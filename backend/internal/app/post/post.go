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

//CreatePost takes a description, recourceData, recourceMimeType and audioDuration frm CreatePostRequest.
//First it creates a resource in the backend by resourceData, resourceMimeType and audioDuration.
//Then it gets the userID corresponding to the logged in user.
//Then it creates a post taking the userID, description, resourceID and mimeType and returns it in CreatePostResponse.
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
	if r.MIMEType == "image/jpeg" {
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

//GetPostFeed firstly gets the corresponding userID to the logged in user.
//Then it gets all of the userIDs whom the logged in user is following.
//Based on all those IDs and his own the posts are loaded and returned.
//In case there is no post related to the IDs an empty List will be returned.
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
