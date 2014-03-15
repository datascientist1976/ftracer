#!/bin/sh

if [ $# != 1 ]; then
	echo "usage gen_report.sh exe"
	exit 1
fi

exe=$1
trace_file=/tmp/trace.txt
data_file=/tmp/trace_data

./formatter.py -f $trace_file > $data_file

cat $data_file | while read prefix function caller
do
	func_data=`addr2line -e $exe -f -C $function`
	caller_data=`addr2line -e $exe -s -f -C $caller | tail -1`

        func_name=`echo $func_data | awk '{print $1}'`
        func_location=`echo $func_data | awk '{print $2}'`

	echo "$prefix [$func_name]($func_location) - (called from $caller_data)"
done

rm -f $data_file