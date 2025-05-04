package user

import (
	"errors"

	"golang.org/x/crypto/bcrypt"
)

func Register(username, password string) error {
	existing, _ := GetUserByUsername(username)
	if existing != nil {
		return errors.New("username already exists")
	}

	hashed, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}

	user := &User{
		Username: username,
		Password: string(hashed),
	}
	return CreateUser(user)
}

func Login(username, password string) error {
	user, err := GetUserByUsername(username)
	if err != nil {
		return errors.New("user not found")
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password)); err != nil {
		return errors.New("invalid password")
	}

	return nil
}
