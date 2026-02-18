# Heatmap of LDSC genetic correlations between diseases wihin sex (male, females)
# module load R/4.0.0-foss-2020a
if (!require(devtools)) { install.packages("devtools"); library(devtools)}
#if (!require(BiocInstaller)) { install.packages("BiocInstaller") }
if (!require(BiocManager)) {install.packages("BiocManager") }
if (!require(ComplexHeatmap)) { install_github("jokergoo/ComplexHeatmap"); library(ComplexHeatmap)}
#install.packages("gridtext")
#library(gridtext)
if (!require(circlize)) {install.packages("circlize"); library(circlize)}
if (!require(data.table)) {install.packages("data.table"); library(data.table)}
if (!require(dplyr)) {install.packages("dplyr"); library(dplyr)}
library(stringr)
library(ggplot2)


args <- commandArgs(T)

# --------------------------------------------------------------------------------------------------
# Config
sig_level <- args[1]
outputs_dir <- "./real/outputs"


if (sig_level=="fdr") {
font_size_1 = 10 # row, col titles
font_size_2 = 12  # row, col names
font_size_3 = 9  # grid text
} else {
font_size_1 = 8 # # row, col titles
font_size_2 = 9  # # row, col names 
font_size_3 = 5  #  grid text
}


#input_file <- "../1-rg-diff/real/outputs/compare_rg_intrasex.txt"
#input_file <- "/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/6-sex-differences/2-rg/1-rg-diff/real/outputs/rg_results_power_good.txt"

# sig correlated in both sexes
input_file <- "real/outputs/mf_diff.txt"
# unfiltered ct pairs results in each sex
rg_m <- fread("./real/outputs/m_crosstrait.txt")
rg_f <- fread("./real/outputs/f_crosstrait.txt")
# mf joint
rg <- fread(input_file, header = T)
# diff # FDR significant sex differences
rg_diff <- fread(paste0("./real/outputs/mf_diff_", sig_level,".txt"))
rg_m <- filter(rg_m, pair_name %in% rg_diff$pair_name)
rg_f <- filter(rg_f, pair_name %in% rg_diff$pair_name)
# h2  prefilter taking into account the h2 estimates or h2 z score  # here to remove the one of the duplicated traits (highest power selected)
#reliable_h2 <- fread("../../1-h2/1-h2-diff-calc/real/outputs/reliable_h2.txt")
#reliable_h2 <- fread("../../../3-power-calc/real/outputs/metadata_power.txt")
#rg <- filter(rg, sid_1 %in% reliable_h2$sid & sid_2 %in% reliable_h2$sid )
#rg$id1_trait <- sapply(rg$id1_trait, function(a) { gsub(x=a, pattern="female", "")})
#rg$id1_trait <- sapply(rg$id1_trait, function(a) { gsub(x=a, pattern="male", "")})
#rg$id2_trait <- sapply(rg$id2_trait, function(a) 
# filter to those comparisons with enough power (<0.80) to detect differences of 0.1 (for this use rg_results_power_best)
# per sex rg subset
#rg <-  filter(rg, , rg_power0.1>0.8) # power to detect a difference of 0.1 with rg=0 or a difference of rg of 0.1
#rg_f <-  filter(rg, sid_1_sex=="f" & sid_2_sex == "f") 
#rg_m <-  filter(rg, sid_1_sex=="m" & sid_2_sex == "m")
#rg_m <- rg %>% select(pair_name, "GC.x", "GC_SE.x")
#rg_f <-	rg %>% select(pair_name, "GC.y", "GC_SE.y")
# common well powered combinations 
#common_combi <-  intersect(rg_f$trait_combi, rg_m$trait_combi)
#rg_f <- filter(rg_f, trait_combi  %in% common_combi)
#rg_m <- filter(rg_m, trait_combi  %in% common_combi)
#dim(rg_f) # 219	18 
#dim(rg_m) # 219 18
# females
#rg_f$id1_trait <- sapply(rg_f$id1_trait, function(a) { gsub(x=a, pattern="female", "")})
#rg_f$id2_trait <- sapply(rg_f$id2_trait, function(a) { gsub(x=a, pattern="female", "")})
#rg_f$traits1 <- sapply(rg_f$Trait1_name, function(e) { str_split(e, "\\(")[[1]][1] } )
#rg_f$traits2 <- sapply(rg_f$Trait2_name, function(e) { str_split(e, "\\(")[[1]][1] } )
#traits <- unique(c(rg_f$traits1, rg_f$traits2))


