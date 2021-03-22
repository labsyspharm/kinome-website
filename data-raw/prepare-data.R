
kinomedat <- readr::read_csv("data-raw/the_697_extended_kinome_v3_annotated.csv")
fst::write_fst(kinomedat, "data/the_697_extended_kinome_v3_annotated.fst")
