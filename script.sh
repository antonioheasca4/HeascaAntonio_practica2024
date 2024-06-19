#!/bin/bash

# Functie pentru masurarea timpului de executie, output-ului, apelurilor de sistem si de biblioteca
collect_metrics() 
{
    /usr/bin/time -f "%e" "$@" > output.txt 2> time.txt
    strace -o strace_output.txt "$@" > /dev/null
    ltrace -o ltrace_output.txt "$@" > /dev/null
    local execution_time=$(cat time.txt)
    local output=$(cat output.txt)
    local sys_calls=$(cat strace_output.txt)
    local lib_calls=$(cat ltrace_output.txt | head -n -1)

    #afisez in .csv doar denumirile apelurilor de sistem si a celor de biblioteca
    local var_sys=$(echo "$sys_calls" | egrep -o "^.+\(" | egrep -o "^[^ ]+" | egrep -o "^[^(]+" | tr "\n" " ")
    local var_lib=$(echo "$lib_calls" | egrep -o "^.+\(" | egrep -o "^[^ ]+" | egrep -o "^[^(]+" | tr "\n" " ")

    echo "$execution_time|$output|$var_sys|$var_lib" 
}

# Functie pentru creare fisier .csv
create_csv() 
{
    local csv_file=$1
    echo "Application,Input,Output,Time,System Calls,Library Calls" > "$csv_file"
}

# Functie pentru adaugarea in fisierul CSV
append_csv() 
{
    local csv_file=$1
    local application=$2
    local input=$3
    local output=$4
    local time=$5
    local sys_calls=$6
    local lib_calls=$7
    echo "$application,$input,$output,$time,$sys_calls,$lib_calls" >> "$csv_file"
}

# Functie pentru interogarea utilizatorului
query_user() 
{
    if [ "$dir_choice" = "da" ]; then
        echo "Introduceti numele aplicatiei:"
        read app_name

            if [[ ! -x $app_name ]] ; then
                echo "$app_name nu e executabil..."
                exit 1
            fi   

        echo "Introduceti numele directorului ce contine fisierele de input:"
        read input_dir

            if [[ ! -d $input_dir ]] ; then
                echo "$input_dir nu e director..."
                exit 1
            fi   

        echo "Doriti sa creati un fisier CSV cu detalii despre toate inputurile? (da/nu)"
        read create_csv_choice

        if [ "$create_csv_choice" = "da" ]; then
            csv_file="results.csv"
            create_csv "$csv_file"
        fi

        set -x
        for input_file in "$input_dir"/*; do
            input=$(cat "$input_file")
            metrics=$(collect_metrics "$app_name" $input)
            if [ "$create_csv_choice" = "da" ]; then
                local execution_time=$(echo "$metrics" | cut -d'|' -f1)
                local output=$(echo "$metrics" | cut -d'|' -f2)
                local sys_calls=$(echo "$metrics" | cut -d'|' -f3)
                local lib_calls=$(echo "$metrics" | cut -d'|' -f4)

                append_csv "$csv_file" "$app_name" "$input" "$output" "$execution_time" "$sys_calls" "$lib_calls"
            fi
        done
    else
        local app_name=$1
        shift 
        local arg=$@

        echo "Doriti sa creati un fisier CSV? (da/nu)"
        read create_csv_choice

        if [ "$create_csv_choice" = "da" ]; then
            csv_file="results.csv"
            create_csv "$csv_file"
        fi
        
        metrics=$(collect_metrics "$app_name" $arg)
        echo $metrics
        if [ "$create_csv_choice" = "da" ]; then
                local execution_time=$(echo "$metrics" | cut -d'|' -f1)
                local output=$(echo "$metrics" | cut -d'|' -f2)
                local sys_calls=$(echo "$metrics" | cut -d'|' -f3)
                local lib_calls=$(echo "$metrics" | cut -d'|' -f4)

                append_csv "$csv_file" "$app_name" "$arg" "$output" "$execution_time" "$sys_calls" "$lib_calls"
        fi

        
    fi
}

# Start script
if [ $# -lt 1 ]; then
    echo "Doriti sa furnizati un nume de director ce contine fisiere de input? (da/nu)"
    read dir_choice
    if [[ "$dir_choice" = "nu" ]] ; then
        echo "Trebuia furnizat un director deorece ati optat pentru apelarea scriptului fara parametri"
        exit 1
    fi    
    query_user # userul nu introduce argumente pentru ca doreste furnizarea unui director cu fisierele de input
else
    app_name=$1
    shift
    args=$@       
    query_user "$app_name" "$args"
fi
