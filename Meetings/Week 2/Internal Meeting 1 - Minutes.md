# Internal Meeting 1 (Debrief Meeting) - Minutes

- Date: 30/07/2025
- Present: Chloe, Dennis, Harper, Naren, Ryan, Tri
- Absent:
- Apologies:
- Venue: EZONE Meeting Room
- Minutes by: Chloe
- Meeting Start: 4:00pm

## Item 1 - Workflow Clarification
- If we are working on something not involving code, have a log on Github (Markdown file on GitHub, will be created, with links to external resources such as Figma and Shared Google Drive)

## Item 2 - For Tomorrow: Looking into Access Files in our Group.
Preparation to start Project Work.

- Look at what's in Shared Drive first.
    - iOS: Chloe, Harper, Dennis
    - Android: Tri, Naren, Ryan

- Once we have the Shared Drive...
    - Prototype - every device can access that, but only iOS people can test out iOS features. If something doesn't work, let Val know.
    - Databases 
    - Relook at the Slides
    - Migration Tools. MDB Tools for Mac users. pyODBC tools for Windows. 
    - Docker (PostgreSQL)

### Actions
Chloe: 
- Email Kevin. Send Kevin GitHub IDs of whole team. Create Figma document (tablet setting). Discord Server Invitation - Role: Client.
- Set up a Markdown with external links related to the project (Figma, Google Drive)

## Item 3a: Deliverable 1.
### Expected deliverable for Sprint 1 - Client:
- Preliminary draft designs - Mockup of GUI (Figma).
- Show understanding of how FASTAPI routes work
    - Simple routes going (static data)
    - Pagination
- Start thinking about how to do mapping of Access to another database (Postgres).
    - Conversion from Access to PostgreSQL. Look at MDB-tools - only runs on Mac and Linux. Migration - doesn't matter time. Only do it once and share it to everyone. 
- Export tables and data, but not all the constraints. Can actually access the internal relationship files within Access. Another form of ERL diagrams. Read internal diagrams to discover internal constraints. 
    - Don't need all constraints in to start working. 
- Have an understanding of how Flutter apps are built

### Expected deliverable for Sprint 1 - Auditor:
- A Scope of Work, or, in the language of the Scrum methodology, the Epic. That is, a general statement of what the project is to achieve. That statement can be as informal as a set of bullet points in a text document, or as formal as a Requirements Document (an example can be found here). 
> Chloe. Potentially what client expects as well?
> Requirements?

- A Skills and Resources Audit. The idea is that, before you dive into the project, the team should undertake an audit of what skills and tools the team needs to successfully carry out the project, and therefore what you need to learn/acquire (and from where).
> Ryan

- A Risk Register, i.e. a discussion about possible risks to the project and how the team will avoid or mitigate those risks.
> Naren and Dennis. Table that shows risk and risk classification. Effects of risk and also mitigations.

- Project Acceptance Tests. How will you know that the project as been successful? Like the Scope of Work, this can be as informal as a bullet-point list or as formal a formal test manual, a template for which can be found here. 
> Tri

- A set of stories to be completed in Sprint 2. It is recommended that you also create a set of intermediate acceptance criteria to assess the products of that Sprint for your internal use, but these will not assessed.
> Harper

*Format?*
- Google Doc. Start with one Document first. If it gets too bad we'll split it. 

<br>
 
### Requirements:
- Database migration
- Useability - no complex mouse movements. Accessbility is crucial. 
- Security: To be added later. Not our top priority. Unsure but probably run on the Amazon Cloud. AWS Cognito. (reset passwords, multi-factor authentication...)
- No passwords, no environment settings. Environment public. (for now)
- Access for Administrators: Capturing plantings. 
    - Generic access and admin of metatables.
        - Conditions. Why is this here? Same basic functions. Add, Edit, Delete. 
        - Routes connected to FastAPI. Web-based server. POST and GET with data. 
        - FASTAPI - SQL Model. Define lots of little classes.

## Item 3b: Deliverable 1 Workflow.
1. Look at the shared drive (prototype). (Tomorrow)
2. Google Doc - Auditor. Goal at the end of the day. (Tomorrow - Dennis and Tri: Skeleton. Detailed allocations listed above.)  
   - Chloe and Ryan - Week 3 Wednesday deadline (6th August). Others - Week 3 Friday deadline.
3. Project itself. Client requirements. 


### ACTION: 
- Dennis and Tri: Skeleton. 
- Everyone: Allocated Parts for Sprint 1 Google Doc. 

> Talk about Project Work Allocation on Friday (after prototype has been viewed.)

## Item - Hours Sheet
Discussion on Hours Sheet. 

## Action Items
- Chloe: 
    - Email Kevin. Send Kevin GitHub IDs of whole team. Create Figma document (tablet setting). Discord Server Invitation - Role: Client.
    - Set up a Markdown with external links related to the project (Figma, Google Drive)

- Dennis and Tri: Skeleton of Sprint 1 Google Doc [Done]

- Everyone: Allocated Parts for Sprint 1 Google Doc. 
    - Deadline for Chloe and Ryan: Week 3 Wednesday. (6th of August)
    - Deadline for Dennis Harper, Naren, Tri: Week 3 Friday (8th of August)

## Closing
- Meeting Closed: 6:00pm
- Next Scheduled Meeting: To be decided. LettuceMeet created by Chloe. Dicussion on Project Work Allocation after Prototype and additional documents have been explored. 
