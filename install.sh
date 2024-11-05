#!/bin/bash

# Script per clonare una lista fissa di repository Git

# Lista delle repository da clonare
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