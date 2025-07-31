# Client Meeting 1 - Minutes Template

- Date: 30 July 2025
- Present (Team): Tri, Ryan, Naren, Harper, Chloe, Dennis 
- Present (Client): Kevin, DR. Val
- Absent: N.A.
- Apologies: N.A.
- Venue: ICRAR Lobby 
- Minutes by: Dennis. Finalising by Chloe.
- Meet Preparation: 2:30pm - 3:00pm
- Meeting Start: 3:00pm

## Introductions - Client and Project
> **Interpretation from the Project Description:**
> - This project proposes the design and implementation of Botanic Guide, a tablet and desktop application designed to support staff managing the botanical garden under development in Yanchep, Western Australia. The app will be primarily used by the garden manager and field staff to capture, view, and update records relevant to planting activities, seed suppliers, plant breeding trials, and other operational data. The application will provide streamlined access to a complex relational dataset.

## Sprint 1 Requirements - Information required from the Client
### Define scope of work - General statement of what the project is to achieve.
> **Interpretation from the Project Description:**
> - Cross-platform application using Flutter, targeting iPad, Android Tablets, and desktop systems (Windows, macOS, and Linux).
> - Simple, robust user interface that accommodates both data entry in the field and reporting needs in the management via AWS Cognito, enabling secure user authentication and role-based access.
> - Features: 
    > - Include functionality for capturing new user records, seed suppliers, seed lots, and planting data, as well as records for a plant breeding programme in collaboration with Kings Park. 
    > - Users will be able to update all records and manage associated lookup tables, including taxonomy (family, genus, species), planting zones, and user roles. 
    > - The app will also support flexible reporting on all data tables with configurable selection parameters. The user interface will prioritise clarity, responsiveness, and ease of use for staff working in varied environments. 

<br> 

**Clarifying Project Scope**
<br>

Confirm primary users and environments (whether the application is designed predominantly for field or office use)
- Organisation: Yhub Coworking 
Validate feature priorities
- Record creation & updates (planting, seed lots, suppliers, breeding)
    - Add/Update record session & Planting and Pivot Table:
        - VAL: Showing the run through on what the old app looks like, how to interact
- Lookup tables (taxonomy, planting zones, user roles)
- Reporting features
- Server Design
    - Kevin: FASTAPI and PostGRES integration 

- Login Screen: 
    - VAL: Currently no security features (Seems like not a requirement yet - useful for scope of work drafting)

- Will offline capability be required?
    - Response - Docker should have no secrets/online password/enviroment variables.

- UI Considerations?
    - Users (Target Audience): [UI DESIGN]
    - VAL: Non-technical (EASY UI interface), when designing new app UI, try to accomodate to old design used 
    - VAL: Deploying for live users ["NOT SO DIFFERENT FROM OLD RECORD SYSTEM UI DESIGN"] 
    
- Clarification on app use-cases (by Tri)
    - Kevin: Main focus will be on generic access and admin of metatables, conditions, why was this removed of specifc data. (Add/edit/delete) [Add/Update/Delete Slide]
    - Kevin: FASTAPI, sending and request small set of data to and from the database and app. (Helpful tools: SQL model and Pydantic)

### Skills and Resources Audit. What skills and tools the team needs to successfully carry out the project. Confirm tech stack required.
> **Interpretation from the Project Description:**
> - Frontend: Flutter (cross-platform: iPad, Android tablets, desktop)
> - Backend: FastAPI (Python)
    > - Lightweight and maintainable interface that connects directly to the database
    > - Exposing secure REST endpoints to interact with the database
    > - Database: Start with Microsoft Access, then migrate to PostgreSQL in a Docker container
> - User Authentication and Role Management (Access Control)
    > - AWS Cognito - Secure Login and Role-based access
    > - Optional: Future integration with AWS Amplify
> - DevOps and Testing
    > - GitHub - Version Control and Collaboration
    > - CI/CD pipelines (to be developed)
    > - Testing: Unit tests and Usability testing in field conditions

<br> 

**Tech Stack Confirmation**
- Confirm Frontend, Backend, User Management and Role Management (Access Control), along with DevOps and Testing Requirements 
- Are there any preferences or constraints not captured in the brief?

Tips:
- Kevin: Postgres to be in Docker [Ease packaging and usability between different hardwares (mac/windows)]
- Kevin: UI Design Tablets. Tabs are not user friendly.
- Kevin: Testing can be done using Flutter (enables computer visualisation on tablet UI design)
- Kevin: Use intelliJ tool when coding?

**Skills and Resources**
Any existing data records, schemas, documentation, or prior systems we should review?
- Existing data:
    - Species: Good for food, orniments, medicinal 
    - VAL: Volunteer to discover research on species and record data
    - VAL: Species names to be flexible (Changed frequently by scientists), 
    - Ryan: Mentioned that database considerations for the species name have to be careful (Due to primary keys)

