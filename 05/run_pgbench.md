чистая система:
```
 autovacuum                            | on
 autovacuum_analyze_scale_factor       | 0.1
 autovacuum_analyze_threshold          | 50
 autovacuum_freeze_max_age             | 200000000
 autovacuum_max_workers                | 3
 autovacuum_multixact_freeze_max_age   | 400000000
 autovacuum_naptime                    | 60
 autovacuum_vacuum_cost_delay          | 2
 autovacuum_vacuum_cost_limit          | -1
 autovacuum_vacuum_insert_scale_factor | 0.2
 autovacuum_vacuum_insert_threshold    | 1000
 autovacuum_vacuum_scale_factor        | 0.2
 autovacuum_vacuum_threshold           | 50
 autovacuum_work_mem                   | -1
 log_autovacuum_min_duration           | -1


starting vacuum...end.
progress: 60.0 s, 115.8 tps, lat 68.753 ms stddev 32.255
progress: 120.0 s, 114.2 tps, lat 70.072 ms stddev 39.794
progress: 180.0 s, 114.4 tps, lat 69.930 ms stddev 37.718
progress: 240.0 s, 117.5 tps, lat 68.104 ms stddev 26.414
progress: 300.0 s, 116.4 tps, lat 68.700 ms stddev 32.365
progress: 360.0 s, 116.7 tps, lat 68.518 ms stddev 27.727
progress: 420.0 s, 112.9 tps, lat 70.894 ms stddev 44.894
progress: 480.0 s, 115.3 tps, lat 69.374 ms stddev 30.253
progress: 540.0 s, 117.3 tps, lat 68.166 ms stddev 26.766
progress: 600.0 s, 115.8 tps, lat 69.070 ms stddev 36.540
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 69390
latency average = 69.148 ms
latency stddev = 33.916 ms
initial connection time = 221.513 ms
tps = 115.680840 (without initial connection time)
```
---

```
ALTER SYSTEM SET max_connections = 40;
ALTER SYSTEM SET shared_buffers = "1GB";
ALTER SYSTEM SET effective_cache_size = "3GB";
ALTER SYSTEM SET maintenance_work_mem = "512MB";
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET wal_buffers = "16MB";
ALTER SYSTEM SET default_statistics_target = 500;
ALTER SYSTEM SET random_page_cost = 4;
ALTER SYSTEM SET effective_io_concurrency = 2;
ALTER SYSTEM SET work_mem = "6553kB";
ALTER SYSTEM SET min_wal_size = "4GB";
ALTER SYSTEM SET max_wal_size = "16GB";

```
starting vacuum...end.
progress: 60.0 s, 112.2 tps, lat 70.931 ms stddev 41.134
progress: 120.0 s, 117.1 tps, lat 68.296 ms stddev 26.970
progress: 180.0 s, 117.9 tps, lat 67.827 ms stddev 26.289
progress: 240.0 s, 117.6 tps, lat 68.012 ms stddev 26.628
progress: 300.0 s, 112.5 tps, lat 71.108 ms stddev 42.115
progress: 360.0 s, 113.2 tps, lat 70.634 ms stddev 41.393
progress: 420.0 s, 115.5 tps, lat 69.270 ms stddev 32.062
progress: 480.0 s, 117.1 tps, lat 68.324 ms stddev 26.817
progress: 540.0 s, 117.7 tps, lat 67.965 ms stddev 26.134
progress: 600.0 s, 116.0 tps, lat 68.978 ms stddev 28.093
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 69424
latency average = 69.112 ms
latency stddev = 32.341 ms
initial connection time = 243.910 ms
tps = 115.739898 (without initial connection time)

---
```
 autovacuum                            | on
 autovacuum_analyze_scale_factor       | 0.1
 autovacuum_analyze_threshold          | 50
 autovacuum_freeze_max_age             | 200000000
 autovacuum_max_workers                | 10
 autovacuum_multixact_freeze_max_age   | 400000000
 autovacuum_naptime                    | 60
 autovacuum_vacuum_cost_delay          | 10
 autovacuum_vacuum_cost_limit          | 1000
 autovacuum_vacuum_insert_scale_factor | 0.2
 autovacuum_vacuum_insert_threshold    | 1000
 autovacuum_vacuum_scale_factor        | 0.05
 autovacuum_vacuum_threshold           | 20
 autovacuum_work_mem                   | -1
 log_autovacuum_min_duration           | 0

starting vacuum...end.
progress: 60.0 s, 115.7 tps, lat 68.764 ms stddev 27.841
progress: 120.0 s, 113.2 tps, lat 70.678 ms stddev 41.580
progress: 180.0 s, 116.8 tps, lat 68.451 ms stddev 29.444
progress: 240.0 s, 116.7 tps, lat 68.559 ms stddev 27.204
progress: 300.0 s, 116.6 tps, lat 68.626 ms stddev 26.634
progress: 360.0 s, 117.4 tps, lat 68.156 ms stddev 26.924
progress: 420.0 s, 112.0 tps, lat 71.393 ms stddev 44.726
progress: 480.0 s, 116.8 tps, lat 68.497 ms stddev 27.618
progress: 540.0 s, 116.9 tps, lat 68.415 ms stddev 27.063
progress: 600.0 s, 116.9 tps, lat 68.440 ms stddev 26.326
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 69551
latency average = 68.983 ms
latency stddev = 31.110 ms
initial connection time = 269.268 ms
tps = 115.958437 (without initial connection time)
```

