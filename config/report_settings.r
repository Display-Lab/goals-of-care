# Configuration settings read by report.

# Wrap settings in a function to avoid polluting namespace
#   and allow for swapping out how settings are provided.
get_report_settings <- function(){
  
  contacts <- c("FIRSTNAME SURNAME, TITLE (555-555-5555)",
                "Jane Smith, Product Owner (555-555-5555)",
                "John Jones, Project Manager (555-222-1234)"
                )
  
  feedback_provider_name <- "Feedback Provider Name"
  
  memo_title <- "Documenting goals of care conversations"
  
  identifier_names <- c(dTR = "Decreasing Trend Facility",
                        iTR = "Increasing Trend Site",
                        nTR = "No Trend Location",
                        rTR = "Randal Trenderson"
                        )
  
  interpretation_assist_statements <- c("Data collected quarterly.",
                                        "Data is analyzed in aggregate.",
                                        "Your millage may vary."
                                        )
  
  # Return a list with each item named
  config <- list(title    = memo_title,
                 contacts = contacts,
                 provider = feedback_provider_name,
                 id_names = identifier_names,
                 assists  = interpretation_assist_statements
                 )
}
