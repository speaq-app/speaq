package data

import (
	"context"

	"github.com/jackc/pgx/v4"
)

type Service interface {
}

type service struct {
	conn *pgx.Conn
}

func NewPostgres(dsn string) (Service, error) {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	conn, err := pgx.Connect(ctx, "")
	if err != nil {
		return nil, err
	}

	return &service{
		conn: conn,
	}, conn.Ping(ctx)
}
