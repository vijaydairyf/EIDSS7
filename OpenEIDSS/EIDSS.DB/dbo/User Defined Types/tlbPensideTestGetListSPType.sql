﻿CREATE TYPE [dbo].[tlbPensideTestGetListSPType] AS TABLE (
    [idfPensideTest]          BIGINT         NOT NULL,
    [idfMaterial]             BIGINT         NOT NULL,
    [strFieldBarcode]         NVARCHAR (200) NULL,
    [SampleTypeName]          NVARCHAR (200) NULL,
    [idfSpecies]              BIGINT         NULL,
    [SpeciesTypeName]         NVARCHAR (200) NULL,
    [idfAnimal]               BIGINT         NULL,
    [strAnimalCode]           NVARCHAR (200) NULL,
    [idfsPensideTestResult]   BIGINT         NULL,
    [TestResultTypeName]      NVARCHAR (200) NULL,
    [idfsPensideTestName]     BIGINT         NULL,
    [TestNameTypeName]        NVARCHAR (200) NULL,
    [intRowStatus]            INT            NOT NULL,
    [idfTestedByPerson]       BIGINT         NULL,
    [TestedByPersonName]      NVARCHAR (200) NULL,
    [idfTestedByOffice]       BIGINT         NULL,
    [SiteName]                NVARCHAR (200) NULL,
    [idfsDiagnosis]           BIGINT         NULL,
    [strIDC10]                NVARCHAR (200) NULL,
    [datTestDate]             DATETIME       NULL,
    [idfsPensideTestCategory] BIGINT         NULL,
    [TestCategoryTypeName]    NVARCHAR (200) NULL,
    [strMaintenanceFlag]      NVARCHAR (20)  NULL,
    [RecordAction]            NCHAR (1)      NULL,
    PRIMARY KEY CLUSTERED ([idfPensideTest] ASC));

