# Configuration settings read by report.

# Wrap settings in a function to avoid polluting namespace
#   and allow for swapping out how settings are provided.
get_report_settings <- function(){
  
  
  feedback_provider_name <- "Feedback Provider Name"
  
  memo_title <- "Documenting goals of care conversations"
  
  identifier_names <- c(dTR = "Decreasing Trend Facility",
                        iTR = "Increasing Trend Site",
                        nTR = "No Trend Location",
                        rTR = "Randal Trenderson"
                        )
  
  contacts_per_id <- list(
    dTR = c("Jane Smith, Product Owner (555-555-5555)",
            "John Jones, Decreasing Manager (555-222-1234)"
            ),
    iTR = c("Jane Smith, Product Owner (555-555-5555)",
            "John Jones, Increasing Manager (555-222-5678)"
            ),
    nTR = c("Jane Smith, Product Owner (555-555-5555)",
            "John Jones, No Trend Manager (555-222-9101)"
            ),
    rTR = c("Jane Smith, Product Owner (555-555-5555)",
            "John Jones, Random Manager (555-222-1121)"
            )
  )
  
  interpretation_assist_statements <- c("Data collected quarterly.",
                                        "Data is analyzed in aggregate.",
                                        "Your millage may vary."
                                        )
  
  # Return a list with each item named
  config <- list(title    = memo_title,
                 contacts = contacts_per_id,
                 provider = feedback_provider_name,
                 id_names = identifier_names,
                 assists  = interpretation_assist_statements
                 )
}
