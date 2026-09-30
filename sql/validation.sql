-- 1. All tables were populated succesfully
SELECT 'games' AS table_name, COUNT(*) AS row_count FROM games
UNION ALL
SELECT 'developers', COUNT(*) FROM developers
UNION ALL
SELECT 'publishers', COUNT(*) FROM publishers
UNION ALL
SELECT 'genres', COUNT(*) FROM genres
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'game_developers', COUNT(*) FROM game_developers
UNION ALL
SELECT 'game_publishers', COUNT(*) FROM game_publishers
UNION ALL
SELECT 'game_genres', COUNT(*) FROM game_genres
UNION ALL
SELECT 'game_categories', COUNT(*) FROM game_categories;

-- 2. Foreign key integrity

-- Developers
SELECT COUNT(*) AS orphan_developers
FROM game_developers gd
LEFT JOIN developers d
    ON gd.developer_id = d.developer_id
WHERE d.developer_id IS NULL;


-- Publishers
SELECT COUNT(*) AS orphan_publishers
FROM game_publishers gp
LEFT JOIN publishers p
    ON gp.publisher_id = p.publisher_id
WHERE p.publisher_id IS NULL;


-- Genres
SELECT COUNT(*) AS orphan_genres
FROM game_genres gg
LEFT JOIN genres g
    ON gg.genre_id = g.genre_id
WHERE g.genre_id IS NULL;


-- Categories
SELECT COUNT(*) AS orphan_categories
FROM game_categories gc
LEFT JOIN categories c
    ON gc.category_id = c.category_id
WHERE c.category_id IS NULL;


-- 3. Duplicate primary key checks

-- Games
SELECT steam_appid, COUNT(*)
FROM games
GROUP BY steam_appid
HAVING COUNT(*) > 1;


-- Developers
SELECT developer_id, COUNT(*)
FROM developers
GROUP BY developer_id
HAVING COUNT(*) > 1;


-- Publishers
SELECT publisher_id, COUNT(*)
FROM publishers
GROUP BY publisher_id
HAVING COUNT(*) > 1;


-- Genres
SELECT genre_id, COUNT(*)
FROM genres
GROUP BY genre_id
HAVING COUNT(*) > 1;


-- Categories
SELECT category_id, COUNT(*)
FROM categories
GROUP BY category_id
HAVING COUNT(*) > 1;

-- 4. Invalid game values

-- Negative prices
SELECT COUNT(*) AS invalid_prices
FROM games
WHERE price_initial < 0
   OR price_final < 0;


-- Invalid discounts
SELECT COUNT(*) AS invalid_discounts
FROM games
WHERE discount_percent < 0
   OR discount_percent > 100;


-- Invalid Metacritic scores
SELECT COUNT(*) AS invalid_metacritic
FROM games
WHERE metacritic_score < 0
   OR metacritic_score > 100;

-- 5. NULL Validation

SELECT
    COUNT(*) FILTER (WHERE steam_appid IS NULL) AS null_appid,
    COUNT(*) FILTER (WHERE name IS NULL) AS null_name,
    COUNT(*) FILTER (WHERE type IS NULL) AS null_type,
    COUNT(*) FILTER (WHERE required_age IS NULL) AS null_required_age,
    COUNT(*) FILTER (WHERE is_free IS NULL) AS null_is_free,
    COUNT(*) FILTER (WHERE windows IS NULL) AS null_windows,
    COUNT(*) FILTER (WHERE mac IS NULL) AS null_mac,
    COUNT(*) FILTER (WHERE linux IS NULL) AS null_linux,
    COUNT(*) FILTER (WHERE coming_soon IS NULL) AS null_coming_soon
FROM games;

-- 6. Relationship sanity checks

-- Games without a developer
SELECT COUNT(*) AS games_without_developer
FROM games g
LEFT JOIN game_developers gd
    ON g.steam_appid = gd.steam_appid
WHERE gd.steam_appid IS NULL;


-- Games without a publisher
SELECT COUNT(*) AS games_without_publisher
FROM games g
LEFT JOIN game_publishers gp
    ON g.steam_appid = gp.steam_appid
WHERE gp.steam_appid IS NULL;


-- Games without a genre
SELECT COUNT(*) AS games_without_genre
FROM games g
LEFT JOIN game_genres gg
    ON g.steam_appid = gg.steam_appid
WHERE gg.steam_appid IS NULL;


-- Games without a category
SELECT COUNT(*) AS games_without_category
FROM games g
LEFT JOIN game_categories gc
    ON g.steam_appid = gc.steam_appid
WHERE gc.steam_appid IS NULL;

   


-- Get-Content sql/validation.sql | docker exec -i steam-statistics-postgres psql -U steam_user -d steam_statistics