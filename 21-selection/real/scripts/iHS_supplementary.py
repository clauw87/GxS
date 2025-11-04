#!/usr/bin/python3
# -*- coding: utf-8 -*-

__author__: str = "Eva Brigos Barril"
__version__: str = "2025/04/09 15:39"  # YYYY/MM/DD HH:MM
__email__: str = "eva.brigos@upf.edu"

import pandas as pd
import math
import sys


# CONFIGURATION
# Inputs:

input_pleiotropies: str = sys.argv[2]  # Formatted peioFDR Results
input_selection: str = sys.argv[3]
selection_test: str = sys.argv[4]
input_ancestral: str = sys.argv[5]
target_phenotype: str = sys.argv[6]
zscore_colname: str = sys.argv[7]
# Outputs:
output: str = sys.argv[8]


# DATAFRAME OBJECTS
# 1. Create DataFrames
pleiotropies = pd.read_csv(input_pleiotropies, sep=',')
selection = pd.read_csv(input_selection, sep='\t')
alleles = pd.read_csv(input_ancestral, sep='\t')


# 2. Rename Columns to Enable Merging
alleles = alleles.rename(columns={"RSID": "rsid"})
subset_selection = selection[['rsid', 'standarizediHS']]


# 3. Create New DataFrames With Subset of Columns
#subset_pleiotropies = pleiotropies[['TargetTrait', 'DiseaseTrait', 'rsid', 'A1', 'A2', 'Zscore_Disease',
#                                    'Zscore_TargetTrait', 'conjFDR', 'PleiotropySign', 'RiskAllele']]
subset_pleiotropies = pleiotropies
subset_pleiotropies = subset_pleiotropies.rename(columns={"LEAD_SNP": "rsid", 'A2': 'RiskAllele'})


# 4. Merge DataFrames
merge = subset_pleiotropies.merge(subset_selection, on=['rsid'])
merge2 = merge.merge(alleles, on=['rsid'])
#all_combined = merge2.merge(diseaseOnset, on=['DiseaseTrait'])
all_combined = merge2

# 5. Add log10 of pdiff (or conjFDR or placop for pleiotropy)
all_combined['log10conjFDR'] = [-(math.log10(x)) for x in all_combined['conjFDR']]


# iHS VALUE FOR DISEASE-RISK ALLELE
# Add Correct iHS Value For Ancestral or Derived Allele based on allele we target
# PopHuman has an iHS ratio of Derived/Ancestral!
# Centred on the Disease-Risk Allele:
for index, row in all_combined.iterrows():
    if row['Zscore_Disease'] > 0:
        disease_allele = row['A1']
    else:
        disease_allele = row['A2']
    if disease_allele != row['ANCESTRAL_ALLELE']:
        iHS_real_value = row['standarizediHS']
        all_combined.at[index, 'CorrectediHS_DiseaseCentered'] = iHS_real_value
    else:
        iHS_real_value = row['standarizediHS'] * (-1)
        all_combined.at[index, 'CorrectediHS_DiseaseCentered'] = iHS_real_value

# iHS value for longevity increasing allele
for index, row in all_combined.iterrows():
    if row['Zscore_TargetTrait'] > 0:
        increasing_allele = row['A1']
    else:
        increasing_allele = row['A2']
    if increasing_allele != row['ANCESTRAL_ALLELE']:
        iHS_targeted_value = row['standarizediHS']
        all_combined.at[index, 'LongevityIncreasing_iHS'] = iHS_targeted_value
    else:
        iHS_targeted_value = row['standarizediHS'] * (-1)
        all_combined.at[index, 'LongevityIncreasing_iHS'] = iHS_targeted_value

# Rename
all_combined_mod = all_combined.rename(columns={'ANCESTRAL_ALLELE': 'AncestralAllele(AA)',
                                                'CorrectediHS_DiseaseCentered': 'RiskAllele_iHS'})

supplem = all_combined_mod[['TargetTrait', 'DiseaseTrait', 'rsid', 'A1', 'A2', 'Zscore_Disease', 'Zscore_TargetTrait',
                            'conjFDR', 'log10conjFDR', 'PleiotropySign', 'RiskAllele', 'AncestralAllele(AA)',
                            'standarizediHS', 'RiskAllele_iHS', 'LongevityIncreasing_iHS']]

# Save
supplem.to_csv(output, sep='\t', index=False)
