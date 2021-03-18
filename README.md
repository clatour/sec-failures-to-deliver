## SEC Failures To Deliver

```
# First install `xsv` if you don't have it:
$ cargo install xsv
# This will download the SEC archives since 2009, clean the data, and create a single ftds.csv file in the current directory.
$ ./main.bash
```

Now you have a single `ftds.csv` with all FTD data. You can do whatever you want now, ex: partition it by ticker:
```
# xsv opens all the files at once when you partition
$ ulimit -n 5000000
$ mkdir -p by-ticker
$ xsv partition 3 by-ticker ftds.csv
```

Dumb way to make a quick db given the csv:
```
$ sqlite3 < ftds.sql
$ sqlite3 ftds.db
sqlite> select * from ftds where symbol = "GME" order by 1 desc limit 1;
20210129|36467W109|GME|138179|GAMESTOP CORP (HLDG CO) CL A|193.60
```

Or use the docker image (volumes are used in examples for caching, and will, by default, modify the current working directory):
```
## This will drop a ftds.csv in your $(pwd)
$ docker run --rm -v $(pwd)/archive:/opt/ftds/archive -v $(pwd)/www.sec.gov:/opt/ftds/www.sec.gov -v $(pwd):/opt/ftds/out clatour/sec-failures-to-deliver

## Or exec in with bash and run manually. Has tools like sqlite3 and xsv installed already
$ docker run --rm -v $(pwd)/archive:/opt/ftds/archive -v $(pwd)/www.sec.gov:/opt/ftds/www.sec.gov -v $(pwd):/opt/ftds/out -it clatour/sec-failures-to-deliver bash
# ./main.bash
```
