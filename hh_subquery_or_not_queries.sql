# 1. Write a query to display hero name, first name, last name, hero level of those users who are same as the hero level of user id 109.
EXPLAIN SELECT hero_name, first_name, last_name, hero_level 
FROM heroes
WHERE hero_level IN (
	SELECT hero_level
    FROM heroes
	WHERE id = 109
);
#EXPLAIN SELECT h1.hero_name, h1.first_name, h1.last_name, h1.hero_level
#FROM heroes h1, heroes h2
#WHERE h1.hero_level = h2.hero_level AND h2.id = 109;

# 2. Write the query to display hero name, first name, last name, hero level of the user with highest hero level. (Hint: 35 rows)
EXPLAIN SELECT hero_name, first_name, last_name, hero_level
FROM heroes
WHERE hero_level >= 9;

# 3. Simplify the ff. query:
#before
EXPLAIN SELECT COUNT(is_upvote) "num_of_upvote", 
(
	SELECT GROUP_CONCAT(hero_id) 
    FROM comment_votes cv2 
    WHERE cv2.is_upvote=1 AND cv2.comment_id=cv1.comment_id
) as "commenters" 
FROM comment_votes cv1 
WHERE cv1.is_upvote=1 
GROUP BY cv1.comment_id;
#after
EXPLAIN SELECT COUNT(is_upvote) num_of_upvote, GROUP_CONCAT(hero_id) as commenters
FROM comment_votes
WHERE is_upvote = 1
GROUP BY comment_id;

# 4. Refactor the ff. query (Pro tip: Understand what's happening in subquery first):
EXPLAIN SELECT
	hero_answers.hero_id, hero_answers.score as hero_score, hero_answers.id, 
    hero_answers.challenge_id, hero_answers.answer_json,
    hero_answers.is_answer_unlocked, hero_answers.cache_upvotes_count, hero_answers.cache_downvotes_count,
    TIMESTAMPDIFF(SECOND, hero_answers.started_at,hero_answers.completed_at) as time_spent,
    heroes.hero_name, heroes.country_id, countries.flag_url as hero_flag_url, hero_answers.id AS hero_answer_id
FROM
	hero_answers
INNER JOIN heroes ON hero_answers.hero_id = heroes.id
LEFT JOIN countries ON countries.id = heroes.country_id
WHERE hero_answers.id IN (
	SELECT max(hero_answers.id) AS hero_answer_id
	FROM hero_answers
	INNER JOIN heroes ON hero_answers.hero_id = heroes.id
	WHERE hero_answers.challenge_id = 701
	AND heroes.hero_name NOT LIKE '%v88'
	AND score >= 3
	GROUP BY heroes.id
)
ORDER BY TIMESTAMPDIFF(SECOND, hero_answers.started_at, hero_answers.completed_at) DESC;

# 5. Convert by writing one query to eliminate twice database call in the backend (Hint: There are 3 SELECTs in one query):
#SELECT COUNT(*) as hero_count FROM heroes;
#SELECT COUNT(*) as follower_count FROM hero_follows WHERE following_hero_id = 23;

EXPLAIN SELECT 
(SELECT COUNT(*) FROM heroes) as hero_count, 
(SELECT COUNT(*) FROM hero_follows WHERE following_hero_id = 23) as hero_followers;


