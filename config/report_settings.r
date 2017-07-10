# Configuration settings read by report.

# Wrap settings in a function to avoid polluting namespace
#   and allow for swapping out how settings are provided.
get_report_settings <- function(){
  
  memo_title <- "Documenting goals of care conversations"
  
  # Long name for each feedback recipient identifier (facility id)
  # i.e. Facility name for each facility id.
  identifier_names <- c("dTR" = "Decreasing Trend Facility",
                        "iTR" = "Increasing Trend Site",
                        "nTR" = "No Trend Location",
                        "rTR" = "Randal Trenderson"
                        )
  
  # Name of feedback source per identifier (facility id)
  feedback_provider_name <- c(
    "5569AA" = "Long-Term Care QUERI project",
    "6079AA" = "Long-Term Care QUERI project",
    "568" = "Lynn Peters",
    "568A4" = "Lynn Peters"
  )
  
  # Contact details per identifier (facility id)
  contacts_per_id <- list(
    "dTR" = c("Jane Smith, Product Owner (555-555-5555)",
            "John Jones, Decreasing Manager (555-222-1234)"
            ),
    "iTR" = c("Jane Smith, Product Owner (555-555-5555)",
            "John Jones, Increasing Manager (555-222-5678)"
            ),
    "nTR" = c("Jane Smith, Product Owner (555-555-5555)",
            "John Jones, No Trend Manager (555-222-9101)"
            ),
    "rTR" = c("John Jones, Random Manager (555-222-1121)")
  )
  
  # Itemized list of statements about the report to help recipients understand/interpret the report.
  interpretation_assist_statements <- c("Data collected quarterly.",
                                        "Data is analyzed in aggregate.",
                                        "Your millage may vary."
                                        )
  
  # Construct and return the configuration object; a list with each item of the confige named.
  config <- list(title    = memo_title,
                 contacts = contacts_per_id,
                 provider = feedback_provider_name,
                 id_names = identifier_names,
                 assists  = interpretation_assist_statements
                 )
}
