import sys
import pandas as pd
import numpy as np
from scipy.stats import norm
from statsmodels.stats.multitest import multipletests


# generate traitsInfoLDSC for reformatting with Intercept correction

inputFile = sys.argv[1]
metaFile = sys.argv[2]
inInfo='/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01-format/real/inputs/traitsInfo.tsv'
outInfo = './real/outputs/traitsInfoLDSC.tsv'
outInfoMeta = './real/outputs/traitsInfoLDSCMeta.tsv'
output_dir = "./real/outputs"


h2=pd.read_csv(inputFile, sep="\t")
traitsInfo = pd.read_csv(inInfo, sep="\t")
traitsInfoLDSC  =  pd.merge(traitsInfo, h2, left_on='id', right_on='Trait', how='inner')
traitsInfoLDSC.to_csv(outInfo, sep="\t", index=False)


# To get Nca and Nco
meta=pd.read_csv(metaFile, sep="\t")
traitsInfoLDSC_meta= pd.merge(traitsInfo,meta, left_on="id", right_on="sid", how='inner')
traitsInfoLDSC_meta.to_csv(outInfoMeta, sep="\t", index=False)
