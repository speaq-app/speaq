package cmd

import (
	"bytes"
	_ "embed"
	"fmt"
	"log"
	"net"
	"path"
	"strings"

	"github.com/dgrijalva/jwt-go"
	grpc_middleware "github.com/grpc-ecosystem/go-grpc-middleware"
	grpc_auth "github.com/grpc-ecosystem/go-grpc-middleware/auth"
	"github.com/speaq-app/speaq/internal/app/auth"
	"github.com/speaq-app/speaq/internal/app/post"
	"github.com/speaq-app/speaq/internal/app/resource"
	"github.com/speaq-app/speaq/internal/app/settings"
	"github.com/speaq-app/speaq/internal/app/user"
	"github.com/speaq-app/speaq/internal/pkg/data/mockdb"
	"github.com/speaq-app/speaq/internal/pkg/encryption"
	"github.com/speaq-app/speaq/internal/pkg/middleware"
	"github.com/speaq-app/speaq/internal/pkg/token"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"google.golang.org/grpc"
)

//go:embed config.default.yml
var defaultConfig []byte

type Config struct {
	API        API
	Database   Database
	ImprintURL string
}

type API struct {
	Bind string
}

type Database struct {
	Host     string
	Port     uint16
	Database string
	Username string
	Password string
}

func (cfg Database) DSN() string {
	return fmt.Sprintf("host=%s port=%d dbname=%s user=%s password=%s",
		cfg.Host, cfg.Port, cfg.Database, cfg.Username, cfg.Password)
}

var (
	v *viper.Viper

	configPath string

	rootCmd = &cobra.Command{
		Use:   "infrared",
		Short: "Starts the infrared proxy",
		RunE: func(cmd *cobra.Command, args []string) error {
			log.Printf("loading config from %q\n", configPath)

			cfg, err := loadConfig()
			if err != nil {
				log.Fatalf("Failed to read config from %q, %s", configPath, err)
			}

			// db, err := postgres.Open(cfg.Database.DSN(), time.Second*5)
			// if err != nil {
			// 	return err
			// }

			// if err := db.MigrateSchema(); err != nil {
			// 	return err
			// }

			db := mockdb.New()
			encryptionService := encryption.BcryptService{
				Cost: 10,
			}
			tokenService := token.JWTService{
				Secret:        []byte("changeMe"),
				SigningMethod: jwt.SigningMethodHS512,
			}

			srv := grpc.NewServer(
				grpc.MaxRecvMsgSize(168000000), // 20 MB + 1 MB
				grpc.StreamInterceptor(grpc_middleware.ChainStreamServer(
					grpc_auth.StreamServerInterceptor(middleware.Auth(tokenService)),
				)),
				grpc.UnaryInterceptor(grpc_middleware.ChainUnaryServer(
					grpc_auth.UnaryServerInterceptor(middleware.Auth(tokenService)),
				)),
			)
			resourceSrv := resource.Server{
				ResourceService: db,
			}
			resource.RegisterResourceServer(srv, resourceSrv)
			userSrv := user.Server{
				DataService: db,
			}
			user.RegisterUserServer(srv, userSrv)
			settingsSrv := settings.Server{
				ImprintURL: cfg.ImprintURL,
			}
			settings.RegisterSettingsServer(srv, settingsSrv)
			postSrv := post.Server{
				DataService: db,
			}
			post.RegisterPostServer(srv, postSrv)
			authSrv := auth.Server{
				UserService:       db,
				EncryptionService: encryptionService,
				TokenService:      tokenService,
			}
			auth.RegisterAuthServer(srv, authSrv)

			l, err := net.Listen("tcp", ":8080")
			if err != nil {
				return err
			}

			return srv.Serve(l)
		},
	}
)

func init() {
	v = viper.New()
	v.SetEnvPrefix("SPEAQ")
	v.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))
	v.AutomaticEnv()

	rootCmd.Flags().StringVarP(&configPath, "config", "c", "config.yml", "path of the config file")
	viper.BindPFlag("CONFIG", rootCmd.Flags().Lookup("config"))
}

// Execute executes the root command.
func Execute() error {
	return rootCmd.Execute()
}

func loadConfig() (Config, error) {
	viper.SetConfigType("yml")
	if err := viper.ReadConfig(bytes.NewReader(defaultConfig)); err != nil {
		return Config{}, err
	}

	configPath = strings.TrimSpace(configPath)
	dir, file := path.Split(configPath)
	ext := path.Ext(file)
	fileName := strings.TrimSuffix(file, ext)
	if dir == "" {
		dir = "."
	}

	viper.SetConfigName(fileName)
	viper.AddConfigPath(dir)
	viper.SetConfigType(strings.TrimPrefix(ext, "."))

	_ = viper.SafeWriteConfigAs(configPath)

	if err := viper.ReadInConfig(); err != nil {
		return Config{}, err
	}

	var cfg Config
	return cfg, viper.Unmarshal(&cfg)
}
