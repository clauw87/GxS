import sys
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np


filename = sys.argv[1]


# Load the data
#df = pd.read_csv("./real/outputs/joined.clump", sep=" ")

df = pd.read_csv(filename, sep=" ")



# Convert chromosomes to string for consistency and sort them
df['CHR'] = df['CHR'].astype(str)
df = df.sort_values(['CHR', 'LEAD_BP'])

# Create a cumulative base pair position for plotting
df['chr_num'] = df['CHR'].astype('category').cat.codes
df['ind'] = range(len(df))
df['logp'] = -np.log10(df['pplaco'])

# Prepare color and marker shapes
markers = ['o', 's', '^', 'D', 'P', '*', 'X', 'v', '>', '<', 'H']
traits = df['CODE'].unique()
marker_dict = {trait: markers[i % len(markers)] for i, trait in enumerate(traits)}

# Plotting
plt.figure(figsize=(14, 6))

for trait in traits:
    subset = df[df['CODE'] == trait]
    plt.scatter(subset['ind'], subset['logp'],
                marker=marker_dict[trait],
                label=trait, alpha=0.7)

# Add axis formatting
plt.xticks([])
plt.xlabel("Genomic Position")
plt.ylabel("-log10(p-value)")
plt.title("Manhattan Plot with Trait-specific Point Shapes")
plt.legend(title="GWAS Trait (CODE)", bbox_to_anchor=(1.05, 1), loc='upper left')
plt.tight_layout()
#plt.show()
plt.savefig("./real/outputs/manhattan_plot.pdf", format="pdf", bbox_inches="tight")

