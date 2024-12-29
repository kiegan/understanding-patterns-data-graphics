# testing-charts-interpretation

Analyses of testing charts data focused on participant interpretation across different chart types.

## Folder structure

-   `00_data/`: This folder contains both raw data files received from the AmeriSpeak team as well as the combined data file for use in analyses.
-   `01_prep/`: This folder contains the script used to process the raw data files and generate the combined data file.
-   `02_analysis/`: This folder is where scripts for analyzing data should be stored; these can be `.Rmd`, `.qmd`, or `.R` files.

## Data

We will be using data from three distinct rounds of data collection. Data were collected using the AmeriSpeak Omnibus survey, which surveys approximately 1,000 panelists on a variety of topics. Our questions are one small set of questions among the whole survey. For this analysis, we will be using Rounds 10, 14, and 15.

| Round | Date          | Description           | File Name                              |
|:-----------------|:-----------------|:-----------------|:-----------------|
| 10    | February 2023 | Stacked bar           | OmnibusW2_0223_NOLA_NOLA3B_updated.sav |
| 14    | July 2023     | Line chart            | OmnibusW2_0723_NOLA.sav                |
| 15    | December 2023 | Diverging stacked bar | OmnibusW1_1223_NOLA.sav                |

These data files, the final survey files we recieve from the AmeriSpeak team, are stored in the `00_data/` subfolder.

The combined data file is `all-rounds.rds` and can be read in with the `readRDS` command.

### Ground truth answers to survey questions

True/False questions

-   `NOLA2_1 == 1` (True)
-   `NOLA2_2 == 1` (True)
-   `NOLA2_3 == 0` (False)
-   `NOLA2_4 == 1` (True)
-   `NOLA2_5 == 0` (False)

Value estimation questions (have to answer in integers between 0 and 100)

-   `NOLA3A == 71.4`
-   `NOLA3B == 35.2`
-   `NOLA3C == 16.6`
-   `NOLA3D == 47.6`

## Combining surveys across rounds

In order to jointly analyze data across rounds, we can combine the survey data into one data set with identifiers for Round; however, when we do this, we need to adjust the survey weights to account for differing sample sizes across rounds. This process is completed in the `01_prep/combine-data.R` script.  

## Survey weighting in analyses

In order to ensure proper calculation of standard errors, we will use the `survey` package when calculating summary statistics and completing modeling tasks. It is important to first specify the survey design using the case IDs and survey weights, using the `svydesign` function. Then, when performing calculations or modeling tasks, we use functions from the package such as `svytable`, `svyglm`, `svyciprop`, etc.

## Research Questions

In this analysis, we focus on two main research questions:

1.  How does participant interpretation of the information presented in presented data visualizations differ across different data visualization types (stacked bar, diverging stacked bar, facetted line)?
    -   How does participant accuracy in answering True/False interpretation questions differ across visualization types? Does this differ by the type of question?
    -   How does participant accuracy in estimating the values shown in a data visualization differ across visualization types?
    -   How do participants' open-ended interpretations of the charts differ across visualization types?
2.  Does participant interpretation by data visualization type differ across demographic subgroups?
