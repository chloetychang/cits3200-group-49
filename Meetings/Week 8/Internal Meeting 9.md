# Minutes

- Date: 17/09/2025
- Present: Ryan, Dennis, Naren, Harper, Tri, Chloe
- Absent:
- Apologies:
- Venue: EZONE NTH 202B
- Minutes by: Chloe.
- Meeting Start: 3:00PM

## Item 1 - Backend Finalisation.
> **Finalising backend and backend tests for sprint 2.**

### Discussion
 - Tri: In the test folder, created a readme file. Follow the instructions, should hopefully be able to run tests
    - test_postgres_connection: adapting migration test, but testing database put in .env file. Should tell you if postgres database is correct
    - backend unit tests: for the rest of the tables that we have to put in meeting minutes (Internal Meeting 8.md), only for Planting table for now. Testing routings in isolation. Tri will have more of a think on how unit tests are structured, making sure route works
    - integration tests: testing that payload (put into route, route makes change in database), check query to postgres
        - fastAPI running on one terminal, tests running on the other
        - presented to client? up to them. don't see any harm in presenting to them though.

- Ryan and Harper: It works. More details in Discord chat.
    - Harper - Requirements file: Should change some of it.
    - If Harper can merge her branch by today that would be amazing.

- Dennis: Sprint 3 - Final Deliverable: Linking of frontend to backend. Full app?
    - Tri: The way we structured workflow - planning to do that in Sprint 3.
        - MVP: Connect just a few page. 
    - Chloe: Moved frontend testing from Sprint 3 to Sprint 2 due to Flutterflow. 

- Continue working on pages as delegated in Internal Meeting 8.
    - Harper: Did two pages for View Tables.
    - Chloe: Two pages on Manage Lookup tables.
    - Ryan: Two pages on Update Tables.
    - Dennis: Two pages on Add Tables. 

- Migration: Multiple migration scripts on GitHub, discuss on further action.
    - migration_test.py -> just so we can run test_migration_other
    - actual migration_script -> migration.py

- Backend: routes in main - gives you access to main
- API routes: take information from main, individual components
- See diagram in groupchat

- Database: Has foreign key (integer) and value (string) in separate tables. Extra logic - perhaps a JOIN query. 


### Actions
 - Sprint 3 - Naren and Tri to clean up migration folder
 - Sprint 3 - Clean up GitHub Repo and Documentation

<br>

## Item 2 - Client Retrospective Trial Runthrough
> **Running of all items to be presented on Chloe and Tri's devices.**

### Discussion
 - Frontend: Show all screens + responsiveness. Quick mention to Kevin, he's already seen the screens. 
 - Database Migration: Demonstrations of tests passed, pgadmin. Show postgres connection tests as well. 
 - Backend: View tables. Open two terminals to run app (frontend and backend). 
 - Tests: Show successful runs.
 - Clarify user story 2. 

### Actions
 - Dennis to push frontend improvements (from flutterflow branch), potential backend changes
 - Everyone to continue working on planned goals

<br>

## Item 3 - Creation of User Stories for Sprint 3
> **Final set of stories to be completed in sprint 3.**

### Discussion
 - Revision of user stories, out-of-date

**Original**

1. Viewing of Planting Records (no changes to this user story)

2. Add note regarding it's a postgresql in-built function, not something we have to implement
    - Kevin: PostgreSQL doesn’t maintain a built-in change log of all data modifications (like an audit log). All the system needs is the ability for a superuser to see all the data. The table will have a last updated column and by who.

- 3, 4, 5. No changes. Can be kept. 

6. Y-Hub user story - covered by maintaining structures.

- Can implement all changes in backend.
- Change log and role-based access out-of-scope. 
- Ensure device compatibility. 

**Modifications**
- Marking key for Sprint 3 Goals
- More pages, can add more user stories based on pages we're doing. Extra use cases?


### Actions
 - Ryan: Remove user stories that we are no longer acting on, and add user stories that we have discussed, now that we know we can implement all cases and can help with all use cases. 

<br>

## Meeting Closed: 4:45pm

## Next Scheduled Meeting: Internal Team Retrospective 17th Sep. 4:45PM START
