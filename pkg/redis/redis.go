package redis

import (
	"context"
	"fiberAir4/internal/config"
	"fmt"

	"github.com/redis/go-redis/v9"
)

var Rdb *redis.Client
var Ctx = context.Background()

func Init() {
	c := config.Cfg.Redis

	Rdb = redis.NewClient(&redis.Options{
		Addr:     fmt.Sprintf("%s:%d", c.Host, c.Port),
		Password: c.Password,
		DB:       0,
	})

	if err := Rdb.Ping(Ctx).Err(); err != nil {
		panic(fmt.Sprintf("❌ Redis connect failed: %v", err))
	}
}
