--
-- PostgreSQL database dump
--

\restrict Am2SRS5AnLjIxhksOvAk1sxoJZmS3XQcqwaah5cZCKjLZFSWyba34rvT0U1iCHw

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2025-09-16 09:47:50

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 31544)
-- Name: aspect; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aspect (
    aspect character varying(255) NOT NULL,
    aspect_id integer NOT NULL
);


ALTER TABLE public.aspect OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 31551)
-- Name: bioregion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bioregion (
    bioregion_code character varying(255) NOT NULL,
    region_name character varying(255) NOT NULL
);


ALTER TABLE public.bioregion OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 31558)
-- Name: conservation_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conservation_status (
    conservation_status_id integer NOT NULL,
    status character varying(255) NOT NULL,
    status_short_name character varying(255)
);


ALTER TABLE public.conservation_status OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 31567)
-- Name: container; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.container (
    container_type character varying(255) NOT NULL,
    container_type_id integer NOT NULL
);


ALTER TABLE public.container OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 31572)
-- Name: family; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.family (
    family_id integer NOT NULL,
    famiy_name character varying(255) NOT NULL
);


ALTER TABLE public.family OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 31579)
-- Name: genetic_source; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genetic_source (
    acquisition_date timestamp without time zone NOT NULL,
    female_genetic_source integer,
    generation_number integer NOT NULL,
    genetic_source_id integer NOT NULL,
    gram_weight integer,
    landscape_only boolean,
    male_genetic_source integer,
    price double precision,
    propagation_type integer,
    provenance_id integer,
    research_notes text,
    supplier_id integer NOT NULL,
    supplier_lot_number character varying(255),
    variety_id integer NOT NULL,
    viability integer
);


ALTER TABLE public.genetic_source OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 31586)
-- Name: genus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genus (
    family_id integer NOT NULL,
    genus character varying(255) NOT NULL,
    genus_id integer NOT NULL
);


ALTER TABLE public.genus OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 31593)
-- Name: location_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_type (
    location_type character varying(255),
    location_type_id integer NOT NULL
);


ALTER TABLE public.location_type OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 31598)
-- Name: plant_utility; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plant_utility (
    plant_utility_id integer NOT NULL,
    utility character varying(255) NOT NULL
);


ALTER TABLE public.plant_utility OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 31605)
-- Name: planting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.planting (
    comments text,
    container_type_id integer NOT NULL,
    date_planted timestamp without time zone NOT NULL,
    genetic_source_id integer,
    number_planted integer NOT NULL,
    number_removed integer,
    planted_by integer,
    planting_id integer NOT NULL,
    removal_cause_id integer,
    removal_date timestamp without time zone,
    variety_id integer NOT NULL,
    zone_id integer NOT NULL
);


ALTER TABLE public.planting OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 31633)
-- Name: removal_cause; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.removal_cause (
    cause character varying(255) NOT NULL,
    removal_cause_id integer NOT NULL
);


ALTER TABLE public.removal_cause OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 31649)
-- Name: species; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.species (
    conservation_status_id integer,
    genus_id integer NOT NULL,
    species character varying(255) NOT NULL,
    species_id integer NOT NULL
);


ALTER TABLE public.species OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 31677)
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    address_line_1 character varying(255),
    address_line_2 character varying(255),
    email character varying(255) NOT NULL,
    first_name character varying(255) NOT NULL,
    full_name character varying(255) NOT NULL,
    locality character varying(255),
    mobile character varying(255) NOT NULL,
    password character varying(255),
    postcode integer,
    preferred_name character varying(255),
    surname character varying(255) NOT NULL,
    title character varying(255),
    user_id integer NOT NULL,
    work_phone character varying(255)
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 31689)
-- Name: variety; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.variety (
    common_name character varying(255),
    genetic_source_id integer,
    species_id integer,
    variety character varying(255),
    variety_id integer NOT NULL
);


ALTER TABLE public.variety OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 31698)
-- Name: zone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.zone (
    aspect_id integer,
    exposure_to_wind character varying(255),
    shade character varying(255),
    zone_id integer NOT NULL,
    zone_name character varying(255),
    zone_number character varying(255) NOT NULL
);


ALTER TABLE public.zone OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 31836)
-- Name: plantings_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.plantings_view AS
 SELECT u.full_name AS planted_by,
    z.zone_number,
    a.aspect,
    v.species_id AS taxon,
    (((g.genus)::text || ' '::text) || (s.species)::text) AS genus_and_species,
    p.number_planted,
    p.removal_date,
    rc.cause AS removal_cause,
    p.number_removed,
    p.comments,
    p.date_planted
   FROM (((((((public.planting p
     JOIN public.variety v ON ((p.variety_id = v.variety_id)))
     JOIN public.species s ON ((v.species_id = s.species_id)))
     JOIN public.genus g ON ((s.genus_id = g.genus_id)))
     LEFT JOIN public.removal_cause rc ON ((p.removal_cause_id = rc.removal_cause_id)))
     LEFT JOIN public."user" u ON ((p.planted_by = u.user_id)))
     LEFT JOIN public.zone z ON ((p.zone_id = z.zone_id)))
     LEFT JOIN public.aspect a ON ((z.aspect_id = a.aspect_id)));


ALTER VIEW public.plantings_view OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 31612)
-- Name: progeny; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.progeny (
    child_name character varying(255) NOT NULL,
    comments character varying(255),
    date_germinated timestamp without time zone NOT NULL,
    genetic_source_id integer NOT NULL,
    progeny_id integer,
    sibling_number integer NOT NULL
);


ALTER TABLE public.progeny OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 31621)
-- Name: propagation_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.propagation_type (
    can_cross_genera boolean,
    needs_two_parents boolean,
    propagation_type character varying(255),
    propagation_type_id integer NOT NULL
);


ALTER TABLE public.propagation_type OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 31626)
-- Name: provenance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.provenance (
    bioregion_code character varying(50) NOT NULL,
    extra_details character varying(255),
    location character varying(255),
    location_type_id integer,
    provenance_id integer NOT NULL
);


ALTER TABLE public.provenance OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 31640)
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role (
    description character varying(255),
    role character varying(255) NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE public.role OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 31654)
-- Name: species_utility_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.species_utility_link (
    plant_utility_id integer NOT NULL,
    species_id integer NOT NULL
);


ALTER TABLE public.species_utility_link OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 31659)
-- Name: sub_zone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sub_zone (
    aspect_id integer,
    exposure_to_wind character varying(255),
    shade character varying(255),
    sub_zone_code character varying(255),
    sub_zone_id integer NOT NULL,
    zone_id integer
);


ALTER TABLE public.sub_zone OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 31666)
-- Name: supplier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplier (
    is_a_research_breeder boolean,
    short_name character varying(255) NOT NULL,
    supplier_id integer NOT NULL,
    supplier_name character varying(255) NOT NULL,
    web_site character varying(255)
);


ALTER TABLE public.supplier OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 31832)
-- Name: taxon; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.taxon AS
 SELECT v.variety_id,
    v.species_id AS taxon,
    g.genus,
    s.species,
    v.variety,
    (((g.genus)::text || ' '::text) || (s.species)::text) AS genus_and_species
   FROM ((public.variety v
     JOIN public.genus g ON ((g.genus_id = g.genus_id)))
     JOIN public.species s ON ((v.species_id = s.species_id)));


