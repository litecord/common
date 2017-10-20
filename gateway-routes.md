Gateway Routes
---------------

A litecord gateway, other than already implementing
the websocket protocol defined by the Discord API docs,
has to implement internal HTTP routes for communication
between parts of the system.

## `GET:/state?user=USER_ID`

Get the current websocket state about a user who is connected.
 - Returns `204` if the user is not connected
 - Returns a JSON payload if the user is connected:
   - **TODO: show it**

## `GET:/shard_state?user=USER_ID&shard=SHARD_ID`

Get the current websocket state about a shard.
 - Returns `400` if the shard_id doesn't exist,
   or if the user isn't a sharded bot.
 - Returns a JSON payload on success:
   - **TODO**

## `POST:/payload`
 - Receives a JSON payload with the fields `user_id` and `payload`
 - Returns `204`.

