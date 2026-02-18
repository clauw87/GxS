library(data.table)
library(dplyr)


intra <- fread("./real/outputs/rg_intratrait.txt")




library(data.table)
library(stringr)
library(dplyr)
library(xtable)
library(ggplot2)

if (!require(devtools)) { install.packages("devtools"); library(devtools)}
if (!require(ComplexHeatmap)) { install_github("jokergoo/ComplexHeatmap"); library(ComplexHeatmap)}
#install.packages("gridtext")
#library(gridtext)
if (!require(circlize)) {install.packages("circlize"); library(circlize)}
if (!require(data.table)) {install.packages("data.table"); library(data.table)}
if (!require(dplyr)) {install.packages("dplyr"); library(dplyr)}



# Heatmap of LDSC genetic correlations
outputs_dir <- "./real/outputs"

type="intersex"

#input_file <-"/Users/claudiavasallo/gxs/intersex.txt"

input_file <- "/Users/claudiavasallo/Library/CloudStorage/GoogleDrive-claudia.vasallo@upf.edu/My Drive/gxs/genetic-correlations.txt"

rg <- fread(input_file, header = F)
h2 <- fread("/Users/claudiavasallo/Library/CloudStorage/GoogleDrive-claudia.vasallo@upf.edu/My Drive/gxs/reliable_h2.txt")

m_traits <- fread("/Users/claudiavasallo/Library/CloudStorage/GoogleDrive-claudia.vasallo@upf.edu/My Drive/gxs/m_traits.txt", header = F)$V1
f_traits <- fread("/Users/claudiavasallo/Library/CloudStorage/GoogleDrive-claudia.vasallo@upf.edu/My Drive/gxs/f_traits.txt", header = F)$V1


# ------------------------------------------------------------------------------

rg <- rg[, c(1,2,5,6, 7)]
colnames(rg) <- c("Trait1", "Trait2", "rg", "se", "p")
dim(rg)

f_atlas <- fread("/Users/claudiavasallo/Library/CloudStorage/GoogleDrive-claudia.vasallo@upf.edu/My Drive/gxs/female_atlas_ids.txt")$x
m_atlas <- fread("/Users/claudiavasallo/Library/CloudStorage/GoogleDrive-claudia.vasallo@upf.edu/My Drive/gxs/male_atlas_ids.txt")$x


# Filter to h2 reliable results ---
rg$trait1 <- rg$Trait1
rg$trait1 <- ifelse(rg$Trait1 %in% f_atlas, paste0(rg$Trait1, "f"), rg$trait1 )
rg$trait1 <- ifelse(rg$Trait1 %in% m_atlas, paste0(rg$Trait1, "m"), rg$trait1 )


rg$trait2 <- rg$Trait2
rg$trait2 <- ifelse(rg$Trait2 %in% f_atlas, paste0(rg$Trait2, "f"), rg$trait2 )
rg$trait2 <- ifelse(rg$Trait2 %in% m_atlas, paste0(rg$Trait2, "m"), rg$trait2 )


# traits names dictionaries
neale_dic <- fread("/Users/claudiavasallo/Library/CloudStorage/GoogleDrive-claudia.vasallo@upf.edu/My Drive/gxs/neale_dic.txt", header = F, sep="\t")
neale_dic <- filter(neale_dic, !(is.na(V2)), !(is.na(V1)))
neale_dic <- filter(neale_dic, V2!="N/A" & V1 != "N/A")
neale_dic_f <- neale_dic
neale_dic_f$V1 <- paste0(neale_dic_f$V1, "_f")
neale_dic_m <- neale_dic
neale_dic_m$V1 <- paste0(neale_dic_m$V1, "_m")
atlas_dic <- fread("/Users/claudiavasallo/Library/CloudStorage/GoogleDrive-claudia.vasallo@upf.edu/My Drive/gxs/atlas_dic.txt", header = F)
a_dic <- fread("/Users/claudiavasallo/Library/CloudStorage/GoogleDrive-claudia.vasallo@upf.edu/My Drive/gxs/a_dic.txt", header = F)
traits_dic <- rbind(neale_dic_f, neale_dic_m)
traits_dic <- rbind(traits_dic, atlas_dic )
traits_dic <- rbind(traits_dic, a_dic)
colnames(traits_dic) <- c("trait_id", "trait_name")

traits_dic <- unique(traits_dic)
sum(duplicated(traits_dic$trait_id)) # 0
sum(duplicated(traits_dic$trait_name)) # 4931

traits_dic$trait_name[duplicated(traits_dic$trait_name)]
# -------------------------------------------------------------------------------
# filter to h2_results 
#reliable_h2 <- fread("../1-h2/real/outputs/reliable_h2.txt")
reliable_h2 <- fread("/Users/claudiavasallo/Library/CloudStorage/GoogleDrive-claudia.vasallo@upf.edu/My Drive/gxs/reliable_h2.txt")
length(unique(traits_dic$trait_name)) # 4261
h2$trait_name <- sapply(h2$trait, function(t) { gsub("male", "", gsub("female", "", t ))})
length(unique(reliable_h2$Trait)) # 94 
rg <- filter(rg, Trait1 %in% unique(reliable_h2$Trait) &  Trait2 %in% unique(reliable_h2$Trait))
dim(rg) # 4371    6
length(unique(c(rg$Trait1, rg$Trait2))) # 94
length(unique(c(rg$trait1, rg$trait2))) # 94

# ---

# define traits
traits <- unique(c(rg$Trait1, rg$Trait2))
traits

