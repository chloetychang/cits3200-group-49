# Minutes 

- Date: 24/09/2025
- Present: Dennis, Harper, Naren, Chloe, Tri, Ryan 
- Absent:
- Apologies:
- Venue: EZONE NTH 202B 
- Minutes by: Tri
- Meeting Start: 1700

## Item 1 - Client retrospective catch up
> **Catch up of client retrospective and key takeaways from that meeting for members who weren't able to be present.**

### Discussion
- Separation of routes suggested by client. 
    - Chloe: instead of everythin in main.py, separate each page/table into its own separate routing folder. 
    - Tri: we made the routes folder with plantings.py with Kevin
    - Chloe: we can implement some of the routings and sub-directories and submit them to Kevin to make sure that we are doing it correctly.
    - Tri: Kevin also mentioned something about splitting the schemas in schemas.py into these sub-directories.
- Database migration comments
    - Kevin stated that the previously identified issue with the foreign key between genetic source and variety needs to be added
    - Tri: Spend no more than a few hours investigating, and if we have no leads, just tell Kevin that we couldn't conform to it. May only input it explicitly, but issue is that there is some foreign key constraint being violated. 
    - Naren: Investigate it until end of this week, mainly the main cause and seeing if we can get it done. 
- Chloe: client stated only tablet and desktop need to be implemented. They do not imagine that they will be using mobile. 

### Actions
- Harper: more investigation on structure of routes within the project. When she has completed one routes structure, she will submit to Kevin. Probably a screenshot of the sub-directory structure to Kevin. To be submitted by Saturday Night.
- Naren & Tri: investigate cause and solution to genetic source and variety foreign key issue by end of week 9. In the next internal meeting will decide if the team needs to inform Kevin about it. 
- Tri: female & male genetic source foreign keys to be added explictly. 
<br>

## Item 2 - Progress check in on Backend/FastAPI integrations 
> **<Description>**

### Discussion
 - **Dennis:** Progress on Add Screens
    - Drop downs referencing other tables now have drop downs that allow selecting of names rather than ids, but having issue where database is rejecting the new rows
    - Tri: the likely reason is because the data being submitted is using the names rather than the ids, which would be violating the constraints on those tables. 
    - Allocation of backend implementation tasks for the team to be done in the next meeting when base cases of each type of backend has been completed
    - Update and manage_lookup tables to be managed later
 - **Ryan:** Progress on Update Screens +  Removal of user stories that we are no longer acting on, and add user stories that we have discussed, now that we know we can implement all cases and can help with all use cases.
    - Clarification of user stories: Are the user stories that we made for sprint 3 are they final for spritn 3 or will we build on them
    - Chloe: Kevin doesn't care too much about the user stories, mostly just as a requirement for CITS3200
    - Tri: there are no plans to expand on the user stories for the rest of the project
 - **Harper:** Progess on Centred Authentication - JSON web token
    - Put the empty authentication parameter into all routes. 
    - view_genetic_source route implemented. But identified bug where some provenance items are unknown which should not be happening
    - However, foreign keys are displaying names not id's, so can be used for future pages to be implemented
    - Acquisitions is not a table name, so not sure what to do with it.
 - **Chloe:** Progress on Manage View Table Screens
    - Realized some of the functionality for the backend wasn't able to be ran on her device
    - Spent her time consolidating the documentation into a single README, and put the entire system (frontend, backend, database) into a single Docker container
    - She wants everyone to make sure that they can run her Docker setup on their system before they merge into main. 
 - **Tri & Naren:** Progress on Github Repo Cleanup + Tidying
    - Compiled list of sprint3 tasks
    - Integration & System test, database migration comments/finalisation from client discussed.
    - Documentation on how to run test (everyone else to run on their own machine)
    - Highlights that investigation of database migration should not take more than 2-3 hours.
    - If not needed, can re-role into QA test or backend routings.

### Actions
 - Every team member to run the Docker setup on the documentation_backend branch and ensure they can run it so it can be merged by the next internal meeting.
 - Implement the drop down functionality and post requests to add/change data. probably plantings. 
 - Harper to ask Kevin about what Acquisitions is. 
<br>

## Item 3 - Database Migration final tasks
> **Discussion on final set of database migration changes based on client feedback and previously determined tasks.**

### Discussion
 - Already discussed what the client stated
 - Tri: Will move the tests to the test folder
 - Tri: subdirectory for reports and other miscellaneous files. 
 - The final migration script will be the one Tri made. 
 - Naren: when should I finalise the database in the docker into backup.sql
    - Chloe: Wait until you've investigated the database migration points from the client and for everyone to confirm that they can run her Docker setup on her branch. 

### Actions
 - Database and script will be finalised in the next meeting
 - Investigate the client's points and clean up migration folder by next meeting. 
 - Naren to tidy up migration folder. Tri to move tests to test folder and make sure they can run there. 
<br>

## Item 4 - Plans of Action
> **Planning of task allocation and meetings for next couple of weeks.**

### Discussion
- Organise internal team catchup
    - Tentative for Sunday night on Discord
    - Naren needs to confirm if his job will not conflict with that date
    - After dinner period (8:00PM or 8:30PM)
    - Dennis: the meeting will aim to be about 1 hour. Just a checkup on everyones progress and the points raised in this meeting.
- Task allocation
    - 
- Time availabilities plan from internal team retrospective
    - Should everyone have set in stone times where they are available to be contacted?
    - Decision is that expectation is that replies are within a day. That is, every team member will check the Discord at least once a day. 

### Actions
 - Next meeting will be Sunday 28th Sep. ~8:00PM. Subject to Naren availability. 
 - Task allocation for next meeting
    - everyone: docker setup in documentation_backend branch
    - Tri & Naren: investigation of databse migration tweaks and migration folder cleanup. Make progress on integration tests. 
    - Chloe: Technical support for docker setup
    - Ryan: Linux & Windows setup of docker setup. 
    - Dennis: add_plantings and add_family.
    - Harper: routings subdirectories changes from client and fixing of viewtable bugs (overflow) 
<br>

## Meeting Closed: 18:00

## Next Scheduled Meeting: Sunday 28th Sep. 8:00-9:00PM
