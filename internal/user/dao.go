package user

import (
	"errors"
	"log" // ✅ 加上这个才能让 log.Printf 正常打印！
	"fiberAir4/pkg/db"
	"gorm.io/gorm" // ✅ 必须加这个！
)

func CreateUser(user *User) error {
	log.Println("📥 CreateUser called for:", user.Username)
	result := db.DB.Create(user)
	log.Printf("📦 CreateUser affected rows: %d, error: %v\n", result.RowsAffected, result.Error)
	return result.Error
}

func GetUserByUsername(username string) (*User, error) {
	var user User
	err := db.DB.Where("username = ?", username).First(&user).Error
	if err != nil {
		log.Printf("💥 GORM 查询出错: %v", err)
	}
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, nil // ✅ 用户不存在
	}
	return &user, err // ✅ 查到了 或者其他错误
}