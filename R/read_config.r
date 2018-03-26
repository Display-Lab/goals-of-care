#' @title Read Config
#' @description Read contents of configuration.  Throw warning if not present and use default config.
#' @importFrom config get
read_config <- function(path){
  tryCatch(expr=get_config(), error=failed_config())
}

get_config <- function(path){
  config::get(file=config_path, config = "default", use_parent = FALSE)
}

failed_config <- function(){
  list(clc=GOCC$DEFAULT_CFG,
       hbpc=GOCC$DEFAULT_CFG)
}
