-- 1. Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользоваетелем. 
-- Запросы необходимо строить с использованием JOIN ! 

SELECT 
	IF(ms.from_user_id = 1, ms.to_user_id, ms.from_user_id) as user_id,
	count(*) AS total FROM messages ms
  LEFT JOIN (SELECT * FROM 
                        (SELECT friend_id FROM friendship WHERE user_id = 1
		                 UNION ALL SELECT user_id FROM friendship WHERE friend_id = 1) t1) t2 
    ON ms.from_user_id=t2.friend_id	    
  LEFT JOIN (SELECT * FROM 
                       (SELECT friend_id FROM friendship WHERE user_id = 1
		                UNION ALL SELECT user_id FROM friendship WHERE friend_id = 1)  t3) t4
    ON ms.to_user_id=t4.friend_id
WHERE ms.to_user_id = 1 OR ms.from_user_id = 1   
GROUP BY user_id
ORDER BY total DESC
LIMIT 1;

-- 2 Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
-- Запросы необходимо строить с использованием JOIN !
SELECT 
	COUNT(*) as total_likes
FROM 
	likes lk INNER JOIN media md
    ON lk.to_subject_id=md.id
    INNER JOIN (SELECT youngest.user_id as yong_id FROM
			(SELECT
				user_id,
				TIMESTAMPDIFF(DAY, birthday, NOW()) AS age_days
			FROM 
				profiles
			ORDER BY age_days
			LIMIT 10) as youngest) t
    ON md.user_id=t.yong_id;
	
-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
-- Запросы необходимо строить с использованием JOIN !
SELECT 
	tot_likes.sex as sex, 
	tot_likes.total_likes as sum_likes
FROM 
	(
    SELECT 
		'f' as sex, 
		f_likes.total as total_likes
	FROM 
		(SELECT count(*) as total
		FROM likes lk INNER JOIN (SELECT user_id FROM profiles WHERE sex = 'f') t1
		ON lk.from_user_id = t1.user_id				
		) AS f_likes
	UNION
	SELECT 
		'm' as sex, 
		m_likes.total as total_likes
	FROM 
		(SELECT count(*) as total
		FROM likes lk INNER JOIN (SELECT user_id FROM profiles WHERE sex = 'm') t2
		ON lk.from_user_id=t2.user_id 	
		) AS m_likes
	  ) AS tot_likes
ORDER BY sum_likes DESC 
LIMIT 1;

-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
-- Скорее всего здесь если и будет запрос joinами, то неудачный
SELECT 
	users_activity.user_id AS user_id, 
	SUM(users_activity.activity) total
FROM 
	(SELECT 
		from_user_id user_id,
		count(*) activity
	FROM 
		likes
	GROUP BY
		user_id

	UNION ALL
	
	SELECT
		from_user_id user_id,
		count(*) activity
	FROM
		messages
	GROUP BY 
		user_id
	
	UNION ALL
	
	SELECT
		to_user_id user_id,
		count(*) activity
	FROM
		messages
	GROUP BY 
		user_id) users_activity

GROUP BY 
	user_id
ORDER BY 
	total
LIMIT 10;

