# DNATestCompression
# Repository per la compressione di file EDS

Questo progetto è uno script bash che esegue una serie di operazioni per convertire file di tipo `.eds` in formato `.bwt`, comprimerli e infine analizzarli con `DNAStructureInfo`. È utile per coloro che lavorano con dati biologici e necessitano di strumenti per la gestione e l'analisi dei dati.

## Prerequisiti

Prima di eseguire lo script, assicurati di avere nella cartella corrente i seguenti progetti:

1. **[EDS-GEN](https://github.com/dadaynamo/EDS_GEN.git)**: Questo programma serve per generare file in formato Raw e Eds.
2. **[DNAStructureInfo](https://github.com/dadaynamo/DNAStructureInfo.git)**: Utilizzato per analizzare file BWT generati.
3. **[gsufsort](https://github.com/felipelouza/gsufsort.git)**: Serve a eseguire l'ordinamento BWT sui file RAW.

Inoltre, assicurati di avere installato i seguenti strumenti:

- **7-Zip**: Necessario per la compressione dei file.
- **Bash**: Per eseguire lo script.

## Utilizzo

1. **Avvia l'installazione**:

   ```bash
   ./install.sh
