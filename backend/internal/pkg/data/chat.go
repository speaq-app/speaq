package data

import "time"

type ChatService interface {
	GetChats(ownerID int64) ([]Chat, error)
	GetChatMessages(messageIDs []int64) ([]Message, error)
	CreateChat(participantIDs []int64, title string) (Chat, error)
	CreateMessage(ownerID int64, chatID int64, text string, resourceID int64, resourceMIMEType string, resourceBlurHash string, persistanceDuration int64) (Message, error)
	DeleteChat(chatID int64) (bool, error)
	DeleteMessage(chatID int64, messageID int64) (bool, error)
}

type Chat struct {
	ID              int64
	Title           string
	ParticipantsIDs []int64
	MessageIDs      []int64
	CreatedAt       time.Time
}

type Message struct {
	ID               int64
	OwnerID          int64
	CreatedAt        time.Time
	Text             string
	ResourceID       int64
	ResourceMimeType string
	ResourceBlurHash string
	DeletionDate     time.Time
}
