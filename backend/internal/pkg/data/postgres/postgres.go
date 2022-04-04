package postgres

import (
	"context"
	"embed"
	_ "embed"
	"fmt"
	"log"
	"time"

	"github.com/jackc/pgx/v4/pgxpool"
)

//go:embed schema/*.sql
var schemata embed.FS

type Service struct {
	*pgxpool.Pool
	timeout time.Duration
}

func Open(dsn string, timeout time.Duration) (Service, error) {
	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()

	pool, err := pgxpool.Connect(ctx, dsn)
	if err != nil {
		return Service{}, err
	}

	return Service{
		Pool:    pool,
		timeout: timeout,
	}, pool.Ping(ctx)
}

func (s *Service) MigrateSchema() error {
	ctx, cancel := context.WithTimeout(context.Background(), s.timeout)
	defer cancel()

	var schemaVersion int
	if err := s.QueryRow(ctx, `
SELECT MAX(version_number)
FROM schema_version
`).Scan(&schemaVersion); err != nil {
		log.Printf("Failed to detect schema version; %s", err)
		return s.initDatabase()
	}
	log.Printf("Schema Version: %d", schemaVersion)

	return s.migrateSchema(schemaVersion, -1)
}

func (s *Service) initDatabase() error {
	log.Println("Initializing new database")
	ctx, cancel := context.WithTimeout(context.Background(), s.timeout)
	defer cancel()

	var tableCount uint32
	if err := s.QueryRow(ctx, `
SELECT COUNT(table_name)
FROM information_schema.tables
WHERE table_schema = 'public'
`).Scan(&tableCount); err != nil {
		return err
	}

	if tableCount > 0 {
		return fmt.Errorf("database already populated with %d tables", tableCount)
	}

	return s.migrateSchema(0, -1)
}

// migrateSchema migrates the database schema from a version number that must be equal or greater than 0
// to a version number that must be greater than the version number to migrate from
// or a negative number for latest schema version
func (s *Service) migrateSchema(from, to int) error {
	if to < 0 {
		files, err := schemata.ReadDir("schema")
		if err != nil {
			return err
		}
		to = len(files)
	}

	if from < 0 || (from >= to && to > 0) {
		return fmt.Errorf("invalid mirgation from %d to %d", from, to)
	} else if from == to {
		return nil
	}

	log.Printf("Migrating schema from version %d to %d", from, to)

	var sql []byte
	for i := from + 1; i <= to; i++ {
		fileName := fmt.Sprintf("schema/%d.sql", i)
		log.Printf("Loading migration instructions from %q", fileName)
		bb, err := schemata.ReadFile(fileName)
		if err != nil {
			return err
		}
		sql = append(sql, bb...)
	}

	ctx, cancel := context.WithTimeout(context.Background(), s.timeout)
	defer cancel()

	_, err := s.Exec(ctx, string(sql))
	return err
}
