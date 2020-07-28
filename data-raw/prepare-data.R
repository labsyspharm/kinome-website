# 
# microbenchmark::microbenchmark({
#   kinomedat <- readr::read_csv("data/the_697_extended_kinome_v1_annotated.csv")
# }, unit = "us") # 20752.77
# 
# microbenchmark::microbenchmark({
#   kinomedat <- readr::read_rds("~/junk/kinome.rds")
# }, unit = "us") # 74.94416


#kinomedat <- readr::read_csv("data-raw/the_697_extended_kinome_v1_annotated.csv")
#readr::write_rds(kinomedat, "data/the_697_extended_kinome_v1_annotated.rds")

kinomedat <- readr::read_csv("data-raw/the_697_extended_kinome_v2_annotated.csv")
readr::write_rds(kinomedat, "data/the_697_extended_kinome_v2_annotated.rds")