﻿CREATE TABLE [dbo].[gisWKBHighway] (
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
    CONSTRAINT [XPKgisWKBHighway] PRIMARY KEY CLUSTERED ([idfsGeoObject] ASC),
    CONSTRAINT [FK_gisWKBHighway_gisCountry] FOREIGN KEY ([idfsCountry]) REFERENCES [dbo].[gisCountry] ([idfsCountry]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisWKBHighway_gisOtherBaseReference] FOREIGN KEY ([idfsGeoObject]) REFERENCES [dbo].[gisOtherBaseReference] ([idfsGISOtherBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisWKBHighway_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE SPATIAL INDEX [IX_gisWKBHighway_geomShape]
    ON [dbo].[gisWKBHighway] ([geomShape])
    USING GEOMETRY_GRID
    WITH  (
            BOUNDING_BOX = (XMAX = 9641230, XMIN = 2467970, YMAX = 7435920, YMIN = 3507630),
            GRIDS = (LEVEL_1 = MEDIUM, LEVEL_2 = MEDIUM, LEVEL_3 = MEDIUM, LEVEL_4 = MEDIUM)
          );


GO

CREATE TRIGGER [dbo].[TR_gisWKBHighway_A_Update] ON [dbo].[gisWKBHighway]
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
