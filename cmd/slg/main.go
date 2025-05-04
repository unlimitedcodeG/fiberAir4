package main

import (
	"fiberAir4/internal/config"
	"fiberAir4/internal/user"
	"fiberAir4/pkg/db"
	"log"

	"github.com/gofiber/fiber/v2"
)

func main() {
	// 加载配置
	config.Init()

	// 初始化数据库
	db.Init()
	if err := db.DB.AutoMigrate(&user.User{}); err != nil {
		log.Fatalf("AutoMigrate failed: %v", err)
	}

	// 启动 Fiber 服务
	app := fiber.New()

	// 路由
	api := app.Group("/api/user")
	api.Post("/register", user.RegisterHandler)
	api.Post("/login", user.LoginHandler)

	// 启动服务
	addr := ":" + fiber.Itoa(config.Cfg.Server.Port)
	log.Printf("Starting server at %s...", addr)
	log.Fatal(app.Listen(addr))
}
