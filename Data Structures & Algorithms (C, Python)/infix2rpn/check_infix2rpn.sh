#! /usr/bin/env bash

PROG=./infix2rpn

echo "~42f + 5 ^ (2)g => ..."
$PROG "~42f + 5 ^ (2)g"
echo 

echo "4 2 + 5 => 42 5 +"
$PROG "4 2 + 5"
echo 

echo "~~42 => 42 ~ ~"
$PROG "~~42"