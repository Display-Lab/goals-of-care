#' @title Read Config
#' @description Read contents of configuration.  Throw warning if not present and use default config.
#' @importFrom config get
read_config <- function(path){
  if(!file.exists(path)){
    cat(paste0("\nConfig file not found: ", path, collapse=""))
    cfg <- failed_config()
  }else{
    cfg <-tryCatch(expr=get_config(path), error=failed_config())
  }
  return(cfg)  
}

get_config <- function(path){
  config::get(file=path, config = "default", use_parent = FALSE)
}

failed_config <- function(){
  list(clc=GOCC$DEFAULT_CFG,
       hbpc=GOCC$DEFAULT_CFG,
       dementia=GOCC$DEFAULT_CFG)
}
