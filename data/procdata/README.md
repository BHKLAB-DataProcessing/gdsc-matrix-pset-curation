# Processed intermediates

Expected files and current size:

| File | Current size |
|---|---:|
| `response.rds` | 134.06 MiB |
| `annotations.rds` | 0.02 MiB |
| `molecular_profiles.rds` | 267.08 MiB |
| `curve_response.rds` | Pending full run |
| `fitted_response.rds` | Pending full run |
| `microarray.rds` | Pending full run |

`extracted/` holds indexed source members; the GENCODE extraction keeps gene records only. `fit_checkpoints/` holds resumable RDS chunks. `metadata/` contains TSV mapping audits, manifests and validation logs. `microarray_cohort.rds` caches the full normalized CEL cohort with a source/package/code signature; it is regenerated on mismatch.
