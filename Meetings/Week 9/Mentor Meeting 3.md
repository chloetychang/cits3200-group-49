# Minutes 

- Date: 24/09/2025
- Present: Dennis, Harper, Naren, Chloe, Tri, Ryan, Maureen (Mentor)
- Absent:
- Apologies:
- Venue: EZONE NTH 202B 
- Minutes by: Tri
- Meeting Start: 1500

## Item 1 - Team Check in - Sprint 2 reflections 
> **Questions from Mentor about delivery of sprint 2 and plans/confidence for sprint 3**

### Discussion
- Mentor: how did your study break go?
    - Chloe: did some work, but mostly focused on CITS3200 individual submissions e.g. PDP
- Mentor: How is your project currently?
    - Ryan: implemented some backend, and part of the final product
    - Mentor: how is the database migration going
    - Naren: Quite stressful in my opinion because dependency on migration to work on backend. When there were issues, I knew the urgency so when I was contacted I stayed up to make sure they were done quickly
    - Mentor: I like how you mentioned the managing of dependencies, very good project team communication
    - Chloe: regarding frontend, we are using a software that makes the frontend easier, but it overwrites everything when it merges so to reduce conflicts, we completed all the frontend in the previous sprint and adjusted our timeline to account for that. We also clarified with the client about changes to the database, changes made after October 1st can be ignored for our project. 
    - Mentor applauded the group for managing that risk and establishing a clear boundary in the scope of the project, recorded in the minutes of that meeting
- Mentor: what is the final stretch of the project looking like?
    - Chloe: considering the date, unlikely to be any changes to the database that we can act on. That means that the frontend is complete, just a lot of integrations between the frontend and backend to work on. 
    - Mentor: seems like communication within group and with client is good. Also, seems like team is confident in the delivery of the project. Seems like team has good momentum going. 
    - Tri: final mentor meeting will be week 12, Wednesday 15th October
- Mentor: any potential risks/roadbumps between now and the submission
    - Dennis & Naren: biggest risk is availability and commitment, most busy period of the semester.
    - Mentor praised dependencies have been met, well structured project timeline/planning, integration flow is well defined and seen by entire team. Also likes how available and responsive the client has been for the team. 
- Mentor: how complicated are the remaining pages to implement
    - Tri: View pages have simpler/less requests, e.g. some add pages require requests to match foreign key id's to names. Chloe also mentioned something about integration with Alembic
    - Chloe: Some pages do require use of Alembic, but team already has done some work on it. 

### Actions
 - 
<br>

## Item 2 -  Q&A with Maureen
> **Questions from the team to the Mentor.**

### Discussion
- Tri: a question about test design and quality assurance, since two team members have been assigned to it since the team has the luxury for it
    - Mentor: Good to have, make sure previous things have not been broken and quickly find issues in early deployments. 
    - Tri: Would less of a focus on unit tests in favour of other tests a good approach
    - Mentor: Hesitate to completely forgo unit tests in favour of others, unit tests should generally be done by developers not QA team, 
    - Tri: to clarify, since 47 pages, don't want to have 47 sets of unit and integration tests, especially if some can be sometimes redundant. How to determine what unit/integration tests would be effective to make
    - Mentor: applauds approach to project, Look at integration patterns e.g. 4 integration patterns which need to be tested thoroughly. Do you then need to test all 55 frontend if only 4 integration patterns. Depends on how confident on the repeatability and uniformance of integration patterns between each page. How do you identify small mistakes between members of same integration patterns. Actual testing is one way of doing it, another way is using code reviews. If team decides to only do code reviews, can rely on later system tests to make sure all integration patterns implemented the same, risk being that errors will be detected later if code review misses it. However, you sound very confident already on the implementation, and there are other methods apart from writing unit tests
- Chloe: Project management - in the case where we presented/planned one timeline, only to realize there is a change in the critical path, what should the team do?
    - Chloe: In our case, a change in the workflow. Initially, implement a few pages before moving onto all pages (frontend, backend). However, in the end, did all of frontend before moving onto backend. 
    - Mentor: was it project team's decision, scope change or team realizing need to change to meet deadlines
    - Chloe: the techstack used encouraged the change
    - Mentor: That is speaking from the developer point of view. Is a complicated situation. In the team's case, since client is understanding team was able to explain situation to them. From client point of view, does this mean that timeline will be longer or cost more money? From lectures, remember to consider client's pressures. If results in longer timeline but client is under timeline pressure, may reject. Key consideration is if previous workflow would work. From Chloe's words, team found a better way, but does not necessarily mean that old workflow woulld not have worked
    - Chloe: New workflow reduced workflow, old workflow would have worked but required more work to complete. 
    - Mentor: what you need to sell to management and client is that the new workflow would result in reduced time and cost, especially if it still allows us to finish on time 
    - Tri: I will add that client mentioned that our different frontend software compared to the recommendation and different workflow allowed the team to complete more of the frontend than they expected, especially compared to the other groups
    - Mentor: Good to have a way of showing to the client the positive effects of changing software/workflow. Only possible because client trusts team, this conversation would not be possible if they did not trust the team or their judgement.

### Actions
- Mentor confirmed that next mentor meeting will be Wednesday 15th October same time. 
<br>

## Meeting Closed: 15:45

## Next Scheduled Meeting: 17:00-18:00 24th Sep. Auditor meeting 2
