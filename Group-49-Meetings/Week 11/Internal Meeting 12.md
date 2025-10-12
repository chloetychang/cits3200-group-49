# Minutes 

- Date: 05/10/25
- Present: Dennis, Harper, Naren, Chloe, Tri, Ryan 
- Absent:
- Apologies:
- Venue: Discord (Online)
- Minutes by: Ryan
- Meeting Start: 20:00

## Item 1 - Progress Checkup
> **<Reviewing everyones progress since last meeting>**

### Discussion
**Chloe and Dennis**  
Update Species page
- Chloe had a chance to implement dropdown
- Debugging routes page
- Chloe suggests that duplicate routes in main may be causing isses, after merging Tri's changes, we can investigate

**Harper**  
Drop down pagenation
- Made progress on fixing the dropdown loading time
- After everyone merges to main, suggests we should troubleshoot for bugs and merge Harper's branch

**Naren**  
Migration Script
- testing migration script pre merge

Add Progeny page
- Researched how best to implement progeny ID
- Tri: that should be able to generate the IDs automatically

**Tri**  
Add aquisitions page
- Fully implemented full stack for page
- Ryan verified that page is operable to post a record to database
- Possibly need to review how aquisition date and time field is filled, autofill format is not being accepted by DB
- Naren identified that access db may have been responsible for time/date issue

**Ryan**
Add provanence page
- implemented full stack dropdowns and post request for page
- ready for implementing primary key sequence fix, after this we can merge
- Tri, Dennis and Chloe confirming page works during meeting so we can merge to main
- Add provanences branch merging to main, merge conflicts occured

### Actions
 - Tri: verify that migration script is ready to merge new migration script
 - Everyone: following Harper's merge confirm that pages are still functional
 - Tri: Adjust aqusition date autogenerate field to match format accepted by db
 - Harper: finalise PR request for manage lookup tables and view pages

<br>

## Item 2 - Project Acceptance Planning
> **<Reviewing what is required for final deliverables>**

### Discussion
Front and Backend
 - to demonstrate add, update, view and lookup table pages, we can populate the fields and investigate changes via PGadmin 

Database Migration
- running test postgres connection and schema test is sufficient to demonstrate Database migration was successful
- Page functionality relies on migration success so demonstrating pages also confirms successful migration

Android and IOS supportability
- Docker allows us to prove functionality via android and ios
- using flutterflow tools, verified that frontend functions in smaller formfactor

Alembic
- Previously client said that alembic wont be part of the deliverables
- Dennis: Since we are maintainting a remigrated instance of the codebase, we dont need alembic but it could be useful as for future proofing the schema

### Actions
In Client Meeting, ask:
 - preliminary acceptance tests
 - what constitutes a sufficient delivery of IOS and Android functionality
 - what is requrired to succesfully complete final deliverables for sprint 3
 - specific doccuments requried as part of final submission for sprint 3

 - Tri: Test wether alembic and lib/backend/schema is nesscesary for delivery
<br>

## Item 3 - Task Allocation
> **<Task allocation for near future>**

### Discussion
 - alembic requirement test actions
 - all view pages and lookup pages work
 - the remaining add pages and update pages still need implementation
 - should we implement dropdown pagination for every add pages?

### Actions
 - Tri: finalise readme for migration and tests
 - Ryan and Naren: start chipping away at remaining add pages (suppliers, users, zone, subzones, varieties)
 - Tri: make issues for remaining add pages for people to self assign
<br>

- Meeting Closed: 21:45

- Next Scheduled Meeting: 08/10/25 client meeting + internal meeting