# Testing Results
## Frontend Testing Results 
**Add_pages**
- AddAcquisitions: Pass. 
- AddNewFamily: Minor（Slight overflow on Mobile, fix scheduled today）(Fixed Overflow on Mobile based on Harper's and Chloe's advice to wrap elements)
- AddPlantings: Minor（Overflow on Mobile + iPad, already fixed) 
- AddProgeny: Minor（Slight overflow on Mobile, fix scheduled today）(Fixed Overflow on Mobile based on Harper's and Chloe's advice to wrap elements)
- AddProvenances: Minor（Slight overflow on Mobile, fix scheduled today）(Fixed Overflow on Mobile based on Harper's and Chloe's advice to wrap elements)
- AddSubZones: Pass. 
- AddSuppliers: Minor（Slight overflow on Mobile, fix scheduled today）(Fixed Overflow on Mobile based on Harper's and Chloe's advice to wrap elements)
- AddUsers: Pass.
- AddVarieties: Pass.
- AddZone: Pass.

**Update_pages**
#### Comments for overall Update Page Screen Designs
**Minor:** Slight overflow with "Choose Record here" Dropdown list on Mobile (P) for the following devices (iPhone14 Pro, iPhone 13, iPhone SE).
Otherwise, Mobile (P & L), Tablet (P & L), Desktop (P & L) works well. (Tested using iPhone XR, iPad Air Pro, Desktop (1920 x 1080 Resolution))
- UpdateAcquisitions
- UpdateNewFamily 
- UpdatePlantings
- UpdateProgeny
- UpdateProvenances
- UpdateSubZone
- UpdateSuppliers
- UpdateUsers
- UpdateVarieties
- UpdateZone

**Manage_lookups_table**
#### Comments for overall Manage Lookup Table Screen Designs
**Passes Mobile, Tablet and Desktop**
- ManageConservationStatus
- ManageContainerType
- ManagePlantingRemoval
- ManagePlantUtility
- ManagePropagationType
- ManageProvenance
- ManageProvenanceLocationTypes
- ManageSpeciesUtility
- ManageZoneAspect

**View_table**
#### Comments for overall View Table Screen Designs
**Passes Mobile, Tablet and Desktop**
- ViewGeneticSource
- ViewPlantings
- ViewProgeny
- ViewProvenances
- ViewSpecies
- ViewSubzones
- ViewSuppliers
- ViewUsers
- ViewZone

**WelcomeAndLanding**
#### Comments for overall Welcome and Landing Screen Designs
**Passes Mobile, Tablet and Desktop**
- Landing_ASuperuser
- Landing_ClaireFrankynJones
- Landing_Guest
- Landing_LizBarbour
- Landing_ValMacduff
- UsernamePassword
- UserOther

**Other**
#### Comments for overall other screen Designs
- FormUpdateSpecies: Minor: Overflown text on Mobile (Portrait) (Harper currently fixing as of 10/09/25 by wrapping elements to resize effectively on Mobile), **Fixed as of 10/09/25**
- PlantingCrossTabReport: Minor: Overflown text on Mobile (Portrait), however, it works well with Tablet-iPad Mini (L), Desktop (L) (Let Ryan know to not touch this Planting CrossTabReport) 

**Bonus Fixings**
- All top row buttons for all screens (47) in Mobile Portrait into dropdowns "menu" instead. 
