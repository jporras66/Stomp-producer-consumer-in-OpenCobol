#!/bin/bash
#
#
for i in 1 2 3 4 5
do
    export FILEDAT=$APL/data/filedat.$i.out
    nohup $APL/brkcob/consumer  > $APL/data/consumer.$i.out 2> $APL/data/consumer.$i.err & 
done
