# Development decisions

See [processing decisions](implementation.md), [source provenance](data_sources.md) and [validation](validation.md). Dependencies and source checksums are pinned; generated data and diagnostic artifacts remain outside Git.

## preserve source wells and separate derived assays

`raw` retains each imported physical-well measurement using the source `wellid`,
with no averaging across wells. `synergy` holds derived dose-context measurements
and scores; its `n_observations` records the number of imported wells averaged.
`profiles` summarizes combination contexts and includes matched mono fit metrics
with `_1`/`_2` suffixes. The independent `monotherapy_profiles` assay is retained.
Scores remain explicitly labelled observed/fitted and, where applicable, E0=1.
Source identifiers remain in response keys; treatments with the same source display name share a metadata entry.
Flat `sensitivity.tsv` now mirrors source wells; `synergy.tsv` holds derived values.
This is an assay-layout correction and does not change curve-fitting inputs.

### Observed-well indexing

CoreGx 2.7.3 builds a Cartesian row/column index before removing unobserved cells, exceeding the 16 GiB R vector limit for the full Matrix screen. The repo-local `construct_observed_tre.R` adapter constructs the equivalent raw-assay index from observed physical wells. It preserves the CoreGx object layout and is checked against the standard constructor, including missing identifiers, repeated doses, and subsequent assay assignment. No response measurements or fit definitions change. Recheck equivalence when upgrading CoreGx.

`pixi run setup` now runs `workflow/tests/test_observed_tre.R` after package installation. This checks exact object equivalence to the installed CoreGx public constructor and assay assignment, so a future dependency change cannot silently bypass this compatibility check.

### Molecular assay type annotations

Assembly sets each molecular experiment's `metadata$annotation` to its explicit assay type; RNA-seq expression keeps its `rnaseq.*` annotation. This is required by the current MCP `drugSensitivitySig` consumer. Source values and units are unchanged. Proteomics, methylation and heterogeneous DTP experiments retain their true types even though that consumer does not currently support all of them. Use explicit numeric `sProfiles` for combination-response analyses; do not delete descriptive profile fields merely to make a consumer run.

Package-description installation paths (`file` attributes and `LibPath`) are removed from the public object annotation. Package versions and GitHub revisions remain intact, and full local session/package manifests are retained outside the RDS under `data/procdata/metadata`. QC checks that the serialized annotation is already portable.


## Reference-object comparison

The mapped GDSC Matrix reference in the previously curated reference collection contains 755 samples, 37 named treatments and 46 preserved source drug IDs. All 46 IDs map consistently into the response tables; nine name groups contain two IDs. No response-name conflicts or orphan treatment IDs were found. The sample mapping is one-to-one across all 755 source IDs.

After matching sample, raw drug IDs, doses, technical context, plate, matrix and physical-well position, all 3,915,245 keys and ten retained source measurements agree exactly, including missingness. Observed HSA and Bliss means agree exactly for all 84,055 combination profiles. Fitted mean Bliss differs in all profiles (MAE 0.03202175; maximum absolute difference 0.2526797); fitted equivalence is not claimed. Source-ID preservation and name collapsing are separate policy choices: the current object retains 46 source treatments with readable annotations rather than silently combining them into 37 names.

The reference has historical `rna` microarray (17,611 features, 748 samples) and Kallisto RNA-seq (60,662 features, 303 samples), while this object has `microarray.rma` (17,055 features, 751 samples) and CMP 2022 RNA-seq (36,998 features, 752 samples). These are distinct processed inputs; a naming map does not establish expression equivalence.

## Current treatment and expression scope

Treatments with identical source display names share one metadata entry. Every original treatment ID remains in `treatmentid_dataset` and in source-specific TRE row keys; all response measurements, fitted values and assay indices remain unchanged. Matrix has 37 named treatments from 46 source IDs; Anchor has 68 distinct source names, including its component mixtures. The ten original CMP molecular assays are retained unchanged. The CEL-derived microarray layer, its acquisition/processing scripts and its local prerequisites have been retired. Earlier microarray comparisons above describe the previous artifact, not a layer in the current PSet.