---

```
 autovacuum                            | on
 autovacuum_analyze_scale_factor       | 0.1
 autovacuum_analyze_threshold          | 50
 autovacuum_freeze_max_age             | 200000000
 autovacuum_max_workers                | 10
 autovacuum_multixact_freeze_max_age   | 400000000
 autovacuum_naptime                    | 10**
 autovacuum_vacuum_cost_delay          | 10
 autovacuum_vacuum_cost_limit          | 1000
 autovacuum_vacuum_insert_scale_factor | 0.2
 autovacuum_vacuum_insert_threshold    | 1000
 autovacuum_vacuum_scale_factor        | 0.05
 autovacuum_vacuum_threshold           | 20
 autovacuum_work_mem                   | -1
 log_autovacuum_min_duration           | 0

starting vacuum...end.
progress: 60.0 s, 113.8 tps, lat 69.988 ms stddev 32.974
progress: 120.0 s, 115.6 tps, lat 69.205 ms stddev 27.897
progress: 180.0 s, 114.5 tps, lat 69.852 ms stddev 31.277
progress: 240.0 s, 116.5 tps, lat 68.690 ms stddev 27.190
progress: 300.0 s, 111.7 tps, lat 71.611 ms stddev 49.312
progress: 360.0 s, 115.1 tps, lat 69.515 ms stddev 29.952
progress: 420.0 s, 116.6 tps, lat 68.610 ms stddev 27.498
progress: 480.0 s, 114.3 tps, lat 69.968 ms stddev 29.703
progress: 540.0 s, 114.6 tps, lat 69.811 ms stddev 30.215
progress: 600.0 s, 111.8 tps, lat 71.545 ms stddev 43.297
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 68675
latency average = 69.866 ms
latency stddev = 33.584 ms
initial connection time = 240.420 ms
tps = 114.491837 (without initial connection time)

```
---
~~~
 autovacuum                            | on
 autovacuum_analyze_scale_factor       | 0.1
 autovacuum_analyze_threshold          | 50
 autovacuum_freeze_max_age             | 200000000
 autovacuum_max_workers                | 10
 autovacuum_multixact_freeze_max_age   | 400000000
 autovacuum_naptime                    | 10
 autovacuum_vacuum_cost_delay          | 10
 autovacuum_vacuum_cost_limit          | 1000
 autovacuum_vacuum_insert_scale_factor | 0.2
 autovacuum_vacuum_insert_threshold    | 1000
 autovacuum_vacuum_scale_factor        | 0.01
 autovacuum_vacuum_threshold           | 20
 autovacuum_work_mem                   | -1
 log_autovacuum_min_duration           | 0


starting vacuum...end.
progress: 60.0 s, 115.9 tps, lat 68.684 ms stddev 27.497
progress: 120.0 s, 116.0 tps, lat 68.982 ms stddev 28.517
progress: 180.0 s, 112.3 tps, lat 71.218 ms stddev 42.297
progress: 240.0 s, 116.4 tps, lat 68.726 ms stddev 27.250
progress: 300.0 s, 114.7 tps, lat 69.772 ms stddev 31.486
progress: 360.0 s, 115.8 tps, lat 69.077 ms stddev 27.756
progress: 420.0 s, 114.8 tps, lat 69.691 ms stddev 38.362
progress: 480.0 s, 110.1 tps, lat 72.681 ms stddev 48.602
progress: 540.0 s, 115.4 tps, lat 69.323 ms stddev 29.311
progress: 600.0 s, 114.9 tps, lat 69.602 ms stddev 32.351
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 68781
latency average = 69.758 ms
latency stddev = 33.962 ms
initial connection time = 244.110 ms
tps = 114.668926 (without initial connection time)

~~~
---
```
 autovacuum                            | on
 autovacuum_analyze_scale_factor       | 0.1
 autovacuum_analyze_threshold          | 50
 autovacuum_freeze_max_age             | 200000000
 autovacuum_max_workers                | 10
 autovacuum_multixact_freeze_max_age   | 400000000
 autovacuum_naptime                    | 10
 autovacuum_vacuum_cost_delay          | 10
 autovacuum_vacuum_cost_limit          | 1000
 autovacuum_vacuum_insert_scale_factor | 0.2
 autovacuum_vacuum_insert_threshold    | 1000
 autovacuum_vacuum_scale_factor        | 0.01
 autovacuum_vacuum_threshold           | 10
 autovacuum_work_mem                   | -1
 log_autovacuum_min_duration           | 0


```
