library(data.table)
library(dplyr)
library(stringr)
library(ggplot2)


res_file <- "real/outputs/rg_intratrait.txt"
outputs_dir <- "real/outputs"

type= "intersex"

rg_diff_1 <- fread(res_file)
rg_diff_1$name <- sapply(rg_diff_1$Trait1_name, function(e) {  str_split(e, pattern='\\(|\\)')[[1]][1] })

#pdf(file = paste0(outputs_dir, "/", "rg.f-m.", type,  ".pdf"), height = 10, width = 10)
# p value of differences


data <- rg_diff_1

#create regression plot with customized style
# x = abbreviate(Trait1_name, minlength=17)
pp <- ggplot(data, aes(x = name, y = GC, fill=rg1_p_adj)) +
  geom_bar(stat="identity",
           position=position_dodge()) +
  geom_errorbar(aes(ymin=GC_SE, ymax=GC+GC_SE), width=.2,
                position=position_dodge(.9)) +
  geom_hline(yintercept = 1, linetype="dashed",
             color = "red", linewidth=0.2) +	 
  theme_minimal() +
  theme(plot.title = element_text(hjust=0.5, size=15, face='bold')) +
  labs(x='', y='rg f-m', title='') +
  theme(axis.text.x = element_text(angle = 90, hjust=1),
        axis.title.x = element_text())

#dev.off()
#abbreviate(x, minlength=7)

ggsave(plot=pp, file = paste0(outputs_dir, "/", "rg.f-m.", type,  ".pdf"), height = 10, width = 10)
