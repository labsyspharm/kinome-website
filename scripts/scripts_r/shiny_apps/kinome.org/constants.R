


KINOME_COLORS <- c(`crimson` = "#c90016", `2` = "#ef8a62", `3` = "#fddbc7", `10` = "#d9d9d9")
DT_DOM <- '<"row justify-content-between"<"col-sm-12 col-md-auto"B><"col-sm-12 col-md-auto"l><"col-sm-12 col-md-auto ml-md-auto"f>><"row"<"col-sm-12"t>><"row"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>'




# Right side is in table, left is display
# careful -- the one that says "TWO_COLUMNS", one user selected
# var leads to two columns added
COLUMNS <- c(
  "HGNC_Symbol" = "HGNC symbol",
  "Approved name" = "Approved name",
  "INDRA_network" = "INDRA network",
  "Fold_Annotation" = "Fold annotation",
  "Group" = "Group",
  "Number of MS/SS cmpds" = "Number of MS/SS cmpds" ,
  "IDG dark kinase" = "IDG dark kinase",
  "Statistically defined dark kinase" = "Statistically defined dark kinase",
  "Cancer" = "Cancer",
  "Alzeheimer’s disease" = "Alzheimer's disease", 
  "Chronic obstructive pulmonary disease" = "Chronic obstructive pulmonary disease", 
  "Number of Essential cell lines" = "Number of essential cell lines", 
  "Structures" = "Structures",
  "TWO_COLUMNS" = "Commercial assays available",
  "Pseudokinase" = "Pseudokinase",
  "Manning Kinase" = "Manning kinase",
  "Kinhub Kinase" = "Kinhub kinase",
  "Family" = "Family",
  "PfamDomain" = "PfamDomain",
  "DomainStart" = "Domain start",
  "DomainEnd" = "Domain end",
  "Number of INDRA Statements" = "Number of INDRA statements", 
  "TIN-X_Score" = "TIN-X_Score",
  "PHAROS_Target_Development_Level" = "PHAROS target development level",
  "gene_id" = "Gene ID",
  "Uniprot Entry" = "Uniprot entry",
  "Uniprot Entry name" = "Uniprot entry name", 
  "Gene names" = "Gene names"
)

# Use display name
DEFAULT_COLUMNS <- c(
  "HGNC symbol", 
  "Approved name", 
  "Fold annotation", 
  "Group")
TWO_COLUMNS <- c("kinaseform_in_ReactionBiology", "kinaseform_in_DiscoverX")
