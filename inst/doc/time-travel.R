## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(icebergr)

## -----------------------------------------------------------------------------
tbl <- icebergr_example_table(rows = 200)

## -----------------------------------------------------------------------------
history <- icebergr_snapshots(tbl)
history[, c(
  "snapshot_id", "parent_snapshot_id", "operation", "added_records",
  "total_records"
)]

## -----------------------------------------------------------------------------
class(history$snapshot_id)

## -----------------------------------------------------------------------------
first <- history$snapshot_id[[1]]

nrow(icebergr_collect(icebergr_scan(tbl, snapshot_id = first)))
nrow(icebergr_collect(icebergr_scan(tbl)))

## -----------------------------------------------------------------------------
nrow(icebergr_scan_plan(icebergr_scan(tbl, snapshot_id = first)))
nrow(icebergr_scan_plan(icebergr_scan(tbl)))

## -----------------------------------------------------------------------------
icebergr_collect(
  icebergr_scan(tbl, as_of = history$timestamp[[1]], select = "id", limit = 3)
)

## -----------------------------------------------------------------------------
identical(
  icebergr_schema(tbl, snapshot_id = first)$name,
  icebergr_schema(tbl)$name
)

## -----------------------------------------------------------------------------
current <- icebergr_snapshots(tbl)
tbl2 <- icebergr_reload(tbl)
identical(nrow(icebergr_snapshots(tbl2)), nrow(current))

## -----------------------------------------------------------------------------
features <- icebergr_spec_support()$features
features[
  grepl("snapshot|maintenance", features$feature, ignore.case = TRUE),
  c("feature", "supported", "reason")
]

