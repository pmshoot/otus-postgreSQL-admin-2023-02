1. Clean
```
starting vacuum...end.
progress: 60.0 s, 115.3 tps, lat 69.061 ms stddev 30.240
progress: 120.0 s, 116.9 tps, lat 68.418 ms stddev 27.429
progress: 180.0 s, 117.5 tps, lat 68.087 ms stddev 26.404
progress: 240.0 s, 113.9 tps, lat 70.246 ms stddev 41.629
progress: 300.0 s, 110.3 tps, lat 72.518 ms stddev 50.200
progress: 360.0 s, 117.3 tps, lat 68.212 ms stddev 26.889
progress: 420.0 s, 116.7 tps, lat 68.562 ms stddev 26.918
progress: 480.0 s, 117.2 tps, lat 68.247 ms stddev 27.057
progress: 540.0 s, 115.9 tps, lat 69.029 ms stddev 29.376
progress: 600.0 s, 111.6 tps, lat 71.684 ms stddev 52.305
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 69159
latency average = 69.377 ms
latency stddev = 35.021 ms
initial connection time = 244.570 ms
tps = 115.299363 (without initial connection time)
```
---
```
alter system set log_autovacuum_min_duration TO 0;
alter system set autovacuum_vacuum_scale_factor TO 0.05;
alter system set autovacuum_vacuum_threshold TO 0;
```

```
starting vacuum...end.
progress: 60.0 s, 116.2 tps, lat 68.550 ms stddev 27.941
progress: 120.0 s, 116.1 tps, lat 68.923 ms stddev 35.598
progress: 180.0 s, 117.6 tps, lat 68.037 ms stddev 26.039
progress: 240.0 s, 117.4 tps, lat 68.159 ms stddev 26.878
progress: 300.0 s, 112.1 tps, lat 71.382 ms stddev 43.703
progress: 360.0 s, 114.8 tps, lat 69.697 ms stddev 39.665
progress: 420.0 s, 116.8 tps, lat 68.429 ms stddev 27.072
progress: 480.0 s, 117.3 tps, lat 68.287 ms stddev 26.836
progress: 540.0 s, 116.0 tps, lat 68.931 ms stddev 28.608
progress: 600.0 s, 115.0 tps, lat 69.253 ms stddev 29.317
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 69554
latency average = 68.999 ms
latency stddev = 31.992 ms
initial connection time = 225.330 ms
tps = 115.920370 (without initial connection time)
```
---

```
alter system set autovacuum_max_workers TO 6;
alter system set autovacuum_vacuum_cost_limit TO 400;
```

