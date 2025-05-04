package user

import (
	"encoding/json"
	"fiberAir4/internal/auth"
	"log"

	"github.com/gofiber/fiber/v3"
)

type req struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

func parseBody[T any](c fiber.Ctx, dst *T) error {
	return json.Unmarshal(c.Body(), dst)
}

// ✅ 注册接口（简化逻辑）
func RegisterHandler(c fiber.Ctx) error {
	var r req
	if err := parseBody(c, &r); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid request"})
	}
	if err := Register(r.Username, r.Password); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": err.Error()})
	}
	return c.JSON(fiber.Map{"message": "register success"})
}

// ✅ 登录接口：生成 token，写入 Redis
func LoginHandler(c fiber.Ctx) error {
	var r req
	if err := parseBody(c, &r); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid request"})
	}

	err := Login(r.Username, r.Password)
	if err != nil {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error": err.Error()})
	}

	// 查找用户
	user, err := GetUserByUsername(r.Username)
	if err != nil || user == nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "user lookup failed"})
	}

	// ✅ 生成 token
	token, err := auth.GenerateJWT(user.ID, user.Username)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "token generate failed"})
	}

	// ✅ 写入 Redis
	if err := auth.SaveToken(user.ID, token); err != nil {
		log.Println("❌ Redis SaveToken failed:", err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "login session error"})
	}

	return c.JSON(fiber.Map{
		"message":  "login success",
		"token":    token,
		"username": user.Username,
		"uid":      user.ID,
	})
}
