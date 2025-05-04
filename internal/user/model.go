package user

import "gorm.io/gorm"

type User struct {
	gorm.Model
	Username string `gorm:"uniqueIndex;size:32;not null"`
	Password string `gorm:"size:255;not null"` // bcrypt hash
}
