package main

import (
	"fmt"
	"log"

	"fiberAir4/internal/config"
	"fiberAir4/internal/user"
	"fiberAir4/pkg/db"
	"fiberAir4/pkg/redis"

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

	// 路由
	api := app.Group("/api/user")
	api.Post("/register", user.RegisterHandler)
	api.Post("/login", user.LoginHandler)

	// 启动服务
	addr := fmt.Sprintf(":%d", config.Cfg.Server.Port)
	log.Printf("Starting server at %s...", addr)
	log.Fatal(app.Listen(addr))
}
