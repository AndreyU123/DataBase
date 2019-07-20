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


