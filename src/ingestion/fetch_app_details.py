import requests
import json
from pathlib import Path


appid = 10

url = "https://store.steampowered.com/api/appdetails"

params = {
    "appids": appid,
    "cc": "ro", # Romania prices
    "l": "english"
}

response = requests.get(url, params=params, timeout=30)

print("Status:", response.status_code)

response.raise_for_status()

data = response.json()

output_path = Path("data/raw/app_10.json")

with output_path.open("w", encoding="utf-8") as file:
    json.dump(data, file, indent=2, ensure_ascii=False)

print(f"Saved raw data to {output_path}")