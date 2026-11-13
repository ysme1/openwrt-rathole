# openwrt-rathole

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![OpenWrt](https://img.shields.io/badge/OpenWrt-21.02%20~%2024.10+-brightgreen.svg)](https://openwrt.org/)
[![Package](https://img.shields.io/badge/Package-APK%20%7C%20IPK-orange.svg)](#)

适用于 OpenWrt 的高性能反向代理与内网穿透工具 **[Rathole](https://github.com/rathole-org/rathole)** 的 LuCI Web 控制面板。

---

## ✨ 特性

- ⚡ **高性能**：基于 Rust 编写的 Rathole，内存占用极低，高并发稳定。
- 🌐 **双模式支持**：支持客户端（Client）、服务端（Server）及双模式（Both）独立或同时运行。
- 🔒 **安全加密**：支持 TCP、Noise 协议及 TLS 传输加密。
- 📦 **全版本兼容**：同时提供现代 OpenWrt 24.10+ 的 `.apk` 与经典系统的 `.ipk` 安装包。
- 🎨 **原生体验**：遵循 OpenWrt 标准 Controller 架构，完美适配各类 LuCI 主题。

---

## 📸 界面预览

### 通用设置 (Base)
![通用设置](Base.png)

### 服务端设置 (Server)
![服务端设置](Server.png)

### 客户端设置 (Client)
![客户端设置](Client.png)

---

## 📥 快速安装

前往 [Releases](../../releases) 下载对应设备架构（如 `aarch64` / `x86_64`）的最新安装包：

### OpenWrt 24.10+ (APK 包管理器)
```bash
apk add --allow-untrusted /tmp/luci-app-rathole_*.apk
```

### OpenWrt 21.02 / 22.03 / 23.05 (OPKG 包管理器)
```bash
opkg update
opkg install /tmp/luci-app-rathole_*.ipk
```

---

## ⚙️ 快速配置示例 (`/etc/config/rathole`)

```uci
config rathole 'common'
	option enabled '1'
	option role 'both'
	option log_level 'info'

config server 'server'
	option bind_addr '0.0.0.0:2333'
	option default_token 'my_secret_token'
	option heartbeat_interval '30'

config client 'client'
	option remote_addr 'vcloud.example.com:2333'
	option default_token 'my_secret_token'
	option heartbeat_timeout '40'
	option retry_interval '1'

config server_service
	option name 'ssh'
	option bind_addr '0.0.0.0:2222'

config client_service
	option name 'ssh'
	option local_addr '127.0.0.1:22'
	option nodelay '1'
```

---

## 🛠️ 编译进固件 (源码编译)

```bash
# 1. 克隆到 OpenWrt 源码目录
git clone https://github.com/ysme1/luci-app-rathole.git package/luci-app-rathole

# 2. 更新并安装 feed
./scripts/feeds update -a
./scripts/feeds install -a

# 3. 在 menuconfig 中选中
# LuCI -> 3. Applications -> <*> luci-app-rathole
make menuconfig

# 4. 执行编译
make package/luci-app-rathole/compile V=s
```

---

## 📄 License

[Apache License 2.0](LICENSE)
