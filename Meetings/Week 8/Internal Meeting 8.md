# Minutes

- Date: 15/09/2025
- Present: Dennis, Harper, Naren, Chloe, Tri, Ryan
- Absent:
- Apologies:
- Venue: Online - Discord
- Minutes by: Chloe
- Meeting Start: 9:00pm

## Item 1 - Re-scheduling Client Retrospective
> **<Description>**


### Discussion
- Have to reschedule client meeting, Kevin can only do Thursday
    - Cannot do Thursday at all: Naren, Ryan, Harper, Dennis
    - Tri: Can do anytime Thursday
    - Chloe: Between 11am and 2pm Thursday.
    - Client Retrospective: 12-1pm. 

- Need whole team present for team retrospective. Don't need all of us for client retrospective. 

### Actions
 - Tri: To organise Client Retrospective time with Kevin
<br>

## Item 2 - Backend Checkup and plan
> **<Description>**

### Discussion
 - Tri wanted to put some time in backend, wants to get that moving, but didn't want to overstep. Main focus until Wednesday: Making tests for the backend
 - Ryan: Had a chance to connect to database. Health check responses working. Should discuss where we should go from here. 
 - Docker set-up.
 - Tri: Asks Naren - latest migration script utilised? 
    - Naren: Using his script that passes all the test. Should be the latest version.
    - Tri: Added a few more tests.
    - Action Naren: To make sure database has utilised latest migration script and passed `test_migration_schema.py`. Wants to show client the latest version of the database migration. 

- Tri: Started with arbitrary page. Thinks he understand it relatively well. Went to add_pages, looked at planting pages specifcally. Went to widget, http, conda? not sure if it's necessary
    - Function for submitting planting to some URL. Only tested function for submit planting, not sure how well it connects to database. 
    - Function to submit plantings. Make it run function when press button `submit plants`. Tried to run some tests through test_BackendUnitTests.py (unit test)
    - Ignored postgres for now, utilised sqlite instead.
        - Library -> add pages -> add_plantings_widget. Function that works when submit button is pressed.
        - Made a few changes to App to make sure everything runs

- Ryan: When linking up database to API - kept throwing importing errors.
    - Importing app.database - doesn't work properly since it's in same directory
    - App has been reworked
    - Move main out of main file...?
        - Tri: We should look at another solution. Move test into app...? Would rather have test outside of app.
    - Running from app directory...? 
    - API can be run, send diagnostics, health checks should come back with 'OK'
        - Follow instructions in API README.md -> tells you to set up venv and set up all requirements, export all database credentials from docker. Get credentials, export as env variables, run main.
        - API itself should work. Docker is nice, don't have to do postgres on laptop.  

- Have until Wednesday to finish up as much of the backend as we can. 
    - Frontend -> Make appropriate POST request -> Database
    - Complete add_pages...? Write function for submitting, HTTP request, call it when pressing submit button, routes in `main.py`. 
    - User stories: No user stories for add_pages and view_tables, marking us on everything related to viewing planting records, managing seed lot details and viewing custom planting and breeding reports. 
        - More effective for our marks: Select specific add pages and specific view tables...etc. A few different functionalities. 

- Linking to Postgres or SQLite?
    - Intermediate acceptance criteria? No immediate mention of Postgres.
    - Everything has been successfully migrated.
    - Demonstrate how we have pass the intermediate acceptance criteria. Do it manually or show our unit tests. 
    - All code from now on: write to Postgresql. 
    - Backend now - overwritting postgresql and writing sqlite.
        - App: Postgresql
        - Test: Currently using sqlite. Trial test. Might decide on Postgres later, but not sure how well it's integrated with backend. Tri: Might change to postgres once Ryan's completed that. 

- Python environment: API README.md

### Actions
 - Naren: To make sure database has utilised latest migration script and passed `test_migration_schema.py`. Wants to show client the latest version of the database migration. 
 - Ryan: Remove database credentials from GitHub. Config file, Naren's README.
 - Everyone: Follow instructions on README - API Backend. `requirements.txt` - in App folder. Might be missing some requirements, need to double check. 
 - Clean up GitHub repo, documentation in the near future. 

