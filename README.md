# DataMiningHealthcare_Capstone

***For R Version 3.6 (Base R)***


Dataset comprises links to two files for county level data and hospital readmission data :
        1. https://healthdata.gov/dataset/community-health-status-indicators-chsi-combat-obesity-heart-disease-and-cancer
        2. https://archive.ics.uci.edu/ml/datasets/diabetes+130-us+hospitals+for+years+1999-2008.
        3.
https://www.kaggle.com/GoogleNewsLab/health-searches-us-county/downloads/health-searches-us-county.zip/1


There exists jupyter notebook script for data cleaning:
        - Add the path to the directory where the dataset exists
        - Reads Dataset.
        - Installs and loads required libraries.
        - Performs data cleaning.
        - Writes the new cleaned files to csv.


There are separate R Scripts for each model built.


Guidelines:
        1. KNN will atleast take an hour to run (sentiment_by function call on 38000 reviews.)
        2. Each prediction model resides in a separate script.
        3. To check any model, the entire script is to be run.
        4. Visualizations and Exploratory Data Analysis resides in a separate script.
        5. Twitter data Analysis was done on live data and API keys, it might not reproduce the same results.


Instructions for running R Scripts:
        1. Place all data files and r scripts in one folder.
        2. Open Master.R in RStudio.
        3. Set the Directory to Source File.
        4. Run cleaning dataset script in Jupyter Notebook. 
        5. Open a script for the desired classification model.
        6. Library loading commands are redundant if you are in the same session.
        7. Run script.
        8. Once run, view plots generated in the plot window.


Instructions for running Tableau (.twbx) files:
1. Right click on the file and open with Tableau Desktop Application
*This file contains the dashboard along with the source dataset


Instructions for running .ipynb files:
1. Place all data files in one folder
2. Set directory to that folder containing data files
3. Open Jupyter notebook
4. Browse the file and click 
5. Run the code
