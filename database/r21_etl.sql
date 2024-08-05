DROP VIEW IF EXISTS
  ETL.CellLineView_query;
CREATE VIEW
  ETL.CellLineView_query AS
SELECT
  SS.Sample_ID,
  SS.Sample_Name,
  CL.ATCC_ID,
  CL.Cosmic_ID,
  CL.depmap_ID,
  TD.Short_topo,
  MD.Morphology,
  TuD.Tumor_origin,
  CL.Add_info,
  SI.Sex,
  SS.Age,
  CD.Country,
  CD.Population,
  CD.Region,
  CD.Development,
  SI.Germline_mutation,
  SI.Infectious_agent,
  ToD.Tobacco,
  AD.Alcohol,
  ExD.Exposure,
  SS.KRAS_status,
  SS.Other_mutations,
  CL.TP53status,
  SS.LOH AS TP53_LOH,
  CL.Protein_status AS p53_protein_status,
  SS.p53_IHC,
  MU.MUT_ID,
  L.hg18_Chr17_coordinates,
  L.hg19_Chr17_coordinates,
  L.hg38_Chr17_coordinates,
  L.ExonIntron,
  L.Codon_number,
  MU.Description,
  MU.c_description,
  MU.g_description,
  MU.g_description_GRCh38,
  AA.ProtDescription,
  MU.COSMIClink,
  MU.TCGA_ICGC_GENIE_count,
  MU.cBioportalCount,
  Sq.Hotspot,
  TY.Type,
  L.Base AS WT_nucleotide,
  MU.Mutant_nucleotide,
  Sq.WT_codon,
  MU.Mutant_codon,
  Sq.WT_AA,
  GC.Amino_Acid AS Mutant_AA,
  ED.Effect,
  AA.AGVGDClass,
  AA.SIFTClass,
  AA.Polyphen2,
  AA.REVEL,
  AA.BayesDel,
  AA.DNE_LOFclass,
  AA.DNEclass,
  AA.TransactivationClass,
  FI.WAF1nWT,
  FI.MDM2nWT,
  FI.BAXnWT,
  FI.AIP1nWT,
  FI.h1433snWT,
  FI.GADD45nWT,
  FI.NOXAnWT,
  FI.P53R2nWT,
  SR.Ref_ID,
  SR.Journal,
  SR.S_Ref_Year AS Year,
  SR.Volume,
  SR.Start_page,
  SR.PubMed,
  SR.Start_material,
  SR.Prescreening,
  SR.Material_sequenced,
  SR.exon2,
  SR.exon3,
  SR.exon4,
  SR.exon5,
  SR.exon6,
  SR.exon7,
  SR.exon8,
  SR.exon9,
  SR.exon10,
  SR.exon11,
  MU.Type_ID,
  Sq.Structural_motif,
  AA.AAchange,
  MoD.Morphogroup,
  TuD.Tumor_origin_group,
  ToD.Tobacco_search,
  AD.Alcohol_search,
  MU.hgvs_hg19,
  MU.hgvs_hg38,
  MU.hgvs_NM_000546
FROM
  `P53_data.Effect_dic` AS ED
RIGHT OUTER JOIN
  `P53_data.AA_change` AS AA
RIGHT OUTER JOIN
  `P53_data.MUTATION` AS MU
INNER JOIN
  `P53_data.Type_dic` AS TY
ON
  MU.Type_ID = TY.Type_ID
ON
  AA.AAchange_ID = MU.AAchangeID
ON
  ED.Effect_ID = MU.Effect_ID
LEFT OUTER JOIN
  `P53_data.Genetic_code` AS GC
ON
  MU.Mutant_codon = GC.Codon
LEFT OUTER JOIN
  `P53_data.Location` AS L
LEFT OUTER JOIN
  `P53_data.p53_sequence` AS Sq
ON
  L.Codon_number = Sq.Codon_number
ON
  MU.Location_ID = L.Location_ID
RIGHT OUTER JOIN
  `P53_data.S_MUTATION` AS SM
