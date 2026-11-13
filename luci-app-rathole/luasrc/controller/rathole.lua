module("luci.controller.rathole", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/rathole") then
		return
	end

	local page = entry({"admin", "services", "rathole"}, alias("admin", "services", "rathole", "general"), _("Rathole"), 60)
	page.dependent = true
	page.acl_depends = { "luci-app-rathole" }

	entry({"admin", "services", "rathole", "general"}, cbi("rathole/general"), _("General Settings"), 10).leaf = true
	entry({"admin", "services", "rathole", "server"}, cbi("rathole/server"), _("Server Settings"), 20).leaf = true
	entry({"admin", "services", "rathole", "client"}, cbi("rathole/client"), _("Client Settings"), 30).leaf = true

	entry({"admin", "services", "rathole", "status"}, call("action_status")).leaf = true
end

function action_status()
	local sys = require "luci.sys"
	local uci = require "luci.model.uci".cursor()

	local role = uci:get("rathole", "common", "role") or "both"
	local enabled = (uci:get("rathole", "common", "enabled") == "1")
	local binary_exists = nixio.fs.access("/usr/bin/rathole")

	local client_pid = nil
	local server_pid = nil

	-- Detect client instance PID
	local p_client = sys.exec("pgrep -f 'rathole.*--client' 2>/dev/null") or ""
	client_pid = tonumber(p_client:match("(%d+)"))

	-- Detect server instance PID
	local p_server = sys.exec("pgrep -f 'rathole.*--server' 2>/dev/null") or ""
	server_pid = tonumber(p_server:match("(%d+)"))

	-- Fallback for systems without pgrep
	if not client_pid and not server_pid then
		local ps_out = sys.exec("ps | grep '[r]athole' 2>/dev/null") or ""
		for line in ps_out:gmatch("[^\r\n]+") do
			local pid = line:match("^%s*(%d+)")
			if pid then
				if line:find("%-%-client") then
					client_pid = tonumber(pid)
				elseif line:find("%-%-server") then
					server_pid = tonumber(pid)
				end
			end
		end
	end

	luci.http.prepare_content("application/json")
	luci.http.write_json({
		binary_exists = binary_exists,
		enabled = enabled,
		role = role,
		client_running = (client_pid ~= nil),
		client_pid = client_pid,
		server_running = (server_pid ~= nil),
		server_pid = server_pid
	})
end
