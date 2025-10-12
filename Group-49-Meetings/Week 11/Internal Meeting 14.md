# Minutes 

- Date: 12/10/25
- Present: Dennis, Naren, Chloe, Tri, Ryan, Harper
- Absent:
- Apologies:
- Venue: Online
- Minutes by: Chloe
- Meeting Start: 20:15

## Item 1 Update Species Table
> User Story: Update Species Table

### Discussion
 - formUpdateSpecies table.
 - Tri: Multiple tables would be using the same logic for the dropdowns.

### Actions
 - 
<br>

## Item 2 - The Three Pull Requests
> **<Description>**
- Attempting to merge all three pull requests by tonight

### Discussion
- AddNewFamily - most complicated, do that last. 

1. Looking at AddVarieties first. 
- Tri and Naren: Potential miscommunication on Genetic Source dropdown.
    - Copying Genetic Source dropdown from Ryan's AddPlantings page.
- Naren: Variety Table - Pick Genus first before Species. 
    - Took around 10-20s to run the first time. 
- Tri: Confirming that AddVarieties can be run

2. AddPlantings
- Dennis has run the page before the meeting - it works on a Mac
- Ryan: Implemented extra component for varieties for convenience. Don't think this will break the view table.
- Tri: Fixing merge conflicts due to extra function added.
- Ryan: Slow loading speed with Species dropdown. No pagination. Given permission from Kevin. Naren has genus dropdown to assist, but not in this case.

Tricky part of implementing these pages: Dropdowns, not the POST requests. 

- Current state of AddPlantings work. 
- Tests: No time to implement them currently. As long as ViewGeneticSource doesn't break when this is merged, we're good. 

3. AddNewFamily
- Merged pull request
- Utilised View Table to check

### Actions
 - Potentially resolve Genetic Source dropdown for varieties.
 - Genetic Source and Varieties. POST requests for the extra pages. 

<br>

## Item 3 - What we should try to implement by tomorrow(?)
> **<Description>**

### Discussion
 - Tri: Try to implement the two update pages for the two add pages he completed.
 - Naren: Do not have the capacity to work tomorrow. Already skipped work yesterday and today to work on this unit. 
 - User Stories - Data Manager (View Planting Records), View and Update Records on Seed Lot details (Genetic Source), Botanist (Genetic Information for plants), Select genus and update species name, custom planting and breeding reports.
 - Tri's Goal: Update Acquisitions, Update Planting, and Update New Family completed. Varieties Dropdown, Update Species, Simple POST request.
 - Ryan: Not sure if it's fair to try to add new things right before Chloe has to submit everything to ICRAR. 
 - Discussion between team. Majority believes that it would be best to wrap everything up by today when everyone is present and has the capacity to review the deliverable. 
 - Final Decision: Next Hour - Tri to try to implement update pages, all others tidy up repo and final testing of deliverable.

### Actions
 - 
<br>

## Item 4 - Repository Tidying Up and Final Testing of Application
> **<Description>**
- Tidying up of Repo
- Documentation writing - `README.md`
- Creating Issue for `Assumptions, Bugs & Incomplete Pages` - refer to the issue for more details.

### Discussion
- Dennis tested on Macbook, Naren tested on Windows. Both worked successfully. 
- Tri later tested all functionality as well. Successful run.

### Actions
 - Chloe: Transfer repo ownership to ICRAR
 - Chloe: Upload minutes to GitHub

<br>

## Meeting Closed: 23:30 

## Digressions: 
- Chloe doing action items as part of the meeting, Tri doing timesheets.

## Next Scheduled Meeting: Wednesday 3-4pm (Client Meeting).
