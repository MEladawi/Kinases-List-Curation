#!/usr/bin/env Rscript
# =============================================================================
# Comprehensive human kinase reference table -- entry point.
#
# Builds a gene-level human kinase table (keyed on base Ensembl gene IDs, typed by
# enzymatic function) by integrating seven kinase resources through HGNC. All logic
# lives in helper_code/; this script just loads it and runs the pipeline.
#
# Run:   Rscript build_kinases.R
# Or, from an R session, source the helpers and call the function directly:
#   invisible(lapply(list.files("helper_code", "\\.R$", full.names = TRUE), source))
#   result <- build_kinase_list(refresh_data = FALSE)   # see ?build_kinase_list parameters
#
# See README.md for the method and outputs.
# =============================================================================

invisible(lapply(list.files("helper_code", pattern = "\\.R$", full.names = TRUE), source))

result <- build_kinase_list(
  refresh_data = TRUE,    # FALSE = offline, reproducible rerun of the cached files in data_in/
  data_in_dir  = "data_in",
  output_dir   = "data_out",
  write_files  = TRUE,
  quiet        = FALSE)

cat("Outputs written to ", normalizePath("data_out"), "\n", sep = "")
if (!isTRUE(result$sanity_passed)) quit(status = 1)
