USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_DAS_MYCOLLECTIONS_GETList]    Script Date: 5/6/2019 6:44:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*************************************************************
-- Name 				: USP_DAS_MYCOLLECTIONS_GETList
-- Description			: Returns a list of vectors surveillance sessions collected by a user
--          
-- Author               : Ricky Moss
-- Revision History
-- Name			Date		Change Detail
-- ---------------------------------------------------------------
-- Ricky Moss	11/28/2018	Initial Release
-- Ricky Moss	05/06/2019  Added Pagination
-- Testing code:
-- EXEC USP_DAS_MYCOLLECTIONS_GETList 'en', 55429560000000, 1, 10, 10
-- EXEC USP_DAS_MYCOLLECTIONS_GETList 'en', 55423020000000, 1, 10, 10
--*************************************************************
ALTER PROCEDURE [dbo].[USP_DAS_MYCOLLECTIONS_GETList]
(
	@langId NVARCHAR(50),
	@idfPerson BIGINT, 
	@PaginationSet INT = 1,
	@PageSize INT = 10,
	@MaxPagesPerFetch INT = 10  
)
AS
BEGIN
	BEGIN TRY
		SELECT DISTINCT	vss.idfVectorSurveillanceSession,
				strSessionID,
				datCollectionDateTime AS datEnteredDate,
				strVectors,  
				strDiagnoses AS strDisease,
				datStartDate, 
				strRegion,
				strRayon
		FROM	dbo.FN_VCTS_VSSESSION_GetList(@langId) vss
		JOIN	tlbVector v on vss.idfVectorSurveillanceSession = v.idfVectorSurveillanceSession
		WHERE	vss.idfsVectorSurveillanceStatus = 10310001 and v.idfCollectedByPerson = @idfPerson
		ORDER BY strSessionID OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS
				FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
