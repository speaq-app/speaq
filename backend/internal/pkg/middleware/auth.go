package middleware

import (
	"context"
	"errors"
	"strings"

	grpc_auth "github.com/grpc-ecosystem/go-grpc-middleware/auth"
	"github.com/speaq-app/speaq/internal/pkg/token"
	"google.golang.org/grpc"
)

var metaDataKey = struct{}{}
var userKey = struct{}{}

func Auth(tokenService token.Service, exceptions ...string) grpc_auth.AuthFunc {
	return func(ctx context.Context) (context.Context, error) {
		method, ok := grpc.Method(ctx)
		if !ok {
			return ctx, errors.New("no method called")
		}

		// /Auth endpoints don't need authentication
		if strings.HasPrefix(method, "/Auth") {
			return ctx, nil
		}

		token, err := grpc_auth.AuthFromMD(ctx, "bearer")
		if err != nil {
			return nil, err
		}

		metaData, err := tokenService.Validate(token)
		if err != nil {
			return ctx, err
		}

		return context.WithValue(ctx, metaDataKey, metaData), nil
	}
}

func GetUserIDFromContext(ctx context.Context) (int64, error) {
	metaData, ok := ctx.Value(metaDataKey).(token.MetaData)
	if !ok {
		return 0, errors.New("no metadata in request")
	}

	return metaData.UserID(), nil
}
