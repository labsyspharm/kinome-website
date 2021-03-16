
kinomedat <- readr::read_csv("data-raw/the_697_extended_kinome_v2_annotated.csv")
readr::write_fst(kinomedat, "data/the_697_extended_kinome_v2_annotated.fst")
