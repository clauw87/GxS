import os
import sys
import pandas as pd
import csv
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from matplotlib.patches import Patch
import textwrap


res_sb=sys.argv[1]
outdir=sys.argv[2]
sig_level=sys.argv[3]
meta_file=sys.argv[4]



df = pd.read_csv(res_sb, sep = '\t')
df = df.sort_values(by='Total Sex-Differential Loci', ascending=False).reset_index(drop=True)


# Names from meta trait_name_clean
meta = pd.read_csv(meta_file, sep = '\t')
# Clean up trait names - remove "Diagnoses - main ICD10: " and following 3 characters + space
#df['trait_name_clean'] = df['trait_name'].str.replace('Diagnoses - main ICD10: \w{3} ', '', regex=True)
# df['trait_name_clean']  already, from meta
df = df.merge(
    meta[['uniqValue','trait_name_clean']],  # ← Only these columns from right
    left_on='Trait',
    right_on='uniqValue',
    how='left'  # or 'inner', 'right', 'outer'
)
df = df.drop_duplicates()
# df['Trait'] = df['Trait'].str.replace(r'^Diagnoses - main ICD10:\s*\S+\s*|\s\([^\)]*\)\s(\d+|NA)$', '', regex=True)


# Function to split long lines
def split_long_trait(trait, max_words=6):
    words = trait.split()  # Split the sentence into words
    if len(words) >= max_words:
        # Find a good place to split (e.g., 3-2 for five words, 4-3 for seven, etc.)
        mid = len(words) // 2  # Split roughly in the middle
        return '\n'.join([' '.join(words[:mid]), ' '.join(words[mid:])])
    return trait  # Return unchanged if < max_words



# Apply function to 'TRAIT' column
df['Trait_Name'] = df['trait_name_clean'].apply(split_long_trait)



width = 0.7 # Bar width
y_pos = range(len(df))
#opp_color = '#6c20bd'
opp_color = '#FFFF00' # yellow
opp_contrast = 'white'
#same_color = '#20bd6a'
same_color = '#5a5d63'
same_contrast = 'black'

# Split into parts
num_sections = 3
rows_per_section = len(df) // num_sections
df_splits = [df.iloc[i * rows_per_section: (i + 1) * rows_per_section] for i in range(num_sections - 1)]
df_splits.append(df.iloc[(num_sections - 1) * rows_per_section:]) # add the remaining rows if there are


# Calculate the x-range for each subset, this being the maximum of each subset
xmaxs = [ (subset['Total Sex-Differential Loci']).max() for subset in df_splits ]

# Calculate the total width of the four datasets
total_width = sum(xmaxs)


# Pre-determiend width of each plot, change this to the best visualization.
widths = [15, 2, 1] # The first phenotypes have much more sex-differential SNPs.

# Customized legend
legend_elements = [
    #Patch(facecolor=opp_color, label='SNPs with Differential Effects\nin Opposite Direction'),
    #Patch(facecolor=same_color, label='SNPs with Differential Effects\nin the Same Direction')
    Patch(facecolor=opp_color, label='Opposite Direction Effects'),
    Patch(facecolor=same_color, label='Same Direction Effects')
]


# Create plot ---
# Set up the plot
fig, axes = plt.subplots(1, num_sections, figsize=(total_width*0.17, len(df_splits[0])*0.55), # These two first varaibles control the horizontal and vertical lengths
                         gridspec_kw={'width_ratios': widths}) # Adjusting width ratios to the total x in each subplot
# Adjust space between the two columns
fig.subplots_adjust(wspace=2)  # Adjust vertical spacing

for i, (df_subset, ax, xmax) in enumerate(zip(df_splits, axes.flatten(), xmaxs)):
    # Reset index so `j` matches y_pos correctly
    df_subset = df_subset.reset_index(drop=True)
    # Calculate y positions on the subset
    y_pos = range(len(df_subset))
    # Plot opposite counts
    ax.barh(y_pos, df_subset['Opposite Direction'], height=width, color=opp_color, label='SNPs with Differerential Effects\nin Opposite Direction')
    # Plot same counts
    ax.barh(y_pos, df_subset['Same Direction'], left=df_subset['Opposite Direction'], height=width, color=same_color, label='SNPs with Differential Effects\nin the Same Direction')
    # Annotate counts, if not 0
    for j, row in df_subset.iterrows():
        # Annotate for Opposite Direction (left bars)
        if row['Opposite Direction'] != 0:
            ax.text(row['Opposite Direction'] / 2, y_pos[j],  # Adjust position to the middle of the bar
                    f"{row['Opposite Direction']}",
                    va='center', ha='center', fontsize=11, color=same_contrast)
        #Annotate for Same Direction (right bars)
        if row['Same Direction'] != 0:
            ax.text(row['Opposite Direction'] + row['Same Direction'] / 2, y_pos[j],  # Adjust to middle of stacked section
                    f"{row['Same Direction']}",
                    va='center', ha='center', fontsize=11, color=opp_contrast)
    # Make axis the same as in the df
    ax.invert_yaxis()
    # Set y labels
    ax.set_yticks(y_pos)
    ax.set_yticklabels(df_subset['Trait_Name'], fontsize=11)
    # Set labels
    if i == 0:
        ax.set_xlabel("SNP Count", fontsize=12)
    else:
        ax.set_xlabel("Count")
    # Draw a horizontal line at y=0
    ax.axvline(0, color='black', linewidth=0.8)
    # Remove top and side borders
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.margins(y=0.01)
    # Set the x-axis limit for this subplot to match its data range.
    ax.set_xlim(0, xmax)


# Add a single legend outside the subplots
fig.legend(handles=legend_elements, fontsize=12, bbox_to_anchor=(0.13, 0.95))  # Moves legend outside the right edge

# Add a title
fig.suptitle('Proportions of Sex-Differential Loci per Phenotype', fontsize=16)

# Adjust layout and display the plot
plt.tight_layout()

#plt.show()



plt.savefig(
    outdir + "/" + 'diff.beta.' + sig_level + '.pdf',
    dpi=300,
    bbox_inches='tight',
    facecolor='white',
    edgecolor='none',
    transparent=False
)
