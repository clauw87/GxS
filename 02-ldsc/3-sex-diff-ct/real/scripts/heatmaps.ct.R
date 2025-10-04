# Heatmaps of LDSC genetic correlations between diseases wihin sex (male, females)

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


# --------------------------------------------------------------------------------------------------
# Config
outputs_dir <- "./real/outputs"
# mf joint dataset of significant genetic correlation pairs in either sex
target_file <- "real/outputs/mf_diff.txt"
# unfiltered ct pairs results in each sex
m_ct_file <- "./real/outputs/m_crosstrait.txt"
f_ct_file <- "./real/outputs/f_crosstrait.txt"


sig_level <- args[1]

sex_diff_file <- paste0("./real/outputs/mf_diff_", sig_level ,".txt")



rg <- fread(target_file, header = T)
rg_m <- fread(m_ct_file)
rg_f <- fread(f_ct_file)
rg_diff <- fread(sex_diff_file)


# Split in sexes
rg_m <- filter(rg_m, pair_name %in% rg_diff$pair_name)
rg_f <- filter(rg_f, pair_name %in% rg_diff$pair_name)


# Females
rg_f <- rg_f %>% select(Trait1_name, Trait2_name, "GC" , "GC_SE"  )
colnames(rg_f) <- c( "traits1", "traits2", "rg", "rg_se")
rg_f$traits1 <- sapply(rg_f$traits1,function(t){ ifelse(str_detect(t, ": "),str_split(string=str_split(string=t,pattern=": ")[[1]][2],pattern=" ",n=2)[[1]][2],t)})
rg_f$traits1 <- sapply(rg_f$traits1,function(t){ ifelse(str_detect(t, "/ "),str_split(string=t,pattern="/ ")[[1]][2],t)})
rg_f$traits1 <- sapply(rg_f$traits1,function(t){ ifelse(str_detect(t, "\\["),str_split(string=t,pattern=" \\[")[[1]][1],t)})
rg_f$traits2 <- sapply(rg_f$traits2,function(t){ ifelse(str_detect(t, ": "),str_split(string=str_split(string=t,pattern=": ")[[1]][2],pattern=" ",n=2)[[1]][2],t)})
rg_f$traits2 <- sapply(rg_f$traits2,function(t){ ifelse(str_detect(t, "/ "),str_split(string=t,pattern="/ ")[[1]][2],t)})
rg_f$traits2 <- sapply(rg_f$traits2,function(t){ ifelse(str_detect(t, "\\["),str_split(string=t,pattern=" \\[")[[1]][1],t)})
traits <- unique(c(rg_f$traits1, rg_f$traits2))
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
na_color <- "#FAF9F6"
font_size_1 = 10 
font_size_2 = 12  
font_size_3 = 9  
type = paste0("intrasex.f", ".", sig_level)
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



# males
rg_m <- rg_m %>% select(Trait1_name, Trait2_name, "GC" , "GC_SE"  )
colnames(rg_m) <- c( "traits1", "traits2", "rg", "rg_se")
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



# Heatmap of sex differences rgm -rgf
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
Heatmap(colors_diff, name = "rg diff (m-f)",
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




