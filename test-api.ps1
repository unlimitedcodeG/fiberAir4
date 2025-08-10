# FiberAir4 API测试脚本
# 设置环境变量和测试所有接口

Write-Host "🚀 FiberAir4 API测试脚本" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Green

# 设置环境变量
Write-Host "📝 设置环境变量..." -ForegroundColor Yellow
$env:JWT_SECRET = "youxi123"
Write-Host "✅ JWT_SECRET = $env:JWT_SECRET" -ForegroundColor Green

# 等待服务启动
Write-Host "`n⏰ 等待服务启动..." -ForegroundColor Yellow
Start-Sleep -Seconds 2

# 测试变量
$baseUrl = "http://localhost:8080"
$testUser = @{
    username = "test_user_$(Get-Random -Minimum 1000 -Maximum 9999)"
    password = "123456"
}

Write-Host "`n🧪 开始API测试..." -ForegroundColor Cyan
Write-Host "测试用户: $($testUser.username)" -ForegroundColor Gray

# 1. 测试健康检查
Write-Host "`n1️⃣ 测试健康检查接口" -ForegroundColor Blue
try {
    $healthResponse = Invoke-RestMethod -Uri "$baseUrl/health" -Method GET
    Write-Host "✅ 健康检查通过:" -ForegroundColor Green
    Write-Host "   服务: $($healthResponse.service)" -ForegroundColor Gray
    Write-Host "   状态: $($healthResponse.status)" -ForegroundColor Gray
    Write-Host "   时间戳: $($healthResponse.timestamp)" -ForegroundColor Gray
} catch {
    Write-Host "❌ 健康检查失败: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 2. 测试用户注册
Write-Host "`n2️⃣ 测试用户注册接口" -ForegroundColor Blue
try {
    $registerBody = @{
        username = $testUser.username
        password = $testUser.password
    } | ConvertTo-Json

    $registerResponse = Invoke-RestMethod -Uri "$baseUrl/api/user/register" -Method POST -Headers @{"Content-Type"="application/json"} -Body $registerBody
    Write-Host "✅ 用户注册成功: $($registerResponse.message)" -ForegroundColor Green
} catch {
    Write-Host "❌ 用户注册失败: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 3. 测试用户登录
Write-Host "`n3️⃣ 测试用户登录接口" -ForegroundColor Blue
try {
    $loginBody = @{
        username = $testUser.username
        password = $testUser.password
    } | ConvertTo-Json

    $loginResponse = Invoke-RestMethod -Uri "$baseUrl/api/user/login" -Method POST -Headers @{"Content-Type"="application/json"} -Body $loginBody
    Write-Host "✅ 用户登录成功:" -ForegroundColor Green
    Write-Host "   消息: $($loginResponse.message)" -ForegroundColor Gray
    Write-Host "   用户名: $($loginResponse.username)" -ForegroundColor Gray
    Write-Host "   用户ID: $($loginResponse.uid)" -ForegroundColor Gray
    Write-Host "   Token: $($loginResponse.token.Substring(0, 20))..." -ForegroundColor Gray
    
    $jwtToken = $loginResponse.token
} catch {
    Write-Host "❌ 用户登录失败: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 4. 测试游戏档案接口（需要JWT认证）
Write-Host "`n4️⃣ 测试游戏档案接口（JWT认证）" -ForegroundColor Blue
try {
    $profileHeaders = @{
        "Content-Type" = "application/json"
        "Authorization" = "Bearer $jwtToken"
    }
    
    $profileResponse = Invoke-RestMethod -Uri "$baseUrl/api/game/profile" -Method GET -Headers $profileHeaders
    Write-Host "✅ 游戏档案获取成功:" -ForegroundColor Green
    Write-Host "   用户ID: $($profileResponse.uid)" -ForegroundColor Gray
    Write-Host "   用户名: $($profileResponse.username)" -ForegroundColor Gray
    Write-Host "   消息: $($profileResponse.msg)" -ForegroundColor Gray
} catch {
    Write-Host "❌ 游戏档案获取失败: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 测试完成
Write-Host "`n🎉 所有API测试完成！" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Green

# 接口总结
Write-Host "`n📋 接口列表总结:" -ForegroundColor Cyan
Write-Host "1. GET  /health                - 健康检查 ✅" -ForegroundColor Gray
Write-Host "2. POST /api/user/register     - 用户注册 ✅" -ForegroundColor Gray
Write-Host "3. POST /api/user/login        - 用户登录 ✅" -ForegroundColor Gray
Write-Host "4. GET  /api/game/profile      - 游戏档案 ✅ (需要JWT)" -ForegroundColor Gray

Write-Host "`n🏷️ 环境信息:" -ForegroundColor Cyan
Write-Host "- Go版本: 1.24.6" -ForegroundColor Gray
Write-Host "- Fiber版本: v3.0.0-beta.5" -ForegroundColor Gray
Write-Host "- JWT_SECRET: $env:JWT_SECRET" -ForegroundColor Gray
Write-Host "- 服务地址: $baseUrl" -ForegroundColor Gray

Write-Host "`n💡 使用说明:" -ForegroundColor Yellow
Write-Host "1. 确保Air正在运行: air -c .air.windows.toml" -ForegroundColor Gray
Write-Host "2. 运行此脚本: .\test-api.ps1" -ForegroundColor Gray
Write-Host "3. 查看测试结果" -ForegroundColor Gray