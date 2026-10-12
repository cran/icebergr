## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(icebergr)

## -----------------------------------------------------------------------------
tbl <- icebergr_example_table(rows = 200)

icebergr_schema(tbl)
icebergr_partitions(tbl)

## -----------------------------------------------------------------------------
icebergr_snapshots(tbl)[, c("snapshot_id", "operation", "added_records")]

## -----------------------------------------------------------------------------
plan <- icebergr_scan_plan(icebergr_scan(tbl))

# `data_file_path` is elided: it is an absolute path in a temporary
# warehouse, so it would differ on every machine.
plan[, c("record_count", "file_size_in_bytes")]

## ----eval = FALSE-------------------------------------------------------------
# tbl <- icebergr_reload(tbl) # now points at the newest snapshot

## -----------------------------------------------------------------------------
support <- icebergr_spec_support()
features <- support$features
head(features[
  !is.na(features$supported) & !features$supported,
  c("feature", "reason")
], 8)

