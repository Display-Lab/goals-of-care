#' @title Read Config
#' @description Read contents of configuration.  Throw warning if not present and use default config.
#' @importFrom config get
#' @importFrom rlang warn
read_config <- function(path){
  if(is.null(path) || !file.exists(path)){
    rlang::warn(paste0("Config file not found: ", path, collapse=""))
    cfg <- failed_config()
  }else{
    cfg <-tryCatch(expr=get_config(path), error=failed_config())
  }
  return(cfg)  
}


#' @title Get Config
#' @description Wrapper for config::get
get_config <- function(path){
  config::get(file=path, config = "default", use_parent = FALSE) 
}

#' @title Failed Config
#' @description handler function for config read error.  Returns default config
failed_config <- function(){
  rlang::warn("FAILED READING CONFIG")
  list(clc=GOCC$DEFAULT_CFG,
       hbpc=GOCC$DEFAULT_CFG,
       dementia=GOCC$DEFAULT_CFG)
}
