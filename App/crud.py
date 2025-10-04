from sqlalchemy.orm import Session
from typing import List, Optional, Type, TypeVar, Generic
from sqlalchemy.ext.declarative import DeclarativeMeta
from . import models
from . import schemas

# Generic type for CRUD operations
ModelType = TypeVar("ModelType", bound=DeclarativeMeta)
CreateSchemaType = TypeVar("CreateSchemaType")
UpdateSchemaType = TypeVar("UpdateSchemaType")

class CRUDBase(Generic[ModelType, CreateSchemaType, UpdateSchemaType]):
    def __init__(self, model: Type[ModelType]):
        """
        CRUD object with default methods to Create, Read, Update, Delete (CRUD).
        
        **Parameters**
        * `model`: A SQLAlchemy model class
        """
        self.model = model

    def get_multi(self, db: Session, *, skip: int = 0, limit: int = 100) -> List[ModelType]:
        """Get multiple records with pagination"""
        return db.query(self.model).offset(skip).limit(limit).all()

    def create(self, db: Session, *, obj_in: CreateSchemaType) -> ModelType:
        """Create a new record"""
        obj_in_data = obj_in.model_dump() if hasattr(obj_in, 'model_dump') else obj_in #type: ignore
        db_obj = self.model(**obj_in_data) #type: ignore
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj

    def count(self, db: Session) -> int:
        """Count total records in the table"""
        return db.query(self.model).count()

    def get_all(self, db: Session) -> List[ModelType]:
        """Get all records (use with caution on large tables)"""
        return db.query(self.model).all()
        
# Specific CRUD classes for each model
class CRUDAspect(CRUDBase[models.Aspect, schemas.AspectCreate, schemas.AspectCreate]):
    def get_by_aspect(self, db: Session, *, aspect: str) -> Optional[models.Aspect]:
        return db.query(models.Aspect).filter(models.Aspect.aspect == aspect).first()

class CRUDBioregion(CRUDBase[models.Bioregion, schemas.BioregionCreate, schemas.BioregionCreate]):
    def get_by_code(self, db: Session, *, code: str) -> Optional[models.Bioregion]:
        return db.query(models.Bioregion).filter(models.Bioregion.bioregion_code == code).first()

class CRUDConservationStatus(CRUDBase[models.ConservationStatus, schemas.ConservationStatusCreate, schemas.ConservationStatusCreate]):
    def get_by_status(self, db: Session, *, status: str) -> Optional[models.ConservationStatus]:
        return db.query(models.ConservationStatus).filter(models.ConservationStatus.status == status).first()

class CRUDContainer(CRUDBase[models.Container, schemas.ContainerCreate, schemas.ContainerCreate]):
    pass

class CRUDFamily(CRUDBase[models.Family, schemas.FamilyCreate, schemas.FamilyCreate]):
    def get_by_name(self, db: Session, *, name: str) -> Optional[models.Family]:
        return db.query(models.Family).filter(models.Family.famiy_name == name).first()

class CRUDGenus(CRUDBase[models.Genus, schemas.GenusCreate, schemas.GenusCreate]):
    def get_by_name(self, db: Session, *, genus: str) -> Optional[models.Genus]:
        return db.query(models.Genus).filter(models.Genus.genus == genus).first()
    
    def get_by_family(self, db: Session, *, family_id: int) -> List[models.Genus]:
        return db.query(models.Genus).filter(models.Genus.family_id == family_id).all()

class CRUDGeneticSource(CRUDBase[models.GeneticSource, schemas.GeneticSourceCreate, schemas.GeneticSourceCreate]):
    def get_by_variety(self, db: Session, *, variety_id: int) -> List[models.GeneticSource]:
        return db.query(models.GeneticSource).filter(models.GeneticSource.variety_id == variety_id).all()
    
    def get_by_supplier(self, db: Session, *, supplier_id: int) -> List[models.GeneticSource]:
        return db.query(models.GeneticSource).filter(models.GeneticSource.supplier_id == supplier_id).all()

class CRUDLocationType(CRUDBase[models.LocationType, schemas.LocationTypeCreate, schemas.LocationTypeCreate]):
    pass 

class CRUDPlantUtility(CRUDBase[models.PlantUtility, schemas.PlantUtilityCreate, schemas.PlantUtilityCreate]):
    def get_by_utility(self, db: Session, *, utility: str) -> Optional[models.PlantUtility]:
        return db.query(models.PlantUtility).filter(models.PlantUtility.utility == utility).first()

class CRUDPlanting(CRUDBase[models.Planting, schemas.PlantingCreate, schemas.PlantingCreate]):
    def get_by_zone(self, db: Session, *, zone_id: int) -> List[models.Planting]:
        return db.query(models.Planting).filter(models.Planting.zone_id == zone_id).all()
    
    def get_by_variety(self, db: Session, *, variety_id: int) -> List[models.Planting]:
        return db.query(models.Planting).filter(models.Planting.variety_id == variety_id).all()

