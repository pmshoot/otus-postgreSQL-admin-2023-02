alter system set max_connections = 40;
alter system set shared_buffers = '1GB';
alter system set effective_cache_size = '3GB';
alter system set maintenance_work_mem = '512MB';
alter system set checkpoint_completion_target = 0.9;
alter system set wal_buffers = '16MB';
alter system set default_statistics_target = 500;
alter system set random_page_cost = 4;
alter system set effective_io_concurrency = 2;
alter system set work_mem = '6553kB';
alter system set min_wal_size = '4GB';
alter system set max_wal_size = '16GB';