ALTER VIEW public.taxon OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 31684)
-- Name: user_role_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_role_link (
    role_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.user_role_link OWNER TO postgres;

--
-- TOC entry 5079 (class 0 OID 31544)
-- Dependencies: 217
-- Data for Name: aspect; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aspect (aspect, aspect_id) FROM stdin;
\.


--
-- TOC entry 5080 (class 0 OID 31551)
-- Dependencies: 218
-- Data for Name: bioregion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bioregion (bioregion_code, region_name) FROM stdin;
\.


--
-- TOC entry 5081 (class 0 OID 31558)
-- Dependencies: 219
-- Data for Name: conservation_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conservation_status (conservation_status_id, status, status_short_name) FROM stdin;
\.


--
-- TOC entry 5082 (class 0 OID 31567)
-- Dependencies: 220
-- Data for Name: container; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.container (container_type, container_type_id) FROM stdin;
\.


--
-- TOC entry 5083 (class 0 OID 31572)
-- Dependencies: 221
-- Data for Name: family; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.family (family_id, famiy_name) FROM stdin;
22715	Lycopodiaceae
22716	Selaginellaceae
22717	Isoetaceae
22718	Ophioglossaceae
22719	Schizaeaceae
22720	Adiantaceae
22721	Pteridaceae
22722	Gleicheniaceae
22723	Polypodiaceae
22724	Cyatheaceae
22725	Thelypteridaceae
22726	Dennstaedtiaceae
22727	Lindsaeaceae
22728	Aspleniaceae
22729	Dryopteridaceae
22730	Blechnaceae
22731	Marsileaceae
22732	Salviniaceae
22733	Azollaceae
22734	Cycadaceae
22735	Zamiaceae
22736	Podocarpaceae
22737	Pinaceae
22738	Cupressaceae
22739	Typhaceae
22740	Pandanaceae
22741	Potamogetonaceae
22742	Zannichelliaceae
22743	Posidoniaceae
22744	Cymodoceaceae
22745	Zosteraceae
22746	Najadaceae
22747	Aponogetonaceae
22748	Juncaginaceae
22749	Alismataceae
22750	Hydrocharitaceae
22751	Poaceae
22752	Cyperaceae
22753	Arecaceae
22754	Araceae
22755	Lemnaceae
22756	Flagellariaceae
22757	Restionaceae
22758	Centrolepidaceae
22759	Hydatellaceae
22760	Xyridaceae
22761	Eriocaulaceae
22762	Commelinaceae
22763	Philydraceae
22764	Juncaceae
22765	Stemonaceae
22766	Smilacaceae
22767	Asparagaceae
22768	Dasypogonaceae
22769	Xanthorrhoeaceae
22770	Phormiaceae
22771	Anthericaceae
22772	Asphodelaceae
22773	Hyacinthaceae
22774	Alliaceae
22775	Colchicaceae
22776	Alstroemeriaceae
22777	Haemodoraceae
22778	Tecophilaeaceae
22779	Amaryllidaceae
22780	Hypoxidaceae
22781	Agavaceae
22782	Taccaceae
22783	Dioscoreaceae
22784	Iridaceae
22785	Cannaceae
22786	Burmanniaceae
22787	Orchidaceae
22788	Casuarinaceae
22789	Bataceae
22790	Ulmaceae
22791	Moraceae
22792	Urticaceae
22793	Proteaceae
22794	Santalaceae
22795	Opiliaceae
22796	Olacaceae
22797	Loranthaceae
22798	Viscaceae
22799	Aristolochiaceae
22800	Rafflesiaceae
22801	Polygonaceae
22802	Chenopodiaceae
22803	Amaranthaceae
22804	Nyctaginaceae
22805	Gyrostemonaceae
22806	Phytolaccaceae
22807	Aizoaceae
22808	Molluginaceae
22809	Portulacaceae
22810	Caryophyllaceae
22811	Nymphaeaceae
22812	Ceratophyllaceae
22813	Ranunculaceae
22814	Menispermaceae
22815	Annonaceae
22816	Myristicaceae
22817	Lauraceae
22818	Hernandiaceae
22819	Papaveraceae
22820	Fumariaceae
22821	Capparaceae
22822	Emblingiaceae
22823	Brassicaceae
22824	Resedaceae
22825	Podostemaceae
22826	Droseraceae
22827	Crassulaceae
22828	Cephalotaceae
22829	Saxifragaceae
22830	Pittosporaceae
22831	Byblidaceae
22832	Cunoniaceae
22833	Surianaceae
22834	Rosaceae
22835	Chrysobalanaceae
22836	Mimosaceae
22837	Caesalpiniaceae
22838	Papilionaceae
22839	Geraniaceae
22840	Oxalidaceae
22841	Tropaeolaceae
22842	Linaceae
22843	Erythroxylaceae
22844	Zygophyllaceae
22845	Rutaceae
22846	Simaroubaceae
22847	Burseraceae
22848	Meliaceae
22849	Tremandraceae
22850	Polygalaceae
22851	Euphorbiaceae
22852	Callitrichaceae
22853	Anacardiaceae
22854	Aquifoliaceae
22855	Celastraceae
22856	Hippocrateaceae
22857	Stackhousiaceae
22858	Sapindaceae
22859	Rhamnaceae
22860	Vitaceae
22861	Tiliaceae
22862	Malvaceae
22863	Bombacaceae
22864	Sterculiaceae
22865	Dilleniaceae
22866	Clusiaceae
22867	Elatinaceae
22868	Frankeniaceae
22869	Cochlospermaceae
22870	Violaceae
22871	Passifloraceae
22872	Cactaceae
22873	Thymelaeaceae
22874	Lythraceae
22875	Sonneratiaceae
22876	Lecythidaceae
22877	Rhizophoraceae
22878	Combretaceae
22879	Myrtaceae
22880	Melastomataceae
22881	Onagraceae
22882	Haloragaceae
22883	Araliaceae
22884	Apiaceae
22885	Epacridaceae
22886	Myrsinaceae
22887	Primulaceae
22888	Plumbaginaceae
22889	Sapotaceae
22890	Ebenaceae
22891	Loganiaceae
22892	Buddlejaceae
22893	Gentianaceae
22894	Menyanthaceae
22895	Apocynaceae
22896	Asclepiadaceae
22897	Convolvulaceae
22898	Cuscutaceae
22899	Polemoniaceae
22900	Hydrophyllaceae
22901	Boraginaceae
22902	Verbenaceae
22903	Chloanthaceae
22904	Avicenniaceae
22905	Lamiaceae
22906	Solanaceae
22907	Scrophulariaceae
22908	Bignoniaceae
22909	Pedaliaceae
22910	Martyniaceae
22911	Orobanchaceae
22912	Lentibulariaceae
22913	Acanthaceae
22914	Myoporaceae
22915	Plantaginaceae
22916	Rubiaceae
22917	Valerianaceae
22918	Dipsacaceae
22919	Cucurbitaceae
22920	Campanulaceae
22921	Lobeliaceae
22922	Goodeniaceae
22923	Stylidiaceae
22924	Asteraceae
22925	Bixaceae
22926	Caprifoliaceae
22927	Liliaceae
22928	Psilotaceae
22929	Melianthaceae
22930	Oleaceae
22931	Pontederiaceae
22932	Acrobolbaceae
22933	Adelanthaceae
22934	Allisoniaceae
22935	Aneuraceae
22936	Antheliaceae
22937	Anthocerotaceae
22938	Arnelliaceae
22939	Aytoniaceae
22940	Balantiopsidaceae
22941	Blasiaceae
22942	Brevianthaceae
22943	Calypogeiaceae
22944	Cephaloziaceae
22945	Cephaloziellaceae
22946	Chaetophyllopsidaceae
22947	Chonecoleaceae
22948	Cleveaceae
22949	Conocephalaceae
22950	Corsiniaceae
22951	Exormothecaceae
22952	Fossombroniaceae
22953	Frullaniaceae
22954	Geocalycaceae
22955	Goebeliellaceae
22956	Gymnomitriaceae
22957	Gyrothyraceae
22958	Haplomitriaceae
22959	Herbertaceae
22960	Hymenophytaceae
22961	Jackiellaceae
22962	Jubulaceae
22963	Jubulopsidaceae
22964	Jungermanniaceae
22965	Lejeuneaceae
22966	Lepicoleaceae
22967	Lepidolaenaceae
22968	Lepidoziaceae
22969	Lunulariaceae
22970	Makinoaceae
22971	Marchantiaceae
22972	Mesoptychiaceae
22973	Metzgeriaceae
22974	Mizutaniaceae
22975	Monocarpaceae
22976	Monocleaceae
22977	Monosoleniaceae
22978	Notothyladaceae
22979	Oxymitraceae
22980	Pallaviciniaceae
22981	Pelliaceae
22982	Perssoniellaceae
22983	Phycolepidoziaceae
22984	Phyllothalliaceae
22985	Plagiochilaceae
22986	Pleuroziaceae
22987	Porellaceae
22988	Pseudolepicoleaceae
22989	Ptilidiaceae
22990	Radulaceae
22991	Ricciaceae
22992	Riellaceae
22993	Scapaniaceae
22994	Schistochilaceae
22995	Sphaerocarpaceae
22996	Takakiaceae
22997	Targioniaceae
22998	Treubiaceae
22999	Trichocoleaceae
23000	Trichotemnomataceae
23001	Vandiemeniaceae
23002	Vetaformaceae
23003	Wiesnerellaceae
23004	Amblystegiaceae
23005	Andreaeaceae
23006	Andreaeobryaceae
23007	Archidiaceae
23008	Aulacomniaceae
23009	Bartramiaceae
23010	Brachytheciaceae
23011	Bryaceae
23012	Bryobartramiaceae
23013	Bryoxiphiaceae
23014	Buxbaumiaceae
23015	Callicostaceae
23016	Calomniaceae
23017	Calymperaceae
23018	Catoscopiaceae
23019	Climaciaceae
23020	Cochlearidiaceae
23021	Cryphaeaceae
23022	Cyrtopodaceae
23023	Dawsoniaceae
23024	Dicnemonaceae
23025	Dicranaceae
23026	Diphysciaceae
23027	Disceliaceae
23028	Ditrichaceae
23029	Donrichardsiaceae
23030	Echinodiaceae
23031	Encalyptaceae
23032	Entodontaceae
23033	Ephemeraceae
23034	Ephemeropsidaceae
23035	Erpodiaceae
23036	Eustichiaceae
23037	Fabroniaceae
23038	Fissidentaceae
23039	Fontinalaceae
23040	Funariaceae
23041	Gigaspermaceae
23042	Grimmiaceae
23043	Hedwigiaceae
23044	Helicophyllaceae
23045	Hookeriaceae
23046	Hylocomiaceae
23047	Hypnaceae
23048	Hypnobartlettiaceae
23049	Hypnodendraceae
23050	Hypopterygiaceae
23051	Lembophyllaceae
23052	Leptostomaceae
23053	Lepyrodontaceae
23054	Leskeaceae
23055	Leucobryaceae
23056	Leucodontaceae
23057	Leucomiaceae
23058	Meesiaceae
23059	Meteoriaceae
23060	Mitteniaceae
23061	Mniaceae
23062	Myuriaceae
23063	Neckeraceae
23064	Oedipodiaceae
23065	Orthotrichaceae
23066	Phyllodrepaniaceae
23067	Phyllogoniaceae
23068	Plagiotheciaceae
23069	Pleurophascaceae
23070	Polytrichaceae
23071	Pottiaceae
23072	Prionodontaceae
23073	Pseudoditrichaceae
23074	Pterobryaceae
23075	Ptychomitriaceae
23076	Ptychomniaceae
23077	Racopilaceae
23078	Rhizogoniaceae
23079	Rhytidiaceae
23080	Rutenbergiaceae
23081	Schistostegaceae
23082	Seligeriaceae
23083	Sematophyllaceae
23084	Sorapillaceae
23085	Sphagnaceae
23086	Spiridentaceae
23087	Splachnaceae
23088	Tetraphidaceae
23089	Thamnobrayceae
23090	Theliaceae
23091	Thuidiaceae
23092	Timmiaceae
23093	Trachypodaceae
23094	Viridivelleraceae
23139	Tilopteriadles
23146	Arthopyreniaceae
23147	Arthrorhaphidaceae
23148	Aspidotheliaceae
23149	Asterothyriaceae
23150	Bacidiaceae
23151	Baeomycetaceae
23152	Biatoraceae
23153	Brigantiaeaceae
23154	Caliciaceae
23155	Candelariaceae
23156	Catillariaceae
23157	Catinariaceae
23158	Chiodectonaceae
23159	Chrysothricaceae
23160	Cladoniaceae
23161	Clavulariaceae
23162	Coccocarpiaceae
23163	Coccotremataceae
23164	Collemataceae
23165	Coniocybaceae
23166	Crocyniaceae
23167	Dictyonemataceae
23168	Ectolechiaceae
23169	Fuscideaceae
23170	Gomphillaceae
23171	Graphidaceae
23172	Gyalectaceae
23173	Haematommaceae
23174	Heppiaceae
23175	Heterodeaceae
23176	Hymeneliaceae
23177	Hypogymniaceae
23178	Lecanactidaceae
23179	Lecanoraceae
23180	Lecideaceae
23181	Lecotheciaceae
23182	Letrouitaceae
23183	Lichenotheliaceae
23184	Lichinaceae
23185	Lithographaceae
23186	Lobariaceae
23187	Lopadiaceae
23188	Megalariaceae
23189	Megalosporaceae
23190	Melaspileaceae
23191	Micareaceae
23192	Microcaliciaceae
23193	Monoblastiaceae
23194	Mycobilimbiaceae
23195	Mycocaliciaceae
23196	Mycoporaceae
23197	Nephromataceae
23198	Odontotremataceae
23199	Opegraphaceae
23200	Pannariaceae
23201	Parmeliaceae
23202	Peltigeraceae
23203	Peltulaceae
23204	Pertusariaceae
23205	Phlyctidaceae
23206	Phragmopelthecaceae
23207	Phyllopsoraceae
23208	Physciaceae
23209	Pilocarpaceae
23210	Placynthiaceae
23211	Porpidiaceae
23212	Psoraceae
23213	Pyrenulaceae
23214	Pyxinaceae
23215	Ramalinaceae
23216	Rhizocarpaceae
23217	Rimulariaceae
23218	Roccellaceae
23219	Roccellinastraceae
23220	Saccomorphaceae
23221	Schaereriaceae
23222	Sclerophoraceae
23223	Scoliciosporaceae
23224	Sphaerophoraceae
23225	Sphinctrinaceae
23226	Squamarinaceae
23227	Stereocaulaceae
23228	Strictidaceae
23229	Strigulaceae
23230	Teloschistaceae
23231	Thelenellaceae
23232	Trapeliaceae
23233	Tremoleciaceae
23234	Tricholomataceae
23235	Trichotheliaceae
23236	Trypetheliaceae
23237	Umbilicariaceae
23238	Usneaceae
23239	Verrucariaceae
23240	Vezdaeaceae
23241	Tamaricaceae
23242	Turneraceae
23244	Basellaceae
23245	Bonnemaisoniles
23246	Gracilarilaes
23248	Piperaceae
23249	Taxodiaceae
23250	Agaricaceae
23251	Albuginaceae
23252	Aleurodiscaceae
23253	Amanitaceae
23255	Ascobolaceae
23257	Asterinaceae
23258	Astraeaceae
23259	Auriculariaceae
23260	Auriscalpiaceae
23261	Bankeraceae
23262	Battarreaceae
23263	Bolbitiaceae
23264	Boletaceae
23265	Botryosphaeriaceae
23266	Calostomataceae
23267	Cantharellaceae
23268	Capnodiaceae
23270	Chaetomiaceae
23271	Chamonixiaceae
23272	Clathraceae
23273	Clavariaceae
23274	Clavariadelphaceae
23275	Clavicipitaceae
23276	Clavicoronaceae
23277	Clavulinaceae
23278	Coleosporiaceae
23279	Coniophoraceae
23280	Coprinaceae
23281	Coriolaceae
23282	Corticiaceae
23283	Cortinariaceae
23284	Craterellaceae
23285	Crepidotaceae
23287	Cronartiaceae
23288	Cyttariaceae
23289	Dacrymycetaceae
23290	Dermateaceae
23291	Diatrypaceae
23292	Dichostereaceae
23293	Dothideales
23294	Elpahomycetaceae
23295	Elasmomycetaceae
23296	Elsinoaceae
23297	Entolomataceae
23298	Erysiphaceae
23299	Exidiaceae
23300	Exobasidiaceae
23301	Fistulinaceae
23302	Ganodermataceae
23303	Gautieriaceae
23304	Geastraceae
23305	Geoglossaceae
23306	Gloeocystidiellaceae
23307	Graphiolaceae
23308	Gyrodontaceae
23309	Helvellaceae
23310	Hemiphacidiaceae
23311	Hyaloscyphaceae
23312	Hydnaceae
23313	Hydnangiaceae
23314	Hygrophoraceae
23315	Hymenochaetaceae
23316	Hymenogastraceae
23317	Hyphodermataceae
23318	Hypocreaceae
23319	Hyponectriaceae
23320	Hysteriaceae
23321	Lachnocladiaceae
23322	Lasiosphaeriaceae
23323	Lentinaceae
23324	Lentinellaceae
23325	Leotiaceae
23326	Leptosphaeriaceae
23328	Lycoperdaceae
23329	Magnaporthaceae
23330	Massariaceae
23331	Melampsoraceae
23332	Melanogastraceae
23333	Meliolaceae
23334	Meliolinaceae
23335	Meruliaceae
23336	Mesophelliaceae
23337	Micropeltidaceae
23338	Microthyriaceae
23339	Mitosporic Fungi
23340	Morchellaceae
23341	Mycenastraceae
23342	Mycosphaerellaceae
23343	Myxomycota (division/family fudge)
23344	Nidulariaceae
23345	Nitschkiaceae
23346	Olpidiaceae
23347	Onygenaceae
23348	Otideaceae
23349	Paxillaceae
23350	Peniophoraceae
23351	Peronosporaceae
23352	Pezizaceae
23353	Phakopsoraceae
23354	Phallaceae
23355	Phelloriniaceae
23356	Phragmidiaceae
23357	Phyllachoraceae
23359	Physodermataceae
23360	Pileolariaceae
23361	Pleosporaceae
23362	Pluteaceae
23363	Podaxaceae
23364	Polyporaceae
23365	Protophallaceae
23366	Pucciniaceae
23367	Pucciniosiraceae
23368	Pucciniastraceae
23369	Pyronemataceae
23370	Pythiaceae
23371	Ramariaceae
23372	Raveneliaceae
23373	Rhizopogonaceae
23374	Rhytismataceae
23375	Russulaceae
23376	Sarcoscyphaceae
23377	Sarcosomataceae
23378	Schizophyllaceae
23379	Sclerodermataceae
23380	Sclerosporaceae
23381	Sclerotiniaceae
23382	Secotiaceae
23383	Septobasidiaceae
23384	Sordariaceae
23385	Sphaerobolaceae
23386	Sphaerophragmiaceae
23387	Steccherinaceae
23389	Stereaceae
23390	Strobilomycetaceae
23391	Strophariaceae
23392	Synchytriaceae
23393	Taphrinaceae
23394	Thelephoraceae
23395	Tilletiaceae
23396	Torrendiaceae
23397	Tremellaceae
23399	Trichocomaceae
23400	Tulostomataceae
23401	Uredinales
23402	Uropyxidaceae
23403	Ustilaginaceae
23404	Valsaceae
23405	Venturiaceae
23406	Verrucalvaceae
23407	Vizellaceae
23408	Xerocomaceae
23409	Xylariaceae
23410	Cannabaceae
23411	Boryaceae
23412	Ericaceae
23413	Aloeaceae
23414	Salicaceae
23415	Platanaceae
23416	Eremosynaceae
23417	Scutigeraceae
23418	Ecdeiocoleaceae
23419	Chlorophyceae
23420	Davalliaceae
23421	Lygodiaceae
23422	Parkeriaceae
23423	Platyzomataceae
23424	Hysterangiaceae
23425	Gelopellaceae
23426	Aspidiaceae
23427	Balsaminaceae
23428	Moringaceae
23429	Plasmodiophoraceae
23430	Sphenocleaceae
23431	Acarosporaceae
23432	Arthoniaceae
23433	Thelotremataceae
23434	Cladiaceae
23435	Acrocordiaceae
23436	Agyriaceae
23437	Alectoriaceae
23438	Arctomiaceae
23439	Deuteromycotina
23440	Siphulaceae
23441	Mycoblastaceae
23442	Musaceae
25954	Anadyomenaceae
25955	Bryopsidaceae
25956	Caulerpaceae
25957	Chaetosiphonaceae
25958	Cladophoraceae
25959	Codiaceae
25960	Dasycladaceae
25961	Derbesiaceae
25962	Halimedaceae
25963	Monostromataceae
25964	Ostreobiaceae
25965	Phaeophilaceae
25966	Polyphysaceae
25967	Siphonocladaceae
25968	Udoteaceae
25969	Ulotrichaceae
25970	Ulvaceae
25972	Valoniaceae
25973	Phormidiaceae
25974	Rivulariaceae
25975	Schizotrichaceae
25976	Alariaceae
25977	Chnoosporaceae
25978	Chordariaceae
25979	Cladostephaceae
25980	Corynophlaeaceae
25981	Cutleriaceae
25982	Cystoseiraceae
25983	Dictyotaceae
25984	Ectocarpaceae
25985	Elachistaceae
25986	Giraudiaceae
25987	Hormosiraceae
25988	Laminariaceae
25989	Notheiaceae
25990	Punctariaceae
25991	Ralfsiaceae
25992	Sargassaceae
25993	Scoresbyellaceae
25994	Scytosiphonaceae
25995	Seirococcaceae
25996	Spermatochnaceae
25997	Sphacelariaceae
25998	Sporochnaceae
25999	Stypocaulaceae
26000	Acrochaetiaceae
26001	Acrosymphytaceae
26002	Acrotylaceae
26003	Areschougiaceae
26004	Balliaceae
26005	Bangiaceae
26006	Bonnemaisoniaceae
26007	Caulacanthaceae
26008	Ceramiaceae
26009	Champiaceae
26010	Compsopogonaceae
26011	Corallinaceae
26012	Corynomorphaceae
26013	Cystocloniaceae
26014	Dasyaceae
26015	Delesseriaceae
26016	Dicranemataceae
26017	Dumontiaceae
26018	Erythrotrichiaceae
26019	Faucheaceae
26020	Galaxauraceae
26021	Gelidiaceae
26022	Gelidiellaceae
26023	Gigartinaceae
26024	Gracilariaceae
26025	Halymeniaceae
26026	Hypneaceae
26027	Kallymeniaceae
26028	Liagoraceae
26029	Lomentariaceae
26030	Mychodeaceae
26031	Mychodeophyllidaceae
26032	Nemastomataceae
26033	Nizymeniaceae
26034	Peyssonneliaceae
26035	Phacelocarpaceae
26036	Plocamiaceae
26037	Polyidaceae
26038	Porphyridiaceae
26039	Pterocladiophilaceae
26040	Rhizophyllidaceae
26041	Rhodomelaceae
26042	Rhodymeniaceae
26043	Rhodymeniales: Family Incertae Sedis
26044	Sarcodiaceae
26045	Sarcomeniaceae
26046	Schizymeniaceae
26047	Sebdeniaceae
26048	Sporolithaceae
27418	Platygloeaceae
27419	Tremolechiaceae
30431	Rhabdoweisiaceae
30671	Calliergonaceae
31651	Bruchiaceae
32051	Orthodontiaceae
32052	Saulomataceae
33461	Apodanthaceae
34336	Agapanthaceae
34337	Hemerocallidaceae
34338	Anarthriaceae
34419	Ruppiaceae
34466	Ophioparmaceae
34856	Putranjivaceae
34857	Fabaceae
34858	Phyllanthaceae
35036	Picrodendraceae
35075	Hypericaceae
35183	Aphanopetalaceae
35224	Cleomaceae
35265	Elaeocarpaceae
35277	Hydroleaceae
35278	Nitrariaceae
35337	Phrymaceae
35338	Linderniaceae
35476	Lomariopsidaceae
36198	Corynocystaceae
36365	Pihiellaceae
36740	Colaconemataceae
37060	Didiereaceae
38642	Marasmiaceae
38643	Physalacriaceae
38644	Psathyrellaceae
38645	Tricholomatales
38646	Amylocorticiaceae
38647	Glomeraceae
38648	Schizoporaceae
38649	Tuberaceae
38650	Phyllacoraceae
38916	Clastodermataceae
38917	Echinosteliaceae
38918	Cribrariaceae
38919	Liceaceae
38920	Lycogalaceae
38921	Didymiaceae
38922	Physaraceae
38923	Ceratiomyxaceae
38924	Stemonitidaceae
38925	Arcyriaceae
38926	Dianemataceae
38927	Trichiaceae
39882	Elaphomycetaceae
39920	Chrysotrichaceae
42622	Rhipiliaceae
43304	Cryphonectriaceae
43552	Marantaceae
43882	Carbonicolaceae
44515	Ochrolechiaceae
44521	Boodleaceae
44576	Hydnodontaceae
44577	Inocybaceae
44686	Hydrangeaceae
44720	Calceolariaceae
44727	Phanerochaetaceae
44734	Hapalidiaceae
44789	Pleurotaceae
44814	Mycenaceae
44927	Serpulaceae
45076	Wrangeliaceae
45795	Anthracoideaceae
45812	Eballistraceae
45817	Entorrhizaceae
45820	Georgefischeriaceae
45823	Melanotaeniaceae
45829	Microbotryaceae
45848	Urocystidaceae
45911	Websdaneaceae
45955	Uronemataceae
45958	Kornmanniaceae
45963	Ulvellaceae
45967	Gayraliaceae
46036	Agaricales: Family Incertae Sedis
46153	Phallogastraceae
46154	Suillaceae
46155	Tapinellaceae
46156	Tubariaceae
46213	Stephanosporaceae
46574	Gomphaceae
46994	Hymenocladiaceae
46995	Acinetosporaceae
47013	Pseudocodiaceae
47075	Porinaceae
47076	Icmadophilaceae
48132	Dichotomosiphonaceae
48171	Callithamniaceae
48271	Solieriaceae
48272	Neoralfsiaceae
48315	Fagaceae
48326	Macarthuriaceae
48327	Francoaceae
48328	Anacampserotaceae
48329	Montiaceae
48403	Bachelotiaceae
48499	Hapalospongidiaceae
48798	Gloniaceae
48849	Fomitopsidaceae
48910	Megasporaceae
48912	Lessoniaceae
48959	Stylonemataceae
48965	Scinaiaceae
48966	Hydrolithaceae
48970	Mastophoraceae
48977	Spongitaceae
49024	Berberidaceae
49043	Gyroporaceae
49087	Sarcinochrysidaceae
49175	Yamadaellaceae
49222	Rhodogorgonaceae
49229	Lithophyllaceae
49236	Porolithaceae
49291	Etheliaceae
49352	Pterocladiaceae
49355	Orthogonacladiaceae
49361	Quambalariaceae
49445	Naccariaceae
49541	Spyridiaceae
49603	Helotiaceae
49609	Scytonemataceae
49627	Caricaceae
49698	Palmophyllaceae
49708	Dictyosphaeriaceae
49719	Placentophoraceae
49770	Phyllophoraceae
49779	Tsengiaceae
49844	Nephrolepidaceae
49867	Nostocaceae
49878	Aphanizomenonaceae
49895	Microcoleaceae
49897	Oscillatoriaceae
49900	Coleofasciculaceae
49903	Leptolyngbyaceae
49906	Microcystaceae
49909	Hydrococcaceae
49912	Spirulinaceae
49915	Trichocoleusaceae
49918	Symphyonemataceae
50002	Gallaceaceae
50040	Bondarzewiaceae
50155	Atheliaceae
50167	Botryobasidiaceae
50225	Harknessiaceae
50242	Niaceae
50286	Hygrophoropsidaceae
50311	Radulomycetaceae
50315	Rickenellaceae
50358	Diaporthaceae
50380	Marthamycetaceae
50426	Xenasmataceae
50433	Octoblepharaceae
50572	Clavicloniaceae
50581	Phaeosphaeriaceae
50606	Guttulinaceae
50631	Omphalotaceae
50666	Cyphellaceae
50711	Hyaloriaceae
50778	Superstratomycetaceae
50801	Cladosporiaceae
50804	Didymosphaeriaceae
50807	Didymellaceae
50823	Niessliaceae
50826	Teratosphaeriaceae
50843	Sporocadaceae
50863	Bionectriaceae
50866	Coniothyriaceae
50869	Coryneliaceae
50872	Cucurbitariaceae
50888	Gnomoniaceae
50891	Lentitheciaceae
50898	Neocrinulaceae
50903	Phlogicylindriaceae
50906	Saccharataceae
50916	Teichosporaceae
50920	Aplosporellaceae
50922	Uromycladiaceae
50962	Microascaceae
50966	Ophiostomataceae
50988	Pestalotiopsidaceae
50994	Glomerellaceae
51118	Pseudofusicoccaceae
51124	Tranzscheliaceae
51178	Oxyporaceae
51203	Panaceae
51310	Naemateliaceae
51353	Legeriomycetaceae
51364	Harpellaceae
51419	Claustulaceae
51430	Gloeophyllaceae
51548	Characeae
51606	Xanthopyreniaceae
51739	Erythrogloeaceae
51743	Celotheliaceae
51790	Leprocaulaceae
52010	Dendrocerotaceae
52073	Dictydiaethaliaceae
52210	Lophocoleaceae
52241	Rhacocarpaceae
52301	Cordycipitaceae
52305	Thermoascaceae
52316	Incertae Sedis: Pleosporales
52319	Incertae Sedis: Dothideomycetes
52322	Incertae Sedis: Ascomycota
52343	Myriangiaceae
52375	Incertae Sedis: Sordariomycetes
52443	Archaeosporaceae
52446	Lizoniaceae
52520	Grifolaceae
52529	Okellyaceae
52532	Hericiaceae
52533	Vaucheriaceae
52564	Hypoxylaceae
52586	Laetiporaceae
\.


--
-- TOC entry 5084 (class 0 OID 31579)
-- Dependencies: 222
-- Data for Name: genetic_source; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genetic_source (acquisition_date, female_genetic_source, generation_number, genetic_source_id, gram_weight, landscape_only, male_genetic_source, price, propagation_type, provenance_id, research_notes, supplier_id, supplier_lot_number, variety_id, viability) FROM stdin;
\.


--
-- TOC entry 5085 (class 0 OID 31586)
-- Dependencies: 223
-- Data for Name: genus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genus (family_id, genus, genus_id) FROM stdin;
22928	Psilotum	20872
22715	Lycopodiella	20873
22715	Lycopodium	20874
22715	Phylloglossum	20875
22716	Selaginella	20876
22717	Isoetes	20877
22718	Helminthostachys	20878
22718	Ophioglossum	20879
23421	Lygodium	20880
22719	Schizaea	20881
22721	Adiantum	20882
22721	Anogramma	20883
22721	Ceratopteris	20884
22721	Cheilanthes	20885
22721	Doryopteris	20886
22721	Paraceterach	20887
22721	Taenitis	20888
22721	Acrostichum	20889
22721	Pteris	20890
22722	Dicranopteris	20891
22721	Platyzoma	20892
22723	Drynaria	20893
22723	Microsorum	20894
22724	Cyathea	20895
22724	Sphaeropteris	20896
22725	Ampelopteris	20897
22725	Christella	20898
22725	Cyclosorus	20899
22725	Macrothelypteris	20900
22726	Dennstaedtia	20901
22726	Histiopteris	20902
22726	Hypolepis	20903
22726	Microlepia	20904
22726	Pteridium	20905
22727	Lindsaea	20906
22728	Asplenium	20907
22728	Pleurosorus	20908
49844	Nephrolepis	20909
22730	Blechnum	20910
22730	Stenochlaena	20911
22731	Marsilea	20912
22731	Pilularia	20913
22732	Salvinia	20914
22732	Azolla	20915
22734	Cycas	20916
22735	Macrozamia	20917
22736	Podocarpus	20918
22737	Pinus	20919
22738	Actinostrobus	20920
22738	Callitris	20921
22739	Typha	20922
22740	Pandanus	20923
22741	Potamogeton	20924
34419	Ruppia	20925
22741	Lepilaena	20926
22743	Posidonia	20927
22744	Amphibolis	20928
22744	Cymodocea	20929
22744	Halodule	20930
22744	Syringodium	20931
22744	Thalassodendron	20932
22745	Heterozostera	20933
22745	Zostera	20934
22750	Najas	20935
22747	Aponogeton	20936
22748	Triglochin	20937
22749	Alisma	20938
22749	Caldesia	20939
22749	Damasonium	20940
22750	Blyxa	20941
22750	Egeria	20942
22750	Enhalus	20943
22750	Halophila	20944
22750	Maidenia	20945
22750	Ottelia	20946
22750	Vallisneria	20947
22751	Acrachne	20948
22751	Agropyron	20949
22751	Aira	20950
22751	Alloteropsis	20951
22751	Ammophila	20952
22751	Amphibromus	20953
22751	Amphipogon	20954
22751	Anthoxanthum	20955
22751	Aristida	20956
22751	Arrhenatherum	20957
22751	Arundinella	20958
22751	Arundo	20959
22751	Astrebla	20960
22751	Austrofestuca	20961
22751	Austrostipa	20962
22751	Avellinia	20963
22751	Avena	20964
22751	Axonopus	20965
22751	Bothriochloa	20966
22751	Brachiaria	20967
22751	Brachyachne	20968
22751	Brachypodium	20969
22751	Briza	20970
22751	Bromus	20971
22751	Capillipedium	20972
22751	Catapodium	20973
22751	Cenchrus	20974
22751	Chionachne	20975
22751	Chloris	20976
22751	Chrysopogon	20977
22751	Coelorhachis	20978
22751	Coix	20979
22751	Cortaderia	20980
22751	Critesion	20981
22751	Crypsis	20982
22751	Cymbopogon	20983
22751	Cynodon	20984
22751	Cynosurus	20985
22751	Cyperochloa	20986
22751	Dactylis	20987
22751	Dactyloctenium	20988
22751	Danthonia	20989
22751	Desmazeria	20990
22751	Deyeuxia	20991
22751	Dichanthium	20992
22751	Dichelachne	20993
22751	Digitaria	20994
22751	Dimeria	20995
22751	Diplachne	20996
22751	Diplopogon	20997
22751	Distichlis	20998
22751	Echinochloa	20999
22751	Echinopogon	21000
22751	Ectrosia	21001
22751	Ehrharta	21002
22751	Eleusine	21003
22751	Elionurus	21004
22751	Elymus	21005
22751	Elytrigia	21006
22751	Enneapogon	21007
22751	Enteropogon	21008
22751	Eragrostis	21009
22751	Eriochloa	21010
22751	Eulalia	21011
22751	Festuca	21012
22751	Festulolium	21013
22751	Germainia	21014
22751	Glyceria	21015
22751	Hainardia	21016
22751	Helictotrichon	21017
22751	Hemarthria	21018
22751	Heteropholis	21019
22751	Heteropogon	21020
22751	Homopholis	21021
22751	Hyparrhenia	21022
22751	Imperata	21023
22751	Ischaemum	21024
22751	Joycea	21025
22751	Koeleria	21026
22751	Lamarckia	21027
22751	Lasiochloa	21028
22751	Lepturus	21029
22751	Lolium	21030
22751	Melinis	21031
22751	Mibora	21032
22751	Microlaena	21033
22751	Miscanthus	21034
22751	Mnesithea	21035
22751	Monachather	21036
22751	Monodia	21037
22751	Neurachne	21038
22751	Neuropoa	21039
22751	Notodanthonia	21040
22751	Ophiuros	21041
22751	Oplismenus	21042
22751	Oryza	21043
22751	Oryzopsis	21044
22751	Oxychloris	21045
22751	Panicum	21046
22751	Paractaenum	21047
22751	Paraneurachne	21048
22751	Parapholis	21049
22751	Paspalidium	21050
22751	Paspalum	21051
22751	Pennisetum	21052
22751	Pentaschistis	21053
22751	Periballia	21054
22751	Perotis	21055
22751	Phalaris	21056
22751	Phleum	21057
22751	Phragmites	21058
22751	Piptatherum	21059
22751	Plagiochloa	21060
22751	Plagiosetum	21061
22751	Plectrachne	21062
22751	Poa	21063
22751	Polypogon	21064
22751	Psammagrostis	21065
22751	Pseudochaetochloa	21066
22751	Pseudopogonatherum	21067
22751	Pseudoraphis	21068
22751	Puccinellia	21069
22751	Rhynchelytrum	21070
22751	Rostraria	21071
22751	Rottboellia	21072
22751	Sacciolepis	21073
22751	Schismus	21074
22751	Schizachyrium	21075
22751	Sclerandrium	21076
22751	Scleropoa	21077
22751	Secale	21078
22751	Sehima	21079
22751	Serrafalcus	21080
22751	Setaria	21081
22751	Sorghastrum	21082
22751	Sorghum	21083
22751	Spartochloa	21084
22751	Spinifex	21085
22751	Stenotaphrum	21086
22751	Stipa	21087
22751	Thaumastochloa	21088
22751	Themeda	21089
22751	Thyridolepis	21090
22751	Trachynia	21091
22751	Tragus	21092
22751	Triodia	21093
22751	Tripogon	21094
22751	Trisetaria	21095
22751	Trisetum	21096
22751	Urochloa	21097
22751	Vulpia	21098
22751	Whiteochloa	21099
22751	Yakirra	21100
22751	Zea	21101
22752	Actinoschoenus	21102
22752	Arthrostylis	21103
22752	Bolboschoenus	21104
22752	Bulbostylis	21105
22752	Carpha	21106
22752	Chorizandra	21107
22752	Cladium	21108
22752	Crosslandia	21109
22752	Cyathochaeta	21110
22752	Cyperus	21111
22752	Eleocharis	21112
22752	Evandra	21113
22752	Fimbristylis	21114
22752	Fuirena	21115
22752	Gahnia	21116
22752	Gymnoschoenus	21117
22752	Hymenochaeta	21118
22752	Isolepis	21119
22752	Juncellus	21120
22752	Lepidosperma	21121
22752	Lipocarpha	21122
22752	Mesomelaena	21123
22752	Pycreus	21124
22752	Reedia	21125
22752	Rhynchospora	21126
22752	Schoenoplectus	21127
22752	Schoenus	21128
22752	Scirpus	21129
22752	Scleria	21130
22752	Tetraria	21131
22752	Tetrariopsis	21132
22752	Tricostularia	21133
22753	Livistona	21134
22753	Phoenix	21135
22754	Amorphophallus	21136
22754	Colocasia	21137
22754	Pistia	21138
22754	Typhonium	21139
22754	Zantedeschia	21140
22754	Lemna	21141
22754	Spirodela	21142
22754	Wolffia	21143
22756	Flagellaria	21144
22757	Alexgeorgea	21145
34338	Anarthria	21146
22757	Calorophus	21147
22757	Catocolea	21148
22757	Chaetanthus	21149
22757	Desmocladus	21150
23418	Ecdeiocolea	21151
22757	Empodisma	21152
22757	Georgiella	21153
22757	Harperia	21154
34338	Hopkinsia	21155
22757	Hypolaena	21156
22757	Lepidobolus	21157
22757	Leptocarpus	21158
22757	Lepyrodia	21159
22757	Loxocarya	21160
34338	Lyginia	21161
22757	Megalotheca	21162
22757	Onychosepalum	21163
22757	Restio	21164
22757	Sporadanthus	21165
22757	Taraxis	21166
22758	Aphelia	21167
22758	Centrolepis	21168
22759	Hydatella	21169
22759	Trithuria	21170
22761	Eriocaulon	21171
22762	Commelina	21172
22762	Cyanotis	21173
22931	Eichhornia	21174
22931	Monochoria	21175
22763	Philydrum	21176
22764	Juncus	21177
22764	Luzula	21178
22766	Ripogonum	21179
22767	Asparagus	21180
22767	Myrsiphyllum	21181
22767	Acanthocarpus	21182
22768	Baxteria	21183
22768	Calectasia	21184
22768	Dasypogon	21185
22768	Kingia	21186
22767	Lomandra	21187
22767	Xerolirion	21188
22769	Xanthorrhoea	21189
34337	Dianella	21190
34337	Stypandra	21191
34337	Agrostocrinum	21192
34337	Arnocrinum	21193
22767	Arthropodium	21194
23411	Borya	21195
34337	Caesia	21196
34337	Chamaescilla	21197
22767	Chlorophytum	21198
34337	Corynotheca	21199
22767	Dichopogon	21200
34337	Hensmania	21201
34337	Hodgsoniola	21202
34337	Johnsonia	21203
22767	Laxmannia	21204
22767	Murchisonia	21205
22767	Sowerbaea	21206
34337	Stawellia	21207
22767	Thysanotus	21208
34337	Tricoryne	21209
22772	Asphodelus	21210
22772	Bulbine	21211
22772	Bulbinella	21212
22772	Trachyandra	21213
22767	Albuca	21214
22767	Lachenalia	21215
22767	Muscari	21216
22767	Ornithogalum	21217
34336	Agapanthus	21218
22774	Allium	21219
22774	Ipheion	21220
22774	Nothoscordum	21221
22775	Baeometra	21222
22775	Burchardia	21223
22775	Iphigenia	21224
22775	Wurmbea	21225
22776	Alstroemeria	21226
22777	Anigozanthos	21227
22777	Blancoa	21228
22777	Conostylis	21229
22777	Haemodorum	21230
22777	Macropidia	21231
22777	Phlebocarya	21232
22777	Tribonanthes	21233
22777	Wachendorfia	21234
22778	Cyanella	21235
22779	Amaryllis	21236
22779	Crinum	21237
22779	Leucojum	21238
22779	Narcissus	21239
22779	Proiphys	21240
22780	Hypoxis	21241
22767	Yucca	21242
22782	Tacca	21243
22784	Babiana	21244
22784	Chasmanthe	21245
22784	Dierama	21246
22784	Ferraria	21247
22784	Gladiolus	21248
22784	Gynandriris	21249
22784	Hexaglottis	21250
22784	Homeria	21251
22784	Iris	21252
22784	Ixia	21253
22784	Moraea	21254
22784	Patersonia	21255
22784	Romulea	21256
22784	Sisyrinchium	21257
22784	Tritonia	21258
22784	Watsonia	21259
22786	Burmannia	21260
22787	Burnettia	21261
22787	Caladenia	21262
22787	Calochilus	21263
22787	Corybas	21264
22787	Cryptostylis	21265
22787	Cyanicula	21266
22787	Cymbidium	21267
22787	Cyrtostylis	21268
22787	Dendrobium	21269
22787	Didymoplexis	21270
22787	Dipodium	21271
22787	Diuris	21272
22787	Drakaea	21273
22787	Drakonorchis	21274
22787	Elythranthera	21275
22787	Epiblema	21276
22787	Eriochilus	21277
22787	Eulophia	21278
22787	Gastrodia	21279
22787	Genoplesium	21280
22787	Geodorum	21281
22787	Goadbyella	21282
22787	Habenaria	21283
22787	Leporella	21284
22787	Leptoceras	21285
22787	Lyperanthus	21286
22787	Microtis	21287
22787	Monadenia	21288
22787	Nervilia	21289
22787	Paracaleana	21290
22787	Praecoxanthus	21291
22787	Prasophyllum	21292
22787	Pterostylis	21293
22787	Pyrorchis	21294
22787	Rhizanthella	21295
22787	Rostranthus	21296
22787	Spiculaea	21297
22787	Thelymitra	21298
22787	X Drakodenia	21299
22788	Allocasuarina	21300
22788	Casuarina	21301
23248	Peperomia	21302
22789	Batis	21303
23410	Celtis	21304
23410	Trema	21305
22791	Fatoua	21306
22791	Ficus	21307
22791	Malaisia	21308
22792	Boehmeria	21309
22792	Laportea	21310
22792	Parietaria	21311
22792	Pouzolzia	21312
22792	Soleirolia	21313
22792	Urtica	21314
22793	Acidonia	21315
22793	Banksia	21316
22793	Conospermum	21317
22793	Dryandra	21318
22793	Grevillea	21319
22793	Hakea	21320
22793	Lambertia	21321
22793	Persoonia	21322
22793	Stenocarpus	21323
22793	Stirlingia	21324
22793	Synaphea	21325
22793	Xylomelum	21326
22794	Choretrum	21327
22794	Exocarpos	21328
22794	Santalum	21329
22794	Spirogardnera	21330
22795	Opilia	21331
22796	Olax	21332
22797	Decaisnina	21333
22797	Diplatia	21334
22797	Lysiana	21335
22797	Nuytsia	21336
22794	Viscum	21337
22799	Aristolochia	21338
33461	Pilostyles	21339
22801	Emex	21340
22801	Fagopyrum	21341
22801	Muehlenbeckia	21342
22801	Persicaria	21343
22801	Polygonum	21344
22801	Rumex	21345
22802	Arthrocnemum	21346
22802	Atriplex	21347
22802	Babbagia	21348
22802	Bassia	21349
22802	Chenopodium	21350
22802	Didymanthus	21351
22802	Dissocarpus	21352
22802	Dysphania	21353
22802	Einadia	21354
22802	Enchylaena	21355
22802	Eremophea	21356
22802	Eriochiton	21357
22802	Halosarcia	21358
22802	Kochia	21359
22802	Maireana	21360
22802	Malacocera	21361
22802	Neobassia	21362
22802	Osteocarpum	21363
22802	Pachycornia	21364
22802	Rhagodia	21365
22802	Roycea	21366
22802	Salicornia	21367
22802	Salsola	21368
22802	Sarcocornia	21369
22802	Sclerochlamys	21370
22802	Sclerolaena	21371
22802	Sclerostegia	21372
22802	Spinacia	21373
22802	Suaeda	21374
22802	Tecticornia	21375
22802	Tegicornia	21376
22802	Teloxys	21377
22802	Threlkeldia	21378
22803	Achyranthes	21379
22803	Aerva	21380
22803	Alternanthera	21381
22803	Amaranthus	21382
22803	Celosia	21383
22803	Deeringia	21384
22803	Dipteranthemum	21385
22803	Gomphrena	21386
22803	Hemichroa	21387
22803	Ptilotus	21388
22803	Pupalia	21389
22804	Boerhavia	21390
22804	Commicarpus	21391
22804	Pisonia	21392
22805	Codonocarpus	21393
22805	Didymotheca	21394
22805	Gyrostemon	21395
22805	Tersonia	21396
22806	Phytolacca	21397
22807	Aizoon	21398
22807	Carpobrotus	21399
22807	Drosanthemum	21400
22807	Galenia	21401
22807	Lampranthus	21402
22807	Mesembryanthemum	21403
22807	Neogunnia	21404
22807	Ruschia	21405
22807	Sarcozona	21406
22807	Tetragonia	21407
22807	Zaleya	21408
22808	Glinus	21409
48326	Macarthuria	21410
48329	Calandrinia	21411
22809	Portulaca	21412
22809	Rumicastrum	21413
22810	Cerastium	21414
22810	Drymaria	21415
22810	Gypsophila	21416
22810	Herniaria	21417
22810	Lychnis	21418
22810	Minuartia	21419
22810	Petrorhagia	21420
22810	Polycarpaea	21421
22810	Polycarpon	21422
22810	Sagina	21423
22810	Silene	21424
22810	Spergula	21425
22810	Spergularia	21426
22810	Stellaria	21427
22810	Vaccaria	21428
22811	Nymphaea	21429
22811	Ondinea	21430
22812	Ceratophyllum	21431
22813	Adonis	21432
22813	Clematis	21433
22813	Consolida	21434
22813	Myosurus	21435
22813	Ranunculus	21436
22814	Hypserpa	21437
22814	Pachygone	21438
22814	Stephania	21439
22814	Tinospora	21440
22815	Annona	21441
22815	Cyathostemma	21442
22815	Miliusa	21443
22815	Polyalthia	21444
22815	Polyaulax	21445
22815	Uvaria	21446
22816	Myristica	21447
22817	Cassytha	21448
22817	Cryptocarya	21449
22817	Litsea	21450
22818	Gyrocarpus	21451
22819	Argemone	21452
22819	Eschscholzia	21453
22819	Glaucium	21454
22819	Papaver	21455
22819	Romneya	21456
22819	Fumaria	21457
22821	Cadaba	21458
22821	Capparis	21459
35224	Cleome	21460
35224	Justago	21461
22822	Emblingia	21462
22823	Alyssum	21463
22823	Arabidella	21464
22823	Blennodia	21465
22823	Brassica	21466
22823	Cakile	21467
22823	Camelina	21468
22823	Capsella	21469
22823	Cardamine	21470
22823	Carrichtera	21471
22823	Coronopus	21472
22823	Cuphonotus	21473
22823	Eruca	21474
22823	Geococcus	21475
22823	Harmsiodoxa	21476
22823	Hirschfeldia	21477
22823	Hymenolobus	21478
22823	Lobularia	21479
22823	Matthiola	21480
22823	Microlepidium	21481
22823	Pachymitus	21482
22823	Phlegmatospermum	21483
22823	Rapistrum	21484
22823	Rorippa	21485
22823	Sisymbrium	21486
22823	Soccowia	21487
22823	Succowia	21488
22824	Reseda	21489
22826	Aldrovanda	21490
22826	Drosera	21491
22827	Cotyledon	21492
22827	Crassula	21493
22828	Cephalotus	21494
23416	Eremosyne	21495
22830	Billardiera	21496
22830	Bursaria	21497
22830	Citriobatus	21498
22830	Pittosporum	21499
22830	Sollya	21500
22831	Byblis	21501
35183	Aphanopetalum	21502
22833	Stylobasium	21503
22834	Acaena	21504
22834	Aphanes	21505
22834	Prunus	21506
22834	Rosa	21507
22834	Rubus	21508
22834	Sanguisorba	21509
22835	Parinari	21510
34857	Acacia	21511
34857	Albizia	21512
34857	Cathormion	21513
34857	Dichrostachys	21514
34857	Leucaena	21515
34857	Neptunia	21516
34857	Paraserianthes	21517
34857	Pithecolobium	21518
34857	Prosopis	21519
34857	Bauhinia	21520
34857	Caesalpinia	21521
34857	Cassia	21522
34857	Delonix	21523
34857	Erythrophleum	21524
34857	Gleditsia	21525
34857	Labichea	21526
34857	Lysiphyllum	21527
34857	Parkinsonia	21528
34857	Petalostylis	21529
34857	Piliostigma	21530
34857	Senna	21531
34857	Tamarindus	21532
34857	Abrus	21533
34857	Aenictophyton	21534
34857	Aeschynomene	21535
34857	Alhagi	21536
34857	Alysicarpus	21537
34857	Aotus	21538
34857	Aphyllodium	21539
34857	Arachis	21540
34857	Atylosia	21541
34857	Austrodolichos	21542
34857	Bossiaea	21543
34857	Brachysema	21544
34857	Burgesia	21545
34857	Burtonia	21546
34857	Callistachys	21548
34857	Centrosema	21549
34857	Chamaecytisus	21550
34857	Christia	21551
34857	Cicer	21552
34857	Clitoria	21553
34857	Crotalaria	21554
34857	Cullen	21555
34857	Cupulanthus	21556
34857	Cytisus	21557
34857	Daviesia	21558
34857	Dendrolobium	21559
34857	Dicerma	21560
34857	Dillwynia	21561
34857	Dolichos	21562
34857	Erichsenia	21563
34857	Eriosema	21564
34857	Euchilopsis	21565
34857	Eutaxia	21566
22794	Fusanus	21567
34857	Galactia	21568
34857	Genista	21569
34857	Gliricidia	21570
34857	Glycine	21571
34857	Gompholobium	21572
34857	Goodia	21573
34857	Hedysarum	21574
34857	Holtzea	21575
34857	Hovea	21576
34857	Indigofera	21577
34857	Isotropis	21578
34857	Jacksonia	21579
34857	Jansonia	21580
34857	Kennedia	21581
34857	Lablab	21582
34857	Lathyrus	21583
34857	Latrobea	21584
34857	Leptosema	21585
34857	Lespedeza	21586
34857	Lotus	21587
34857	Lupinus	21588
34857	Macroptilium	21589
34857	Macrotyloma	21590
34857	Medicago	21591
34857	Melilotus	21592
34857	Mirbelia	21593
34857	Mucuna	21594
34857	Muelleranthus	21595
34857	Nemcia	21596
34857	Nomismia	21597
34857	Ornithopus	21598
34857	Otion	21599
34857	Oxylobium	21600
34857	Paratephrosia	21601
34857	Phaseolus	21602
34857	Phyllodium	21603
34857	Phyllota	21604
34857	Plagiocarpus	21605
34857	Podalyria	21606
34857	Psoralea	21607
34857	Ptychosema	21608
34857	Pultenaea	21609
34857	Pycnospora	21610
34857	Retama	21611
34857	Rhynchosia	21612
34857	Robinia	21613
34857	Rothia	21614
34857	Sclerothamnus	21615
34857	Sesbania	21616
34857	Sphaerolobium	21617
34857	Stylosanthes	21618
34857	Sutherlandia	21619
34857	Swainsona	21620
34857	Tadehagi	21621
34857	Teline	21622
34857	Templetonia	21623
34857	Tephrosia	21624
34857	Trifolium	21625
34857	Trigonella	21626
34857	Uraria	21627
34857	Vicia	21628
34857	Viminaria	21629
22839	Erodium	21630
22839	Pelargonium	21631
22840	Oxalis	21632
22842	Linum	21633
22843	Erythroxylum	21634
35278	Nitraria	21635
22844	Tribulopis	21636
22844	Tribulus	21637
22845	Asterolasia	21638
22845	Boronia	21639
22845	Chorilaena	21640
22845	Correa	21641
22845	Crowea	21642
22845	Drummondita	21643
22845	Eriostemon	21644
22845	Geijera	21645
22845	Glycosmis	21646
22845	Melicope	21647
22845	Microcybe	21648
22845	Muiriantha	21649
22845	Murraya	21650
22845	Paramignya	21651
22845	Phebalium	21652
22845	Rhadinothamnus	21653
22845	Urocarpus	21654
22845	Zanthoxylum	21655
22846	Brucea	21656
22845	Harrisonia	21657
22833	Suriana	21658
22847	Canarium	21659
22847	Garuga	21660
22848	Aglaia	21661
22848	Dysoxylum	21662
22848	Melia	21663
22848	Owenia	21664
22848	Toona	21665
22848	Turraea	21666
22848	Vavaea	21667
22848	Xylocarpus	21668
35265	Platytheca	21669
35265	Tetratheca	21670
35265	Tremandra	21671
22850	Comesperma	21672
22850	Polygala	21673
22850	Salomonia	21674
22851	Acalypha	21675
22851	Adriana	21676
22851	Amperea	21677
34858	Andrachne	21678
34858	Antidesma	21679
22851	Bertya	21680
22851	Beyeria	21681
34858	Breynia	21682
34858	Bridelia	21683
22851	Calycopeplus	21684
22851	Chrozophora	21685
22851	Claoxylon	21686
22851	Croton	21687
22851	Dimorphocalyx	21688
34856	Drypetes	21689
22851	Eremocarpus	21690
22851	Euphorbia	21691
22851	Excoecaria	21692
34858	Flueggea	21693
34858	Glochidion	21694
22851	Homalanthus	21695
22851	Jatropha	21696
34858	Leptopus	21697
22851	Mallotus	21698
34858	Margaritaria	21699
22851	Mercurialis	21700
22851	Monotaxis	21701
22851	Omalanthus	21702
35036	Petalostigma	21703
34858	Phyllanthus	21704
34858	Poranthera	21705
35036	Pseudanthus	21706
22851	Ricinocarpos	21707
22851	Ricinocarpus	21708
34858	Sauropus	21709
22851	Securinega	21710
22851	Stachystemon	21711
22915	Callitriche	21712
22853	Mangifera	21713
22853	Schinus	21714
22855	Apatophyllum	21715
22855	Celastrus	21716
22855	Maytenus	21717
22855	Psammomoya	21718
22855	Macgregoria	21719
22855	Tripterococcus	21720
22858	Alectryon	21721
22858	Allophylus	21722
22858	Cardiospermum	21723
22858	Diplopeltis	21724
22858	Distichostemon	21725
22858	Dodonaea	21726
22858	Heterodendrum	21727
22858	Lepisanthes	21728
48327	Melianthus	21729
22859	Blackallia	21730
22859	Colubrina	21731
22859	Emmenosperma	21732
22859	Granitites	21733
22859	Pomaderris	21734
22859	Rhamnus	21735
22859	Siegfriedia	21736
22859	Spyridium	21737
22859	Trymalium	21738
22859	Ventilago	21739
22859	Ziziphus	21740
22860	Ampelocissus	21741
22860	Cayratia	21742
22860	Cissus	21743
22860	Clematicissus	21744
22860	Vitis	21745
22862	Corchorus	21746
22862	Grewia	21747
22862	Triumfetta	21748
22862	Abutilon	21749
22862	Alyogyne	21750
22862	Anoda	21751
22862	Decaschistia	21752
22862	Fioria	21753
22862	Gossypium	21754
22862	Herissantia	21755
22862	Hibiscus	21756
22862	Lagunaria	21757
22862	Lavatera	21758
22862	Lawrencia	21759
22862	Malva	21760
22862	Malvastrum	21761
22862	Modiola	21762
22862	Pavonia	21763
22862	Radyera	21764
22862	Selenothamnus	21765
22862	Sida	21766
22862	Thespesia	21767
22862	Urena	21768
22862	Adansonia	21769
22862	Bombax	21770
22862	Camptostemon	21771
22862	Brachychiton	21772
22862	Commersonia	21773
22862	Dicarpidium	21774
22862	Gilesia	21775
22862	Guichenotia	21776
22862	Hannafordia	21777
22862	Helicteres	21778
22862	Heritiera	21779
22862	Keraudrenia	21780
22862	Lasiopetalum	21781
22862	Lysiosepalum	21782
22862	Melhania	21783
22862	Rulingia	21784
22862	Thomasia	21785
22862	Waltheria	21786
22865	Pachynema	21787
22866	Calophyllum	21788
22867	Bergia	21789
22867	Elatine	21790
23241	Tamarix	21791
22925	Cochlospermum	21792
22870	Viola	21793
23242	Turnera	21794
22871	Passiflora	21795
22872	Opuntia	21796
22873	Thecanthes	21797
22874	Ammannia	21798
22874	Lagerstroemia	21799
22874	Lythrum	21800
22874	Pemphis	21801
22874	Sonneratia	21802
22876	Planchonia	21803
22877	Bruguiera	21804
22877	Carallia	21805
22877	Rhizophora	21806
22878	Quisqualis	21807
22878	Terminalia	21808
22879	Actinodium	21809
22879	Angasomyrtus	21810
22879	Baeckea	21811
22879	Balaustion	21812
22879	Beaufortia	21813
22879	Callistemon	21814
22879	Calothamnus	21815
22879	Calythropsis	21816
22879	Calytrix	21817
22879	Chamelaucium	21818
22879	Conothamnus	21819
22879	Corymbia	21820
22879	Corynanthera	21821
22879	Darwinia	21822
22879	Eremaea	21823
22879	Eucalyptus	21824
22879	Eugenia	21825
22879	Euryomyrtus	21826
22879	Fenzlia	21827
22879	Homalocalyx	21828
22879	Homalospermum	21829
22879	Hypocalymma	21830
22879	Kunzea	21831
22879	Lamarchea	21832
22879	Leptospermum	21833
22879	Lhotskya	21834
22879	Lophostemon	21835
22879	Malleostemon	21836
22879	Melaleuca	21837
22879	Micromyrtus	21838
22879	Myrtella	21839
22879	Osbornia	21840
22879	Pericalymma	21841
22879	Phymatocarpus	21842
22879	Pileanthus	21843
22879	Regelia	21844
22879	Rinzia	21845
22879	Scholtzia	21846
22879	Syzygium	21847
22879	Thryptomene	21848
22879	Tristania	21849
22879	Verticordia	21850
22879	Wehlia	21851
22879	Xanthostemon	21852
22880	Melastoma	21853
22880	Memecylon	21854
22880	Osbeckia	21855
22881	Epilobium	21856
22881	Ludwigia	21857
22881	Oenothera	21858
22882	Glischrocaryon	21859
22882	Gonocarpus	21860
22882	Haloragis	21861
22882	Loudonia	21862
22882	Meziella	21863
22882	Myriophyllum	21864
22884	Actinotus	21865
22884	Ammi	21866
22884	Apium	21867
22884	Bupleurum	21868
22884	Chlaenosciadium	21869
22884	Conium	21870
22884	Daucus	21871
22884	Eryngium	21872
22884	Foeniculum	21873
22884	Homalosciadium	21874
22884	Lilaeopsis	21875
22883	Neosciadium	21876
22884	Pentapeltis	21877
22884	Platysace	21878
22883	Trachymene	21879
22884	Uldinia	21880
22884	Xanthosia	21881
23412	Andersonia	21882
23412	Astroloma	21883
23412	Coleanthera	21884
23412	Conostephium	21885
23412	Cosmelia	21886
23412	Croninia	21887
23412	Leocopogon	21888
23412	Lysinema	21889
23412	Monotoca	21890
23412	Needhamia	21891
23412	Needhamiella	21892
23412	Oligarrhena	21893
23412	Sphenotoma	21894
23412	Styphelia	21895
23412	Trochocarpa	21896
22887	Aegiceras	21897
22887	Rapanea	21898
22887	Anagallis	21899
22887	Asterolinon	21900
22887	Samolus	21901
22888	Aegialitis	21902
22888	Limonium	21903
22888	Muellerolimon	21904
22888	Plumbago	21905
22889	Mimusops	21906
22889	Planchonella	21907
22889	Pouteria	21908
22890	Diospyros	21909
22930	Jasminum	21910
22930	Olea	21911
22930	Syringa	21912
22891	Logania	21913
22891	Mitrasacme	21914
22891	Mitreola	21915
22891	Phyllangium	21916
22891	Strychnos	21917
22907	Buddleja	21918
22893	Canscora	21919
22893	Centaurium	21920
22893	Cicendia	21921
22893	Erythraea	21922
22893	Sebaea	21923
22894	Nymphoides	21924
22894	Villarsia	21925
22895	Allamanda	21926
22895	Alstonia	21927
22895	Alyxia	21928
22895	Carissa	21929
22895	Cascabela	21930
22895	Catharanthus	21931
22895	Ervatamia	21932
22895	Ichnocarpus	21933
22895	Lyonsia	21934
22895	Parsonsia	21935
22895	Tabernaemontana	21936
22895	Vinca	21937
22895	Wrightia	21938
22895	Araujia	21939
22895	Asclepias	21940
22895	Bidaria	21941
22895	Calotropis	21942
22895	Cryptostegia	21943
22895	Gomphocarpus	21944
22895	Gymnanthera	21945
22895	Hoya	21946
22895	Ischnostemma	21947
22895	Marsdenia	21948
22895	Microstemma	21949
22895	Pentatropis	21950
22895	Rhyncharrhena	21951
22895	Secamone	21952
22895	Tylophora	21953
22897	Bonamia	21954
22897	Convolvulus	21955
22897	Cressa	21956
22897	Evolvulus	21957
22897	Ipomoea	21958
22897	Merremia	21959
22897	Operculina	21960
22897	Polymeria	21961
22897	Quamoclit	21962
22897	Xenostegia	21963
22897	Cuscuta	21964
35277	Hydrolea	21965
22901	Phacelia	21966
22901	Amsinckia	21967
22901	Anchusa	21968
22901	Argusia	21969
22901	Borago	21970
22901	Buglossoides	21971
22901	Coldenia	21972
22901	Cordia	21973
22901	Cynoglossum	21974
22901	Echium	21975
22901	Ehretia	21976
22901	Halgania	21977
22901	Heliotropium	21978
22901	Messerschmidia	21979
22901	Myosotis	21980
22901	Omphalolappula	21981
22901	Plagiobothrys	21982
22901	Symphytum	21983
22901	Tournefortia	21984
22901	Trichodesma	21985
22905	Callicarpa	21986
22905	Clerodendrum	21987
22902	Lantana	21988
22902	Phyla	21989
22905	Premna	21990
22902	Pygmaeopremna	21991
22902	Stachytarpheta	21992
22902	Verbena	21993
22905	Vitex	21994
22905	Chloanthes	21995
22905	Cyanostegia	21996
22905	Dicrastylis	21997
22906	Grammosolen	21998
22905	Hemiphora	21999
22905	Lachnostachys	22000
22905	Mallophora	22001
22905	Newcastelia	22002
22905	Physopsis	22003
22905	Pityrodia	22004
22905	Spartothamnella	22005
22913	Avicennia	22006
22905	Anisomeles	22007
22905	Basilicum	22008
22905	Coleus	22009
22905	Dysophylla	22010
22905	Eichlerago	22011
22905	Hemiandra	22012
22905	Hemigenia	22013
22905	Hyptis	22014
22905	Lamium	22015
22905	Lavandula	22016
22905	Leonotis	22017
22905	Marrubium	22018
22905	Mentha	22019
22905	Moluccella	22020
22905	Ocimum	22021
22905	Pogostemon	22022
22905	Prostanthera	22023
22905	Prunella	22024
22905	Salvia	22025
22905	Solenostemon	22026
22905	Teucrium	22027
22905	Wrixonia	22028
22906	Anthocercis	22029
22906	Anthotroche	22030
22906	Crenidium	22031
22906	Datura	22032
22906	Duboisia	22033
22906	Isandra	22034
22906	Lycopersicon	22035
22906	Nicotiana	22036
22906	Physalis	22037
22906	Solanum	22038
22906	Symonanthus	22039
22915	Bacopa	22040
22911	Bartsia	22041
22911	Buchnera	22042
22911	Centranthera	22043
22907	Dischisma	22044
22915	Dopatrium	22045
35337	Elacholoma	22046
22911	Euphrasia	22047
35337	Glossostigma	22048
22915	Gratiola	22049
35338	Hemiarrhena	22050
35338	Ilysanthes	22051
22915	Kickxia	22052
22915	Limnophila	22053
22907	Limosella	22054
22915	Linaria	22055
35338	Lindernia	22056
35337	Microcarpaea	22057
35337	Mimulus	22058
22915	Misopates	22059
22915	Morgania	22060
22911	Parentucellia	22061
35337	Peplidium	22062
22907	Phyllopodium	22063
22907	Polycarena	22064
22911	Rhamphicarpa	22065
22915	Scoparia	22066
22915	Stemodia	22067
22911	Striga	22068
22907	Verbascum	22069
22915	Veronica	22070
22907	Zaluzianskya	22071
22908	Dolichandrone	22072
22908	Pandorea	22073
22909	Josephinia	22074
22910	Proboscidea	22075
22911	Orobanche	22076
22912	Polypompholyx	22077
22912	Utricularia	22078
22913	Acanthus	22079
22913	Asystasia	22080
22913	Brunoniella	22081
22913	Dicladanthera	22082
22913	Dicliptera	22083
22913	Dipteracanthus	22084
22913	Ebermaiera	22085
22913	Harnieria	22086
22913	Hygrophila	22087
22913	Hypoestes	22088
22913	Nelsonia	22089
22913	Pseuderanthemum	22090
22913	Rostellularia	22091
22913	Ruellia	22092
22913	Sarojusticia	22093
22913	Staurogyne	22094
22913	Thunbergia	22095
22907	Calamphoreus	22096
22907	Diocirea	22097
22907	Eremophila	22098
22907	Myoporum	22099
22907	Pholidia	22100
22915	Plantago	22101
22916	Borreria	22102
22916	Dentella	22103
22916	Galium	22104
22916	Guettarda	22105
22916	Ixora	22106
22916	Knoxia	22107
22916	Morinda	22108
22916	Nauclea	22109
22916	Opercularia	22110
22916	Pavetta	22111
22916	Psychotria	22112
22916	Richardia	22113
22916	Scyphiphora	22114
22916	Spermacoce	22115
22916	Synaptantha	22116
22916	Terenna	22117
22926	Lonicera	22118
22926	Centranthus	22119
22919	Citrullus	22120
22919	Coccinia	22121
22919	Diplocyclos	22122
22919	Ecballium	22123
22919	Luffa	22124
22919	Melothria	22125
22919	Momordica	22126
22919	Mukia	22127
22919	Trichosanthes	22128
22919	Zehneria	22129
22920	Wahlenbergia	22130
22920	Grammatotheca	22131
22920	Isotoma	22132
22920	Lobelia	22133
22920	Monopsis	22134
22922	Anthotium	22135
22922	Brunonia	22136
22922	Calogyne	22137
22922	Catosperma	22138
22922	Coopernookia	22139
22922	Dampiera	22140
22922	Diaspasis	22141
22922	Goodenia	22142
22922	Lechenaultia	22143
22922	Neogoodenia	22144
22922	Nigromnia	22145
22922	Pentaptilon	22146
22922	Scaevola	22147
22922	Selliera	22148
22922	Symphyobasis	22149
22922	Velleia	22150
22922	Verreauxia	22151
22923	Levenhookia	22152
22923	Stylidium	22153
22924	Acanthospermum	22154
22924	Achillea	22155
22924	Acroptilon	22156
22924	Actinobole	22157
22924	Actites	22158
22924	Adenostemma	22159
22924	Ageratum	22160
22924	Ambrosia	22161
22924	Anemocarpa	22162
22924	Angianthus	22163
22924	Anthemis	22164
22924	Arctotheca	22165
22924	Arctotis	22166
22924	Argentipallium	22167
22924	Argyranthemum	22168
22924	Argyroglottis	22169
22924	Artemisia	22170
22924	Aster	22171
22924	Asteridea	22172
22924	Baccharis	22173
22924	Berkheya	22174
22924	Bidens	22175
22924	Blumea	22176
22924	Brachyscome	22177
22924	Calocephalus	22178
22924	Calotis	22179
22924	Carduus	22180
22924	Cassinia	22181
22924	Centaurea	22182
22924	Cephalipterum	22183
22924	Cephalosorus	22184
22924	Chondrilla	22185
22924	Chondropyxis	22186
22924	Chrysanthemum	22187
22924	Chrysocephalum	22188
22924	Chrysocoryne	22189
22924	Chrysogonum	22190
22924	Cichorium	22191
22924	Cirsium	22192
22924	Conyza	22193
22924	Cotula	22194
22924	Craspedia	22195
22924	Crepis	22196
22924	Cymbonotus	22197
22924	Cynara	22198
22924	Delairea	22199
22924	Dichromochlamys	22200
22924	Diodontium	22201
22924	Dithyrostegia	22202
22924	Dittrichia	22203
22924	Eclipta	22204
22924	Elachanthus	22205
22924	Emilia	22206
22924	Epaltes	22207
22924	Epitriche	22208
22924	Erigeron	22209
22924	Eriochlamys	22210
22924	Erodiophyllum	22211
22924	Erymophyllum	22212
22924	Euchiton	22213
22924	Eupatorium	22214
22924	Eurybiopsis	22215
22924	Ewartia	22216
22924	Feldstonia	22217
22924	Filago	22218
22924	Fitzwillia	22219
22924	Flaveria	22220
22924	Galinsoga	22221
22924	Gamochaeta	22222
22924	Gazania	22223
22924	Gilberta	22224
22924	Gilruthia	22225
22924	Glossocardia	22226
22924	Glossogyne	22227
22924	Gnaphalium	22228
22924	Gnephosis	22229
22924	Gorteria	22230
22924	Haegiela	22231
22924	Haptotrichion	22232
22924	Hedypnois	22233
22924	Helianthus	22234
22924	Helichrysum	22235
22924	Helipterum	22236
22924	Helminthotheca	22237
22924	Hyalochlamys	22238
22924	Hyalosperma	22239
22924	Hypochaeris	22240
22924	Inula	22241
22924	Iotasperma	22242
22924	Isoetopsis	22243
22924	Ixiochlamys	22244
22924	Ixiolaena	22245
22924	Kippistia	22246
22924	Lactuca	22247
22924	Lagenifera	22248
22924	Launaea	22249
22924	Lawrencella	22250
22924	Lemooria	22251
22924	Leontodon	22252
22924	Leptinella	22253
22924	Leucanthemum	22254
22924	Leucochrysum	22255
22924	Leucophyta	22256
22924	Matricaria	22257
22924	Millotia	22258
22924	Minuria	22259
22924	Neotysonia	22260
22924	Olearia	22261
22924	Onopordum	22262
22924	Othonna	22263
22924	Ozothamnus	22264
22924	Pentalepis	22265
22924	Picris	22266
22924	Pithocarpa	22267
22924	Pluchea	22268
22924	Podolepis	22269
22924	Podotheca	22270
22924	Polycalymma	22271
22924	Pseudognaphalium	22272
22924	Pterochaeta	22273
22924	Quinetia	22274
22924	Quinqueremulus	22275
22924	Rhodanthe	22276
22924	Rutidosis	22277
22924	Scyphocoronis	22278
22924	Senecio	22279
22924	Sigesbeckia	22280
22924	Siloxerus	22281
22924	Silybum	22282
22924	Solidago	22283
22924	Soliva	22284
22924	Sonchus	22285
22924	Sondottia	22286
22924	Sphaeranthus	22287
22924	Streptoglossa	22288
22924	Stuartina	22289
22924	Tagetes	22290
22924	Taplinia	22291
22924	Taraxacum	22292
22924	Thespidium	22293
22924	Thiseltonia	22294
22924	Tietkensia	22295
22924	Tolpis	22296
22924	Toxanthes	22297
22924	Tragopogon	22298
22924	Trichanthodium	22299
22924	Trichocline	22300
22924	Tridax	22301
22924	Triptilodiscus	22302
22924	Tysonia	22303
22924	Urospermum	22304
22924	Ursinia	22305
22924	Vellereophyton	22306
22924	Verbesina	22307
22924	Vernonia	22308
22924	Vittadinia	22309
22924	Waitzia	22310
22924	Wedelia	22311
22924	Xanthium	22312
26011	Corallina	22313
26011	Haliptilon	22314
26011	Jania	22315
25966	Acetabularia	22316
25966	Polyphysa	22317
22719	Actinostachys	22318
34857	Chamaecrista	22319
22859	Stenanthemum	22320
22750	Elodea	22321
22750	Hydrilla	22322
22750	Thalassia	22323
22751	Agrostis	22324
22751	Alopecurus	22325
22751	Andropogon	22326
22751	Elytrophorus	22327
22751	Eriachne	22328
22751	Eustachys	22329
22751	Gastridium	22330
22751	Hackelochloa	22331
22751	Heterachne	22332
22751	Holcus	22333
22751	Hordeum	22334
22751	Isachne	22335
22751	Iseilema	22336
22751	Lagurus	22337
22751	Leptochloa	22338
22751	Lophochloa	22339
22751	Micraira	22340
22751	Sporobolus	22341
22751	Tetrarrhena	22342
22751	Thinopyrum	22343
22751	Tribolium	22344
22751	Triraphis	22345
22751	Triticum	22346
22751	Vetiveria	22347
22751	Xerochloa	22348
22751	Zygochloa	22349
22752	Baumea	22350
22752	Carex	22351
22752	Caustis	22352
22752	Chrysitrix	22353
22757	Meeboldina	22354
22757	Pseudoloxocarya	22355
22758	Brizula	22356
22758	Desvauxia	22357
22760	Xyris	22358
22762	Cartonema	22359
22762	Murdannia	22360
22763	Philydrella	22361
22765	Stemona	22362
22766	Smilax	22363
22767	Protasparagus	22364
22767	Chamaexeros	22365
22780	Curculigo	22366
22767	Agave	22367
22783	Dioscorea	22368
22784	Crocosmia	22369
22784	Freesia	22370
22784	Hesperantha	22371
22784	Homoglossum	22372
22784	Orthrosanthus	22373
22784	Sparaxis	22374
22785	Canna	22375
22787	Acianthus	22376
22787	Caleana	22377
22787	Chiloglottis	22378
22793	Adenanthos	22379
22793	Franklandia	22380
22793	Isopogon	22381
22793	Petrophile	22382
22793	Strangea	22383
22794	Anthobolus	22384
22794	Leptomeria	22385
22795	Cansjera	22386
22797	Amyema	22387
22797	Dendrophthoe	22388
22794	Korthalsella	22389
22801	Antigonon	22390
22801	Fallopia	22391
22805	Cypselocarpus	22392
22805	Walteranthus	22393
22807	Disphyma	22394
22807	Gunniopsis	22395
22807	Micropterum	22396
22807	Sesuvium	22397
22807	Trianthema	22398
22808	Mollugo	22399
48329	Montia	22400
23244	Anredera	22401
22810	Corrigiola	22402
22810	Illecebrum	22403
22810	Moenchia	22404
22823	Cardaria	22405
22823	Crambe	22406
22823	Diplotaxis	22407
22823	Heliophila	22408
22823	Lepidium	22409
22823	Menkea	22410
22823	Nasturtium	22411
22823	Raphanus	22412
22823	Sinapis	22413
22823	Stenopetalum	22414
22825	Tristicha	22415
22827	Aeonium	22416
22827	Kalanchoe	22417
22830	Bentleya	22418
22830	Cheiranthera	22419
22830	Pronaya	22420
34857	Canavalia	22421
34857	Chorizema	22422
34857	Clianthus	22423
34857	Cryptosema	22424
34857	Desmodium	22426
34857	Dipogon	22427
34857	Dunbaria	22428
34857	Erythrina	22429
34857	Flemingia	22430
34857	Gastrolobium	22431
34857	Glycyrrhiza	22432
34857	Hardenbergia	22433
34857	Indigastrum	22434
34857	Ulex	22435
34857	Urodon	22436
34857	Vigna	22437
34857	Zornia	22438
22839	Geranium	22439
22841	Tropaeolum	22440
22844	Kallstroemia	22441
22844	Zygophyllum	22442
22845	Coleonema	22443
22845	Diplolaena	22444
22845	Euodia	22445
22845	Geleznowia	22446
22845	Micromelum	22447
22845	Nematolepis	22448
22845	Philotheca	22449
22846	Ailanthus	22450
22851	Ricinus	22451
22851	Sebastiania	22452
22853	Buchanania	22453
22854	Ilex	22454
22855	Cassine	22455
22855	Denhamia	22456
22855	Salacia	22457
22855	Stackhousia	22458
22858	Atalaya	22459
22858	Cupaniopsis	22460
22858	Ganophyllum	22461
22859	Alphitonia	22462
22859	Cryptandra	22463
22862	Melochia	22464
22862	Sterculia	22465
22865	Hibbertia	22466
35075	Hypericum	22467
22868	Frankenia	22468
22870	Hybanthus	22469
22871	Adenia	22470
22873	Pimelea	22471
22873	Wikstroemia	22472
22874	Nesaea	22473
22874	Rotala	22474
22876	Barringtonia	22475
22877	Ceriops	22476
22878	Lumnitzera	22477
22879	Agonis	22478
22879	Astartea	22479
22882	Haloragodendron	22480
22883	Astrotricha	22481
22884	Berula	22482
22884	Centella	22483
22884	Cyclospermum	22484
22924	Genus	22485
22883	Hydrocotyle	22486
22884	Pastinaca	22487
22884	Schoenolaena	22488
23412	Acrotriche	22489
23412	Brachyloma	22490
23412	Consostephium	22491
23412	Leucopogon	22492
22895	Brachystelma	22493
22895	Cynanchum	22494
22895	Gymnema	22495
22895	Leichardtia	22496
22895	Oxystelma	22497
22895	Sarcostemma	22498
22897	Calystegia	22499
22897	Dichondra	22500
22897	Jacquemontia	22501
22897	Porana	22502
22897	Wilsonia	22503
22899	Navarretia	22504
22901	Wigandia	22505
22905	Microcorys	22506
22905	Plectranthus	22507
22905	Rosmarinus	22508
22905	Stachys	22509
22905	Westringia	22510
22906	Cestrum	22511
22906	Cyphanthera	22512
22906	Lycium	22513
22906	Nicandra	22514
22906	Salpichroa	22515
22915	Antirrhinum	22516
22911	Bellardia	22517
22915	Cymbalaria	22518
22907	Glycocystis	22519
22916	Aidia	22520
22916	Canthium	22521
22916	Gardenia	22522
22916	Hedyotis	22523
22916	Kohautia	22524
22916	Oldenlandia	22525
22916	Pomax	22526
22916	Randia	22527
22916	Sherardia	22528
22916	Tarenna	22529
22916	Timonius	22530
22926	Scabiosa	22531
22919	Cucumis	22532
22924	Bellida	22533
22924	Blennospora	22534
22924	Bracteantha	22535
22924	Carthamus	22536
22924	Centipeda	22537
22924	Ceratogyne	22538
22924	Chrysanthemoides	22539
22924	Chthonocephalus	22540
22924	Coreopsis	22541
22924	Cratystylis	22542
22924	Decazesia	22543
22924	Dielitzia	22544
22924	Leptorhynchos	22545
22924	Logfia	22546
22924	Microseris	22547
22924	Myriocephalus	22548
22924	Osteospermum	22549
22924	Pentzia	22550
22924	Pleurocarpaea	22551
22924	Pogonolepis	22552
22924	Pterocaulon	22553
22924	Reichardia	22554
22924	Schoenia	22555
22881	Gaura	22556
22791	Morus	22557
22924	Chrysocoma	22558
22749	Sagittaria	22559
22751	Thonandia	22560
22830	Marianthus	22561
22810	Arenaria	22562
22754	Alocasia	22563
22848	Azadirachta	22564
22757	Tremulina	22565
22757	Chordifex	22566
22757	Tyrbastes	22567
22757	Platychorda	22568
22757	Melanostachya	22569
22757	Cytogonidium	22570
22884	Coriandrum	22571
22757	Stenopa	22572
22801	Acetosa	22573
22751	Pentapogon	22574
22801	Acetosella	22575
22738	Sequoia	22576
22757	Catacolea	22577
22807	Dorotheanthus	22578
22757	Dielsia	22579
22757	Kulinia	22580
22757	Apodasmia	22581
22753	Washingtonia	22582
22908	Tecoma	22583
22885	Gen.Nov.[Aff.Melichrus]	22584
22751	Austrodanthonia	22585
22729	Cyrtomium	22586
22779	Nerine	22587
23201	Xanthoparmelia	22588
23201	Paraparmelia	22589
23201	Neofuscelia	22590
23200	Degelia	22591
23238	Usnea	22592
23201	Canoparmelia	22593
22807	Aptenia	22594
23410	Cannabis	22595
22823	Hornungia	22596
22916	Psydrax	22597
22862	Abelmoschus	22598
22931	Pontederia	22599
23085	Sphagnum	22600
23253	Amanita	22601
23412	Erica	22602
22772	Aloe	22603
22906	Petunia	22604
22897	Jaquemontia	22605
23410	Humulus	22606
22883	Hedera	22607
22881	Fuchsia	22608
22834	Eriobotrya	22609
22817	Cinnamomum	22610
22851	Chamaesyce	22611
22924	Ageratina	22612
22924	Dimorphotheca	22613
22834	Cotoneaster	22614
22804	Mirabilis	22615
23414	Populus	22616
23415	Platanus	22617
22895	Thevetia	22618
22803	Guilleminea	22619
22884	Petroselinum	22620
22895	Nerium	22621
22845	Luvunga	22622
22767	Furcraea	22623
22757	Stenotalis	22624
23412	Pseudactinia	22625
22834	Pyrus	22626
23418	Georgeantha	22627
22884	Brachyscias	22628
22919	Muellerargia	22629
22924	Lagenophora	22630
22751	Symplectrodia	22631
23412	Gen.Nov.(Aff.Melichrus)	22632
22787	Liparis	22633
23069	Pleurophascum	22634
52241	Rhacocarpus	22635
22924	Cyanthillium	22636
22879	Lithomyrtus	22637
22791	Trophis	22638
22907	Nemesia	22639
22924	Grindelia	22640
22802	Scleroblitum	22641
22924	Leiocarpa	22642
22752	Abildgaardia	22643
22905	Gmelina	22644
22860	Parthenocissus	22645
34857	Willdampia	22646
22827	Bryophyllum	22647
22905	Brachysola	22648
23427	Impatiens	22649
22879	Aluta	22650
22787	Disa	22651
22908	Campsis	22652
22823	Arabidopsis	22653
23428	Moringa	22654
22830	Auranticarpa	22655
22787	Oligochaetochilus	22656
22787	Plumatichilos	22657
22924	Symphyotrichum	22658
22745	Nanozostera	22659
34857	Lessertia	22660
34857	Adenocarpus	22661
22924	Oligocarpus	22662
22924	Tripteris	22663
22879	Enekbatus	22664
34857	Cristonia	22665
34857	Thinicola	22666
34857	Astragalus	22667
22924	Xerochrysum	22668
22751	Lachnagrostis	22669
22815	Meiogyne	22670
23430	Sphenoclea	22671
22884	Anthriscus	22672
23414	Salix	22673
22879	Taxandria	22674
22879	Paragonis	22675
22784	Lapeirousia	22676
22924	Synedrella	22677
23037	Fabronia	22678
23035	Erpodium	22679
23071	Barbula	22680
23004	Drepanocladus	22681
23071	Calymperastrum	22682
23204	Pertusaria	22683
22752	Ficinia	22684
22807	Delosperma	22685
22895	Orbea	22686
22787	Glycorchis	22687
22787	Arthrochilus	22688
22872	Cylindropuntia	22689
22751	Pheidochloa	22690
22924	Pilbara	22691
22872	Austrocylindropuntia	22692
22751	Hygrochloa	22693
22752	Rhyncospora	22694
37060	Portulacaria	22695
22807	Cleretum	22696
22879	Cyathostemon	22697
22879	Anticoryne	22698
22924	Coleocoma	22699
22924	Camptacra	22700
22825	Malaccotristicha	22701
22787	Pheladenia	22702
22879	Astus	22703
22924	Pembertonia	22704
22751	Megathyrsus	22705
23412	Lissanthe	22706
22883	Tetrapanax	22707
22924	Oncosiphon	22708
22751	Phyllostachys	22709
22787	Ericksonella	22710
22787	X Cyanthera	22711
22751	Thedachloa	22712
23442	Musa	22713
34857	Biserrula	22714
22924	Hullsia	23457
48328	Anacampseros	23485
22855	Elaeodendron	23497
22787	Hydrorchis	23983
22919	Cucurbita	25824
22924	Amblysperma	25841
26041	Acanthophora	26049
25992	Acrocarpia	26050
26015	Acrosorium	26051
26001	Acrosymphyton	26052
26008	Acrothamnion	26053
26020	Actinotrichia	26054
26032	Adelophycus	26055
48171	Aglaothamnion	26056
26041	Alleynea	26057
26041	Amansia	26058
26008	Amoenothamnion	26059
50572	Amphiplexia	26060
49229	Amphiroa	26061
25954	Anadyomene	26062
26008	Anisoschizus	26063
45076	Anotrichium	26064
26008	Antithamnion	26065
26008	Antithamnionella	26066
50572	Antrocentrum	26067
25967	Apjohnia	26068
26015	Apoglossum	26069
26003	Areschougia	26070
26006	Asparagopsis	26071
25978	Asperococcus	26072
46994	Asteromenia	26073
26000	Audouinella	26074
26003	Austroclonium	26075
25998	Austronereia	26076
48132	Avrainvillea	26077
26004	Ballia	26078
26008	Balliella	26079
26005	Bangia	26080
48271	Betaphycus	26081
25957	Blastophysa	26082
25963	Blidingia	26083
25967	Boergesenia	26084
44521	Boodlea	26085
25960	Bornetella	26086
45076	Bornetia	26087
26041	Bostrychia	26088
26042	Botryocladia	26089
26015	Botryoglossum	26090
26041	Brongniartella	26091
25955	Bryopsis	26092
26013	Calliblepharis	26093
25968	Callipsygma	26094
48171	Callithamnion	26095
49719	Callophycus	26096
26027	Callophyllis	26097
26015	Caloglossa	26098
25974	Calothrix	26099
25998	Carpomitra	26100
26025	Carpopeltis	26101
48171	Carpothamnion	26102
26007	Catenella	26103
26007	Caulacanthus	26104
25956	Caulerpa	26105
25992	Caulocystis	26106
26008	Centroceras	26107
26008	Ceramium	26108
26029	Ceratodictyon	26109
25958	Chaetomorpha	26110
26042	Chamaebotrys	26111
26041	Chamaethamnion	26112
26009	Champia	26113
26015	Chauviniella	26114
26011	Cheilosporum	26115
26041	Chiracanthia	26116
25968	Chlorodesmis	26117
26041	Chondria	26118
26041	Chondrophycus	26119
44734	Choreonema	26120
26042	Chrysymenia	26121
26027	Cirrulicarpus	26122
25958	Cladophora	26123
44521	Cladophoropsis	26124
25978	Cladosiphon	26125
25979	Cladostephus	26126
26041	Cladurus	26127
26015	Claudea	26128
50572	Claviclonium	26129
26041	Cliftonaea	26130
26025	Codiophyllum	26131
25959	Codium	26132
26042	Coelarthrum	26133
26041	Coeloclonium	26134
26009	Coelothrix	26135
26014	Colacodasya	26136
25994	Colpomenia	26137
26010	Compsopogon	26138
26008	Corallophila	26139
26025	Corynomorpha	26140
25978	Corynophlaea	26141
26045	Cottoniella	26142
26013	Craspedocarpus	26143
26015	Crassilingua	26144
48171	Crouania	26145
26025	Cryptonemia	26146
26024	Curdiea	26147
25981	Cutleria	26148
26028	Cylindraxis	26149
25992	Cystophora	26150
25992	Cystoseira	26151
26014	Dasya	26152
25960	Dasycladus	26153
26041	Dasyclonium	26154
26008	Dasyphila	26155
26008	Dasythamniella	26156
26006	Delisea	26157
26016	Dicranema	26158
26015	Dicroglossum	26159
26041	Dictyomenia	26160
25983	Dictyopteris	26161
49708	Dictyosphaeria	26162
25983	Dictyota	26163
26041	Digenea	26164
25983	Dilophus	26165
45076	Diplothamnion	26166
26041	Dipterosiphonia	26167
25983	Distromium	26168
26041	Ditria	26169
26028	Dotyophycus	26170
26041	Doxodasya	26171
26008	Drewiana	26172
26017	Dudresnaya	26173
26041	Echinophycus	26174
26041	Echinosporangium	26175
26041	Echinothamnion	26176
48912	Ecklonia	26177
25984	Ectocarpus	26178
25978	Elachista	26179
26008	Elisiella	26180
25998	Encyothalia	26181
26041	Endosiphonia	26182
25970	Enteromorpha	26183
26041	Epiglossum	26184
26025	Epiphloea	26185
26008	Episporium	26186
26018	Erythrocladia	26187
26003	Erythroclonium	26188
26041	Erythrostachys	26189
26018	Erythrotrichia	26190
46994	Erythrymenia	26191
48271	Eucheuma	26192
48171	Euptilocladia	26193
48171	Euptilota	26194
26041	Exophyllum	26195
46995	Feldmannia	26196
26020	Galaxaura	26197
26028	Ganonema	26198
26008	Gattya	26199
45967	Gayralia	26200
26022	Gelidiella	26201
26029	Gelidiopsis	26202
26021	Gelidium	26203
26025	Gelinaria	26204
26017	Gibsmithia	26205
26023	Gigartina	26206
25978	Giraudia	26207
26027	Glaphyrymenia	26208
26019	Gloiocladia	26209
48965	Gloiophloea	26210
26042	Gloiosaccion	26211
26028	Gloiotrichus	26212
25983	Glossophora	26213
26024	Gracilaria	26214
26025	Grateloupia	26215
45076	Griffithsia	26216
45076	Guiryella	26217
26008	Gulsonia	26218
26015	Halicnide	26219
25962	Halimeda	26220
45076	Haloplegma	26221
25999	Halopteris	26222
26041	Halydictyon	26223
26025	Halymenia	26224
48499	Hapalospongidion	26225
26041	Haplodasya	26226
26015	Haraldiophyllum	26227
26028	Helminthocladia	26228
26028	Helminthora	26229
26015	Hemineura	26230
26002	Hennedya	26231
26041	Herposiphonia	26232
26041	Herposiphoniella	26233
26041	Heterocladia	26234
26015	Heterodoxia	26235
26014	Heterosiphonia	26236
26041	Heterostroma	26237
26008	Heterothamnion	26238
46995	Hincksia	26239
48171	Hirsutithallia	26240
26039	Holmsella	26241
26041	Holotrichia	26242
25992	Hormophysa	26243
25987	Hormosira	26244
26041	Husseya	26245
25994	Hydroclathrus	26246
48966	Hydrolithon	26247
26015	Hymenena	26248
46994	Hymenocladia	26249
26013	Hypnea	26250
26013	Hypneocolax	26251
26015	Hypoglossum	26252
26008	Involucrana	26253
26027	Kallymenia	26254
26041	Kentrophora	26255
26017	Kraftia	26256
26041	Kuetzingia	26257
26008	Lasiothalia	26258
26041	Laurencia	26259
26008	Lejolisia	26260
26041	Lenormandia	26261
26019	Leptofauchea	26262
26042	Leptosomia	26263
26011	Lesueuria	26264
26041	Leveillea	26265
26028	Liagora	26266
49229	Lithophyllum	26267
44734	Lithothamnion	26268
25983	Lobophora	26269
25983	Lobospira	26270
26008	Lomathamnion	26271
26029	Lomentaria	26272
26041	Lophocladia	26273
26041	Lophosiphonia	26274
26008	Macrothamnion	26275
26045	Malaconema	26276
26015	Martensia	26277
48970	Mastophora	26278
45076	Mazoyerella	26279
26008	Medeiothamnion	26280
44734	Melobesia	26281
48271	Meristotheca	26282
44734	Mesophyllum	26283
49236	Metagoniolithon	26284
48970	Metamastophora	26285
49895	Microcoleus	26286
25954	Microdictyon	26287
26041	Micropeuce	26288
45076	Monosporus	26289
26030	Mychodea	26290
26031	Mychodeophyllum	26291
25992	Myriodesma	26292
25978	Myriogloea	26293
26015	Myriogramme	26294
26041	Nanopera	26295
25978	Nemacystus	26296
48977	Neogoniolithon	26297
25960	Neomeris	26298
26041	Neurymenia	26299
26015	Nitophyllum	26300
26033	Nizymenia	26301
25989	Notheia	26302
26041	Ophidocladus	26303
26041	Osmundaria	26304
25964	Ostreobium	26305
25983	Pachydictyon	26306
26025	Pachymenia	26307
25983	Padina	26308
25978	Papenfussiella	26309
25961	Pedobesia	26310
25968	Penicillus	26311
26008	Perischelia	26312
25998	Perithalia	26313
26008	Perithamnion	26314
25994	Petalonia	26315
26034	Peyssonnelia	26316
26035	Phacelocarpus	26317
25965	Phaeophila	26318
26015	Phitymophora	26319
25999	Phloiocaulon	26320
26015	Phycodrys	26321
44521	Phyllodictyon	26322
44734	Phymatolithon	26323
26041	Placophora	26324
26046	Platoma	26325
26045	Platysiphonia	26326
25992	Platythalia	26327
26008	Pleonosporium	26328
26036	Plocamium	26329
26011	Pneophyllum	26330
26041	Pollexfenia	26331
25978	Polycerea	26332
26027	Polycoelia	26333
26025	Polyopes	26334
26041	Polysiphonia	26335
26041	Polyzonia	26336
26005	Porphyra	26337
26018	Porphyropsis	26338
26040	Portieria	26339
26032	Predaea	26340
26041	Protokuetzingia	26341
25955	Pseudobryopsis	26342
47013	Pseudocodium	26343
26008	Psilothalia	26344
49352	Pterocladia	26345
49352	Pterocladiella	26346
26041	Pterosiphonia	26347
26008	Pterothamnion	26348
48171	Ptilocladia	26349
26006	Ptilonia	26350
26021	Ptilophora	26351
26008	Ptilothamnion	26352
25991	Ralfsia	26353
26003	Rhabdonia	26354
25954	Rhipidiphyllon	26355
25968	Rhipidosiphon	26356
25962	Rhipiliopsis	26357
25958	Rhizoclonium	26358
26008	Rhodocallis	26359
26023	Rhodoglossum	26360
26041	Rhodomela	26361
26017	Rhodopeltis	26362
26013	Rhodophyllis	26363
26042	Rhodymenia	26364
25994	Rosenvingea	26365
26018	Sahlingia	26366
26044	Sarcodia	26367
26045	Sarcomenia	26368
48271	Sarconema	26369
26045	Sarcotrichia	26370
25992	Sargassum	26371
25992	Scaberia	26372
26008	Scageliopsis	26373
25975	Schizothrix	26374
26046	Schizymenia	26375
48965	Scinaia	26376
25983	Scoresbyella	26377
25994	Scytosiphon	26378
25995	Scytothalia	26379
26047	Sebdenia	26380
48171	Seirospora	26381
26029	Semnocarpa	26382
26008	Shepleya	26383
25967	Siphonocladus	26384
48271	Solieria	26385
25983	Spatoglossum	26386
26008	Spencerella	26387
25978	Spermatochnus	26388
26008	Spermothamnion	26389
25997	Sphacelaria	26390
26042	Sphaerococcus	26391
26041	Spirocladia	26392
48977	Spongites	26393
44521	Spongocladia	26394
45076	Spongoclonium	26395
25998	Sporochnus	26396
26048	Sporolithon	26397
49541	Spyridia	26398
26013	Stictosporum	26399
25978	Stictyosiphon	26400
25978	Stilopsis	26401
25983	Stoechospermum	26402
44521	Struvea	26403
48959	Stylonema	26404
25983	Stypopodium	26405
25978	Suringariella	26406
26041	Symphyocladia	26407
44734	Synarthrophyton	26408
26015	Taenioma	26409
45076	Tanakaella	26410
26025	Thamnoclonium	26411
26027	Thamnophyllis	26412
26014	Thuretia	26413
45076	Tiffaniella	26414
26041	Tiparraria	26415
26046	Titanophora	26416
26041	Tolypiocladia	26417
26041	Trichidium	26418
49895	Trichodesmium	26419
26028	Trichogloea	26420
26020	Tricleocarpa	26421
26008	Trithamnion	26422
25992	Turbinaria	26423
26016	Tylotus	26424
25968	Udotea	26425
25969	Ulothrix	26426
25970	Ulva	26427
45955	Uronema	26428
25972	Valonia	26429
49708	Valoniopsis	26430
26041	Veleroa	26431
25967	Ventricaria	26432
26041	Vidalia	26433
26019	Webervanbossea	26434
26041	Wilsonaea	26435
26008	Wollastoniella	26436
45076	Wrangelia	26437
49175	Yamadaella	26438
25983	Zonaria	26439
23431	Acarospora	27420
23208	Amandinea	27421
23184	Anema	27422
23193	Anisomeridium	27423
23432	Arthonia	27424
23146	Arthopyrenia	27425
23432	Arthothelium	27426
23189	Aspicilia	27427
23208	Australiaena	27428
23215	Bacidia	27429
23215	Biatora	27430
23397	Biatoropsis	27431
23208	Buellia	27432
23154	Calicium	27433
23230	Caloplaca	27434
23155	Candelaria	27435
23155	Candelariella	27436
23201	Canomaculina	27437
23156	Catillaria	27438
23215	Catinaria	27439
23201	Cetraria	27440
23165	Chaenotheca	27441
23195	Chaenothecopsis	27442
23201	Chondropsis	27443
39920	Chrysothrix	27444
23160	Cladia	27445
23160	Cladinia	27446
23160	Cladonia	27447
23179	Clauzadeana	27448
23162	Coccocarpia	27449
23172	Coenogonium	27450
23164	Collema	27451
23154	Cyphelium	27452
23208	Dimelaena	27453
23172	Dimerella	27454
23208	Diploicia	27455
23171	Diploschistes	27456
23208	Diplotomma	27457
23208	Dirinaria	27458
23193	Ditremis	27459
23171	Dyplolabia	27460
23239	Endocarpon	27461
23184	Ephebe	27462
23201	Flavoparmelia	27463
23230	Fulgensia	27464
23174	Gloeoheppia	27465
23171	Graphina	27466
23171	Graphis	27467
23160	Gymnoderma	27468
23179	Haematomma	27469
23208	Hafellia	27470
23174	Heppia	27471
23160	Heterodea	27472
23208	Heterodermia	27473
23208	Hyperphyscia	27474
34466	Hypocenomyce	27475
23201	Hypogymnia	27476
23201	Hypotrachyna	27477
23201	Imshaugia	27478
23239	Lauderlindsaya	27479
23178	Lecanactis	27480
23215	Lecania	27481
23179	Lecanora	27482
23180	Lecidea	27483
23179	Lecidella	27484
23227	Lepraria	27485
51790	Leprocaulon	27486
23200	Leproloma	27487
23164	Leptogium	27488
23146	Leptorhaphis	27489
23182	Letrouitia	27490
23432	Lichenostigma	27491
23183	Lichenothelia	27492
23184	Lichina	27493
23186	Lobaria	27494
23176	Lobothallia	27495
23215	Megalaria	27496
23189	Megalospora	27497
23201	Menegazzia	27498
23209	Micarea	27499
23192	Microcalicium	27500
23195	Mycocalicium	27501
23196	Mycoporum	27502
23224	Neophyllis	27503
23239	Normandina	27504
44515	Ochrolechia	27505
23234	Omphalina	27506
23200	Pannaria	27507
23201	Pannoparmelia	27508
23211	Paraporpidia	27509
23201	Parmelia	27510
23200	Parmeliella	27511
23201	Parmelina	27512
23201	Parmelinopsis	27513
23201	Parmeliopsis	27514
23213	Parmentaria	27515
23201	Parmotrema	27516
23184	Paulia	27517
23184	Peccania	27518
23202	Peltigera	27519
23203	Peltula	27520
23179	Phacopsis	27521
23171	Phaeographis	27522
23208	Phaeophyscia	27523
23184	Phloeopeccania	27524
23208	Physcia	27525
23208	Physconia	27526
23239	Placidium	27527
23232	Placopsis	27528
23210	Placynthium	27529
23431	Polysporina	27530
47075	Porina	27531
23184	Poroscyphus	27532
23211	Porpidia	27533
23201	Protoparmelia	27534
23186	Pseudocyphellaria	27535
23212	Psora	27536
23200	Psoroma	27537
23184	Pterygiopsis	27538
23201	Punctelia	27539
23184	Pyrenopsis	27540
23213	Pyrenula	27541
23179	Pyrrhospora	27542
23208	Pyxine	27543
23160	Ramalea	27544
23215	Ramalina	27545
23179	Ramboldia	27546
23201	Relicinopsis	27547
23216	Rhizocarpon	27548
23201	Rimelia	27549
23232	Rimularia	27550
23208	Rinodina	27551
23208	Rinodinella	27552
23218	Roccella	27553
23431	Sarcogyne	27554
23221	Schaereria	27555
47076	Siphula	27556
23156	Solenopsora	27557
23225	Sphinctrina	27558
23162	Spilonema	27559
23227	Stereocaulon	27560
23230	Teloschistes	27561
23441	Tephromela	27562
23171	Thelotrema	27563
23160	Thysanothecium	27564
23215	Toninia	27565
23232	Trapelia	27566
23232	Trapeliopsis	27567
27419	Tremolechia	27568
23236	Trypethelium	27569
23237	Umbilicaria	27570
23239	Verrucaria	27571
23230	Xanthoria	27572
23201	Melanelia	28328
22754	Landoltia	28341
22879	Asteromyrtus	28352
22887	Myrsine	28360
22924	Acmella	29049
22787	Zeuxine	29059
22916	Coprosma	29282
22787	Corunastylis	29360
23156	Halecania	29382
23201	Pseudephebe	29384
23167	Dictyonema	29392
23227	Hertelidea	29395
22924	Monoculus	29417
34857	Vachellia	29523
22924	Laphangium	29595
26028	Titanophycus	29600
26020	Dichotomaria	29614
22879	Tetrapora	29719
22784	Dietes	29831
22902	Glandularia	29835
22859	Polianthion	29916
26008	Psilothallia	29932
23171	Platygramme	30172
22924	Rhaponticum	30291
26003	Erythrodonium	30296
26041	Aneurianna	30311
23160	Notocladonia	30456
22730	Doodia	30553
22924	Rhetinocarpha	30571
30671	Warnstorfia	30672
22751	Leersia	30720
23396	Torrendia	30802
23209	Psilolechia	30805
22888	Psylliostachys	31081
22888	Statice	31083
48329	Neopaxia	31085
22889	Sersalisia	31171
22924	Mauranthemum	31236
22897	Duperreya	31273
23234	Lichenomphalia	31279
22851	Microstachys	31373
22915	Asarina	31377
22915	Maurandya	31379
22859	Serichonus	31574
22859	Papistylus	31576
22814	Pleogyne	31691
22762	Tradescantia	31693
22930	Ligustrum	31893
22848	Khaya	32096
23071	Acaulon	32237
23071	Aloina	32238
30431	Amphidium	32239
23007	Archidium	32240
23009	Bartramia	32241
23010	Brachythecium	32242
23009	Breutelia	32243
31651	Bruchia	32244
23071	Bryoerythrophyllum	32245
23011	Bryum	32246
23017	Calymperes	32247
23025	Campylopus	32248
23028	Ceratodon	32249
23071	Crossidium	32250
23025	Dicranoloma	32251
23071	Didymodon	32252
23028	Ditrichum	32253
23028	Eccremidium	32254
23040	Entosthodon	32255
23033	Ephemerum	32256
23038	Fissidens	32257
23040	Funaria	32258
23011	Gemmabryum	32259
23041	Gigaspermum	32260
23040	Goniomitrium	32261
23042	Grimmia	32262
23071	Gymnostomum	32263
23043	Hedwigia	32264
23043	Hedwigidium	32265
23071	Hyophila	32266
23047	Hypnum	32267
23050	Hypopteryigium	32268
23037	Ischyrodon	32269
23047	Isopterygium	32270
23058	Leptobryum	32271
23071	Leptodontium	32272
23055	Leucobryum	32273
23065	Macromitrium	32274
23071	Microbryum	32275
23011	Ochiobryum	32276
50433	Octoblepharum	32277
32051	Orthodontium	32278
23071	Phascopsis	32279
23009	Philonotis	32280
23011	Plagiobryum	32281
23028	Pleuridium	32282
23071	Pottia	32283
23075	Ptychomitrium	32284
23011	Ptychostomum	32285
23042	Racomitrium	32286
23077	Racopilum	32287
23083	Rhaphidorrhynchium	32288
23010	Rhynchostegium	32289
23011	Rosulabryum	32290
32052	Sauloma	32291
23042	Schistidium	32292
23061	Schizymenium	32293
23083	Sematophyllum	32294
23071	Syntrichia	32295
23087	Tayloria	32296
23071	Tetrapterum	32297
23091	Thuidium	32298
23071	Tortella	32299
23071	Tortula	32300
23032	Trachyphyllum	32301
31651	Trematodon	32302
23071	Trichostomum	32303
23071	Triquetrella	32304
23047	Vesicularia	32305
23071	Weissia	32306
23065	Zygodon	32307
23179	Maronina	32977
22919	Austrobryonia	33029
23171	Hemithecium	33032
22879	Backhousia	33078
22872	Hylocereus	33103
22751	Molineriella	33116
22751	Corynephorus	33436
34857	Peltophorum	33458
22879	Seorsus	33576
22882	Meionectes	33637
22879	Cheyniana	34808
22879	Oxymyrrhine	34839
22882	Trihaloragis	34962
22924	Peripleura	34996
25966	Parvocaulis	35118
26028	Patenocarpus	35119
25968	Boodleopsis	35127
22751	Walwhalleya	35199
25983	Canistrocarpus	35219
25983	Rugulopteryx	35221
25962	Rhipilia	35298
26041	Acrocystis	35867
26024	Hydropuntia	35870
26015	Vanvoorstia	35903
26015	Zellera	35914
36198	Corynocystis	35918
23071	Pseudocrossidium	36136
49918	Brachytrichia	36144
22894	Liparophyllum	36159
22894	Ornduffia	36176
25994	Chnoospora	36196
26041	Palisada	36258
49897	Lyngbya	36260
25998	Bellotia	36263
26023	Chondracanthus	36280
34857	Mimosa	36336
26015	Platyclinia	36359
36740	Colaconema	36363
36365	Pihiella	36366
22887	Lysimachia	36372
26003	Tikvahiella	36396
22879	Babingtonia	36440
22879	Harmogia	36444
22924	Pycnosorus	37200
26041	Periphykon	38140
23412	Dielsiodoxa	38220
22897	Davenportia	38300
22924	Cosmos	38382
22924	Zinnia	38385
34858	Notoleptopus	38420
22924	Sphagneticola	38440
22751	Anthosachne	38500
23335	Abortiporus	38651
23250	Agaricus	38652
38642	Anthracophyllum	38653
23311	Arachnopeziza	38654
23375	Arcangeliella	38655
23259	Auricularia	38656
23260	Auriscalpium	38657
44577	Auritella	38658
44927	Austropaxillus	38659
23250	Battarrea	38660
23352	Bisporella	38661
23263	Bolbitius	38662
23264	Boletus	38663
38642	Campanella	38664
23336	Castoreum	38665
23250	Chlorophyllum	38666
23273	Clavaria	38667
23277	Clavulina	38668
23234	Clitocybe	38669
23315	Coltriciella	38670
23263	Conocybe	38671
38644	Coprinellus	38672
38644	Coprinus	38673
23283	Cortinarius	38674
38646	Craterellus	38675
23318	Creopus	38676
23285	Crepidotus	38677
23289	Dacryopinax	38678
23250	Dendromyces	38679
23283	Dermocybe	38680
23263	Descomyces	38681
23297	Entoloma	38682
23304	Geastrum	38683
38647	Glomus	38684
23391	Gymnopilus	38685
23279	Gyrodontium	38686
23283	Hebeloma	38687
44727	Hjortstamia	38688
44789	Hohenbuehelia	38689
23312	Hydnum	38690
23314	Hygrocybe	38691
23316	Hymenogaster	38692
23391	Hypholoma	38693
44577	Inocybe	38694
38649	Labyrinthomyces	38695
23313	Laccaria	38696
23364	Laccocephalum	38697
23311	Lachnum	38698
23375	Lactarius	38699
23260	Lentinellus	38700
23364	Lentinus	38701
23250	Lepiota	38702
23297	Leptonia	38703
23234	Leucopaxillus	38704
23253	Limacella	38705
38642	Marasmius	38706
23289	Merulius	38707
23336	Mesophellia	38708
44814	Mycena	38709
23336	Nothocastoreum	38710
23234	Omphalia	38711
38642	Omphalotus	38712
38644	Panaeolus	38713
44814	Panellus	38714
23352	Peziza	38715
23354	Phallus	38716
23391	Pholiota	38717
23357	Phyllachora	38718
23264	Phylloporus	38719
23285	Pleuroflammula	38720
44789	Pleurotus	38721
23362	Pluteus	38722
38646	Podoserpula	38723
23364	Polyporus	38724
46153	Protubera	38725
38644	Psathyra	38726
38644	Psathyrella	38727
23391	Psilocybe	38728
23366	Puccinia	38729
23234	Resupinatus	38730
23373	Rhizopogon	38731
23364	Royoporus	38732
23375	Russula	38733
38648	Schizopora	38734
23250	Secotium	38735
23409	Sphaeria	38736
23373	Splanchnomyces	38737
38649	Stephensia	38738
23389	Stereum	38739
46154	Suillus	38740
46155	Tapinella	38741
23394	Thelephora	38742
23364	Trametes	38743
44576	Trechispora	38744
46156	Tubaria	38745
23366	Uredo	38746
23234	Xerotus	38747
38643	Xerula	38748
23375	Zelleromyces	38749
38925	Arcyria	38928
38922	Badhamia	38929
38926	Calomyxa	38930
38923	Ceratiomyxa	38931
38916	Clastoderma	38932
38924	Collaria	38933
38924	Colloderma	38934
38924	Comatricha	38935
38922	Craterium	38936
38918	Cribraria	38937
38921	Diachea	38938
38926	Dianema	38939
38921	Diderma	38940
38921	Didymium	38941
38917	Echinostelium	38942
38924	Enerthenema	38943
38922	Fuligo	38944
38927	Hemitrichia	38945
38924	Lamproderma	38946
38922	Leocarpus	38947
38919	Licea	38948
38920	Lycogala	38949
38924	Macbrideola	38950
38927	Metatrichia	38951
38927	Oligonema	38952
38924	Paradiachea	38953
38924	Paradiacheopsis	38954
38927	Perichaena	38955
38922	Physarum	38956
38920	Reticularia	38957
38924	Stemonitis	38958
38924	Stemonitopsis	38959
38927	Trichia	38960
38920	Tubifera	38961
38922	Willkommlangea	38962
22751	Rytidosperma	39580
34857	Paragoodia	39801
39882	Elaphomyces	39883
22751	Spathia	40081
22930	Fraxinus	40240
22924	Parthenium	40340
22751	Pentameris	40421
22794	Omphacomeria	40462
22748	Cycnogeton	40520
22858	Acer	40760
22862	Androcalva	40900
22905	Dasymalla	41021
22905	Quoya	41040
22738	Hesperocyparis	41141
23171	Halegrapha	41266
23218	Cresponea	41503
22924	Sphaeromorphaea	41622
22893	Schenkia	41645
22913	Barleria	41728
23412	Melichrus	41766
23283	Protoglossum	41827
23283	Quadrispora	41828
23263	Setchelliogaster	41829
23302	Ganoderma	41880
34857	Cajanus	41962
23201	Austroparmelina	42105
38924	Elaeomyxa	42227
25992	Sirophysalis	42784
22924	Blainvillea	42880
22924	Apowollastonia	43100
22891	Adelphacme	43200
22803	Surreya	43202
22793	Protea	43302
43304	Luteocirrhus	43305
34857	Cyclocarpa	43322
22790	Ulmus	43500
22767	Hyacinthoides	43501
34337	Phormium	43502
43552	Thalia	43503
22780	Pauridia	43740
43882	Carbonicola	43883
23232	Xylographa	43900
23213	Lithothelium	44001
23171	Ingvariella	44005
52073	Dictydiaethalium	44063
23171	Xalocoa	44200
25955	Trichosolen	44323
22801	Duma	44464
22741	Stuckenia	44491
23186	Crocodia	44518
26025	Spongophloea	44522
26028	Neoizziella	44524
22853	Anacardium	44541
22927	Lilium	44570
25992	Sargassopsis	44572
38924	Symphytocarpus	44591
44686	Hydrangea	44687
22874	Punica	44711
35338	Bonnaya	44715
23318	Hypocrea	44717
44720	Calceolaria	44721
44727	Porostereum	44728
26034	Sonderophycus	44730
38647	Funneliformis	44753
22767	Sansevieria	44774
34858	Synostemon	44785
22738	Cupressus	44793
22908	Spathodea	44795
23180	Bryobilimbia	44853
23201	Notoparmelia	44855
22779	Pancratium	44859
23201	Melanelixia	44913
22762	Callisia	44922
23354	Ileodictyon	44925
23239	Bagliettoa	44937
23180	Immersaria	44953
23179	Carbonea	44954
23208	Cratiria	44959
23208	Monerolechia	44961
23208	Baculifera	44976
23160	Cladina	44993
23369	Pyronema	45073
45076	Grallatoria	45077
23184	Porocyphus	45114
22924	Roebuckia	45133
22924	Roebuckiella	45134
22879	Ericomyrtus	45214
22807	Malephora	45294
23230	Jackelixia	45298
22879	Hysterobaeckea	45414
22924	Roldana	45433
45795	Cintractia	45796
45795	Moreaua	45799
45812	Eballistra	45813
45817	Entorrhiza	45818
45820	Jamesdicksonia	45821
45823	Yelsemia	45824
45829	Microbotryum	45830
23395	Tilletia	45834
45848	Urocystis	45849
23403	Macalpinomyces	45852
23403	Moesziomyces	45859
23403	Pericladium	45861
23403	Sporisorium	45863
23403	Tranzscheliella	45890
23403	Ustilago	45892
45911	Restiosporium	45912
45911	Websdanea	45918
45958	Neostromatella	45956
45963	Ulvella	45964
23231	Thelenella	45993
23431	Myriospora	46013
23264	Boletellus	46073
22730	Telmatoblechnum	46113
22924	Glebionis	46133
46213	Stephanospora	46214
22891	Orianthera	46216
22884	Carum	46233
23250	Leucoagaricus	46453
23375	Gymnomyces	46493
38644	Rhacophyllus	46553
46574	Ramaria	46575
23403	Anthracocystis	46613
23403	Langdonia	46614
23403	Triodiomyces	46615
23403	Stollia	46636
22924	Allopterigeron	46795
22862	Seringia	46813
22815	Monoon	47034
23176	Tremolecia	47133
22916	Gynochthodes	47243
22787	Spiranthes	48165
22784	Geissorhiza	48168
23412	Stenanthera	48192
22808	Trigastrotheca	48200
22808	Hypertelis	48202
35337	Thyridia	48211
35337	Uvedalia	48212
22924	Balladonia	48220
22924	Notisia	48225
25961	Derbesia	48260
48272	Neoralfsia	48273
22905	Mesosphaerum	48282
25992	Phyllotricha	48285
26022	Huismaniella	48299
48315	Quercus	48314
22751	Tripogonella	48318
34857	Colophospermum	48333
22749	Albidella	48343
25998	Nereia	48352
22752	Schoenoplectiella	48354
22751	Dinebra	48376
48403	Bachelotia	48404
23366	Uromyces	48406
26027	Austrokallymenia	48415
26027	Leiomenia	48418
26027	Stauromenia	48422
26027	Meredithia	48426
22901	Hackelia	48447
23071	Stonea	48473
44577	Tubariomyces	48557
26042	Halopeltis	48567
22924	Thymophylla	48570
23264	Gymnogaster	48604
22741	Althenia	48619
23201	Relicina	48637
22750	Limnobium	48639
34857	Desmanthus	48641
35338	Torenia	48662
22860	Causonis	48714
22767	Dracaena	48716
22751	Polytoca	48718
22897	Distimake	48734
22897	Camonea	48743
25997	Herpodiscus	48791
48798	Glonium	48799
23218	Dictyographa	48801
23179	Japewiella	48808
23218	Enterographa	48812
23441	Mycoblastus	48814
23209	Septotrapelia	48816
23204	Lepra	48818
23364	Pycnoporus	48831
23315	Coltricia	48839
23335	Flavodon	48844
23364	Coriolopsis	48847
48849	Laetiporus	48850
23364	Phaeotrametes	48852
23364	Macrohyporia	48854
23364	Favolus	48856
34857	Erythrostemon	48859
22862	Azanza	48863
26029	Fushitsunagia	48871
23352	Antrelloides	48873
22844	Roepera	48881
23200	Fuscopannaria	48918
25978	Giraudya	48967
23379	Pisolithus	48971
26024	Crassa	48978
22895	Vincetoxicum	48982
23250	Barcheria	48993
23250	Macrolepiota	49001
23336	Gummivena	49006
49024	Nandina	49025
22879	Syncarpia	49027
22924	Calyptocarpus	49029
26022	Millerella	49041
49043	Gyroporus	49044
38922	Physarella	49047
22775	Gloriosa	49049
22851	Micrococca	49051
23364	Truncospora	49065
23364	Earliella	49068
23364	Picipes	49070
49087	Chrysonephos	49086
26008	Ossiella	49099
23342	Stigmidium	49172
26028	Macrocarpus	49177
26028	Yoshizakia	49184
26028	Hommersandiophycus	49188
26028	Izziella	49194
49222	Rhodogorgon	49223
49229	Titanoderma	49232
49236	Porolithon	49237
22787	Phoringopsis	49248
44734	Rhizolamellia	49253
44734	Melyvonnea	49255
49236	Floiophycus	49257
49236	Oztralia	49259
49236	Dawsoniolithon	49263
22787	Pecteilis	49277
23255	Thecotheus	49287
49291	Ethelia	49292
26027	Rhytimenia	49295
26040	Contarinia	49297
26007	Pseudocaulacanthus	49300
26034	Incendia	49313
26034	Polystrata	49327
26034	Seiria	49330
26034	Ramicrusta	49332
23083	Brittonodoxa	49340
49355	Aphanta	49356
49361	Quambalaria	49362
26047	Cryptocallis	49378
26041	Bostrychiocolax	49396
26042	Campylosaccion	49409
22931	Heteranthera	49414
26008	Gayliella	49437
49445	Reticulocaulis	49446
26000	Acrochaetium	49484
44814	Favolaschia	49505
26041	Melanothamnus	49512
26041	Pentocladia	49526
26041	Womersleyella	49537
26041	Xiphosiphonia	49539
23352	Hydnoplicata	49542
45076	Desikacharyella	49547
44727	Pseudolagarobasidium	49567
38648	Hyphodontia	49579
38648	Xylodon	49581
22919	Sicyos	49587
22752	Anthelepis	49589
23234	Tricholoma	49596
23289	Calocera	49599
49603	Discinella	49602
23369	Pulvinula	49604
49603	Phaeohelotium	49610
23264	Austroboletus	49620
49627	Carica	49628
23369	Aleurina	49660
23218	Angiactis	49666
23234	Asproinocybe	49668
44727	Byssomerulius	49671
38924	Diacheopsis	49675
49355	Orthogonacladia	49684
23335	Phlebia	49689
49698	Palmophyllum	49697
49698	Palmoclathrus	49700
25958	Lychaete	49702
26041	Corynecladia	49706
46994	Perbella	49721
26019	Gloioderma	49723
25994	Pseudochnoospora	49728
26041	Vertebrata	49730
23215	Bibbya	49763
23215	Thalloidima	49766
49770	Schottera	49771
49779	Tsengia	49780
22721	Pellaea	49834
22715	Pseudolycopodiella	49838
22715	Palhinhaea	49840
22730	Blechnopsis	49842
23364	Hexagonia	49863
49867	Hydrocoryne	49866
49867	Nostoc	49868
25974	Dichothrix	49871
23391	Galerina	49873
25974	Rivularia	49875
49878	Dolichospermum	49879
48849	Postia	49881
23391	Agrocybe	49884
49878	Nodularia	49888
49609	Heteroscytonema	49890
49609	Scytonematopsis	49892
49895	Symploca	49894
49900	Coleofasciculus	49901
49903	Leptolyngbya	49904
49906	Microcystis	49907
49909	Myxohyella	49910
49912	Spirulina	49913
49915	Trichocoleus	49916
23255	Ascobolus	49919
23369	Anthracobia	49963
38643	Armillaria	49991
23260	Artomyces	49997
50002	Austrogautieria	50003
23321	Asterostroma	50005
22752	Chaetospora	50013
35224	Areocleome	50023
35224	Arivela	50025
23250	Bovista	50035
50040	Bondarzewia	50041
44727	Bjerkandera	50043
23369	Byssonectria	50068
23264	Buchwaldoboletus	50070
23266	Calostoma	50082
23250	Calvatia	50085
23250	Chlamydopus	50088
22870	Afrohybanthus	50091
22878	Combretum	50100
48271	Mimica	50102
22845	Cyanothamnus	50104
22916	Dolichocarpa	50128
22916	Paranotis	50132
22916	Scleromitrion	50137
23389	Aleurodiscus	50151
50155	Amphinema	50154
23409	Annulohypoxylon	50157
49603	Banksiamyces	50160
23299	Basidiodendron	50162
50167	Botryobasidium	50168
44727	Ceriporia	50172
23354	Clathrus	50175
23297	Clitopilus	50179
23354	Colus	50181
23279	Coniophora	50189
23250	Cyathus	50195
23315	Fomitiporia	50201
23289	Dacrymyces	50207
23282	Dendrothele	50209
23283	Descolea	50211
23321	Dichostereum	50213
23301	Fistulina	50216
38644	Coprinopsis	50218
38642	Gymnopus	50223
50225	Harknessia	50226
44814	Hemimycena	50229
38642	Henningsomyces	50234
23311	Hyaloscypha	50236
23313	Hydnangium	50238
23349	Hydnomerulius	50240
50242	Merismodes	50243
23381	Martininia	50245
23331	Melampsora	50247
23234	Melanoleuca	50249
23290	Mollisia	50253
23250	Mycenastrum	50259
23317	Hyphoderma	50268
23318	Hypomyces	50270
23409	Hypoxylon	50273
23282	Kurtia	50275
23322	Lasiosphaeria	50277
23250	Leucocoprinus	50284
50286	Leucogyrophana	50287
46213	Lindtneria	50288
44576	Litschauerella	50290
23328	Lycoperdon	50292
23354	Lysurus	50294
23364	Skeletocutis	50296
23387	Steccherinum	50298
23394	Tomentella	50303
23394	Tomentellopsis	50305
23387	Austeria	50309
50311	Aphanobasidium	50312
50315	Odonticium	50316
23250	Panaeolina	50318
51203	Panus	50321
38644	Parasola	50323
23350	Peniophora	50328
23364	Perenniporia	50331
26024	Crassiphycus	50335
44727	Phanerochaete	50350
50358	Phomopsis	50359
44727	Phlebiopsis	50361
44577	Pseudosperma	50366
44577	Mallocybe	50368
48849	Piptoporus	50374
50380	Propolis	50381
23394	Pseudotomentella	50384
23282	Punctularia	50386
38649	Reddellomyces	50388
50315	Resinicium	50390
48849	Rhodofomitopsis	50394
50315	Rickenella	50397
23378	Schizophyllum	50400
23379	Scleroderma	50402
23369	Scutellinia	50406
23350	Scytinostroma	50408
23318	Trichoderma	50410
23234	Tricholomopsis	50415
23315	Tubulicrinis	50418
23264	Tylopilus	50420
50922	Uromycladium	50422
23362	Volvopluteus	50424
50426	Xenasma	50427
22751	Oloptum	50439
22909	Sesamum	50447
22754	Arisarum	50449
22924	Panaetia	50458
22924	Siemssenia	50461
22924	Walshia	50464
34857	Desmodiopsis	50466
34857	Pleurolobus	50468
34857	Grona	50470
22926	Sixalix	50484
23352	Oedocephalum	50520
22752	Netrostylis	50531
25955	Pseudoderbesia	50533
22895	Leichhardtia	50539
22752	Ammothryon	50548
22752	Morelotia	50550
26002	Acrotylus	50570
22905	Lycopus	50573
50581	Didymocyrtis	50582
22752	Scleroschoenus	50585
50606	Pocheina	50607
22752	Machaerina	50615
23250	Melanophyllum	50626
23369	Sowerbyella	50629
50631	Rhodocollybia	50632
44814	Roridomyces	50634
23273	Clavulinopsis	50657
23267	Cantharellus	50660
23314	Humidicutis	50664
50666	Chondrostereum	50667
22878	Conocarpus	50674
22851	Tritaxis	50676
23091	Thuidiopsis	50680
22905	Apatelantha	50682
50711	Myxarium	50712
23375	Cystangium	50719
22879	Austrobaeckea	50751
22923	Coleostylis	50770
23375	Lactifluus	50775
50778	Superstratomyces	50779
23265	Tiarosporella	50799
50801	Davidiellomyces	50802
50804	Paraconiothyrium	50805
50807	Nothophoma	50808
50807	Verrucoconiothyrium	50810
23342	Zasmidium	50820
50823	Myrtacremonium	50824
50826	Parateratosphaeria	50827
50826	Myrtapenidiella	50829
50581	Banksiophoma	50834
50826	Readeriella	50836
23409	Rosellinia	50839
50804	Paraphaeosphaeria	50841
50843	Heterotruncatella	50844
50843	Distononappendiculata	50852
43304	Holocryphia	50855
50843	Sarcostroma	50857
23257	Blastacervulus	50861
50863	Bullanockia	50864
50866	Neoconiothyrium	50867
50869	Caliciopsis	50870
50872	Neocucurbitaria	50873
23290	Coleophoma	50875
23291	Diatrypella	50877
23296	Elsinoe	50879
22916	Mitracarpus	50886
50888	Apiognomonia	50889
50891	Pleurophoma	50892
23326	Sphaerellopsis	50894
23342	Mycodiella	50896
50898	Neocrinula	50899
50581	Phaeosphaeriopsis	50901
50903	Phlogicylindrium	50904
50906	Saccharata	50907
50916	Teichospora	50917
50920	Aplosporella	50919
23265	Dothiorella	50931
23265	Lasiodiplodia	50954
23265	Neofusicoccum	50956
23265	Neoscytalidium	50960
50962	Graphium	50963
50966	Sporothrix	50967
23351	Phytophthora	50969
25958	Willeella	50980
50988	Pestalotiopsis	50989
50994	Colletotrichum	50995
50826	Teratosphaeria	51001
23397	Tremella	51011
23250	Tulostoma	51018
22924	Leuzea	51035
50823	Eucasphaeria	51039
50843	Allelochaeta	51042
22901	Euploca	51049
34858	Lysiandra	51101
34858	Kirganelia	51102
34858	Cathetus	51105
23342	Mycosphaerella	51116
51118	Pseudofusicoccum	51119
51124	Tranzschelia	51125
23364	Trichaptum	51131
23364	Lenzites	51134
23364	Cellulariella	51136
23364	Datronia	51142
34858	Nellica	51144
34858	Emblica	51148
34858	Moeroris	51149
34858	Dendrophyllanthus	51152
26034	Agissea	51168
44727	Oxychaete	51172
51178	Oxyporus	51179
51430	Neolentinus	51186
23364	Poria	51204
22884	Helosciadium	51209
23351	Peronospora	51213
23352	Geoscypha	51216
23253	Amarrendia	51220
23361	Alternaria	51222
23349	Alpova	51226
50807	Ascochyta	51230
22823	Lemphoria	51232
23264	Amylotrama	51241
26034	Sonderopelta	51247
23409	Xylaria	51299
23409	Poronia	51302
23389	Xylobolus	51305
51310	Naematelia	51311
50315	Cotylidia	51323
23344	Nidularia	51327
23361	Curvularia	51330
22787	Empusa	51338
23283	Austrocortinarius	51345
51353	Smittium	51354
51353	Simuliomyces	51362
51364	Stachylina	51365
23250	Panaeolopsis	51374
34857	Neltuma	51383
22906	Lycianthes	51388
23160	Rexia	51401
23160	Rexiella	51402
23160	Pulchrocladia	51405
22920	Lithotoma	51410
38927	Minakatella	51415
51419	Gelopellis	51420
23305	Glutinoglossum	51423
23305	Geoglossum	51425
51430	Gloeophyllum	51431
23340	Morchella	51434
23369	Geopyxis	51443
23265	Macrophomina	51453
22754	Lazarum	51492
22872	Nopalea	51496
44927	Serpula	51510
23250	Podaxis	51513
23349	Paxillus	51537
22924	Felicia	51540
51548	Nitella	51549
23164	Blennothallia	51571
23164	Enchylium	51573
23169	Fuscidea	51575
23218	Opegrapha	51587
23232	Ainoa	51600
23164	Lathagrium	51602
50863	Pronectria	51604
51606	Zwackhiomyces	51607
51548	Lamprothamnium	51609
51548	Chara	51616
23297	Alboleptonia	51637
23283	Phlegmacium	51643
23283	Rozites	51646
23361	Stemphylium	51650
23315	Hymenochaete	51668
23250	Crucibulum	51671
22715	Brownseya	51673
22787	Corysanthes	51675
22787	Anzybas	51680
23265	Sphaeropsis	51692
23366	Aecidium	51694
23394	Amaurodon	51700
23259	Exidiopsis	51702
23259	Eichleriella	51704
23259	Heterochaete	51706
50888	Cryptodiaporthe	51709
50888	Diplodina	51711
23342	Davisoniella	51713
23234	Conchomyces	51715
50826	Camarosporula	51720
50581	Hendersonia	51722
50581	Stagonospora	51724
50988	Pestalotia	51731
51739	Disculoides	51740
51743	Celerioriella	51744
23319	Physalospora	51756
23257	Dimerosporium	51758
23257	Asterina	51759
23405	Polyrhizon	51761
22870	Pigea	51771
23391	Deconica	51803
22752	Diplacrum	51833
23218	Lecanographa	51841
38927	Ophiotheca	51881
22879	Leptospermopsis	51883
22879	Aggreflorum	51892
22879	Apectospermum	51895
22879	Gaudium	51900
23362	Volvariella	51917
48271	Kappaphycus	51924
22937	Anthoceros	51928
23005	Andreaea	51930
22935	Riccardia	51932
22965	Siphonolejeunea	51936
23004	Sanionia	51945
22932	Goebelobryum	51951
22932	Lethocolea	51954
23012	Bryobartramia	51966
23031	Encalypta	51967
23071	Pterygoneurum	51973
22953	Frullania	51992
22975	Monocarpus	51995
23025	Sclerodontium	51997
23061	Pohlia	52000
30431	Dicranoweisia	52005
52010	Megaceros	52009
22978	Phaeoceros	52015
23042	Dryptodon	52021
23042	Bucklandiella	52024
22939	Asterella	52029
22992	Austroriella	52031
44814	Cruentomycena	52038
22945	Cephaloziella	52040
23336	Malajczukia	52043
23234	Collybia	52049
23361	Bipolaris	52052
23275	Claviceps	52056
43304	Microthia	52059
43304	Endothia	52061
50823	Niesslia	52064
22993	Chaetophyllopsis	52069
22932	Enigmella	52071
38927	Gulielmina	52075
22952	Fossombronia	52079
22969	Lunularia	52098
22971	Marchantia	52113
22973	Metzgeria	52115
23040	Physcomitrium	52119
23040	Physcomitrella	52120
22980	Pallavicinia	52124
22939	Plagiochasma	52127
22990	Radula	52129
22939	Reboulia	52131
23304	Sphaerobolus	52135
23234	Lepista	52137
22991	Riccia	52140
23250	Nidula	52141
23264	Rossbeevera	52145
22980	Symphyogyna	52179
22997	Targionia	52181
22968	Telaranea	52184
23342	Cercospora	52187
22968	Ceramanus	52192
23264	Fistulinella	52197
22992	Riella	52203
23011	Plagiobryoides	52206
52210	Chiloscyphus	52211
22965	Diplasiolejeunea	52216
22938	Gongylanthus	52223
22968	Hyalolepidozia	52225
22968	Paracromastigum	52227
22964	Jamesoniella	52229
22968	Kurzia	52231
22965	Lejeunea	52234
22968	Lepidozia	52236
26008	Reinboldiella	52239
23071	Phascum	52247
23025	Dicranella	52257
38644	Candolleomyces	52283
23335	Allophlebia	52285
23273	Ramariopsis	52287
23232	Kleopowiella	52291
23232	Trapegintarasia	52294
23232	Xyloelixia	52296
23275	Corallocytostroma	52298
52301	Beauveria	52302
52301	Cordyceps	52304
52305	Paecilomyces	52306
52301	Isaria	52309
23275	Drechmeria	52311
52316	Perthomyces	52317
52319	Dilophospora	52320
52322	Annellosympodia	52323
38922	Nannengaella	52329
23353	Uredopeltis	52332
23352	Clelandia	52334
23352	Mycoclelandia	52335
23283	Phaeocollybia	52338
34857	Senegalia	52340
52343	Myriangium	52344
23315	Phellinus	52346
23315	Fuscoporia	52350
23266	Mitremyces	52353
23291	Cryptovalsa	52356
23250	Arachnion	52372
52375	Pleosphaeria	52376
50155	Athelopsis	52386
23335	Crustodontia	52389
46213	Cyanobasidium	52391
23350	Duportella	52394
23305	Trichoglossum	52398
23071	Desmatodon	52414
23071	Gymnostomiella	52419
23071	Phasconica	52422
23424	Hysterangium	52437
52443	Archaeospora	52444
52446	Lizonia	52447
23364	Grammothele	52450
23364	Lopharia	52453
23335	Mycoacia	52456
44727	Phanerodontia	52459
50315	Peniophorella	52462
23335	Scopuloides	52469
23312	Sistotrema	52471
22865	Pleurandra	52473
52520	Grifola	52521
52586	Phaeolus	52523
52529	Okellya	52530
52533	Vaucheria	52534
52532	Laxitextum	52535
23349	Meiorganum	52544
38643	Flammulina	52546
38643	Hymenopellis	52548
23394	Phellodon	52555
52564	Daldinia	52565
23369	Cheilymenia	52567
23377	Plectania	52570
23071	Uleobryum	52600
49770	Gymnogongrus	52603
23071	Splachnobryum	52624
23071	Trichostomopsis	52628
23414	Scolopia	52630
23309	Helvella	52633
22924	Plecostachys	52644
22752	Trianoptiles	52646
22924	Crassocephalum	52669
22738	Juniperus	52671
22772	Aloiampelos	52674
22750	Hydrocharis	52677
22830	Hymenosporum	52678
\.


--
-- TOC entry 5086 (class 0 OID 31593)
-- Dependencies: 224
-- Data for Name: location_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_type (location_type, location_type_id) FROM stdin;
\.


--
-- TOC entry 5087 (class 0 OID 31598)
-- Dependencies: 225
-- Data for Name: plant_utility; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plant_utility (plant_utility_id, utility) FROM stdin;
\.


--
-- TOC entry 5088 (class 0 OID 31605)
-- Dependencies: 226
-- Data for Name: planting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.planting (comments, container_type_id, date_planted, genetic_source_id, number_planted, number_removed, planted_by, planting_id, removal_cause_id, removal_date, variety_id, zone_id) FROM stdin;
\.


--
-- TOC entry 5089 (class 0 OID 31612)
-- Dependencies: 227
-- Data for Name: progeny; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.progeny (child_name, comments, date_germinated, genetic_source_id, progeny_id, sibling_number) FROM stdin;
\.


--
-- TOC entry 5090 (class 0 OID 31621)
-- Dependencies: 228
-- Data for Name: propagation_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.propagation_type (can_cross_genera, needs_two_parents, propagation_type, propagation_type_id) FROM stdin;
\.


--
-- TOC entry 5091 (class 0 OID 31626)
-- Dependencies: 229
-- Data for Name: provenance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provenance (bioregion_code, extra_details, location, location_type_id, provenance_id) FROM stdin;
\.


--
-- TOC entry 5092 (class 0 OID 31633)
-- Dependencies: 230
-- Data for Name: removal_cause; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.removal_cause (cause, removal_cause_id) FROM stdin;
\.


--
-- TOC entry 5093 (class 0 OID 31640)
-- Dependencies: 231
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role (description, role, role_id) FROM stdin;
\.


--
-- TOC entry 5094 (class 0 OID 31649)
-- Dependencies: 232
-- Data for Name: species; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.species (conservation_status_id, genus_id, species, species_id) FROM stdin;
\.


--
-- TOC entry 5095 (class 0 OID 31654)
-- Dependencies: 233
-- Data for Name: species_utility_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.species_utility_link (plant_utility_id, species_id) FROM stdin;
\.


--
-- TOC entry 5096 (class 0 OID 31659)
-- Dependencies: 234
-- Data for Name: sub_zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sub_zone (aspect_id, exposure_to_wind, shade, sub_zone_code, sub_zone_id, zone_id) FROM stdin;
\.


--
-- TOC entry 5097 (class 0 OID 31666)
-- Dependencies: 235
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supplier (is_a_research_breeder, short_name, supplier_id, supplier_name, web_site) FROM stdin;
\.


--
-- TOC entry 5098 (class 0 OID 31677)
-- Dependencies: 236
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (address_line_1, address_line_2, email, first_name, full_name, locality, mobile, password, postcode, preferred_name, surname, title, user_id, work_phone) FROM stdin;
\.


--
-- TOC entry 5099 (class 0 OID 31684)
-- Dependencies: 237
-- Data for Name: user_role_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_role_link (role_id, user_id) FROM stdin;
\.


--
-- TOC entry 5100 (class 0 OID 31689)
-- Dependencies: 238
-- Data for Name: variety; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.variety (common_name, genetic_source_id, species_id, variety, variety_id) FROM stdin;
\.


--
-- TOC entry 5101 (class 0 OID 31698)
-- Dependencies: 239
-- Data for Name: zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.zone (aspect_id, exposure_to_wind, shade, zone_id, zone_name, zone_number) FROM stdin;
\.


--
-- TOC entry 4838 (class 2606 OID 31550)
-- Name: aspect aspect_aspect_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aspect
    ADD CONSTRAINT aspect_aspect_key UNIQUE (aspect);


--
-- TOC entry 4840 (class 2606 OID 31548)
-- Name: aspect aspect_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aspect
    ADD CONSTRAINT aspect_pkey PRIMARY KEY (aspect_id);


--
-- TOC entry 4842 (class 2606 OID 31557)
-- Name: bioregion bioregion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bioregion
    ADD CONSTRAINT bioregion_pkey PRIMARY KEY (bioregion_code);


--
-- TOC entry 4844 (class 2606 OID 31564)
-- Name: conservation_status conservation_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conservation_status
    ADD CONSTRAINT conservation_status_pkey PRIMARY KEY (conservation_status_id);


--
-- TOC entry 4846 (class 2606 OID 31566)
-- Name: conservation_status conservation_status_status_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conservation_status
    ADD CONSTRAINT conservation_status_status_key UNIQUE (status);


--
-- TOC entry 4848 (class 2606 OID 31571)
-- Name: container container_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.container
    ADD CONSTRAINT container_pkey PRIMARY KEY (container_type_id);


--
-- TOC entry 4850 (class 2606 OID 31578)
-- Name: family family_famiy_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.family
    ADD CONSTRAINT family_famiy_name_key UNIQUE (famiy_name);


--
-- TOC entry 4852 (class 2606 OID 31576)
-- Name: family family_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.family
    ADD CONSTRAINT family_pkey PRIMARY KEY (family_id);


--
-- TOC entry 4854 (class 2606 OID 31585)
-- Name: genetic_source genetic_source_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genetic_source
    ADD CONSTRAINT genetic_source_pkey PRIMARY KEY (genetic_source_id);


--
-- TOC entry 4856 (class 2606 OID 31592)
-- Name: genus genus_genus_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genus
    ADD CONSTRAINT genus_genus_key UNIQUE (genus);


--
-- TOC entry 4858 (class 2606 OID 31590)
-- Name: genus genus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genus
    ADD CONSTRAINT genus_pkey PRIMARY KEY (genus_id);


--
-- TOC entry 4860 (class 2606 OID 31597)
-- Name: location_type location_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_type
    ADD CONSTRAINT location_type_pkey PRIMARY KEY (location_type_id);


--
-- TOC entry 4862 (class 2606 OID 31602)
-- Name: plant_utility plant_utility_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plant_utility
    ADD CONSTRAINT plant_utility_pkey PRIMARY KEY (plant_utility_id);


--
-- TOC entry 4864 (class 2606 OID 31604)
-- Name: plant_utility plant_utility_utility_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plant_utility
    ADD CONSTRAINT plant_utility_utility_key UNIQUE (utility);


--
-- TOC entry 4866 (class 2606 OID 31611)
-- Name: planting planting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planting
    ADD CONSTRAINT planting_pkey PRIMARY KEY (planting_id);


--
-- TOC entry 4868 (class 2606 OID 31618)
-- Name: progeny progeny_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progeny
    ADD CONSTRAINT progeny_pkey PRIMARY KEY (genetic_source_id, sibling_number);


--
-- TOC entry 4870 (class 2606 OID 31620)
-- Name: progeny progeny_progeny_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progeny
    ADD CONSTRAINT progeny_progeny_id_key UNIQUE (progeny_id);


--
-- TOC entry 4872 (class 2606 OID 31625)
-- Name: propagation_type propagation_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.propagation_type
    ADD CONSTRAINT propagation_type_pkey PRIMARY KEY (propagation_type_id);


--
-- TOC entry 4874 (class 2606 OID 31632)
-- Name: provenance provenance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provenance
    ADD CONSTRAINT provenance_pkey PRIMARY KEY (provenance_id);


--
-- TOC entry 4876 (class 2606 OID 31639)
-- Name: removal_cause removal_cause_cause_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.removal_cause
    ADD CONSTRAINT removal_cause_cause_key UNIQUE (cause);


--
-- TOC entry 4878 (class 2606 OID 31637)
-- Name: removal_cause removal_cause_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.removal_cause
    ADD CONSTRAINT removal_cause_pkey PRIMARY KEY (removal_cause_id);


--
-- TOC entry 4880 (class 2606 OID 31646)
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (role_id);


--
-- TOC entry 4882 (class 2606 OID 31648)
-- Name: role role_role_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_role_key UNIQUE (role);


--
-- TOC entry 4884 (class 2606 OID 31653)
-- Name: species species_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_pkey PRIMARY KEY (species_id);


--
-- TOC entry 4886 (class 2606 OID 31658)
-- Name: species_utility_link species_utility_link_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species_utility_link
    ADD CONSTRAINT species_utility_link_pkey PRIMARY KEY (plant_utility_id, species_id);


--
-- TOC entry 4888 (class 2606 OID 31665)
-- Name: sub_zone sub_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_zone
    ADD CONSTRAINT sub_zone_pkey PRIMARY KEY (sub_zone_id);


--
-- TOC entry 4890 (class 2606 OID 31672)
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (supplier_id);


--
-- TOC entry 4892 (class 2606 OID 31674)
-- Name: supplier supplier_short_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_short_name_key UNIQUE (short_name);


--
-- TOC entry 4894 (class 2606 OID 31676)
-- Name: supplier supplier_supplier_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_supplier_name_key UNIQUE (supplier_name);


--
-- TOC entry 4896 (class 2606 OID 31683)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4898 (class 2606 OID 31688)
-- Name: user_role_link user_role_link_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role_link
    ADD CONSTRAINT user_role_link_pkey PRIMARY KEY (role_id, user_id);


--
-- TOC entry 4900 (class 2606 OID 31697)
-- Name: variety variety_genetic_source_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variety
    ADD CONSTRAINT variety_genetic_source_id_key UNIQUE (genetic_source_id);


--
-- TOC entry 4902 (class 2606 OID 31695)
-- Name: variety variety_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variety
    ADD CONSTRAINT variety_pkey PRIMARY KEY (variety_id);


--
-- TOC entry 4904 (class 2606 OID 31704)
-- Name: zone zone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zone
    ADD CONSTRAINT zone_pkey PRIMARY KEY (zone_id);


--
-- TOC entry 4906 (class 2606 OID 31706)
-- Name: zone zone_zone_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zone
    ADD CONSTRAINT zone_zone_number_key UNIQUE (zone_number);


--
-- TOC entry 4907 (class 2606 OID 31732)
-- Name: genetic_source genetic_source_genetic_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genetic_source
    ADD CONSTRAINT genetic_source_genetic_source_id_fkey FOREIGN KEY (genetic_source_id) REFERENCES public.variety(genetic_source_id);


--
-- TOC entry 4908 (class 2606 OID 31707)
-- Name: genetic_source genetic_source_propagation_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genetic_source
    ADD CONSTRAINT genetic_source_propagation_type_fkey FOREIGN KEY (propagation_type) REFERENCES public.propagation_type(propagation_type_id);


--
-- TOC entry 4909 (class 2606 OID 31712)
-- Name: genetic_source genetic_source_provenance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genetic_source
    ADD CONSTRAINT genetic_source_provenance_id_fkey FOREIGN KEY (provenance_id) REFERENCES public.provenance(provenance_id);


--
-- TOC entry 4910 (class 2606 OID 31722)
-- Name: genetic_source genetic_source_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genetic_source
    ADD CONSTRAINT genetic_source_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.supplier(supplier_id);


--
-- TOC entry 4911 (class 2606 OID 31727)
-- Name: genetic_source genetic_source_supplier_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genetic_source
    ADD CONSTRAINT genetic_source_supplier_id_fkey1 FOREIGN KEY (supplier_id) REFERENCES public.supplier(supplier_id);


--
-- TOC entry 4912 (class 2606 OID 31717)
-- Name: genetic_source genetic_source_variety_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genetic_source
    ADD CONSTRAINT genetic_source_variety_id_fkey FOREIGN KEY (variety_id) REFERENCES public.variety(variety_id);


--
-- TOC entry 4913 (class 2606 OID 31737)
-- Name: genus genus_family_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genus
    ADD CONSTRAINT genus_family_id_fkey FOREIGN KEY (family_id) REFERENCES public.family(family_id);


--
-- TOC entry 4914 (class 2606 OID 31742)
-- Name: planting planting_container_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planting
    ADD CONSTRAINT planting_container_type_id_fkey FOREIGN KEY (container_type_id) REFERENCES public.container(container_type_id);


--
-- TOC entry 4915 (class 2606 OID 31752)
-- Name: planting planting_genetic_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planting
    ADD CONSTRAINT planting_genetic_source_id_fkey FOREIGN KEY (genetic_source_id) REFERENCES public.genetic_source(genetic_source_id);


--
-- TOC entry 4916 (class 2606 OID 31762)
-- Name: planting planting_planted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planting
    ADD CONSTRAINT planting_planted_by_fkey FOREIGN KEY (planted_by) REFERENCES public."user"(user_id);


--
-- TOC entry 4917 (class 2606 OID 31747)
-- Name: planting planting_removal_cause_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planting
    ADD CONSTRAINT planting_removal_cause_id_fkey FOREIGN KEY (removal_cause_id) REFERENCES public.removal_cause(removal_cause_id);


--
-- TOC entry 4918 (class 2606 OID 31757)
-- Name: planting planting_variety_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planting
    ADD CONSTRAINT planting_variety_id_fkey FOREIGN KEY (variety_id) REFERENCES public.variety(variety_id);


--
-- TOC entry 4919 (class 2606 OID 31767)
-- Name: planting planting_zone_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planting
    ADD CONSTRAINT planting_zone_id_fkey FOREIGN KEY (zone_id) REFERENCES public.zone(zone_id);


--
-- TOC entry 4920 (class 2606 OID 31772)
-- Name: progeny progeny_genetic_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progeny
    ADD CONSTRAINT progeny_genetic_source_id_fkey FOREIGN KEY (genetic_source_id) REFERENCES public.genetic_source(genetic_source_id);


--
-- TOC entry 4921 (class 2606 OID 31777)
-- Name: provenance provenance_bioregion_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provenance
    ADD CONSTRAINT provenance_bioregion_code_fkey FOREIGN KEY (bioregion_code) REFERENCES public.bioregion(bioregion_code);


--
-- TOC entry 4922 (class 2606 OID 31782)
-- Name: provenance provenance_location_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provenance
    ADD CONSTRAINT provenance_location_type_id_fkey FOREIGN KEY (location_type_id) REFERENCES public.location_type(location_type_id);


--
-- TOC entry 4923 (class 2606 OID 31787)
-- Name: species species_conservation_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_conservation_status_id_fkey FOREIGN KEY (conservation_status_id) REFERENCES public.conservation_status(conservation_status_id);


--
-- TOC entry 4924 (class 2606 OID 31792)
-- Name: species species_genus_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_genus_id_fkey FOREIGN KEY (genus_id) REFERENCES public.genus(genus_id);


--
-- TOC entry 4925 (class 2606 OID 31797)
-- Name: species_utility_link species_utility_link_plant_utility_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species_utility_link
    ADD CONSTRAINT species_utility_link_plant_utility_id_fkey FOREIGN KEY (plant_utility_id) REFERENCES public.plant_utility(plant_utility_id);


--
-- TOC entry 4926 (class 2606 OID 31802)
-- Name: species_utility_link species_utility_link_species_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species_utility_link
    ADD CONSTRAINT species_utility_link_species_id_fkey FOREIGN KEY (species_id) REFERENCES public.species(species_id);


--
-- TOC entry 4927 (class 2606 OID 31807)
-- Name: sub_zone sub_zone_zone_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_zone
    ADD CONSTRAINT sub_zone_zone_id_fkey FOREIGN KEY (zone_id) REFERENCES public.zone(zone_id);


--
-- TOC entry 4928 (class 2606 OID 31812)
-- Name: user_role_link user_role_link_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role_link
    ADD CONSTRAINT user_role_link_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.role(role_id);


--
-- TOC entry 4929 (class 2606 OID 31817)
-- Name: user_role_link user_role_link_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role_link
    ADD CONSTRAINT user_role_link_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(user_id);


--
-- TOC entry 4930 (class 2606 OID 31822)
-- Name: variety variety_species_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variety
    ADD CONSTRAINT variety_species_id_fkey FOREIGN KEY (species_id) REFERENCES public.species(species_id);


--
-- TOC entry 4931 (class 2606 OID 31827)
-- Name: zone zone_aspect_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zone
    ADD CONSTRAINT zone_aspect_id_fkey FOREIGN KEY (aspect_id) REFERENCES public.aspect(aspect_id);


-- Completed on 2025-09-16 09:47:50

--
-- PostgreSQL database dump complete
--

\unrestrict Am2SRS5AnLjIxhksOvAk1sxoJZmS3XQcqwaah5cZCKjLZFSWyba34rvT0U1iCHw

