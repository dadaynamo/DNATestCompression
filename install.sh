#!/bin/bash

mkdir -p samples/
mkdir -p csv/
mkdir -p file_compressed/
# Script per clonare una lista fissa di repository Git

# Lista repo da installare
repos=(
    "https://github.com/dadaynamo/EDS_GEN.git"
    "https://github.com/dadaynamo/DNAStructureInfo.git"
)

# Ciclo su ciascun URL di repository e clonazione
for repo in "${repos[@]}"; do
    echo "Clonando la repository da $repo ..."
    git clone "$repo"
    echo "Clonazione completata per $repo."
done

cd DNAStructureInfo
make
cd -
cd DNAStructureInfo/main2
make
cd -

cd EDS-GEN 
make
cd -

# Compilazione edsToRaw
cd EDS_GEN/edsToRaw
make
cd -

cd EDS_GEN/stringCheck
make
cd -

git clone "https://github.com/felipelouza/gsufsort.git"
cd gsufsort
make TERMINATOR=0 DNA=1
cd -

git clone "https://github.com/simongog/sdsl-lite.git"
cd sdsl-lite
./install.sh ../
cd -

git clone "https://github.com/giovannarosone/EDS-BWT.git"
cd EDS-BWT
make 
cd -

echo -n "Caricamento: ["
# Esegui un ciclo per simulare il progresso
for ((i = 0; i <= 50; i++)); do
    sleep 0.1  # Ritardo per simulare un'attesa
    echo -n "#"
done
echo "] Completato!"
sleep 1
clear
echo "\ Ricordati di inserire in EDS-BWT nel file EDS-BWTransform.sh come path GSUFPATH = "../gsufsort" /"
echo "\ E nel makefile di EDS-BWT nel campo SDSL_INC = "../include" e in SDSL_LIB = "../lib" /"
sleep 15
clear