rg_f <- rg_f %>% select(Trait1_name, Trait2_name, "GC" , "GC_SE"  )
#traits <- unique(c(rg_f$Trait1_name, rg_f$Trait2_name))
colnames(rg_f) <- c( "traits1", "traits2", "rg", "rg_se")
# update Neales names "Diagnoses - main ICD10:"
# traits[str_detect(traits, ":")]
rg_f$traits1 <- sapply(rg_f$traits1,function(t){ ifelse(str_detect(t, ": "),str_split(string=str_split(string=t,pattern=": ")[[1]][2],pattern=" ",n=2)[[1]][2],t)})
rg_f$traits1 <- sapply(rg_f$traits1,function(t){ ifelse(str_detect(t, "/ "),str_split(string=t,pattern="/ ")[[1]][2],t)})
rg_f$traits1 <- sapply(rg_f$traits1,function(t){ ifelse(str_detect(t, "\\["),str_split(string=t,pattern=" \\[")[[1]][1],t)})
rg_f$traits2 <- sapply(rg_f$traits2,function(t){ ifelse(str_detect(t, ": "),str_split(string=str_split(string=t,pattern=": ")[[1]][2],pattern=" ",n=2)[[1]][2],t)})
rg_f$traits2 <- sapply(rg_f$traits2,function(t){ ifelse(str_detect(t, "/ "),str_split(string=t,pattern="/ ")[[1]][2],t)})
rg_f$traits2 <- sapply(rg_f$traits2,function(t){ ifelse(str_detect(t, "\\["),str_split(string=t,pattern=" \\[")[[1]][1],t)})
# "/ " take secxond 
# [] take all but
traits <- unique(c(rg_f$traits1, rg_f$traits2))
# matrix of between diseases correlations 
f <- matrix(nrow=length(traits), ncol =  length(traits))
colnames(f) <- traits
rownames(f) <- traits
for (t1 in rownames(f)) {
  for (t2 in colnames(f)) {
    val <- round(filter(rg_f, traits1 ==t1 & traits2==t2 | traits2 ==t1 & traits1==t2)$rg, 2)
    if (length(val) >0) {
     f[t1, t2]  <-  f[t2, t1]  <- val
    } else {
     f[t1, t2]  <-  f[t2, t1]  <- NA
    }
  }
}
diag(f) <- 1
colors_f <- f
#colnames(colors_f) <- sapply(colnames(colors_f), function(e) { gsub(",", "", gsub("()", "", gsub("male", "", gsub("female", "", e )), 
#fixed = T), fixed = T) } )
#rownames(colors_f) <- sapply(rownames(colors_f), function(e) { gsub(",", "", gsub("()", "", gsub("male", "", gsub("female", "", e )), 
#fixed = T), fixed = T) } )
#numbers_f <- sig_f
numbers_f <- colors_f
numbers_text_f <- ifelse(is.na(numbers_f), "", as.character(round(numbers_f,1)))
row_order <- 1:length(rownames(colors_f))
column_order <- length(colnames(colors_f)):1
# Create color gradient
col_fun <- colorRamp2(
  breaks = c(-1, -0.5, 0, 0.5, 1),
  #colors = c("#C7DB53", "#e6ebb9", "#FBFBEA", "#9EC0BE", "#2A8490")
   colors = c("#6c20bd", "#aa86d1", "#FBFBEA", "#a8e0c3", "#20bd6a")
)
na_color <- "#FAF9F6"      #"#FBFBEA"
type = paste0("intrasex.f",".", sig_level)
pdf(file = paste0(outputs_dir, "/", "heatmap.rg2.", type,  ".pdf"), height = 15, width = 15)
#jpeg(file = paste0(outputs_dir, "/", "heatmap.rg2.", type,  ".jpeg"), height = 15, width = 15)
Heatmap(colors_f, name = "rg",
        col = col_fun,  # Add color mapping here 
        row_order = row_order, # [length(row_order):1]
        column_order = column_order[length(column_order):1],
        row_names_side = "left", 
        column_names_side = "bottom", 
        na_col =  na_color,              #   "#FBFBEA"  "grey", "transparent"
        rect_gp = gpar(col = "grey", lwd = 0.05),  # Add borders to all cells
        row_title_gp = gpar(fontsize = font_size_1),
        column_title_gp = gpar(fontsize = font_size_1),
        #colorRamp2(c(-1,-0.5, 0, 0.5, 1), c("#C7DB53", "#e6ebb9", "#FBFBEA",  "#9EC0BE", "#2A8490")),  # #B4D743 "azure" #F3F7D4 #CBEE86 #f4fac3 #e6ebb9 #f4fac3
        show_column_dend = FALSE, 
        show_row_dend = FALSE, 
        row_names_max_width = unit(12, "cm"),
        row_names_gp = gpar(fontsize = font_size_2),
        #row_labels = gt_render(sapply(rownames(colors_m), strrep, 1), align_widths = TRUE),
        row_names_rot = 0,
        row_names_centered = FALSE,
        column_names_max_height = unit(12, "cm"),
        column_names_gp = gpar(fontsize = font_size_2),
        column_names_rot = 90,
        column_names_centered = FALSE,
        cell_fun = function(j, i, x, y, w, h, col) { # add text to each grid
          if(j >= i) {
          grid.rect(x, y, w, h, gp = gpar(fill = "#ffffff", col = "#ffffff"))
          } else {
          grid.text(numbers_text_f[i, j], x, y, gp=gpar(fontsize = font_size_3)) # fontface = "bold"
          }
        }


)
dev.off()
#ggsave(filename=paste0(outputs_dir, "/", "heatmap.rg2.", type,  ".png"), height = 15, width = 15, units="cm")


