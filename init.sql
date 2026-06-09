-- =====================================================================
-- 1. PERFORMANCE TUNING FOR BENCHMARK (Optimized for 24GB RAM / 8 CPU)
-- =====================================================================

-- Memory Configuration (RAM)
ALTER SYSTEM SET shared_buffers = '6GB';          -- 25% of RAM dedicated to data caching
ALTER SYSTEM SET work_mem = '4GB';                -- Allows heavy graph queries to run entirely in RAM
ALTER SYSTEM SET maintenance_work_mem = '4GB';    -- Speeds up index creation significantly
ALTER SYSTEM SET effective_cache_size = '18GB';   -- Tells the optimizer how much memory is available overall

-- CPU Configuration (Parallel Workers)
ALTER SYSTEM SET max_worker_processes = 8;
ALTER SYSTEM SET max_parallel_workers = 8;
ALTER SYSTEM SET max_parallel_workers_per_gather = 6; -- Uses 6 cores for ONE single query

-- Disk & Write Optimization
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET max_wal_size = '16GB';           -- Reduces disk I/O bottlenecks during heavy writes
ALTER SYSTEM SET min_wal_size = '2GB';

-- =====================================================================
-- 2. ORIGINAL INITIALIZATION PROCESS
-- =====================================================================

-- Initialize the AGE extension
CREATE EXTENSION IF NOT EXISTS age CASCADE;

-- Load AGE into the session search path
LOAD 'age';
SET search_path = ag_catalog, "$user", public;

-- Create a graph named "social_media"
SELECT create_graph('social_media');

-- Insert test data (Cypher syntax)
SELECT * FROM cypher('social_media', $$
    CREATE (a:Person {name: 'Alice', age: 30})
    CREATE (b:Person {name: 'Bob', age: 25})
    CREATE (a)-[r:KNOWS {since: 2021}]->(b)
$$) AS (v agtype);
