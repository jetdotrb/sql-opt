-- PART 1
SELECT cache_ratings_json FROM hh_subquery_or_not.games WHERE id = 1;
SELECT cache_ratings_json FROM hh_subquery_or_not.games WHERE id < 3;

# 1.) Make the minimum units rate to value “1” in cache_ratings_json field of game id 1.
UPDATE games
SET `cache_ratings_json` = JSON_REPLACE(`cache_ratings_json`, '$.min_units_rate', 1) 
WHERE `id` = 1;

# 2.) Have a new json field “max_units_rate” with default value 10 to game id 1.
UPDATE games
SET `cache_ratings_json` = JSON_INSERT(`cache_ratings_json`, '$.max_units_rate', 10) 
WHERE `id` = 1;

# 3.) Create a query so that all game id less than 3 can have max_units_rate 15.
UPDATE games
SET `cache_ratings_json` = JSON_SET(`cache_ratings_json`, '$.max_units_rate', 15) 
WHERE `id` < 3;

# 4.) Get the average and total of ratings from game id 9.
SELECT 
	JSON_EXTRACT(games.cache_ratings_json, '$.avg') AS average, 
	JSON_EXTRACT(games.cache_ratings_json, '$.total') AS total
FROM hh_subquery_or_not.games
WHERE `id` = 9;

# 5.) Get the module details in first module id of hero game summary id 1674.
SELECT cache_progress_json
FROM hh_subquery_or_not.hero_game_summaries 
WHERE id = 1674;

SELECT 
	JSON_EXTRACT(cache_progress_json, CONCAT('$.modules.', JSON_EXTRACT(JSON_KEYS(cache_progress_json, '$.modules'), '$[0]'))) AS first_module_details
FROM hh_subquery_or_not.hero_game_summaries 
WHERE id = 1674;

# 6.) Convert the following query to more readable JSON select.
SELECT
	JSON_MERGE_PRESERVE(
		JSON_OBJECTAGG(game_ratings.star_rating, game_ratings.total_raters),
		JSON_OBJECT(
			'total', SUM(game_ratings.total_raters), 
            'avg', FORMAT(SUM(game_ratings.avg_rating) / SUM(game_ratings.total_raters), 2), 
            'min_units_rate', MIN(game_ratings.min_units_rate)
		)
    ) AS game_ratings_json
FROM (
	SELECT star_rating, COUNT(*) as total_raters, (star_rating * COUNT(*)) as avg_rating, 
    JSON_EXTRACT(games.cache_ratings_json, '$.min_units_rate') as min_units_rate
    FROM game_ratings
    INNER JOIN games ON games.id = game_ratings.game_id
    WHERE game_ratings.game_id = 9
    GROUP BY star_rating
) as game_ratings;

-- PART 2 
# add order_items_json in orders table


