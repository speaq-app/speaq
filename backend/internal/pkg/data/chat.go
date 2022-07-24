package data

import "time"

type ChatService interface {
	GetChats() ([]Chat, error)
	GetChatMessages(messageIDs []int64) ([]Message, error)
	CreateChat(participantIDs []int64, title string) (Chat, error)
	CreateMessage(ownerID int64, chatID int64, text string, resourceID int64, resourceMIMEType string, resourceBlurHash string) (Message, error)
	DeleteChat()
	DeleteMessage()
}

type Chat struct {
	ID              int64
	Title           string
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
