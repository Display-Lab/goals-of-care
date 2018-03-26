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
check_col_names <- function(df, expected_colnames){
  cat("\nChecking column names\n")
  
  lower_colnames <- str_to_lower(colnames(summ))
  col_differences <- setdiff(expected_colnames, lower_colnames)
  
  # Report column name differences to std out
  if(length(col_differences) == 0){
    cat("Found expected columns.\n")
  } else {
    cat("Unexpected columns!\n")
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
  
  if(length(summ) != vars_count){
    cat("Unexpected number of variables!\n")
    return(FALSE)
  }
  
  return(TRUE)
}
