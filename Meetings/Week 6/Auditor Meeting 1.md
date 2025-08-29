# Minutes Template
- Date: 27/08/25
- Present: Mahit (Auditor), Chloe, Tri, Ryan, Naren, Harper, Dennis
- Absent:
- Apologies:
- Venue: EZONE NTH 202C
- Minutes by: Dennis
- Meeting Start: 1600

## Item 1 - Mentor meeting reflection
> **Reflection of action items from mentor meeting.**

### Discussion
 - Tri: Formalising of roles and responsibilities allocation for the Frontend and Backend.
 - Tri: Clarifying that the assigned person who will be responsible for the test requirements.
 - Chloe: Frontend - Sending screens to the client for review and feedback before writing the Frontend unit acceptance tests.
 - Tri: Clarifying for Backend team, How are the unit tests for the Database Migrations being created? Are they before creating the plan for Database Migration or during?
 - Ryan: Mentions that they will do it during the database migration plan.
 - Ryan: Reduce in project availability from 29th August onwards due to ongoing commitments with other units.
   
### Actions
 - 
<br>

## Item 2 - Frontend demonstration, discussion and submission for feedback to client
> **Frontend team demonstrate what they have created, the team will discuss improvements, and the team will prepare to send the frontend drafts as screenshots to the client**

### Discussion
- Demonstration:
    - Chloe: Clarifying on the why the Frontend Team hasn't been pushing the work on to Github as frequently. Due to FlutterFlow's interface and bug fixes, the Frontend team has fixed up the bugs and are now frequenlty pushing the updated change in work.
    - Chloe: Highlighted that "Update Statistics" portion is currently unavailable, and will require further clarification with Kevin & Client if they still want this feature.
    - Chloe: Highlight some issue for the mobile responsiveness to be fixed accordingly.
    - Harper: Volunteers to fix the responsiveness and standardise it across all the screen designs
    - Chloe: Clarification to Dennis on how the bug fix was resolved
    - Dennis: Through trial and error with FlutterFlows interface, playing around with the settings, eventually getting it to be responsive across all devices.
- Feeback & Submission:
    - Chloe -> Team: If the current FlutterFlow front end screen designs are ready to be sent for review to the client.

### Actions
 - Frontend Team -> Kevin: 1) Share a few screenshots of the FlutterFlow (Instead of all 47 screens), review and amend if there are any changes required from Kevin, 2) Share the FlutterFlow project (Read Only access) to Kevin and the Client for them to view and explore with the designs.
 - Tri -> Frontend Team: Once Kevins confirms the screen designs, then proceed with starting work on the backend routes (FastAPI). 
<br>

## Item 3 - Database Migration demonstration, plan of action
> **Demonstration of tests for database migration, migrated database showcase, plan of action for rest of sprint 2**

### Discussion
- Tri: Showcased the V02 Database Migration Schema tests.
- Ryan: Showcased the new and cleaned up MS Access Database Entity Relationship Diagrams.
- Tests demonstration (and potential submission for feedback to client):
    - Tri: Showcased unit tests created for the database Primary Key, Non-nullable arguments are tested during the migration.
- Comparison of migration results:
  - Chloe: Clarification on the database migration tests (Are the completed as of this moment?)
  - Tri: Highlights that PostgreSQL database is there, but does not currently have unique or foreign key constaints as of now.
  - Naren: Highlights the use PyODBC is very manual and laborous (each tables have to be read manually first, to then understand the database schema constaints of MS Access) but allows fine grain of control for each database schemas.
  - Ryan: Highlights that the backend using mostly the Views table which are non destructive.

### Actions
- Tri: Migrations schema tests file - Migrate the Engine portion of code from the end of the file to the top.
- Backend Team: Continue finshing up all PostgreSQL constraints into the Python Script file and Database Migration Tests to pass by the end of Sprint 2 .
- Backend Team: Wait for kevin approval and review on Database Migration files before pushing Database Prototype into Github.
<br>

## Item 4 - Submission for feedback from client. 
> **Screenshots of frontend, and planned deliverables for sprint2**

### Discussion
 - Tri: Don't specifically promise at the current moment for the backend unit tests are created in the email to confirm sprint 2 deliverables. (Backend unit test will be delivered in actual in Sprint 3)
 - Chloe: Clarification on Frontend unit tests (are they specifically for the Responsive Designs, specific functions that must work, etc)

### Actions
 - Tri: Confirmation on the planned deliverables for Sprint 2:
    - Database Migrations:
        - Database Migration tests scripts (Access to PostgreSQL) to showcase that successful migration will enforce all requirements (i.e constraints, keys requirements)
        - Final Database copy (Final PostgreSQL db) after migration was successful
    - Frontend:
        - Final Screen Designs
 - Tri: Confirm with kevin if the will continuely update us if they get a new version of the database. Otherwise, to get a weekly (Friday) update if there are any changes to the MS Access Database.
 - Chloe: Write list of considerations that's been applied during the Frontend screen designs on FlutterFlow (e.g. making it responsive for mobile, tablet, desktop, etc)
 - Naren & Tri: Create README.md for migration documentation which includes instructions on migration tutorial (e.g. Install dependencies, files ran, etc)
 - Tri: Add Auditor (Mahit) into the Github repository with viewing access.
<br>

## Meeting Closed: 1700

## Next Scheduled Meeting: TBC
