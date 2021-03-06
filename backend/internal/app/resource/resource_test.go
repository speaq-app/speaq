//go:generate mockgen -destination=resource_mock_test.go -package=resource_test github.com/speaq-app/speaq/internal/pkg/data ResourceService
package resource_test

import (
	"bytes"
	"context"
	"errors"
	"math/rand"
	"testing"

	"github.com/golang/mock/gomock"
	"github.com/speaq-app/speaq/internal/app/resource"
	"github.com/speaq-app/speaq/internal/pkg/data"
)

func TestGetResource(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	tt := []struct {
		name       string
		resourceID int64
		resource   data.Resource
		err        error
	}{
		{
			name:       "ResourceByID_WithRandomID",
			resourceID: rand.Int63(),
			resource: data.Resource{
				Data:          []byte{1, 2, 3, 4},
				MIMEType:      "type",
				AudioDuration: 187000,
			},
		},
		{
			name:       "ResourceByID_WithError",
			resourceID: rand.Int63(),
			err:        errors.New("error"),
		},
	}

	for _, tc := range tt {
		t.Run(tc.name, func(t *testing.T) {
			s := NewMockResourceService(ctrl)
			s.EXPECT().ResourceByID(tc.resourceID).Times(1).Return(tc.resource, tc.err)
			srv := resource.Server{
				ResourceService: s,
			}

			ctx, cancel := context.WithCancel(context.Background())
			defer cancel()
			req := resource.GetResourceRequest{Id: tc.resourceID}

			resp, err := srv.GetResource(ctx, &req)
			if err != nil {
				if err != tc.err {
					t.Error(err)
				}
				return
			}

			if !bytes.Equal(resp.Data, tc.resource.Data) ||
				resp.MimeType != tc.resource.MIMEType ||
				resp.AudioDuration != tc.resource.AudioDuration {
				t.Fail()
			}
		})
	}
}
