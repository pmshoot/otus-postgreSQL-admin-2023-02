pgbench -i

clean
```
progress: 60.0 s, 66.7 tps, lat 119.055 ms stddev 117.012, 0 failed
progress: 120.0 s, 64.9 tps, lat 123.664 ms stddev 138.115, 0 failed
progress: 180.0 s, 61.8 tps, lat 129.333 ms stddev 136.689, 0 failed
progress: 240.0 s, 64.1 tps, lat 124.394 ms stddev 122.562, 0 failed
progress: 300.0 s, 65.1 tps, lat 123.264 ms stddev 115.615, 0 failed
progress: 360.0 s, 64.1 tps, lat 124.749 ms stddev 132.372, 0 failed
progress: 420.0 s, 63.6 tps, lat 125.761 ms stddev 146.961, 0 failed
progress: 480.0 s, 40.1 tps, lat 198.906 ms stddev 180.960, 0 failed
progress: 540.0 s, 33.0 tps, lat 242.859 ms stddev 152.553, 0 failed
progress: 600.0 s, 33.3 tps, lat 239.948 ms stddev 154.622, 0 failed
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
maximum number of tries: 1
duration: 600 s
number of transactions actually processed: 33416
number of failed transactions: 0 (0.000%)
latency average = 143.608 ms
latency stddev = 143.356 ms
initial connection time = 196.475 ms
tps = 55.693080 (without initial connection time)
```

- settings

```
progress: 60.0 s, 62.8 tps, lat 126.986 ms stddev 144.107, 0 failed
progress: 120.0 s, 65.2 tps, lat 122.780 ms stddev 118.481, 0 failed
progress: 180.0 s, 65.3 tps, lat 122.417 ms stddev 117.915, 0 failed
progress: 240.0 s, 66.1 tps, lat 120.729 ms stddev 119.584, 0 failed
progress: 300.0 s, 65.0 tps, lat 123.431 ms stddev 124.226, 0 failed
progress: 360.0 s, 63.4 tps, lat 125.617 ms stddev 134.197, 0 failed
progress: 420.0 s, 64.5 tps, lat 124.422 ms stddev 137.470, 0 failed
progress: 480.0 s, 65.0 tps, lat 122.977 ms stddev 132.118, 0 failed
progress: 540.0 s, 63.1 tps, lat 126.927 ms stddev 134.035, 0 failed
progress: 600.0 s, 62.7 tps, lat 127.502 ms stddev 136.436, 0 failed
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
maximum number of tries: 1
duration: 600 s
number of transactions actually processed: 38593
number of failed transactions: 0 (0.000%)
latency average = 124.337 ms
latency stddev = 130.027 ms
initial connection time = 155.319 ms
tps = 64.327912 (without initial connection time)
```


• log_autovacuum_min_duration = 0
• autovacuum_max_workers = 10
• autovacuum_naptime = 15s
• autovacuum_vacuum_threshold = 25
• autovacuum_vacuum_scale_factor = 0.05
• autovacuum_vacuum_cost_delay = 10
• autovacuum_vacuum_cost_limit = 1000

```
progress: 60.0 s, 62.6 tps, lat 127.369 ms stddev 132.779, 0 failed
progress: 120.0 s, 63.5 tps, lat 125.941 ms stddev 125.751, 0 failed
progress: 180.0 s, 64.5 tps, lat 123.493 ms stddev 131.587, 0 failed
progress: 240.0 s, 62.5 tps, lat 128.694 ms stddev 147.031, 0 failed
progress: 300.0 s, 61.2 tps, lat 130.673 ms stddev 135.007, 0 failed
progress: 360.0 s, 64.6 tps, lat 123.172 ms stddev 129.519, 0 failed
progress: 420.0 s, 65.6 tps, lat 122.532 ms stddev 131.426, 0 failed
progress: 480.0 s, 62.7 tps, lat 127.510 ms stddev 127.269, 0 failed
progress: 540.0 s, 61.6 tps, lat 129.889 ms stddev 137.730, 0 failed
progress: 600.0 s, 58.8 tps, lat 135.508 ms stddev 148.931, 0 failed
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
maximum number of tries: 1
duration: 600 s
number of transactions actually processed: 37664
number of failed transactions: 0 (0.000%)
latency average = 127.489 ms
latency stddev = 135.092 ms
initial connection time = 184.191 ms
tps = 62.715257 (without initial connection time)
```

postgres=# alter system set autovacuum_vacuum_scale_factor = 0.02;

