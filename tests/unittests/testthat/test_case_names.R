# R notebook source
# -------------------------------------------------------------------------
# Copyright (c) 2023 Craig Robert Shenton. All rights reserved.
# Licensed under the MIT License. See license.txt in the project root for
# license information.
# -------------------------------------------------------------------------

# FILE:           test_case_names.R
# DESCRIPTION:    The test the case names function
# CONTRIBUTORS:   Craig R. Shenton
# CONTACT:        craig.shenton@nhs.net
# CREATED:        15 May 2023
# VERSION:        0.0.1

# Define the unit tests
# -------------------------------------------------------------------------

# Test 1: Check if the function handles an empty input dataframe correctly
test_that("case_names handles empty input dataframe", {
  # Create an empty input dataframe
  data <- data.frame(org_name = character(0))

  # Call the case_names function with the empty input data
  result <- case_names(data, "org_name")

  # Expect an empty output dataframe
  expect_true(nrow(result) == 0)
})

# Fails - Need to account for acronyms
#--------------------------------------
# Test 2: Check if the function correctly transforms organization names
test_that("case_names transforms organization names correctly", {
  # Create a sample input dataframe
  data <- data.frame(org_name = c("ABC And XYZ", "Institute On Health", "Nhs Trust"))

  # Expected output dataframe
  expected_output <- data.frame(org_name = c("ABC and XYZ", "Institute on Health", "NHS Trust"))

  # Call the case_names function with the input data
  result <- case_names(data, "org_name")

  # Check if the transformed org_name column matches the expected output
  expect_identical(result$org_name, expected_output$org_name)
})

# Fails - Need to account for special characters
#-----------------------------------------------
# Test 3: Check if the function handles special characters in organization names
test_that("case_names handles special characters in organization names", {
  # Create a sample input dataframe with special characters
  data <- data.frame(org_name = c("ABC & XYZ", "ABC #123", "Company/Institute"))

  # Expected output dataframe
  expected_output <- data.frame(org_name = c("ABC & XYZ", "ABC #123", "Company/Institute"))

  # Call the case_names function with the input data
  result <- case_names(data, "org_name")

  # Check if the transformed org_name column matches the expected output
  expect_identical(result$org_name, expected_output$org_name)
})

# Test 4: Check if the function correctly handles multiple columns in the input dataframe
test_that("case_names handles multiple columns in the input dataframe", {
  # Create a sample input dataframe with multiple columns
  data <- data.frame(org_name = c("nhs barnsley", "Institute On Health"),
                     other_col = c("Value 1", "Value 2"))

  # Expected output dataframe
  expected_output <- data.frame(org_name = c("NHS Barnsley", "Institute on Health"),
                                other_col = c("Value 1", "Value 2"))

  # Call the case_names function with the input data
  result <- case_names(data, "org_name")

  # Check if the transformed org_name column matches the expected output
  expect_identical(result$org_name, expected_output$org_name)

  # Check if the other column remains unchanged
  expect_identical(result$other_col, expected_output$other_col)
})
