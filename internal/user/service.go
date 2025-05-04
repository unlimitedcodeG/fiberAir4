package user

import (
	"errors"
	"log"

	"golang.org/x/crypto/bcrypt"
)

func Register(username, password string) error {
	log.Println("🚀 Register called:", username)

	existing, err := GetUserByUsername(username)
	if err != nil {
		log.Println("❌ 查询用户失败:", err)
		return err // ❗注意：不要直接当作用户已存在！
	}
	if existing != nil {
		log.Println("⚠️ 用户已存在:", username)
		return errors.New("username already exists")
	}

	// 密码加密
	hashed, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		log.Println("❌ bcrypt 加密失败:", err)
		return err
	}

	user := &User{
		Username: username,
		Password: string(hashed),
	}

	if err := CreateUser(user); err != nil {
		log.Println("❌ 创建用户失败:", err)
		return err
	}

	log.Println("✅ 注册成功:", username)
	return nil
}
// Login 用户登录验证
func Login(username, password string) error {
	log.Println("🔐 Login called:", username)

	user, err := GetUserByUsername(username)
	if err != nil {
		log.Println("❌ 查询用户失败:", err)
		return errors.New("internal error")
	}
	if user == nil {
		log.Println("❌ 用户不存在:", username)
		return errors.New("user not found")
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password)); err != nil {
		log.Println("❌ 密码错误")
		return errors.New("invalid password")
	}

	log.Println("✅ Login success:", username)
	return nil
}
