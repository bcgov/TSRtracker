
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `TSRtracker`

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

## Installation

You can install the development version of `{TSRtracker}` like so:

``` r
remotes::install_github("bcgov/TSRtracker")
#> Using GitHub PAT from the git credential store.
#> Downloading GitHub repo bcgov/TSRtracker@HEAD
#> fs           (1.6.5    -> 1.6.6  ) [CRAN]
#> cli          (3.6.3    -> 3.6.5  ) [CRAN]
#> Rcpp         (1.0.13-1 -> 1.0.14 ) [CRAN]
#> sass         (0.4.9    -> 0.4.10 ) [CRAN]
#> bslib        (0.8.0    -> 0.9.0  ) [CRAN]
#> commonmark   (1.9.2    -> 1.9.5  ) [CRAN]
#> rlang        (1.1.4    -> 1.1.6  ) [CRAN]
#> later        (1.4.1    -> 1.4.2  ) [CRAN]
#> R6           (2.5.1    -> 2.6.1  ) [CRAN]
#> jsonlite     (1.8.9    -> 2.0.0  ) [CRAN]
#> mime         (0.12     -> 0.13   ) [CRAN]
#> httpuv       (1.6.15   -> 1.6.16 ) [CRAN]
#> curl         (6.0.1    -> 6.2.2  ) [CRAN]
#> units        (0.8-5    -> 0.8-7  ) [CRAN]
#> classInt     (0.4-10   -> 0.4-11 ) [CRAN]
#> utf8         (1.2.4    -> 1.2.5  ) [CRAN]
#> bit          (4.5.0.1  -> 4.6.0  ) [CRAN]
#> bit64        (4.5.2    -> 4.6.0-1) [CRAN]
#> pillar       (1.10.0   -> 1.10.2 ) [CRAN]
#> tzdb         (0.4.0    -> 0.5.0  ) [CRAN]
#> cpp11        (0.5.1    -> 0.5.2  ) [CRAN]
#> tinytex      (0.54     -> 0.57   ) [CRAN]
#> evaluate     (1.0.1    -> 1.0.3  ) [CRAN]
#> terra        (1.8-7    -> 1.8-42 ) [CRAN]
#> knitr        (1.49     -> 1.50   ) [CRAN]
#> xfun         (0.49     -> 0.52   ) [CRAN]
#> sp           (2.1-4    -> 2.2-0  ) [CRAN]
#> scales       (1.3.0    -> 1.4.0  ) [CRAN]
#> raster       (3.6-30   -> 3.6-32 ) [CRAN]
#> stringi      (1.8.4    -> 1.8.7  ) [CRAN]
#> sf           (1.0-19   -> 1.0-20 ) [CRAN]
#> purrr        (1.0.2    -> 1.0.4  ) [CRAN]
#> xml2         (1.3.6    -> 1.3.8  ) [CRAN]
#> shinydash... (0.7.2    -> 0.7.3  ) [CRAN]
#> RPostgreSQL  (0.7-7    -> 0.7-8  ) [CRAN]
#> ggplot2      (3.5.1    -> 3.5.2  ) [CRAN]
#> data.table   (1.16.4   -> 1.17.0 ) [CRAN]
#> Installing 37 packages: fs, cli, Rcpp, sass, bslib, commonmark, rlang, later, R6, jsonlite, mime, httpuv, curl, units, classInt, utf8, bit, bit64, pillar, tzdb, cpp11, tinytex, evaluate, terra, knitr, xfun, sp, scales, raster, stringi, sf, purrr, xml2, shinydashboard, RPostgreSQL, ggplot2, data.table
#> 
#>   There is a binary version available but the source version is later:
#>             binary source needs_compilation
#> RPostgreSQL  0.7-7  0.7-8              TRUE
#> 
#> package 'fs' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'fs'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\fs\libs\x64\fs.dll to
#> C:\Data\localApps\R-4.4.2\library\fs\libs\x64\fs.dll: Permission denied
#> Warning: restored 'fs'
#> package 'cli' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'cli'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\cli\libs\x64\cli.dll to
#> C:\Data\localApps\R-4.4.2\library\cli\libs\x64\cli.dll: Permission denied
#> Warning: restored 'cli'
#> package 'Rcpp' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'Rcpp'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\Rcpp\libs\x64\Rcpp.dll to
#> C:\Data\localApps\R-4.4.2\library\Rcpp\libs\x64\Rcpp.dll: Permission denied
#> Warning: restored 'Rcpp'
#> package 'sass' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'sass'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\sass\libs\x64\sass.dll to
#> C:\Data\localApps\R-4.4.2\library\sass\libs\x64\sass.dll: Permission denied
#> Warning: restored 'sass'
#> package 'bslib' successfully unpacked and MD5 sums checked
#> package 'commonmark' successfully unpacked and MD5 sums checked
#> package 'rlang' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'rlang'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\rlang\libs\x64\rlang.dll to
#> C:\Data\localApps\R-4.4.2\library\rlang\libs\x64\rlang.dll: Permission denied
#> Warning: restored 'rlang'
#> package 'later' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'later'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\later\libs\x64\later.dll to
#> C:\Data\localApps\R-4.4.2\library\later\libs\x64\later.dll: Permission denied
#> Warning: restored 'later'
#> package 'R6' successfully unpacked and MD5 sums checked
#> package 'jsonlite' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'jsonlite'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\jsonlite\libs\x64\jsonlite.dll to
#> C:\Data\localApps\R-4.4.2\library\jsonlite\libs\x64\jsonlite.dll: Permission
#> denied
#> Warning: restored 'jsonlite'
#> package 'mime' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'mime'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\mime\libs\x64\mime.dll to
#> C:\Data\localApps\R-4.4.2\library\mime\libs\x64\mime.dll: Permission denied
#> Warning: restored 'mime'
#> package 'httpuv' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'httpuv'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\httpuv\libs\x64\httpuv.dll to
#> C:\Data\localApps\R-4.4.2\library\httpuv\libs\x64\httpuv.dll: Permission denied
#> Warning: restored 'httpuv'
#> package 'curl' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'curl'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\curl\libs\x64\curl.dll to
#> C:\Data\localApps\R-4.4.2\library\curl\libs\x64\curl.dll: Permission denied
#> Warning: restored 'curl'
#> package 'units' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'units'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\units\libs\x64\units.dll to
#> C:\Data\localApps\R-4.4.2\library\units\libs\x64\units.dll: Permission denied
#> Warning: restored 'units'
#> package 'classInt' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'classInt'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\classInt\libs\x64\classInt.dll to
#> C:\Data\localApps\R-4.4.2\library\classInt\libs\x64\classInt.dll: Permission
#> denied
#> Warning: restored 'classInt'
#> package 'utf8' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'utf8'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\utf8\libs\x64\utf8.dll to
#> C:\Data\localApps\R-4.4.2\library\utf8\libs\x64\utf8.dll: Permission denied
#> Warning: restored 'utf8'
#> package 'bit' successfully unpacked and MD5 sums checked
#> package 'bit64' successfully unpacked and MD5 sums checked
#> package 'pillar' successfully unpacked and MD5 sums checked
#> package 'tzdb' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'tzdb'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\tzdb\libs\x64\tzdb.dll to
#> C:\Data\localApps\R-4.4.2\library\tzdb\libs\x64\tzdb.dll: Permission denied
#> Warning: restored 'tzdb'
#> package 'cpp11' successfully unpacked and MD5 sums checked
#> package 'tinytex' successfully unpacked and MD5 sums checked
#> package 'evaluate' successfully unpacked and MD5 sums checked
#> package 'terra' successfully unpacked and MD5 sums checked
#> package 'knitr' successfully unpacked and MD5 sums checked
#> package 'xfun' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'xfun'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\xfun\libs\x64\xfun.dll to
#> C:\Data\localApps\R-4.4.2\library\xfun\libs\x64\xfun.dll: Permission denied
#> Warning: restored 'xfun'
#> package 'sp' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'sp'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\sp\libs\x64\sp.dll to
#> C:\Data\localApps\R-4.4.2\library\sp\libs\x64\sp.dll: Permission denied
#> Warning: restored 'sp'
#> package 'scales' successfully unpacked and MD5 sums checked
#> package 'raster' successfully unpacked and MD5 sums checked
#> package 'stringi' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'stringi'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\stringi\libs\icudt74l.dat to
#> C:\Data\localApps\R-4.4.2\library\stringi\libs\icudt74l.dat: Invalid argument
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\stringi\libs\x64\stringi.dll to
#> C:\Data\localApps\R-4.4.2\library\stringi\libs\x64\stringi.dll: Permission
#> denied
#> Warning: restored 'stringi'
#> package 'sf' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'sf'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\sf\libs\x64\sf.dll to
#> C:\Data\localApps\R-4.4.2\library\sf\libs\x64\sf.dll: Permission denied
#> Warning: restored 'sf'
#> package 'purrr' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'purrr'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\purrr\libs\x64\purrr.dll to
#> C:\Data\localApps\R-4.4.2\library\purrr\libs\x64\purrr.dll: Permission denied
#> Warning: restored 'purrr'
#> package 'xml2' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'xml2'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\xml2\libs\x64\xml2.dll to
#> C:\Data\localApps\R-4.4.2\library\xml2\libs\x64\xml2.dll: Permission denied
#> Warning: restored 'xml2'
#> package 'shinydashboard' successfully unpacked and MD5 sums checked
#> package 'ggplot2' successfully unpacked and MD5 sums checked
#> package 'data.table' successfully unpacked and MD5 sums checked
#> Warning: cannot remove prior installation of package 'data.table'
#> Warning in file.copy(savedcopy, lib, recursive = TRUE): problem copying
#> C:\Data\localApps\R-4.4.2\library\00LOCK\data.table\libs\x64\data_table.dll to
#> C:\Data\localApps\R-4.4.2\library\data.table\libs\x64\data_table.dll:
#> Permission denied
#> Warning: restored 'data.table'
#> 
#> The downloaded binary packages are in
#>  C:\Users\klochhea\AppData\Local\Temp\Rtmpwt17df\downloaded_packages
#> installing the source package 'RPostgreSQL'
#> Warning in i.p(...): installation of package 'RPostgreSQL' had non-zero exit
#> status
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>          checking for file 'C:\Users\klochhea\AppData\Local\Temp\Rtmpwt17df\remotesa57c519299c\bcgov-TSRtracker-bb6378e/DESCRIPTION' ...  ✔  checking for file 'C:\Users\klochhea\AppData\Local\Temp\Rtmpwt17df\remotesa57c519299c\bcgov-TSRtracker-bb6378e/DESCRIPTION' (506ms)
#>       ─  preparing 'TSRtracker': (742ms)
#>    checking DESCRIPTION meta-information ...     checking DESCRIPTION meta-information ...   ✔  checking DESCRIPTION meta-information
#>       ─  checking for LF line-endings in source and make files and shell scripts (402ms)
#>   ─  checking for empty or unneeded directories
#>   ─  building 'TSRtracker_0.0.0.9000.tar.gz'
#>      
#> 
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
#> [1] "2025-05-08 13:35:27 PDT"
```

