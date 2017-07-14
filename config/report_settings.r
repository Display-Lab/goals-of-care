# Configuration settings read by report.

# Wrap settings in a function to avoid polluting namespace
#   and allow for swapping out how settings are provided.
get_report_settings <- function(){
  
  memo_title <- "Documenting goals of care conversations"
  
  # Long name for each feedback recipient identifier (facility id)
  # i.e. Facility name for each facility id.
  identifier_names <- c("5569AA"   = "Captain James A Lovell FHCC",
                        "6079AA"   = "Madison VA",
                        "568"   = "VA Black Hills HCS",
                        "568A4" = "VA Black Hills HCS"
                        )
  
  # Name of feedback source per identifier facility id
  feedback_provider_name <- c(
    "5569AA" = "Long-Term Care QUERI project",
    "6079AA" = "Long-Term Care QUERI project",
    "568" = "Lynn Peters",
    "568A4" = "Lynn Peters"
  )
  
  # Contact details per facility id
  contacts_per_id <- list(
    "5569AA"   = c("Jennifer Henry, Project Coordinator (Jennifer.Henry2@va.gov)"),
    "6079AA"   = c("Jennifer Henry, Project Coordinator (Jennifer.Henry2@va.gov)"),
    "568"   = c("Lynn Peters 605-347-2511 ext 7644"),
    "568A4" = c("Lynn Peters 605-347-2511 ext 7644")
  )
  
  # Itemized list of statements about the report to help recipients understand/interpret the report.
  interpretation_assist_statements <-  c(
    "Data are collected quarterly from CLCs",
    "This report shows data from your facility only",
    "Data in this report comes from the LST template in CPRS; the data is extracted from the Corporate Data Warehouse (CDW) Production Domain and summarized using SAS EG 7.1",
    "The report includes data only for Veterans who were newly admitted to your CLC in 2015 and 2016, quarter by quarter",
    "If a Veteran had more than one goals of care conversation documented in a quarter, only the first conversation was counted, therefore multiple readmissions in one quarter are not represented",
    "If a Veteran was admitted more than once during a quarter, only the first admission was counted."
    )
  
  # Construct and return the configuration object; a list with each item named.
  config <- list(title    = memo_title,
                 contacts = contacts_per_id,
                 provider = feedback_provider_name,
                 id_names = identifier_names,
                 assists  = interpretation_assist_statements
                 )
}
