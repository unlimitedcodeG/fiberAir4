package config

import (
	"log"
	"os"

	"github.com/spf13/viper"
)

var Cfg Config

type Config struct {
	Database struct {
		Host     string
		Port     int
		User     string
		Password string
		Name     string
	}
	Redis struct {
		Host     string
		Port     int
		Password string
	}
	Server struct {
		Port int
	}
}

func Init() {
	// ✅ 允许从环境变量指定 config 路径
	path := os.Getenv("CFG_PATH")
	if path == "" {
		path = "internal/config/config.yml"
	}

	viper.SetConfigFile(path)

	if err := viper.ReadInConfig(); err != nil {
		log.Fatalf("❌ failed to read config file: %v", err)
	}

	if err := viper.Unmarshal(&Cfg); err != nil {
		log.Fatalf("❌ failed to unmarshal config: %v", err)
	}
}
