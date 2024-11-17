import requests
import pandas as pd

API_URL = "https://hp-api.onrender.com/api/characters"

try:
    response = requests.get(API_URL)
    response.raise_for_status() 
    data = response.json()  
    print("Conexión exitosa")
except requests.exceptions.RequestException as e:
    print(f"Error al conectarse a la API: {e}")
    data = []

characters = []
for char in data:
    role = "Staff" if char.get("hogwartsStaff") else ("Student" if char.get("hogwartsStudent") else "Unknown")
    character = {
        "name": char.get("name"),
        "house": char.get("house", "Unknown"),
        "role": role
    }
    characters.append(character)

df = pd.DataFrame(characters)

print(df.head())

output_file = "harry_potter_characters.csv"
df.to_csv(output_file, index=False, encoding="utf-8")
print(f"Datos guardados en {output_file}")
