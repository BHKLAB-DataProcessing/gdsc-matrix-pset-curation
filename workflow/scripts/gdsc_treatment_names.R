# Canonical display names group treatment metadata only. Original screen IDs
# stay in every TRE row key, so equal names never pool observations or fits.
gdsc_source_assay_keys <- function(t) {
  intern <- CoreGx::mutable(t@.intern)
  intern$assayKeys <- lapply(intern$assayKeys,function(keys) {
    keys <- as.character(keys)
    unique(c(keys,paste0(intersect(c('treatment1id','treatment2id'),keys),'_source')))
  })
  t@.intern <- CoreGx::immutable(intern)
  t
}

name_gdsc_treatments <- function(p) {
  if (!is.null(p@annotation$source_treatment_metadata)) {
    p@treatmentResponse <- gdsc_source_assay_keys(p@treatmentResponse)
    methods::validObject(p@treatmentResponse);methods::validObject(p)
    return(p)
  }
  original <- p@treatment
  labels <- trimws(as.character(original$treatment_name))
  missing <- is.na(labels) | !nzchar(labels)
  labels[missing] <- as.character(original$treatmentid[missing])
  labels <- gsub('|','///',labels,fixed=TRUE)
  mapping <- setNames(labels,as.character(original$treatmentid))
  t <- p@treatmentResponse
  rd <- data.table::copy(t@rowData)
  for (field in c('treatment1id','treatment2id')) {
    raw <- as.character(rd[[field]])
    named <- unname(mapping[raw])
    stopifnot(!any(!is.na(raw) & is.na(named)))
    data.table::set(rd,j=paste0(field,'_source'),value=raw)
    data.table::set(rd,j=field,value=named)
  }
  oldkeys <- as.character(t@.intern$rowIDs)
  intern <- CoreGx::mutable(t@.intern)
  intern$rowIDs <- unique(c(oldkeys,'treatment1id_source','treatment2id_source'))
  t@.intern <- CoreGx::immutable(intern)
  rd[, .rownames := do.call(paste,c(.SD,sep=':')), .SDcols=as.character(t@.intern$rowIDs)]
  stopifnot(!anyDuplicated(rd,by=as.character(t@.intern$rowIDs)),!anyDuplicated(rd$.rownames))
  t@rowData <- rd
  t <- gdsc_source_assay_keys(t)
  combine <- function(d) {
    d$treatmentid_dataset <- as.character(d$treatmentid)
    d$treatmentid <- unname(mapping[d$treatmentid])
    if ('treatment_name' %in% names(d)) d$treatment_name <- d$treatmentid
    groups <- split(seq_len(nrow(d)),factor(d$treatmentid,levels=unique(d$treatmentid)))
    result <- lapply(groups,function(ii) {
      row <- d[ii[1],,drop=FALSE]
      for(n in names(d)) {
        values <- unique(d[[n]][ii]); values <- values[!is.na(values)]
        if(is.character(values)) values <- values[nzchar(values)]
        if(length(values)>1L) {
          if(is.character(values)) row[[n]] <- paste(sort(values),collapse='///') else row[[n]] <- NA
        } else if(length(values)==1L) row[[n]] <- values
      }
      row
    })
    result <- do.call(rbind,result);rownames(result)<-result$treatmentid;result
  }
  p@treatment <- combine(original)
  p@curation$treatment <- combine(p@curation$treatment)
  p@treatmentResponse <- t
  p@annotation$source_treatment_metadata <- original
  p@annotation$treatment_naming <- list(
    policy='Group identical source display names; retain source IDs in response keys and treatmentid_dataset; no measurement aggregation',
    source_to_name=data.frame(treatmentid_source=names(mapping),treatmentid=unname(mapping)))
  stopifnot(setequal(p@treatment$treatmentid,unique(labels)))
  methods::validObject(t);methods::validObject(p)
  p
}

name_gdsc_response_table <- function(x,mapping) {
  x <- data.table::copy(x)
  for(field in intersect(c('treatment1id','treatment2id'),names(x))) {
    raw <- as.character(x[[field]])
    named <- unname(mapping[raw])
    stopifnot(!any(!is.na(raw)&is.na(named)))
    data.table::set(x,j=paste0(field,'_source'),value=raw)
    data.table::set(x,j=field,value=named)
  }
  x
}
