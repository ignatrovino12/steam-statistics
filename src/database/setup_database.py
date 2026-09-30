import os
from pathlib import Path

import psycopg
from dotenv import load_dotenv


load_dotenv()

DB_HOST = "localhost"
DB_PORT = os.getenv("POSTGRES_PORT", "5432")
DB_NAME = os.getenv("POSTGRES_DB")
DB_USER = os.getenv("POSTGRES_USER")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD")

SQL_FILE = Path(__file__).resolve().parents[2] / "sql" / "create_tables.sql"


def main():
    sql = SQL_FILE.read_text(encoding="utf-8")

    with psycopg.connect(
        host=DB_HOST,
        port=DB_PORT,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
    ) as conn:
        with conn.cursor() as cur:
            cur.execute(sql)

        conn.commit()

    print("Database tables created successfully.")


if __name__ == "__main__":
    main()