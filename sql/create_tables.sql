-- Create tables for the parquet data

CREATE TABLE games (
    steam_appid INTEGER PRIMARY KEY,
    type TEXT NOT NULL,
    name TEXT NOT NULL,
    required_age INTEGER NOT NULL,
    is_free BOOLEAN NOT NULL,
    currency TEXT,
    price_initial INTEGER,
    price_final INTEGER,
    discount_percent INTEGER,
    windows BOOLEAN NOT NULL,
    mac BOOLEAN NOT NULL,
    linux BOOLEAN NOT NULL,
    metacritic_score NUMERIC,
    metacritic_url TEXT,
    coming_soon BOOLEAN NOT NULL,
    release_date DATE,
    recommendations_total INTEGER
);

CREATE TABLE developers (
    developer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE genres (
    genre_id INTEGER PRIMARY KEY,
    description TEXT NOT NULL
);

CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    description TEXT NOT NULL
);


CREATE TABLE game_developers (
    steam_appid INTEGER NOT NULL,
    developer_id INTEGER NOT NULL,

    PRIMARY KEY (steam_appid, developer_id),

    FOREIGN KEY (steam_appid)
        REFERENCES games(steam_appid),

    FOREIGN KEY (developer_id)
        REFERENCES developers(developer_id)
);


CREATE TABLE game_publishers (
    steam_appid INTEGER NOT NULL,
    publisher_id INTEGER NOT NULL,

    PRIMARY KEY (steam_appid, publisher_id),

    FOREIGN KEY (steam_appid)
        REFERENCES games(steam_appid),

    FOREIGN KEY (publisher_id)
        REFERENCES publishers(publisher_id)
);

CREATE TABLE game_genres (
    steam_appid INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,

    PRIMARY KEY (steam_appid, genre_id),

    FOREIGN KEY (steam_appid)
        REFERENCES games(steam_appid),

    FOREIGN KEY (genre_id)
        REFERENCES genres(genre_id)
);

CREATE TABLE game_categories (
    steam_appid INTEGER NOT NULL,
    category_id INTEGER NOT NULL,

    PRIMARY KEY (steam_appid, category_id),

    FOREIGN KEY (steam_appid)
        REFERENCES games(steam_appid),

    FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);