# HeascaAntonio_practica2024
Script pentru testarea unei aplicații(timp de execuție, input-output, apeluri de sistem(strace), apeluri de biblioteca(ltrace)). Modularizat.

# 17.06.2024

    Am modificat README
    Din nou!

# 18.06.2024
Mi-am definit task-urile de inceput:
-Scriptul primeste parametri, astfel:
    Primul parametru -> numele aplicatiei
    Restul -> parametrii aplicatiei

-Implementare functii pentru:
    1.Timp de executie
    2.Input-Output
    3.Apeluri de sistem(strace)
    4.Apeluri de biblioteca(ltrace)
    5.Functii pentru gestionare metrici:
        a.creare fisier .csv cu detalii despre aplicatia testata
        b.append in fisierul .csv
        c.creare fisiere pentru fiecare metrica
    6.Functie pentru interogarea utilizatorului cu privire la optiunea de a furniza numele unui director ce contine fisiere de input pentru a fi testate fiecare in parte

-Scriptul va fi interactiv, in sensul ca va interoga cu privire la:
    *append sau nu in fisiere
    *optiunea primirii unui nume de director ce contine fisiere de input pentru a fi testate
        (aici scriptul nu o sa mai primeasca parametrii , ci utilizatorul va introduce doar numele aplicatiei fara argumente, urmand ca argumentele sa le preia din fisiere)

# 19.06.2024
-Am inceput implementarea functiilor si testarea acestora
-Am rezolvat problema cu utilitarul ltrace
-Am stabilit ca separator virgula in cadrul fisierului .csv(la deschiderea acestuia e important)
-Am aflat de comanda shift si am folosit-o pentru a "shifta" la stanga parametrii pozitionali ai scriptului
-Voi afisa in .csv doar denumirile apelurilor de sistem,de biblioteca, nu si detaliile acestora

# 20.06.2024
-Adaugare campuri in .csv referitoare la numarul apelurilor de sistem/biblioteca (distincte si nu)
-Implementare functie de interogare user cu privire la deschiderea fisierului .csv dupa rularea scriptului
-Implementare functie de interogare cu privirea la deschiderea vreunuia dintre fisierele de testare
-Modularizare script (organizarea pe functii + definire flow)
-Implementare functie de generare a unei diagrame a apelurilor

# 21.06.2024
-Implementare functionalitate de "checker"
    * user-ul poate introduce numele a 2 directoare: unul ce contine fisiere de input si altul ce contine fisiere de output
    * scriptul executa aplicatia pe rand cu fiecare input si compara ceea ce obtine cu ceea ce se afla in fisierul de output aferent
    * se furnizeaza un procentaj de corectitudine

# 25.06.2024
- Verificare functionalitati pe mai multe aplicatii
- ';' in loc de '\n' in fisierul .csv (pentru output)
- Am modificat politica de apelare a scriptului:
    * cu optiunea -d se furnizeaza ca parametri doar numele aplicatiei , urmand a se furniza si un director cu fisiere de input
    * cu optiunea -a se furnizeaza ca parametri numele aplicatiei si argumentele acesteia
- Modificare modul collect_metrics (pentru a prelua timpul de executie mai precis,utilizand keyword-ul time)

# 26.06.2024
- Implementare functionalitate de analiza codului sursa (tipuri de date,structuri repetitive,posibile bug-uri)
- Testare functionalitate
- Utilizatorul va folosi optiunea -t fara alt paramatru atunci cand va rula scriptul
- Documenatare top 5 functii generatoare de bug-uri