import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import RobustScaler
from sklearn.mixture import GaussianMixture
from sklearn.metrics import adjusted_rand_score
from sklearn.utils import resample
from statsmodels.stats.multitest import multipletests


# Data:  indep SNPs and their metrics and cases statuses
Xdf = pd.read_csv(
    "/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/21-selection/21-selection/3-create-plink-cases/real/outputs/allcases.indep.test.df.tsv",
    sep="\t"
)




# Features
Xdf["abs_standarizediHS"] = Xdf["standarizediHS"].abs()
Xdf["abs_SDS"] = Xdf["SDS"].abs()
Xdf["CHR"] = Xdf["CHR.x"]
Xdf["BP"] = Xdf["BP.x"]

features = ["abs_standarizediHS","abs_SDS","Beta2_std"]

model_name = "abs3"

class_columns = [f"case{i}_status" for i in range(0, 7)]



# Scaling
X = Xdf[features].copy()
scaler = RobustScaler()
X_scaled = pd.DataFrame(
scaler.fit_transform(X),
columns=features,
index=X.index
)



# GMM model selection
covariance_types = ["full", "tied", "diag", "spherical"]
n_components = range(2, 11)

results = []

for cov in covariance_types:
    for k in n_components:
        gmm = GaussianMixture(n_components=k,covariance_type=cov,random_state=42)
        gmm.fit(X_scaled)
        results.append({"covariance_type": cov,"k": k,"BIC": gmm.bic(X_scaled),"AIC": gmm.aic(X_scaled)})

model_selection_df = pd.DataFrame(results)

## plot model selection
plt.figure(figsize=(10, 6))
sns.lineplot(data=model_selection_df,x="k", y="BIC", hue="covariance_type", marker="o")
plt.title("GMM Model Selection via BIC")
plt.ylabel("BIC (lower = better)")
plt.tight_layout()
plt.show()


# using model with lowest BIC or genomics choice, "diag" (avoids overfitting, more predictable, stable clusters)

# GMM fitting
best = model_selection_df.loc[model_selection_df["BIC"].idxmin()]
optimal_k = int(best["k"])
best_cov = best["covariance_type"]

# best_cov="diag"
# optimal_k=5 # elbow by eye

gmm = GaussianMixture(n_components=optimal_k,covariance_type=best_cov,random_state=42)

#clusters = gmm.fit_predict(X_scaled)
clusters = pd.Series(
    gmm.fit_predict(X_scaled),
    index=X_scaled.index,
    name="cluster_gmm"
)
Xdf["cluster_gmm"] = clusters



# Assess cluster stability (boostrap ARI)

ari_scores = []

for i in range(50):
    X_resampled = resample(X_scaled, replace=True, random_state=i)
    labels_resampled = gmm.fit_predict(X_resampled)
    ari = adjusted_rand_score(
        clusters.loc[X_resampled.index],
        labels_resampled
    )
    ari_scores.append(ari)


print(f"Mean ARI (stability): {np.mean(ari_scores):.3f}")




# Feature x cluster plots
sns.set(style="whitegrid", context="paper")

fig, axes = plt.subplots(
    nrows=2, ncols=2, figsize=(12, 8), sharex=True
)

for ax, feature in zip(axes.flat, features):
    sns.violinplot(
        data=Xdf, x="cluster_gmm", y=feature,
        inner="quartile", ax=ax
    )
    ax.axhline(0, color="black", linestyle="--", linewidth=0.8)
    ax.set_title(feature)

plt.tight_layout()
plt.savefig(f"cluster_feature_violin_{model_name}.png", dpi=300)
plt.show()



# Permutation-based enrichment

def permutation_enrichment(
    df, cluster_col, class_col,
    cluster_id, n_perm=10000
):
    in_cluster = df[cluster_col] == cluster_id
    observed = df.loc[in_cluster, class_col].mean()

    permuted = []
    for _ in range(n_perm):
        perm = np.random.permutation(df[class_col])
        permuted.append(perm[in_cluster.values].mean())

    permuted = np.array(permuted)

    p_enriched = np.mean(permuted >= observed)
    p_depleted = np.mean(permuted <= observed)

    return observed, permuted.mean(), p_enriched, p_depleted

## run enrichment
results = []

for cluster_id in range(optimal_k):
    for cls in class_columns:
        obs, exp, p_enr, p_dep = permutation_enrichment(
            Xdf, "cluster_gmm", cls, cluster_id
        )

        if obs > exp:
            status = "ENRICHED"
            pval = p_enr
        else:
            status = "DEPLETED"
            pval = p_dep

        results.append({
            "Cluster": cluster_id,
            "SNP_Class": cls,
            "Observed": obs,
            "Expected": exp,
            "Fold_Enrichment": obs / exp if exp > 0 else np.nan,
            "P_value": pval,
            "Status": status
        })

enrichment_df = pd.DataFrame(results)

## multiple testing correction
rej, p_fdr, _, _ = multipletests(
    enrichment_df["P_value"],
    method="fdr_bh"
)

enrichment_df["P_value_FDR"] = p_fdr
enrichment_df["Significant"] = rej


## heatmap
heat = enrichment_df.pivot(
    index="SNP_Class", columns="Cluster", values="Fold_Enrichment"
)

signif = enrichment_df.pivot(
    index="SNP_Class", columns="Cluster", values="Significant"
).fillna(False)

plt.figure(figsize=(10, 6))
sns.heatmap(
    np.log2(heat),
    mask=~signif,
    cmap="RdBu_r",
    center=0,
    annot=heat.round(2),
    fmt=""
)
plt.title("Permutation-based SNP Class Enrichment (log2 FE)")
plt.tight_layout()
plt.savefig(f"enrichment_heatmap_{model_name}.png", dpi=300)
plt.show()