ON
  MU.MUT_ID = SM.MUT_ID
RIGHT OUTER JOIN
  `P53_data.Morphogroup_dic` AS MoD
INNER JOIN
  `P53_data.CellLines` AS CL
INNER JOIN
  `P53_data.S_REFERENCE` AS SR
INNER JOIN
  `P53_data.S_INDIVIDUAL` AS SI
ON
  SR.Ref_ID = SI.Ref_ID
INNER JOIN
  `P53_data.S_SAMPLE` AS SS
ON
  SI.Individual_ID = SS.Individual_ID
INNER JOIN
  `P53_data.Morphology_dic` AS MD
ON
  SS.Morpho_ID = MD.Morphology_ID
INNER JOIN
  `P53_data.Subtopography_dic` AS SD
INNER JOIN
  `P53_data.Topography_dic` AS TD
ON
  SD.Topo_code = TD.Topo_code
ON
  SS.Subtopo_ID = SD.Subtopo_ID
ON
  CL.Sample_ID = SS.Sample_ID
INNER JOIN
  `P53_data.Country_dic` AS CD
ON
  SI.Country_ID = CD.Country_ID
INNER JOIN
  `P53_data.Exposure_dic` AS ExD
ON
  SI.Exposure_ID = ExD.Exposure_ID
INNER JOIN
  `P53_data.Tobacco_dic` AS ToD
ON
  SI.Tobacco_ID = ToD.Tobacco_ID
INNER JOIN
  `P53_data.Alcohol_dic` AS AD
ON
  SI.Alcohol_ID = AD.Alcohol_ID
INNER JOIN
  `P53_data.Tumor_origin_dic` AS TuD
ON
  SS.Tumor_origin_ID = TuD.Tumor_origin_ID
ON
  MoD.Morphogroup_ID = MD.Morphogroup_ID
ON
  SM.Sample_ID = SS.Sample_ID
LEFT OUTER JOIN
  `P53_data.FUNCTION_ISHIOKA` AS FI
ON
  AA.AAchange_ID = FI.AAchangeID
WHERE
  (SS.Sample_source_ID = 4)
ORDER BY
  TD.Short_topo,
  SS.Sample_Name,
  CL.TP53status;
DROP VIEW IF EXISTS
  ETL.GermlineView_query;
CREATE VIEW
  ETL.GermlineView_query AS
SELECT
  GF.Family_ID,
  GF.Family_code,
  GC.Class,
  GF.Generations_analyzed,
  GF.Germline_mutation,
  Cd.Country,
  Cd.Population,
  Cd.Region,
  Cd.Development,
  M.MUT_ID,
  Lo.hg18_Chr17_coordinates,
  Lo.hg19_Chr17_coordinates,
  Lo.hg38_Chr17_coordinates,
  Lo.ExonIntron,
  Lo.Codon_number,
  M.Description,
  M.c_description,
  M.g_description,
  M.g_description_GRCh38,
  Ty.Type,
  Lo.Base AS WT_nucleotide,
  Lo.Splice_site,
  Lo.CpG_site,
  M.Mutant_nucleotide,
  p53.WT_codon,
  M.Mutant_codon,
  p53.WT_AA,
  Ge.Amino_Acid AS Mutant_AA,
  Ef.Effect,
  AA.AGVGDClass,
  AA.SIFTClass,
  AA.Polyphen2,
  AA.REVEL,
  AA.BayesDel,
  AA.TransactivationClass,
  AA.DNE_LOFclass,
  AA.DNEclass,
  AA.ProtDescription,
  M.COSMIClink,
  M.CLINVARlink,
  M.TCGA_ICGC_GENIE_count,
  p53.Hotspot,
  GI.Individual_ID,
  GI.Individual_code,
  GFc.FamilyCase,
  GFc.FamilyCase_group,
  GI.Sex,
  GI.Germline_carrier,
  GI.Mode_of_inheritance,
  GI.Dead,
  GI.Unaffected,
  GI.Age,
  GT.Tumor_ID,
  Topo.Topography,
  Mo.Morphology,
  Gr.PubMed,
  GT.Age_at_diagnosis,
  GF.Ref_ID,
  Topo.Short_topo,
  GT.ShortTumor,
  Ef.Effect_ID,
  p53.Structural_motif,
  Ty.Type_ID,
  Topo.StatisticGraphGermline,
  Mog.Morphogroup,
  AA.AAchange,
  AA.Mut_rateAA,
  GF.Other_infos,
  SP.DS_AG AS SpliceAI_DS_AG,
  SP.DS_AL AS SpliceAI_DS_AL,
  SP.DS_DG AS SpliceAI_DS_DG,
  SP.DS_DL AS SpliceAI_DS_DL,
  SP.DP_AG AS SpliceAI_DP_AG,
  SP.DP_AL AS SpliceAI_DP_AL,
  SP.DP_DG AS SpliceAI_DP_DG,
  SP.DP_DL AS SpliceAI_DP_DL,
  ROW_NUMBER() OVER(ORDER BY GF.Ref_ID) AS GermlineView_ID
