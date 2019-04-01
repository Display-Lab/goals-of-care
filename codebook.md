# Input Data Codebook

## Abbreviations
- **GoCC** Goals of care conversation.
- **veterans** Veterans newly admitted to a care facility during the reporting month.

## HBPC Input
### Columns Definitions
- **report_month** Reporting month of counts in yyyy-MM-dd format.  Date indicates first day of relevant month. E.g. 2071-04-01 indicates counts are for April 2017.
- **cdw_sta6a** String uniquely identifying the site to which counts are attributed. E.g. 4369AA.
- **hbpc** Number of veterans who were counted in the analysis.  This is the overal denominator.
- **numer1** Counts of veterans who had a GoCC at the first HBPC visit.
- **numer2** Counts of veterans who had a GoCC at the 2nd HBPC visit, when they did not have one at the first visit.
- **numer3** Counts of veterans who had a GoCC at the 3rd HBPC visit, when they did not have a GoCC at the first 2 visits.
- **denom90** Counts of veterans who were admitted between 60 and 90 days prior. 
- **numer90** Counts of veterans who had GoCC up to 90 days prior to admission.
- **goc_pre** Counts of veterans who had GoCC more than 90 days prior to admission.

### Notes
- denom90 is unused in reporting.

## CLC Input
### Columns Definitions
- **Sta6a** String uniquely identifying the site to which counts are attributed. E.g. 4369AA.
- **trtsp_1** String identifying the treatment specialty. Either "Short-Term NH Care" or "Long-Term NH Care".
- **report_month** Reporting month of counts in yyyy-MM-dd format.  Date indicates first day of relevant month. E.g. 2071-04-01 indicates counts are for April 2017.
- **\_FREQ\_** Number of veterans who were counted in the analysis. This is the overal denominator.
- **goc_7** Number of veterans who had a GoCC within the first 7 days of admission.
- **goc_14** Number of veterans who had a GoCC between day 8 and day 14 post admission. 
Excludes counts in `goc\_7`
- **goc_30** Number of veterans who had a GoCC between day 15 and day 30 post admission.
Excludes counts in `goc\_14`
- **goc_pre90** Number of veterans who had a GoCC no more than 90 days prior to admission.
Excludes counts in `goc\_30`
- **goc_pre** Number of veterans who had a GoCC 90 days or more prior to admission.
Exluces those who had a GoCC between 90 days prior and 30 days after admission.
- **goc_none** Number of veterans without a documented GoCC.

### Notes
- \_freq\_ is unused in calculations.  
- Denominator is sum of 'goc\_7', 'goc\_14', 'goc\_30', 'goc\_pre90', 'goc\_pre', 'goc\_none'

## Dementia Input
### Columns Definitions
- **Sta6a** String uniquely identifying the site to which counts are attributed. E.g. 4369AA.
- **trtsp_1** String identifying the treatment specialty. Either "Short-Term NH Care" or "Long-Term NH Care".
- **report_month** Reporting month of counts in yyyy-MM-dd format.  Date indicates first day of relevant month. E.g. 2071-04-01 indicates counts are for April 2017.
- **dementia** Enumerated category valid values are 1 or 2.
    - **1** veterans with dementia
    - **2** all veterans (including those with dementia)
- **\_FREQ\_** Number of veterans who were counted in the analysis. This is the overal denominator.
- **goc_pre_month** Number of veterans with a GoCC documented up to 30 days prior to admission.
- **goc_first_month** Number of veterans with a GoCC documented during the reporting month.
- **goc_ever Number** of veterans with a GoCC documented prior to admission. Sum of `goc_first_month` and `goc_pre_month`
- **goc_none Number** of veterans without a documented GoCC.

### Notes
- dementia "all veterans" includes counts from veterans with dementia
- \_freq\_ is unused in calculations.  
- Denominator is sum of 'goc\_pre\_month', 'goc\_first\_month', 'goc\_none'
