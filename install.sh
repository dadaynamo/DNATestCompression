#!/bin/bash

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
cd /EDS_GEN
make
cd ..
cd /DNAStructureInfo
make
cd ..


echo -n "Caricamento: ["
# Esegui un ciclo per simulare il progresso
for ((i = 0; i <= 50; i++)); do
    sleep 0.1  # Ritardo per simulare un'attesa
    echo -n "#"
done
echo "] Completato!"

clear

./EDS_GEN

#If vuoi creare un file raw clicca 1
    # Se si allora creo file RAW
    # Comprimo il file in tot modi diversi
    # Confronto tra file

    # Else creo il file EDS con X parametri
    # Espansione del file eds in formato Raw
    # Compressione sequenziale del file originale
    # Confronto tra file



