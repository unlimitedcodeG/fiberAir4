package user

import (
	"fiberAir4/internal/config"
	"fiberAir4/pkg/db"
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
)

func init() {
	// 获取项目根目录的绝对路径
	root, _ := filepath.Abs("../../") // fiberAir4 是根目录

	configPath := filepath.Join(root, "internal", "config", "config.yml")
	os.Setenv("CFG_PATH", configPath)

	config.Init()
	db.Init() // ✅ 初始化数据库
}

func TestLogin(t *testing.T) {
	const username = "login_test_user"
	const password = "secure123"

	// ⚠️ 先注册一个用户，避免测试失败
	_ = Register(username, password)

	t.Run("登录成功", func(t *testing.T) {
		err := Login(username, password)
		assert.NoError(t, err)
	})

	t.Run("用户不存在", func(t *testing.T) {
		err := Login("non_existent_user_xxx", password)
		assert.EqualError(t, err, "user not found")
	})

	t.Run("密码错误", func(t *testing.T) {
		err := Login(username, "wrongpassword")
		assert.EqualError(t, err, "invalid password")
	})
}
