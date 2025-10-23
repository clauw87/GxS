import sys
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Load data
metadata_df = pd.read_csv('../../00-download/1-get_traitsinfo/real/outputs/joined_metadata_domains.txt', sep='\t')
gwama_matrix_df = pd.read_csv('real/outputs/across.mat', sep='\t', index_col=0)
clump_snps_df = pd.read_csv('real/outputs/joined/result.clump.snps.csv', sep='\t')

metadata_path = sys.argv[1]
gwama_matrix_path = sys.argv[2]
clump_snps_path = sys.argv[3]





# Prepare metadata
metadata_df['pair_m_f_normalized'] = metadata_df['pair_m_f'].str.replace(' ', ':')
metadata_with_domains = metadata_df[['pair_m_f_normalized', 'TYPE']].drop_duplicates()
metadata_with_domains.columns = ['pair_m_f', 'TYPE']

# Filter matrix
valid_pairs = set(metadata_with_domains['pair_m_f'])
filtered_gwama_matrix_df = gwama_matrix_df[gwama_matrix_df.index.isin(valid_pairs)]
filtered_gwama_matrix_df = filtered_gwama_matrix_df.loc[:, (filtered_gwama_matrix_df != 0).any(axis=0)]

# Melt and merge
melted = filtered_gwama_matrix_df.reset_index().melt(id_vars='index', var_name='SNP', value_name='Associated')
melted = melted[melted['Associated'] == 1]
melted = melted.rename(columns={'index': 'pair_m_f'})
melted = melted.merge(metadata_with_domains, on='pair_m_f')

# Add SNP coordinates
snp_coords = clump_snps_df[['CAND_SNP', 'CAND_BP']].drop_duplicates().rename(columns={'CAND_SNP': 'SNP', 'CAND_BP': 'BP'})
snp_chrs = clump_snps_df[['CAND_SNP', 'CHR']].drop_duplicates().rename(columns={'CAND_SNP': 'SNP'})
melted = melted.merge(snp_coords, on='SNP', how='left')
melted = melted.merge(snp_chrs, on='SNP', how='left')
melted = melted.dropna(subset=['BP'])

# Define index
melted['index'] = list(zip(melted['CHR'], melted['BP']))

# Identify SNPs with ≥2 domains
domain_counts_per_snp = melted.groupby('index')['TYPE'].nunique()
valid_multi_domain_indices = domain_counts_per_snp[domain_counts_per_snp >= 2].index
trait_multi_domain = melted[melted['index'].isin(valid_multi_domain_indices)]

# Define domain order and HTML colors
domain_order = ['Anatomical', 'Antropometric', 'Behavioural', 'Developmental',
                'Disease', 'Fertility', 'Metabolic', 'Trait']
domain_order_reversed = list(reversed(domain_order))

trait_colors_html = {
    'Anatomical': 'blue',
    'Antropometric': 'lightsteelblue',
    'Behavioural': 'orange',
    'Developmental': 'lightsalmon',
    'Disease': 'red',
    'Fertility': 'forestgreen',
    'Metabolic': 'wheat',
    'Trait': 'pink'
}

# Sort by reversed domain order
trait_multi_domain['TYPE'] = pd.Categorical(trait_multi_domain['TYPE'], categories=domain_order_reversed, ordered=True)
trait_multi_domain_sorted = trait_multi_domain.sort_values(by=['CHR', 'BP', 'TYPE'])

# Compute positions and colors
bar_positions_md = []
bar_colors_md = []

for idx, group in trait_multi_domain_sorted.groupby('index'):
    for i, row in enumerate(group.itertuples()):
        bar_positions_md.append((idx, i))
        bar_colors_md.append(trait_colors_html.get(row.TYPE, '#808080'))

md_indices = trait_multi_domain_sorted['index'].unique()
snp_to_x_md = {snp: i for i, snp in enumerate(sorted(md_indices))}
x_vals_md = [snp_to_x_md[idx] for idx, _ in bar_positions_md]
y_vals_md = [pos for _, pos in bar_positions_md]

# X-axis chromosome grouping
snp_chr_map_md = {idx: idx[0] for idx in md_indices}
chromosomes_md = [snp_chr_map_md[idx] for idx in sorted(md_indices)]
unique_chromosomes_md = sorted(set(chromosomes_md))

label_positions_md = []
label_names_md = []

for chrom in unique_chromosomes_md:
    indices = [i for i, c in enumerate(chromosomes_md) if c == chrom]
    if indices:
        label_positions_md.append(indices[len(indices) // 2])
        label_names_md.append(str(chrom))

# Plot
plt.figure(figsize=(16, 7))
ax = plt.gca()
ax.bar(x_vals_md, [1]*len(x_vals_md), bottom=y_vals_md, color=bar_colors_md, width=1.0)

ax.set_xticks(label_positions_md)
ax.set_xticklabels(label_names_md, rotation=0)
ax.set_xlabel("Chromosome")
ax.set_ylabel("Trait Stack Height (1 unit = 1 trait)")
ax.set_title("Trait Stacks for SNPs with ≥2 Domains (Reversed Domain Order, HTML Colors)")
ax.set_facecolor("white")
ax.figure.set_facecolor("white")

# Legend
used_domains_md = [d for d in domain_order_reversed if d in trait_multi_domain_sorted['TYPE'].unique()]
legend_handles = [plt.Rectangle((0, 0), 1, 1, color=trait_colors_html[d]) for d in used_domains_md]
ax.legend(legend_handles, used_domains_md, loc='upper right')

ax.set_ylim(0, max(y_vals_md) + 2)
ax.set_yticks(np.arange(0, max(y_vals_md) + 2, 1))
ax.yaxis.grid(True, linestyle='--', alpha=0.5)

plt.tight_layout()


# === Save plot as PDF ===
plt.savefig("./real/outputs/man_stacked_plot_more1domains.pdf", format="pdf")

