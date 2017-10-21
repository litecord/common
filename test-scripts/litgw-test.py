import logging
import asyncio
import json

import websockets

logging.basicConfig(level=logging.DEBUG)


async def heartbeat(conn, timeout):
    pass

async def main():
    logging.info('connecting')
    async with websockets.connect('ws://localhost:8080/gw') as conn:
        logging.info('done!')
        hello = await conn.recv()
        hello = json.loads(hello)
        loop.create_task(heartbeat(conn, hello['heartbeat_interval'] / 1000))

        while True:
            logging.info('Getting data')
            data = await conn.recv()
            logging.info(data)

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
    loop.close()
