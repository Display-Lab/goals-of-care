#' @title Read Data
#' @param path path to clc or hbpc csv file
#' @param classes vector of classes passed to colClasses
#' @return dataframe or NULL
#' @importFrom utils read.csv
read_data <- function(path, classes){
  if(file.exists(path)){
    utils::read.csv( path, header = TRUE, colClasses = classes )
  }else{
    cat(paste("\nFile not found at:", path)) 
  } 
}

#' @title Read CLC Data
#' @describeIn read_data Convenience function for reading CLC data
read_clc_data <- function(path){
  read_data(path, GOCC$CLC$COL_CLASSES)
}

#' @title Read HBPC Data
#' @describeIn read_data Convenience function for reading HBPC data
read_hbpc_data <- function(path){
  read_data(path, GOCC$HBPC$COL_CLASSES)
}

#' @title Read Dementia Data
#' @describeIn read_data Convenience function for reading dementia data
read_dementia_data <- function(path){
  read_data(path, GOCC$DEMENTIA$COL_CLASSES)
}