# Constants and Config for GOCC data processing
# top level config environment
GOCC <- new.env()

# ----------------#
#     HBPC ENV    #
# ----------------#
GOCC$HBPC <- new.env(parent=GOCC)
attr(GOCC$HBPC, "name") <- 'hbpc'

GOCC$HBPC$COL_CLASSES <- c("integer","integer","character",rep("integer",7))
GOCC$HBPC$COL_NAMES <- make.names(c("fy","quart","cdw_sta6a","hbpc","numer1","numer2",
                                    "numer3","denom90","numer90","goc_pre"))

GOCC$HBPC$ID_COLS    <- c("sta6a")
GOCC$HBPC$CATEGORIES <- list("cat_1"=c("numer90","goc_pre"), 
                             "cat_2"=c("numer1"), 
                             "cat_3"=c("numer2"),
                             "cat_4"=c("numer3")) 
GOCC$HBPC$NUMER_COLS <- c('numer1','numer2','numer3', 'numer90', 'goc_pre') 
GOCC$HBPC$DENOM_COLS <- c('hbpc') 
GOCC$HBPC$OUTFILE_PREFIX <- "hbpc"

# ---------------#
#     CLC ENv    #
# ---------------#
GOCC$CLC  <- new.env(parent=GOCC)
attr(GOCC$CLC, "name") <- 'clc'

GOCC$CLC$COL_CLASSES  <- c("integer", "integer", rep("character", 2), rep("integer", 7))
GOCC$CLC$COL_NAMES <- make.names(c("fy", "quart", "sta6a", "trtsp_1",
                                   "_freq_", "goc_7", "goc_14", "goc_30", "goc_pre90", 
                                   "goc_pre", "goc_none"))
GOCC$CLC$ID_COLS    <- c("sta6a")
GOCC$CLC$CATEGORIES <- list("cat_1"=c("goc_pre90","goc_pre"),
                            "cat_2"=c("goc_7"),
                            "cat_3"=c("goc_14","goc_30"))
GOCC$CLC$NUMER_COLS <- c('goc_7', 'goc_14', 'goc_30', 'goc_pre90', 'goc_pre')
GOCC$CLC$DENOM_COLS <- c('goc_7', 'goc_14', 'goc_30', 'goc_pre90', 'goc_pre', 'goc_none')
GOCC$CLC$GROUP_COLS <- c('trtsp_1')
GOCC$CLC$OUTFILE_PREFIX <- "clc"

# --------------------#
#     DEMENTIA ENV    #
# --------------------#
GOCC$DEMENTIA  <- new.env(parent=GOCC)
attr(GOCC$DEMENTIA, "name") <- 'dementia'

GOCC$DEMENTIA$COL_CLASSES  <- c("integer", "integer", "character", "integer", "character", rep("integer", 5))
GOCC$DEMENTIA$COL_NAMES <- make.names(c("fy", "quart", "sta6a", "dementia", "trtsp_1",
                                   "_freq_", "goc_pre_quart", "goc_first_quart", "goc_ever", "goc_none"))
GOCC$DEMENTIA$ID_COLS    <- c("sta6a")
GOCC$DEMENTIA$CATEGORIES <- list("cat_1"=c("goc_none"),
                            "cat_2"=c("goc_pre_quart"),
                            "cat_3"=c("goc_first_quart"))
GOCC$DEMENTIA$NUMER_COLS <- c('goc_pre_quart', 'goc_first_quart')
GOCC$DEMENTIA$DENOM_COLS <- c('goc_pre_quart', 'goc_first_quart', 'goc_none')
GOCC$DEMENTIA$GROUP_COLS <- c('trtsp_1', 'dementia')
GOCC$DEMENTIA$OUTFILE_PREFIX <- "dementia"

# --------------------------------------#
#     DEFAULT EXTERNAL REPORT CONFIG    #
# --------------------------------------#

# Substitute for missing CLC or HBPC configuration
GOCC$DEFAULT_CFG <- list(
    title = "VA GoCC Report",
    assists = list("No assistance information provided"),
    sites = list(
      default = list( name = "default",
                      contacts = "No Contact Info",
                      provider = "No Provider Info")
))
