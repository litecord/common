CREATE TABLE users (
    /* Basic user information */
    id text PRIMARY KEY NOT NULL,
    username varchar(80) NOT NULL,
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
    password_salt text NOT NULL,
);

CREATE TABLE guilds (
    id text PRIMARY KEY NOT NULL,
    name varchar(255) NOT NULL, /* TODO: get max guild name size in discord */
    icon text,
    splash text,
    owner_id text NOT NULL REFERENCES users (id),

    region text NOT NULL,
    afk_channel_id text,
    afk_timeout int,
    
    verification_level int DEFAULT 0,
    default_message_notifications int,
    explicit_content_filter boolean, /* Does this exist? */
    mfa_level int DEFAULT 0,
 
    features text, /* JSON encoded data, like "[\"VANITY_URL\"]" */
);

CREATE TABLE members (
    user_id text NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    guild_id text NOT NULL REFERENCES guilds (id) ON DELETE CASCADE,
    nickname varchar(100),
    PRIMARY KEY (user_id, guild_id)
);

CREATE TABLE channels (
    id text PRIMARY KEY NOT NULL,
    guild_id text NOT NULL REFERENCES guilds (id) ON DELETE CASCADE,
    channel_type int NOT NULL,
    name varchar(255) NOT NULL,
    position int NOT NULL,
    topic varchar(1024),
);

CREATE TABLE roles (
    id text PRIMARY KEY NOT NULL
    guild_id text NOT NULL REFERENCES guilds (id) ON DELETE CASCADE,
    position int NOT NULL,
    permissions int NOT NULL,
);

/* Represents a role a member has. */
CREATE TABLE member_roles (
    user_id text NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    guild_id text NOT NULL REFERENCES guilds (id) ON DELETE CASCADE,
    role_id text NOT NULL REFERENCES roles (id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, guild_id, role_id)
);

CREATE TABLE bans (
    user_id text NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    guild_id text NOT NULL REFERENCES guilds (id) ON DELETE CASCADE,
    reason varchar(500),
    PRIMARY KEY (user_id, guild_id),
);
