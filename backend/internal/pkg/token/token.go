package token

import "errors"

var (
	ErrMalformedToken   = errors.New("token is mailformed")
	ErrInvalidToken     = errors.New("token is invalid")
	ErrUnableToValidate = errors.New("unable to validate the token")
)

type MetaData interface {
	UserID() int64
}

type Service interface {
	GenerateForUserID(userID int64) (string, error)
	Validate(token string) (MetaData, error)
}
