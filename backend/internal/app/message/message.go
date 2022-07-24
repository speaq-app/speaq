package message

import (
	"github.com/speaq-app/speaq/internal/pkg/data"
)

type Server struct {
	DataService data.Service
	UnimplementedMessageServer
}

//CreatePost takes a description, recourceData, recourceMimeType and audioDuration frm CreatePostRequest.
//First it creates a resource in the backend by resourceData, resourceMimeType and audioDuration.
//Then it gets the userID corresponding to the logged in user.
//Then it creates a post taking the userID, description, resourceID and mimeType and returns it in CreatePostResponse.

//GetPostFeed firstly gets the corresponding userID to the logged in user.
//Then it gets all of the userIDs whom the logged in user is following.
//Based on all those IDs and his own the posts are loaded and returned.
//In case there is no post related to the IDs an empty List will be returned.