FROM
  `P53_data.Subtopography_dic` AS Su
LEFT OUTER JOIN
  `P53_data.Topography_dic` AS Topo
ON
  Su.Topo_code = Topo.Topo_code
  AND Su.Topo_code = Topo.Topo_code
RIGHT OUTER JOIN
  `P53_data.G_TUMOR` AS GT
LEFT OUTER JOIN
  `P53_data.Morphology_dic` AS Mo
INNER JOIN
  `P53_data.Morphogroup_dic` AS Mog
ON
  Mo.Morphogroup_ID = Mog.Morphogroup_ID
ON
  GT.Morpho_ID = Mo.Morphology_ID
  AND GT.Morpho_ID = Mo.Morphology_ID
ON
  Su.Subtopo_ID = GT.Subtopo_ID
  AND Su.Subtopo_ID = GT.Subtopo_ID
RIGHT OUTER JOIN
  `P53_data.Genetic_code` AS Ge
INNER JOIN
  `P53_data.G_Classification_dic` AS GC
INNER JOIN
  `P53_data.G_FAMILY` AS GF
ON
  GC.Class_ID = GF.Class_ID
LEFT JOIN
  `P53_data.G_INDIVIDUAL` AS GI
ON
  GF.Family_ID = GI.Family_ID
LEFT JOIN
  `P53_data.G_P53_MUTATION` AS GP53
ON
  GF.Family_ID = GP53.Family_ID
JOIN
  `P53_data.G_REFERENCE` AS Gr
ON
  GF.Ref_ID = Gr.Ref_ID
INNER JOIN
  `P53_data.Country_dic` AS Cd
ON
  GF.Country_ID = Cd.Country_ID
INNER JOIN
  `P53_data.MUTATION` AS M
ON
  GP53.MUT_ID = M.MUT_ID
  AND GP53.MUT_ID = M.MUT_ID
ON
  Ge.Codon = M.Mutant_codon
INNER JOIN
  `P53_data.Effect_dic` AS Ef
ON
  M.Effect_ID = Ef.Effect_ID
INNER JOIN
  `P53_data.AA_change` AS AA
ON
  M.AAchangeID = AA.AAchange_ID
INNER JOIN
  `P53_data.Location` AS Lo
ON
  M.Location_ID = Lo.Location_ID
INNER JOIN
  `P53_data.p53_sequence` AS p53
ON
  Lo.Codon_number = p53.Codon_number
  AND Lo.Codon_number = p53.Codon_number
INNER JOIN
  `P53_data.Type_dic` AS Ty
ON
  M.Type_ID = Ty.Type_ID
LEFT JOIN
  `P53_data.G_FamilyCase_dic` AS GFc
ON
  GI.FamilyCase_ID = GFc.FamilyCase_ID
ON
  GT.Individual_ID = GI.Individual_ID
LEFT JOIN
  `P53_data.EXONIC_SPLICE_AI` AS SP
