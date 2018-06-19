#' @title Check Input
#' @description Make a pass through data for conformance to expected col names and classes.
#' @param df dataframe of input data to verify
#' @param expected_colnames vector of names that need to match the column headers
#' @importFrom stringr str_to_lower
check_input <- function(df, expected_colnames){
  verify_count <- check_col_count(df, expected_colnames)
  verify_names <- check_col_names(df, expected_colnames)
  
  return( verify_count && verify_names)
}

#' @title Check Column Names
#' @describeIn check_input Check observed column names in df against expected.
#' @importFrom stringr str_to_lower
check_col_names <- function(df, expected_colnames){
  cat("\nChecking column names\n")
  
  # Ignore case by converting all to lower
  lower_colnames <- stringr::str_to_lower(colnames(df))
  lower_expected <- stringr::str_to_lower(expected_colnames)
  
  col_differences <- setdiff(lower_expected, lower_colnames)
  
  # Report column name differences to std out
  if(length(col_differences) == 0){
    cat("Found expected columns.\n")
  } else {
    cat("Unexpected columns!\n")
    cat("\nExpected:\n")
    cat(paste0(lower_expected, collapse=" "))
    cat("\nFound:\n")
    cat(paste0(lower_colnames, collapse=" "))
    cat("\nDifferences:\n")
    print(col_differences)
    return(FALSE)
  }
  
  return(TRUE)
}

#' @title Check Column Count
#' @describeIn check_input Check observed number of columns in df against expected.
check_col_count <- function(df, expected_colnames){
  cat("\nChecking number of variables\n")
  
  names_count <- length(expected_colnames)
  cat("Expected:", names_count, "encountered:", ncol(df),"\n")
  
  if(ncol(df) != names_count){
    cat("Unexpected number of variables!\n")
    return(FALSE)
  }
  
  return(TRUE)
}