<br>

## Item 3 - Current Progress and Allocation of Work
> **Making the agenda for the client retrospective**

### Discussion
Sprint 2: 
- Database migration - Completed.

- Pick a couple of pages from each type. Implement them based on user stories and acceptance tests.
- Until Wednesday? One/Two of each Type. 
    - Viewing Planting Records. [Optional] Filtering and sorting...? 
    - Everything related to planting. 
    - Chloe: One person per type of page...? For Sprint 2 that will be sufficient. 
        - Add [Dennis], Update [Ryan]
            - Acquisitions, Plantings
        - View Table [Harper]
            - Users, Species
        - Manage Lookup tables [Chloe]
            - Manage Conservation Status
            - Manage Container Types
    - Change history - not going to do. Out-of-scope. 
    - Seed lot details? Species. Custom planting and breeding records. 

Sprint 3: Tri - Look more into making comprehensive tests.
- Make backend, but need people making tests for backend. 
    - Naren and Tri: Making intermediate acceptance tests for backend. 
        - Naren: What kind of tests we have to do? To be on the same page. 

- Test: POST, GET requests are correct? Changes being made into Postgres Database?
    - Replace use of SQLITE instead, Postgres instead. 
    - Setup another database? Or run it locally? 
    - Anyone who wants to run Postgres will have to run the database locally. 
    - Backend test: Start with creation of tables, but tables are empty.
        - Ensure data being displayed correctly. Add and Update, especially.
        - View / Manage lookup tables - preexisting database. But add/update - use another database (separate mock database). 

### Actions
- [Ryan]:
    - Remove database credentials from GitHub. Config file, Naren's README.
    - Update Pages (Acquisitions, Plantings)
- [Dennis]:
    - Add Pages (Acquisitions, Plantings)
- [Chloe]: Manage Lookup Tables (Manage Conservation Status, Manage Container Types)
- [Harper]: View Tables (Users, Species)

<br>

## Item 4 - Planning of client retrospective. 
> **Making the agenda for the client retrospective**

### Discussion
- Frontend: Quickly demonstrate all frontend pages created.

- Database migration: Show pgadmin. Demonstrate using `test_migration_schema.py`, `test_migration_other.py`. Table and pgadmin4. 
    - Alternatively, just pull up API and documentation link that lets you run get request and endpoints manually. Demonstrate how the endpoints can be successfully connected.
  
- Backend: Demonstration of tests. Routes and FastAPI. Functionally prove that it works by seeing how the request goes through.

> Further information: Tri has made more notes regarding presentation. 

<br>

## Item 5 - Project Manager Allocation

### Discussion
- Swap at Week 9 - 10: Dennis to be Project Manager.
- Tri to be Project Manager in Week 11 - 12. 

## Overall Actions
- Everyone: Follow instructions on README - API Backend. `requirements.txt` - in App folder. Might be missing some requirements, need to double check. 
- [Ryan]:
    - Remove database credentials from GitHub. Config file, Naren's README.
    - Update Pages (Acquisitions, Plantings)
- [Dennis]:
    - Add Pages (Acquisitions, Plantings)
- [Chloe]: Manage Lookup Tables (Manage Conservation Status, Manage Container Types)
- [Harper]: View Tables (Users, Species)
- [Naren]:
    - To make sure database has utilised latest migration script and passed `test_migration_schema.py`. Wants to show client the latest version of the database migration.
    - Making intermediate acceptance tests for backend.  
- [Tri]:
    - To organise Client Retrospective time with Kevin
    - Making intermediate acceptance tests for backend. 

-  Clean up GitHub repo, documentation in the near future. 

## Meeting Closed: 10:45pm 

## Next Scheduled Meeting: Wednesday 17th September: 3pm - 5pm 
> Team Retrospective: In-person. Recording Team's thoughts on how the project is going, How our team is going.
> Make user stories. 
> Prepare for Client Retrospectives.
