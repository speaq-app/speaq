package mockdb

import (
	"errors"
	"github.com/speaq-app/speaq/internal/pkg/data"
	"log"
	time "time"
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

	for _, id := range chat.ParticipantsIDs {
		user, ok := s.users[id]

		if !ok {
			return chat, errors.New("user not found")
		}

		user.ChatIDs = append(user.ChatIDs, chatID)
		s.users[id] = user
	}

	return chat, nil
}
func (s *service) CreateMessage(ownerID int64, chatID int64, text string, resourceID int64, resourceMIMEType string, resourceBlurHash string, persistanceDuration int64) (data.Message, error) {
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
		// TODO: Change Hardcode deletion time to custom setting
		DeletionDate: time.Now().Add(time.Minute * 1),
	}
	s.messages[messageID] = message
	chat, ok := s.chats[chatID]
	if !ok {
		return message, errors.New("followers by ID not working")
	}

	chat.MessageIDs = append(chat.MessageIDs, message.ID)

	s.chats[chatID] = chat

	log.Printf("%q has send a new chat to chat %q", s.users[ownerID].Profile.Username, s.chats[chatID].Title)
	return message, nil
}

func (s *service) GetChats(ownerID int64) ([]data.Chat, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	user, ok := s.users[ownerID]

	if !ok {
		return nil, errors.New("chat not found")
	}

	var chats []data.Chat

	for _, id := range user.ChatIDs {
		chat, ok := s.chats[id]

		if !ok {
			return chats, errors.New("chat not found")
		}

		chats = append(chats, chat)
	}

	return chats, nil
}
func (s *service) GetMessages(messageIDs []int64) ([]data.Message, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	var messages []data.Message

	for _, id := range messageIDs {
		message, ok := s.messages[id]

		if !ok {
			return messages, errors.New("message not found")
		}

		messages = append(messages, message)
	}

	return messages, nil
}

func (s *service) DeleteChat(chatID int64) (bool, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	chat, ok := s.chats[chatID]
	if !ok {
		return false, errors.New("message not found")
	}

	// Deletes all messages from chat
	for _, id := range chat.MessageIDs {
		delete(s.messages, id)
	}

	// Deletes chat id from all participating users
	for _, id := range chat.ParticipantsIDs {
		user, ok := s.users[id]

		if !ok {
			return false, errors.New("user not found")
		}

		user.ChatIDs = append(user.ChatIDs[:id], user.ChatIDs[id+1:]...)
		s.users[id] = user
	}

	// Deletes chat itself
	delete(s.chats, chatID)
	return true, nil
}
func (s *service) DeleteMessage(chatID int64, messageID int64) (bool, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	chat, ok := s.chats[chatID]

	if !ok {
		return false, errors.New("chat not found")
	}

	_, ok = s.messages[messageID]
	if !ok {
		return false, errors.New("message not found")
	}

	// Deletes Message ID from chat List
	chat.MessageIDs = append(chat.MessageIDs[:messageID], chat.MessageIDs[messageID+1:]...)
	s.chats[chatID] = chat

	// Deletes the actual message
	delete(s.messages, messageID)

	return true, nil
}

//
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