ON
  M.c_description = SP.cDNA
ORDER BY
  GF.Ref_ID;
DROP VIEW IF EXISTS
  ETL.GM_C_DESC_TXT_LIST_query;
CREATE VIEW
  ETL.GM_C_DESC_TXT_LIST_query AS --GM_C_DESC.TXT.LIST
SELECT
  DISTINCT c_description
FROM
  P53_data.GermlineView_Carriers
ORDER BY
  c_description;
DROP VIEW IF EXISTS
  ETL.GM_DESC_TXT_LIST_query;
CREATE VIEW
  ETL.GM_DESC_TXT_LIST_query AS -- GM_DESC.TXT.LIST: Description drop down list for the germline variant search screen. Store the query result in csv format, after removing the first line (header)
SELECT
  DISTINCT Description
FROM
  P53_data.GermlineView_Carriers
ORDER BY
  Description;
DROP VIEW IF EXISTS
  ETL.GM_EFFECT_TXT_LIST_query;
CREATE VIEW
  ETL.GM_EFFECT_TXT_LIST_query AS --GM_EFFECT.TXT.LIST
SELECT
  DISTINCT Effect
FROM
  P53_data.GermlineView_Carriers
WHERE
  Effect != 'NA'
ORDER BY
  CASE
    WHEN Effect = 'other' THEN 1
    ELSE 0
END
  ,
  Effect;
DROP VIEW IF EXISTS
  ETL.GM_EXON_INTRON_TXT_LIST_query;
CREATE VIEW
  ETL.GM_EXON_INTRON_TXT_LIST_query AS
SELECT
  DISTINCT ExonIntron
FROM
  P53_data.GermlineView_Carriers
WHERE
  ExonIntron != 'NA'
ORDER BY
  CASE
    WHEN ExonIntron LIKE '%-intron' THEN 0
    WHEN ExonIntron LIKE 'e%-exon' THEN 2
    WHEN ExonIntron LIKE '%-exon' THEN 1
    ELSE 3
END
  ,
  CAST( REGEXP_REPLACE(ExonIntron, '[^0-9]', '') AS INTEGER ),
  ExonIntron;
DROP VIEW IF EXISTS
  ETL.GM_FAMILY_CASE_TXT_LIST_query;
CREATE VIEW
  ETL.GM_FAMILY_CASE_TXT_LIST_query AS --GM_FAMILY_CASE.TXT.LIST
SELECT
  DISTINCT FamilyCase_group
FROM
  P53_data.GermlineView_Carriers
WHERE
  FamilyCase_group != 'NA'
ORDER BY
  CASE FamilyCase_group
    WHEN 'other' THEN 1
    ELSE 0
END
  ,
  FamilyCase_group;
DROP VIEW IF EXISTS
  ETL.GM_FAMILY_HIST_TXT_LIST_query;
CREATE VIEW
  ETL.GM_FAMILY_HIST_TXT_LIST_query AS --GM_FAMILY_HIST.TXT.LIST
SELECT
  DISTINCT Class
FROM
  P53_data.GermlineView_Carriers
WHERE
  Class != 'NA'
ORDER BY
  Class;
DROP VIEW IF EXISTS
  ETL.GM_G_DESC_HG19_TXT_LIST_query;
CREATE VIEW
  ETL.GM_G_DESC_HG19_TXT_LIST_query AS -- GM_G_DESC_HG19.TXT.LIST: Genomic Description (HG19) drop down list for the germline variant search screen. Store the query result in csv format, after removing the first line (header)
SELECT
  DISTINCT g_description
FROM
  P53_data.GermlineView_Carriers
ORDER BY
  g_description;
DROP VIEW IF EXISTS
  ETL.GM_G_DESC_HG38_TXT_LIST_query;
CREATE VIEW
  ETL.GM_G_DESC_HG38_TXT_LIST_query AS -- GM_G_DESC_HG38.TXT.LIST: Genomic Description (HG38) drop down list for the germline variant search screen. Store the query result in csv format, after removing the first line (header)
