#!/bin/sh
input_file=$1
output_file=$2

if [ -z "$input_file" ]; then
	echo "You need to provide an input file name as an argument."
	echo "Exiting..."
	exit 1
elif [ -z "$output_file" ]; then
	echo "You need to provide an output file name as the second argument."
	echo "Exiting..."
	exit 1
fi

byte_count=$(wc -c "$input_file" | cut -d" " -f1)
i=0
touch "$output_file"

while read -n2 byte; do
	let i+=2
	echo -ne "Bytes decoded: $i --|-- Total Bytes: $byte_count\r"
	printf "\x$byte" 2>/dev/null >>"$output_file"
done <"$input_file"

let i-=1
echo "Bytes decoded: $i --|-- Total Bytes: $byte_count"
echo "Output file: $2"