# # Trait 2 and Trait 2 as male and female
# rg1f <- filter(rg, Trait1 %in% f_traits)
# rg2f <- filter(rg, Trait2 %in% f_traits)
# # colnames(rg2f) <- c("Trait2", "Trait1", "rg", "p")
# #rg2f <- rg2f[, c("Trait1", "Trait2", "rg", "p")]
# 
# 
# rg <- rbind(rg1f, rg2f)

#rg %>% arrange(Trait1, Trait2)







# ---

m <- matrix(nrow = length(traits)/2, ncol = length(traits)/2)
rownames(m) <- unique(traits[traits %in% f_traits]) # F
colnames(m) <- unique(traits[traits %in% m_traits]) # M 

# rg value
for (t1 in rownames(m)) {
  for (t2 in colnames(m)) {
    #val <-  round(filter(rg, Trait1 ==t1 & Trait2==t2 | Trait2 ==t1 & Trait1==t2)$rg, 2)
    val <-  round(filter(rg, Trait1 ==t1 & Trait2==t2 | Trait2 ==t1 & Trait1==t2 )$rg, 2)
    if (length(val) >0) {
    #m[t1, t2]  <-  m[t2, t1]  <- round(filter(rg, Trait1 ==t1 & Trait2==t2 | Trait2 ==t1 & Trait1==t2)$rg, 2)
      m[t1, t2]  <- val
      } else {
      #m[t1, t2]  <-  m[t2, t1]  <- NA
        m[t1, t2]   <- NA
    }
    }
}

colors_m <- m
numbers_m <- m



# # aster showing significative comparisons
sig_m <- matrix(nrow = length(traits)/2, ncol = length(traits)/2)
rownames(sig_m) <- unique(traits[traits %in% f_traits]) # F
colnames(sig_m) <- unique(traits[traits %in% m_traits]) # M 
rg$p <- as.numeric(rg$p)
for (t1 in rownames(sig_m)) {
  for (t2 in colnames(sig_m)) {
    val <- filter(rg, Trait1 ==t1 & Trait2==t2 | Trait2 ==t1 & Trait1==t2)$p < 0.05 #/nrow(rg)
    if (length(val) >0) {
      #sig_m[t1, t2] <- sig_m[t2, t1]  <- filter(rg, Trait1 ==t1 & Trait2==t2 | Trait2 ==t1 & Trait1==t2)$PValue
      sig_m[t1, t2]  <- ifelse(val, "*", "")
    } else {
      sig_m[t1, t2]   <- NA
    }
  }
}


# this was to compare two methods in each part of 
#numbers_m[upper.tri(numbers_m)]  <- sig_m[upper.tri(sig_m)]

# traits ids
# colnamxes(colors_m) <- traits
# rownames(colors_m) <- traits

# rownames(colors_m) <- unique(rg$Trait1)
# colnames(colors_m) <- unique(rg$Trait2)

# trait names 
# colnames(colors_m) <- names(traits)
# rownames(colors_m) <- names(traits)

colnames(colors_m) <- sapply(colnames(colors_m), function(t) {filter(traits_dic, trait_id==t)$trait_name})
rownames(colors_m) <- sapply(rownames(colors_m), function(t) {filter(traits_dic, trait_id==t)$trait_name})

colnames(colors_m) <- sapply(colnames(colors_m), function(e) { gsub(",", "", gsub("()", "", gsub("male", "", gsub("female", "", e )), fixed = T), fixed = T) } )
rownames(colors_m) <- sapply(rownames(colors_m), function(e) { gsub(",", "", gsub("()", "", gsub("male", "", gsub("female", "", e )), fixed = T), fixed = T) } )

#numbers_m <- sig_m


# row_order <- 1:length(rownames(colors_m))
# column_order <- length(colnames(colors_m)):1


# trait names first 15 letters
# colnames(colors_m) <- abbreviate(names(traits) ,25, dot = "TRUE", strict = "TRUE")
# rownames(colors_m) <- abbreviate(names(traits) ,25, dot = "TRUE", strict = "TRUE")



#row_order <- colnames(colors_m) 
#row_order <- order(colnames(colors_m))
#numbers_m <- sig_m
numbers_m <- colors_m

numbers_m[sig_m!="*"] <- ""

row_order <- 1:length(rownames(colors_m))
column_order <- length(colnames(colors_m)):1

pdf(file = paste0(outputs_dir, "/", "heatmap.rg.", type,  ".pdf"), height = 10, width = 10)
Heatmap(colors_m, name = "rg",
        row_order = row_order,
        column_order = row_order[length(row_order):1],
        row_names_side = "left", 
        column_names_side = "bottom", 
        na_col = "grey",
        row_title_gp = gpar(fontsize = 3),
        column_title_gp = gpar(fontsize = 3),
        #colorRamp2(c(-1,-0.5, 0, 0.5, 1), c("#C7DB53", "#e6ebb9", "#FBFBEA",  "#9EC0BE", "#2A8490")),  # #B4D743 "azure" #F3F7D4 #CBEE86 #f4fac3 #e6ebb9 #f4fac3
        show_column_dend = FALSE, 
        show_row_dend = FALSE, 
        row_names_max_width = unit(6, "cm"),
        row_names_gp = gpar(fontsize = 3),
        #row_labels = gt_render(sapply(rownames(colors_m), strrep, 1), align_widths = TRUE),
        row_names_rot = 0,
        row_names_centered = FALSE,
        column_names_max_height = unit(6, "cm"),
        column_names_gp = gpar(fontsize = 3),
        column_names_rot = 90,
        column_names_centered = FALSE,
        cell_fun = function(j, i, x, y, w, h, col) { # add text to each grid
        grid.text(numbers_m[i, j], x, y, gp=gpar(fontsize = 1)) # fontface = "bold"
        }
)
dev.off()


