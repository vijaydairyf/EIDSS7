﻿CREATE TYPE [dbo].[SampleTableType] AS TABLE (
    [SampleID]                       BIGINT         NOT NULL,
    [SampleTypeID]                   BIGINT         NOT NULL,
    [RootSampleID]                   BIGINT         NULL,
    [OriginalSampleID]               BIGINT         NULL,
    [HumanID]                        BIGINT         NULL,
    [SpeciesID]                      BIGINT         NULL,
    [AnimalID]                       BIGINT         NULL,
    [MonitoringSessionID]            BIGINT         NULL,
    [FieldCollectedByPersonID]       BIGINT         NULL,
    [FieldCollectedByOrganizationID] BIGINT         NULL,
    [MainTestID]                     BIGINT         NULL,
    [FieldCollectionDate]            DATETIME       NULL,
    [FieldSentDate]                  DATETIME       NULL,
    [FieldSampleEIDSSID]             NVARCHAR (200) NULL,
    [VectorSessionID]                BIGINT         NULL,
    [VectorID]                       BIGINT         NULL,
    [FreezerID]                      BIGINT         NULL,
    [SampleStatusTypeID]             BIGINT         NULL,
    [DepartmentID]                   BIGINT         NULL,
    [DestroyedByPersonID]            BIGINT         NULL,
    [EnteredDate]                    DATETIME       NULL,
    [DestructionDate]                DATETIME       NULL,
    [LaboratorySampleEIDSSID]        NVARCHAR (200) NULL,
    [Note]                           NVARCHAR (500) NULL,
    [SiteID]                         BIGINT         NOT NULL,
    [RowStatus]                      INT            NOT NULL,
    [FieldSentToOrganizationID]      BIGINT         NULL,
    [ReadOnlyIndicator]              BIT            NOT NULL,
    [BirdStatusTypeID]               BIGINT         NULL,
    [HumanDiseaseReportID]           BIGINT         NULL,
    [VeterinaryDiseaseReportID]      BIGINT         NULL,
    [AccessionDate]                  DATETIME       NULL,
    [AccessionConditionTypeID]       BIGINT         NULL,
    [AccessionComment]               NVARCHAR (200) NULL,
    [AccessionByPersonID]            BIGINT         NULL,
    [DestructionMethodTypeID]        BIGINT         NULL,
    [CurrentSiteID]                  BIGINT         NULL,
    [SampleKindTypeID]               BIGINT         NULL,
    [AccessionIndicator]             BIT            NULL,
    [MarkedForDispositionByPersonID] BIGINT         NULL,
    [OutOfRepositoryDate]            DATETIME       NULL,
    [MaintenanceFlag]                NVARCHAR (20)  NULL,
    [RecordAction]                   NCHAR (1)      NULL,
    PRIMARY KEY CLUSTERED ([SampleID] ASC));

