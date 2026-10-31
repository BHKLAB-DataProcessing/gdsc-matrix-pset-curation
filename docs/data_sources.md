# GDSC Matrix data sources

Response measurements come from the published [Figshare well-statistics archive, article 25266697 version 2](https://figshare.com/articles/dataset/Results_recorded_for_each_well_in_7x7_matrix_experiments_for_all_screens/25266697): 3,915,245 well records across GDSC-007, GDSC-008, GDSC-009, GDSC-010 and Sandpiper-01. These are source-normalized well statistics, not untouched instrument output. The five GDSC combinations portal summaries supply sample/drug metadata and published reference results for 84,055 matrices. Source fitted scores remain separate from current fits and synergy. Equal source display names are merged into 37 treatment entries representing 46 original IDs; original IDs remain in response keys.

## Source files

| File | Role | Bytes | Download URL |
|---|---|---:|---|
| `gdsc-007_matrix_results.csv.gz` | processed matrix summary | 4240832 | [source](https://gdsc-combinations.depmap.sanger.ac.uk/downloads/gdsc-007/matrix_results) |
| `gdsc-008_matrix_results.csv.gz` | processed matrix summary | 4726121 | [source](https://gdsc-combinations.depmap.sanger.ac.uk/downloads/gdsc-008/matrix_results) |
| `gdsc-009_matrix_results.csv.gz` | processed matrix summary | 4365995 | [source](https://gdsc-combinations.depmap.sanger.ac.uk/downloads/gdsc-009/matrix_results) |
| `gdsc-010_matrix_results.csv.gz` | processed matrix summary | 2299653 | [source](https://gdsc-combinations.depmap.sanger.ac.uk/downloads/gdsc-010/matrix_results) |
| `sandpiper-01_matrix_results.csv.gz` | processed matrix summary | 418215 | [source](https://gdsc-combinations.depmap.sanger.ac.uk/downloads/sandpiper-01/matrix_results) |
| `matrix_well_stats_GDSC_007_010_plus_Spiper1.zip` | well-level source data | 241088863 | [source](https://ndownloader.figshare.com/files/45451363) |
| `Matrix_documentation.pdf` | documentation | 370819 | [source](https://gdsc-combinations.depmap.sanger.ac.uk/downloads/Matrix_documentation.pdf) |
| `Matrix_glossary.pdf` | documentation | 181578 | [source](https://gdsc-combinations.depmap.sanger.ac.uk/downloads/Matrix_glossary.pdf) |

## Executable sources and annotation

`config/pipeline.yaml` is the authoritative list of production/QC downloads and expected checksums. Reference-only files in the table need not be downloaded by production stages. Generated source receipts, mapping exclusions and API responses are stored under ignored `data/` directories. AnnotationDB live mode can change independently of measured data; replay mode verifies reviewed response hashes and fails on missing or changed responses. See the README for the exact replay limitation. Gene identifiers use the configured GENCODE reference; mapping does not realign or renormalize source measurements.

## Molecular sources

- RNA-seq counts/TPM/FPKM: <https://cog.sanger.ac.uk/cmp/download/rnaseq_all_20220624.zip>
- WES copy number: <https://cog.sanger.ac.uk/cmp/download/WES_pureCN_CNV_genes_20221213.zip>
- Mutations: <https://cog.sanger.ac.uk/cmp/download/mutations_all_20230202.zip>
- Driver annotations: <https://cog.sanger.ac.uk/cmp/download/driver_mutations_20221208.csv>
- Fusions: <https://cog.sanger.ac.uk/cmp/download/Fusions_20230725.zip>
- Sample/gene annotations: <https://cog.sanger.ac.uk/cmp/download/model_list_latest.csv.gz> and <https://cog.sanger.ac.uk/cmp/download/gene_identifiers_latest.csv.gz>

The ten retained CMP experiments comprise three RNA-seq matrices (FPKM, TPM and read counts), five CNV summaries, mutation and fusion data. The processed RNA-seq release is `rnaseq_all_20220624.zip`. Values and coverage are retained on their source scales. Microarray and CEL processing are excluded; neither a local microarray file nor an archived PSet is a production prerequisite. Mutable metadata endpoints are checksum-pinned. Gzip portal summaries use a decompressed-content hash because compression headers may vary.
