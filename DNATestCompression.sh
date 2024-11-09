#!/bin/bash

# Vai nella directory EDS_GEN
cd EDS_GEN || { echo "Impossibile accedere alla directory EDS_GEN. Assicurati di aver prima eseguito ./install.sh"; exit 1; }

echo "Opzioni:"
echo "1 - Crea un nuovo file"
echo "0 - Scegli un file esistente"

# Leggi l'input dell'utente per creare o scegliere un file
read -p "Inserisci 1 per creare un nuovo file o 0 per scegliere un file esistente: " scelta

# Gestisci la creazione o la selezione del file
if [[ $scelta -eq 1 ]]; then
    # Se l'utente ha scelto 1, crea un nuovo file RAW o EDS

    echo "Creazione del file RAW..."
    read -p "Enter output name: " filename_selezionato
    read -p "Enter TOTsize: " TOTsize
    ./mainEDS-GEN --type R --outputName ../sample/"${filename_selezionato}" --totSize "${TOTsize}"
    filename_selezionato = "${filename_selezionato}".txt

else
    if [[ $scelta -eq 5 ]]; then
        exit 1
    fi
    # Se l'utente ha scelto 0, mostra la lista dei file sample
    echo "Lista dei file sample:"
    ls ../samples/
    read -p "Inserisci il nome del file da selezionare: " file_selezionato
      
    # Controlla se il file esiste nella cartella specificata
    if [[ -f "samples/$file_selezionato" ]]; then
        echo "Il file $file_selezionato è stato selezionato correttamente"
    else
        echo "Il file $file_selezionato non esiste nella cartella $cartella. Riprova!!"
        exit 1
    fi
fi

# Conferma il file creato o selezionato
echo "File creato/selezionato: $file_selezionato"


# Crea una directory per i file compressi nella cartella principale
mkdir -p ../file_compressed
echo "Cartella 'file_compressed' creata nella directory principale."

# Ulteriori opzioni per RAW o EDS
echo "Se hai creato un RAW, premi 0."
echo "Se hai creato un EDS, premi 1."

read -p "Inserisci 0 per RAW o 1 per EDS: " tipo_file

if [[ $tipo_file -eq 0 ]]; then
    # Compressione del file RAW in vari formati
    echo "Compressione del file RAW in corso..."
    gzip -c "$file_selezionato" > "../file_compressed/${file_selezionato}.gz"
    bzip2 -c "$file_selezionato" > "../file_compressed/${file_selezionato}.bz2"
    xz -c "$file_selezionato" > "../file_compressed/${file_selezionato}.xz"
    echo "file compressi correttamente"
elif [[ $tipo_file -eq 1 ]]; then
    # Espansione e compressione del file EDS
   # echo "Espansione del file EDS in formato RAW..."
    # Esempio di comando per l'espansione (sostituire con il comando effettivo)
    # eds_expand "$file_selezionato" > "${file_selezionato%.eds}.raw"
   # echo "Compressione sequenziale del file originale..."
   # gzip -c "$file_selezionato" > "../file_compressed/${file_selezionato}.gz"
   # bzip2 -c "$file_selezionato" > "../file_compressed/${file_selezionato}.bz2"
   # xz -c "$file_selezionato" > "../file_compressed/${file_selezionato}.xz"
   # echo "Confronto tra i file compressi completato."
else
    echo "Opzione non valida. Uscita."
    exit 1
fi
