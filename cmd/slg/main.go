package main

import (
	"fmt"
	"log"
	"time"

	"fiberAir4/internal/auth"
	"fiberAir4/internal/config"
	"fiberAir4/internal/user"
	"fiberAir4/pkg/db"
	"fiberAir4/pkg/redis" // 👈 加上这行

	"github.com/gofiber/fiber/v3"
)

func main() {
	// 加载配置
	config.Init()

	// 初始化数据库
	db.Init()
	redis.Init() // ✅ 这句不能漏！
	if err := db.DB.AutoMigrate(&user.User{}); err != nil {
		log.Fatalf("AutoMigrate failed: %v", err)
	}

	// 启动 Fiber v3 服务
	app := fiber.New()

	// 健康检查端点
	app.Get("/health", func(c fiber.Ctx) error {
		return c.JSON(fiber.Map{
			"status":    "ok",
			"service":   "fiberair4",
			"timestamp": time.Now().Unix(),
		})
	})

	// 路由
	api := app.Group("/api/user")
	api.Post("/register", user.RegisterHandler)
	api.Post("/login", user.LoginHandler)

	// 启动服务
	addr := fmt.Sprintf(":%d", config.Cfg.Server.Port)
	log.Printf("Starting server at %s...", addr)
	log.Fatal(app.Listen(addr))

	// 登录后的接口
	game := app.Group("/api/game", auth.JWTAuth())

	game.Get("/profile", func(c fiber.Ctx) error {
		uid := c.Locals("uid").(int64)
		username := c.Locals("username").(string)
		return c.JSON(fiber.Map{
			"uid":      uid,
			"username": username,
			"msg":      "你已通过身份验证，欢迎进入游戏！",
		})
	})
}
