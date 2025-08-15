# Minutes Template

- Date: 11/08/25
- Present: Kevin, Tri, Dennis, Chloe, Naren, Harper
- Absent: Ryan
- Apologies: Ryan
- Venue: ICRAR
- Minutes by: Naren, Chloe, Tri
- Meeting Start: 10:00AM

## Item 1 - Requirements, Out of Scope, Project Acceptance Test, and User Story Review
> **Review that the requirements, tests and user stories listed in the sprint 1 deliverables reflect what the client is looking for**
> ### Discussion
 - User Stories:
    - Grouped User Stories by Stakeholder
    - Two roles: Admin and User
        - Garden Manager: Admin, Volunteer: User
        - Lookup tables are pretty simple
        - Adding user: Something Yhub has to sort out on their part in the long-term
    - Keeping current structure for submission, but keep the roles in mind when developing
    - Visitors to the Garden: Future (out-of-scope)
    - Changes to the database: Wanted to be able to see what changes people have made to the table and who created the changes.
        - Confirmed requirement, but database changes, not structural.
        - Something within the database that needs to be sorted.
    - Garden Manager: Will have the responsibilities of what is currently at Botanist and Research Analyst
        - Client: Wants a more simplified structure
    - System Administration section: Want administrator to remove users...?
        - Table in the Database that rolls to users
        - Block of code in there that "pretends" to do things
        - In both GUI and server. In GUI, should never show people who do not have permissions things that they shouldn't view.
            - We can stop people who do not have permissions to do things.
    - General User: Can't see lookup tables...etc
    - Admin: Can modify + view everything else
    - Ability to add different roles as we go on, but currently only two roles have to be defined.
    
    - Migrate database - Should be in Sprint 2 User Stories. Future considerations. (Comment in Google Doc).
        - Can't do anything before the database gets migrated over.
        - Or else only one user can really utilise the functionality. Can't commercialise current prototype. Looks you to a Microsoft platform with only ODBC access.
            - Multiple devices coming into FastAPI. Connection Policy? Five connections coming on at the same time. 

- Project Acceptance Tests
    - Additional test for Database Migration
        - Client: Should be Test 1
        - $50 goes to the database.
    
    - Login functionality: Out-of-scope
    
    - Devices: Tablet, Android (easier one to do), iPad (nightmare to get set-up, need XCode installed, right version of Swift...)
        - Prototype and attach on iPad, but generating compiled code and uploading to beta test store...might take a month and a half to certificates (Apple is cautious about malware)
            - Something for later, and can get someone else to do the job.
    
    - Role Allocation - Two different types of users, regular user should be able to do planting (call planting information, using this seed lot, doing this). Other stuff is admin stuff around lookup table.
    -  One screen working? Other screens will simply tumble out.

    - Simple table, not even passwords are required. Login - as super user, user
    - Username, Password (that's just a field with not much functionality)

    - Database utilisation Test
        - Coming out of your 
        - FastAPI: Write lots of tests. Will cover those as you develop the application.
            - POST, GET, PATCH: Check all of those works.

    - Table Viewing and Analysis
        - System currently is a bit dumb, no pagination.
        - Takes time to render. Groups of 100...difficult.
        - Non-functional requirement: Seconds to retrieve a table, preferably. Minutes? Distinct fail.

    - Modification log
        - Database...?
        - Acceptance tests that prove that database is migrations 
        - Deleted from Database? Check that it's vanished in postgresql as well.
        - Primary key should be maintained from initial database to current database. (Conservation of Primary Key)
        - Getting all constraints and rules in. 
        - Functionally exactly the same. 
            - Database itself might take 2 sprints.
    
    - Scope of Work Requirements
        - Login Screen: Username, Password, Okay?. Password doesn't need to do anything. 
        - Tab & Roles: regular users can only see plantings tab. Superuser can see all tabs
        - Non-functional: performance (~5 seconds)
        - 3 components: Database migration, FastAPI, GUI (Figma)

 ### Actions
 - Modify project acceptance tests to structure similar to $$ outline given - Tri
 - Add Kevin to Discord server - Chloe
 - Send details of setup error to Val. Need to get prototype up and running ASAP - Tri
 - Review criteria for non-functional requirements - Chloe
 - Submit Sprint 1 - Team
<br>

## Item 2 - Other Questions
> ### Discussion
 - Is implementing a login system with AWS cognito part of scope?
    - no

 - Can we get the finalized input fields for each tab in the lookup management form right now?
    - To be Confirmed in sprint 2 is okay

 - Do the numbers/criteria used for the non-functional requirements seem right to you?
    - Just consider what you would consider reasonable when using an app
    - Criteria like reliability and modifiability not in scope. But, do what is considered good practice. 

 - Is offline capability something that is part of our scope?
    -Not needed

 - Should we consider visitors to the garden as a significant stakeholder for this project (Guest)?
    - No

 - Are there any performance, memory, throughput constraints we should consider for the app? 
    - Don't need to worry about it if FastAPI can run on our machine. Go with lowest, cheapest specs for now. 

 - Risk RAID log questions (to be ran by Dennis)
    - Val is only one working on database. 
    - Next point of contact apart from Kevin: Val. Apart from that, can't do much
    - Assume all data put into database correct

 - Do you have a preferred format for us to submit the sprint 1 deliverables? Should we email the deliverables to you? 
    - English. 

 - Should we put testing in requirements
    - Not needed in requirements, but would recommend doing it because good practice. 
    - Recommend using a Py environment rather than Github to run tests. 
    - GUI tests may be an issue. Tedious and time-consuming to write. Recommend only check main functionality

 - Are database changes in scope
    - No, but expected that changes in AccessDB are reflected in PostGreSQL

 - Remember that tablets will be used landscape, not portrait
 
 ### Actions
 - 
<br>

## Item 3 - Prioritize requirements/acceptance tests in terms of $100 system
> **Get the client to give definitive priorities for which features are most desirable (needed for Sprint 3)**
> ### Discussion
    - $50: Getting database working, without that, system is useless.
    - $25: FastAPI Server
    - $10: Design and Implementation of GUI
    - $10: Android working
    - $5: IOS working.
 
 ### Actions
 - 
<br>


- Meeting Closed: 11:30AM
- Next Scheduled Meeting: 10:00AM via Discord call
