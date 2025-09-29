#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J convert_to_entrez
#SBATCH --mem 200G # memory pool for all cores
#SBATCH -t 0-05:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load R

# Config
JOBLIST=$1
GENESET=$2
RES_FOLDER=$3
OUTPUT_DIR=$4
POP=$5
MAGMA_FOLDER=$6

#GENESET=c5.go.mf.v2023.1.Hs.entrez.gmt

# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item corresponding to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  FILE=$(cat ${JOBLIST} | sed -n 1p | cut -d "/" -f7 )
  CODE=$(cat ${JOBLIST} | sed -n 1p | cut -d "/" -f7 | cut -d "." -f1)
  #TRAIT=$(cat ${JOBLIST} | sed -n 1p | cut -d" " -f1)
  #FILE=$(cat ${JOBLIST} | sed -n 1p | cut -d" " -f2)
  #CODE=$(basename ${FILE} | cut -d "." -f1)
  #POP=$(cat ${JOBLIST} | sed -n 1p | cut -d" " -f3)
else
  FILE=$(cat ${JOBLIST}  | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f1)
  CODE=$(cat ${JOBLIST} | sed -n ${SLURM_ARRAY_TASK_ID}p  | cut -d "/" -f7 | cut -d "." -f1)
  #TRAIT=$(cat ${JOBLIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f1)
  #FILE=$(cat ${JOBLIST}  | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f2)
  #CODE=$(basename ${FILE} | cut -d "." -f1)
  #POP=$(cat ${JOBLIST}  | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f3)
fi 



# Geneset analysis

# Load modules
module load zlib/1.2.11-GCCcore-11.2.0


MAGMA_FOLDER=/gpfs42/projects/lab_anavarro/disease_pleiotropies/tmp_claudia/magma
#GENE_RESULTS=../../2-gene-analysis/2-gene-analysis/real/outputs/${CODE}.gene.analysis
GENE_RESULTS=${RES_FOLDER}/${CODE}.gene.analysis

# if custom genesets and bg are added per trait
#GENESET_FILE=../1-create-inputs/real/outputs/${TRAIT}.geneset
#BACKGROUND_FILE=../1-create-inputs/real/outputs/${TRAIT}.background
#COVAR_FILE=./real/tmp/${TRAIT}.covar
#cat ${GENESET_FILE} | grep -v NA | tr '\n' ' ' > ./real/outputs/${TRAIT}.geneset
#cat ${BACKGROUND_FILE} | grep -v NA |  tr '\n' ' ' > ./real/outputs/${TRAIT}.background
# sets
#cat ${GENESET_FILE} | grep -v NA | tr '\n' ' ' > ./real/outputs/${TRAIT}.sets
#echo ' ' >> ./real/outputs/${TRAIT}.sets
#cat ${BACKGROUND_FILE} | grep -v NA |  tr '\n' ' ' >> ./real/outputs/${TRAIT}.sets

# adding pathways - done this once for not trait specific genesets and store it in inputs
#echo ' ' >> ./real/outputs/${TRAIT}.sets
#cat ./real/inputs/c5.go.mf.v2023.1.Hs.entrez.gmt >> ./real/outputs/${TRAIT}.sets
#echo ' ' >> ./real/inputs/${TRAIT}.sets
#cat ./real/outputs/c5.go.bp.v2023.1.Hs.entrez.gmt >> ./real/outputs/${TRAIT}.sets
#echo ' ' >> ./real/inputs/${TRAIT}.sets
#cat ./real/outputs/c5.hpo.v2023.1.Hs.entrez.gmt >> ./real/outputs/${TRAIT}.sets
#echo ' ' >> ./real/inputs/${TRAIT}.sets
#cat ./real/inputs/real/inputs/msigdb.v2023.2.Hs.symbols.gmt >> ./real/outputs/${TRAIT}.sets
#SETS_FILE=./real/outputs/${TRAIT}.sets


# in command or it will be rewritten 
#GENESETS_FILE=./real/inputs/${GENESET}
#BACKGROUND_FILE=./real/inputs/background_${GENESET}
#cat ${GENESETS_FILE}  > ./real/tmp/${GENESET}.sets
#cat ${BACKGROUND_FILE} >> ./real/tmp/${GENESET}.sets


SETS_FILE=./real/tmp/${GENESET}.sets

OUT=${OUTPUT_DIR}/${CODE}.geneset.analysis



COMMAND="${MAGMA_FOLDER}/magma --gene-results ${GENE_RESULTS}.genes.raw --set-annot ${SETS_FILE} --model analyse=sets condition=BACKGROUND direction=two-sided --out ${OUT}"




# This  command  will  produce  three  output  files:  step3a.gsa.out,  step3a.gsa.genes.out  and
# step3a.gsa.sets.genes.out.  The  step3a.gsa.out contains  the   analysis results for all the gene sets, and 
# has the following information: the name of the gene set (VARIABLE and FULL_NAME; the VARIABLE 
# column is a truncated version of the full name, this is intended to make the file easier to read when there 
# are very long variable names), the variable type (TYPE; in this case, all are gene set variables), the 
#number of genes included in the gene set for the analysis (NGENES), and the linear regression 
# parameters (BETA, BETA_STD, SE) and corresponding p-value (P). The BETA value is the actual model 
# parameter as discussed in the lecture (with SE its standard error). BETA_STD is a standardized 
# coefficient, dividing BETA by the standard deviation of the gene set (generally larger for larger gene 
# sets). This can be useful for comparing the effect size of different gene sets.



# multi-all Aggregate of linreg, snp-wise=mean and snp-wise=top
# Computes all three models for each gene, then combines the three p-values into an aggregate p-value
# only possible when loading SNP data


#removed
#--model condition
#--set-annot ${GENESET_FILE}
#--settings gene-include=${BACKGROUND_FILE} 


eval $COMMAND




#Modifiers gene-include
#and gene-exclude can be used to specify a file of gene IDs to either include in the analysis (discarding
#the rest) or to exclude from the analysis. 