# males
#rg_m$id1_trait <- sapply(rg_m$id1_trait, function(a) { gsub(x=a, pattern="male", "")})
#rg_m$id2_trait <- sapply(rg_m$id2_trait, function(a) { gsub(x=a, pattern="male", "")})
#traits <- unique(c(rg_m$id1_trait, rg_m$id2_trait))
rg_m <- rg_m %>% select(Trait1_name, Trait2_name, "GC" , "GC_SE"  )
colnames(rg_m) <- c( "traits1", "traits2", "rg", "rg_se")
# update the same names
rg_m$traits1 <- sapply(rg_m$traits1,function(t){ ifelse(str_detect(t, ": "),str_split(string=str_split(string=t,pattern=": ")[[1]][2],pattern=" ",n=2)[[1]][2],t)})
rg_m$traits1 <- sapply(rg_m$traits1,function(t){ ifelse(str_detect(t, "/ "),str_split(string=t,pattern="/ ")[[1]][2],t)})
rg_m$traits1 <- sapply(rg_m$traits1,function(t){ ifelse(str_detect(t, "\\["),str_split(string=t,pattern=" \\[")[[1]][1],t)})
rg_m$traits2 <- sapply(rg_m$traits2,function(t){ ifelse(str_detect(t, ": "),str_split(string=str_split(string=t,pattern=": ")[[1]][2],pattern=" ",n=2)[[1]][2],t)})
rg_m$traits2 <- sapply(rg_m$traits2,function(t){ ifelse(str_detect(t, "/ "),str_split(string=t,pattern="/ ")[[1]][2],t)})
rg_m$traits2 <- sapply(rg_m$traits2,function(t){ ifelse(str_detect(t, "\\["),str_split(string=t,pattern=" \\[")[[1]][1],t)})
# matrix of between diseases correlations
m <- matrix(nrow=length(traits), ncol =  length(traits))
colnames(m) <- traits
rownames(m) <- traits
for (t1 in rownames(m)) {
  for (t2 in colnames(m)) {
    val <- round(filter(rg_m, traits1 ==t1 & traits2==t2 | traits2 ==t1 & traits1==t2)$rg, 2)
    if (length(val) >0) {
     m[t1, t2]  <-  m[t2, t1]  <- val
    } else {
     m[t1, t2]  <-  m[t2, t1]  <- NA
    }
  }
}
diag(m) <- 1
colors_m <- m
#colnames(colors_m) <- sapply(colnames(colors_m), function(e) { gsub(",", "", gsub("()", "", gsub("male", "", gsub("female", "", e )), 
#fixed = T), fixed = T) } )
#rownames(colors_m) <- sapply(rownames(colors_m), function(e) { gsub(",", "", gsub("()", "", gsub("male", "", gsub("female", "", e )), 
#fixed = T), fixed = T) } )
#numbers_m <- sig_m

numbers_m <- colors_m
numbers_text_m <- ifelse(is.na(numbers_m), "", as.character(round(numbers_m, 1)))
row_order <- 1:length(rownames(colors_m))
column_order <- length(colnames(colors_m)):1
type = paste0("intrasex.m", ".", sig_level)
pdf(file = paste0(outputs_dir, "/", "heatmap.rg2.", type,  ".pdf"), height = 15, width = 15)
#jpeg(file = paste0(outputs_dir, "/", "heatmap.rg2.", type,  ".jpeg"), height = 15, width = 15)
Heatmap(colors_m, name = "rg",
        col = col_fun,  # Add color mapping here 
        row_order = row_order, # [length(row_order):1]
        column_order = column_order[length(column_order):1],
        row_names_side = "left", 
        column_names_side = "bottom", 
        na_col = na_color, # "grey",
        rect_gp = gpar(col = "grey", lwd = 0.05),  # Add borders to all cells
        row_title_gp = gpar(fontsize = font_size_1),
        column_title_gp = gpar(fontsize = font_size_1),
        #colorRamp2(c(-1,-0.5, 0, 0.5, 1), c("#C7DB53", "#e6ebb9", "#FBFBEA",  "#9EC0BE", "#2A8490")),  # #B4D743 "azure" #F3F7D4 #CBEE86 #f4fac3 #e6ebb9 #f4fac3
        show_column_dend = FALSE, 
        show_row_dend = FALSE, 
        row_names_max_width = unit(12, "cm"),
        row_names_gp = gpar(fontsize = font_size_2),
        #row_labels = gt_render(sapply(rownames(colors_m), strrep, 1), align_widths = TRUE),
        row_names_rot = 0,
        row_names_centered = FALSE,
        column_names_max_height = unit(12, "cm"),
        column_names_gp = gpar(fontsize = font_size_2),
        column_names_rot = 90,
        column_names_centered = FALSE,
        cell_fun = function(j, i, x, y, w, h, col) { # add text to each grid
          if(j >= i) {
          grid.rect(x, y, w, h, gp = gpar(fill = "#ffffff", col = "#ffffff"))
          } else {
          grid.text(numbers_text_m[i, j], x, y, gp=gpar(fontsize = font_size_3)) # fontface = "bold"
          }
        }


)
dev.off()
#ggsave(filename=paste0(outputs_dir, "/", "heatmap.rg2.", type,  ".png"), height = 15, width = 15, units="cm")




