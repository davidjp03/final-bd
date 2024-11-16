from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/prueba")
db = client["comics_store"]

collections = ["Comics", "Characters", "Villagers", "Mortal_Arms", "Customers"]

characters = [
    {"name": "Superman", "powers": ["flight", "super strength", "x-ray vision"],
     "weaknesses": ["kryptonite"], "group_affiliation": ["Justice League"]},
    {"name": "Batman", "powers": ["intelligence", "martial arts"],
     "weaknesses": ["no superpowers"], "group_affiliation": ["Justice League"]},
    {"name": "Thor", "powers": ["thunder control", "super strength"],
     "weaknesses": ["pride"], "group_affiliation": ["Avengers"]},
    {"name": "Joker", "powers": ["chaos", "manipulation"],
     "weaknesses": ["insanity"], "group_affiliation": ["Villains"]},
    {"name": "Wonder Woman", "powers": ["strength", "agility", "lasso of truth"],
     "weaknesses": ["none"], "group_affiliation": ["Justice League"]},
    {"name": "Loki", "powers": ["deception", "magic"],
     "weaknesses": ["vanity"], "group_affiliation": ["Villains"]}
]
character_ids = db["Characters"].insert_many(characters).inserted_ids

villagers = [
    {"name": "Juan el Panadero", "description": "Aldeano famoso por su pan delicioso.", "availability": True},
    {"name": "María la Valiente", "description": "Defensora de su pueblo, conocida por su valentía.", "availability": True}
]
villager_ids = db["Villagers"].insert_many(villagers).inserted_ids

mortal_arms = [
    {"name": "Martillo de Thor", "description": "El poderoso martillo Mjolnir.", "availability": True},
    {"name": "Escudo Legendario", "description": "Un escudo indestructible.", "availability": True}
]
mortal_arm_ids = db["Mortal_Arms"].insert_many(mortal_arms).inserted_ids

comics = [
    {"title": "Superman Origins", "description": "Los inicios de Superman.", "price": 12.99,
     "category": "superhero", "mortal_arms": [], "characters": [character_ids[0]], "villagers": [villager_ids[0]]},
    {"title": "Batman Rises", "description": "La ascensión de Batman.", "price": 14.99,
     "category": "superhero", "mortal_arms": [], "characters": [character_ids[1]], "villagers": []},
    {"title": "Thor's Revenge", "description": "La venganza de Thor.", "price": 18.00,
     "category": "superhero", "mortal_arms": [mortal_arm_ids[0]], "characters": [character_ids[2]], "villagers": []},
    {"title": "The Killing Joke", "description": "El Joker en su forma más oscura.", "price": 25.00,
     "category": "villain", "mortal_arms": [], "characters": [character_ids[3]], "villagers": []},
    {"title": "Wonder Woman's Quest", "description": "La misión de Wonder Woman.", "price": 20.00,
     "category": "superhero", "mortal_arms": [], "characters": [character_ids[4]], "villagers": []},
    {"title": "Justice League United", "description": "La Liga de la Justicia se une.", "price": 30.00,
     "category": "superhero", "mortal_arms": [mortal_arm_ids[1]], "characters": [character_ids[0], character_ids[1]], "villagers": []},
    {"title": "Loki's Trickery", "description": "Las maquinaciones de Loki.", "price": 15.50,
     "category": "villain", "mortal_arms": [], "characters": [character_ids[5]], "villagers": []},
    {"title": "Thor vs Loki", "description": "El enfrentamiento final.", "price": 22.00,
     "category": "superhero", "mortal_arms": [mortal_arm_ids[0]], "characters": [character_ids[2], character_ids[5]], "villagers": []},
    {"title": "Joker's Chaos", "description": "El caos del Joker.", "price": 10.99,
     "category": "villain", "mortal_arms": [], "characters": [character_ids[3]], "villagers": []},
    {"title": "Superman Returns", "description": "El regreso de Superman.", "price": 19.99,
     "category": "superhero", "mortal_arms": [], "characters": [character_ids[0]], "villagers": []}
]
comic_ids = db["Comics"].insert_many(comics).inserted_ids

customers = [
    {"name": "Ana López", "birthday": "1990-05-10", "email": "ana@example.com",
     "purchase_history": [
         {"comic_id": comic_ids[0], "purchase_date": "2024-11-01", "total_amount": 12.99},
         {"comic_id": comic_ids[1], "purchase_date": "2024-11-02", "total_amount": 14.99},
         {"comic_id": comic_ids[2], "purchase_date": "2024-11-03", "total_amount": 18.00},
         {"comic_id": comic_ids[3], "purchase_date": "2024-11-04", "total_amount": 25.00},
         {"comic_id": comic_ids[4], "purchase_date": "2024-11-05", "total_amount": 20.00},
         {"comic_id": comic_ids[5], "purchase_date": "2024-11-06", "total_amount": 30.00}
     ]},
    {"name": "Carlos Pérez", "birthday": "1985-11-22", "email": "carlos@example.com",
     "purchase_history": [
         {"comic_id": comic_ids[6], "purchase_date": "2024-11-07", "total_amount": 15.50},
         {"comic_id": comic_ids[7], "purchase_date": "2024-11-08", "total_amount": 22.00}
     ]},
    {"name": "Luis Gómez", "birthday": "1970-09-14", "email": "luis@example.com",
     "purchase_history": [
         {"comic_id": comic_ids[8], "purchase_date": "2024-11-09", "total_amount": 10.99}
     ]}
]
db["Customers"].insert_many(customers)

print("Datos insertados:")
for collection in collections:
    count = db[collection].count_documents({})
    print(f"{collection}: {count} documentos")


