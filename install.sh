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

