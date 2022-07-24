package mockdb

import (
	"github.com/speaq-app/speaq/internal/pkg/data"
	"log"
	"time"
)

func (s *service) CreateChat(participantIDs []int64, title string) (data.Chat, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	chatID := s.nextChatID()
	chat := data.Chat{
		ID:              chatID,
		Title:           title,
		ParticipantsIDs: participantIDs,
		CreatedAt:       time.Now(),
	}
	s.chats[chatID] = chat

	return chat, nil
}

func (s *service) CreateMessage(ownerID int64, chatID int64, text string, resourceID int64, resourceMIMEType string, resourceBlurHash string) (data.Message, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	messageID := s.nextMessageID()
	message := data.Message{
		ID:               messageID,
		OwnerID:          ownerID,
		CreatedAt:        time.Now(),
		Text:             text,
		ResourceID:       resourceID,
		ResourceMimeType: resourceMIMEType,
		ResourceBlurHash: resourceBlurHash,
	}
	s.messages[messageID] = message
	chat := s.chats[chatID]

	chat.MessageIDs = append(chat.MessageIDs, message.ID)

	s.chats[chatID] = chat

	log.Printf("%q has send a new chat to chat %q", s.users[ownerID].Profile.Username, s.chats[chatID].Title)
	return message, nil
}

func (s *service) nextMessageID() int64 {
	var nextID int64 = 1
	for id := range s.messages {
		if id >= nextID {
			nextID = id + 1
		}
	}
	return nextID
}
func (s *service) nextChatID() int64 {
	var nextID int64 = 1
	for id := range s.chats {
		if id >= nextID {
			nextID = id + 1
		}
	}
	return nextID
}
