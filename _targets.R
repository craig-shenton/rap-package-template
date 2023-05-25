# R notebook source
# -------------------------------------------------------------------------
# Copyright (c) 2022 Craig Robert Shenton. All rights reserved.
# Licensed under the MIT License. See license.txt in the project root for
# license information.
# -------------------------------------------------------------------------

# FILE:           _targets.R
# DESCRIPTION:    Define targets pipeline
# CONTRIBUTORS:   Craig R. Shenton
# CONTACT:        craig.shenton@nhs.net
# CREATED:        17 Dec 2022
# VERSION:        0.1.0

# Load Packages
# -------------------------------------------------------------------------
# Load necessary libraries
# Install and load Libraries
# -------------------------------------------------------------------------
install_and_load_packages <- function(packages, github_packages) {
  for (package in packages) {
    if (!require(package, character.only = TRUE)) {
      install.packages(package,
                       repos = "https://cran.r-project.org",
                       dependencies = TRUE
                      )
      library(package, character.only = TRUE)
    }
  }

  if (!requireNamespace("remotes", quietly = TRUE)) {
    install.packages("remotes",
                     repos = "https://cran.r-project.org",
                     dependencies = TRUE
                    )
  }

  for (github_path in github_packages) {
    package <- strsplit(github_path, "/")[[1]][2]
    if (!require(package, character.only = TRUE)) {
      remotes::install_github(github_path)
      library(package, character.only = TRUE)
    }
  }
}

packages <- c("dplyr", "readr",
              "here", "DT", "scales",
              "lubridate", "plotly",
              "targets", "quarto"
             )
github_packages <- c("nhs-r-community/NHSRdatasets",
                     "ropensci/tarchetypes")

suppressPackageStartupMessages(
  install_and_load_packages(packages, github_packages)
)

tar_option_set(packages = c("readr",
                            "here",
                            "NHSRdatasets",
                            "dplyr",
                            "quarto"))

# Load all functions in the utilities folder
# -------------------------------------------------------------------------
source("utilities/source_folder.R")
source_folder("pipeline", recursive = TRUE)

# Ingest ae_attendance data from {NHSRdatasets} package
# -------------------------------------------------------------------------
# define parameters
ae_attendance <- list()
nhsr_dataset_name <- "ae_attendances"

# define raw target
ae_attendance$raw <- targets::tar_target(
  name = ae_attendance_raw_data, # name of dataset
  command = f_ae_attendance_raw(nhsr_dataset_name) # pipeline function
  )

# define interim target
ae_attendance$interim <- targets::tar_target(
  name = ae_attendance_interim_data,
  command = f_ae_attendance_interim(ae_attendance_raw_data)
)

# define processed targets
ae_attendance$processed <- targets::tar_target(
  name = ae_attendance_type1_data,
  command = f_ae_attendance_type1(ae_attendance_interim_data,
                                      trust_ods_codes_interim_data)
)

ae_attendance$processed_table <- targets::tar_target(
  name = ae_attendance_type1_table,
  command = f_ae_attendance_type1_table(ae_attendance_type1_data)
)

# Ingest Trust ODS codes from NHSE file store
# -------------------------------------------------------------------------
# define parameters
trust_ods_codes <- list()
file_url <- "https://nhsenglandfilestore.s3.amazonaws.com/ods/etrust.csv"

# define target
trust_ods_codes$raw <- targets::tar_target(
  name = trust_ods_codes_raw_data,
  command = f_trust_ods_codes_raw(file_url)
  )

# define interim target
trust_ods_codes$interim <- targets::tar_target(
  name = trust_ods_codes_interim_data,
  command = f_trust_ods_codes_interim(trust_ods_codes_raw_data)
)

# Render Quarto template
# -------------------------------------------------------------------------
# define target
render_ae_attendance_report <- tarchetypes::tar_quarto(report, "report_template.qmd", 
                                                       execute_params = list())

# Start target list
# -------------------------------------------------------------------------
list(ae_attendance$raw,
     ae_attendance$interim,
     trust_ods_codes$raw,
     trust_ods_codes$interim,
     ae_attendance$processed,
     ae_attendance$processed_table,
     render_ae_attendance_report)
