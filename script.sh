#!/bin/bash

#variabila pentru mesajul "deja creat .csv"
CSV="este deja creat si doresc append(apasa 1)"

#variabila "booleana" pentru cunoasterea optiunii de .csv de la user
OK_CSV=0

# Functie pentru masurarea timpului de executie, output-ului, apelurilor de sistem si de biblioteca
collect_metrics() 
{
    { time "$@"; } > output.txt 2> time_output.txt
    cat time_output.txt | tail -n 3 | head -n 1 | cut -d'l' -f2 | tr "\n" " " | tr "," "." | sed "s/\t//" > time.txt

    strace -o strace_output.txt "$@" > /dev/null

    ltrace -o ltrace_output.txt "$@" > /dev/null


    local execution_time=$(cat time.txt)
    local output=$(cat output.txt | tr "\n" ";")
    local sys_calls=$(cat strace_output.txt)
    local lib_calls=$(cat ltrace_output.txt | head -n -1)

    #afisez in .csv doar denumirile apelurilor de sistem si a celor de biblioteca
    local var_sys=$(echo "$sys_calls" | egrep -o "^.+\(" | egrep -o "^[^ ]+" | egrep -o "^[^(]+" | sort | uniq | tr "\n" " ")
    local var_lib=$(echo "$lib_calls" | egrep -o "^.+\(" | egrep -o "^[^ ]+" | egrep -o "^[^(]+" | sort | uniq | tr "\n" " ")

    #numar apeluri distincte sistem/biblioteca
    local nr_sys_dis=$(echo "$sys_calls" | egrep -o "^.+\(" | egrep -o "^[^ ]+" | egrep -o "^[^(]+" |  sort | uniq | wc -l)
    local nr_lib_dis=$(echo "$lib_calls" | egrep -o "^.+\(" | egrep -o "^[^ ]+" | egrep -o "^[^(]+" | sort | uniq | wc -l)

    #numar apeluri NOT distincte sistem/biblioteca
    local nr_sys=$(echo "$sys_calls" | egrep -o "^.+\(" | egrep -o "^[^ ]+" | egrep -o "^[^(]+" | wc -l)
    local nr_lib=$(echo "$lib_calls" | egrep -o "^.+\(" | egrep -o "^[^ ]+" | egrep -o "^[^(]+" | wc -l)

    echo "$execution_time|$output|$var_sys|$var_lib|$nr_sys_dis|$nr_lib_dis|$nr_sys|$nr_lib" 
    rm time_output.txt
}


# Functie pentru creare fisier .csv
create_csv() 
{
    local csv_file=$1
    echo "Application,Input,Output,Time,#System_Calls(distinct),#System_Calls,#Library_Calls(distinct),#Library_Calls,System Calls,Library Calls" > "$csv_file"
}

# Functie pentru adaugarea in fisierul CSV
append_csv() 
{
    local csv_file=$1
    local application=$2
    local input=$3
    local output=$4
    local time=$5
    local nr_sys_calls_dis=$6
    local nr_lib_calls_dis=$8
    local sys_calls=${10}
    local lib_calls=${11}
    local nr_sys_calls=$7
    local nr_lib_calls=$9
    echo "$application,$input,$output,$time,$nr_sys_calls_dis,$nr_sys_calls,$nr_lib_calls_dis,$nr_lib_calls,$sys_calls,$lib_calls" >> "$csv_file"
}

