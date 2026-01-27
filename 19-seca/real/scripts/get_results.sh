#!/bin/bash
#
#SBATCH -p haswell # haswell (queue)
#SBATCH -J SECAres
#SBATCH --mem 16G
#SBATCH -t 0-03:59 # time (D-HH:MM)
#SBATCH -o ./real/tmp/messages.log.%j.out # STDOUT
#SBATCH -e ./real/tmp/messages.log.%j.err # STDERR



DIR=$1

OUTPUT_DIR=./real/outputs_${DIR}


#RES_LS=$(ls real/outputs/*/*.SECA_results.txt)


RES_LS=$(ls ${OUTPUT_DIR}/*/*.SECA_results.txt | grep -f real/inputs/pairs.list)

#RES=real/outputs/a9f:r5f/a9f:r5f.SECA_results.txt
#CODE=$( echo $RES | xargs -I {} basename {} | cut -d '.' -f1)
# full results table
# primary concor
echo CODE NOM_CON_SNPS NOM_CON_SNPS_EMP_P NOM_VERBOSE MARG_CON_SNPS MARG_CON_SNPS_EMP_P MARG_VERBOSE  SMALLEST_CON_P_EMP_P > ${OUTPUT_DIR}/all.primary.concordant.effects
# primary overlap - pleio
echo CODE NOM_NUM_PLEIO_SUBSETS NOM_NUM_PLEIO_SUBSETS_EMP_P NOM_VERBOSE MARG_NUM_PLEIO_SUBSETS MARG_NUM_PLEIO_SUBSETS_EMP_P MARG_VERBOSE SMALLEST_PLEIO_P_EMP_P >  ${OUTPUT_DIR}/all.primary.overlap.assoc.effects
# directional overlap 
echo CODE D1D2NOM D1GWD2NOM D1SUGD2NOM D1D2MIN_BT_P D1D2MIN_FET_P > ${OUTPUT_DIR}/all.gen.overlap 
# directional alleles effect 
echo CODE D1D2OR D1D2ORPVAL D1GWD2OR D1GWD2PVAL D1SUGD2OR D1SUGD2PVAL D1D2MIN_BTOR D1D2MIN_BTPVAL D1D2MIN_FETOR D1D2MIN_FETPVAL > ${OUTPUT_DIR}/all.alleles.effect



for RES in ${RES_LS}

do

CODE=$( echo $RES | xargs -I {} basename {} | cut -d '.' -f1)

# primary test effects directions FISHER - concordant
NOM_CON_SNPS=$(	cat $RES | grep total | grep subsets | grep nominally | grep concordant | cut -d '=' -f4 | cut -d ' ' -f2)
NOM_CON_SNPS_EMP_P=$( cat $RES | grep empirical | grep subsets | grep nominally | grep concordant | cut -d '=' -f2 | cut -d ' ' -f2)
#NOM_VERBOSE=$(cat $RES | grep	subsets | grep nominally | grep concordant | grep expected | cut -d ' ' -f16)

if [ $(cat $RES | grep  subsets | grep nominally | grep concordant | grep expected | grep MORE | wc -l) == 1 ]
then
NOM_VERBOSE=MORE
fi

if [ $(cat $RES | grep  subsets | grep nominally | grep concordant | grep expected | grep LESS | wc -l) == 1 ]
then
NOM_VERBOSE=LESS
fi

if [ $(cat $RES | grep  subsets | grep nominally | grep concordant | grep expected | grep NOT | wc -l) == 1 ]
then
NOM_VERBOSE=NOT
fi

MARG_CON_SNPS=$( cat $RES | grep total | grep subsets | grep marginally | grep concordant | cut -d '=' -f4 | cut -d ' ' -f2)
MARG_CON_SNPS_EMP_P=$( cat $RES | grep empirical | grep subsets | grep marginally | grep concordant | cut -d '=' -f2 | cut -d ' ' -f2)
if [ $(cat $RES | grep	subsets | grep marginally | grep concordant | grep expected | grep MORE | wc -l) == 1 ]
then
MARG_VERBOSE=MORE
fi

if [ $(cat $RES | grep  subsets | grep marginally | grep concordant | grep expected | grep LESS | wc -l) == 1 ]
then
MARG_VERBOSE=LESS
fi

if [ $(cat $RES | grep  subsets | grep marginally | grep concordant | grep expected | grep NOT | wc -l) == 1 ]
then
MARG_VERBOSE=NOT
fi

SMALLEST_CON_P_EMP_P=$(cat $RES | grep empirical | grep smallest | grep concordant | cut -d '=' -f2 | cut -d ' ' -f2)

#echo CODE NOM_CON_SNPS NOM_CON_SNPS_EMP_P NOM_VERBOSE MARG_CON_SNPS MARG_CON_SNPS_EMP_P MARG_VERBOSE  SMALLEST_CON_P_EMP_P >  ${OUTPUT_DIR}/${CODE}.primary.concordant.effects
#echo $CODE $NOM_CON_SNPS $NOM_CON_SNPS_EMP_P $NOM_VERBOSE $MARG_CON_SNPS $MARG_CON_SNPS_EMP_P $MARG_VERBOSE $SMALLEST_CON_P_EMP_P >>  ${OUTPUT_DIR}/${CODE}.primary.concordant.effects
echo $CODE $NOM_CON_SNPS $NOM_CON_SNPS_EMP_P $NOM_VERBOSE $MARG_CON_SNPS $MARG_CON_SNPS_EMP_P $MARG_VERBOSE $SMALLEST_CON_P_EMP_P >> ${OUTPUT_DIR}/all.primary.concordant.effects



# primart test overlap assoc effects BINOMIAL- pleiotropy

NOM_NUM_PLEIO_SUBSETS=$( cat $RES | grep total | grep total | grep nominally | grep pleiotropy | cut -d '=' -f4 | cut -d ' ' -f2)
NOM_NUM_PLEIO_SUBSETS_EMP_P=$(cat $RES | grep empirical | grep subsets | grep nominally | grep pleiotropy | cut -d '=' -f2 | cut -d ' ' -f2)
#NOM_VERBOSE=$(cat $RES | grep subsets | grep nominally | grep pleiotropy | grep "*" | cut -d ' ' -f16)


if [ $(cat $RES | grep  subsets | grep nominally | grep pleiotropy | grep expected | grep MORE | wc -l) == 1 ]
then
NOM_VERBOSE=MORE
fi

if [ $(cat $RES | grep  subsets | grep nominally | grep pleiotropy | grep expected | grep LESS | wc -l) == 1 ]
then
NOM_VERBOSE=LESS
fi

if [ $(cat $RES | grep  subsets | grep nominally | grep pleiotropy | grep expected | grep NOT | wc -l) == 1 ]
then
NOM_VERBOSE=NOT
fi

MARG_NUM_PLEIO_SUBSETS=$( cat $RES | grep total | grep total | grep marginally | grep pleiotropy | cut -d '=' -f4 | cut -d ' ' -f2)
MARG_NUM_PLEIO_SUBSETS_EMP_P=$(cat $RES | grep empirical | grep subsets | grep marginally | grep pleiotropy | cut -d '=' -f2 | cut -d ' ' -f2)
#MARG_VERBOSE=$(cat $RES | grep subsets | grep marginally | grep pleiotropy | grep "*" | cut -d ' ' -f16)

if [ $(cat $RES | grep  subsets | grep marginally | grep pleiotropy | grep expected | grep MORE | wc -l) == 1 ]
then
MARG_VERBOSE=MORE
fi

if [ $(cat $RES | grep  subsets | grep marginally | grep pleiotropy | grep expected | grep LESS | wc -l) == 1 ]
then
MARG_VERBOSE=LESS
fi

if [ $(cat $RES | grep  subsets | grep marginally | grep pleiotropy | grep expected | grep NOT | wc -l) == 1 ]
then
MARG_VERBOSE=NOT 
fi

SMALLEST_PLEIO_P_EMP_P=$(cat $RES | grep empirical | grep smallest | grep pleiotropy | cut -d '=' -f2 | cut -d ' ' -f2)

#echo CODE NOM_NUM_PLEIO_SUBSETS NOM_NUM_PLEIO_SUBSETS_EMP_P NOM_VERBOSE MARG_NUM_PLEIO_SUBSETS MARG_NUM_PLEIO_SUBSETS_EMP_P MARG_VERBOSE SMALLEST_PLEIO_P_EMP_P >  ${OUTPUT_DIR}/${CODE}.primary.overlap.assoc.effects
#echo $CODE $NOM_NUM_PLEIO_SUBSETS $NOM_NUM_PLEIO_SUBSETS_EMP_P $NOM_VERBOSE $MARG_NUM_PLEIO_SUBSETS $MARG_NUM_PLEIO_SUBSETS_EMP_P $MARG_VERBOSE $SMALLEST_PLEIO_P_EMP_P  >>  ${OUTPUT_DIR}/${CODE}.primary.overlap.assoc.effects
echo $CODE $NOM_NUM_PLEIO_SUBSETS $NOM_NUM_PLEIO_SUBSETS_EMP_P $NOM_VERBOSE $MARG_NUM_PLEIO_SUBSETS $MARG_NUM_PLEIO_SUBSETS_EMP_P $MARG_VERBOSE $SMALLEST_PLEIO_P_EMP_P  >>  ${OUTPUT_DIR}/all.primary.overlap.assoc.effects


# One directional genetic overlap   - binomial test p-value
# bins
# P1 <= 0.05 and P2 <= 0.05
# SNPs with P1 <= 5e-08 and P2 <= 0.05
# SNPs with P1 <= 1e-05 and P2 <= 0.05
# SNPs with P1 <= 6e-04 and P2 <= 0.12
# SNPs with P1 <= 0.28 and P2 <= 0.38

D1D2NOM=$(cat $RES | grep Exact | grep binomial  | sed -n 1p  | cut -d ':' -f2 | cut -d ' ' -f2)
D1GWD2NOM=$(cat $RES | grep Exact | grep binomial  | sed -n 2p  | cut -d ':' -f2 | cut -d ' ' -f2)
D1SUGD2NOM=$(cat $RES | grep Exact | grep binomial  | sed -n 3p  | cut -d ':' -f2 | cut -d ' ' -f2)
D1D2MIN_BT_P=$(cat $RES | grep Exact | grep binomial  | sed -n 4p  | cut -d ':' -f2 | cut -d ' ' -f2)
D1D2MIN_FET_P=$(cat $RES | grep Exact | grep binomial  | sed -n 5p  | cut -d ':' -f2 | cut -d ' ' -f2)


#echo CODE D1D2NOM D1GWD2NOM D1SUGD2NOM D1D2MIN_BT_P D1D2MIN_FET_P > ${OUTPUT_DIR}/${CODE}.gen.overlap
#echo $CODE $D1D2NOM $D1GWD2NOM $D1SUGD2NOM $D1D2MIN_BT_P $D1D2MIN_FET_P >>  ${OUTPUT_DIR}/${CODE}.gen.overlap
echo $CODE $D1D2NOM $D1GWD2NOM $D1SUGD2NOM $D1D2MIN_BT_P $D1D2MIN_FET_P >>  ${OUTPUT_DIR}/all.gen.overlap



# One directional allele effects - FET
# bins
# SNPs with P1 <= 0.05 and P2 <= 0.05
# SNPs with P1 <= 5e-08 and P2 <= 0.05
# SNPs with P1 <= 1e-05 and P2 <= 0.05
# SNPs with P1 <= 6e-04 and P2 <= 0.12
# SNPs with P1 <= 0.28 and P2 <= 0.38



#echo OR PVAL  > ${OUTPUT_DIR}/${CODE}.alleles.effect

#NFETS=$(cat $RES | grep Fisher  | grep ":" | wc -l)
#for N in $(seq 1 $NFETS)
#do
#echo $N

D1D2OR=$(cat $RES | grep Odds  | sed -n 1p | cut -d ':' -f2 | cut -d ' ' -f2)
D1D2PVAL=$(cat $RES | grep Fisher | grep "p-value" | grep -v Tests | sed -n 1p | cut -d ':' -f2 | cut -d ' ' -f2)

D1GWD2OR=$(cat $RES | grep Odds  | sed -n 2p | cut -d ':' -f2 | cut -d ' ' -f2)
D1GWD2PVAL=$(cat $RES | grep Fisher | grep "p-value" | grep -v Tests  | sed -n 2p | cut -d ':' -f2 | cut -d ' ' -f2)

D1SUGD2OR=$(cat $RES | grep Odds  | sed -n 3p | cut -d ':' -f2 | cut -d ' ' -f2)
D1SUGD2PVAL=$(cat $RES | grep Fisher | grep "p-value" | grep -v Tests  | sed -n 3p | cut -d ':' -f2 | cut -d ' ' -f2)

D1D2MIN_BTOR=$(cat $RES | grep Odds  | sed -n 4p | cut -d ':' -f2 | cut -d ' ' -f2)
D1D2MIN_BTPVAL=$(cat $RES | grep Fisher | grep "p-value" | grep -v Tests  | sed -n 4p | cut -d ':' -f2 | cut -d ' ' -f2)

D1D2MIN_FETOR=$(cat $RES | grep Odds  | sed -n 5p | cut -d ':' -f2 | cut -d ' ' -f2)
D1D2MIN_FETPVAL=$(cat $RES | grep Fisher | grep "p-value" | grep -v Tests  | sed -n 5p | cut -d ':' -f2 | cut -d ' ' -f2)


#echo CODE D1D2OR D1D2ORPVAL D1GWD2OR D1GWD2PVAL D1SUGD2OR D1SUGD2PVAL D1D2MIN_BTOR D1D2MIN_BTPVAL D1D2MIN_FETOR D1D2MIN_FETPVAL > ${OUTPUT_DIR}/${CODE}.alleles.effect
#echo $CODE $D1D2OR $D1D2PVAL $D1GWD2OR $D1GWD2PVAL $D1SUGD2OR $D1SUGD2PVAL $D1D2MIN_BTOR $D1D2MIN_BTPVAL $D1D2MIN_FETOR $D1D2MIN_FETPVAL >> ${OUTPUT_DIR}/${CODE}.alleles.effect
echo $CODE $D1D2OR $D1D2PVAL $D1GWD2OR $D1GWD2PVAL $D1SUGD2OR $D1SUGD2PVAL $D1D2MIN_BTOR $D1D2MIN_BTPVAL $D1D2MIN_FETOR $D1D2MIN_FETPVAL >> ${OUTPUT_DIR}/all.alleles.effect


#done


done