SELECT
  DISTINCT g_description_GRCh38
FROM
  P53_data.GermlineView_Carriers
ORDER BY
  g_description_GRCh38;
DROP VIEW IF EXISTS
  ETL.GM_INH_MODE_TXT_LIST_query;
CREATE VIEW
  ETL.GM_INH_MODE_TXT_LIST_query AS --GM_INH_MODE.TXT.LIST
SELECT
  DISTINCT Mode_of_inheritance
FROM
  P53_data.GermlineView_Carriers
WHERE
  Mode_of_inheritance != 'NA'
ORDER BY
  Mode_of_inheritance;
DROP VIEW IF EXISTS
  ETL.GM_MOTIF_TXT_LIST_query;
CREATE VIEW
  ETL.GM_MOTIF_TXT_LIST_query AS -- GM_MOTIF.TXT.LIST: Struct-Function Motif option drop down list for the germline variant search screen. Store the query result in csv format, after removing the first line (header)
SELECT
  DISTINCT Structural_motif
FROM
  P53_data.GermlineView_Carriers
WHERE
  Structural_motif != 'NA'
ORDER BY
  Structural_motif;
DROP VIEW IF EXISTS
  ETL.GM_P_DESC_TEXT_LIST_query;
CREATE VIEW
  ETL.GM_P_DESC_TEXT_LIST_query AS -- GM_P_DESC.TXT.LIST: Protein Description drop down list for the germline variant search screen. Store the query result in csv format, after removing the first line (header)
SELECT
  DISTINCT ProtDescription
FROM
  P53_data.GermlineView_Carriers
ORDER BY
  ProtDescription;
DROP VIEW IF EXISTS
  ETL.GM_SIFT_TXT_LIST_query;
CREATE VIEW
  ETL.GM_SIFT_TXT_LIST_query AS --GM_SIFT.TXT.LIST
SELECT
  DISTINCT SIFTClass
FROM
  P53_data.GermlineView_Carriers
WHERE
  SIFTClass != 'NA'
ORDER BY
  SIFTClass;
DROP VIEW IF EXISTS
  ETL.GM_TA_CLASS_TXT_LIST_query;
CREATE VIEW
  ETL.GM_TA_CLASS_TXT_LIST_query AS --GM_TA_CLASS.TXT.LIST
SELECT
  DISTINCT TransactivationClass
FROM
  P53_data.GermlineView_Carriers
WHERE
  TransactivationClass != 'NA'
ORDER BY
  TransactivationClass;
DROP VIEW IF EXISTS
  ETL.GM_TYPE_TXT_LIST_query;
CREATE VIEW
  ETL.GM_TYPE_TXT_LIST_query AS -- GM_TYPE.TXT.LIST: Type option drop down list for the germline variant search screen. Store the query result in csv format, after removing the first line (header)
SELECT
  DISTINCT Type
FROM
  P53_data.GermlineView_Carriers
WHERE
  Type != 'NA'
ORDER BY
  Type;
DROP VIEW IF EXISTS
  ETL.MutationView_query;
CREATE VIEW
  ETL.MutationView_query AS
WITH
  SOMATIC_CASE_COUNT AS (
  SELECT
    MUT_ID,
    COUNT(DISTINCT Sample_ID) AS Somatic_count
  FROM
    P53_data.SomaticView
  GROUP BY
    MUT_ID ),
  GERMLINE_CASE_COUNT AS (
  SELECT
    MUT_ID,
    COUNT(DISTINCT family_ID) AS Germline_count
  FROM
    P53_data.GermlineView
  GROUP BY
    MUT_ID ),
  CELLLINE_CASE_COUNT AS (
  SELECT
    MUT_ID,
    COUNT(DISTINCT Sample_ID) AS CellLine_count
  FROM
    P53_data.CellLineView
  WHERE
    MUT_ID IS NOT NULL
  GROUP BY
    MUT_ID )
