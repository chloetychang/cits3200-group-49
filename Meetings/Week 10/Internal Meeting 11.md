# Minutes 

- Date: 01/10/25
- Present: Dennis, Harper, Naren, Chloe, Tri, Ryan 
- Absent:
- Apologies:
- Venue: EZONE NTH 202B 
- Minutes by: Chloe
- Meeting Start: 14:55

## Item 1 -  Progress update on screen design allocations 
> **<Description>**
 - Check in on progress with screen designs.
 - Highlight any current challenges faced with implementation and come up with a plan to tackle them.
   
### Discussion
 - Tri: Observation - The migration script might need a small modification to set the sequence number for the primary key. From research, the override command that have been used to insert the roles has meant that the sequence number has been left at one. Generate new primary key? Tries to generate an identity of one, violates primary key constraints. Will need further investigation on constraints. possibility that the migration script has to be changed. Set sequence to max + 1 at the end of the migration. Shouldn't be too hard, but hasn't done any testing with current work. Wants to clarify that the problem with the posting to the database is what has been mentioned.
 - Tri: Combined species and variety into one. A lot to be filled out for dropdowns. Family - doesn't really make sense. Debating whether should ask Kevin about it or not. Have to do a bit of investigation regarding what each column means. Actual names being displayed are not unique to each variety.
 - Dennis: To check what FamilyName is in prototype.
 - Harper: View table pages, Manage lookup tables. Species and Utility pages - take too much time to load anything. Can work, but will take too much time, even with pagination it's not working ideally. Clicking the dropdown takes a long time to load.
 - Dennis: Leave that in, but mention that we've tried our best to do it.
 - Tri: Instead of having dropdown, consider some alternate method? Maybe the dropdown can display the first 20 entries?
 - Harper: Set private key as identity value. There is a command for it. 8 rows for table? The command can make an extra row for identity.
 - Tri: Two methods? Either use sequence number that is set correctly in the migration script, or Harper's solution which is to set up an extra row. Can do both, but will need evidence if we can't do it in the final deliverable that we've tried all we can. Change migration script?
 - Naren: May have to edit migration script for the progeny table. Tried to make a POST request, can register it in the API. However, got error code 500. With consultation from Dennis and Ryan, the table is not working as intended. Access Database - empty. Genetic source - no data in Access database. The way was seen - used linking table in variety and species link. Not working as intended. 
 - Dropdowns - Harper tries to fix it and address the massive loading of the dropdown list [timeline: 1 week to fix this issue]
 - Ryan: Implented FASTapi POST request for Provenances table, returning successful 200 code when given a sample data. [However, this didn;t have the same issue with Tri's primary key of Genetic_source_id].
 - Tri: Query if this is a unique one off that the primary key for provenance_id is auto incremented, or it's just other areas of tables that hasn't been added.
 - Tri & Ryan: Further discussion found that the POST request was a one off success but if another POST request is sent, it may not be successful and therefore we'll need to find/use a working solution that Harper has done.
 - Problem: Initial post request was a one off success. However, if another POST request is sent, it will fail to add a new data entry.
 - Solution: Investigate further and implement Harper's solution throughout the other tables.

### Actions
 - 
<br>

## Item 2 - Discussion on Progeny Table issue + Response to Kevin regarding routings + acquistion id
> **<Description>**
 - Currently Genetic_source_ID & sibling_number is set as a Primary Key.
 - However, the actual primary key ID should be Progeny_id. 
 - Refer back to our Client retrospective meeting minutes with Kevin.
   
### Discussion
 - Naren: POST request for progeny, issues faced: 1) Missing data from inside MSACCESS + POSTGRES, 2) KEY CONFLICTS: In ERD, Genetic_source_id is a foreign key from genetic source. However, in pgAdmin, after migration it's registered as primary key. 3) Sibling Number found as a Primary key (No issues but just a note) 4) Family name and species uses different tables. 5) Sibling number is a Primary Key in both Postgres and Access Database. 5) Progeny ID - will have to generate that for every new entry. Would happen after POST request has happened. Is it in our scope to fix it? (Our role is to migrate, but not to fix the foreign keys or adjust the schema. 6) Sibling number: Access database - registered as an integer. Primary keys have to be unique integers - same sibling number should exist though, in a botany setting? 
 - Solution: May have a solution in mind, but it has not been tested. From there, can also finalise the tweaks made to the migration script.
 - Chloe: Maybe set up a meeting with Kevin to clarify all concepts? 
 - Naren: Tweak migration script by this week, then the add acquisitions table and all can be merged? With Tri and Ryan's materials. By Sunday.
 - Tri: Two Primary Keys for Progeny. Sibling number - specifies what sibling you want. Can quickly send a message to Kevin to quickly clarify the intensions of the progeny. Val couldn't use unique constraints for the Progeny. Ask Kevin regarding expectations of the Progeny Key.

 - Harper: Acquisition ID: Leave that. Though do we create a new column in the database or just have an empty field as an indication?
 - Dennis: Collate all questions for Kevin and then ask them in a meeting next week?
 - Naren: Share findings first then have meeting?
 - Tri: Have to make sure client has nothing in mind regarding Acquisitions. Changing database is out of our scope, will not make a new table for Acquisitions.
 - Tri: Progeny ID as Primary Key. Genetic Source as Foreign Key. Currently not planning to do that, modifying the dataset is not in our scope.
 - Naren: Should ask Kevin the intention of Progeny. Also do a bit of research (as suggested by Tri). 
 - Tri: Genetic Source and Sibling ID to be unique, but it's currently nothing.
 - Naren: Progeny ID starting from 1?
 - 
### Actions
 - Naren: Send message to Kevin regarding clarification and intent on Progeny and AddAcquisitions (Acquisition ID). Clarification on dropdown content regarding Family Name field in Progeny.

<br>

## Item 3 - Dennis' Tutorial/Masterclass on Dropdowns
> **<Description>**
- To speed up team development. 

### Discussion
- 6 files required to be modified - <page>_widget.dart, <page>_model.dart, main.py, <page>.py, schemas.py, api_service.dart
- Going from backend to frontend to form the connection.
 - Copy the structure. Instead of Progeny you're using the structure for Provenances.
 - Also change item returned
- String structure - change in frontend. (String manipulation, similar to Python)
  
   
## Item 4 - Next set of task allocation 
> **<Description>**

### Discussion
 - Dennis: Availability from everyone?
 - Add Page: Dropdowns (which Harper will look into), and waiting on Kevin's clarifications with Naren. 
 - Update Page: Fetch records.

 - Harper: Manage lookup table: One page left and trying to paginate the dropdowns.
 - Tri: AddAcquisitions page is almost done. Will be done once we solve issue with the sequence. Possible new migration. To ping Naren once migration script has been completed and verified.
 - Naren: Message Kevin as per action item, investigate AddProgeny. 
 - Ryan: By this weekend, will try to fully implement Provenances Page. 
 - Dennis and Chloe: Update Species Table

### Actions
 - 
<br>

## Meeting Closed: 17:10

## Next Scheduled Meeting: 05/10/2025 (Sunday) 8PM
