# Combination dataset identity and public inputs

GDSC Matrix and GDSC Anchor refer to the GDSC² combination screens. Canonical filenames are `GDSC_MATRIX_PSet.rds` and `GDSC_ANCHOR_PSet.rds`. GDSC2 remains the ordinary single-agent screen, and its recuration is outside this task.

| Input | Current public source | State |
|---|---|---|
| Matrix physical-well response | https://ndownloader.figshare.com/files/45451363 | Downloaded, parsed and retained; published through GDSC² resources |
| Matrix screen summaries/metadata | https://gdsc-combinations.depmap.sanger.ac.uk/downloads (gdsc-007/008/009/010 and sandpiper-01 matrix_results) | Downloaded and used |
| Anchor original physical-well response | https://ndownloader.figshare.com/files/34010816 | Downloaded and normalized; source study Figshare project 117084 |
| Anchor validation physical-well response | https://ndownloader.figshare.com/files/34010828 | Downloaded and normalized |
| Anchor cell/MSI annotations | Jaaks Supplementary Table 2, DOI 10.1038/s41586-022-04437-2 | Downloaded; COSMIC mapping audited |
| RNA-seq | https://cog.sanger.ac.uk/cmp/download/rnaseq_all_20220624.zip | Processed public matrix already imported; source lab and numeric scale audited |
| CNV | https://cog.sanger.ac.uk/cmp/download/WES_pureCN_CNV_genes_20221213.zip | Processed public matrix imported |
| Variants | https://cog.sanger.ac.uk/cmp/download/mutations_all_20230202.zip | Processed public variant table imported; Sanger subset |
| Fusions | https://cog.sanger.ac.uk/cmp/download/Fusions_20230725.zip | Processed public table imported |
| Model/gene mapping | CMP model_list_latest.csv.gz and gene_identifiers_latest.csv.gz | Downloaded bytes/checksums recorded; latest URLs are mutable |

The GDSC² portal/linked Figshare supplies combination measurements; Sanger/CMP supplies molecular inputs. These are covered by configuration and download receipts. Upstream response/source tables are distinct from CEL/FASTQ-level molecular measurements. No raw sequencing or CEL acquisition is enabled by this source audit.

Expression uses the configured CMP 2022 RNA-seq release on its stored FPKM, TPM and read-count scales. Microarray is excluded from the current PSet and workflow. The original RNA-seq archive and molecular mapping inputs have expected SHA-256 checksums in configuration. No legacy GDSC PSet is a production input.