SELECT
  M.MUT_ID,
  L.hg18_Chr17_coordinates,
  L.hg19_Chr17_coordinates,
  L.hg38_Chr17_coordinates,
  L.ExonIntron,
  L.Codon_number,
  M.Description,
  M.c_description,
  M.g_description,
  M.g_description_GRCh38,
  AA.ProtDescription,
  M.hgvs_hg19,
  M.hgvs_hg38,
  M.hgvs_NM_000546,
  L.Splice_site,
  L.CpG_site,
  L.Context_coding_3,
  TD.Type,
  L.Base AS WT_nucleotide,
  M.Mutant_nucleotide,
  M.Mut_rate,
  S.WT_codon,
  M.Mutant_codon,
  S.WT_AA,
  GC.Amino_Acid AS Mutant_AA,
  AA.Mut_rateAA,
  E.Effect,
  M.Polymorphism,
  M.COSMIClink,
  M.CLINVARlink,
  M.TCGA_ICGC_GENIE_count,
  S.Hotspot,
  P.SNPlink,
  P.gnomADlink,
  P.SourceDatabases,
  P.PubMedlink,
  S.Residue_function,
  S.Domain_function,
  S.Structural_motif,
  S.SA,
  AA.TransactivationClass,
  AA.DNE_LOFclass,
  AA.DNEclass,
  AA.StructureFunctionClass,
  AA.AGVGDClass,
  AA.SIFTClass,
  AA.Polyphen2,
  AA.BayesDel,
  AA.REVEL,
  M.EffectGroup3,
  AA.SwissProtLink,
  F.WAF1nWT,
  F.MDM2nWT,
  F.BAXnWT,
  F.h1433snWT,
  F.AIP1nWT,
  F.GADD45nWT,
  F.NOXAnWT,
  F.P53R2nWT,
  AA.AAchange,
  F.WAF1nWT_Saos2,
  F.MDM2nWT_Saos2,
  F.BAXnWT_Saos2,
  F.h1433snWT_Saos2,
  F.AIP1nWT_Saos2,
  F.PUMAnWT_Saos2,
  F.SubG1nWT_Saos2,
  M.Type_ID,
  AA.AAchange_ID,
  ROW_NUMBER() OVER(ORDER BY L.hg38_Chr17_coordinates DESC, M.Description ) AS MutationView_ID,
  CASE
    WHEN SCC.Somatic_count IS NULL THEN 0
    ELSE SCC.Somatic_count
END
  AS Somatic_count,
  CASE
    WHEN GCC.Germline_count IS NULL THEN 0
    ELSE GCC.Germline_count
END
  AS Germline_count,
  CASE
    WHEN CCC.CellLine_count IS NULL THEN 0
    ELSE CCC.CellLine_count
END
  AS CellLine_count,
  SA.DS_AL AS SpliceAI_DS_AL,
  SA.DS_AG AS SpliceAI_DS_AG,
  SA.DS_DG AS SpliceAI_DS_DG,
  SA.DS_DL AS SpliceAI_DS_DL,
  SA.DP_AG AS SpliceAI_DP_AG,
  SA.DP_AL AS SpliceAI_DP_AL,
  SA.DP_DG AS SpliceAI_DP_DG,
  SA.DP_DL AS SpliceAI_DP_DL
FROM
  P53_data.POLYMORPHISM AS P
RIGHT OUTER JOIN
  P53_data.MUTATION AS M
INNER JOIN
  P53_data.Location AS L
ON
  M.Location_ID = L.Location_ID
INNER JOIN
  P53_data.Genetic_code AS GC
ON
  M.Mutant_codon = GC.Codon
INNER JOIN
  P53_data.Type_dic AS TD
ON
  M.Type_ID = TD.Type_ID
INNER JOIN
  P53_data.AA_change AS AA
ON
  M.AAchangeID = AA.AAchange_ID
INNER JOIN
  P53_data.p53_sequence AS S
ON
  L.Codon_number = S.Codon_number
INNER JOIN
  P53_data.Effect_dic AS E
ON
  M.Effect_ID = E.Effect_ID
ON
  P.MUT_ID = M.MUT_ID
