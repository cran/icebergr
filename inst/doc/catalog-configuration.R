## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  # Connection recipes cannot be executed here: they need catalog servers and
  # credentials, and a vignette that reaches the network is neither reproducible
  # nor permitted on CRAN.
  eval = FALSE
)

## -----------------------------------------------------------------------------
# library(icebergr)

## -----------------------------------------------------------------------------
# Sys.setenv(ICEBERGR_REST_TOKEN = "...") # better: set this in ~/.Renviron
# 
# catalog <- icebergr_catalog(
#   "rest",
#   uri = "https://catalog.example.com/api/catalog",
#   warehouse = "analytics"
# )
# 
# icebergr_list_namespaces(catalog)
# icebergr_list_tables(catalog, "analytics")

## -----------------------------------------------------------------------------
# Sys.setenv(
#   ICEBERGR_REST_CREDENTIAL = "client_id:client_secret",
#   ICEBERGR_REST_OAUTH2_SERVER_URI = "https://auth.example.com/oauth/token",
#   ICEBERGR_REST_SCOPE = "catalog"
# )
# 
# catalog <- icebergr_catalog("rest", uri = "https://catalog.example.com")

## -----------------------------------------------------------------------------
# catalog <- icebergr_catalog(
#   "rest",
#   uri = "https://catalog.example.com",
#   `rest.signing-region` = "us-east-1",
#   `rest.sigv4-enabled` = "true"
# )

## -----------------------------------------------------------------------------
# "s3" %in% icebergr_spec_support()$cargo_features

## -----------------------------------------------------------------------------
# Sys.setenv(
#   ICEBERGR_S3_ACCESS_KEY_ID = "...",
#   ICEBERGR_S3_SECRET_ACCESS_KEY = "...",
#   ICEBERGR_S3_REGION = "us-east-1"
# )
# 
# catalog <- icebergr_catalog(
#   "rest",
#   uri = "https://catalog.example.com",
#   storage = "s3"
# )

## -----------------------------------------------------------------------------
# Sys.setenv(
#   ICEBERGR_S3_ENDPOINT = "https://minio.internal:9000",
#   ICEBERGR_S3_ACCESS_KEY_ID = "...",
#   ICEBERGR_S3_SECRET_ACCESS_KEY = "..."
# )
# 
# catalog <- icebergr_catalog(
#   "rest",
#   uri = "https://catalog.internal/api/catalog",
#   storage = "s3",
#   `s3.path-style-access` = "true"
# )

## -----------------------------------------------------------------------------
# catalog <- icebergr_catalog(
#   "glue",
#   warehouse = "s3://my-bucket/warehouse",
#   `glue.region` = "us-east-1"
# )
# 
# icebergr_list_namespaces(catalog)

## -----------------------------------------------------------------------------
# warehouse <- "/data/warehouse"
# catalog <- icebergr_catalog("memory", warehouse = warehouse)
# 
# icebergr_create_namespace(catalog, "db")
# tbl <- icebergr_create_table(catalog, "db.events", data.frame(id = integer()))

## -----------------------------------------------------------------------------
# catalog <- icebergr_catalog("memory", warehouse = "/data/warehouse")
# icebergr_create_namespace(catalog, "db")
# 
# tbl <- icebergr_register_table(
#   catalog, "db.events",
#   "/data/warehouse/db/events/metadata/00003-....metadata.json"
# )

