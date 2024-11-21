#!/bin/bash

# Vai nella directory EDS_GEN
cd EDS_GEN || { echo "Impossibile accedere alla directory EDS_GEN. Assicurati di aver prima eseguito ./install.sh"; exit 1; }

# Ulteriori opzioni per RAW o EDS
echo "Lavora con un file RAW, premi 0."
echo "Lavora con un file EDS, premi 1."


read -p "-> " tipo_file
clear

# Esegui azioni in base all'input
case $tipo_file in
    # Lavoro con Raw DIRETTAMENTE
    0)  
        
        echo -e "\e[32mOpzioni\e[0m"
        echo -e "\e[32m1\e[0m - Crea un nuovo file"
        echo -e "\e[32m0\e[0m - Scegli un file esistente"

        # Leggi l'input dell'utente per creare o scegliere un file
        read -p "Inserisci 1 per creare un nuovo file o 0 per scegliere un file esistente: " scelta
        clear
        # Gestisci la creazione o la selezione del file
        if [[ $scelta -eq 1 ]]; then
            # Se l'utente ha scelto 1, crea un nuovo file RAW

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
            ls ../samples/*.txt
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

        #Da inserire la parte di compressione
        
        #stampa della cartella sample e cartella file_compressed
        echo -e "\e[32mCartella Sample\e[0m"
        ls samples
        echo -e "\e[32mCartella file_compressed\e[0m"
        ls file_compressed
        read -p "Inserisci il nome del filename Originale: " inOrigin
        read -p "Inserisci la lista dei file name per il confronto: " inListComp
        pwd
        echo "${inOrigin}"
        echo "${inListComp}"
        
        #./mainDNAStructureInfo --type C --typeOut T --typeIn E --profile A --outputName output --inOrigin input --inListComp test1 test2 test3

        ./DNAStructureInfo/mainDNAStructureInfo --type C --typeOut C --profile A --outputName final --inOrigin samples/"${inOrigin}" --inListComp "${inListComp}"

        exit 0
        ;;

    #Lavoro inizialmente con un file eds
    1)
        
        echo -e "\e[32mOpzioni\e[0m"
        echo -e "\e[32m1\e[0m - Crea un nuovo file"
        echo -e "\e[32m0\e[0m - Scegli un file esistente"

        # Leggi l'input dell'utente per creare o scegliere un file
        read -p "Inserisci 1 per creare un nuovo file o 0 per scegliere un file esistente: " scelta
        clear
        # Gestisci la creazione o la selezione del file
        if [[ $scelta -eq 1 ]]; then
            # Se l'utente ha scelto 1, crea un nuovo file RAW

            echo "Creazione del file EDS..."
            read -p "Enter output name: " filename_selezionato
            read -p "Enter TOTsize: " TOTsize
            read -p "Enter maxPerDeg: " maxPerDeg
            read -p "Enter numDeg: " numDeg
            
            ./mainEDS-GEN --type E --outputName ../samples/"${filename_selezionato}" --totSize "${TOTsize}" --maxPerDeg "${maxPerDeg}" --numDeg "${numDeg}"
            filename_selezionato="${filename_selezionato}.eds"
          

        else
            if [[ $scelta -eq 5 ]]; then
                exit 1
            fi

            # Se l'utente ha scelto 0, mostra la lista dei file sample
            echo "Lista dei file sample:"
            ls ../samples/*.eds
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


        # Espansione in raw
        #./EDS_GEN/edsToRaw/eds_gen ../../samples/"${filename_selezionato}" ../../samples/"${filename_selezionato}.txt"
        ./EDS_GEN/edsToRaw/eds_gen samples/"${filename_selezionato}" samples/"${filename_selezionato}.txt"
        filename_selezionato="${filename_selezionato}.txt"


        # Crea una directory per i file compressi nella cartella principale
        mkdir -p file_compressed
        echo "Cartella 'file_compressed' creata nella directory principale."


        #da controllare se il file compresso è quello selezionato
        if [[ $tipo_file -eq 1 ]]; then
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

        #Da inserire la parte di compressione
        

        exit 0
        ;;
    #Errore inserimento scelta
    *)
        echo "Errore: Valore non valido."
        exit 1
        ;;
esac    



