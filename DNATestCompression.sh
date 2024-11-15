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
    ./mainEDS-GEN --type R --outputName ../samples/"${filename_selezionato}" --totSize "${TOTsize}"
    filename_selezionato="${filename_selezionato}.txt"
    tipo="raw"

else
    if [[ $scelta -eq 5 ]]; then
        exit 1
    fi

    # Se l'utente ha scelto 0, mostra la lista dei file sample
    echo "Lista dei file sample:"
    ls ../samples/
    read -p "Inserisci il nome del file da selezionare: " filename_selezionato
      
    # Controlla se il file esiste nella cartella specificata
    if [[ -f "../samples/$filename_selezionato" ]]; then
        echo "Il file $filename_selezionato è stato selezionato correttamente"
    else
        echo "Il file $filename_selezionato non esiste nella cartella $cartella. Riprova!!"
        exit 1
    fi
fi

# Conferma il file creato o selezionato
echo "File creato/selezionato: $filename_selezionato"

cd ..

pwd


# Crea una directory per i file compressi nella cartella principale
mkdir -p file_compressed
echo "Cartella 'file_compressed' creata nella directory principale."

# Ulteriori opzioni per RAW o EDS
echo "Se hai creato un RAW, premi 0."
echo "Se hai creato un EDS, premi 1."


read -p "Inserisci 0 per RAW o 1 per EDS: " tipo_file

if [[ $tipo_file -eq 0 ]]; then
    # Compressione del file RAW in vari formati
    echo "Compressione del file RAW in corso..."
    7z a -mx=5 -m0=PPMd "file_compressed/${filename_selezionato}_PPMd.7z" samples/"$filename_selezionato"
    echo "***************************************************************************************************"
    7z a -mx=5 -m0=LZMA "file_compressed/${filename_selezionato}_LZMA.7z" samples/"$filename_selezionato"
    echo "***************************************************************************************************"
    7z a -mx=5 -m0=LZMA2 "file_compressed/${filename_selezionato}_LZMA2.7z" samples/"$filename_selezionato" 
    echo "***************************************************************************************************"
    7z a -mx=5 -m0=BZip2 "file_compressed/${filename_selezionato}_BZip2.7z" samples/"$filename_selezionato"
    echo "***************************************************************************************************"
    7z a -mx=5 -m0=Deflate64 "file_compressed/${filename_selezionato}_Deflate64.7z" samples/"$filename_selezionato"
    # Solo con p7zip "non ufficiale"
    #echo "***************************************************************************************************"
    #7z a -mx=5 -m0=LZ4 "file_compressed/${filename_selezionato}_LZ4.7z" samples/"$filename_selezionato"
    echo "***************************************************************************************************"
    echo "compressioni eseguite"

    #gzip -c samples/"$filename_selezionato" > "file_compressed/${filename_selezionato}.gz"
    #bzip2 -c samples/"$filename_selezionato" > "file_compressed/${filename_selezionato}.bz2"
    #xz -c "samples/$filename_selezionato" > "file_compressed/${filename_selezionato}.xz"
    #echo "file compressi correttamente"
fi