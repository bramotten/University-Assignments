#! /usr/bin/env bash

# note: reference sort leaves leading zeros (eg 01) so better use our
# Test PROG with all txt files in tests/
# Compare the output with reference output files *.out

PROG=./mysort
prog_output=$(mktemp)
tests=`find tests/*.txt`

trap "rm -f $prog_output" EXIT

for t in $tests
do
    echo "testing: $t"
    $PROG < $t > $prog_output
    if diff -q $prog_output ${t%.*}.out > /dev/null;
    then
        echo "OK"
    else
        if diff -qwB $prog_output ${t%.*}.out > /dev/null;
        then
            echo "OK (apart from whitespace)"
        else
            echo "FAILED"
        fi
    fi
done

rm -f $prog_output
