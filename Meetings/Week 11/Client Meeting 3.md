# Minutes Template

- Date: 8/10/25
- Present: Tri, Chloe, Naren, Dennis
- Absent: 
- Apologies: Ryan, Harper 
- Venue: ICRAR
- Minutes by: Naren
- Meeting Start: 10:00

## Item 1 - Project Acceptance Discussion
> **Confirmation of how to demonstrate project acceptance**

### Discussion
 - add/update/view/lookup page acceptance design
    - add/update
    - view
    - manage lookup tables
 - database migration acceptance design
    - test_migration_schema & test_postgresConnection
 - Android/IOS acceptance design
    - flutterflow tools
 - Deliverables/Documentation to be submitted

Tri: How can we show the project acceptance?
Kevin: Running it in a emulator unless one of us have a google tablet to turn a thether.
Kevin: Local host, Emulation will doo. Database to run in a local machinese along with API. Emulating the flutter through a browser 
Chloe: Confirming whether flutter through the browser is alright 
Kevin: Confirm, as long as its working in the browser "we can move it to anything"
Tri: Any documentation to submit?
Kevin: Git Repo, GUI and DB migration 
Chloe: Github transfering ownership to Kevin, might have to clone 
Kevin: Wait till you finish the final work 
CONFIGURING GITHUB FOR TRANSFER OF OWNERSHIP
Kevin: Dont transfer ownership 
Tri: Any other documentation?
Kevin: Create a documentary in the github with an appropriate directory 
Kevin: Instruction on how to run the test 
Tri: More focus with system test
Kevin: Acknowledge
Chloe: Is the expectation to complete all page neccesary 
Kevin: NO, Complete as much as you can. "I see you have done the priorities". As long as the most complicated is done, everything is fine
Chloe: Asking what is the complicated pages
Kevin: Add acquisition , platings, 
Kevin: Explaning how variety works in plants and how certain species are more immune to a particular substance (Rewilding)
Kevin: Continue to explain the ecosystem of WA
Tri: In certain add pages, unclear of how to input the data 
Kevin: Dont stress on it, do you best 
Tri: Confirming whether judgement calls are alright 
Tri: Asking Dennis whether generation number will be a dropdown or an integer 
Dennis: Confirming that it is an integer 
Kevin: Generation number is still up to debate, keep as it is 
Tri: In the acquisition, you can select a family name but it doesnt represent a genetic number 
Kevin: Appears to be a bug, we found a few 
Kevin: Base it to the original 
Tri: Issues with date time
Kevin: ISO8601 is the most standard format 
Kevin: List of the features/assumptions 
Tri: Add pages dropdown, we havent implemented pagination 
Dennis: Can search in the drop down
Tri: Judgement call, cant do it due to time constraints 
Chloe: Questioning - drop down format 
Dennis: Explaining our current format 
Kevin: Thats alright 
Tri: Progeny table issues with the structure 
Kevin: In access, cant have two things as a primary key
Kevin: Composite index should be a primary key 
Tri: Current call, we wont complete it as require changes to the structure of the database.
Kevin: "Pragmatic call, good call"
Chloe: Explaning our current docker (Linux discussion)
Kevin: Will run native on ubuntu 
Kevin: Explaining rotating log and its function 



### Actions
 - Doccumentating the system test
 - List of the features/assumptions 
<br>

## Item 2 - flutter showcase and clarification
> **Team to showcase current state of system and clarify ambiguous fields in pages.**

### Discussion
- Tri: Asking Dennis whether generation number will be a dropdown or an integer 
- Dennis: Confirming that it is an integer 
- Kevin: Generation number is still up to debate, keep as it is 
 
### Actions
 - 
<br>

## Item 3 - Progeny Pages Discussion
> **Discussion about whether to keep progeny pages in scope or not.**

### Discussion
 - 3 solutions
    - (preferred) remove from scope since requires changes to database structure to implement correctly
    - Redesign table to use composite unique constraint and correct primary key
    - Remove generate as identity from primary keys, and debug whatever else is required to get it working
  - Kevin: Dont worry about it, do as much as you can 

### Actions
 - 
<br>

## Meeting Closed: 11:00

## Next Scheduled Meeting: 11:00 (ICRAR) 8/10/2025
