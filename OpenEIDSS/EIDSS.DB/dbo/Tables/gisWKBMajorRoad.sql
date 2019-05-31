﻿CREATE TABLE [dbo].[gisWKBMajorRoad] (
    [idfsGeoObject]        BIGINT           NOT NULL,
    [strCode]              NVARCHAR (256)   NULL,
    [NameEng]              NVARCHAR (256)   NULL,
    [NameRu]               NVARCHAR (256)   NULL,
    [Type]                 NVARCHAR (256)   NULL,
    [Code]                 NVARCHAR (256)   NULL,
    [idfsCountry]          BIGINT           NULL,
    [geomShape]            [sys].[geometry] NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKgisWKBMajorRoad] PRIMARY KEY CLUSTERED ([idfsGeoObject] ASC),
    CONSTRAINT [FK_gisWKBMajorRoad_gisCountry] FOREIGN KEY ([idfsCountry]) REFERENCES [dbo].[gisCountry] ([idfsCountry]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisWKBMajorRoad_gisOtherBaseReference] FOREIGN KEY ([idfsGeoObject]) REFERENCES [dbo].[gisOtherBaseReference] ([idfsGISOtherBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisWKBMajorRoad_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE SPATIAL INDEX [IX_gisWKBMajorRoad_geomShape]
    ON [dbo].[gisWKBMajorRoad] ([geomShape])
    USING GEOMETRY_GRID
    WITH  (
            BOUNDING_BOX = (XMAX = 9494360, XMIN = 2468130, YMAX = 7408860, YMIN = 3502220),
            GRIDS = (LEVEL_1 = MEDIUM, LEVEL_2 = MEDIUM, LEVEL_3 = MEDIUM, LEVEL_4 = MEDIUM)
          );


GO

CREATE TRIGGER [dbo].[TR_gisWKBMajorRoad_A_Update] ON [dbo].[gisWKBMajorRoad]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsGeoObject))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
