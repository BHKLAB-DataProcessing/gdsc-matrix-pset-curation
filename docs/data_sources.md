# GDSC Matrix data sources

Status: source review pending. This is a candidate registry, not an approved input manifest. `config/pipeline.yaml` is the source of truth for URLs and selected versions.

| Source | Version/release | URL / access | Format |
|---|---|---|---|
| GDSC 7x7 matrix well statistics | Figshare article 25266697 v2 | https://ndownloader.figshare.com/files/45451363 | ZIP containing five CSV files |
| GDSC raw molecular data and metadata | Unresolved | Unresolved | To be selected |

Direct Figshare URLs, where present, were recovered from historical local article metadata and have not been revalidated in this task. Confirm availability, licensing/access, exact release, raw-versus-derived status, expected files and checksums before adding download rules. HMCL and NCI direct URLs remain unset until exact assets are selected. Automatic direct downloads should be the first DAG stage wherever public access permits.

Review the five well-statistics CSVs, viability scale and source versus independently recomputed synergy. The legacy script borrows molecular profiles/metadata from GDSC2.rds; select raw sources for these components.

Expected generated output: `data/results/GDSC_MATRIX_PSet.rds` plus secondary TSV exports. No input files or generated PSets have been copied into this repo.

Legacy processing references (inspect before porting):
- `/Users/michael/Projects/BHKLab/PGx/Nikta PGX3 Curation/GDSC_sq_matrix_PSet_curation.R`
- `/Users/michael/Projects/BHKLab/PGx/Nikta PGX3 Curation/gdsc2_helpers.R`
- `/Users/michael/Projects/BHKLab/PGx/Nikta PGX3 Curation/scripts/update_gdsc2_matrix_fitted_synergy.R`
