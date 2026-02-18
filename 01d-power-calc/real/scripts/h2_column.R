
# add_h2() -------------------------------------------------------

add_h2 <- function(metadata) {

meta <- metadata


h2 <-fread("../2-ldsc/2-join_h2_results/real/outputs/h2.txt")

#meta <- left_join(meta, h2, by = join_by(sid == Trait))
meta <- merge(meta, h2, by.x="sid", by.y="Trait", all.x=TRUE)


meta

}
