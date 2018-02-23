/*
 Litecord schema file
 */

-- Thank you FrostLuma for giving those functions
-- convert Discord snowflake to timestamp
CREATE OR REPLACE FUNCTION snowflake_time (snowflake BIGINT)
    RETURNS TIMESTAMP AS $$
BEGIN
    RETURN to_timestamp(((snowflake >> 22) + 1420070400000) / 1000);
END; $$
LANGUAGE PLPGSQL;


-- convert timestamp to Discord snowflake
CREATE OR REPLACE FUNCTION time_snowflake (date TIMESTAMP WITH TIME ZONE)
    RETURNS BIGINT AS $$
BEGIN
    RETURN CAST(EXTRACT(epoch FROM date) * 1000 - 1420070400000 AS BIGINT) << 22;
END; $$
LANGUAGE PLPGSQL;


CREATE TABLE IF NOT EXISTS users (
    /* Basic user information */
    id text PRIMARY KEY NOT NULL,
    username varchar(32) NOT NULL,
    discriminator varchar(4) NOT NULL,
    avatar text,

    /* User properties */
    bot boolean DEFAULT FALSE,
    mfa_enabled boolean DEFAULT FALSE,
    verified boolean DEFAULT FALSE,
    email varchar(255) NOT NULL,
    flags int DEFAULT 0,

    /* Private information */
    phone varchar(60) DEFAULT '',
    password_hash text NOT NULL,
    password_salt text NOT NULL
);

CREATE TABLE IF NOT EXISTS channels (
    id text PRIMARY KEY NOT NULL,
    channel_type int NOT NULL,
    name varchar(100) NOT NULL,
    position int NOT NULL,
    topic varchar(1024)
);


CREATE TABLE IF NOT EXISTS guilds (
    id text PRIMARY KEY NOT NULL,
    name varchar(100) NOT NULL,
    icon text,
    splash text,
    owner_id text NOT NULL REFERENCES users (id),

    region text NOT NULL,
    afk_channel_id text,
    afk_timeout int,
    
    verification_level int DEFAULT 0,
    default_message_notifications int,
    explicit_content_filter int DEFAULT 0, /* goes from 0-2 */
    mfa_level int DEFAULT 0,

    embed_enabled boolean DEFAULT false,
    embed_channel_id text REFERENCES channels (id) DEFAULT NULL,

    widget_enabled boolean DEFAULT false,
    widget_channel_id text REFERENCES channels (id) DEFAULT NULL,

    system_channel_id text REFERENCES channels (id) DEFAULT NULL,
    features text /* JSON encoded data, like "[\"VANITY_URL\"]" */
);

ALTER TABLE channels ADD COLUMN
    guild_id text NOT NULL REFERENCES guilds (id) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS members (
    user_id text NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    guild_id text NOT NULL REFERENCES guilds (id) ON DELETE CASCADE,
    nickname varchar(100),
    joined_at timestamp without time zone default now(),
    PRIMARY KEY (user_id, guild_id)
);

CREATE TABLE IF NOT EXISTS roles (
    id text PRIMARY KEY NOT NULL,
    guild_id text NOT NULL REFERENCES guilds (id) ON DELETE CASCADE,
    name varchar(100) NOT NULL,
    position int NOT NULL,
    permissions int NOT NULL
);

/* Represents a role a member has. */
CREATE TABLE IF NOT EXISTS member_roles (
    user_id text NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    guild_id text NOT NULL REFERENCES guilds (id) ON DELETE CASCADE,
    role_id text NOT NULL REFERENCES roles (id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, guild_id, role_id)
);

CREATE TABLE IF NOT EXISTS bans (
    user_id text NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    guild_id text NOT NULL REFERENCES guilds (id) ON DELETE CASCADE,
    reason varchar(500),
    PRIMARY KEY (user_id, guild_id)
);