```
starting vacuum...end.
progress: 60.0 s, 115.7 tps, lat 68.798 ms stddev 27.617
progress: 120.0 s, 118.0 tps, lat 67.793 ms stddev 25.964
progress: 180.0 s, 116.9 tps, lat 68.450 ms stddev 28.255
progress: 240.0 s, 111.0 tps, lat 72.048 ms stddev 39.612
progress: 300.0 s, 113.8 tps, lat 70.332 ms stddev 32.165
progress: 360.0 s, 114.8 tps, lat 69.682 ms stddev 27.275
progress: 420.0 s, 112.2 tps, lat 71.295 ms stddev 33.802
progress: 480.0 s, 113.4 tps, lat 70.541 ms stddev 29.651
progress: 540.0 s, 112.3 tps, lat 70.833 ms stddev 29.975
progress: 600.0 s, 108.6 tps, lat 74.116 ms stddev 46.210
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 68203
latency average = 70.347 ms
latency stddev = 32.525 ms
initial connection time = 258.057 ms
tps = 113.709426 (without initial connection time)

```
---
```
alter system set autovacuum_analyze_threshold TO 0;
alter table pgbench_accounts set (autovacuum_vacuum_scale_factor = 0.01);
alter table pgbench_accounts set (autovacuum_analyze_scale_factor=0.05);
```
```
starting vacuum...end.
progress: 60.0 s, 112.1 tps, lat 70.986 ms stddev 30.331
progress: 120.0 s, 114.2 tps, lat 70.055 ms stddev 28.404
progress: 180.0 s, 108.0 tps, lat 74.076 ms stddev 42.107
progress: 240.0 s, 113.9 tps, lat 70.212 ms stddev 27.566
progress: 300.0 s, 114.1 tps, lat 70.126 ms stddev 27.797
progress: 360.0 s, 108.4 tps, lat 73.821 ms stddev 37.072
progress: 420.0 s, 113.6 tps, lat 70.457 ms stddev 29.349
progress: 480.0 s, 106.7 tps, lat 74.941 ms stddev 45.293
progress: 540.0 s, 113.1 tps, lat 70.714 ms stddev 30.292
progress: 600.0 s, 114.3 tps, lat 70.011 ms stddev 28.057
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 67107
latency average = 71.493 ms
latency stddev = 33.089 ms
initial connection time = 279.893 ms
tps = 111.886078 (without initial connection time)
```
---
```
alter system set autovacuum_naptime TO 10;
```
```
starting vacuum...end.
progress: 60.0 s, 110.5 tps, lat 72.025 ms stddev 31.423
progress: 120.0 s, 109.9 tps, lat 72.817 ms stddev 33.947
progress: 180.0 s, 112.5 tps, lat 71.097 ms stddev 29.956
progress: 240.0 s, 110.3 tps, lat 72.524 ms stddev 35.225
progress: 300.0 s, 107.9 tps, lat 74.139 ms stddev 43.595
progress: 360.0 s, 112.5 tps, lat 71.061 ms stddev 29.428
progress: 420.0 s, 111.7 tps, lat 71.629 ms stddev 31.294
progress: 480.0 s, 112.3 tps, lat 71.140 ms stddev 30.572
progress: 540.0 s, 111.2 tps, lat 71.985 ms stddev 31.230
progress: 600.0 s, 106.2 tps, lat 75.327 ms stddev 46.483
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 66315
latency average = 72.357 ms
latency stddev = 34.699 ms
initial connection time = 238.804 ms
tps = 110.551901 (without initial connection time)

```
---
```
alter system set autovacuum_analyze_scale_factor TO 0.02;
alter system set autovacuum_vacuum_scale_factor TO 0.03;
```
```
starting vacuum...end.
progress: 60.0 s, 112.1 tps, lat 70.991 ms stddev 30.361
progress: 120.0 s, 105.3 tps, lat 75.951 ms stddev 51.460
progress: 180.0 s, 110.9 tps, lat 72.134 ms stddev 31.472
progress: 240.0 s, 111.5 tps, lat 71.768 ms stddev 31.280
progress: 300.0 s, 111.0 tps, lat 72.031 ms stddev 32.792
progress: 360.0 s, 112.2 tps, lat 71.254 ms stddev 31.075
progress: 420.0 s, 104.6 tps, lat 76.555 ms stddev 48.683
progress: 480.0 s, 111.3 tps, lat 71.920 ms stddev 31.190
progress: 540.0 s, 111.7 tps, lat 71.583 ms stddev 30.501
progress: 600.0 s, 109.2 tps, lat 73.293 ms stddev 37.860
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 65996
latency average = 72.703 ms
latency stddev = 36.298 ms
initial connection time = 232.504 ms
tps = 110.024109 (without initial connection time)

```
---
```
alter system set autovacuum_vacuum_insert_scale_factor TO 0.05;
alter system set autovacuum_vacuum_insert_scale_factor TO 0.05;
alter system set autovacuum_vacuum_insert_threshold TO 200;
```
```
starting vacuum...end.
progress: 60.0 s, 110.5 tps, lat 72.043 ms stddev 30.837
progress: 120.0 s, 110.2 tps, lat 72.596 ms stddev 33.586
progress: 180.0 s, 111.7 tps, lat 71.606 ms stddev 30.865
progress: 240.0 s, 107.1 tps, lat 74.489 ms stddev 45.528
progress: 300.0 s, 109.3 tps, lat 73.351 ms stddev 40.114
progress: 360.0 s, 112.0 tps, lat 71.418 ms stddev 31.370
progress: 420.0 s, 110.4 tps, lat 72.420 ms stddev 33.286
progress: 480.0 s, 111.6 tps, lat 71.747 ms stddev 31.117
progress: 540.0 s, 109.2 tps, lat 73.262 ms stddev 36.436
progress: 600.0 s, 107.8 tps, lat 74.248 ms stddev 41.882
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 65996
latency average = 72.703 ms
latency stddev = 35.798 ms
initial connection time = 232.185 ms
tps = 110.025206 (without initial connection time)
```
---
```
alter system set autovacuum_vacuum_scale_factor TO 0.05;
alter system set autovacuum_naptime TO 15;
alter system set autovacuum_vacuum_threshold TO 20;
alter system set autovacuum_analyze_threshold TO 20;
```
```
starting vacuum...end.
progress: 60.0 s, 105.7 tps, lat 75.345 ms stddev 44.398
progress: 120.0 s, 111.0 tps, lat 72.066 ms stddev 33.093
progress: 180.0 s, 110.3 tps, lat 72.506 ms stddev 34.239
progress: 240.0 s, 113.4 tps, lat 70.534 ms stddev 29.120
progress: 300.0 s, 113.6 tps, lat 70.451 ms stddev 29.307
progress: 360.0 s, 107.1 tps, lat 74.700 ms stddev 39.447
progress: 420.0 s, 112.5 tps, lat 71.108 ms stddev 30.222
progress: 480.0 s, 112.7 tps, lat 70.995 ms stddev 29.691
progress: 540.0 s, 111.9 tps, lat 71.487 ms stddev 31.421
progress: 600.0 s, 112.2 tps, lat 71.287 ms stddev 30.547
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 66630
latency average = 72.012 ms
latency stddev = 33.412 ms
initial connection time = 227.738 ms
tps = 111.080540 (without initial connection time)
```
---
```
alter system set autovacuum_naptime TO 30;
```
```
starting vacuum...end.
progress: 60.0 s, 106.0 tps, lat 75.119 ms stddev 43.710
progress: 120.0 s, 114.0 tps, lat 70.168 ms stddev 28.522
progress: 180.0 s, 113.2 tps, lat 70.632 ms stddev 29.345
progress: 240.0 s, 112.1 tps, lat 71.259 ms stddev 32.494
progress: 300.0 s, 112.1 tps, lat 71.475 ms stddev 34.557
progress: 360.0 s, 109.5 tps, lat 73.041 ms stddev 36.801
progress: 420.0 s, 113.0 tps, lat 70.762 ms stddev 29.333
progress: 480.0 s, 112.1 tps, lat 71.307 ms stddev 30.684
progress: 540.0 s, 113.3 tps, lat 70.633 ms stddev 29.466
progress: 600.0 s, 111.5 tps, lat 71.760 ms stddev 35.463
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 67024
latency average = 71.596 ms
latency stddev = 33.287 ms
initial connection time = 218.918 ms
tps = 111.717787 (without initial connection time)

```
---
```
alter system set autovacuum_analyze_scale_factor TO 0.05;
alter system set autovacuum_vacuum_scale_factor TO 0.05;
alter table pgbench_accounts set (autovacuum_vacuum_threshold=0);
```
```
starting vacuum...end.
progress: 60.0 s, 111.1 tps, lat 71.701 ms stddev 30.660
progress: 120.0 s, 109.9 tps, lat 72.817 ms stddev 37.630
progress: 180.0 s, 113.5 tps, lat 70.493 ms stddev 29.138
progress: 240.0 s, 113.6 tps, lat 70.428 ms stddev 29.033
progress: 300.0 s, 110.8 tps, lat 72.215 ms stddev 34.572
progress: 360.0 s, 113.0 tps, lat 70.714 ms stddev 28.757
progress: 420.0 s, 108.8 tps, lat 73.562 ms stddev 43.280
progress: 480.0 s, 109.8 tps, lat 72.663 ms stddev 34.869
progress: 540.0 s, 113.2 tps, lat 70.795 ms stddev 35.377
progress: 600.0 s, 110.2 tps, lat 72.632 ms stddev 36.095
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 66841
latency average = 71.788 ms
latency stddev = 34.188 ms
initial connection time = 222.290 ms
tps = 111.422762 (without initial connection time)

```
---
```
alter system set autovacuum_vacuum_cost_limit TO 800;
```
```starting vacuum...end.
progress: 60.0 s, 108.2 tps, lat 73.525 ms stddev 37.592
progress: 120.0 s, 105.4 tps, lat 75.868 ms stddev 47.452
progress: 180.0 s, 106.7 tps, lat 74.965 ms stddev 42.308
progress: 240.0 s, 101.8 tps, lat 78.587 ms stddev 52.892
progress: 300.0 s, 109.5 tps, lat 73.047 ms stddev 37.361
progress: 360.0 s, 110.1 tps, lat 72.683 ms stddev 36.366
progress: 420.0 s, 110.6 tps, lat 72.329 ms stddev 37.883
progress: 480.0 s, 107.2 tps, lat 74.617 ms stddev 45.614
progress: 540.0 s, 101.1 tps, lat 79.109 ms stddev 54.691
progress: 600.0 s, 108.0 tps, lat 74.091 ms stddev 39.677
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
duration: 600 s
number of transactions actually processed: 64125
latency average = 74.822 ms
latency stddev = 43.521 ms
initial connection time = 271.497 ms
tps = 106.907084 (without initial connection time)
```
---
