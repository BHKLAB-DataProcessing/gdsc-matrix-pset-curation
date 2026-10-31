# Consumer-facing assay type; source units and all values remain unchanged.
annotate_molecular_types <- function(profiles) {
  for (name in names(profiles)) {
    annotation <- name
    S4Vectors::metadata(profiles[[name]])$annotation <- annotation
  }
  profiles
}
