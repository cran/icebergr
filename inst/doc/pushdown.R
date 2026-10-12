## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(icebergr)

## -----------------------------------------------------------------------------
tbl <- icebergr_example_table(rows = 200)

## -----------------------------------------------------------------------------
all_files <- icebergr_scan_plan(icebergr_scan(tbl))
hot_files <- icebergr_scan_plan(icebergr_scan(tbl, filter = id > 1000))

nrow(all_files)
nrow(hot_files)

## -----------------------------------------------------------------------------
all_files[, c("record_count", "file_size_in_bytes")]
hot_files[, c("record_count", "file_size_in_bytes")]

## -----------------------------------------------------------------------------
nrow(icebergr_scan_plan(icebergr_scan(tbl, filter = id > 10^6)))

## -----------------------------------------------------------------------------
narrow <- icebergr_collect(
  icebergr_scan(tbl, select = c("id", "amount"), limit = 3)
)
narrow

## -----------------------------------------------------------------------------
icebergr_collect(
  icebergr_scan(tbl,
    filter = event %in% c("purchase", "refund") & amount > 900,
    select = c("event", "amount"), limit = 5
  )
)

## -----------------------------------------------------------------------------
threshold <- 950
icebergr_collect(
  icebergr_scan(tbl, filter = amount > threshold, select = "amount", limit = 3)
)

## -----------------------------------------------------------------------------
nrow(icebergr_scan_plan(icebergr_scan(tbl, limit = 1)))

## -----------------------------------------------------------------------------
features <- icebergr_spec_support()$features
features[
  grepl("decimal|limit", features$feature, ignore.case = TRUE),
  c("feature", "supported", "reason")
]

## -----------------------------------------------------------------------------
icebergr_collect(icebergr_scan(tbl,
  select = "ID", case_sensitive = FALSE,
  limit = 2
))

## -----------------------------------------------------------------------------
sum(all_files$file_size_in_bytes)
sum(hot_files$file_size_in_bytes)