```
progress: 60.0 s, 60.8 tps, lat 130.646 ms stddev 125.524, 0 failed
progress: 120.0 s, 63.1 tps, lat 127.206 ms stddev 138.397, 0 failed
progress: 180.0 s, 62.9 tps, lat 127.055 ms stddev 130.448, 0 failed
progress: 240.0 s, 64.8 tps, lat 122.996 ms stddev 121.585, 0 failed
progress: 300.0 s, 63.3 tps, lat 126.769 ms stddev 127.239, 0 failed
progress: 360.0 s, 63.2 tps, lat 126.588 ms stddev 137.728, 0 failed
progress: 420.0 s, 60.3 tps, lat 132.698 ms stddev 148.973, 0 failed
progress: 480.0 s, 63.0 tps, lat 126.739 ms stddev 133.238, 0 failed
progress: 540.0 s, 60.6 tps, lat 132.187 ms stddev 144.225, 0 failed
progress: 600.0 s, 62.8 tps, lat 127.355 ms stddev 134.930, 0 failed
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
maximum number of tries: 1
duration: 600 s
number of transactions actually processed: 37500
number of failed transactions: 0 (0.000%)
latency average = 127.957 ms
latency stddev = 134.373 ms
initial connection time = 180.540 ms
tps = 62.509780 (without initial connection time)
```

postgres=# alter system set autovacuum_vacuum_cost_delay = 5;
postgres=# alter system set autovacuum_vacuum_cost_limit = 2000;
postgres=# alter system set autovacuum_vacuum_scale_factor = 0.01;

```
progress: 60.0 s, 64.2 tps, lat 124.084 ms stddev 121.550, 0 failed
progress: 120.0 s, 62.7 tps, lat 127.570 ms stddev 133.917, 0 failed
progress: 180.0 s, 59.8 tps, lat 133.075 ms stddev 139.069, 0 failed
progress: 240.0 s, 66.4 tps, lat 121.030 ms stddev 124.867, 0 failed
progress: 300.0 s, 63.6 tps, lat 125.775 ms stddev 119.576, 0 failed
progress: 360.0 s, 62.3 tps, lat 128.361 ms stddev 136.035, 0 failed
progress: 420.0 s, 63.4 tps, lat 125.720 ms stddev 121.030, 0 failed
progress: 480.0 s, 57.8 tps, lat 138.863 ms stddev 151.645, 0 failed
progress: 540.0 s, 64.3 tps, lat 124.344 ms stddev 136.753, 0 failed
progress: 600.0 s, 63.7 tps, lat 124.998 ms stddev 128.671, 0 failed
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 8
number of threads: 1
maximum number of tries: 1
duration: 600 s
number of transactions actually processed: 37709
number of failed transactions: 0 (0.000%)
latency average = 127.270 ms
latency stddev = 131.606 ms
initial connection time = 187.538 ms
tps = 62.849957 (without initial connection time)

```



---
pgbench -i -s 100 -F 1000

- clean

```
progress: 60.0 s, 97.5 tps, lat 81.641 ms stddev 51.375, 0 failed
progress: 120.0 s, 94.4 tps, lat 84.648 ms stddev 59.948, 0 failed
progress: 180.0 s, 87.0 tps, lat 92.061 ms stddev 77.354, 0 failed
progress: 240.0 s, 90.2 tps, lat 88.671 ms stddev 60.210, 0 failed
progress: 300.0 s, 79.8 tps, lat 100.004 ms stddev 69.259, 0 failed
progress: 360.0 s, 81.0 tps, lat 98.958 ms stddev 71.537, 0 failed
progress: 420.0 s, 80.0 tps, lat 100.123 ms stddev 63.362, 0 failed
progress: 480.0 s, 78.7 tps, lat 101.749 ms stddev 75.048, 0 failed
progress: 540.0 s, 83.8 tps, lat 95.318 ms stddev 62.565, 0 failed
progress: 600.0 s, 77.6 tps, lat 103.227 ms stddev 68.149, 0 failed
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 100
query mode: simple
number of clients: 8
number of threads: 1
maximum number of tries: 1
duration: 600 s
number of transactions actually processed: 51000
number of failed transactions: 0 (0.000%)
latency average = 94.077 ms
latency stddev = 66.323 ms
initial connection time = 196.885 ms
tps = 85.017171 (without initial connection time)
```
- settings

```
progress: 60.0 s, 84.6 tps, lat 94.089 ms stddev 64.603, 0 failed
progress: 120.0 s, 84.0 tps, lat 95.313 ms stddev 61.201, 0 failed
progress: 180.0 s, 82.8 tps, lat 96.582 ms stddev 65.817, 0 failed
progress: 240.0 s, 80.6 tps, lat 99.313 ms stddev 63.226, 0 failed
progress: 300.0 s, 85.8 tps, lat 93.126 ms stddev 64.703, 0 failed
progress: 360.0 s, 84.1 tps, lat 95.132 ms stddev 65.454, 0 failed
progress: 420.0 s, 81.5 tps, lat 97.990 ms stddev 64.051, 0 failed
progress: 480.0 s, 84.2 tps, lat 94.987 ms stddev 59.871, 0 failed
progress: 540.0 s, 85.3 tps, lat 93.830 ms stddev 66.016, 0 failed
progress: 600.0 s, 85.2 tps, lat 93.881 ms stddev 63.621, 0 failed
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 100
query mode: simple
number of clients: 8
number of threads: 1
maximum number of tries: 1
duration: 600 s
number of transactions actually processed: 50301
number of failed transactions: 0 (0.000%)
latency average = 95.385 ms
latency stddev = 63.911 ms
initial connection time = 200.522 ms
tps = 83.854210 (without initial connection time)
```

