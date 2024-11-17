-- Estudiantes que empiezan por H
SELECT 
    string_field_0 AS name, 
    string_field_1 AS house
FROM 
    `final-bd-441921.dataset_hp.hp`
WHERE 
    string_field_2 = 'Student' 
    AND string_field_0 LIKE 'H%'
ORDER BY 
    string_field_0;
