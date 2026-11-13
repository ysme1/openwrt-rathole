local m, srv, srv_svc

m = Map("rathole", translate("Rathole - Server Settings"), translate("Configure Rathole server control tunnel and exposed public services."))

srv = m:section(NamedSection, "server", "server", translate("Server Basic Settings"))
srv.anonymous = true
srv.addremove = false

local srv_bind = srv:option(Value, "bind_addr", translate("Control Listen Address"), translate("Address and port for control connection between client and server (e.g. 0.0.0.0:2333)"))
srv_bind.datatype = "hostport"
srv_bind.placeholder = "0.0.0.0:2333"
srv_bind.default = "0.0.0.0:2333"
srv_bind.rmempty = false

local srv_def_token = srv:option(Value, "default_token", translate("Default Token"), translate("Service-level default authentication token. Services without explicit token will inherit this."))
srv_def_token.password = true
srv_def_token.rmempty = true

local srv_hb = srv:option(Value, "heartbeat_interval", translate("Heartbeat Interval (seconds)"), translate("Interval for sending application-layer heartbeat to client. Set to 0 to disable, default is 30."))
srv_hb.datatype = "uinteger"
srv_hb.placeholder = "30"
srv_hb.default = "30"

local srv_transport = srv:option(ListValue, "transport", translate("Transport Protocol"))
srv_transport:value("tcp", "TCP")
srv_transport:value("noise", "Noise")
srv_transport:value("tls", "TLS")
srv_transport.default = "tcp"

local srv_nodelay = srv:option(Flag, "nodelay", translate("TCP NoDelay Mode"), translate("Enable to reduce latency, disable to increase throughput."))
srv_nodelay.default = "1"
srv_nodelay.rmempty = true

-- Exposed services
srv_svc = m:section(TypedSection, "server_service", translate("Server Services (Exposed Endpoints)"))
srv_svc.anonymous = true
srv_svc.addremove = true
srv_svc.template = "cbi/tblsection"

local s_name = srv_svc:option(Value, "name", translate("Service Name"))
s_name.placeholder = "ssh"
s_name.rmempty = true

local s_bind_addr = srv_svc:option(Value, "bind_addr", translate("Public Bind Address"), translate("e.g. 0.0.0.0:2222"))
s_bind_addr.placeholder = "0.0.0.0:2222"
s_bind_addr.rmempty = true

local s_token = srv_svc:option(Value, "token", translate("Custom Token"), translate("Leave blank to inherit global default token."))
s_token.password = true
s_token.rmempty = true

local s_type = srv_svc:option(ListValue, "type", translate("Service Type"))
s_type:value("tcp", "TCP")
s_type:value("udp", "UDP")
s_type.default = "tcp"

local s_nodelay = srv_svc:option(Flag, "nodelay", translate("NoDelay"))
s_nodelay.default = "1"
s_nodelay.rmempty = true

function m.on_after_commit(self)
	luci.sys.call("/etc/init.d/rathole restart >/dev/null 2>&1")
end

return m
