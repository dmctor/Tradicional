SELECT COUNT(*) AS count FROM quizzes
WHERE user_id = 1;

SELECT * FROM users_answers 
WHERE user_id = 1;

-- aciertos del usuario_id 1
SELECT COUNT(*) AS aciertos FROM alternatives A
INNER JOIN users_answers UA ON UA.alternative_id = A.id
WHERE correct = 1 AND user_id = 1;
-- total de alternativas de las preguntas del un usuario
SELECT COUNT(*) AS total_alternativas FROM users U 
INNER JOIN quizzes Q ON U.id = Q.user_id 
INNER JOIN quizzes_questions QQ ON QQ.quiz_id = Q.id 
WHERE U.id = 1;
-- juntando todo
SELECT 
    COALESCE((
        SELECT COUNT(*) FROM alternatives A
        INNER JOIN users_answers UA ON UA.alternative_id = A.id
        WHERE A.correct = 1 AND UA.user_id = 1), 0) AS aciertos,

    COALESCE((
        SELECT COUNT(*) FROM users U 
        INNER JOIN quizzes Q ON U.id = Q.user_id 
        INNER JOIN quizzes_questions QQ ON QQ.quiz_id = Q.id 
        WHERE U.id = 1), 0) AS total_alternativas,

    (COALESCE((
        SELECT COUNT(*) FROM alternatives A
        INNER JOIN users_answers UA ON UA.alternative_id = A.id
        WHERE A.correct = 1 AND UA.user_id = 1), 0)
    ) * 1.0 /
    NULLIF((
        SELECT COUNT(*) FROM users U 
        INNER JOIN quizzes Q ON U.id = Q.user_id 
        INNER JOIN quizzes_questions QQ ON QQ.quiz_id = Q.id 
        WHERE U.id = 1), 0) AS proporcion_acierto;
-- PONER LO DEMAS QUE DESEEN




