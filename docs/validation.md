# Validation status

Full fitting, synergy, assembly, reloaded-object QC and the strengthened full observed-score/foreign-key checks passed. The current RDS SHA256 is `0cf27a6d0c722dda82a2daa26e9ce98c94a2ba6e56095398504c8f9ecf09b5f2`.

| Check | Result |
|---|---|
| PharmacoGx PR178 installed | PASS: 3.14.1, `28c58707eece80086bee75d8ef0e8afae96389ca` |
| CoreGx installed | PASS: 2.7.3, `bf6d814abd3dc0fc98f9f419f430cc6473046cb2` |
| Full public response import | PASS: 3,915,245 source dose/well observations, 755 sample IDs, 46 treatment IDs |
| Full sample/compound annotation | PASS; unmapped/ambiguous matches are audited |
| Full molecular import | PASS for ten CMP assays; microarray is excluded |
| Actual-source integration subset | PASS: 119 observations through fitting, synergy and PSet assembly |
| Subset RDS round trip | PASS: valid object, explicit dose units, E0/Rsquare, AUC + AAC = 1 |
| Complete workflow dry-run | PASS |
| Full-scale PSet and full QC | PASS: saved full RDS reloads and validates; 3,915,245 physical wells, 755 samples, 37 named treatments representing 46 source IDs, 10 molecular assays |

All 168,110 monotherapy fits reported optimizer success. Median finite R-square is 0.8732; 41,486 fits have R-square below 0.5 and 4,335 have undefined R-square. These are review flags, particularly for flat curves, rather than automatic exclusions. All IC50/AAC values are finite and no AAC lies outside [0,1]. AnnotationDB maps 700/755 samples and 32/46 treatments; misses are exported for review. Molecular coverage varies by assay (692–752 samples).

The final artifact is `data/results/GDSC_MATRIX_PSet.rds`; [full QC](pset_qc.html) and TSV exports accompany it. The RDS contains 3,915,245 raw rows, 3,915,245 derived synergy contexts and 84,055 combination profiles. Source wells and stable IDs are retained. The full build used the repo-local observed-index adapter after the standard CoreGx constructor exceeded R's 16 GiB vector limit; the adapter matches the standard constructor on tested sparse fixtures.

The tested MCP revision is the fixed SHA recorded above, not a moving branch head. Logs, exact dependency manifests, source receipts and the remote-head verification are in `data/procdata/metadata`.

Verification covered a clean macOS ARM64 installation of the shared dependency lock, each dataset’s setup checks, all four isolated workflow graphs, access to every configured source URL, and selected fresh download/extraction stages. The fresh HMCL response stage reproduced all 904,376 observations and its sample, treatment and published-profile tables exactly. Full fitting and end-to-end regeneration of all four PSets were not repeated; current final objects retain their previously verified fitted measurements.

The retired CEL-derived microarray layer is excluded from the active PSet and workflow. The ten retained CMP assays keep their original values and sample/feature mappings.


## Conformance and remaining work

The ADAPT static check has no failures. Remaining warnings cover intentionally deferred template/publishing/release automation and full-run artifacts. This implementation keeps the user's minimal four-repository setup; no documentation site, release automation or container workflow was added. Pixi is the requested environment manager. The static checker does not prove numerical concordance or full-run success.

Review fit/annotation coverage, full QC and numerical correspondence to the reference pipelines, and independently validate a clean environment before release. Nothing has been uploaded to ORCESTRA.


## Source-well validation

Rebuilt and reloaded both GDSC actual-source subset PSets after separating source wells from derived assays. Checked exact source-well counts and imported values, score formulas, matched mono-fit fields, and object validity. Both updated HTML QC reports rendered; both workflow dry-runs passed. Full source-well keys are unique (3,915,245 Matrix and 3,634,666 Anchor wells). The full Matrix artifact and QC now supersede the subset for scale validation; subset tests remain useful evidence for source-value preservation and constructor equivalence.

## Score and grid coverage

Of 84,055 combination profiles, 70,920 meet the strict 7×7 grid flag and 13,135 have other dose grids; reduced source grids are retained. Mean observed HSA and Bliss are present for every profile. Mean Loewe under the explicit E0=1 model is missing for 16,842 profiles (20.0%); these values are not imputed. Review this coverage and the model assumption before using Loewe comparisons.

## Consumer compatibility and published-score audit