Here are the tests results and package coverage:

``` r
devtools::check(quiet = TRUE)
#> ℹ Loading TSRtracker
#> ── R CMD check results ────────────────────────────── TSRtracker 0.0.0.9000 ────
#> Duration: 1m 45s
#> 
#> ❯ checking for missing documentation entries ... WARNING
#>   Undocumented code objects:
#>     'data.tsrTracker'
#>   Undocumented data sets:
#>     'data.tsrTracker'
#>   All user-level objects in a package should have documentation entries.
#>   See chapter 'Writing R documentation files' in the 'Writing R
#>   Extensions' manual.
#> 
#> ❯ checking LazyData ... WARNING
#>     LazyData DB of 38.4 MB without LazyDataCompression set
#>     See §1.1.6 of 'Writing R Extensions'
#> 
#> ❯ checking for hidden files and directories ... NOTE
#>   Found the following hidden files and directories:
#>     .here
#>   These were most likely included in error. See section 'Package
#>   structure' in the 'Writing R Extensions' manual.
#> 
#> ❯ checking installed package size ... NOTE
#>     installed size is 42.2Mb
#>     sub-directories of 1Mb or more:
#>       app    3.8Mb
#>       data  38.4Mb
#> 
#> ❯ checking for future file timestamps ... NOTE
#>   unable to verify current time
#> 
#> ❯ checking top-level files ... NOTE
#>   File
#>     LICENSE
#>   is not mentioned in the DESCRIPTION file.
#>   Non-standard files/directories found at top level:
#>     'Dockerfile' 'LICENSE.md' 'README.Rmd' 'config.yml' 'dev'
#> 
#> ❯ checking package subdirectories ... NOTE
#>   Problems with news in 'NEWS.md':
#>   No news entries found.
#> 
#> ❯ checking dependencies in R code ... NOTE
#>   Unexported objects imported by ':::' calls:
#>     'shinydashboard:::tagAssert' 'shinydashboard:::validateColor'
#>     See the note in ?`:::` about the use of this operator.
#> 
#> ❯ checking R code for possible problems ... [13s] NOTE
#>   getAvailableStudyAreas: no visible binding for global variable
#>     'data.tsrTracker'
#>   get_tbls: no visible global function definition for 'unzip'
#>   mod_page_dashboard_server : <anonymous>: no visible binding for global
#>     variable 'in_progress'
#>   mod_page_dashboard_server : <anonymous>: no visible binding for global
#>     variable 'past_due'
#>   mod_page_dashboard_server : <anonymous>: no visible binding for global
#>     variable 'tsr_fn2025'
#>   mod_page_dashboard_server : <anonymous>: no visible binding for global
#>     variable 'data.tsrTracker'
#>   mod_page_dashboard_server : <anonymous>: no visible binding for global
#>     variable 'start'
#>   mod_page_dashboard_server : <anonymous>: no visible binding for global
#>     variable 'end'
#>   mod_page_dashboard_server : <anonymous>: no visible binding for global
#>     variable 'task'
#>   Undefined global functions or variables:
#>     data.tsrTracker end in_progress past_due start task tsr_fn2025 unzip
#>   Consider adding
#>     importFrom("stats", "end", "start")
#>     importFrom("utils", "unzip")
#>   to your NAMESPACE file.
#> 
#> ❯ checking Rd contents ... NOTE
#>   Argument items with no description in Rd file 'getInformationSchemaTables.Rd':
#>     'schema'
#> 
#> 0 errors ✔ | 2 warnings ✖ | 8 notes ✖
#> Error: R CMD check found WARNINGs
```

``` r
covr::package_coverage()
#> TSRtracker Coverage: 44.55%
#> R/app_config.R: 0.00%
#> R/app_server.R: 0.00%
#> R/app_ui.R: 0.00%
#> R/run_app.R: 0.00%
#> R/utils_import_docx.R: 0.00%
#> R/utils_TSRtracker_utils_ui.R: 0.00%
#> R/utils_TSRtracker_utils_server.R: 4.35%
#> R/mod_page_dashboard.R: 44.44%
#> R/golem_utils_server.R: 100.00%
#> R/golem_utils_ui.R: 100.00%
#> R/mod_page_rationalization.R: 100.00%
#> R/mod_page_report.R: 100.00%
#> R/mod_page_user_inputs.R: 100.00%
```
