import os
import sys 
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from matplotlib.patches import Patch


outdir=sys.argv[1]
requested_only=sys.argv[2]
meta_file=sys.argv[3]
sig_level=sys.argv[4]



#df = pd.read_csv( outdir +'/' +'rg_intratrait_'  + sig_level + '.txt', sep = '\t')

df = pd.read_csv( outdir +'/' +'rg_intratrait' +'.txt', sep = '\t')

if  sig_level== 'nominal':
    df = df[df['rg1_p'] < 0.05]
elif sig_level=='fdr':
    df = df[df['rg1_p_adj'] < 0.05]



if requested_only:
    df = df[~df['pair_name'].str.contains('neales|elena', case=False, na=False)]


meta = pd.read_csv(meta_file, sep = '\t')

df = df.merge(
    meta[['sid','trait_name_clean']],  # ← Only these columns from right
    left_on='Trait1',
    right_on='sid',
    how='left'  # or 'inner', 'right', 'outer'
)


# FDR sig :create formatted trait names with asterisks
if  sig_level== 'nominal':
    df['trait_name_clean'] = df.apply(
        lambda row: f"*{row['trait_name_clean']}" if row['rg1_p_adj'] < 0.05 else row['trait_name_clean'], axis=1)


df['trait_name_clean'] = df['trait_name_clean'].str.split('/').str[0].str.strip()



n_traits=len(df)


df['diff'] = 1 - df['est']



# Create a y-axis position for each trait
y_pos = range(len(df))

# Sort by most different (lowest correlation) to most different (highest correlation)
df = df.sort_values(by='est', ascending=True)

# Calculate half of the length to plot in two columns.
half = n_traits//2 # we use two bars to make the result an even number.






# plot correlation m-f -------------------------------------------------------------------------------
# Legend
# Customized legend
null_color="#F0E6E4"
#fill_color="orange"
fill_color="#baf4f7"


legend_elements = [
    Patch(facecolor=fill_color, label='Genetic correlation'),
    Patch(facecolor=null_color, label='Difference from 1')
]


# Calculate dynamic width based on number of categories
#base_width = 8  # Minimum width
#width_per_category = 0.25  # Width per category
#dynamic_width = max(base_width, n_traits * width_per_category)

# Set up the plot for the correlations (single bar per trait)
# Create subplots with 2 rows and 1 column
fig, axes = plt.subplots(nrows=1, ncols=2, figsize=(12, n_traits * 0.25))
# Adjust space between the two columns
fig.subplots_adjust(wspace=1.3)  # Adjust vertical spacing
# Add a common title
fig.suptitle('Correlation between Female and Male Genetic Correlation (rg) Estimates', fontsize=14, fontweight='bold', y=1.02)  # Adjust title position
# Plot first half of the data -----------
#  Plot the correlation
axes[0].barh(y_pos[:half], df['est'][:half], color=fill_color, align='center', edgecolor='black')
# Plot the difference stacked / 'gray' or F0E6E4
axes[0].barh(y_pos[:half], df['diff'][:half], left = df['est'][:half], color=null_color, align='center', edgecolor='black')
axes[0].set_yticks(y_pos[:half])
axes[0].set_yticklabels(df['trait_name_clean'][:half], fontsize=12)
# dash line
axes[0].grid(axis='x', linestyle='--', alpha=0.5) 
axes[0].set_xlim(0, 1)  # Set x-axis to be between 0 and 1
axes[0].invert_yaxis()  # Keep the order the same as df
# Remove the spines on the left and right
axes[0].spines['top'].set_visible(False)
axes[0].spines['bottom'].set_visible(False)
# Adjust the right spine (coincides with 1)
axes[0].spines['right'].set_linestyle((0, (5, 5)))  # Dotted line
axes[0].spines['right'].set_linewidth(0.4)  # Adjust thickness
axes[0].spines['right'].set_color('grey')  # Adjust color if needed
# Plot the second half of the data -----------
# Plot the correlation
axes[1].barh(y_pos[half:], df['est'][half:], color=fill_color, align='center', edgecolor='black')
# Plot the difference stacked
axes[1].barh(y_pos[half:], df['diff'][half:], left = df['est'][half:], color=null_color, align='center', edgecolor='black')
axes[1].set_yticks(y_pos[half:])
axes[1].set_yticklabels(df['trait_name_clean'][half:], fontsize=12)
axes[1].grid(axis='x', linestyle='--', alpha=0.5)
axes[1].set_xlim(0, 1)  # Set x-axis to be between 0 and 1
axes[1].invert_yaxis()  # Keep the order the same as original
# Remove the spines on the left and right
axes[1].spines['top'].set_visible(False)
axes[1].spines['bottom'].set_visible(False)
# Adjust the right spine (1)
axes[1].spines['right'].set_linestyle((0, (5, 5)))  # Dotted line
axes[1].spines['right'].set_linewidth(0.4)  # Adjust thickness
axes[1].spines['right'].set_color('grey')  # Adjust color if needed


