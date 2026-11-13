local m, s

m = Map("rathole", translate("Rathole"), translate("A lightweight and high-performance reverse proxy for NAT traversal written in Rust."))

-- Status monitoring panel
local status_view = m:section(SimpleSection)
status_view.template = "rathole/status"

s = m:section(NamedSection, "common", "rathole", translate("General Settings"))
s.anonymous = true
s.addremove = false

local enabled = s:option(Flag, "enabled", translate("Enable"))
enabled.rmempty = false
enabled.default = "0"

local role = s:option(ListValue, "role", translate("Running Mode"))
role:value("both", translate("Both (Client & Server)"))
role:value("client", translate("Client Only"))
role:value("server", translate("Server Only"))
role.default = "both"

local log_level = s:option(ListValue, "log_level", translate("Log Level"))
log_level:value("error", "Error")
log_level:value("warn", "Warn")
log_level:value("info", "Info")
log_level:value("debug", "Debug")
log_level:value("trace", "Trace")
log_level.default = "error"

function m.on_after_commit(self)
	luci.sys.call("/etc/init.d/rathole restart >/dev/null 2>&1")
end

return m