# Functie pentru interogarea utilizatorului
query_user() 
{
    if [ "$dir_choice" = "da" ]; then
        echo "Introduceti numele directorului ce contine fisierele de input:"
        read input_dir

            if [[ ! -d $input_dir ]] ; then
                echo "$input_dir nu e director..."
                exit 1
            fi   

        echo "Doriti sa creati un fisier CSV cu inputuri? (da/nu/$CSV)"
        read create_csv_choice

        if [[ ! "$create_csv_choice" = "da" ]]  && [[ ! "$create_csv_choice" = "nu" ]] && [[ ! "$create_csv_choice" = "1" ]] ; then
            echo "Optiune invalida"
            exit 1
        fi     

        csv_file="$app_name.csv"

        if [ "$create_csv_choice" = "da" ]; then
            OK_CSV=1
            create_csv "$csv_file"
        elif [ "$create_csv_choice" = "1" ] ; then  
            OK_CSV=1
        fi        

        

        for input_file in "$input_dir"/*; do
            input=$(cat "$input_file")
            metrics=$(collect_metrics "$app_name" $input)
            if [[ "$create_csv_choice" = "da" || "$create_csv_choice" = "1" ]]; then
                local execution_time=$(echo "$metrics" | cut -d'|' -f1)
                local output=$(echo "$metrics" | cut -d'|' -f2)
                local sys_calls=$(echo "$metrics" | cut -d'|' -f3)
                local lib_calls=$(echo "$metrics" | cut -d'|' -f4)
                local sys_nr_dis=$(echo "$metrics" | cut -d'|' -f5)
                local lib_nr_dis=$(echo "$metrics" | cut -d'|' -f6)
                local sys_nr=$(echo "$metrics" | cut -d'|' -f7)
                local lib_nr=$(echo "$metrics" | cut -d'|' -f8)

                if [[ $OK_CSV -eq 1 ]] ; then
                    append_csv "$csv_file" "$app_name" "$input" "$output" "$execution_time" "$sys_nr_dis" "$sys_nr" "$lib_nr_dis" "$lib_nr" "$sys_calls" "$lib_calls"
                fi    
            fi
        done
    else
        app_name=$1
        shift 
        local arg=$@

        echo "Doriti sa creati un fisier CSV? (da/nu/$CSV)"
        read create_csv_choice
        
        if [[ ! "$create_csv_choice" = "da" ]]  && [[ ! "$create_csv_choice" = "nu" ]] && [[ ! "$create_csv_choice" = "1" ]] ; then
            echo "Optiune invalida"
            exit 1
        fi  

        csv_file="$app_name.csv"

        if [ "$create_csv_choice" = "da" ]; then
            OK_CSV=1
            create_csv "$csv_file"
        elif [ "$create_csv_choice" = "1" ] ; then  
            OK_CSV=1
        fi

        metrics=$(collect_metrics "$app_name" $arg)
        if [[ "$create_csv_choice" = "da" || "$create_csv_choice" = "1" ]]; then
                local execution_time=$(echo "$metrics" | cut -d'|' -f1)
                local output=$(echo "$metrics" | cut -d'|' -f2)
                local sys_calls=$(echo "$metrics" | cut -d'|' -f3)
                local lib_calls=$(echo "$metrics" | cut -d'|' -f4)
                local sys_nr_dis=$(echo "$metrics" | cut -d'|' -f5)
                local lib_nr_dis=$(echo "$metrics" | cut -d'|' -f6)
                local sys_nr=$(echo "$metrics" | cut -d'|' -f7)
                local lib_nr=$(echo "$metrics" | cut -d'|' -f8)

                if [[ $OK_CSV -eq 1 ]] ; then
                    append_csv "$csv_file" "$app_name" "$arg" "$output" "$execution_time" "$sys_nr_dis" "$sys_nr" "$lib_nr_dis" "$lib_nr" "$sys_calls" "$lib_calls"
                fi    
        fi

        
    fi
}


open_libreoffice()
{
    echo "Doriti deschiderea fisierului $csv_file?(da/nu)"
    read open_choice

    if [[ "$open_choice" = "da" ]] ; then
        libreoffice --calc "$csv_file"    
    fi   
}

#interogare deschidere fisier de testare 
open_files()
{
    PS3="Alegeti o optiune referitoare la deschiderea unui fisier de testare a unei metrici (1/2/3/4/5) -> "
    select ITEM in "ltrace_output" "output" "strace_output" "time" "exit"
        do 
            case $REPLY in 
                1)gedit ltrace_output.txt ;; 
                2) gedit output.txt ;;
                3) gedit strace_output.txt ;; 
                4) gedit time.txt ;;  
                5) return;;
                *) echo "Optiune incorecta" 
                    open_files ;;
            esac
        done
}



#interogare deschidere .csv
query_open_csv()
{
    if [ $OK_CSV -eq 1 ] ; then
        open_libreoffice
    fi 
}
   
generate_chart_of_calls() 
{

    echo "Doriti generarea unei diagrame a apelurilor(sistem/biblioteca) aplicatiei?(da/nu)"
    read choice

    if [[ ! "$choice" = "da" ]] ; then
        return
    else
        echo "Se va genera un fisier png cu numele fisier_csv.png"    
    fi

    local data_file="data.txt"
    if [ $OK_CSV -eq 1 ] ; then
        cut -d',' -f4-8 "$csv_file" > "$data_file"
        tail -n +2 "$data_file" > "$data_file.tmp"
    fi 

output_plot="$csv_file.png"
    gnuplot << EOF
set terminal png size 800,600
set output "$output_plot"
set title "Diagrama pentru detalii despre apelurile aplicatiei"
set datafile separator ","
set style data histogram
set style histogram clustered
set style fill solid 1.0
set boxwidth 0.8 relative

plot "$data_file.tmp" using 2 title '#SYSCALLSdistinct', \
     '$data_file.tmp' using 3 title '#SYSCALLS', \
     '$data_file.tmp' using 4 title '#LIBCALLSDISdistinct', \
     '$data_file.tmp' using 5 title '#LIBCALLS', 
EOF

    # sterg fisierele auxiliare folosite
    rm data* 
}

checker()
{
    echo "Doriti sa utilizati optiunea de checker,furnizand 2 nume de directore(unul cu inputuri si unul cu outputurile aferente)?(da/nu)"
    read choice

    if [[ ! "$choice" = "da" ]] ; then
        return
    fi 

    echo "Introduceti directorul de inputuri"
    read in_dir

    echo "Introduceti directorul de outputuri"
    read out_dir   
    
    if [[ ! -d "$in_dir" || ! -d "$out_dir" ]]; then
        echo "Director/Directoare incorecte"
        return
    fi

    #preiau fisierele

    files_in="$in_dir"/*
    files_out=$(ls $out_dir)

    #adaug fisierele de out intr un fisier temporar
    local tmp="out.txt"
    echo "$files_out" | tr "\t" "\n" > $tmp



    # verific nr de fisiere sa fie identic
    if [[ ${#files_in[@]} -ne ${#files_out[@]} ]]; then
        echo "Directoarele nu au acelasi numar de fisiere!"
        return
    fi

    local corect=0
    local contor=1
    
    for file_in in $files_in; do

        file_out_aux=$(cat $tmp | head -n $contor | tail -n 1)
        file_out="$out_dir/$file_out_aux"

        if [[ ! -f "$file_in" || ! -f "$file_out" ]]; then
            echo "Unul din fisiere nu este regulat!"
            exit 1
        fi

        #fisier folosit pt outputul executiei aplicatiei
        local aux_file="temp.txt"

        local input=$(cat $file_in)
        $app_name $input > $aux_file
        
        
        local var=$(diff -q --line-format=%l "$file_out" "$aux_file")
        if [[ -n $var ]] ; then
            echo "Fisierul $file_out nu contine outputul corect aferent inputului din fisierul $file_in!"
        else
            let corect++
        fi

        let contor++
    done  
    
    let contor=contor-1
    echo $corect
    echo $contor
    echo "Procentajul de corectitudine al fisierelor de output este:"
    bc<<<"scale=2;$corect.0/$contor.0 * 100.0"

    #sterg fisierele temporare 
    rm $tmp
    rm $aux_file
}


flow_of_script()
{
    query_open_csv
    open_files
    generate_chart_of_calls
    checker
}


# De aici incepe scriptul (distractia)
# Start script
if [[ "$1" = "-d" ]]; then
        app_name=$2
        echo "Doriti sa furnizati un nume de director ce contine fisiere de input? (da/nu)"
        read dir_choice
        if [[ "$dir_choice" = "nu" ]] ; then
            echo "Trebuia furnizat un director deorece ati optat pentru apelarea scriptului fara parametri"
            exit 1
        fi    
        query_user # userul nu introduce argumente pentru ca doreste furnizarea unui director cu fisierele de input
elif [[ "$1" = "-a" ]] ; then
        app_name=$2
        shift
        shift
        args=$@       
        query_user "$app_name" "$args"
else 
    echo "Optiune invalida.EXIT..."
    exit 1        
fi
flow_of_script