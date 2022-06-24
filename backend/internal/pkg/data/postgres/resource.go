package postgres

import (
	"context"

	"github.com/speaq-app/speaq/internal/pkg/data"
)

func (s Service) ResourceByID(id int64) (data.Resource, error) {
	ctx, cancel := context.WithTimeout(context.Background(), s.timeout)
	defer cancel()

	var r data.Resource
	if err := s.QueryRow(ctx, `
SELECT resource_data, resource_name, mime_type, size
FROM resources
WHERE id = $1;
`, id).Scan(&r.Data, &r.Name, &r.MIMEType, &r.Size); err != nil {
		return r, err
	}

	return r, nil
}
