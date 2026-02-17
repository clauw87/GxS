# H2 Plot and latex table


library(data.table)
library(dplyr)
library(tidyverse)

sca <- "liab"

args <- commandArgs(T)
h2_compare <- args[1]

suffix <- strsplit(basename(h2_compare), ".", fixed=T)[[1]][1]


if (!require(data.table)) { install.packages("data.table"); library(data.table) }
if (!require(dplyr)) { install.packages("dplyr"); library(dplyr) }
if (!require(tidyr)) { install.packages("tidyr"); library(tidyr) }
if (!require(stringr)) { install.packages("stringr"); library(stringr) }
if (!require(ggplot2)) { install.packages("ggplot2"); library(ggplot2) }
if (!require(ggthemes)) { install.packages("ggthemes"); library(ggthemes) }
if (!require(xtable)) { install.packages("xtable"); library(xtable) }


compare_h2 <- fread(h2_compare, header=T, sep="\t")


type <- "intersex"

outputs_dir <- "./real/outputs"


pdf(file = paste0(outputs_dir, "/", "h2.f-m.", type, ".", suffix, ".", "scatter.pdf"), height = 10, width = 10)
# All are h2 different from zero:
# p value of differences
data <- compare_h2
#create regression plot with customized style
ggplot(data, aes(x = m_est, y = f_est, color=p_diff)) +
  geom_point() +
  geom_abline(linetype = "dashed") +
  #geom_smooth(method='lm', se=FALSE, color='turquoise4') +
  theme_minimal() +
  labs(x='SNP h2 males', y='SNP h2 females', title='') +
  theme(plot.title = element_text(hjust=0.5, size=20, face='bold')) 
dev.off()



# Side by side barplot
compare_h2 <- compare_h2[,-1]
#colnames(compare_h2)[1] <- "trait"

#compare_h2$trait <- sapply(compare_h2$trait, function(t) { str_split(t, "requested|atlas|neales" )[[1]][1]  } )
#compare_h2$trait <- sapply(compare_h2$trait, function(t) {  substr(t, 1, nchar(t) -2)   }) 
#compare_h2$trait <- sapply(compare_h2$trait, function(t) { gsub(pattern="adjusted for BMI", replacement="adjBMI", x=t) })

compare_h2$trait <- compare_h2$trait_name

data_long <- gather(compare_h2,  key="sex_est", value="beta_est", c(m_est, f_est))
data_long <- gather(data_long, key="sex_se", value=beta_est_se, c("m_est_se", "f_est_se"))
data_long <- filter(data_long, (str_detect(sex_est, "f") & str_detect(sex_se, "f")) | (str_detect(sex_est, "m") & str_detect(sex_se, "m")) )
data_long$sex <- ifelse(data_long$sex_est=="m_est", "male", "female")
data_long <- data_long %>% select(-c(sex_est, sex_se))
data_long <- distinct(data_long)

pdf(file = paste0(outputs_dir, "/", "h2.f-m.", type, ".", suffix, ".",  "barplot.pdf"), height = 10, width = 10)
ggplot(data=data_long, aes(trait_name, beta_est, fill=sex)) +
	geom_bar(stat="identity", position="dodge", colour="black") +
	geom_errorbar(aes(ymin=beta_est - beta_est_se, ymax= beta_est + beta_est_se), width=.2, position=position_dodge(.9) ) +
	theme_bw() +
	#theme(axis.text.x = element_text(angle=90, vjust=0.5, hjust=1)) +
	guides(fill=guide_legend(title=NULL)) + 
	#theme_fivethirtyeight() +
	#scale_fill_fivethirtyeight() +
        scale_fill_manual(values=c("#FF69B4", "#000080")) + 
	labs(x="", y="SNP h2 estimate (liability)") +
	theme(axis.text.x = element_text(angle=90, vjust=0.5, hjust=1))
dev.off()




# Tabulate results
# latex table
compare <- compare_h2
compare$m <- paste0(compare$m_est, "(", compare$m_est_se , ")")
compare$f <- paste0(compare$f_est, "(", compare$f_est_se , ")")
#compare_ <- compare %>% select(TRAIT1_C, m, f, stat, stat_sign, p_diff, p_diff_adj)
compare_ <- compare %>% select(trait_name, m, f, stat, stat_sign, p_diff, p_diff_adj)

nom_sig <- filter(compare_, p_diff <0.05)
colnames(nom_sig) <-  c("Trait", "h2m(se)", "h2f(se)", "stat", "sign", "p diff", "p diff FDR")
tex_table <- print(xtable(nom_sig), include.rownames=FALSE)
write(tex_table, paste0(outputs_dir, "/",  suffix,".","nominal", ".", "tex") )

fdr_sig <- filter(compare_, p_diff_adj <0.05)
colnames(fdr_sig) <-  c("Trait", "h2m(se)", "h2f(se)", "stat", "sign", "p diff", "p diff FDR")
tex_table <- print(xtable(fdr_sig), include.rownames=FALSE)
write(tex_table, paste0(outputs_dir, "/",  suffix,".","fdr", ".", "tex") )

#compare_h2$sign <- as.integer(compare_h2$sign)
# Table
#compare_h2 <- compare_h2 %>% arrange(p_adj)
#tex_table <-  print(xtable(compare_h2[,c("trait", "m_est", "f_est", "stat" , "sign" , "p_adj")] ), include.rownames=FALSE)
#write(tex_table, paste0(outputs_dir, "/", "h2_table.tex"))
