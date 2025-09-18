# Minutes - Client Retrospective

- Date: 18/09/2025
- Present: Tri, Chloe, Kevin (Client)
- Absent:
- Apologies: Harper, Dennis, Naren, Ryan
- Venue: ICRAR Ground Floor
- Minutes by: Chloe
- Meeting Start: 12:00PM

## Item 1 - Frontend
> **Demonstration of all frontend pages created.**

### Discussion
 - Dropdown tables - observed that the foreign keys have to be access. Have to go and get the name associated with ID.
 - Once general method.
 - Pagination? Got all data working, but are we tweaking / adding in token tags into the headers to keep track of where we are?
 - list of planting sponsors - list of paginated type var - pass the data through that way. Don't break the response model.
 - passing it through arguments - that's clean (Kevin likes that).
 - Kevin's happy with the screens. Use Android Flutter Studio and that will download the code and run the app on your device. 

## Item 2 - Database Migration
> **Demonstration of tests passed and PGAdmin.**

### Discussion
 - Tri: Demonstration of V2 Migration.
 - Kevin: Question on Foreign Keys?
   - Tri: Currently ignored Foreign Keys.
   - Until variety exists, can't have a foreign key. Once it exists, it can have a foreign key.
 - Kevin: Still trying to figure out what's happening. It's not fake, it's a real situation that has to be dealt with, should not be ignored.
 - Kevin: What Access does in the hood - ignore all referential integrity. Genetic source and variety table. Suspicion: What all they're trying to do it to connect the two tables together. Tri has more details - asked about his observations.
 - Female Genetic Source and Male Genetic Source - both reference Genetic Source. Currently migration can't seem to deal with that.
 - Kevin: Can add the two foreign keys back later on. Can turn the constraints on and off. Worry with the way Access tends to ignore constraints, while PostgreSQL would reject numbers that are unknown. 
 - Tri: Non-explicit referencing?
 - Kevin: Bizarre index / primary key in one of the tables. Using two elements as a Key. Progeny ID should be the Primary Key. Can't put unique index into Access, Val put it on genetic_source_id and sibling_number, which should be a unique index instead of a Primary Key.
   - Access - can't make unique index.
   - Genetic Source: Might come back and bite later, have to be aware. Genetic source should be a foreign key back to that, but nothing seems to use the Progeny material currently. Don't think there's any data in that, so just something to be mindful of (nothing to be worry about currently).

- Tri: Demonstration of tests. Database migration and backend (which has a similar logic to database migration).
- Kevin: Using pytests to check data that's coming through? Commended - clever way of doing it.
- Access string is on. Everything is loaded in from env files.
- `psql -u /postgres /dt`
- Kevin: Commenting on Docker setup for different systems. Startup - pass in passwords that you have to pass in for usernames.
- Another release of the database? Raising queries, but uncertainty on Kevin's part. Three usernames have not been testing it out quick enough. Should probably not have an update. 
  - If anything's received by the 1st of October, forget it.

<br>

## Item 3 - Backend 
> **Demonstration of tests passed and routes on fastAPI. Also demonstration of select pages on Flutter.**

### Discussion
 - Kevin: How the routes have been set-up?
 - All routes in a particular table should be within their own document. Keep everything separated out. 
 - Instead of going straight in and getting data? At some point, need to get centred authentication in. Return true all of the time. In the future, there will be something that goes into this. Not using JSON web tokens yet, but ultimately will do. 
 - Getting the DB implemented, but there should be an optional components within the routes currently (JSON web-token). It has to come in.
 - Keep response models and the splitting of different components. Makes sure everything that is outtput is accurate.
 - Pagination - one place, all pagination works for each route.
 - All `GET ALLs` gradually need pagination. For example, families. Perhaps many thousand datalines.
 - Kevin: Integration tests? Async or sync?
   - DB engine to async DB engine?
   - A lot complicated but a lot faster.
   - pytest: Set fixtures in it, the db connection can create the whole database for you, without having to tidy up afterwards. DB engine. Function-based: throw everything that's in database and runs tests again. Something that has all the rebuilt. 
   - Alembic - works off a database model. Make it either (normal method: sqlalchemy or sqlmodel - automatically generates the database model. instead of postgres will spit out python. Alembic will rebuilt everything as instructed).
   - Or add a table to act as a version tracker.
   - "user" - reserved name table inside.
   - `select * for "user"`
- Kevin - happy to send over some sample files for Docker. All sorts of problems with three different devices. 

<br>

## Item 4 - Confirmation of documents to be submitted for sprint 2
> **The team to confirm with client what documents should be submitted to them for sprint 2, if any.**

### Discussion
 - Relationship diagram.
 - Screenshots of Flutter (selected screens, plantings, the more complicated ones).
   - All add tables, one update table, one view table (ones with backend implemented), one manage lookup tables, others screens.
 - User stories so Kevin know what we are and will be working on. Wants a simple set of user stories, do not have to be complicated. Don't have to add more according to Kevin. Trying to implement backend pages. 
  
<br>

## Item 4 - (Optional) Review of revised set of user stories.
> **If there is time, the team is to present the revised set of user stories for client review.**

### Discussion
 - Mostly removed change log user stories and authentication.
 - Don't need to do anything? commands?
 - Kevin: can turn it on in PostgreSQL, but no interest.

<br>

**Overall feedback from Kevin:** It's pretty good, considering that the team has only just started investigating backend. Understandable since the team has changed focus to go down the path of frontend due to technical constraints. Authentication and separation concerns, but shouldn't take us long to fix.

## Meeting Closed: 12:55PM 

## Next Scheduled Meeting: To be Decided. Mentor Meeting and Auditor Meeting to be scheduled. 
