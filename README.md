# DNATestCompression
# Repository per la compressione di file EDS

Questo progetto è uno script bash che esegue una serie di operazioni per convertire file di tipo `.eds` in formato `.bwt`, comprimerli e infine analizzarli con `DNAStructureInfo`. È utile per coloro che lavorano con dati biologici e necessitano di strumenti per la gestione e l'analisi dei dati.

## Prerequisiti

Prima di eseguire lo script, assicurati di avere nella cartella corrente i seguenti progetti:

1. **[EDS-GEN](https://github.com/username/EDS-GEN)**: Questo programma serve per convertire file EDS in formato RAW.
2. **[DNAStructureInfo](https://github.com/username/DNAStructureInfo)**: Utilizzato per analizzare file BWT generati.
3. **[gsufsort](https://github.com/username/gsufsort)**: Serve a eseguire l'ordinamento BWT sui file RAW.

Inoltre, assicurati di avere installato i seguenti strumenti:

- **7-Zip**: Necessario per la compressione dei file.
- **Bash**: Per eseguire lo script.

## Utilizzo

1. **Clona la repository**:

   ```bash
   git clone https://github.com/tuo-username/nome-repository.git
   cd nome-repository
