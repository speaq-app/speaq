package cmd

import (
	"bytes"
	_ "embed"
	"fmt"
	"log"
	"net"
	"path"
	"strings"

	"github.com/speaq-app/speaq/internal/app/post"
	"github.com/speaq-app/speaq/internal/app/resource"
	"github.com/speaq-app/speaq/internal/app/settings"
	"github.com/speaq-app/speaq/internal/app/user"
	"github.com/speaq-app/speaq/internal/pkg/data/mockdb"
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

			srv := grpc.NewServer()
			resourceSrv := resource.Server{
				DataService: db,
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
