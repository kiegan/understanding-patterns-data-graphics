# understanding-patterns-data-graphics

Data, code, and analyses of for "Measuring Real-World Understanding of Patterns in Data Graphics", a manuscript submitted to the IEEE CG&A Special Issue on Inclusive Data Experiences.  

This work focuses on measuring ability to interpret content presented in data graphics and how that ability differs across subgroups within the U.S. adult population. 

## Folder structure

-   `00_data/`: This folder contains both raw data files received from the AmeriSpeak team as well as the combined data file for use in analyses.
-   `01_prep/`: This folder contains the script used to process the raw data files and generate the combined data file.
-   `02_paper-file/`: All files for the paper manuscript, including the references file, style files, and rendered PDF. We utilize RMarkdown in concert with the IEEE CG&A templates for TeX and references to render the final TeX and PDF files. The primary files of interest here are `ieee-special-issue-rmd.Rmd`, `CsMag_template.tex`, `references.bib`, and `ieee-special-issue-rmd.tex`. The rendered PDF is `ieee-special-issue-rmd.pdf`. 

## Data

There are data from three differen survey rounds from NORC's AmeriSpeak Omnibus survey, provided in the `round-10`, `round-14`, and `round-15` subfolders within `00_data`. These files are combined into a shared `all-rounds.rds` file using the script in the `01_prep` folder.


| Round | Date          | Description           | File Name                              |
|:-----------------|:-----------------|:-----------------|:-----------------|
| 10    | February 2023 | Stacked bar           | OmnibusW2_0223_NOLA_NOLA3B_updated.sav |
| 14    | July 2023     | Line chart            | OmnibusW2_0723_NOLA.sav                |
| 15    | December 2023 | Diverging stacked bar | OmnibusW1_1223_NOLA.sav                |


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

In order to jointly analyze data across rounds, we combine the survey data into one data set with identifiers for Round; however, when we do this, we need to adjust the survey weights to account for differing sample sizes across rounds. This process is completed in the `01_prep/combine-data.R` script.  

## Survey weighting in analyses

In order to ensure proper calculation of standard errors, we use the `survey` package when calculating summary statistics and completing modeling tasks. It is important to first specify the survey design using the case IDs and survey weights, using the `svydesign` function. Then, when performing calculations or modeling tasks, we use functions from the package such as `svytable`, `svyglm`, `svyciprop`, etc.

## Contact  

The corresponding author for this work is Kiegan Rice.