fig.legend(handles=legend_elements, bbox_to_anchor=(0.1, 1), fontsize=12)
#fig.legend(handles=legend_elements, bbox_to_anchor=(1.05, 1), loc='upper left', fontsize=12)

# Set common x-axis label
fig.text(0.5, 0.04, 'Male-Female Genetic Correlation (rg m-f)', ha='center', fontsize=12)


plt.savefig(
    outdir + "/" + 'diff.rg1.stacked.' + sig_level + '.pdf',
    dpi=300,
    bbox_inches='tight',
    facecolor='white',
    edgecolor='none',
    transparent=False
)





# Plot difference from 1 ------------------------------------------------------------------------
# Set up the plot for the correlations (single bar per trait)
diff_color='orange'
# Create subplots with 2 rows and 1 column
fig, axes = plt.subplots(nrows=1, ncols=2, figsize=(12, n_traits * 0.25))
# Adjust space between the two columns
fig.subplots_adjust(wspace=1.3)  # Adjust vertical spacing

# Add a common title
fig.suptitle('Difference from 1 in Genetic Correlation\nbetween Female and Male', fontsize=14, fontweight='bold', y=1.02)  # Adjust title position

# First half of the data
axes[0].barh(y_pos[:half], df['diff'][:half], color=diff_color, align='center', edgecolor='black')
axes[0].set_yticks(y_pos[:half])
axes[0].set_yticklabels(df['trait_name_clean'][:half], fontsize=12)
# dash line
axes[0].grid(axis='x', linestyle='--', alpha=0.5)
axes[0].set_xlim(0, 1)  # Set x-axis to be between 0 and 1
axes[0].invert_yaxis()  # Keep the order the same as origin
# Remove the spines on the left and right
axes[0].spines['top'].set_visible(False)
axes[0].spines['bottom'].set_visible(False)
# Adjust the right spine (coincides with 1)
axes[0].spines['right'].set_linestyle((0, (5, 5)))  # Dotted line
axes[0].spines['right'].set_linewidth(0.4)  # Adjust thickness
axes[0].spines['right'].set_color('grey')  # Adjust color if needed
# Second half of the data
axes[1].barh(y_pos[half:], df['diff'][half:], color=diff_color, align='center', edgecolor='black')
axes[1].set_yticks(y_pos[half:])
axes[1].set_yticklabels(df['trait_name_clean'][half:], fontsize=12)
axes[1].grid(axis='x', linestyle='--', alpha=0.5)
axes[1].set_xlim(0, 1)  # Set x-axis to be between 0 and 1
axes[1].invert_yaxis()  # Keep the order the same as df
# Remove the spines on the left and right
axes[1].spines['top'].set_visible(False)
axes[1].spines['bottom'].set_visible(False)
# Adjust the right spine (1)
axes[1].spines['right'].set_linestyle((0, (5, 5)))  # Dotted line
axes[1].spines['right'].set_linewidth(0.4)  # Adjust thickness
axes[1].spines['right'].set_color('grey')  # Adjust color if needed


# Set common x-axis label
#fig.text(0.5, 0.04, 'Difference', ha='center', fontsize=12)


plt.savefig(
    outdir + "/" + 'diff.rg1.diff1.' + sig_level + '.pdf',
    dpi=300,
    bbox_inches='tight',
    facecolor='white',
    edgecolor='none',
    transparent=False
)






