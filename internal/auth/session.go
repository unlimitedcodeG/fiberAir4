package auth

import (
	"context"
	"fmt"
	"log"
	"time"

	"fiberAir4/pkg/redis"
)

const tokenTTL = 30 * 24 * time.Hour // 30天
const tokenPrefix = "login_token"

// SaveToken 保存用户token到Redis
func SaveToken(uid int64, token string) error {
	key := fmt.Sprintf("%s:%d", tokenPrefix, uid)
	log.Printf("Generated key: %s", key) // 关键的 log 输出
	return redis.Rdb.Set(context.Background(), key, token, tokenTTL).Err()
}

// GetToken 获取Redis中当前登录的token（用于判断是否一致）
func GetToken(uid int64) (string, error) {
	key := fmt.Sprintf("%s:%d", tokenPrefix, uid)
	return redis.Rdb.Get(context.Background(), key).Result()
}

// DeleteToken 主动注销/登出
func DeleteToken(uid int64) error {
	key := fmt.Sprintf("%s:%d", tokenPrefix, uid)
	return redis.Rdb.Del(context.Background(), key).Err()
}

// IsTokenValid 校验当前用户传来的token是否与Redis一致（用于强制踢下线）
func IsTokenValid(uid int64, token string) bool {
	saved, err := GetToken(uid)
	if err != nil {
		return false
	}
	return saved == token
}
