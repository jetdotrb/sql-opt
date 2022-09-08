# 1.) A website feature where a user can display his/her top 8 followers in profile freely:
# before
EXPLAIN SELECT * 
FROM `hh_features_before`.`heroes` 
WHERE find_in_set(id, '1,3,5,7,9,15,16, 20');
# after
EXPLAIN SELECT * 
FROM `hh_features`.`heroes` 
WHERE id IN (1, 3, 5, 7, 9, 15, 16, 20);

# 2.) When there’s an input field where you can type hero name in top search bar:
#before
EXPLAIN SELECT * 
FROM `hh_features_before`.`heroes` 
WHERE hero_name LIKE 'Superman%';
#after
EXPLAIN SELECT * 
FROM `hh_features`.`heroes` 
WHERE hero_name LIKE 'Superman%';

# 3.) A new feature where you can welcome the last 10 registered users in the dashboard page (hint: think of better column): 
#before
EXPLAIN SELECT * 
FROM `hh_features_before`.`heroes`  
ORDER BY created_at DESC 
LIMIT 10;
#after
EXPLAIN SELECT * 
FROM `hh_features_before`.`heroes`  
ORDER BY id DESC 
LIMIT 10;

# 4.) When you want to check if there’s existing user named “Michael Choi” in admin page (given that there's firstname, lastname input fields) (pro tip: index cannot be utilized if used in aggregate function):
#before
EXPLAIN SELECT * 
FROM `hh_features_before`.`heroes`  
WHERE CONCAT(first_name, last_name) LIKE "%Michael Choi%";
#after
EXPLAIN SELECT * 
FROM `hh_features`.`heroes`  
WHERE first_name = 'Michael' AND last_name = 'Choi';

# 5.) When you want to get the hero id, hero name only of all who answered the specific challenge (that to be displayed in solution page) (hint: use better join type):
#before
EXPLAIN SELECT heroes.*
FROM `hh_features_before`.`heroes` 
LEFT JOIN `hh_features_before`.`hero_answers` ON hero_answers.hero_id = heroes.id 
WHERE hero_answers.hero_id IS NOT null 
AND hero_answers.challenge_id = 491;
#after
EXPLAIN SELECT heroes.*
FROM `hh_features`.`heroes` 
INNER JOIN `hh_features`.`hero_answers` ON hero_answers.hero_id = heroes.id 
AND hero_answers.challenge_id = 491;

# 6.) In recruitment page, if we want to search for topnotch users, what is the best query to get the list of users who live in the Philippines with hero level greater than or equal to 9? The user’s name, level, and their country should be displayed on the list.
#before
EXPLAIN SELECT heroes.first_name, heroes.last_name, heroes.hero_level, countries.name AS country_name
FROM `hh_features_before`.`heroes`
LEFT JOIN `hh_features`.`countries` ON countries.id = heroes.country_id
WHERE hero_level >= 9 AND countries.name = 'Philippines';
#after
EXPLAIN SELECT heroes.first_name, heroes.last_name, heroes.hero_level, countries.name AS country_name
FROM `hh_features`.`heroes`
LEFT JOIN `hh_features`.`countries` ON countries.id = heroes.country_id
WHERE hero_level >= 9 AND countries.name = 'Philippines';

# 7.) For the admin page, what is the most efficient query to get the list of users who successfully paid the subscription activated between April 1-30, 2020?
EXPLAIN SELECT heroes.*
FROM `hh_features`.`heroes`
INNER JOIN `hh_features`.`subscriptions` ON subscriptions.hero_id = heroes.id
INNER JOIN `hh_features`.`payments` ON payments.id = subscriptions.payment_id
WHERE payments.is_charged = 1  AND subscriptions.start_date BETWEEN '2020-04-01' and '2020-04-30';