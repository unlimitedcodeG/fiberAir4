package user

import (
	"encoding/json"

	"github.com/gofiber/fiber/v3"
)

type req struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

func parseBody[T any](c fiber.Ctx, dst *T) error {
	return json.Unmarshal(c.Body(), dst)
}

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

func LoginHandler(c fiber.Ctx) error {
	var r req
	if err := parseBody(c, &r); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid request"})
	}
	if err := Login(r.Username, r.Password); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": err.Error()})
	}

	// ✅ 登录成功，生成 token
	token, err := GenerateJWT(r.Username)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "failed to generate token"})
	}

	return c.JSON(fiber.Map{
		"message": "login success",
		"token":   token,
	})
}
