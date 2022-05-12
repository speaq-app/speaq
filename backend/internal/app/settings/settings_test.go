package settings_test

import (
	"context"
	"testing"

	"github.com/golang/protobuf/ptypes/empty"
	"github.com/speaq-app/speaq/internal/app/settings"
)

func TestGetResource(t *testing.T) {
	tt := []struct {
		name       string
		imprintURL string
	}{
		{
			name:       "NoImprintURL",
			imprintURL: "",
		},
		{
			name:       "ExampleImprintURL",
			imprintURL: "https://example.com/imprint",
		},
	}

	for _, tc := range tt {
		t.Run(tc.name, func(t *testing.T) {
			srv := settings.Server{
				ImprintURL: tc.imprintURL,
			}

			resp, err := srv.GetImprintURL(context.Background(), &empty.Empty{})
			if err != nil {
				t.Error(err)
			}

			if resp.Url != tc.imprintURL {
				t.Fail()
			}
		})
	}
}
