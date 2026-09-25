Apps Dataset
├── 1000 rows
├── 4 columns
│
├── appid
│   ├── integer
│   ├── unique
│   ├── positive
│   └── no missing values
│
├── name
│   ├── string
│   ├── no missing values
│   ├── no empty strings
│   └── 999 unique values (1 duplicate)
│
├── last_modified
│   ├── integer Unix timestamp
│   └── can be converted to datetime
│
└── price_change_number
    ├── integer
    ├── no missing values
    ├── several repeated values
    └── represents version number of price change


1 App Data
│
├── type               → simple string value
├── name               → simple string value
├── steam_appid        → simple integer value
├── required_age       → simple integer value
├── is_free            → boolean value
│
├── price_overview     → dict
│   ├── currency       → string
│   ├── initial        → integer
│   ├── final          → integer
│   └── discount_percent → integer
│
├── developers         → list[str]
├── publishers         → list[str]
│
├── platforms          → dict[str, bool]
│   ├── windows        → boolean
│   ├── mac            → boolean
│   └── linux          → boolean
│
├── genres             → list[dict]
│   └── each item
│       ├── id         → string
│       └── description → string
│
├── categories         → list[dict]
│   └── each item
│       ├── id         → integer
│       └── description → string
│
├── metacritic         → dict
│   ├── score          → integer
│   └── url            → string
│
├── release_date       → dict
│   ├── coming_soon    → boolean
│   └── date           → string
│
├── recommendations    → dict
│   └── total          → integer
│
└── ...                

Observation:
The Steam API returns nested JSON data with several different structures:
simple values, dictionaries, lists of strings, and lists of dictionaries.

This structure will need to be flattened/transformed later before loading
the data into relational tables.