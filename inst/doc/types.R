## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(icebergr)

# bit64 and vctrs are in Suggests; guard the chunks that need them so this
# vignette builds on any installation.
has_bit64 <- requireNamespace("bit64", quietly = TRUE)
has_vctrs <- requireNamespace("vctrs", quietly = TRUE)

## -----------------------------------------------------------------------------
warehouse <- file.path(tempdir(), "icebergr-types")
dir.create(warehouse, showWarnings = FALSE)
catalog <- icebergr_catalog("memory", warehouse = warehouse)
icebergr_create_namespace(catalog, "t")

## -----------------------------------------------------------------------------
plain <- data.frame(
  i = 1L,
  d = 1.5,
  s = "text",
  b = TRUE,
  day = as.Date("2026-07-01"),
  ts = as.POSIXct("2026-07-01 09:00:00", tz = "UTC")
)

tbl <- icebergr_create_table(catalog, "t.plain", plain)
icebergr_schema(tbl)[, c("name", "type")]

## -----------------------------------------------------------------------------
tbl <- icebergr_append(tbl, plain)
back <- icebergr_collect(tbl)
vapply(back, function(x) class(x)[[1]], character(1))
identical(back$s, plain$s)
identical(back$day, plain$day)

## -----------------------------------------------------------------------------
nan_tbl <- icebergr_create_table(catalog, "t.nan", data.frame(x = 1.5))
nan_tbl <- icebergr_append(nan_tbl, data.frame(x = c(1.5, NaN, NA)))
icebergr_collect(nan_tbl)$x

## -----------------------------------------------------------------------------
fac_tbl <- icebergr_create_table(
  catalog, "t.fac",
  data.frame(g = factor("a", levels = c("a", "b")))
)
fac_tbl <- icebergr_append(fac_tbl, data.frame(g = factor(c("a", "b", "a"))))
str(icebergr_collect(fac_tbl)$g)

## ----eval = has_bit64---------------------------------------------------------
big <- bit64::as.integer64("9007199254740993") # 2^53 + 1
long_tbl <- icebergr_create_table(catalog, "t.long", data.frame(n = big))
long_tbl <- icebergr_append(long_tbl, data.frame(n = big))

got <- icebergr_collect(long_tbl)$n
class(got)
as.character(got)

## ----eval = has_bit64---------------------------------------------------------
identical(as.character(got), "9007199254740993")

## -----------------------------------------------------------------------------
nested <- data.frame(id = 1L)
nested$geo <- data.frame(lat = 41.79, lon = -87.6)

nest_tbl <- icebergr_create_table(catalog, "t.nested", nested)
icebergr_schema(nest_tbl)[, c("name", "type")]

## -----------------------------------------------------------------------------
nest_tbl <- icebergr_append(nest_tbl, nested)
got <- icebergr_collect(nest_tbl)
class(got$geo)
got$geo$lat

## ----eval = has_vctrs---------------------------------------------------------
lst <- data.frame(id = 1L)
lst$tags <- vctrs::list_of(c("a", "b"))

lst_tbl <- icebergr_create_table(catalog, "t.lst", lst)
lst_tbl <- icebergr_append(lst_tbl, lst)
icebergr_collect(lst_tbl)$tags

## -----------------------------------------------------------------------------
subset(icebergr_collect(nest_tbl), geo$lat > 41)

## -----------------------------------------------------------------------------
icebergr_schema(nest_tbl)