LEFT OUTER JOIN
  P53_data.FUNCTION_ISHIOKA AS F
ON
  AA.AAchange_ID = F.AAchangeID
LEFT OUTER JOIN
  P53_data.SpliceAI_Prediction AS SA
ON
  M.c_description = SA.cDNA
LEFT OUTER JOIN
  GERMLINE_CASE_COUNT AS GCC
ON
  GCC.MUT_ID = M.MUT_ID
LEFT OUTER JOIN
  SOMATIC_CASE_COUNT AS SCC
ON
  SCC.MUT_ID = M.MUT_ID
LEFT OUTER JOIN
  CELLLINE_CASE_COUNT AS CCC
ON
  CCC.MUT_ID = M.MUT_ID
WHERE
  (M.CompleteDescription = TRUE)
ORDER BY
  P.MUT_ID;
DROP VIEW IF EXISTS
  ETL.SomaticView_query;
CREATE VIEW
  ETL.SomaticView_query AS
SELECT
  SM.Mutation_ID,
  MU.MUT_ID,
  LO.hg18_Chr17_coordinates,
  LO.hg19_Chr17_coordinates,
  LO.hg38_Chr17_coordinates,
  LO.ExonIntron,
  LO.Codon_number,
  LO.Genomic_nt,
  MU.Description,
  MU.c_description,
  MU.g_description,
  MU.g_description_GRCh38,
  AA.ProtDescription,
  MU.COSMIClink,
  MU.CLINVARlink,
  MU.TCGA_ICGC_GENIE_count,
  MU.cBioportalCount,
  LO.Splice_site,
  LO.CpG_site,
  LO.Context_coding_3,
  TY.Type,
  LO.Base_number AS WT_nucleotide,
  MU.Mutant_nucleotide,
  MU.Mut_rate,
  SE.WT_codon,
  MU.Mutant_codon,
  SE.WT_AA,
  GC.Amino_Acid AS Mutant_AA,
  AA.Mut_rateAA,
  ED.Effect,
  MU.Polymorphism,
  AA.AGVGDClass,
  AA.SIFTClass,
  AA.Polyphen2,
  AA.REVEL,
  AA.BayesDel,
  AA.StructureFunctionClass,
  AA.TransactivationClass,
  AA.DNE_LOFclass,
  AA.DNEclass,
  SE.Hotspot,
  SE.Structural_motif,
  SS.Sample_Name,
  SS.Sample_ID,
  SSD.Sample_source,
  TOD.Tumor_origin,
  TD.Topography,
  TD.Short_topo,
  TD.Topo_code,
  SD.Sub_topography,
  MD.Morphology,
  MD.Morpho_code,
  SS.Grade,
  SS.Stage,
  SS.TNM,
  SS.p53_IHC,
  SS.KRAS_status,
  SS.Other_mutations,
  SS.Other_associations,
  SS.Add_Info,
  SI.Individual_ID,
  SI.Sex,
  SS.Age,
  SI.Ethnicity,
  CD.Country,
  CD.Population,
  CD.Region,
  CD.Development,
  SI.Geo_area,
  SI.TP53polymorphism,
  SI.Germline_mutation,
  SI.Family_history,
  TOB.Tobacco,
  AD.Alcohol,
  EXD.Exposure,
  SI.Infectious_agent,
  SR.Ref_ID,
  SR.PubMed,
  SR.Exclude_analysis,
  SR.WGS_WXS,
  AA.AAchange_ID,
  TY.Type_ID,
  ED.Effect_ID,
  CD.Country_ID,
  SR.Cross_Ref_ID,
  SR.Comment,
  SR.Start_material,
  SR.exon2,
  SR.exon3,
  SR.exon4,
  SR.exon5,
  SR.exon6,
  SR.exon7,
  SR.exon8,
  SR.exon9,
  SR.exon10,
  SR.exon11,
  FI.WAF1nWT,
  FI.MDM2nWT,
  FI.BAXnWT,
  FI.h1433snWT,
  FI.AIP1nWT,
  FI.GADD45nWT,
  FI.NOXAnWT,
  FI.P53R2nWT,
  MG.Morphogroup,
  TOB.Tobacco_search,
  AD.Alcohol_search,
  AA.AAchange,
  SSD.Sample_source_group,
  TOD.Tumor_origin_group
