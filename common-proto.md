Common Protocol
=======

This is a custom protocol running over websockets
to request and send commands between Litecord components.


# OP table

| OP Code | OP Name | Sent by |
|---------|:-------:|---------:|
| 0 | `HELLO` | Server |
| 1 | `HELLO_ACK` | Client |
| 2 | `HEARTBEAT` | Client |
| 3 | `HEARTBEAT_ACK` | Server |
| 4 | `REQUEST` | Client |
| 5 | `RESPONSE` | Server |
| 6 | `DISPATCH` | Client |

# General packet format

```javascript
{
    "op": OP_CODE_OF_PACKET,
    ...
}
```

The rest of the payload examples assume those fields
are in them.

## OP 0 Hello

Sent by the server on the start of the websocket connection
to request a handshake by the client, with it sending an `OP 1 HELLO ACK`

### Fields

 - `hb_interval [int]`: Heartbeat Interval, in milliseconds

### Example
```javascript
{
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

## OP 5 Response

## OP 6 Dispatch