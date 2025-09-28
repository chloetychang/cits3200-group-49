# Minutes 
- Date: 28/09/2025
- Present: Chloe, Harper, Naren, Ryan, Tri, Dennis
- Absent:
- Apologies:
- Venue: Online Discord
- Minutes by: Dennis
- Meeting Start: 2000

## Item 1 - Progress check in on task assigned
> **<Description>**

### Discussion
 - **Everyone:** Docker Setup in documentation_backend branch
    - Everyone: No further issues with installations and are happy to with the docker setup guide.
 - **Chloe:** Technical support for docker setup + future best practices communications
    - Notify other team members if working on a branch or reviewing a pull request. 
    - Provides visibility and avoid merge conflicts (I.e. post merge comments, which should be done during review stage)
 - **Tri & Naren:** Investigation of Database Migration tweaks and migration folder cleanup 
    - Naren: Primary composites keys issues - refering to 2 columns at the same time (for tables user link role + species utility link) This means that reference to future columns in the future will cause difficulty to reference the table linkage. 
    - Tri: Teams that are working on the routing for the backend, will need to take note of these composite key reference. (If they need to display users + species, they need to match userid and speciesid from the link table)
    - Naren: Specification explicitly in Postgres that these composite keys are "specificaly" stated as composite keys in the database. Otherwise, Postgres would not recognise this unique constraint. 
    - Harper: Mentions that for the frontend designs, there isn't any specific use for these user link role + species utility link table at the moment.
    - Tri: Upon investigation, no issues with having multiple role ids identified. Responding to Harper's question, at the moment, there isn't a use to call the respective table at the moment. 
    - Tri: Querying male and female genetic source data missing in Postgres - Re-migration of the database again to include these missing data from the MS Access DB.
    - Tri: Querying for missing variety and genetic source data missing - Foreign keys are detected by the pywin/migration script established are wronging routed at the moment (as they are flipped). 
    - Naren: Querying for missing variety and genetic source data missing - Was this modification of data part of our job scope requirements?
    - Tri: Issue of this missing data: Foreign key for male and female genetic source TO genetic source id, is not detected by Pywin module. Due to that, explicit definition of foreign keys have to be made for those columns.
    - Tri: Variety and Gentic Source foreign keys are detected with the Pywin module to be of the other way. Current solution, ignore incorrect foreign key detections and add explicit definition for foreign key. 
    - Tri: Solution for this missing data: Highlight that data for the foreign key has to be manually "hardcode" an SQL query that will add that foreign key addition for us, instead of originally reading from the MS Access data and migrating accross. With this done, re-migrate the database to get the latest data.
    - Tri & Naren: Query on missing data on the frontend side of the house - Should missing data's found as NA or configure the routes for it and when client remigrates to the new DB with all the data there, it will be pre-loaded. 
    - Chloe & Naren: Recommend to leave it as currently N/A as data is missing currently. Collate a list of these missing data and highlight to the client. 
    - Tri: Highlights that client has provided the team with incomplete database, therefore, it's acceptable that we can configure the route and leave it blank at the moment. Best course of action that leave it as blank/empty. 
    - Naren: Migration folder clean up has been completed. Tri has moved that test script into the correct folder and Naren has cleaned up the old remnant data.
 - **Ryan:** Linux & Windows setup of docker setup 
    - Docker setup for Window and Linux worked well. 
    - Minor issues with AARCH64 architecture (like difficulty in installing docker for specific OS), otherwise, no futher issues.
 - **Harper:** Routings subdirectories changes from client and fixing of viewtable bugs (overflow) 
    - Suggested changes on Routings and highlighted to Kevin. Pending reply from Kevin on his proposed solution to this. 
    - Fixed viewtable bugs found and provided solution to team members if they occur it during development. 
 - **Dennis:** Progress on Add Screens 
    - Dropdown list implemented for Add_plantings & Add_family
    - Brought up new issues to be addressed and tackled. (Further explained below in Item 2)
<br>

## Item 2 - Addressing new challenges and brainstorm solutions

### Discussion
 -  1) Re-migration to occur due to minor script issues
    - Identity foreign key auto-increment issues, causing POST route issues. (E.g. Unable to "Save" users input from frontend and send data to database) 
    - Use of PyWin Migration script causes data to be missing. (E.g. Variety + Genetic source, Male and Female Source). Current workaround is to hardcode certain key values in order to work. 
 -  2) Missing data found Post Migration
    - Proposed solution: Leave database as it is. No changes to be made but put a comment/note to highlight during hand over on these missing data (I.e. Male and Female source, Variety and Genetic Source)
 -  3) Backend - Custom dropdown data to be crafted 
    - Sample entries like "Genetic Source", "Species + Variety", "Choose a Record here" found on the prototype requires merger of multiple table and creation of a unique string + careful linkage to database table.
    - Proposed solution: Harper has provided a working solution (found in "View_Genetic_Source_widget.dart"). Team to work work referencing solution and tweak for their screen designs. 

### Actions
 - Everyone: Merge outstanding PRs 
    - Tri's new comments for the docker readme setup.
    - Tri's latest migration script changes.
    - Harper's latest work with implementing view table screens. 
    - Naren's migration of new "backup.sql", modification to docker setup scripts (e.g. "docker-compose.yml", ".env") into our mainbranch 
    - Dennis's latest updates + routing additions to add screen designs.
 - Naren -> Add_Progeny screen 
 - Tri -> Add_Acquistions screen 
 - Ryan -> Add_Provenances screen 
 - Dennis -> Add_Varieties screen, clarify with kevin on following screens (Add_Varities, Form Species Update table, Plantings Cross Tab reports)
 - Chloe -> Manage Lookup tables 
 - Harper -> View tables 
<br>

## Meeting Closed: 2200

## Next Scheduled Meeting: 1st OCT 3-5PM (EZone NTH 202B Meeting Pod)
