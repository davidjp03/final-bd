-- casas con mas personajes
SELECT 
    string_field_1 AS house, 
    COUNT(*) AS num_characters
FROM 
    `final-bd-441921.dataset_hp.hp`
WHERE 
    string_field_1 IS NOT NULL AND string_field_1 != ''
GROUP BY 
    string_field_1
ORDER BY 
    num_characters DESC
LIMIT 3;
