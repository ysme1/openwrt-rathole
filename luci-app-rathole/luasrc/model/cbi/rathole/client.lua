local m, cli, cli_svc

m = Map("rathole", translate("Rathole - Client Settings"), translate("Configure Rathole client remote server connection and local service mappings."))

cli = m:section(NamedSection, "client", "client", translate("Client Basic Settings"))
cli.anonymous = true
cli.addremove = false

local cli_remote = cli:option(Value, "remote_addr", translate("Remote Server Address"), translate("IP/domain and control port of the public Rathole server (e.g. example.com:2333)"))
cli_remote.placeholder = "example.com:2333"
cli_remote.rmempty = false

local cli_def_token = cli:option(Value, "default_token", translate("Default Token"), translate("Service-level default authentication token. Services without explicit token will inherit this."))
cli_def_token.password = true
cli_def_token.rmempty = true

local cli_hb = cli:option(Value, "heartbeat_timeout", translate("Heartbeat Timeout (seconds)"), translate("Timeout for detecting dead connection. Must be greater than server heartbeat_interval. Set to 0 to disable, default is 40."))
cli_hb.datatype = "uinteger"
cli_hb.placeholder = "40"
cli_hb.default = "40"

local cli_retry = cli:option(Value, "retry_interval", translate("Retry Interval (seconds)"), translate("Interval for reconnecting after connection drop, default is 1."))
cli_retry.datatype = "uinteger"
cli_retry.placeholder = "1"
cli_retry.default = "1"

local cli_transport = cli:option(ListValue, "transport", translate("Transport Protocol"))
cli_transport:value("tcp", "TCP")
cli_transport:value("noise", "Noise")
cli_transport:value("tls", "TLS")
cli_transport.default = "tcp"

local cli_proxy = cli:option(Value, "proxy", translate("Outbound Proxy (Optional)"), translate("Proxy used when connecting to server, e.g. socks5://127.0.0.1:1080 or http://..."))
cli_proxy.placeholder = "socks5://127.0.0.1:1080"
cli_proxy.rmempty = true

local cli_nodelay = cli:option(Flag, "nodelay", translate("TCP NoDelay Mode"))
cli_nodelay.default = "1"
cli_nodelay.rmempty = true

-- Local services
cli_svc = m:section(TypedSection, "client_service", translate("Client Services (Local Forwarding)"))
cli_svc.anonymous = true
cli_svc.addremove = true
cli_svc.template = "cbi/tblsection"

local c_name = cli_svc:option(Value, "name", translate("Service Name"))
c_name.placeholder = "ssh"
c_name.rmempty = true

local c_local = cli_svc:option(Value, "local_addr", translate("Local Service Address"), translate("e.g. 127.0.0.1:22 or 192.168.1.50:80"))
c_local.placeholder = "127.0.0.1:22"
c_local.rmempty = true

local c_token = cli_svc:option(Value, "token", translate("Custom Token"), translate("Leave blank to inherit global default token."))
c_token.password = true
c_token.rmempty = true

local c_type = cli_svc:option(ListValue, "type", translate("Service Type"))
c_type:value("tcp", "TCP")
c_type:value("udp", "UDP")
c_type.default = "tcp"

local c_nodelay = cli_svc:option(Flag, "nodelay", translate("TCP NoDelay"))
c_nodelay.default = "1"
c_nodelay.rmempty = true

function m.on_after_commit(self)
	luci.sys.call("/etc/init.d/rathole restart >/dev/null 2>&1")
end

return m