FROM
  P53_data.S_INDIVIDUAL AS SI
INNER JOIN
  P53_data.Country_dic AS CD
ON
  SI.Country_ID = CD.Country_ID
  AND SI.Country_ID = CD.Country_ID
INNER JOIN
  P53_data.S_REFERENCE AS SR
ON
  SI.Ref_ID = SR.Ref_ID
  AND SI.Ref_ID = SR.Ref_ID
INNER JOIN
  P53_data.S_SAMPLE AS SS
ON
  SI.Individual_ID = SS.Individual_ID
INNER JOIN
  P53_data.Morphology_dic AS MD
INNER JOIN
  P53_data.Morphogroup_dic AS MG
ON
  MD.Morphogroup_ID = MG.Morphogroup_ID
  AND MD.Morphogroup_ID = MG.Morphogroup_ID
ON
  SS.Morpho_ID = MD.Morphology_ID
INNER JOIN
  P53_data.AA_change AS AA
INNER JOIN
  P53_data.MUTATION AS MU
ON
  AA.AAchange_ID = MU.AAchangeID
INNER JOIN
  P53_data.Effect_dic AS ED
ON
  MU.Effect_ID = ED.Effect_ID
INNER JOIN
  P53_data.Genetic_code AS GC
ON
  MU.Mutant_codon = GC.Codon
INNER JOIN
  P53_data.Location AS LO
ON
  MU.Location_ID = LO.Location_ID
INNER JOIN
  P53_data.p53_sequence AS SE
ON
  LO.Codon_number = SE.Codon_number
  AND LO.Codon_number = SE.Codon_number
INNER JOIN
  P53_data.S_MUTATION AS SM
ON
  MU.MUT_ID = SM.MUT_ID
ON
  SS.Sample_ID = SM.Sample_ID
  AND SS.Sample_ID = SM.Sample_ID
INNER JOIN
  P53_data.Sample_source_dic AS SSD
ON
  SS.Sample_source_ID = SSD.Sample_source_ID
  AND SS.Sample_source_ID = SSD.Sample_source_ID
INNER JOIN
  P53_data.Subtopography_dic AS SD
ON
  SS.Subtopo_ID = SD.Subtopo_ID
  AND SS.Subtopo_ID = SD.Subtopo_ID
INNER JOIN
  P53_data.Topography_dic AS TD
ON
  SD.Topo_code = TD.Topo_code
  AND SD.Topo_code = TD.Topo_code
INNER JOIN
  P53_data.Tumor_origin_dic AS TOD
ON
  SS.Tumor_origin_ID = TOD.Tumor_origin_ID
  AND SS.Tumor_origin_ID = TOD.Tumor_origin_ID
INNER JOIN
  P53_data.Type_dic AS TY
ON
  MU.Type_ID = TY.Type_ID
INNER JOIN
  P53_data.Exposure_dic AS EXD
ON
  SI.Exposure_ID = EXD.Exposure_ID
INNER JOIN
  P53_data.Alcohol_dic AS AD
ON
  SI.Alcohol_ID = AD.Alcohol_ID
INNER JOIN
  P53_data.Tobacco_dic AS TOB
ON
  SI.Tobacco_ID = TOB.Tobacco_ID
LEFT OUTER JOIN
  P53_data.FUNCTION_ISHIOKA AS FI
ON
  AA.AAchange_ID = FI.AAchangeID
WHERE
  (SR.Exclude_analysis = FALSE)
  AND (SR.Ref_ID != 2636)
  AND (SR.Ref_ID != 2637)
  AND (SR.Ref_ID != 2638)
ORDER BY
  TD.Short_topo,
  MD.Morphology,
  SR.Ref_ID;