from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import datetime

# Base schemas for common patterns
class BaseSchema(BaseModel):
    model_config = ConfigDict(from_attributes=True)

# Aspect schemas
class AspectBase(BaseSchema):
    aspect: str

class AspectCreate(AspectBase):
    pass

class AspectResponse(AspectBase):
    aspect_id: int

# Bioregion schemas
class BioregionBase(BaseSchema):
    bioregion_code: str
    region_name: str

class BioregionCreate(BioregionBase):
    pass

class BioregionResponse(BioregionBase):
    pass

# Conservation Status schemas
class ConservationStatusBase(BaseSchema):
    status: str
    status_short_name: Optional[str] = None

class ConservationStatusCreate(ConservationStatusBase):
    pass

class ConservationStatusResponse(ConservationStatusBase):
    conservation_status_id: int

# Container schemas
class ContainerBase(BaseSchema):
    container_type: str

class ContainerCreate(ContainerBase):
    pass

class ContainerResponse(ContainerBase):
    container_type_id: int

# Family schemas
class FamilyBase(BaseSchema):
    famiy_name: str  # Note: typo preserved from schema

class FamilyCreate(FamilyBase):
    pass

class FamilyResponse(FamilyBase):
    family_id: int

# Genus schemas
class GenusBase(BaseSchema):
    genus: str
    family_id: int

class GenusCreate(GenusBase):
    pass

class GenusResponse(GenusBase):
    genus_id: int

# Location Type schemas
class LocationTypeBase(BaseSchema):
    location_type: Optional[str] = None

class LocationTypeCreate(LocationTypeBase):
    pass

class LocationTypeResponse(LocationTypeBase):
    location_type_id: int

# Plant Utility schemas
class PlantUtilityBase(BaseSchema):
    utility: str

class PlantUtilityCreate(PlantUtilityBase):
    pass

class PlantUtilityResponse(PlantUtilityBase):
    plant_utility_id: int

# Propagation Type schemas
class PropagationTypeBase(BaseSchema):
    propagation_type: Optional[str] = None
    needs_two_parents: bool
    can_cross_genera: bool

class PropagationTypeCreate(PropagationTypeBase):
    pass

class PropagationTypeResponse(PropagationTypeBase):
    propagation_type_id: int

# Provenance schemas
class ProvenanceBase(BaseSchema):
    bioregion_code: str
    location: Optional[str] = None
    location_type_id: Optional[int] = None
    extra_details: Optional[str] = None

class ProvenanceCreate(ProvenanceBase):
    pass

class ProvenanceResponse(ProvenanceBase):
    provenance_id: int

# Removal Cause schemas
class RemovalCauseBase(BaseSchema):
    cause: str

class RemovalCauseCreate(RemovalCauseBase):
    pass

class RemovalCauseResponse(RemovalCauseBase):
    removal_cause_id: int

# Role schemas
class RoleBase(BaseSchema):
    role: str
    description: Optional[str] = None

class RoleCreate(RoleBase):
    pass

class RoleResponse(RoleBase):
    role_id: int

# Species schemas
class SpeciesBase(BaseSchema):
    species: str
    genus_id: int
    conservation_status_id: Optional[int] = None

class SpeciesCreate(SpeciesBase):
    pass

class SpeciesResponse(SpeciesBase):
    species_id: int

# Species Utility Link schemas
class SpeciesUtilityLinkBase(BaseSchema):
    species_id: int
    plant_utility_id: int

class SpeciesUtilityLinkCreate(SpeciesUtilityLinkBase):
    pass

class SpeciesUtilityLinkResponse(SpeciesUtilityLinkBase):
    pass

# Supplier schemas
class SupplierBase(BaseSchema):
    supplier_name: str
    short_name: str
    web_site: Optional[str] = None
    is_a_research_breeder: bool

class SupplierCreate(SupplierBase):
    pass

class SupplierResponse(SupplierBase):
    supplier_id: int

# User schemas
class UserBase(BaseSchema):
    title: Optional[str] = None
    surname: str
    first_name: str
    preferred_name: Optional[str] = None
    address_line_1: Optional[str] = None
    address_line_2: Optional[str] = None
    locality: Optional[str] = None
    postcode: Optional[int] = None
    work_phone: Optional[str] = None
    mobile: str
    email: str
    full_name: str

class UserCreate(UserBase):
    password: Optional[str] = None

class UserResponse(UserBase):
    user_id: int

# User Role Link schemas
class UserRoleLinkBase(BaseSchema):
    user_id: int
    role_id: int

class UserRoleLinkCreate(UserRoleLinkBase):
    pass

class UserRoleLinkResponse(UserRoleLinkBase):
    pass

# Variety schemas
class VarietyBase(BaseSchema):
    species_id: Optional[int] = None
    common_name: Optional[str] = None
    variety: Optional[str] = None
    genetic_source_id: Optional[int] = None

class VarietyCreate(VarietyBase):
    pass

class VarietyResponse(VarietyBase):
    variety_id: int

# Zone schemas
class ZoneBase(BaseSchema):
    zone_number: str
    zone_name: Optional[str] = None
    aspect_id: Optional[int] = None
    exposure_to_wind: Optional[str] = None
    shade: Optional[str] = None

class ZoneCreate(ZoneBase):
    pass

class ZoneResponse(ZoneBase):
    zone_id: int

# Sub Zone schemas
class SubZoneBase(BaseSchema):
    zone_id: Optional[int] = None
    sub_zone_code: Optional[str] = None
    aspect_id: Optional[int] = None
    exposure_to_wind: Optional[str] = None
    shade: Optional[str] = None

class SubZoneCreate(SubZoneBase):
    pass

class SubZoneResponse(SubZoneBase):
    sub_zone_id: int

# Genetic Source schemas
class GeneticSourceBase(BaseSchema):
    acquisition_date: datetime
    variety_id: int
    supplier_id: int
    supplier_lot_number: Optional[str] = None
    price: Optional[float] = None
    gram_weight: Optional[int] = None
    provenance_id: Optional[int] = None
    viability: Optional[int] = None
    propagation_type: Optional[int] = None
    female_genetic_source: Optional[int] = None
    male_genetic_source: Optional[int] = None
    generation_number: int
    landscape_only: bool
    research_notes: Optional[str] = None

class GeneticSourceCreate(GeneticSourceBase):
    pass

class GeneticSourceResponse(GeneticSourceBase):
    genetic_source_id: int

# Planting schemas
class PlantingBase(BaseSchema):
    date_planted: datetime
    planted_by: Optional[int] = None
    zone_id: int
    variety_id: int
    number_planted: int
    genetic_source_id: Optional[int] = None
    container_type_id: int
    removal_date: Optional[datetime] = None
    number_removed: Optional[int] = None
    removal_cause_id: Optional[int] = None
    comments: Optional[str] = None

class PlantingCreate(PlantingBase):
    pass

class PlantingResponse(PlantingBase):
    planting_id: int

# Progeny schemas
class ProgenyBase(BaseSchema):
    genetic_source_id: int
    sibling_number: int
    child_name: str
    date_germinated: datetime
    comments: Optional[str] = None

class ProgenyCreate(ProgenyBase):
    pass

class ProgenyResponse(ProgenyBase):
    progeny_id: Optional[int] = None
    progeny_id: Optional[int] = None