class CRUDProgeny(CRUDBase[models.Progeny, schemas.ProgenyCreate, schemas.ProgenyCreate]):
    def get_by_genetic_source(self, db: Session, *, genetic_source_id: int) -> List[models.Progeny]:
        return db.query(models.Progeny).filter(models.Progeny.genetic_source_id == genetic_source_id).all()

class CRUDPropagationType(CRUDBase[models.PropagationType, schemas.PropagationTypeCreate, schemas.PropagationTypeCreate]):
    pass

class CRUDProvenance(CRUDBase[models.Provenance, schemas.ProvenanceCreate, schemas.ProvenanceCreate]):
    def get_by_bioregion(self, db: Session, *, bioregion_code: str) -> List[models.Provenance]:
        return db.query(models.Provenance).filter(models.Provenance.bioregion_code == bioregion_code).all()

    def get_by_location(self, db, location: str):
        return db.query(models.Provenance).filter(models.Provenance.location == location).first()

class CRUDRemovalCause(CRUDBase[models.RemovalCause, schemas.RemovalCauseCreate, schemas.RemovalCauseCreate]):
    def get_by_cause(self, db: Session, *, cause: str) -> Optional[models.RemovalCause]:
        return db.query(models.RemovalCause).filter(models.RemovalCause.cause == cause).first()

class CRUDRole(CRUDBase[models.Role, schemas.RoleCreate, schemas.RoleCreate]):
    def get_by_role(self, db: Session, *, role: str) -> Optional[models.Role]:
        return db.query(models.Role).filter(models.Role.role == role).first()

class CRUDSpecies(CRUDBase[models.Species, schemas.SpeciesCreate, schemas.SpeciesCreate]):
    def get_by_genus(self, db: Session, *, genus_id: int) -> List[models.Species]:
        return db.query(models.Species).filter(models.Species.genus_id == genus_id).all()
    
    def get_by_conservation_status(self, db: Session, *, status_id: int) -> List[models.Species]:
        return db.query(models.Species).filter(models.Species.conservation_status_id == status_id).all()

class CRUDSupplier(CRUDBase[models.Supplier, schemas.SupplierCreate, schemas.SupplierCreate]):
    def get_by_name(self, db: Session, *, name: str) -> Optional[models.Supplier]:
        return db.query(models.Supplier).filter(models.Supplier.supplier_name == name).first()
    
    def get_by_short_name(self, db: Session, *, short_name: str) -> Optional[models.Supplier]:
        return db.query(models.Supplier).filter(models.Supplier.short_name == short_name).first()

class CRUDUser(CRUDBase[models.User, schemas.UserCreate, schemas.UserCreate]):
    def get_by_email(self, db: Session, *, email: str) -> Optional[models.User]:
        return db.query(models.User).filter(models.User.email == email).first()

class CRUDVariety(CRUDBase[models.Variety, schemas.VarietyCreate, schemas.VarietyCreate]):
    def get_by_species(self, db: Session, *, species_id: int) -> List[models.Variety]:
        return db.query(models.Variety).filter(models.Variety.species_id == species_id).all()

class CRUDZone(CRUDBase[models.Zone, schemas.ZoneCreate, schemas.ZoneCreate]):
    def get_by_number(self, db: Session, *, zone_number: str) -> Optional[models.Zone]:
        return db.query(models.Zone).filter(models.Zone.zone_number == zone_number).first()

class CRUDSubZone(CRUDBase[models.SubZone, schemas.SubZoneCreate, schemas.SubZoneCreate]):
    def get_by_zone(self, db: Session, *, zone_id: int) -> List[models.SubZone]:
        return db.query(models.SubZone).filter(models.SubZone.zone_id == zone_id).all()

# Initialize CRUD instances
aspect = CRUDAspect(models.Aspect)
bioregion = CRUDBioregion(models.Bioregion)
conservation_status = CRUDConservationStatus(models.ConservationStatus)
container = CRUDContainer(models.Container)
family = CRUDFamily(models.Family)
genus = CRUDGenus(models.Genus)
genetic_source = CRUDGeneticSource(models.GeneticSource)
location_type = CRUDLocationType(models.LocationType)
plant_utility = CRUDPlantUtility(models.PlantUtility)
planting = CRUDPlanting(models.Planting)
progeny = CRUDProgeny(models.Progeny)
propagation_type = CRUDPropagationType(models.PropagationType)
provenance = CRUDProvenance(models.Provenance)
removal_cause = CRUDRemovalCause(models.RemovalCause)
role = CRUDRole(models.Role)
species = CRUDSpecies(models.Species)
supplier = CRUDSupplier(models.Supplier)
user = CRUDUser(models.User)
variety = CRUDVariety(models.Variety)
zone = CRUDZone(models.Zone)
sub_zone = CRUDSubZone(models.SubZone)
