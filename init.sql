-- 1. Initialize the AGE extension
CREATE EXTENSION IF NOT EXISTS age CASCADE;

-- 2. Load AGE into the session search path
LOAD 'age';
SET search_path = ag_catalog, "$user", public;

-- 3. Create a graph named "social_media"
SELECT create_graph('social_media');

-- 4. Insert test data (Cypher syntax)
SELECT * FROM cypher('social_media', $$
    CREATE (a:Person {name: 'Alice', age: 30})
    CREATE (b:Person {name: 'Bob', age: 25})
    CREATE (a)-[r:KNOWS {since: 2021}]->(b)
$$) AS (v agtype);
