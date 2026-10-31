# Reference: Nikta PGX3 Curation/GDSC_sq_matrix_PSet_curation.R.
source("workflow/scripts/common.R")
files <- source_files("matrix_well_stats", "combo_well_stats.*\\.csv$")
x <- rbindlist(lapply(files, function(path) {
  part <- fread(path)
  part[, source_file := basename(path)]
  part
}), use.names=TRUE)
require_columns(x, c("lib1_drug_id", "lib2_drug_id", "lib1_conc", "lib2_conc", "inhibition", "BARCODE", "POSITION"))
samples <- unique(x[, .(sampleid=as.character(MASTER_CELL_ID), sample_name=CELL_LINE_NAME,
                        tissueid=TISSUE, COSMIC_ID=as.character(COSMIC_ID))])
samples <- samples[, lapply(.SD, collapse_text), by=sampleid]
summaries <- rbindlist(lapply(members[grepl("_summary$", source_id), path], fread), fill=TRUE)
drugs <- unique(rbind(summaries[, .(treatmentid=as.character(lib1_ID), treatment_name=lib1_name,
                                   target=lib1_target, pathway=lib1_pathway)],
                      summaries[, .(treatmentid=as.character(lib2_ID), treatment_name=lib2_name,
                                    target=lib2_target, pathway=lib2_pathway)]))
drugs <- drugs[!is.na(treatmentid), lapply(.SD, collapse_text), by=treatmentid]
sample_models <- unique(summaries[, .(sampleid=as.character(MASTER_CELL_ID), model_id=SIDM)])
if (anyDuplicated(sample_models$sampleid)) stop("Conflicting sample/model IDs in matrix summaries")
samples <- merge(samples, sample_models, by="sampleid", all.x=TRUE)
write_tsv(summaries, "published_matrix_profiles")
long <- x[, .(sampleid=as.character(MASTER_CELL_ID), treatment1id=as.character(lib1_drug_id),
  treatment2id=as.character(lib2_drug_id), treatment1dose=lib1_conc, treatment2dose=lib2_conc,
  dose_unit="uM", viability=1-inhibition, intensity=INTENSITY,
  viability_1=1-lib1_y, viability_2=1-lib2_y,
  viability_1_fitted_published=1-lib1_yhat, viability_2_fitted_published=1-lib2_yhat,
  hsa_published=HSA, hsa_excess_published=HSA_excess,
  bliss_published=Bliss_additivity, bliss_excess_published=Bliss_excess,
  plateid=as.character(BARCODE), tech_rep=paste(PROJECT_ID, PROJECT_NAME, BARCODE, sep="_"),
  wellid=as.character(POSITION), matrixid=as.character(cmatrix))]
long <- canonical_response(long)
save_rds(list(response=long, sample=samples, treatment=drugs), "data/procdata/response.rds")
