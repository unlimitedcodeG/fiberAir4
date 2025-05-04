package user

import (
	"errors"
	"fiberAir4/pkg/db"
)

func CreateUser(user *User) error {
	return db.DB.Create(user).Error
}

func GetUserByUsername(username string) (*User, error) {
	var user User
	result := db.DB.Where("username = ?", username).First(&user)
	if errors.Is(result.Error, db.DB.Error) {
		return nil, result.Error
	}
	return &user, result.Error
}
