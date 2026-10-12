## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(icebergr)
# Handles and catalogs print their `location:` / `warehouse:`, which is a
# temporary directory unique to whichever machine built this page. Printing it
# would bake that path into the shipped HTML, so it is replaced here.
show <- function(x) {
  writeLines(gsub(tempdir(), "<tempdir>", capture.output(print(x)), fixed = TRUE))
}

## -----------------------------------------------------------------------------
warehouse <- file.path(tempdir(), "icebergr-writing")
dir.create(warehouse, showWarnings = FALSE)

catalog <- icebergr_catalog("memory", warehouse = warehouse)
show(catalog)

## -----------------------------------------------------------------------------
icebergr_create_namespace(catalog, "shop")
icebergr_list_namespaces(catalog)

## -----------------------------------------------------------------------------
template <- data.frame(
  id = integer(),
  item = character(),
  amount = double(),
  day = as.Date(character())
)

orders <- icebergr_create_table(catalog, "shop.orders", template)
show(orders)

## -----------------------------------------------------------------------------
orders <- icebergr_append(orders, data.frame(
  id = 1:3,
  item = c("mug", "kettle", "mug"),
  amount = c(9.5, 42, 9.5),
  day = as.Date("2026-07-01") + 0:2
))

icebergr_collect(orders)

## -----------------------------------------------------------------------------
orders <- icebergr_append(orders, data.frame(
  id = 4L, item = "cafetiere", amount = 24.5, day = as.Date("2026-07-04")
))

icebergr_snapshots(orders)[, c("operation", "added_records", "total_records")]

## -----------------------------------------------------------------------------
orders <- icebergr_append(
  orders,
  data.frame(id = 5L, item = "grinder", amount = 60, day = as.Date("2026-07-05")),
  compression = "snappy"
)

nrow(icebergr_collect(orders))

## ----eval = FALSE-------------------------------------------------------------
# icebergr_register_table(
#   catalog, "shop.archive",
#   file.path(warehouse, "shop/archive/metadata/00007-8b1c….metadata.json")
# )

## -----------------------------------------------------------------------------
features <- icebergr_spec_support()$features
writes <- grepl("append|delete|merge|overwrite|partition|propert",
  features$feature,
  ignore.case = TRUE
)
features[
  writes & !is.na(features$supported) & !features$supported,
  c("feature", "reason")
]

## -----------------------------------------------------------------------------
icebergr_table_exists(catalog, "shop.orders")
icebergr_table_exists(catalog, "shop.nothing_here")

icebergr_list_tables(catalog, "shop")

## -----------------------------------------------------------------------------
icebergr_properties(orders)

