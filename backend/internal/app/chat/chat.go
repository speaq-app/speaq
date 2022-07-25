package chat

import (
	"bytes"
	"context"
	"github.com/buckket/go-blurhash"
	"github.com/speaq-app/speaq/internal/pkg/data"
	"github.com/speaq-app/speaq/internal/pkg/middleware"
	"image/jpeg"
)

type Server struct {
	DataService data.Service
	UnimplementedChatServer
}

func (s Server) CreateChat(ctx context.Context, req *CreateChatRequest) (*CreateChatResponse, error) {
	r, err := s.DataService.CreateChat(req.ParticipantIds, req.Title)

	if err != nil {
		return nil, err
	}

	/*	userID, err := middleware.GetUserIDFromContext(ctx)
		if err != nil {
			return nil, err
		}
	*/
	return &CreateChatResponse{
		CreatedChat: &PrivateChat{
			ParticipantIds: r.ParticipantsIDs,
		},
	}, nil
}
func (s Server) CreateMessage(ctx context.Context, req *CreateMessageRequest) (*CreateMessageResponse, error) {
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

	m, err := s.DataService.CreateMessage(userID, req.ChatId, req.Text, r.ID, r.MIMEType, blurHash, req.PersistantDuration)

	if err != nil {
		return nil, err
	}

	return &CreateMessageResponse{
		CreatedMessage: &SingleMessage{
			MessageId:        m.ID,
			OwnerId:          userID,
			Date:             m.CreatedAt.Unix(),
			ResourceId:       m.ResourceID,
			ResourceMimeType: m.ResourceMimeType,
			ResourceBlurHash: m.ResourceBlurHash,
			DeletionDate:     m.DeletionDate.Unix(),
		},
	}, nil
}

//CreatePost takes a description, recourceData, recourceMimeType and audioDuration frm CreatePostRequest.
//First it creates a resource in the backend by resourceData, resourceMimeType and audioDuration.
//Then it gets the userID corresponding to the logged in user.
//Then it creates a post taking the userID, description, resourceID and mimeType and returns it in CreatePostResponse.

//GetPostFeed firstly gets the corresponding userID to the logged in user.
//Then it gets all of the userIDs whom the logged in user is following.
//Based on all those IDs and his own the posts are loaded and returned.
//In case there is no post related to the IDs an empty List will be returned.
