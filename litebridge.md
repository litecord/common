Common Protocol
=======

This is a custom protocol running over websockets
to request and send commands between Litecord components.


# OP table

| OP Code | OP Name | Sent by |
|:-------:|:-------:|:-------:|
| 0 | `HELLO` | Server |
| 1 | `HELLO_ACK` | Client |
| 2 | `HEARTBEAT` | Client |
| 3 | `HEARTBEAT_ACK` | Server |
| 4 | `REQUEST` | Client |
| 5 | `RESPONSE` | Server |
| 6 | `DISPATCH` | Client |

# Close code table
| Close Code | Meaning |
|:----------:|:-------:|
| 4001 | Authentication Failed |
| 4002 | Requesting without authentication |
| 4003 | Heartbeat timeout |

# General packet format

```javascript
{
    "op": OP_CODE_OF_PACKET,
    ...
}
```

The rest of the payload examples assume those fields
are in them.

# Note about reconnecting

If a client's websocket fails for any reason, it should wait a random
amount of time (minimum 1 second), and then reconnect.

## OP 0 Hello

Sent by the server on the start of the websocket connection
to request a handshake by the client, with it sending an `OP 1 HELLO ACK`

### Fields

 - `hb_interval` [int]: Heartbeat Interval, in milliseconds

### Example
```javascript
{
    "op": 0,
    "hb_interval": 10000
}
```

## OP 1 Hello ACK

Acknowledgment by the client that it received the `OP 0 HELLO`
and they can start heartbeating.

### Fields

 - `password`[str]: Can be any common secret between the
   Client and the Server.

### Example

```javascript
{
    "op": 1,
    "password": "helloworld",
}
```

## OP 2 Heartbeat

Should be sent by the client every `hb_interval` milliseconds.
The connection will close if the client tries to heartbeat before
sending `OP 1 HELLO ACK`.

The server will assume client death if the client
doesnt send a heartbeat packet in that time period.

### Example
```javascript
{
    "op": 2
}
```

## OP 3 Heartbeat ACK

Sent by the server everytime it receives an `OP 2 HEARTBEAT`.

### Example

```javascript
{
    "op": 3
}
```

## OP 4 Request

Sent by the client to request something from the server.
The actual payload follows a format, but the allowed content is defined
by the implementation.

### Fields

All fields are required
 - `w` [str]: What to request.
 - `a` [list[any]]: Arguments to the request.
 - `n` [any]: Request nonce.

### Example
```
{
    "op": 4,
    "w": "ANYTHING",
    "a": [],
    "n": 1
}
```

## OP 5 Response

Sent by the server to indicate a response sent by the client.

### Fields
 - `n` [any]: The nonce sent by the client in `OP 4 REQUEST`.
 - `r` [any]: Response data.

### Example
```javascript
{
    "op": 5,
    "n": 1,
    "r": ["you're gay"]
}
```

## OP 6 Dispatch

Sent by the client to request something it knows it won't get
a reply(`OP 5 RESPONSE`) to.

### Fields
 - Same as `OP 4 REQUEST`, but without `n`.

### Example

```javascript
{
    "op": 6,
    "w": "ANYTHING",
    "a": []
}
```

TODO
------

Maybe add a way to use zlib for payload compression?
