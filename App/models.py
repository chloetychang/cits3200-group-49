from sqlalchemy import Column, Integer, String, Boolean, Text, TIMESTAMP, ForeignKey, Float, UniqueConstraint
from sqlalchemy.orm import relationship
from database import Base

class Aspect(Base):
    __tablename__ = "aspect"
    
    aspect_id = Column(Integer, primary_key=True)
    aspect = Column(String, nullable=False, unique=True)
    
    # Relationships
    zones = relationship("Zone", back_populates="aspect")
    sub_zones = relationship("SubZone", back_populates="aspect")

class Bioregion(Base):
    __tablename__ = "bioregion"
    
    bioregion_code = Column(String, primary_key=True)
    region_name = Column(String, nullable=False)
    
    # Relationships
    provenances = relationship("Provenance", back_populates="bioregion")

class ConservationStatus(Base):
    __tablename__ = "conservation_status"
    
    conservation_status_id = Column(Integer, primary_key=True)
    status = Column(String, nullable=False, unique=True)
    status_short_name = Column(String, nullable=True)
    
    # Relationships
    species = relationship("Species", back_populates="conservation_status")

class Container(Base):
    __tablename__ = "container"
    
    container_type_id = Column(Integer, primary_key=True)
    container_type = Column(String, nullable=False)
    
    # Relationships
    plantings = relationship("Planting", back_populates="container")

class Family(Base):
    __tablename__ = "family"
    
    family_id = Column(Integer, primary_key=True)
    famiy_name = Column(String, nullable=False, unique=True)  # Note: typo preserved from schema
    
    # Relationships
    genera = relationship("Genus", back_populates="family")

class GeneticSource(Base):
    __tablename__ = "genetic_source"
    
    genetic_source_id = Column(Integer, primary_key=True)
    acquisition_date = Column(TIMESTAMP, nullable=False)
    variety_id = Column(Integer, ForeignKey("variety.variety_id"), nullable=False)
    supplier_id = Column(Integer, ForeignKey("supplier.supplier_id"), nullable=False)
    supplier_lot_number = Column(String, nullable=True)
    price = Column(Float, nullable=True)
    gram_weight = Column(Integer, nullable=True)
    provenance_id = Column(Integer, ForeignKey("provenance.provenance_id"), nullable=True)
    viability = Column(Integer, nullable=True)
    propagation_type = Column(Integer, ForeignKey("propagation_type.propagation_type_id"), nullable=True)
    female_genetic_source = Column(Integer, ForeignKey("genetic_source.genetic_source_id"), nullable=True)
    male_genetic_source = Column(Integer, ForeignKey("genetic_source.genetic_source_id"), nullable=True)
    generation_number = Column(Integer, nullable=False)
    landscape_only = Column(Boolean, nullable=False)
    research_notes = Column(Text, nullable=True)
    
    # Relationships
    variety = relationship("Variety", back_populates="genetic_sources")
    supplier = relationship("Supplier", back_populates="genetic_sources")
    provenance = relationship("Provenance", back_populates="genetic_sources")
    propagation_type_rel = relationship("PropagationType", back_populates="genetic_sources")
    female_parent = relationship("GeneticSource", remote_side="GeneticSource.genetic_source_id", foreign_keys=[female_genetic_source])
    male_parent = relationship("GeneticSource", remote_side="GeneticSource.genetic_source_id", foreign_keys=[male_genetic_source])
    plantings = relationship("Planting", back_populates="genetic_source")
    progeny = relationship("Progeny", back_populates="genetic_source")
    varieties_as_source = relationship("Variety", back_populates="genetic_source_rel")

class Genus(Base):
    __tablename__ = "genus"
    
    genus_id = Column(Integer, primary_key=True)
    family_id = Column(Integer, ForeignKey("family.family_id"), nullable=False)
    genus = Column(String, nullable=False, unique=True)
    
    # Relationships
    family = relationship("Family", back_populates="genera")
    species = relationship("Species", back_populates="genus")

class LocationType(Base):
    __tablename__ = "location_type"
    
    location_type_id = Column(Integer, primary_key=True)
    location_type = Column(String, nullable=True)
    
    # Relationships
    provenances = relationship("Provenance", back_populates="location_type")

