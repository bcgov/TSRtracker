
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `{TSRtracker}`

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

## Installation

You can install the development version of `{TSRtracker}` like so:

``` r
#remotes::install_github("bcgov/TSRtracker")
```

## Run

You can launch the application by running:

``` r
TSRtracker::run_app()
```

## About

You are reading the doc about version : 0.0.0.9000

This README has been compiled on the

``` r
Sys.time()
#> [1] "2025-05-02 12:46:25 PDT"
```

Here are the tests results and package coverage:

``` r
devtools::check(quiet = TRUE)
#> ℹ Loading TSRtracker
#> ── R CMD check results ────────────────────────────── TSRtracker 0.0.0.9000 ────
#> Duration: 42.4s
#> 
#> ❯ checking for future file timestamps ... NOTE
#>   unable to verify current time
#> 
#> ❯ checking top-level files ... NOTE
#>   File
#>     LICENSE
#>   is not mentioned in the DESCRIPTION file.
#> 
#> ❯ checking package subdirectories ... NOTE
#>   Problems with news in 'NEWS.md':
#>   No news entries found.
#> 
#> ❯ checking R code for possible problems ... NOTE
#>   get_tbls: no visible global function definition for 'unzip'
#>   Undefined global functions or variables:
#>     unzip
#>   Consider adding
#>     importFrom("utils", "unzip")
#>   to your NAMESPACE file.
#> 
#> 0 errors ✔ | 0 warnings ✔ | 4 notes ✖
```

``` r
covr::package_coverage()
#> TSRtracker Coverage: 57.14%
#> R/app_config.R: 0.00%
#> R/app_ui.R: 0.00%
#> R/run_app.R: 0.00%
#> R/utils_import_docx.R: 0.00%
#> R/golem_utils_server.R: 100.00%
#> R/golem_utils_ui.R: 100.00%
#> R/mod_page_dashboard.R: 100.00%
```
