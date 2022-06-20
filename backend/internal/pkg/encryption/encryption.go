package encryption

type Service interface {
	CompareHashAndPassword(hash, password []byte) bool
	GenerateFromPassword(password []byte) ([]byte, error)
}
