import json
import time
from pathlib import Path

import requests
from datetime import date

INGESTION_DATE = date.today().isoformat()

INPUT_PATH = Path("data/raw/steam_apps.json")
OUTPUT_DIR = Path(f"data/raw/individual/ingestion_date={INGESTION_DATE}")

URL = "https://store.steampowered.com/api/appdetails"


# Load app list
with INPUT_PATH.open("r", encoding="utf-8") as file:
    data = json.load(file)

apps = data["response"]["apps"]

print(f"Found {len(apps)} apps.")


# Create output directory
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


# Fetch details for each app
for index, app in enumerate(apps, start=1):
    appid = app["appid"]

    output_path = OUTPUT_DIR / f"app_{appid}.json"

    # Skip if we already downloaded this app
    if output_path.exists():
        print(f"[{index}/{len(apps)}] App {appid} already exists. Skipping.")
        continue

    params = {
        "appids": appid,
        "cc": "ro",
        "l": "english",
    }

    try:
        response = requests.get(
            URL,
            params=params,
            timeout=30,
        )

        response.raise_for_status()

        result = response.json()

        with output_path.open("w", encoding="utf-8") as file:
            json.dump(
                result,
                file,
                indent=2,
                ensure_ascii=False,
            )

        print(f"[{index}/{len(apps)}] Saved app {appid}")

    except requests.RequestException as error:
        print(f"[{index}/{len(apps)}] Failed app {appid}: {error}")

    time.sleep(0.5)