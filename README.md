# rapR-package-template

An example {targets} analytics pipeline template that can be adapted for RAP projects.

## About

This repository serves as a template for processing data from the NHSR-datasets package and NHS ODS codes using R, targets, and tarchetypes. The output of the data processing is a comprehensive report generated using Quarto. This repository also includes unit tests for the functions within the utilities folder to ensure robust data processing.
Features

- **Data Processing**: Using the R programming language, targets, and tarchetypes to process data from the NHSR-datasets package and NHS ODS codes.
- **Report Generation**: The Quarto package is used to generate a report from the processed data.
- **Unit Testing**: This repository includes a set of unit tests for the functions in the utilities folder to help ensure data processing reliability and robustness.

# Getting Started

Clone the repository: Start by cloning this repository to your local machine.

```bash
git clone https://github.com/<username>/nhs-data-processing.git
```

Install dependencies: Ensure you have R installed. You should also install the required packages. Run the following command in your R console to install the required packages.

```r
install.packages(c("NHSRdatasets", "targets", "tarchetypes", "quarto", "testthat"))
```

Process the data: Use targets and tarchetypes to process the data. To run the pipeline, execute the following command in your R console:

```r
targets::tar_make()
```

Generate report: To generate the report using Quarto, run the following command:

```r
quarto::quarto_render()
```

Run unit tests: Unit tests for the utility functions can be run with the following command:

```r
testthat::test_dir("utilities/tests")
```

## Structure of the Repository

```lua
|-- README.md
|-- .gitignore
|-- quarto_report
|   |-- report.qmd
|-- R
|   |-- _targets.R
|-- utilities
|   |-- functions.R
|   |-- tests
|   |   |-- test-functions.R
|-- data
|   |-- nhsr_datasets
|   |-- ods_codes
```

Folder Descriptions:

- quarto_report: Contains Quarto markdown files for the report generation.
- R: Contains the R script defining the data processing targets pipeline.
- utilities: Contains utility functions used in data processing and their unit tests.
    data: Folder for the NHSR-datasets and NHS ODS codes data.

# Folder structure

```bash
rap-package-template
│   README.md
|   _targets.R
│   create_report.R
│   params.R
|   report_template.qmd
|
├── pipeline
│   ├── interim
│   ├── processed
│   └── raw
│
├───utilities
|   |
│   ├───data_connections.R
│   ├───field_definitions.R
│   └───processing_steps.R
|
├───reports
│   │
│   ├───input_profile
│   └───output_profile
│
└───tests
    └───unittests
        └───testthat
            |
            ├───
            ├───test_data_connections.R
            ├─── test_field_definitions.R
            └───test_processing_steps.R
```
