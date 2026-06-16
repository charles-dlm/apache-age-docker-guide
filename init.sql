-- =====================================================================
-- 1. PERFORMANCE TUNING FOR BENCHMARK (Optimized for 24GB RAM / 8 CPU)
-- =====================================================================

-- Memory Configuration (RAM)
ALTER SYSTEM SET shared_buffers = '6GB';          -- 25% of RAM dedicated to data caching
ALTER SYSTEM SET work_mem = '4GB';                -- Allows heavy graph queries to run entirely in RAM
ALTER SYSTEM SET maintenance_work_mem = '4GB';    -- Speeds up index creation significantly
ALTER SYSTEM SET effective_cache_size = '18GB';   -- Tells the optimizer how much memory is available overall
ALTER SYSTEM SET temp_buffers = '64MB';           -- Buffer size for temporary tables (Optimized to 64MB)

-- CPU Configuration (Parallel Workers)
ALTER SYSTEM SET max_worker_processes = 8;
ALTER SYSTEM SET max_parallel_workers = 8;
ALTER SYSTEM SET max_parallel_workers_per_gather = 6; -- Uses 6 cores for ONE single query

-- Disk, Write & WAL Optimization (BULK IMPORT MODE)
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET max_wal_size = '16GB';           -- Reduces disk I/O bottlenecks during heavy writes
ALTER SYSTEM SET min_wal_size = '2GB';
ALTER SYSTEM SET random_page_cost = 1.4;          -- Informs the optimizer about fast storage (SSD)

-- Configuration for disabling heavy logging (wal_level = minimal)
ALTER SYSTEM SET wal_level = 'minimal';           -- Reduces WAL logging to a strict minimum to accelerate bulk import
ALTER SYSTEM SET max_wal_senders = 0;             -- MANDATORY requirement by PostgreSQL to enable 'minimal' wal_level

-- Transaction Isolation
ALTER SYSTEM SET default_transaction_isolation = 'read uncommitted'; -- Set default transaction isolation level

-- Graph Queries & Table Partitioning Optimization
ALTER SYSTEM SET geqo = 'off';                    -- Forces the optimizer to calculate the best plan for massive joins
ALTER SYSTEM SET enable_partition_pruning = 'on'; -- Enables automatic exclusion of unneeded partitions

-- Advanced optimizations for partitioning (Partitionwise joins and aggregations)
ALTER SYSTEM SET enable_partitionwise_join = 'on';
ALTER SYSTEM SET enable_partitionwise_aggregate = 'on';

-- Reload configuration (Applies compatible parameters online immediately)
SELECT pg_reload_conf();

-- =====================================================================
-- 2. ORIGINAL INITIALIZATION PROCESS
-- =====================================================================

-- Initialize the AGE extension
CREATE EXTENSION IF NOT EXISTS age CASCADE;

-- Load AGE into the session search path
LOAD 'age';
SET search_path = ag_catalog, "$user", public;

-- Create a graph named "graph1"
SELECT create_graph('graph1');

-- Insert test data (Cypher syntax)
SELECT * FROM cypher('graph1', $$
    CREATE (a:Person {name: 'Alice', age: 30})
    CREATE (b:Person {name: 'Bob', age: 25})
    CREATE (a)-[r:KNOWS {since: 2021}]->(b)
$$) AS (v agtype);
