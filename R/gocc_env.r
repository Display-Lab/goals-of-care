# Constants and Config for GOCC data processing

# top level config environment
GOCC <- new.env()

# sub environments for CLC | HBPC specific config
GOCC$HBPC <- new.env(parent=GOCC)
GOCC$CLC  <- new.env(parent=GOCC)

GOCC$CLC$COL_CLASSES  <- c("integer", "integer", rep("character", 2), rep("integer", 7))
GOCC$CLC$COL_NAMES <- make.names(c("fy", "quart", "sta6a", "trtsp_1",
                                       "_freq_", "goc_7", "goc_14", "goc_30", "goc_pre90", 
                                       "goc_pre", "goc_none"))

GOCC$HBPC$COL_CLASSES <- c("integer","integer","character",rep("integer",7))
GOCC$HBPC$COL_NAMES <- make.names(c("fy","quart","cdw_sta6a","hbpc","numer1","numer2",
                                        "numer3","denom90","numer90","goc_pre"))