- Planting and zones: 17 Zones (Currently) referred to sector of where these plants are housed at (beside Yanchep Train Station) 
    - Seed lots: Packet of seeds bought externally of specific species. [IDs of plant species]
    - VAL: Mentions that with seed lots, they need to know the orignation of where these seedlot comes from. [Swan coast plains?]
    - VAL: Current problem: Plants planted now have no source of origination, provenance and records. [Posing as a problem with data recording]

- Look up tables: Slide missing 1 column "removal clause" column [Why it was removed? E.g. vandalised, dead]
    - Aspect: Which direction plants facing (N,S,E,W)
    - Bioregion: Based on seedlot record data
    - Conservation_Status: Which species, is it endangered, etc.
    - Container: 
    - Location type: What location these plants where taken from (E.g. from which town, surburb)
    - Propogation type: tbc.

- Registration:
    - VAL: Record keeping of who has add/made/change data [Due to this being a formal registration as a park - needs to follow aus data legislation compliance]

- Account for specific data security requirements:
    - Security not a main priority at this point in time. 

- Botanical Research: 
    - VAL: Potential collaboraion with kings park for plant breeding experiments? [New research family/variety - New data entry in database?]
        - With each single seed planted from CROSS BREEDING, a record/provenance data column is needed to track.

- Some technical details:
    - VAL Emphasis: Built in primary keys are all AutoNumber fields that MS access deals with
    - VAL Emphasis: Ensure flexibility of database design with new copy 
    - VAL Emphasis: Existing PRIMARY KEYS ARE NOT TO BE CHANGED (Must be preserved) 
    - VAL: Mentions MS ACCESS ER Diagram 

Potential stakeholders we will need access to? (For example: garden manager, field staff)
- 


### Suggest possible risks to the project and how the team will avoid or mitigate those risks.
**Risks and Mitigation**
Role Management (Systems Security - User onboarding and access control clarity)
- Users and roles:
    - VAL: No access control at the moment. [Currently, focused on preventing accidental deletions of data records - not so much on security]
- Registration:
    - VAL: Record keeping of who has add/made/change data [Due to this being a formal registration as a park - needs to follow aus data legislation compliance]
    - Kevin & Val: Designing of security system for this database/app? [Added on later AWS Cognitio, MFA]

Database
- Database design change? 
    - VAL: preferred not to change the database schema originally. [Handling who recording/update database + Access control on this database requirement]
- Data migration challenges (Access to PostgreSQL)
- Data retention policy

### Definition of "success" to the client. According to the client, what will the ideal sprint 1 product look like? What components should we prioritise?
> **Interpretation from the Project Description:**
> - Initial release of the database may be implemented in Microsoft Access. (PostgreSQL version, packaged in a Docker container, is expected to follow shortly for ongoing development and deployment.)

<br> 

**Sprint 1 Expectations**
<br>

> What would a successful first sprint deliverable look like?
- Kevin: Flutter on the GUI, Why do we need to use flutte? As other project leverages this system and helps with their integration. 
- Target of device: Google Tablets, Ipads. 
- Database: Postgres database, maintain alembic migrations.
- Server: Linux server - FASTAPI. - Another project has the roles/access controls working 

> Key components to prioritise?
- Kevin: Actionable steps: 
    - Design actionable plan on how to migrate the huge database (How to map MS Access to another DB tool)
    - Creating mockup of the GUI design (FIGMA?), Paginations concerns? (Don't want data to transfer for ages), when designing GUI, think about volunteers, admin (Claire), botanists, garderners (Think from the old perspective where it needs to be simple and dummy proof)
    - Mock up/draw diagram: Using MDB tools to convert from MS Access DB to PostGRES DB to convert into CSV of data [Helpful tool: MDB-tools (linux/mac only), python tool (PyODBC) - Windows]

> Overall success criteria for project? Complete app to be utilised by users.

**Future implementations:**
- VAL: Hope to implement a GIS extension [When developing app, it will accomodate for identifying plants to associate with which Zone are planted in.]
- Val: PostGIS extensions

## Action Items
Actions/Stakeholder/Due date/Status:
- OneDrive link: Provides all the access of MS access database, link for old app, etc / Kevin / 31st July / In Progress
- Collate and send all 6 github IDs to Kevin [Set it to public and send to Kevin] / Chloe / 30th July / In Progress

## Closing
- Meeting Closed: 4:00pm
- Next Scheduled Meeting: Debrief - Estimate: 4:00pm-5:00pm

## Digressions
- Yanchep botanic guide is the start, Kings Albert Park is next. [External pressure to get this done well and implement for next parks]
- Photos, videos, of this species of trees/plants over the years.
- Kevin: History/motivation of this app/project, conservation motivation, where 1930, all trees were cut down, water level rises, trees becoming less resistent to salt. Therefore, with seedlots being found "salt resistent", they can be used for cross breeding to conserve. 
- Internal Meeting should happen to debrief contents - Minutes Documented Separately: Refer to `Internal Meeting 1.md`
