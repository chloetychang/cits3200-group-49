# Client Meeting 1 - Minutes Template

- Date: 
- Present:
- Absent:
- Apologies:
- Venue:
- Minutes by:
- Meeting Start:

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
- Confirm primary users and environments (whether the application is designed predominantly for field or office use)
- Validate feature priorities
    - Record creation & updates (planting, seed lots, suppliers, breeding)
    - Lookup tables (taxonomy, planting zones, user roles)
    - Reporting features
    - Will offline capability be required?
    - UI Considerations?

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

**Skills and Resources**
- Any existing data records, schemas, documentation, or prior systems we should review?
    - Account for specific data security requirements
- Potential stakeholders we will need access to? (For example: garden manager, field staff)

### Suggest possible risks to the project and how the team will avoid or mitigate those risks.
**Risks and Mitigation**
- Data Security and Role Management
- Potential considerations: Field usability or connectivity limitations 
- User onboarding and access control clarity (role management - systems security)
- Data migration challenges (Access to PostgreSQL)

### Definition of "success" to the client. According to the client, what will the ideal sprint 1 product look like? What components should we prioritise?
> **Interpretation from the Project Description:**
> - Initial release of the database may be implemented in Microsoft Access. (PostgreSQL version, packaged in a Docker container, is expected to follow shortly for ongoing development and deployment.)

<br> 

**Sprint 1 Expectations**
- What would a successful first sprint deliverable look like?
- Key components to prioritise?
- Overall success criteria for project?

## Action Items

- Meeting Closed:
- Next Scheduled Meeting:

## Digressions