class PlantUtility(Base):
    __tablename__ = "plant_utility"
    
    plant_utility_id = Column(Integer, primary_key=True)
    utility = Column(String, nullable=False, unique=True)
    
    # Relationships
    species_utilities = relationship("SpeciesUtilityLink", back_populates="plant_utility")

class Planting(Base):
    __tablename__ = "planting"
    
    planting_id = Column(Integer, primary_key=True)
    date_planted = Column(TIMESTAMP, nullable=False)
    planted_by = Column(Integer, ForeignKey("user.user_id"), nullable=True)
    zone_id = Column(Integer, ForeignKey("zone.zone_id"), nullable=False)
    variety_id = Column(Integer, ForeignKey("variety.variety_id"), nullable=False)
    number_planted = Column(Integer, nullable=False)
    genetic_source_id = Column(Integer, ForeignKey("genetic_source.genetic_source_id"), nullable=True)
    container_type_id = Column(Integer, ForeignKey("container.container_type_id"), nullable=False)
    removal_date = Column(TIMESTAMP, nullable=True)
    number_removed = Column(Integer, nullable=True)
    removal_cause_id = Column(Integer, ForeignKey("removal_cause.removal_cause_id"), nullable=True)
    comments = Column(Text, nullable=True)
    
    # Relationships
    planted_by_user = relationship("User", back_populates="plantings")
    zone = relationship("Zone", back_populates="plantings")
    variety = relationship("Variety", back_populates="plantings")
    genetic_source = relationship("GeneticSource", back_populates="plantings")
    container = relationship("Container", back_populates="plantings")
    removal_cause = relationship("RemovalCause", back_populates="plantings")

class Progeny(Base):
    __tablename__ = "progeny"
    
    progeny_id = Column(Integer, unique=True)
    genetic_source_id = Column(Integer, ForeignKey("genetic_source.genetic_source_id"), primary_key=True)
    sibling_number = Column(Integer, primary_key=True)
    child_name = Column(String, nullable=False)
    date_germinated = Column(TIMESTAMP, nullable=False)
    comments = Column(String, nullable=True)
    
    # Relationships
    genetic_source = relationship("GeneticSource", back_populates="progeny")

class PropagationType(Base):
    __tablename__ = "propagation_type"
    
    propagation_type_id = Column(Integer, primary_key=True)
    propagation_type = Column(String, nullable=True)
    needs_two_parents = Column(Boolean, nullable=False)
    can_cross_genera = Column(Boolean, nullable=False)
    
    # Relationships
    genetic_sources = relationship("GeneticSource", back_populates="propagation_type_rel")

class Provenance(Base):
    __tablename__ = "provenance"
    
    provenance_id = Column(Integer, primary_key=True)
    bioregion_code = Column(String, ForeignKey("bioregion.bioregion_code"), nullable=False)
    location = Column(String, nullable=True)
    location_type_id = Column(Integer, ForeignKey("location_type.location_type_id"), nullable=True)
    extra_details = Column(String, nullable=True)
    
    # Relationships
    bioregion = relationship("Bioregion", back_populates="provenances")
    location_type = relationship("LocationType", back_populates="provenances")
    genetic_sources = relationship("GeneticSource", back_populates="provenance")

class RemovalCause(Base):
    __tablename__ = "removal_cause"
    
    removal_cause_id = Column(Integer, primary_key=True)
    cause = Column(String, nullable=False, unique=True)
    
    # Relationships
    plantings = relationship("Planting", back_populates="removal_cause")

class Role(Base):
    __tablename__ = "role"
    
    role_id = Column(Integer, primary_key=True)
    role = Column(String, nullable=False, unique=True)
    description = Column(String, nullable=True)
    
    # Relationships
    user_roles = relationship("UserRoleLink", back_populates="role")

class Species(Base):
    __tablename__ = "species"
    
    species_id = Column(Integer, primary_key=True)
    genus_id = Column(Integer, ForeignKey("genus.genus_id"), nullable=False)
    species = Column(String, nullable=False)
    conservation_status_id = Column(Integer, ForeignKey("conservation_status.conservation_status_id"), nullable=True)
    
    # Relationships
    genus = relationship("Genus", back_populates="species")
    conservation_status = relationship("ConservationStatus", back_populates="species")
    varieties = relationship("Variety", back_populates="species")
    species_utilities = relationship("SpeciesUtilityLink", back_populates="species")