• log_autovacuum_min_duration = 0
• autovacuum_max_workers = 10
• autovacuum_naptime = 15s
• autovacuum_vacuum_threshold = 25
• autovacuum_vacuum_scale_factor = 0.05
• autovacuum_vacuum_cost_delay = 10
• autovacuum_vacuum_cost_limit = 1000

```
progress: 60.0 s, 88.4 tps, lat 90.189 ms stddev 56.595, 0 failed
progress: 120.0 s, 88.2 tps, lat 90.704 ms stddev 61.226, 0 failed
progress: 180.0 s, 91.9 tps, lat 86.888 ms stddev 56.577, 0 failed
progress: 240.0 s, 93.3 tps, lat 85.889 ms stddev 52.645, 0 failed
progress: 300.0 s, 87.6 tps, lat 91.283 ms stddev 65.307, 0 failed
progress: 360.0 s, 89.1 tps, lat 89.681 ms stddev 52.067, 0 failed
progress: 420.0 s, 89.1 tps, lat 89.806 ms stddev 51.460, 0 failed
progress: 480.0 s, 81.4 tps, lat 98.313 ms stddev 52.733, 0 failed
progress: 540.0 s, 81.0 tps, lat 98.741 ms stddev 64.717, 0 failed
progress: 600.0 s, 78.3 tps, lat 101.971 ms stddev 81.996, 0 failed
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 100
query mode: simple
number of clients: 8
number of threads: 1
maximum number of tries: 1
duration: 600 s
number of transactions actually processed: 52106
number of failed transactions: 0 (0.000%)
latency average = 92.084 ms
latency stddev = 60.062 ms
initial connection time = 130.138 ms
tps = 86.851970 (without initial connection time)
```

postgres=# alter system set autovacuum_vacuum_scale_factor = 0.02;

```
progress: 60.0 s, 92.5 tps, lat 85.899 ms stddev 51.776, 0 failed
progress: 120.0 s, 91.5 tps, lat 87.586 ms stddev 52.128, 0 failed
progress: 180.0 s, 90.2 tps, lat 88.630 ms stddev 68.162, 0 failed
progress: 240.0 s, 95.7 tps, lat 83.593 ms stddev 50.737, 0 failed
progress: 300.0 s, 96.9 tps, lat 82.581 ms stddev 49.719, 0 failed
progress: 360.0 s, 90.1 tps, lat 88.796 ms stddev 57.324, 0 failed
progress: 420.0 s, 90.2 tps, lat 88.700 ms stddev 62.986, 0 failed
progress: 480.0 s, 87.0 tps, lat 91.823 ms stddev 72.789, 0 failed
progress: 540.0 s, 92.2 tps, lat 86.847 ms stddev 57.403, 0 failed
progress: 600.0 s, 90.6 tps, lat 88.261 ms stddev 65.082, 0 failed
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 100
query mode: simple
number of clients: 8
number of threads: 1
maximum number of tries: 1
duration: 600 s
number of transactions actually processed: 55019
number of failed transactions: 0 (0.000%)
latency average = 87.193 ms
latency stddev = 59.167 ms
initial connection time = 241.799 ms
tps = 91.729425 (without initial connection time)
```

postgres=# alter system set autovacuum_vacuum_cost_delay = 5;
postgres=# alter system set autovacuum_vacuum_cost_limit = 2000;
postgres=# alter system set autovacuum_vacuum_scale_factor = 0.01;

```
progress: 60.0 s, 87.3 tps, lat 91.290 ms stddev 54.732, 0 failed
progress: 120.0 s, 88.6 tps, lat 90.215 ms stddev 58.879, 0 failed
progress: 180.0 s, 91.0 tps, lat 87.982 ms stddev 59.596, 0 failed
progress: 240.0 s, 91.5 tps, lat 87.462 ms stddev 58.365, 0 failed
progress: 300.0 s, 83.9 tps, lat 95.175 ms stddev 67.886, 0 failed
progress: 360.0 s, 90.9 tps, lat 88.135 ms stddev 54.813, 0 failed
progress: 420.0 s, 89.2 tps, lat 89.620 ms stddev 61.029, 0 failed
progress: 480.0 s, 91.9 tps, lat 87.054 ms stddev 61.309, 0 failed
progress: 540.0 s, 96.1 tps, lat 83.209 ms stddev 56.374, 0 failed
progress: 600.0 s, 88.4 tps, lat 90.521 ms stddev 68.799, 0 failed
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 100
query mode: simple
number of clients: 8
number of threads: 1
maximum number of tries: 1
duration: 600 s
number of transactions actually processed: 53929
number of failed transactions: 0 (0.000%)
latency average = 88.961 ms
latency stddev = 60.341 ms
initial connection time = 207.147 ms
tps = 89.906150 (without initial connection time)
```
