package encryption

import "golang.org/x/crypto/bcrypt"

type BcryptService struct {
	Cost int
}

func (s BcryptService) CompareHashAndPassword(hash, password []byte) bool {
	return bcrypt.CompareHashAndPassword(hash, password) == nil
}

func (s BcryptService) GenerateFromPassword(password []byte) ([]byte, error) {
	return bcrypt.GenerateFromPassword(password, s.Cost)
}
