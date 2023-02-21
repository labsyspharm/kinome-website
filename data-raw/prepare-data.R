library(synExtra)

synapser::synLogin()

syn <- synDownloader("data-raw", .cache = FALSE)

kinomedat <- readr::read_csv(syn("syn50560392"))

column_map <- c(HGNC_Symbol = "hgnc_symbol", `Approved name` = "hgnc_name",
                `IDG dark kinase` = "is_idg_dark_kinase", `Kinhub Kinase` = "is_kinhub_kinase",
                `Manning Kinase` = "is_manning_kinase", Group = "group", Family = "family",
                Uniprot_kinaseactivity = "has_annotated_kinase_activity", PfamDomain = "pfam_domain",
                DomainStart = "domain_start", DomainEnd = "domain_end", ProKinO = "is_prokino_kinase",
                Fold_Annotation = "fold_code", Fold = "fold", Annotation_Score = "annotation_score",
                INDRA_network = "indra_network", `Number of INDRA Statements` = "n_indra_statements",
                `TIN-X_Score` = "tin_x_score", PHAROS_Target_Development_Level = "pharos_development_level",
                Structures = "pdb_structure_ids", num_pdb = "n_pdb_structures",
                `Number of MS/SS cmpds` = "n_selective_compounds", rb_name = "rb_name",
                kinaseform_in_ReactionBiology = "kinaseform_in_reaction_biology",
                kinomescan_name = "kinomescan_name", kinaseform_in_DiscoverX = "kinaseform_in_discoverx",
                commercial_assay = "has_commercial_assay", `Number of Essential cell lines` = "n_essential_cell_lines",
                `Alzeheimer’s disease` = "significant_in_alzheimers", Cancer = "significant_in_cancer",
                `Chronic obstructive pulmonary disease` = "significant_in_copd",
                Pseudokinase = "is_pseudokinase", `Statistically defined dark kinase` = "is_statistically_defined_dark_kinase",
                protein_length = NA, domain_length = NA, is_curated = "is_curated", symbol_nice = NA,
                uniprot_name_nice = NA, multiple_domains = "multiple_domains",
                af2_pdb_url = NA)

colnames(kinomedat) <- column_map[colnames(kinomedat)]
kinomedat <- kinomedat[, na.omit(column_map)]

fst::write_fst(kinomedat, "data/the_extended_kinome.fst")
