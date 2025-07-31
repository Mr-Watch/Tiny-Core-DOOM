#!/bin/sh
input_file=$1

if [ -z "$input_file" ]; then
	echo "You need to provide an input file name as an argument."
	echo "Exiting..."
	exit 1
fi

if [ ! -e "$input_file" ]; then
	echo "The input file name does correspond to an existing file."
	echo "Exiting..."
	exit 1
fi

#This way can work but is not ass elegant, or fast.
#hexdump -Xv $input_file | cut -d" " -f1 --complement | tr -s "  " | tr "\n" " " | tr -s "  " | tr " " "\n" > $input_file.hex ; sed -i '1d;$d' $input_file.hex;

hexdump -v -e'1/1 "%02x"' "$input_file" >"$input_file".hex
echo "Encoding finished."
echo "Output file: $input_file.hex"
