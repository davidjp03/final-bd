
CREATE TABLE Villagers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    availability BOOLEAN NOT NULL
);

CREATE TABLE Characters (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    powers TEXT[],
    weaknesses TEXT[],
    group_affiliation TEXT[]
);

CREATE TABLE Comics (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL,
    category VARCHAR(50) NOT NULL
);

CREATE TABLE Mortal_Arms (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    availability BOOLEAN NOT NULL
);

CREATE TABLE Customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    birthday DATE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    purchase_history JSONB
);

CREATE TABLE Transactions (
    id SERIAL PRIMARY KEY,
    comic_id INT REFERENCES Comics(id),
    customer_id INT REFERENCES Customers(id),
    purchase_date DATE NOT NULL,
    total_amount NUMERIC(10, 2) NOT NULL
);

CREATE TABLE Special_Offers (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(id),
    customer_name VARCHAR(255) NOT NULL,
    birthday DATE NOT NULL
);

CREATE TABLE VillagersXComics (
    id SERIAL PRIMARY KEY,
    villager_id INT REFERENCES Villagers(id),
    comic_id INT REFERENCES Comics(id)
);

CREATE TABLE CharactersXComics (
    id SERIAL PRIMARY KEY,
    character_id INT REFERENCES Characters(id),
    comic_id INT REFERENCES Comics(id)
);

CREATE TABLE ArmsXComics (
    id SERIAL PRIMARY KEY,
    arm_id INT REFERENCES Mortal_Arms(id),
    comic_id INT REFERENCES Comics(id)
);

CREATE TABLE HeroesVillainsBattles (
    battle_id SERIAL PRIMARY KEY,
    hero_id INT REFERENCES Characters(id),
    villain_id INT REFERENCES Characters(id),
    result VARCHAR(50) NOT NULL CHECK (result IN ('win', 'loss', 'draw')),
    battle_date DATE NOT NULL
);


