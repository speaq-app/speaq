package token

import (
	"time"

	"github.com/dgrijalva/jwt-go"
)

type Claims struct {
	UserID int64 `json:"userId"`
	jwt.StandardClaims
}

type metaData struct {
	claims Claims
}

func (m metaData) UserID() int64 {
	return m.claims.UserID
}

type JWTService struct {
	Secret        []byte
	SigningMethod *jwt.SigningMethodHMAC
}

func (s JWTService) key(token *jwt.Token) (interface{}, error) {
	return s.Secret, nil
}

func (s JWTService) GenerateForUserID(userID int64) (string, error) {
	now := time.Now()
	claims := Claims{
		UserID: userID,
		StandardClaims: jwt.StandardClaims{
			IssuedAt:  now.Unix(),
			ExpiresAt: now.Add(time.Hour * 24 * 7).Unix(),
		},
	}
	token := jwt.NewWithClaims(s.SigningMethod, claims)
	return token.SignedString(s.Secret)
}

func (s JWTService) Validate(tokenString string) (MetaData, error) {
	claims := Claims{}
	token, err := jwt.ParseWithClaims(tokenString, &claims, s.key)
	if err != nil {
		if ve, ok := err.(*jwt.ValidationError); ok {
			if ve.Errors&jwt.ValidationErrorMalformed != 0 {
				return nil, ErrMalformedToken
			} else if ve.Errors&(jwt.ValidationErrorExpired|jwt.ValidationErrorNotValidYet) != 0 {
				return nil, ErrInvalidToken
			} else {
				return nil, ErrInvalidToken
			}
		}
		return nil, ErrUnableToValidate
	}

	if !token.Valid {
		return nil, ErrInvalidToken
	}

	return metaData{claims: claims}, err
}
