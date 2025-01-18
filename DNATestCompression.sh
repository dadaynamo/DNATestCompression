#!/bin/bash

#!/bin/bash

# Funzione per mostrare il menu
show_menu() {
  echo "----------------------------------------"
  echo -e "| \e[32mScegli un Opzione\e[0m                    |"
  echo -e "| \e[32m1)\e[0m Generazione DNA in vari formati   |"
  echo -e "| \e[32m2)\e[0m Controllo EDS creati              |"
  echo -e "| \e[32m3)\e[0m EDS to RAW                        |"
  echo -e "| \e[32m4)\e[0m BWT di file                       |"
  echo -e "| \e[32m5)\e[0m Compressione file                 |"
  echo -e "| \e[32m6)\e[0m Confronto tra file  (NO)          |"
  echo -e "| \e[32m7)\e[0m Check delle cartelle              |"
  echo -e "| \e[32m8)\e[0m Mostra contenuto file             |"
  echo -e "| \e[32m9)\e[0m Stampa CSV                        |"  
  echo -e "| \e[32m10)\e[0m EDS-BWT                          |" 
  echo -e "| \e[32m11)\e[0m Aggiungi intestazione ind in csv |" 
  echo -e "| \e[32m12)\e[0m Aggiungi intestazione comp in csv|" 
  echo -e "| \e[32m13)\e[0m Aggiungi riga individuale in csv |" 
  echo -e "| \e[32m14)\e[0m Aggiungi riga di confronto csv   |" 
  echo -e "| \e[32m15)\e[0m Rimuovi ultima riga in csv       |" 
  echo -e "| \e[32m16)\e[0m Calcolo numero e tasso run       |" 
  echo -e "| \e[32m0)\e[0m Esci                              |"
  echo "----------------------------------------"
}


run_program1() {
    clear

    # Vai nella directory EDS_GEN
    cd EDS_GEN || { echo "Impossibile accedere alla directory EDS_GEN. Assicurati di aver prima eseguito ./install.sh"; exit 1; }

    # Ulteriori opzioni per RAW o EDS
    echo "Genera un file RAW, premi 0."
    echo "Genera un file EDS, premi 1."


    read -p "-> " tipo_file
    clear

    # Esegui azioni in base all'input
    case $tipo_file in
        # Genera un Raw DIRETTAMENTE
        0)  
            # Se l'utente ha scelto 1, crea un nuovo file RAW

            echo "Creazione del file RAW..."
            read -p "Enter output name: " filename_selezionato
            read -p "Enter TOTsize: " TOTsize
            ./mainEDS-GEN --type R --outputName ../samples/"${filename_selezionato}" --totSize "${TOTsize}"
            filename_selezionato="${filename_selezionato}.txt"

            # Conferma il file creato o selezionato
            echo "File creato/selezionato: $filename_selezionato"
            cd ..
            pwd  
    
            ;;

        #Lavoro inizialmente con un file eds
        1)
                echo "Creazione del file EDS..."
                read -p "Enter output name: " filename_selezionato
                read -p "Enter TOTsize: " TOTsize
                read -p "Enter maxPerDeg: " maxPerDeg
                read -p "Enter numDeg: " numDeg
                
                ./mainEDS-GEN --type E --outputName ../samples/"${filename_selezionato}" --totSize "${TOTsize}" --maxPerDeg "${maxPerDeg}" --numDeg "${numDeg}"
                filename_selezionato="${filename_selezionato}.eds"
            
            # Conferma il file creato o selezionato
            echo "File creato/selezionato: $filename_selezionato"
            cd ..
            pwd

            ;;
        #Errore inserimento scelta
        *)
            echo "Errore: Valore non valido."
            exit 1
            ;;
    esac    


}


