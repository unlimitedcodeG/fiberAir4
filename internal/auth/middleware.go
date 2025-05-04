package auth

import (
	"strings"

	"github.com/gofiber/fiber/v3"
)

// JWTAuth 是 Fiber 中间件：校验 token、验证 Redis 状态、注入 uid/username
func JWTAuth() fiber.Handler {
	return func(c fiber.Ctx) error {
		authHeader := c.Get("Authorization")
		if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
				"error": "missing or invalid token",
			})
		}

		tokenStr := strings.TrimPrefix(authHeader, "Bearer ")

		claims, err := ParseJWT(tokenStr)
		if err != nil {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
				"error": "invalid or expired token",
			})
		}

		// Redis 校验是否当前 token 合法（未被踢/登出）
		if !IsTokenValid(claims.Uid, tokenStr) {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
				"error": "token has been invalidated",
			})
		}

		// 注入用户信息到上下文
		c.Locals("uid", claims.Uid)
		c.Locals("username", claims.Username)

		return c.Next()
	}
}
