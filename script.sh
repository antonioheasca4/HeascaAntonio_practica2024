#!/bin/bash


measure_execution_time() 
{
    local executable=$1
    echo "Measuring execution time..."
    /usr/bin/time -v $executable &> execution_time.txt
    echo "Execution time details saved to execution_time.txt"
}



if [[ $# -ne 1 ]]; then
    echo "Too much arguments/No argument!"
    exit 1
fi


if [[ ! -x $1 ]]; then
    echo "The specified file is not executable or does not exist: $1"
    exit 1
fi

    measure_execution_time $1



