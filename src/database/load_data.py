import os
from pathlib import Path

import pandas as pd
import psycopg
from dotenv import load_dotenv


load_dotenv()

DB_HOST = "localhost"
DB_PORT = os.getenv("POSTGRES_PORT", "5432")
DB_NAME = os.getenv("POSTGRES_DB")
DB_USER = os.getenv("POSTGRES_USER")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD")

DATA_DIR = Path(__file__).resolve().parents[2] / "data" / "processed"


def get_connection():
    return psycopg.connect(
        host=DB_HOST,
        port=DB_PORT,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
    )

def _load_table(conn, dataframe, table, columns):
    dataframe = dataframe.loc[:, columns].astype(object).where(
        pd.notna(dataframe.loc[:, columns]), None
    )
    rows = dataframe.itertuples(index=False, name=None)
    column_names = ", ".join(columns)
    placeholders = ", ".join(["%s"] * len(columns))

    with conn.cursor() as cur:
        cur.executemany(
            f"INSERT INTO {table} ({column_names}) VALUES ({placeholders})",
            rows,
        )

def load_games(conn, games):
    _load_table(
        conn,
        games,
        "games",
        [
            "steam_appid",
            "type",
            "name",
            "required_age",
            "is_free",
            "currency",
            "price_initial",
            "price_final",
            "discount_percent",
            "windows",
            "mac",
            "linux",
            "metacritic_score",
            "metacritic_url",
            "coming_soon",
            "release_date",
            "recommendations_total",
        ],
    )


def load_developers(conn, developers):
    _load_table(conn, developers, "developers", ["developer_id", "name"])


def load_publishers(conn, publishers):
    _load_table(conn, publishers, "publishers", ["publisher_id", "name"])


def load_genres(conn, genres):
    _load_table(conn, genres, "genres", ["genre_id", "description"])


def load_categories(conn, categories):
    _load_table(conn, categories, "categories", ["category_id", "description"])


def load_game_developers(conn, game_developers):
    _load_table(
        conn,
        game_developers,
        "game_developers",
        ["steam_appid", "developer_id"],
    )


def load_game_publishers(conn, game_publishers):
    _load_table(
        conn,
        game_publishers,
        "game_publishers",
        ["steam_appid", "publisher_id"],
    )


def load_game_genres(conn, game_genres):
    _load_table(conn, game_genres, "game_genres", ["steam_appid", "genre_id"])


def load_game_categories(conn, game_categories):
    _load_table(
        conn,
        game_categories,
        "game_categories",
        ["steam_appid", "category_id"],
    )


def main():
    table_names = [
        "games",
        "developers",
        "publishers",
        "genres",
        "categories",
        "game_developers",
        "game_publishers",
        "game_genres",
        "game_categories",
    ]
    tables = {
        table_name: pd.read_parquet(DATA_DIR / f"{table_name}.parquet")
        for table_name in table_names
    }

    for table_name, dataframe in tables.items():
        print(f"{table_name}: {dataframe.shape}")

    with get_connection() as conn:
        load_games(conn, tables["games"])
        load_developers(conn, tables["developers"])
        load_publishers(conn, tables["publishers"])
        load_genres(conn, tables["genres"])
        load_categories(conn, tables["categories"])
        load_game_developers(conn, tables["game_developers"])
        load_game_publishers(conn, tables["game_publishers"])
        load_game_genres(conn, tables["game_genres"])
        load_game_categories(conn, tables["game_categories"])

    print("All data loaded successfully.")


if __name__ == "__main__":
    main()