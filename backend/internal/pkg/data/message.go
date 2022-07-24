package data

import "time"

type MessageService interface {
	GetChats() ([]Chat, error)
	GetChatMessages(messageIDs []int64) ([]Message, error)
	CreateMessage(ownerID int64, chatID int64, text string, resourceID int64, resourceMIMEType string, resourceBlurHash string) (Message, error)
}

type Chat struct {
	ID              int64
	ParticipantsIDs []int64
	CreatedAt       time.Time
	MessageIDs      []int64
}

type Message struct {
	ID               int64
	OwnerID          int64
	CreatedAt        time.Time
	Text             string
	ResourceID       int64
	ResourceMimeType string
	ResourceBlurHash string
}
