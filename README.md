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