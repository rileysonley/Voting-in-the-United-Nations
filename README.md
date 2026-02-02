# Voting-in-the-United-Nations

## Project Overview 

**Project Title**: UN General Assembly Votes Analysis 

**Dataset**: 2025_9_19_ga_voting.csv, https://digitallibrary.un.org/record/4060887?ln=en

**Skills Demonstrated**: 
- Python
- Tableau
- SQL
- Machine Learning (K-Means) 

This projcet was designed to demostrate skills in Postgre SQL, Python and Tableau. The project involves transfomring and cleaning messy United Nations data in python, which was then loaded into SQL and transformed in order to calculate the % agreements of member states with the USA, China and Russia/CCCP. This data was then loaded back into python where some inital Exploratior Data Anysis (EDA) was perfromed. In addition a K-Means clustering Machine Learning algorithm was used to group sates into voting clusters based on allignment with the USA, China and Russia/CCCP. All the data was then compiled into an interactive Tableau dashboard.

# Objectives 
- Demonstrate a strong basic skillset in data analytical techniques of data cleaning, transforming, EDA and SQL queries 
- Uncover underlying patterns in UN voting data
- Demonstrate more advanced techniques of machine learning

# Scope 
- The dataset used in this project contains voting data on General Assembly resoultions in the UN from 1946 to 2025
- The data is split up into three time periods. Looking at the Cold-War (1946-1991) era, the Post Cold-War era (1991-2025) and the entire period for which data exists (1946-2025) 


# Key Findings 

## United States
- The data shows that there are distinct voting blocs within the United Nations on the side of the USA and NATO
- K-Means modelling and Tableau visualizations show consistent allignment with United States voting behaviour among Western Europe across all periods examined
- A large mnajoirty of states that allign with US voting patterns in the UN are democracies, suggesting a correlation
- Other than Western European allies and occassional outlieres, the data shows a majority of countires do not vote in line with US interests 

## China and Russia/CCCP
- The data shows a more varied, and larger, array of states voting in alligment with Russia/CCCP and China
- K-Means modelling and Tableau visualizations show a larger cluster of states that vote more favourably with Russia/CCCP and China
- K-Means modelling shows that Russia/CCCP and China exist in the same cluster, perhaps suggesting an alligned approach to geopolitics
- A large number of states in the Russia/CCCP/China allignment bloc are non-democratic
- A large number of states are not alligned with US voting behaviour
- Non-allignment with US voting behaviour does not signify consistent allignment with Russia/CCCP/China and could be resultant of the self-determination of these states in the UN 