Molecular assay type annotations were added without changing values, units, identifiers or the TRE. The pre-correction RDS is preserved under `data/procdata/artifact_history/`; checksums are in `data/procdata/metadata/molecular_annotation_artifact_versions.tsv`. The corrected serialized artifact passed full QC. A current-MCP `drugSensitivitySig` API probe on 735 samples passed using explicit numeric `sProfiles`, with all descriptive profile fields retained. This was an API check, not replication of a biological benchmark or the peer RNA normalization.

Across all 3,915,245 wells, published HSA/Bliss scores reconstruct from published fitted monotherapy references within 2.2e-15. Current PR178 fitted scores have mean absolute differences of 0.0618 (HSA) and 0.0699 (Bliss) from those published values; 111,970 and 150,825 wells respectively differ by more than 0.2. Largest-difference contexts are exported for review. In the largest HSA example the new mono fit follows the observed response much more closely than the published reference, so these differences should not be assumed ingestion errors. Full fit-level equivalence to the original publication is not asserted.

## Exact validation environment

Validation uses the isolated Pixi R library with PharmacoGx 3.14.1 (`28c58707eece80086bee75d8ef0e8afae96389ca`) and CoreGx 2.7.3 (`bf6d814abd3dc0fc98f9f419f430cc6473046cb2`). Setup verifies all locked R dependencies and rejects global libraries or mismatched revisions.

Generated validation metadata records code/config fingerprints and source receipts alongside the artifact. These records are excluded from Git.

## Portable artifact verification

Local package-description paths and absolute BLAS/LAPACK installation paths were removed from the public annotation while retaining package versions, GitHub SHAs and library basenames. All response, molecular, sample and treatment slots were verified unchanged. The final RDS was reloaded and passed QC. `data/procdata/metadata/artifact_versions.tsv` records current and preserved-artifact checksums.

## Scientific QC expansion

The first expanded full-data render passed all structural/source-identity assertions. Published versus current fitted synergy was compared on all 3,915,245 matched dose contexts: HSA Pearson 0.77577, Spearman 0.70034, MAE 0.06179 and mean bias −0.01536; Bliss Pearson 0.70710, Spearman 0.62675, MAE 0.06985 and mean bias −0.02104. Scores use viability fractions. Published-score formulas reconstruct to floating-point tolerance with source mono fits, so the remaining differences concern fitted models rather than an identified import mismatch.

Whole-matrix mean comparisons (84,055 contexts) are separately labelled as derived from the published well scores, not published best-window scores. The report includes coverage/missingness, difference-versus-mean plots, named outliers, response/synergy surfaces, expression coverage and an exploratory equally weighted per-cell pair ranking. Plot samples are bounded; statistics use all matching contexts. The final refresh completed at 19:47 UTC: 27 HTML tables and 16 embedded figures. Corrected expression-distribution and representative response plots were visually inspected. No fits or PSet bytes were changed. Browser file:// access was denied by policy, so complete browser layout was not inspected; HTML structure and generated PNGs were checked instead.

## Constructor-key hazard review

A separate synthetic test reproduced entity-only-key record collapse on the exact intended PR178 dependency pair. This pipeline uses explicit dose and technical-context dimensions. The current saved PSet passed all 23 exact pre-constructor-source-to-object checks across 3,915,245 rows, including key uniqueness, identifiers and every retained numeric source measurement. No constructor-related record or value loss was detected. The regression fixture also rejects deliberately collapsed records and altered values. These checks are now part of full QC; they do not substitute for upstream normalization or scientific model validation. Details are in `data/procdata/metadata/source_roundtrip.tsv`.

## Returned-curve fit quality

All 168,110 monotherapy contexts passed reconstruction of the actual fitting inputs and dose-count checks. There are 163,775 finite R² pairs and 4,335 undefined flat-response cases. Because the pinned package computes reported R² before returning clipped asymptotes, 50,171 contexts differ from the returned curve by more than 1e-8, with maximum absolute difference 0.5022957226. All 83,784 interior-parameter contexts agree within numerical precision. In 897 contexts the returned variance R² falls below 0.5 although reported R² is at least 0.5. Counts below 0.5 are 41,486 reported, 42,383 returned variance R² and 44,630 returned SSE/SST R². These are review flags and do not exclude records.

The report exports `docs/qc-data/returned-fit-quality.tsv` with the context keys, stored parameters, dose support and both quality definitions. The variance statistic removes constant residual bias; SSE/SST retains it. Parameters, checkpoints and the PSet remain unchanged.
