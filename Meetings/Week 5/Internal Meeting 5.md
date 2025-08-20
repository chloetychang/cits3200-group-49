# Minutes Template

- Date: 20/8/25
- Present: Naren, Dennis, Ryan, Chloe, Harper
- Absent: 
- Apologies:
- Venue: EZONE NTH 202B
- Minutes by: Naren
- Meeting Start: 15:00
## Item 0 - Project Manager Meeting Minutes
>
### Discussion:
Tri: Issues with submiting the minutes for Week 4
Tri: Ensure that the minutes could be exported to PDF 
Chloe: Chloe is willing to aid future project managers, (Dont be too late to the deadline) 
Tri: Possibly utlilizing Docs 
Chloe: Obsidian is recomended to chande markdown file to PDF 


### Action:
- Obsidian learning curve (but its good) 
- Fix formating (No leading spaces before heading and new lines character)
- 


## Item 1 - Flutter/Figma demonstration
> **Demonstration of how to use, and what has been done on Flutter.**

### Discussion
Chloe: Flutter is low code and can be completely transfered into Flutter 
Chloe: Intially uses Figma to CSS but Flutter is better 
Chloe: Figma is very straight forward with "limited" code input 
Chloe: Must confirm with Kevin the current GUI (Flutter) before backend 
Chloe: Front-end to be finalized before backend 
Tri: Suggesting a week for the front-end 
Chloe: Did not anticipate changes for the front-end (V2)
Tri: Suggesting finishing it next week to present to Kevin (Front end) 
Chloe: Overview of the front end to be completed by next week wednesday (But not finalized) 
Chloe: Chloe needs the end points and she wants to see how the data set integrate with the front end. 
Chloe: By week six, the program will be visually reader but not completety responsive and adjustable 
Chloe: Concerns - Only one users per flutter workspace 
Chloe: Demonstrating flutter and explained potential issues with the backhand 

### Actions
- Chloe -> Harper, Dennis: By week six (27th), send Kevin screenshots of the frontend (Chloe, Harper, Dennis) 
- 
<br>

## Item 2 - AccessDB/PostgreSQL demonstration
> **Demonstration of ways to, and what should be done to migrate the database.**

### Discussion
Intermediate deliverables: Migrate MS Acess DB to PosgreSQL
 - Naren: Mentions that Kevin says the databases will be updated monthly, therefore, research is done on how to effectively re-migrate the database instead of manually trying to update it once a new database schema release comes.
 - Naren: Pose concerns that database migration will affect frontend development, causing work to be restarted.
 - Tri: Mentions that VsCode shows the primary key, but not the foreign keys (Theory explaination: Foreign keys are "Primary keys" in other page tables)
 - Naren: Suggested to use PyODBC.
 - Tri: Concerns about intermediate deliverables vs Sprint 2 deliverables.
 - Naren: Concerns on PostgreSQL migration fails, use sqlite instead (but with some limitation).
 - Chloe: Suggestion if possible to use Firebase Database (that's already integrated with FF, making full stack conversion easier)
 - Tri: What is the expectation of the data migration ($50) is a lot of money (KEVIN)
 - Tri: Clarify what are the expectaction of Sprint 2 (data migration team )
 - Tri: Clarify what are the expectaction of Sprint 2 (data migration flutter)
 - Chloe: Delivrables -> To make it more responsive
 - Chloe: Drafts of the front end
 - T

FastApi
- 
 
### Actions
**Database Team:**
 - Naren -> Ryan, Tri: Explore the ER relation diagram (on internal constraints) inside MS Access database, have an understanding on what the key constraints are, before processing the migration to PostgreSQL. 
 - Naren -> all: Creation of a Log that should be created via SQL trigger, which will be intergrated to Superusers in the frontend.

- Investigate how to connect the database with fast API 
- Tri -> Attempt data migration with PYOBDC and evaluate the feasability
- Tri -> Establishing the test to check whether the migration is successfull (Was all the tables migrated, verifing table dimension, verify primary and foreign key to ensure proper JOIN tables, data types are within the correct format and possition, doing a select function, research data integrity testing methods
- Tri -> ESF Database Migration
- ASK KEVIN: Format of the logs

<br>

## Item 3 - Role allocation, task assignment, timeline for Sprint 2
> **Assignment of roles and tasks for sprint 2. Also, establish timeline to work on for sprint 2.**

### Discussion
- Firebase vs PostgresSQL
- Ryan as Data Migration REPPPPPP
- Chloe as Front end REPPPPP
  
### Actions
 -  Investigate how to connect the database with fast API 
- Tri & Naren -> Attempt data migration with PYOBDC and evaluate the feasability
- Tri & Naren -> Establishing the test to check whether the migration is successfull (Was all the tables migrated, verifing table dimension, verify primary and foreign key to ensure proper JOIN tables, data types are within the correct format and possition, doing a select function, research data integrity testing methods
- Tri -> ESF Database Migration
- ASK KEVIN: Format of the logs
- Flutter team to finalized the demo for Kevin (Next Week Wednesday)
- ER Diagram
- Dennis Harper Chloe: Have inital screen finalized & Screenshots


<br>




## Meeting Closed: 17:00
## Next Scheduled Meeting: Monday, 25th of August (Pre-Auditor Meeting) 
