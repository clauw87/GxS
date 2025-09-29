For trait specific genesets plus databases see primate traits.

Here we analyse all traits the same, with the databases only.

Conditional analysis on background of all genes in corresponding database:
cat real/inputs/c5.go.bp.v2023.1.Hs.entrez.gmt | cut --complement  -f1,2 | tr '\n' '\t' > ./real/inputs/all_bp_genes.txt
Rscript ./real/scripts/u_genes.R bp ./real/inputs/all_bp_genes.txt 
cat real/inputs/all_unique_bp_genes.txt | grep -v NA | tr '\n' ' '  > ./real/inputs/bp_background.gmt




If we wanted to add the databases together, this step would be done once 
outside the main code
echo ' ' >> ./real/outputs/${TRAIT}.sets
cat ./real/inputs/c5.go.mf.v2023.1.Hs.entrez.gmt >> ./real/outputs/${TRAIT}.sets
echo ' ' >> ./real/inputs/${TRAIT}.sets
cat ./real/outputs/c5.go.bp.v2023.1.Hs.entrez.gmt >> ./real/outputs/${TRAIT}.sets
echo ' ' >> ./real/inputs/${TRAIT}.sets
cat ./real/outputs/c5.hpo.v2023.1.Hs.entrez.gmt >> ./real/outputs/${TRAIT}.sets
echo ' ' >> ./real/inputs/${TRAIT}.sets