colors_diff <- abs(colors_m - colors_f)
numbers_diff <- colors_diff
numbers_text_diff <- ifelse(!is.na(numbers_diff), as.character(round(numbers_diff,1)) , "")
row_order <- 1:length(rownames(colors_diff))
column_order <- length(colnames(colors_diff)):1
col_fun <- colorRamp2(
  #breaks = c( 0, 0.25, 0.5, 0.75, 1),
   breaks = c(0,0.5,1), 
   colors = c("#FAF9F6", "#8c7f99", "#70518f")
)
na_color <- "#FAF9F6"	   #"#FBFBEA"

type = paste0("intrasex.diff", ".", sig_level)
pdf(file = paste0(outputs_dir, "/", "heatmap.rg2.", type,  ".pdf"), height = 15, width = 15)
#jpeg(file = paste0(outputs_dir, "/", "heatmap.rg2.", type,  ".jpeg"), height = 15, width = 15)
Heatmap(colors_diff, name = "rg diff (abs)",
        col = col_fun,  # Add color mapping here 
        row_order = row_order, # [length(row_order):1]
        column_order = column_order[length(column_order):1],
        row_names_side = "left", 
        column_names_side = "bottom", 
        na_col = na_color, # "grey",
        rect_gp = gpar(col = "grey", lwd = 0.05),  # Add borders to all cells
        row_title_gp = gpar(fontsize = font_size_1),
        column_title_gp = gpar(fontsize = font_size_1),
        #colorRamp2(c(-1,-0.5, 0, 0.5, 1), c("#C7DB53", "#e6ebb9", "#FBFBEA",  "#9EC0BE", "#2A8490")),  # #B4D743 "azure" #F3F7D4 #CBEE86 #f4fac3 #e6ebb9 #f4fac3
        show_column_dend = FALSE, 
        show_row_dend = FALSE, 
        row_names_max_width = unit(12, "cm"),
        row_names_gp = gpar(fontsize = font_size_2),
        #row_labels = gt_render(sapply(rownames(colors_m), strrep, 1), align_widths = TRUE),
        row_names_rot = 0,
        row_names_centered = FALSE,
        column_names_max_height = unit(12, "cm"),
        column_names_gp = gpar(fontsize = font_size_2),
        column_names_rot = 90,
        column_names_centered = FALSE,
        cell_fun = function(j, i, x, y, w, h, col) { # add text to each grid
          if(j >= i) {
          grid.rect(x, y, w, h, gp = gpar(fill = "#ffffff", col = "#ffffff"))
          } else {
          grid.text(numbers_text_diff[i, j], x, y, gp=gpar(fontsize = font_size_3)) # fontface = "bold"
          }
        }


)
dev.off()
#ggsave(filename=paste0(outputs_dir, "/", "heatmap.rg2.", type,  ".png"), height = 15, width = 15, units="cm")







# # aster showing significative comparisons
#sig_m <- matrix(nrow = length(traits), ncol = length(traits))
#colnames(sig_m ) <- traits
#rownames(sig_m ) <- traits
#for (t1 in rownames(sig_m)) {
#for (t2 in colnames(sig_m)) {
#    p <- filter(rg_m, traits ==t1 & traits2==t2 | traits2 ==t1 & traits1==t2)$pvalue
#    if (length(p) >0) {
#    # fdr adjusted
#    p_adj <- p.adjust(p, method="fdr", n=length(unique(rg_m$trait_combi)))
#    val <- p_adj < 0.05
#    } else {
#    val <- NULL
#    }
#    if (length(val) >0) {
#   sig_m[t1, t2] <- sig_m[t2, t1]  <- ifelse(val, "*", "")
#    } else {
#      sig_m[t1, t2]  <-  sig_m[t2, t1]  <- NA
#  }
#  }
# }
