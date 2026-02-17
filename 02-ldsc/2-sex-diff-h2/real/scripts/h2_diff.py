import sys
import os
import pandas as pd
import csv
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import matplotlib.gridspec as gridspec


h2_compare=sys.argv[1]
outdir=sys.argv[2]
sig_level=sys.argv[3]
meta_file=sys.argv[4]

#   meta_file='../../joined_metadata_domain_updated.txt'


df = pd.read_csv(h2_compare, sep = '\t')

meta = pd.read_csv(meta_file, sep = '\t')
# Clean up trait names - remove "Diagnoses - main ICD10: " and following 3 characters + space
#df['trait_name_clean'] = df['trait_name'].str.replace('Diagnoses - main ICD10: \w{3} ', '', regex=True)
# df['trait_name_clean']  already, from meta
df = df.merge(
    meta[['sid','trait_name_clean']],  # ← Only these columns from right
    left_on='m_sid',
    right_on='sid',
    how='left'  # or 'inner', 'right', 'outer'
)




# Sig differences
if sig_level=='fdr':
    df = df[df['p_diff_adj'] < 0.05]
elif sig_level=='nominal':
    df = df[df['p_diff'] < 0.05]

# absolute value of h2 sex differences
#df.loc[:, 'diff'] = abs(df['m_est'] - df['f_est'])
# sort by diff
#df = df.sort_values(by='diff', ascending=False)
# abs value of diff test statistic
# sort by stat
df.loc[:, 'abs_stat'] = abs(df['stat'])
df = df.sort_values(by='abs_stat', ascending=False)


# Diverging colors for each sex
m_color = "#3F7FDB"    # blue
f_color = "#fa6db4"  # pink

# Create a y-axis position for each trait
y_pos_sig = range(len(df))
y_pos_sig_np = np.arange(len(df))  # Convert to numpy array for easier manipulation


# Bar height
bar_width = 0.35

# Create a new column for the female estimate multiplied by -1
# df['f_est_neg'] = -df['f_est']
# male on the left instead
df['m_est_neg'] = -df['m_est']

# Create a y-axis position for each trait
y_pos = range(len(df))

# Set up the plot
fig, ax = plt.subplots(figsize=(10, len(df)*0.35))

# Plot the female estimates (to the right) with error bars
bars_f =ax.barh(y_pos, df['f_est'],
        xerr=df['f_est_se'],
        capsize=3,  # Adds caps to the error bars
        color=f_color,
        align='center',
        label='Female')

# Plot the male estimates (to the left, negative values) with error bars
bars_m = ax.barh(y_pos, df['m_est_neg'],
        xerr=df['m_est_se'],
        capsize=3,
        color=m_color,
        align='center',
        label='Male')



#if sig_level=='nominal':
#    for i, (y, pval) in enumerate(zip(y_pos, df['p_diff'])):
#        if pval < 0.05:
#            # Position asterisk to the left of the y-axis labels
#            ax.text(-1.65, y, '*', ha='center', va='center', 
#                 fontsize=12, fontweight='bold', color='red')

# Add asterisks to the left of trait names for significant differences (using p_diff)
if sig_level=='nominal':
    sig_labels = []
    for trait, pval in zip(df['trait_name_clean'], df['p_diff_adj']):
        if pval < 0.05:
            sig_labels.append(f"*{trait}")
        else:
            sig_labels.append(f" {trait}")  # Space for alignment
    ax.set_yticks(y_pos)
    ax.set_yticklabels(sig_labels)
else:
    ax.set_yticks(y_pos)
    ax.set_yticklabels(df['trait_name_clean'])



# Add a vertical line at zero
ax.axvline(x=0, color='black', linewidth=0.8)

# Set y-axis labels using trait names
#ax.set_yticks(y_pos)
#ax.set_yticklabels(df['trait_name_clean'])

# Add labels and title
ax.set_xlabel('SNP Heritability (SNP h2) Estimate')
ax.set_title('Heritability by Sex')

# Add horizontal grid lines for better visualization
ax.grid(axis='y', linestyle='--', alpha=0.7)

# Add legend
#ax.legend()
ax.legend([bars_m, bars_f], ['Male', 'Female'])

# Adjust the y-axis to remove extra space at the ends
plt.ylim(len(y_pos) - 0.5, -0.5)  # Adjust y-axis limits

# Adjust the x-axis
plt.xlim(-0.6, 0.6)  # Adjust x-axis limits



# Format x-axis to show all positive numbers, one decimal point
def format_abs_value(x, pos):
    return f'{abs(x):.1f}'

ax.xaxis.set_major_formatter(plt.FuncFormatter(format_abs_value))


plt.tight_layout()
#plt.show()

plt.savefig(
    outdir + "/" + 'diff.m-f.' + sig_level + '.pdf',
    dpi=300,
    bbox_inches='tight',
    facecolor='white',
    edgecolor='none',
    transparent=False
)


