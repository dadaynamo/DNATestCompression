#!/bin/bash

# Nome del file EDS di input
input_eds="input.eds"
# Nome del file RAW di output dal programma edsToRaw
output_raw="Outputraw.raw"
# Nome del file BWT di output dal programma gsufsort
output_bwt="Outputbwt.bwt"
# Nome dell'archivio compresso finale
output_archive="compressed_output.7z"

# Step 1: Convertire il file EDS in RAW usando edsToRaw
echo "Converting EDS file to RAW format..."
edsToRaw "$input_eds" --output "$output_raw"
if [ $? -ne 0 ]; then
    echo "Errore durante la conversione con edsToRaw."
    exit 1
fi

# Step 2: Usare il file RAW come input per gsufsort con opzioni --txt e --bwt
echo "Applying gsufsort to RAW file..."
gsufsort "$output_raw" --txt --bwt --output "$output_bwt"
if [ $? -ne 0 ]; then
    echo "Errore durante l'elaborazione con gsufsort."
    exit 1
fi

# Step 3: Comprimere il file BWT generato usando 7-Zip con metodo PPMd
echo "Compressing BWT output with 7-Zip using PPMd..."
7z a -m0=PPMd "$output_archive" "$output_bwt"
if [ $? -ne 0 ]; then
    echo "Errore durante la compressione con 7-Zip."
    exit 1
fi

# Step 4: Eseguire il programma DNAStructureInfo
echo "Running DNAStructureInfo..."
DNAStructureInfo "$output_bwt" # Aggiungi eventuali parametri necessari per DNAStructureInfo
if [ $? -ne 0 ]; then
    echo "Errore durante l'esecuzione di DNAStructureInfo."
    exit 1
fi

echo "Operazione completata con successo! File compresso: $output_archive"
