-- 1. Initialiser l'extension AGE
CREATE EXTENSION IF NOT EXISTS age CASCADE;

-- 2. Charger AGE dans le path de cette session
LOAD 'age';
SET search_path = ag_catalog, "$user", public;

-- 3. Créer un graphe nommé "reseau_social"
SELECT create_graph('social_media');

-- 4. Insérer des données de test (Syntaxe Cypher)
SELECT * FROM cypher('reseau_social', $$
    CREATE (a:Person {name: 'Alice', age: 30})
    CREATE (b:Person {name: 'Bob', age: 25})
    CREATE (a)-[r:KNOWS {since: 2021}]->(b)
$$) AS (v agtype);
