import os
import requests
import json
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()

api_key = os.getenv("STEAM_API_KEY")

url = "https://api.steampowered.com/IStoreService/GetAppList/v1/"

params = {
    "key": api_key,
    "max_results": 1000
}

response = requests.get(url, params=params, timeout=30)

print("Status:", response.status_code)

response.raise_for_status()

data = response.json()

output_path = Path("data/raw/steam_apps.json")
output_path.parent.mkdir(parents=True, exist_ok=True)

with output_path.open("w", encoding="utf-8") as file:
    json.dump(data, file, indent=2, ensure_ascii=False)

print(f"Saved raw data to {output_path}")