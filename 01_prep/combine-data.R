# -----------------------------------------------------------
# Script Name: combine-data.R
# Purpose: This script is used to combine multiple rounds of AmeriSpeak data into one dataset
# Author: Kiegan Rice
# Date: 2024-01-16
# Version: 1.0
# -----------------------------------------------------------


# Packages ----------------------------------------------------------------
library(haven)
library(dplyr)

# Read in raw data files --------------------------------------------------
round10 <- haven::read_sav("00_data/round-10/OmnibusW2_0223_NOLA_NOLA3B_updated.sav") %>% 
  mutate(ROUND = "ROUND 10", DESIGN = "STACKED BAR") 
round14 <- haven::read_sav("00_data/round-14/OmnibusW2_0723_NOLA.sav") %>% 
  mutate(ROUND = "ROUND 14", DESIGN = "LINE") 
round15 <- haven::read_sav("00_data/round-15/OmnibusW1_1223_NOLA.sav") %>% 
  mutate(ROUND = "ROUND 15", DESIGN = "DIVERGING STACKED BAR")

# Fix inconsistencies for the CLICKCOUNT and TOTALTIME variables ----------
columns_to_convert <- c("NOLA1_CLICKCOUNT", "NOLA1_TOTALTIME", "NOLA2_CLICKCOUNT",
                        "NOLA2_TOTALTIME", "NOLA3_CLICKCOUNT", "NOLA3_TOTALTIME")
round10 <- round10 %>%
  rename(NOLA1_CLICKCOUNT = NOLA1A_CLICKCOUNT, NOLA1_TOTALTIME = NOLA1A_TOTALTIME,
         NOLA2_CLICKCOUNT = NOLA2A_CLICKCOUNT, NOLA2_TOTALTIME = NOLA2A_TOTALTIME)
round10[columns_to_convert] <- lapply(round10[columns_to_convert], as.numeric)

round14 <- round14 %>%
  rename(NOLA3_CLICKCOUNT = NOLA3A_CLICKCOUNT, NOLA3_TOTALTIME = NOLA3A_TOTALTIME,
         PartyID5 = PARTYID5, PartyID7 = PARTYID7,
         P_DISABILITY = DISABILITY, P_HL006 = HL006, P_HL026 = HL026)

round15[columns_to_convert] <- lapply(round15[columns_to_convert], as.numeric)

# Calculate lambda values -------------------------------------------------
# Kish's Effective Sample Size
neff <- function(weight) {
  n <- length(weight)
  L <- var(weight)/mean(weight)^2
  n/(1+L)
}


calculate_lambdas <- function(weights1, weights2, weights3) {
  
  neffs <- c(neff(weights1), neff(weights2), neff(weights3))
  lambdas <- neffs/sum(neffs)
  return(lambdas)
  
}

lambdas <- calculate_lambdas(round10$WEIGHT_NOLA, round14$WEIGHT_NOLA, round15$WEIGHT)

# Apply lambda values -----------------------------------------------------
round10$WEIGHT_COMBINED <- lambdas[1]*round10$WEIGHT_NOLA
round14$WEIGHT_COMBINED <- lambdas[2]*round14$WEIGHT_NOLA
round15$WEIGHT_COMBINED <- lambdas[3]*round15$WEIGHT

# Merge data files --------------------------------------------------------
combined <- bind_rows(round10, 
                      round14, 
                      round15 %>% 
                        ## fix some inconsistencies with round 15 data structure before merging
                        rename(`WEIGHT_NOLA` = `WEIGHT`)) %>%
  ## Scale weights so that effective sample size is similar to original sizes after combining samples
  mutate(WEIGHT_SCALED = neff(WEIGHT_COMBINED)/sum(WEIGHT_COMBINED)*WEIGHT_COMBINED) %>%
  select(-CaseId)


# Save out data file -----------------------------------------------------

saveRDS(combined, "00_data/all-rounds.rds")
