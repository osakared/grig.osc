# grig.osc

[![pipeline status](https://gitlab.com/haxe-grig/grig.osc/badges/main/pipeline.svg)](https://gitlab.com/haxe-grig/grig.osc/commits/main)
[![Build Status](https://travis-ci.org/osakared/grig.osc.svg?branch=main)](https://travis-ci.org/osakared/grig.osc)
[![Gitter](https://badges.gitter.im/haxe-grig/Lobby.svg)](https://gitter.im/haxe-grig/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

See the [haxe grig documentation](https://grig.tech/)

haxe implementation of OSC (open sound control)

Transports/targets supported so far:

| Target   | UDP        | TCP        | WebSocket | Threading |
| -------- | ---------- | ---------- | --------- | --------- |
| c++      | X          | X          |           | X         |
| hl       | X          | X          |           | X         |
| python   |            | X          |           | X         |
| nodejs   | X          | X          |           |           |
| html/js  |            |            | *         |           |
| lua      |            | O          |           |           |
| php      |            | O          |           |           |
| java     |            | X          |           | X         |
| c#       |            | X          |           | X         |
| neko     | X          | X          |           | X         |
| swf      |            | *          |           |           |

X - non-blocking
O - blocking only
* - when linking with openfl

All targets of course get the logic to parse osc so you can always supply your own transport by implementing `PacketListener` for servers and `PacketSender` for clients.