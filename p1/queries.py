from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/prueba")
db = client["comics_store"]

comics_collection = db["Comics"]
characters_collection = db["Characters"]
customers_collection = db["Customers"]

def get_comics_below_20():
    comics = comics_collection.find(
        {
    'price': {
        '$lt': 20
    }
}
    ).sort('title',1)
    return list(comics)

def get_heroes_with_flight():
    heroes = characters_collection.find(
        {
    'group_affiliation': {
        '$ne': 'Villains'
    }, 
    'powers': 'flight'
}
    ).sort('name',1)
    return list(heroes)

def get_more_than_5_purchases():
    pipeline = [
        {
            '$match': {
                'purchase_history.5': {
                    '$exists': True
                }
            }
        }, {
            '$project': {
                'name': 1, 
                'email': 1, 
                'total_amount': {
                    '$sum': '$purchase_history.total_amount'
                }
            }
        }
    ]
    customers = list(customers_collection.aggregate(pipeline))
    return customers

def get_most_popular_category():
    pipeline = [
        {
            '$unwind': '$purchase_history'
        }, {
            '$lookup': {
                'from': 'Comics', 
                'localField': 'purchase_history.comic_id', 
                'foreignField': '_id', 
                'as': 'comic_details'
            }
        }, {
            '$unwind': '$comic_details'
        }, {
            '$group': {
                '_id': '$comic_details.category', 
                'purchase_count': {
                    '$sum': 1
                }
            }
        }, {
            '$sort': {
                'purchase_count': -1
            }
        }, {
            '$limit': 1
        }
    ]
    customers = list(customers_collection.aggregate(pipeline))
    return customers

def get_avengers_and_justice_league():
    characters = characters_collection.find(
        {
    'group_affiliation': {
        '$all': [
            'Justice League', 'Avengers'
        ]
    }
}
    )
    return list(characters)

def get_comics_with_mortal_arm():
    comics = comics_collection.find(
        {
    'mortal_arms': {
        '$exists': True, 
        '$ne': []
    }
}
    )
    return list(comics)

