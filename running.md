# Running an instance of Litecord

This guide assumes you're running the official gateway component
and the [`rest-py`](https://github.com/litecord/rest-py) component

## Requirements

 - A Linux system
 - PostgreSQL
 - Elixir 1.6.4
 - Python 3.6.4

## Pre-Installation

Firstly, start postgres and run the schema file(from this repo) there.
You can create your own litecord user (recommended).

```
CREATE USER litecord WITH PASSWORD 'somethingsecure';
CREATE DATABASE litecord;
GRANT ALL PRIVILEGES ON DATABASE litecord TO litecord;
```

```bash
psql -U litecord -f schema.sql
```

## Installing `gateway`

```bash
git clone https://github.com/litecord/gateway
cd gateway
mix deps.get
mix compile
```

After installing, you should change the configuration for the gateway
on the `config/config.exs` file (you should not change `http_port` and `https_port`).

## Running gateway

```bash
iex -S mix
```

No, there aren't any "hot reload" commands of fancy deployment strategies
with [distillery](https://github.com/bitwalker/distillery) or [edeliver](https://github.com/edeliver/edeliver).
Feel free if you want to make one though.

## Installing `rest-py`

```bash
git clone https://github.com/litecord/rest-py
cd rest-py

# the use of a separated enviroment is recommended
python3.6 -m venv env
env/bin/python -m pip install -Ur requirements.txt
```

## Running `rest-py`

```bash
env/bin/python run.py
```
