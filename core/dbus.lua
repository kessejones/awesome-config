local dbus = require("dbus")

dbus.request_name("session", "org.awesomewm.audio")
dbus.add_match("session", "interface='org.awesomewm.audio'")