CREATE OR REPLACE FUNCTION add_special_offer()
RETURNS TRIGGER AS $$
BEGIN

    IF NEW.comic_id = (SELECT id FROM Comics WHERE title = 'Superman en Calzoncillos con Batman Asustado') THEN

        INSERT INTO Special_Offers (customer_id, customer_name, birthday)
        VALUES (
            NEW.customer_id,
            (SELECT name FROM Customers WHERE id = NEW.customer_id),
            (SELECT birthday FROM Customers WHERE id = NEW.customer_id)
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER special_offers_trigger
AFTER INSERT ON Transactions
FOR EACH ROW
EXECUTE FUNCTION add_special_offer();


INSERT INTO Villagers (name, description, availability) VALUES
('Juan el Panadero', 'Aldeano famoso por su pan delicioso.', TRUE),
('María la Valiente', 'Defensora de su pueblo, conocida por su valentía.', TRUE),
('Pedro el Carpintero', 'Constructor de las casas del pueblo.', FALSE);


INSERT INTO Characters (name, powers, weaknesses, group_affiliation) VALUES
('Superman', ARRAY['flight', 'super strength', 'x-ray vision'], ARRAY['kryptonite'], ARRAY['Justice League']),
('Batman', ARRAY['intelligence', 'martial arts'], ARRAY['no superpowers'], ARRAY['Justice League']),
('Thor', ARRAY['thunder control', 'super strength'], ARRAY['pride'], ARRAY['Avengers']),
('Joker', ARRAY['chaos', 'manipulation'], ARRAY['insanity'], ARRAY['Villains']);


INSERT INTO Comics (title, description, price, category) VALUES
('Superman en Calzoncillos con Batman Asustado', 'Un cómic raro y coleccionable.', 1000.00, 'superhero'),
('Batman Begins', 'La historia de Batman.', 15.99, 'superhero'),
('Thor Ragnarok', 'La batalla final de Thor.', 20.00, 'superhero'),
('The Killing Joke', 'Una historia oscura del Joker.', 25.00, 'villain');


INSERT INTO Mortal_Arms (name, description, availability) VALUES
('Escudo Legendario', 'Un escudo indestructible.', TRUE),
('Martillo de Thor', 'El poderoso martillo Mjolnir.', TRUE);


INSERT INTO Customers (name, birthday, email, purchase_history) VALUES
('Ana López', '1995-05-10', 'ana@example.com', NULL),
('Carlos Pérez', '1988-11-22', 'carlos@example.com', NULL),
('Luis Gómez', '1975-09-14', 'luis@example.com', NULL);


INSERT INTO Transactions (comic_id, customer_id, purchase_date, total_amount) VALUES
(1, 1, '2024-11-15', 1000.00),  
(2, 2, '2024-11-16', 15.99),
(3, 2, '2024-11-17', 20.00),
(4, 3, '2024-11-18', 25.00),
(2, 1, '2024-11-19', 15.99),
(3, 1, '2024-11-20', 20.00);


INSERT INTO VillagersXComics (villager_id, comic_id) VALUES
(1, 1),
(2, 2),
(3, 3);


INSERT INTO CharactersXComics (character_id, comic_id) VALUES
(1, 1),  
(2, 2),  
(3, 3), 
(4, 4);  


INSERT INTO ArmsXComics (arm_id, comic_id) VALUES
(1, 1),
(2, 3);


INSERT INTO HeroesVillainsBattles (hero_id, villain_id, result, battle_date) VALUES
(1, 4, 'win', '2024-01-10'), 
(2, 4, 'win', '2024-02-15'),  
(1, 4, 'win', '2024-03-20'),  
(2, 4, 'win', '2024-04-25'),  
(1, 4, 'win', '2024-05-30');  


-- Easy queries
--1
SELECT * FROM Comics
WHERE price < 20
ORDER BY title;

--2
SELECT * FROM Characters
WHERE 'flight' = ANY(powers)
AND NOT ('Villains' = ANY(group_affiliation))
ORDER BY name;


--Medium queries
--0
SELECT villain_id, COUNT(hero_id) AS defeats
FROM HeroesVillainsBattles
GROUP BY villain_id
HAVING COUNT(hero_id) > 3;

--1
SELECT Customers.name, COUNT(Transactions.id) AS total_comics, SUM(Transactions.total_amount) AS total_spent
FROM Customers
JOIN Transactions ON Customers.id = Transactions.customer_id
GROUP BY Customers.name
HAVING COUNT(Transactions.id) > 5;

--Advanced queries
--0
SELECT category, COUNT(Transactions.id) AS purchase_count
FROM Comics
JOIN Transactions ON Comics.id = Transactions.comic_id
GROUP BY category
ORDER BY purchase_count DESC
LIMIT 1;

--1
SELECT * FROM Characters
WHERE 'Justice League' = ANY(group_affiliation) AND 'Avengers' = ANY(group_affiliation);

--2
SELECT Comics.title
FROM Comics
JOIN ArmsXComics ON Comics.id = ArmsXComics.comic_id
JOIN CharactersXComics ON Comics.id = CharactersXComics.comic_id
WHERE EXISTS (SELECT 1 FROM Characters WHERE CharactersXComics.character_id = Characters.id AND 'villain' = ANY(Characters.group_affiliation))
AND EXISTS (SELECT 1 FROM Characters WHERE CharactersXComics.character_id = Characters.id AND 'hero' = ANY(Characters.group_affiliation));

--views
CREATE VIEW Popular_Comics AS
SELECT Comics.id, Comics.title, COUNT(Transactions.id) AS purchase_count
FROM Comics
JOIN Transactions ON Comics.id = Transactions.comic_id
GROUP BY Comics.id
HAVING COUNT(Transactions.id) > 50;

CREATE MATERIALIZED VIEW Top_Customers AS
SELECT Customers.id AS customer_id, Customers.name, COUNT(Transactions.id) AS total_purchases, SUM(Transactions.total_amount) AS total_spent
FROM Customers
JOIN Transactions ON Customers.id = Transactions.customer_id
GROUP BY Customers.id
HAVING COUNT(Transactions.id) > 10;