run_program2() {
    clear

    #stampa degli eds in sample
    pwd 
    echo "Scegli un EDS tra i disponibili: "
    #stampa lista filename
    echo "--------------------------------"
    echo "Dir /samples:"
    for file in samples/*.eds; do
        echo "$(basename "$file")"
    done
    echo "--------------------------------"
    read -p "-> " file_name

    # Controlla se il file esiste
    if [ -f "samples/$file_name" ]; then
    cd EDS_GEN/stringCheck || { echo "Impossibile accedere alla directory EDS_GEN/stringCheck. Assicurati di aver prima eseguito ./install.sh"; exit 1; }
    cd -
    ./EDS_GEN/stringCheck/stringCheck "samples/$file_name" "samples/output_stringCheck"
    else
    echo "Errore: Il file $file_name non esiste. Riprova..."

    fi


}


run_program3() {
  clear
  pwd
  #controlla che ci sia edtoraw compilato
  # Controlla se il file esiste
    if [ -d "EDS_GEN/edsToRaw" ]; then
      #stampa lista filename
      echo "--------------------------------"
      echo "Dir /samples:"
      for file in samples/*.eds; do
          echo "$(basename "$file")"
      done
      echo "--------------------------------"
      read -p "Inserisci il nome del file da selezionare: " filename_selezionato
      filename_new="${filename_selezionato%.*}"
      ./EDS_GEN/edsToRaw/edsToRaw "samples/$filename_selezionato" "samples/${filename_new}_e.txt"

    else
      echo "Errore: La directory in questione non esiste o non è accessbile. Riprova con ./install.sh"
    fi

  #inserisci sia input che samples/output
  
  
}

run_program4() {
  clear
  # Mostra la lista dei file sample
  echo "Lista dei file in samples:"
  ls -al samples/
  read -p "Inserisci il nome del file da selezionare: " filename_selezionato
 
  if [ -f "samples/$filename_selezionato" ]; then
    echo "-------------------------------------"
    echo "Avvio BWT di ${filename_selezionato}"
    echo "-------------------------------------"
    pwd
    filename_new="${filename_selezionato%.*}"
    
    ./gsufsort/gsufsort "samples/${filename_selezionato}" --txt --bwt --time --output "samples/${filename_new}_b"

    echo "Completato. Puoi ora controllare in samples/ l'output"
  
  else
    echo "Il file selezionato non esiste"
  fi

}


run_program5() { # compressione
  clear
  # Verifica se la cartella esiste
  if [ -d "file_compressed" ]; then
    # Mostra la lista dei file sample
    echo "Lista dei file in samples:"
    ls samples/
    read -p "Inserisci i nomi dei file da selezionare (separati da spazi): " -a file_list
    archive_name=""

    # Controlla se i file esistono nella cartella specificata
    for file in "${file_list[@]}"; do
      if [[ ! -f "samples/$file" ]]; then
        echo "Il file $file non esiste nella cartella samples. Riprova!"
        exit 1
      fi
      # Crea un nome base per l'archivio dai nomi dei file (es. file1_file2)
      base_name="${file%.*}"
      archive_name="${archive_name}_${base_name}"
    done

    archive_name="${archive_name#_}" # Rimuove il primo underscore dal nome dell'archivio
    echo "I file selezionati sono: ${file_list[*]}"
    echo "Nome dell'archivio: $archive_name"

    # Compressione dei file RAW in vari formati
    echo "Compressione dei file RAW in corso..."
    7z a -mx=5 -m0=PPMd "file_compressed/${archive_name}_PPMd.7z" "${file_list[@]/#/samples/}"
    echo "*******************************************************************************************************************************"
    7z a -mx=5 -m0=LZMA "file_compressed/${archive_name}_LZMA.7z" "${file_list[@]/#/samples/}"
    echo "*******************************************************************************************************************************"
    7z a -mx=5 -m0=LZMA2 "file_compressed/${archive_name}_LZMA2.7z" "${file_list[@]/#/samples/}"
    echo "*******************************************************************************************************************************"
    7z a -mx=5 -m0=BZip2 "file_compressed/${archive_name}_BZip2.7z" "${file_list[@]/#/samples/}"
    echo "*******************************************************************************************************************************"
    7z a -mx=5 -m0=Deflate64 "file_compressed/${archive_name}_Deflate64.7z" "${file_list[@]/#/samples/}"
    echo "*******************************************************************************************************************************"
    echo "Compressioni eseguite correttamente."

  else
    echo "Riavviare il programma con ./install.h"
  fi
}



run_program6() {
  clear
  # Stampa della cartella samples e file_compressed
  echo -e "\e[32mCartella Samples\e[0m"
  ls samples
  echo -e "\e[32mCartella file_compressed\e[0m"
  if [ -d file_compressed ]; then
    if [ -z "$(ls -A file_compressed)" ]; then
      echo "-"
    else
      ls file_compressed
    fi
  else
    echo "La directory 'file_compressed' non esiste. Chiudere il programma e rieseguire ./install.sh"
    exit 1
  fi

  # Input del file originale
  read -p "Inserisci il nome del filename Originale: " inOrigin

  # Input per i file da samples
  read -p "Inserisci la lista dei file name dalla cartella samples da confrontare (premi Invio per lasciare vuoto): " inListCompSample
  pwd

  # Creazione della stringa modificata per samples
  outputsample=""
  if [ -n "$inListCompSample" ]; then
    for word in $inListCompSample; do
      outputsample+="samples/$word "  # Aggiungi "samples/" davanti a ogni parola
    done
    outputsample=$(echo "$outputsample" | sed 's/ $//') # Rimuovi spazio finale
  fi

  # Input per i file da file_compressed
  read -p "Inserisci la lista dei file name dalla cartella file_compressed da confrontare (premi Invio per lasciare vuoto): " inListCompfile_compressed
  pwd

  # Creazione della stringa modificata per file_compressed
  outputcompressed=""
  if [ -n "$inListCompfile_compressed" ]; then
    for word in $inListCompfile_compressed; do
      outputcompressed+="file_compressed/$word "  # Aggiungi "file_compressed/" davanti a ogni parola
    done
    outputcompressed=$(echo "$outputcompressed" | sed 's/ $//') # Rimuovi spazio finale
  fi

  # Costruisci la stringa finale
  finalInputList=""
  if [ -n "$outputsample" ]; then
    finalInputList+="$outputsample"
  fi
  if [ -n "$outputcompressed" ]; then
    if [ -n "$finalInputList" ]; then
      finalInputList+=" "  # Aggiungi spazio solo se necessario
    fi
    finalInputList+="$outputcompressed"
  fi

  # Mostra i risultati
  echo "Input originale: ${inOrigin}"
  echo "File dalla cartella samples: ${outputsample}"
  echo "File dalla cartella file_compressed: ${outputcompressed}"
  echo "Stringa concatenata: ${finalInputList}"
  
  # Esegui il comando finale
  echo "${finalInputList}"
  ./DNAStructureInfo/mainDNAStructureInfo --type C --typeOut C --profile A --outputName csv/final --inOrigin samples/"${inOrigin}" --inListComp "${finalInputList}"
  pwd
}


run_program7() {
    clear
    folder=$1  # Prende il nome della cartella come argomento
    echo $folder

    # Verifica se la cartella esiste
    if [ -d "$folder" ]; then
    echo "Contenuto della cartella $folder:"
    ls -al "$folder"  # Stampa il contenuto della cartella
    else
    echo "Errore: La cartella $folder non esiste."
    fi
}
run_program8() {
  clear
  cd samples/ || { echo "Errore: impossibile accedere alla directory samples/"; return 1; }
  echo "Lista file in samples/"
  ls .
  
  echo "Inserisci il nome del file che vuoi aprire (o digita 'exit' per uscire):"
  read -r file_name
  
  # Verifica se l'utente vuole uscire
  if [[ "$file_name" == "exit" ]]; then
    echo "Operazione annullata."
    cd -
    return 0
  fi
  
  # Verifica se il file esiste
  if [[ ! -f "$file_name" ]]; then
    echo "Errore: Il file '$file_name' non esiste."
    cd -
    return 1
  fi

  # Ottieni la dimensione del file
  if file_size=$(stat -c %s "$file_name" 2>/dev/null); then
    echo "Attenzione: Il file è grande ${file_size} byte."
  else
    echo "Errore: impossibile ottenere la dimensione del file."
    cd -
    return 1
  fi

  # Ciclo per confermare l'apertura del file
  while true; do
    read -rp "Sei sicuro di volerlo aprire? (s/n): " confirm
    case "$confirm" in
      [sS])
        cat "$file_name"
        echo ""
        break
        ;;
      [nN])
        echo "Operazione annullata. Il file non è stato aperto."
        break
        ;;
      *)
        echo "Input non valido. Inserisci 's' per sì o 'n' per no."
        ;;
    esac
  done
  
  # Torna alla directory precedente
  cd -
}
run_program9() {
  clear
  cd csv/ || { echo "Errore: impossibile accedere alla directory samples/"; return 1; }
  echo "Lista file in csv/"
  ls .
  
  echo "Inserisci il nome del file che vuoi aprire (o digita 'exit' per uscire):"
  read -r file_name
  
  # Verifica se l'utente vuole uscire
  if [[ "$file_name" == "exit" ]]; then
    echo "Operazione annullata."
    cd -
    return 0
  fi
  
  # Verifica se il file esiste
  if [[ ! -f "$file_name" ]]; then
    echo "Errore: Il file '$file_name' non esiste."
    cd -
    return 1
  fi

  #Apertura file csv in terminale
  echo "************************************************"
  cat "$file_name" | column -s, -t
  echo "************************************************"
  cd -
}

run_program10() { 
  # Directory dei file .eds
  SAMPLE_DIR="samples/"

  # Mostra la lista dei file con estensione .eds nella cartella samples/
  echo "File disponibili nella cartella $SAMPLE_DIR:"
  eds_files=("$SAMPLE_DIR"*.eds)
  if [ ${#eds_files[@]} -eq 0 ]; then
      echo "Nessun file .eds trovato nella cartella $SAMPLE_DIR."
      exit 1
  fi
  for file in "${eds_files[@]}"; do
      echo "- $(basename "$file")"
  done

  # Richiedi all'utente di selezionare un file
  echo -n "Inserisci il nome del file (inclusa estensione .eds): "
  read selected_file

  # Controlla che il file esista
  if [ ! -f "$SAMPLE_DIR$selected_file" ]; then
      echo "Errore: il file '$selected_file' non esiste nella cartella $SAMPLE_DIR."
      exit 1
  fi

  # Rimuove l'estensione .eds
  input_base_name="${selected_file%.eds}"
  echo "Nome base del file selezionato: $input_base_name"

  # Richiedi all'utente il nome del file output senza estensione
  echo -n "Inserisci il nome del file output (senza estensione): "
  read output_base_name

  # Esegui il programma EDS-BWT
  cd EDS-BWT
  mkdir -p ../samples/ebwt
  ./EDS-BWTransform.sh "../$SAMPLE_DIR$input_base_name" "../samples/$output_base_name"
  
  echo "Operazione completata. File output generato: ../samples/$output_base_name"
  cd -


}

run_program11() {
  clear
  # Elenca tutti i file con estensione .csv nella cartella csv/
  echo "File CSV nella cartella csv/:"
  for file in csv/*.csv; do
    if [ -f "$file" ]; then
        basename "$file"
    fi
  done
  # Chiede all'utente di inserire il nome di un file
  read -p "Inserisci il nome del file o creane uno nuovo (con estensione .csv): " file_name

  # Controlla se il file esiste nella cartella csv/
  if [ -f "csv/$file_name" ]; then
    # Rimuove l'estensione dal nome del file
    file_base_name="${file_name%.csv}"
    ./DNAStructureInfo/mainDNAStructureInfo --type HI --outputName csv/"${file_base_name}"
  else
    # Rimuove l'estensione dal nome del file
    file_base_name="${file_name%.csv}"
    echo "Il file '$file_name' non esiste nella cartella csv. Creazione completata"
    ./DNAStructureInfo/mainDNAStructureInfo --type HI --outputName csv/"${file_base_name}"
  fi

}
run_program12() {
  clear
  # Elenca tutti i file con estensione .csv nella cartella csv/
  echo "File CSV nella cartella csv/:"
  for file in csv/*.csv; do
    if [ -f "$file" ]; then
        basename "$file"
    fi
  done
  # Chiede all'utente di inserire il nome di un file
  read -p "Inserisci il nome del file o creane uno nuovo (con estensione .csv): " file_name

  # Controlla se il file esiste nella cartella csv/
  if [ -f "csv/$file_name" ]; then
    # Rimuove l'estensione dal nome del file
    file_base_name="${file_name%.csv}"
    ./DNAStructureInfo/mainDNAStructureInfo --type HC --outputName csv/"${file_base_name}"
  else
    # Rimuove l'estensione dal nome del file
    file_base_name="${file_name%.csv}"
    echo "Il file '$file_name' non esiste nella cartella csv. Creazione completata"
    ./DNAStructureInfo/mainDNAStructureInfo --type HC --outputName csv/"${file_base_name}"
  fi

 
}
run_program13() { #Aggiunta riga individuale per i raw
  clear    # Passaggi per selezionare il file .txt dalla cartella samples
  echo "Seleziona un file .txt dalla cartella samples/"

  # Elenco dei file .txt nella cartella samples
  files=($(ls samples/*.txt 2>/dev/null))

  if [ ${#files[@]} -gt 0 ]; then
      echo "File disponibili nella cartella samples/:"
      for i in "${!files[@]}"; do
          echo "$((i + 1)). $(basename "${files[$i]}")"
      done

      # Chiedi all'utente di inserire il nome del file
      read -p "Inserisci il nome del file .txt da selezionare: " nome_file
      inOrigin=""

      # Verifica se il file selezionato esiste nella cartella
      for file in "${files[@]}"; do
          if [ "$(basename "$file")" == "$nome_file" ]; then
              inOrigin="$nome_file"
              echo "Hai selezionato: $nome_file"
              break
          fi
      done

      if [ -z "$inOrigin" ]; then
          echo "Errore: Il file '$nome_file' non esiste nella cartella samples/."
          return 1
      fi
  else
      echo "Nessun file .txt trovato nella cartella samples/."
      return 1
  fi

  # Passaggi per selezionare il file .csv dalla cartella csv
  echo "Seleziona un file .csv dalla cartella csv/"

  # Elenco dei file .csv nella cartella csv
  files_csv=($(ls csv/*.csv 2>/dev/null))

  if [ ${#files_csv[@]} -gt 0 ]; then
      echo "File disponibili nella cartella csv/:"
      for i in "${!files_csv[@]}"; do
          echo "$((i + 1)). $(basename "${files_csv[$i]}")"
      done

      # Chiedi all'utente di inserire il nome del file
      read -p "Inserisci il nome del file .csv da selezionare: " nome_file_csv
      outputName=""

      # Verifica se il file selezionato esiste nella cartella
      for file in "${files_csv[@]}"; do
          if [ "$(basename "$file")" == "$nome_file_csv" ]; then
              outputName="$file"
              # Rimuovi l'estensione .csv dal nome del file
              outputName=$(basename "$outputName" .csv)
              echo "Hai selezionato: $outputName"
              break
          fi
      done

      if [ -z "$outputName" ]; then
          echo "Errore: Il file '$nome_file_csv' non esiste nella cartella csv/."
          return 1
      fi
  else
      echo "Nessun file .csv trovato nella cartella csv/."
      return 1
  fi

  # Se tutto è andato a buon fine, stampa OK
  echo "OK"
  echo "File inOrigin selezionato: $inOrigin"
  echo "File outputName selezionato: $outputName"

  # ./DNAStructureInfo/mainDNAStructureInfo --type I --typeOut C --profile A --outputName csv/test --inOrigin samples/smalldna.txt
  #esegui il comando
  ./DNAStructureInfo/mainDNAStructureInfo --type I --typeOut C --outputName csv/"${outputName}" --inOrigin samples/"${inOrigin}"
  pwd
}
run_program14() { #Aggiunta riga comparazione per i raw
  clear    # Passaggi per selezionare il file da samples e file_compressed
  echo "Seleziona un file dalla cartella samples/ o file_compressed/"

  # Elenco di tutti i file nella cartella samples e file_compressed
  files=($(find samples/ file_compressed/ -type f 2>/dev/null))

  if [ ${#files[@]} -gt 0 ]; then
      echo "File disponibili nelle cartelle samples/ e file_compressed/:"
      for i in "${!files[@]}"; do
          echo "$((i + 1)). ${files[$i]}"
      done

      # Chiedi all'utente di selezionare l'indice del file
      read -p "Inserisci l'indice del file da selezionare per inOrigin: " index
      inOrigin="${files[$((index-1))]}"

      if [ -z "$inOrigin" ]; then
          echo "Errore: Indice non valido."
          return 1
      fi

      read -p "Inserisci l'indice del file da selezionare per inComp: " index
      inComp="${files[$((index-1))]}"

      if [ -z "$inComp" ]; then
          echo "Errore: Indice non valido."
          return 1
      fi
  else
      echo "Nessun file trovato nelle cartelle samples/ o file_compressed/."
      return 1
  fi


  # Passaggi per selezionare il file .csv dalla cartella csv
  echo "Seleziona un file .csv dalla cartella csv/"

  # Elenco dei file .csv nella cartella csv
  files_csv=($(find csv/ -type f -name "*.csv" 2>/dev/null))

  if [ ${#files_csv[@]} -gt 0 ]; then
      echo "File disponibili nella cartella csv/:"
      for i in "${!files_csv[@]}"; do
          echo "$((i + 1)). ${files_csv[$i]}"
      done

      # Chiedi all'utente di selezionare l'indice del file
      read -p "Inserisci l'indice del file .csv da selezionare: " index
      outputName="${files_csv[$((index-1))]}"
      outputName=$(basename "$outputName" .csv)

      if [ -z "$outputName" ]; then
          echo "Errore: Indice non valido."
          return 1
      fi
  else
      echo "Nessun file .csv trovato nella cartella csv/."
      return 1
  fi

  # Se tutto è andato a buon fine, stampa OK
  echo "OK"
  echo "File inOrigin selezionato: $inOrigin"
  echo "File inComp selezionato: $inComp"
  echo "File outputName selezionato: $outputName"

  #esegui il comando con i percorsi completi
  ./DNAStructureInfo/mainDNAStructureInfo --type C --typeOut C --outputName csv/"${outputName}" --inOrigin "$inOrigin" --inComp "$inComp"
  pwd

}


run_program15() {

    # Funzione per stampare la lista di file CSV nella cartella csv/
    clear
    echo "Lista dei file CSV nella directory csv/:"
    if [ -d "csv" ]; then
      cd csv
      ls *.csv 2>/dev/null || echo "Nessun file CSV trovato."
      echo -n "Inserisci il nome completo del file CSV "
      read file_name
      if [ -f "$file_name" ]; then
          if [ -f "$file_name" ]; then
              # Rimuovi l'ultima riga
              head -n -1 "$file_name" > temp_file && mv temp_file "$file_name"
              echo "L'ultima riga del file $file è stata rimossa."
          else
              echo "Errore: il file $file non esiste."
          fi
      else
          echo "Errore: il file $file_name non esiste."
      fi
      cd -
    else
        echo "Errore. La directory 'csv/' non è stata trovata, riprovare."
    fi


}



## START -------------------------------------------------------------------------------------------------------------

# Controllo se i file sono stati installati
# Elenco delle cartelle da controllare
folders=("DNAStructureInfo" "EDS_GEN" "gsufsort" "EDS_GEN/edsToRaw" "EDS_GEN/stringCheck" )

# Ciclo per verificare se ogni cartella esiste
for folder in "${folders[@]}"; do
  if [ ! -d "$folder" ]; then
    echo "Errore: La cartella $folder non esiste. File mancanti"
    exit 1  # Ferma il programma con codice di errore 1
  fi
done



# Funzione principale
while true; do
  show_menu
  read -p "Inserisci il numero dell'opzione: " choice

  case $choice in
    1)
      run_program1
      ;;
    2)
      run_program2
      ;;
    3)
      run_program3
      ;;
    4)
      run_program4
      ;;
    5)
      run_program5
      ;;
    6)
      run_program6
      ;;
    7)
        pwd
        # Chiedi all'utente di inserire il nome della cartella
        echo "Inserisci il nome della cartella che vuoi visualizzare: {"samples", "file_compressed", "csv", "samples/ebwt"}"
        read folder_name

        # Chiamata alla funzione con il nome della cartella inserita
        run_program7 "$folder_name"    
        
      ;;
    8)
      clear
      run_program8
      ;;
    9)
      clear
      run_program9
      ;;
    10)
      run_program10
      ;;
    11)
      run_program11
      ;;
    12)
      run_program12
      ;;
    13)
      run_program13
      ;;
    14)
      run_program14
      ;;
    15)
      run_program15
      ;;
    15)
      run_program16
      ;;
    0)
      clear
      echo "Uscita..."
      exit 0
      ;;
    *)
      echo "Scelta non valida. Per favore inserisci un numero tra 0 e 11."
      ;;
  esac
done


