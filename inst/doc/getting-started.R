## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
# Handles and catalogs print their `location:` / `warehouse:`, which is a
# temporary directory unique to whichever machine built this page. Printing it
# would bake that path into the shipped HTML, so it is replaced here.
show <- function(x) {
  writeLines(gsub(tempdir(), "<tempdir>", capture.output(print(x)), fixed = TRUE))
}

## ----setup--------------------------------------------------------------------
library(icebergr)

## -----------------------------------------------------------------------------
tbl <- icebergr_example_table(rows = 200)
show(tbl)

## -----------------------------------------------------------------------------
icebergr_schema(tbl)

## -----------------------------------------------------------------------------
icebergr_partitions(tbl)

## -----------------------------------------------------------------------------
icebergr_collect(icebergr_scan(tbl, limit = 5))

## -----------------------------------------------------------------------------
nrow(icebergr_collect(tbl))

## -----------------------------------------------------------------------------
icebergr_collect(
  icebergr_scan(
    tbl,
    filter = id > 1000 & amount > 900,
    select = c("id", "event", "amount")
  )
)

## -----------------------------------------------------------------------------
# The second append holds ids 1001 to 1200, so this keeps the last fifty.
threshold <- 1150
icebergr_collect(icebergr_scan(tbl, filter = id > threshold, select = "id"))

## ----error = TRUE-------------------------------------------------------------
try({
icebergr_collect(icebergr_scan(tbl, filter = sqrt(amount) > 10))
})

## -----------------------------------------------------------------------------
icebergr_scan_plan(icebergr_scan(tbl))[, c("record_count", "file_size_in_bytes")]

## -----------------------------------------------------------------------------
icebergr_scan_plan(icebergr_scan(tbl, filter = id > 1000))[, c("record_count")]

## -----------------------------------------------------------------------------
icebergr_scan(tbl, filter = id > 1000, limit = 10)

## -----------------------------------------------------------------------------
history <- icebergr_snapshots(tbl)
history[, c("snapshot_id", "operation", "added_records", "total_records")]

## -----------------------------------------------------------------------------
nrow(icebergr_collect(icebergr_scan(tbl, snapshot_id = history$snapshot_id[[1]])))

## -----------------------------------------------------------------------------
nrow(icebergr_collect(icebergr_scan(tbl, as_of = history$timestamp[[1]])))

## -----------------------------------------------------------------------------
icebergr_schema(tbl, snapshot_id = history$snapshot_id[[1]])

## -----------------------------------------------------------------------------
new_rows <- data.frame(
  id = c(9001L, 9002L),
  event = c("purchase", "refund"),
  amount = c(42.5, -12.25),
  day = as.Date(c("2024-07-01", "2024-07-02")),
  recorded_at = as.POSIXct(c("2024-07-01 09:00:00", "2024-07-02 10:30:00"), tz = "UTC")
)

tbl <- icebergr_append(tbl, new_rows)
nrow(icebergr_collect(tbl))

## ----error = TRUE-------------------------------------------------------------
try({
icebergr_append(tbl, transform(new_rows, unexpected = 1))
})

## -----------------------------------------------------------------------------
warehouse <- tempfile("warehouse")
dir.create(warehouse)

catalog <- icebergr_catalog("memory", warehouse = warehouse)
icebergr_create_namespace(catalog, "analytics")

measurements <- data.frame(
  sensor = character(),
  reading = double(),
  taken_at = as.POSIXct(character(), tz = "UTC")
)

sensors <- icebergr_create_table(catalog, "analytics.measurements", measurements)
icebergr_schema(sensors)

## -----------------------------------------------------------------------------
types <- data.frame(
  i = 1L,
  d = 1.5,
  s = "text",
  b = TRUE,
  day = as.Date("2024-01-01"),
  ts = as.POSIXct("2024-01-01 12:00:00", tz = "UTC"),
  f = factor("a", levels = c("a", "b"))
)

type_tbl <- icebergr_create_table(catalog, "analytics.types", types)
type_tbl <- icebergr_append(type_tbl, types)

vapply(icebergr_collect(type_tbl), function(x) class(x)[[1]], character(1))

## -----------------------------------------------------------------------------
support <- icebergr_spec_support()
support$spec_versions

## -----------------------------------------------------------------------------
features <- support$features
unsupported <- !is.na(features$supported) & !features$supported
features[unsupported, c("feature", "reason")]

