#!/bin/bash

mkdir -p samples/
# Script per clonare una lista fissa di repository Git

# Lista repo da installare
repos=(
    "https://github.com/dadaynamo/EDS_GEN.git"
    "https://github.com/dadaynamo/DNAStructureInfo.git"
    "https://github.com/felipelouza/gsufsort.git"
)

# Ciclo su ciascun URL di repository e clonazione
for repo in "${repos[@]}"; do
    echo "Clonando la repository da $repo ..."
    git clone "$repo"
    echo "Clonazione completata per $repo."
done

# Compilazione delle varie repo
# Scorri tutte le cartelle nella directory corrente
for dir in */ ; do
    # Controlla se è effettivamente una directory
    if [ -d "$dir" ]; then
        echo "Entrando nella cartella $dir"
        cd "$dir"
        
        # Esegui 'make' solo se un Makefile è presente
        if [ -f "Makefile" ] || [ -f "makefile" ]; then
            echo "Eseguendo 'make' in $dir"
            make
        else
            echo "Nessun Makefile trovato in $dir, saltando."
        fi
        
        # Torna alla cartella principale
        cd ..
    fi
done


echo -n "Caricamento: ["
# Esegui un ciclo per simulare il progresso
for ((i = 0; i <= 50; i++)); do
    sleep 0.1  # Ritardo per simulare un'attesa
    echo -n "#"
done
echo "] Completato!"
sleep 1
clear
echo "\ Ora puoi avviare DNATestCompression.sh per eseguire la procedura /"
sleep 3
clear