class SpeciesUtilityLink(Base):
    __tablename__ = "species_utility_link"
    
    species_id = Column(Integer, ForeignKey("species.species_id"), primary_key=True)
    plant_utility_id = Column(Integer, ForeignKey("plant_utility.plant_utility_id"), primary_key=True)
    
    # Relationships
    species = relationship("Species", back_populates="species_utilities")
    plant_utility = relationship("PlantUtility", back_populates="species_utilities")

class SubZone(Base):
    __tablename__ = "sub_zone"
    
    sub_zone_id = Column(Integer, primary_key=True)
    zone_id = Column(Integer, ForeignKey("zone.zone_id"), nullable=True)
    sub_zone_code = Column(String, nullable=True)
    aspect_id = Column(Integer, ForeignKey("aspect.aspect_id"), nullable=True)
    exposure_to_wind = Column(String, nullable=True)
    shade = Column(String, nullable=True)
    
    # Relationships
    zone = relationship("Zone", back_populates="sub_zones")
    aspect = relationship("Aspect", back_populates="sub_zones")

class Supplier(Base):
    __tablename__ = "supplier"
    
    supplier_id = Column(Integer, primary_key=True)
    supplier_name = Column(String, nullable=False, unique=True)
    short_name = Column(String, nullable=False, unique=True)
    web_site = Column(String, nullable=True)
    is_a_research_breeder = Column(Boolean, nullable=False)
    
    # Relationships
    genetic_sources = relationship("GeneticSource", back_populates="supplier")

class User(Base):
    __tablename__ = "user"
    
    user_id = Column(Integer, primary_key=True)
    title = Column(String, nullable=True)
    surname = Column(String, nullable=False)
    first_name = Column(String, nullable=False)
    preferred_name = Column(String, nullable=True)
    address_line_1 = Column(String, nullable=True)
    address_line_2 = Column(String, nullable=True)
    locality = Column(String, nullable=True)
    postcode = Column(Integer, nullable=True)
    work_phone = Column(String, nullable=True)
    mobile = Column(String, nullable=False)
    email = Column(String, nullable=False)
    full_name = Column(String, nullable=False)
    password = Column(String, nullable=True)
    
    # Relationships
    plantings = relationship("Planting", back_populates="planted_by_user")
    user_roles = relationship("UserRoleLink", back_populates="user")

class UserRoleLink(Base):
    __tablename__ = "user_role_link"
    
    user_id = Column(Integer, ForeignKey("user.user_id"), primary_key=True)
    role_id = Column(Integer, ForeignKey("role.role_id"), primary_key=True)
    
    # Relationships
    user = relationship("User", back_populates="user_roles")
    role = relationship("Role", back_populates="user_roles")

class Variety(Base):
    __tablename__ = "variety"
    
    variety_id = Column(Integer, primary_key=True)
    species_id = Column(Integer, ForeignKey("species.species_id"), nullable=True)
    common_name = Column(String, nullable=True)
    variety = Column(String, nullable=True)
    genetic_source_id = Column(Integer, ForeignKey("genetic_source.genetic_source_id"), unique=True, nullable=True)
    
    # Relationships
    species = relationship("Species", back_populates="varieties")
    genetic_source_rel = relationship("GeneticSource", back_populates="varieties_as_source", foreign_keys=[genetic_source_id])
    genetic_sources = relationship("GeneticSource", back_populates="variety", foreign_keys="GeneticSource.variety_id")
    plantings = relationship("Planting", back_populates="variety")

class Zone(Base):
    __tablename__ = "zone"
    
    zone_id = Column(Integer, primary_key=True)
    zone_number = Column(String, nullable=False, unique=True)
    zone_name = Column(String, nullable=True)
    aspect_id = Column(Integer, ForeignKey("aspect.aspect_id"), nullable=True)
    exposure_to_wind = Column(String, nullable=True)
    shade = Column(String, nullable=True)
    
    # Relationships
    aspect = relationship("Aspect", back_populates="zones")
    plantings = relationship("Planting", back_populates="zone")
    sub_zones = relationship("SubZone", back_populates="zone")
