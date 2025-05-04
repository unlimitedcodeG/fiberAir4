package user

import (
	"errors"
	"fiberAir4/pkg/db"
	"log"

	"gorm.io/gorm"
)

// 创建新用户
func CreateUser(user *User) error {
	log.Printf("[user.dao] 👉 CreateUser: %s", user.Username)
	result := db.DB.Create(user)
	if result.Error != nil {
		log.Printf("[user.dao] ❌ 创建失败: %v", result.Error)
	}
	return result.Error
}

// 根据用户名查询
func GetUserByUsername(username string) (*User, error) {
	var user User
	err := db.DB.Where("username = ?", username).First(&user).Error

	if errors.Is(err, gorm.ErrRecordNotFound) {
		log.Printf("[user.dao] ❗ 用户不存在: %s", username)
		return nil, nil
	}

	if err != nil {
		log.Printf("[user.dao] 💥 查询错误: %s, err: %v", username, err)
		return nil, err
	}

	log.Printf("[user.dao] ✅ 查询成功: %s (id=%d)", user.Username, user.ID)
	return &user, nil
}
