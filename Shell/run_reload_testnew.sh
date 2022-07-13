#!/bin/bash  

for i in `seq 1 10`; do
    echo >>> Run $i times
    sh reload_serializer_test.sh

    if [ `expr $i % 5` == 0 ]
    then
        echo "<<< Collect top info"
        top -b -n1 > top.txt
        kubectl cp <some-namespace>/<some-pod>:/tmp/foo /mnt/c/Users/t-yitingliu/Desktop/topLogs
    fi
done