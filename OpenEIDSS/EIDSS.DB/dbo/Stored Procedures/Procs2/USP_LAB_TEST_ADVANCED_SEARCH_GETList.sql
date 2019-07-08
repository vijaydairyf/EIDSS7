﻿-- ================================================================================================
-- Name: USP_LAB_TEST_ADVANCED_SEARCH_GETList
--
-- Description:	Get laboratory tests list for the various lab use cases.
--
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     02/21/2019 Initial release.
-- Stephen Long     03/28/2019 Added EIDSS local/field sample ID field.
-- Stephen Long     04/27/2019 Added EIDSS batch ID, observation ID and batch status type name for 
--                             additional test information.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_TEST_ADVANCED_SEARCH_GETList] (
	@LanguageID NVARCHAR(50),
	@UserID BIGINT,
	@SiteID BIGINT,
	@ReportSessionType NVARCHAR(50) = NULL,
	@SurveillanceTypeID BIGINT = NULL,
	@SampleStatusTypeID NVARCHAR(MAX) = NULL,
	@AccessionedIndicator INT = NULL,
	@EIDSSLocalFieldSampleID NVARCHAR(200) = NULL,
	@ExactMatchEIDSSLocalFieldSampleID NVARCHAR(200) = NULL,
	@EIDSSReportCampaignSessionID NVARCHAR(200) = NULL,
	@SentToOrganizationID BIGINT = NULL,
	@TransferredToOrganizationID BIGINT = NULL,
	@EIDSSTransferID NVARCHAR(200) = NULL,
	@ResultsReceivedFromID BIGINT = NULL,
	@AccessionDateFrom DATETIME = NULL,
	@AccessionDateTo DATETIME = NULL,
	@EIDSSLaboratorySampleID NVARCHAR(200) = NULL,
	@SampleTypeID BIGINT = NULL,
	@TestNameTypeID BIGINT = NULL,
	@DiseaseID BIGINT = NULL,
	@TestStatusTypeID BIGINT = NULL,
	@TestResultTypeID BIGINT = NULL,
	@TestResultDateFrom DATETIME = NULL,
	@TestResultDateTo DATETIME = NULL,
	@PatientName NVARCHAR(200) = NULL,
	@FarmOwnerName NVARCHAR(200) = NULL,
	@SpeciesTypeID BIGINT = NULL,
	@PaginationSet INT = 1,
	@PageSize INT = 10,
	@MaxPagesPerFetch INT = 10
	)
AS
BEGIN
	DECLARE @returnCode INT = 0;
	DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SET NOCOUNT ON;

		DECLARE @favorites XML;

		SET @favorites = (
				SELECT PreferenceDetail
				FROM dbo.UserPreference Laboratory
				WHERE idfUserID = @UserID
					AND ModuleConstantID = 10508006
					AND intRowStatus = 0
				);

		DECLARE @CampaignID AS NVARCHAR(200);

		SET @CampaignID = NULL;

		--Campaign ID entered
		IF NOT @EIDSSReportCampaignSessionID IS NULL
			AND @EIDSSReportCampaignSessionID <> ''
		BEGIN
			IF (
					LEFT(@EIDSSReportCampaignSessionID, 1) = 'D'
					OR LEFT(@EIDSSReportCampaignSessionID, 3) = 'HSC'
					)
			BEGIN
				SET @CampaignID = @EIDSSReportCampaignSessionID;
				SET @EIDSSReportCampaignSessionID = NULL;
			END;
		END;

		WITH Favorites
		AS (
			SELECT SampleID = UserPref.value('@SampleID', 'BIGINT')
			FROM @favorites.nodes('/Favorites/Favorite') AS Tbl(UserPref)
			)
		SELECT t.idfTesting AS TestID,
			CASE 
				WHEN f.SampleID IS NULL
					THEN 0
				ELSE 1
				END AS FavoriteIndicator,
			t.idfsTestName AS TestNameTypeID,
			t.idfsTestCategory AS TestCategoryTypeID,
			t.idfsTestResult AS TestResultTypeID,
			t.idfsTestStatus AS TestStatusTypeID,
			t.PreviousTestStatusID AS PreviousTestStatusTypeID,
			(
				CASE 
					WHEN (NOT ISNULL(m.idfMonitoringSession, '') = '')
						THEN msDisease.idfsReference
					WHEN (NOT ISNULL(m.idfHumanCase, '') = '')
						THEN hdrDisease.idfsReference
					WHEN (NOT ISNULL(m.idfVetCase, '') = '')
						THEN vdrDisease.idfsReference
					WHEN (NOT ISNULL(m.DiseaseID, '') = '')
						THEN sampleDisease.idfsReference
					ELSE ''
					END
				) AS DiseaseID,
			m.idfMaterial AS SampleID,
			m.idfRootMaterial AS RootSampleID,
			m.idfParentMaterial AS ParentSampleID,
			t.idfBatchTest AS BatchTestID,
			t.idfObservation AS ObservationID,
			t.intTestNumber AS TestNumber,
			t.strNote AS Note,
			t.datStartedDate AS StartedDate,
			t.datConcludedDate AS ResultDate,
			t.idfTestedByOffice AS TestedByOrganizationID,
			t.idfTestedByPerson AS TestedByPersonID,
			t.idfResultEnteredByOffice AS ResultEnteredByOrganizationID,
			t.idfResultEnteredByPerson AS ResultEnteredByPersonID,
			t.idfValidatedByOffice AS ValidatedByOrganizationID,
			t.idfValidatedByPerson AS ValidatedByPersonID,
			t.blnReadOnly AS ReadOnlyIndicator,
			t.blnNonLaboratoryTest AS NonLaboratoryTestIndicator,
			IIF((
					SELECT COUNT(tom.idfMaterial)
					FROM dbo.tlbTransferOutMaterial tom
					INNER JOIN dbo.tlbTransferOUT AS tr
						ON tr.idfTransferOut = tom.idfTransferOut
					WHERE (
							tr.idfsTransferStatus = 10001001
							OR tr.idfsTransferStatus = 10001004
							)
						AND tom.idfMaterial = t.idfMaterial
					) = 0, 0, 1) AS ExternalTestIndicator,
			t.idfPerformedByOffice AS PerformedByOrganizationID,
			t.datReceivedDate AS ReceivedDate,
			t.strContactPerson AS ContactPersonName,
			m.strCalculatedCaseID AS EIDSSReportSessionID,
			m.strCalculatedHumanName AS PatientFarmOwnerName,
			sampleType.name AS SampleTypeName,
			(
				CASE 
					WHEN (NOT ISNULL(m.idfMonitoringSession, '') = '')
						THEN msDisease.name
					WHEN (NOT ISNULL(m.idfHumanCase, '') = '')
						THEN hdrDisease.name
					WHEN (NOT ISNULL(m.idfVetCase, '') = '')
						THEN vdrDisease.name
					WHEN (NOT ISNULL(m.DiseaseID, '') = '')
						THEN sampleDisease.name
					ELSE ''
					END
				) AS DiseaseName,
			m.strBarcode AS EIDSSLaboratorySampleID,
			m.strFieldBarcode AS EIDSSLocalFieldSampleID,
			testNameType.name AS TestNameTypeName,
			testStatusType.name AS TestStatusTypeName,
			testResultType.name AS TestResultTypeName,
			testCategoryType.name AS TestCategoryTypeName,
			m.datAccession AS AccessionDate,
			functionalArea.name AS FunctionalAreaName,
			m.idfsAccessionCondition AS AccessionConditionTypeID,
			m.idfsSampleStatus AS SampleStatusTypeID,
			(
				CASE 
					WHEN m.blnAccessioned = 0
						THEN 'Un-accessioned'
					WHEN m.idfsSampleStatus IS NULL
						THEN accessionConditionType.name
					WHEN m.idfsSampleStatus = 10015007
						THEN accessionConditionType.name
					ELSE sampleStatusType.name
					END
				) AS AccessionConditionOrSampleStatusTypeName,
			m.strCondition AS AccessionComment,
			a.strAnimalCode AS EIDSSAnimalID,
			testedByOrganization.FullName AS TestedByOrganizationName,
			ISNULL(testedByPerson.strFamilyName, N'') + ISNULL(' ' + testedByPerson.strFirstName, '') + ISNULL(' ' + testedByPerson.strSecondName, '') AS TestedByPersonName,
			resultEnteredByOrganization.FullName AS ResultEnteredByOrganizationName,
			ISNULL(resultEnteredByPerson.strFamilyName, N'') + ISNULL(' ' + resultEnteredByPerson.strFirstName, '') + ISNULL(' ' + resultEnteredByPerson.strSecondName, '') AS ResultEnteredByPersonName,
			u.idfUserID AS ResultEnteredByPersonUserID,
			targetSite.idfsSite AS ResultEnteredByPersonSiteID,
			targetSite.idfsSiteType AS ResultEnteredByPersonSiteTypeID,
			ISNULL(validatedByPerson.strFamilyName, N'') + ISNULL(' ' + validatedByPerson.strFirstName, '') + ISNULL(' ' + validatedByPerson.strSecondName, '') AS ValidatedByPersonName,
			performedByOrganization.FullName AS PerformedByOrganizationName,
			IIF(COUNT(tom.idfMaterial) > 0, 1, 0) AS TransferCount,
			tro.idfTransferOut AS TransferID,
			b.strBarcode AS EIDSSBatchTestID, 
			b.idfsTestName AS BatchTestTestNameTypeID, 
			b.idfObservation AS QualityControlValuesObservationID,
			batchStatusType.name AS BatchStatusTypeName, 
			t.intRowStatus AS RowStatus,
			'' AS RowAction,
			0 AS RowSelectionIndicator
		FROM dbo.tlbMaterial m
		INNER JOIN dbo.tlbTesting AS t
			ON t.idfMaterial = m.idfMaterial
		LEFT JOIN dbo.tlbBatchTest AS b
			ON b.idfBatchTest = t.idfBatchTest AND b.intRowStatus = 0
		LEFT JOIN Favorites AS f
			ON m.idfMaterial = f.SampleID
		LEFT JOIN dbo.tlbTransferOutMaterial AS tom
			ON tom.idfMaterial = m.idfMaterial
		LEFT JOIN dbo.tlbTransferOUT AS tro
			ON tro.idfTransferOut = tom.idfTransferOut
		LEFT JOIN dbo.tlbAnimal AS a
			ON a.idfAnimal = m.idfAnimal
		LEFT JOIN dbo.tlbHumanCase AS hc
			ON hc.idfHumanCase = m.idfHumanCase
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS hdrDisease
			ON hdrDisease.idfsReference = hc.idfsFinalDiagnosis
		LEFT JOIN dbo.tlbVetCase AS vc
			ON vc.idfVetCase = m.idfVetCase
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS vdrDisease
			ON vdrDisease.idfsReference = vc.idfsFinalDiagnosis
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS sampleDisease
			ON sampleDisease.idfsReference = m.DiseaseID
		LEFT JOIN dbo.tlbMonitoringSession AS ms
			ON ms.idfMonitoringSession = m.idfMonitoringSession
		LEFT JOIN dbo.tlbCampaign AS c
			ON c.idfCampaign = ms.idfCampaign
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS msDisease
			ON msDisease.idfsReference = ms.idfsDiagnosis
		LEFT JOIN dbo.tlbDepartment AS d
			ON d.idfDepartment = m.idfInDepartment
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000164) AS functionalArea
			ON functionalArea.idfsReference = d.idfsDepartmentName
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000087) AS sampleType
			ON sampleType.idfsReference = m.idfsSampleType
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000097) AS testNameType
			ON testNameType.idfsReference = t.idfsTestName
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000001) AS testStatusType
			ON testStatusType.idfsReference = t.idfsTestStatus
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000096) AS testResultType
			ON testResultType.idfsReference = t.idfsTestResult
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000095) AS testCategoryType
			ON testCategoryType.idfsReference = t.idfsTestCategory
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000110) AS accessionConditionType
			ON accessionConditionType.idfsReference = m.idfsAccessionCondition
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000015) AS sampleStatusType
			ON sampleStatusType.idfsReference = m.idfsSampleStatus
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000001) AS batchStatusType
			ON batchStatusType.idfsReference = b.idfsBatchStatus
		LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS testedByOrganization
			ON testedByOrganization.idfOffice = t.idfTestedByOffice
		LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS resultEnteredByOrganization
			ON resultEnteredByOrganization.idfOffice = t.idfResultEnteredByOffice
		LEFT JOIN dbo.tlbPerson AS testedByPerson
			ON testedByPerson.idfPerson = t.idfTestedByPerson
		LEFT JOIN dbo.tlbPerson AS resultEnteredByPerson
			ON resultEnteredByPerson.idfPerson = t.idfResultEnteredByPerson
		LEFT JOIN dbo.tstUserTable AS u
			ON u.idfPerson = t.idfResultEnteredByPerson
		LEFT JOIN dbo.tstSite AS targetSite
			ON targetSite.idfsSite = u.idfsSite
		LEFT JOIN dbo.tlbPerson AS validatedByPerson
			ON validatedByPerson.idfPerson = t.idfValidatedByPerson
		LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS performedByOrganization
			ON performedByOrganization.idfOffice = t.idfPerformedByOffice
		LEFT JOIN dbo.tlbFarm AS farm
			ON farm.idfFarm = vc.idfFarm
		LEFT JOIN dbo.tlbHerd AS herd
			ON herd.idfFarm = farm.idfFarm
		LEFT JOIN dbo.tlbSpecies AS species
			ON species.idfHerd = herd.idfHerd
		WHERE (t.intRowStatus = 0)
			AND (m.intRowStatus = 0)
			AND (
				(m.idfsSite = @SiteID)
				OR (@SiteID IS NULL)
				)
			AND (m.idfsSampleType <> 10320001)
			AND (
				(
					@ReportSessionType = 10012001
					AND m.idfHuman IS NOT NULL
					)
				OR (
					@ReportSessionType = 10012006
					AND m.idfVectorSurveillanceSession IS NOT NULL
					)
				OR (
					@ReportSessionType = 10012005
					AND m.idfVetCase IS NOT NULL
					)
				OR (@ReportSessionType IS NULL)
				)
			AND (
				(
					(@SurveillanceTypeID = 4578940000001)
					AND (
						m.idfMonitoringSession IS NOT NULL
						OR m.idfVectorSurveillanceSession IS NOT NULL
						)
					)
				OR (
					(@SurveillanceTypeID = 50815490000000)
					AND (
						m.idfHumanCase IS NOT NULL
						OR m.idfVetCase IS NOT NULL
						OR m.idfMonitoringSession IS NOT NULL
						OR m.idfVectorSurveillanceSession IS NOT NULL
						)
					)
				OR (
					(@SurveillanceTypeID = 4578940000002)
					AND (
						m.idfHumanCase IS NOT NULL
						OR m.idfVetCase IS NOT NULL
						)
					)
				OR (@SurveillanceTypeID IS NULL)
				)
			AND (
				(m.blnAccessioned = @AccessionedIndicator)
				OR (@AccessionedIndicator IS NULL)
				)
			AND (
				(m.idfsSampleStatus IN (@SampleStatusTypeID))
				OR (@SampleStatusTypeID IS NULL)
				)
			AND (
				(m.idfSendToOffice = @SentToOrganizationID)
				OR (@SentToOrganizationID IS NULL)
				)
			AND (
				(tro.idfSendToOffice = @TransferredToOrganizationID)
				OR (@TransferredToOrganizationID IS NULL)
				)
			AND (
				(t.idfTestedByOffice = @ResultsReceivedFromID)
				OR (@ResultsReceivedFromID IS NULL)
				)
			AND (
				(
					m.datAccession BETWEEN @AccessionDateFrom
						AND @AccessionDateTo
					)
				OR (
					@AccessionDateFrom IS NULL
					OR @AccessionDateTo IS NULL
					)
				)
			AND (
				(m.idfsSampleType = @SampleTypeID)
				OR (@SampleTypeID IS NULL)
				)
			AND (
				(t.idfsTestName = @TestNameTypeID)
				OR (@TestNameTypeID IS NULL)
				)
			AND (
				(hc.idfsFinalDiagnosis = @DiseaseID)
				OR (vc.idfsFinalDiagnosis = @DiseaseID)
				OR (m.DiseaseID = @DiseaseID)
				OR (ms.idfsDiagnosis = @DiseaseID)
				OR (@DiseaseID IS NULL)
				)
			AND (
				(t.idfsTestStatus = @TestStatusTypeID)
				OR (@TestStatusTypeID IS NULL)
				)
			AND (
				(t.idfsTestResult = @TestResultTypeID)
				OR (@TestResultTypeID IS NULL)
				)
			AND (
				(species.idfsSpeciesType = @SpeciesTypeID)
				OR (@SpeciesTypeID IS NULL)
				)
			AND (
				(m.strFieldBarcode = @ExactMatchEIDSSLocalFieldSampleID)
				OR (@ExactMatchEIDSSLocalFieldSampleID IS NULL)
				)
			AND (
				(
					t.datConcludedDate BETWEEN @TestResultDateFrom
						AND @TestResultDateTo
					)
				OR (
					@TestResultDateFrom IS NULL
					OR @TestResultDateTo IS NULL
					)
				)
			AND (
				(m.strCalculatedCaseID LIKE '%' + @EIDSSReportCampaignSessionID + '%')
				OR (@EIDSSReportCampaignSessionID IS NULL)
				)
			AND (
				(m.strCalculatedHumanName LIKE '%' + @PatientName + '%')
				OR (@PatientName IS NULL)
				)
			AND (
				(m.strCalculatedHumanName LIKE '%' + @FarmOwnerName + '%')
				OR (@FarmOwnerName IS NULL)
				)
			AND (
				(c.strCampaignID LIKE '%' + @CampaignID + '%')
				OR (@CampaignID IS NULL)
				)
			AND (
				(t.idfsTestStatus = @TestStatusTypeID)
				OR (@TestStatusTypeID IS NULL)
				)
			AND (m.intRowStatus = 0)
			AND (
				(m.strFieldBarcode LIKE '%' + @EIDSSLocalFieldSampleID + '%')
				OR (
					@EIDSSLocalFieldSampleID IS NULL
					OR @EIDSSLocalFieldSampleID = ''
					)
				)
			AND (
				(tro.strBarcode LIKE '%' + @EIDSSTransferID + '%')
				OR (
					@EIDSSTransferID IS NULL
					OR @EIDSSTransferID = ''
					)
				)
			AND (
				(m.strBarcode LIKE '%' + @EIDSSLaboratorySampleID + '%')
				OR (
					@EIDSSLaboratorySampleID IS NULL
					OR @EIDSSLaboratorySampleID = ''
					)
				)
		GROUP BY m.idfMaterial,
			t.idfTesting,
			tro.idfTransferOut,
			t.idfsTestName,
			t.idfsTestCategory,
			t.idfsTestResult,
			t.idfsTestStatus,
			t.PreviousTestStatusID,
			t.idfBatchTest,
			m.idfRootMaterial,
			m.idfParentMaterial,
			b.strBarcode, 
			b.idfObservation, 
			b.idfsTestName,
			batchStatusType.name, 
			t.intTestNumber,
			t.idfObservation,
			t.strNote,
			t.datStartedDate,
			t.datConcludedDate,
			t.idfTestedByOffice,
			testedByOrganization.FullName,
			t.idfTestedByPerson,
			testedByPerson.strFamilyName,
			testedByPerson.strFirstName,
			testedByPerson.strSecondName,
			t.idfResultEnteredByOffice,
			resultEnteredByOrganization.FullName,
			t.idfResultEnteredByPerson,
			resultEnteredByPerson.strFamilyName,
			resultEnteredByPerson.strFirstName,
			resultEnteredByPerson.strSecondName,
			t.idfValidatedByOffice,
			t.idfValidatedByPerson,
			validatedByPerson.strFamilyName,
			validatedByPerson.strFirstName,
			validatedByPerson.strSecondName,
			t.blnReadOnly,
			t.blnNonLaboratoryTest,
			t.blnExternalTest,
			t.idfPerformedByOffice,
			performedByOrganization.FullName,
			t.datReceivedDate,
			t.strContactPerson,
			t.intRowStatus,
			f.SampleID,
			m.strCalculatedCaseID,
			m.strCalculatedHumanName,
			sampleType.name,
			m.strCalculatedCaseID,
			m.strCalculatedHumanName,
			m.strBarcode,
			m.strFieldBarcode, 
			testNameType.name,
			t.idfsTestStatus,
			testStatusType.name,
			t.datStartedDate,
			t.idfsTestResult,
			testResultType.name,
			datConcludedDate,
			t.idfsTestCategory,
			testCategoryType.name,
			m.datAccession,
			functionalArea.name,
			m.idfsAccessionCondition,
			accessionConditionType.name,
			m.idfsSampleStatus,
			sampleStatusType.name,
			m.strCondition,
			a.strAnimalCode,
			m.blnAccessioned,
			m.idfMonitoringSession,
			ms.idfMonitoringSession,
			ms.SessionCategoryID,
			m.idfHumanCase,
			m.idfVectorSurveillanceSession,
			m.idfVetCase,
			m.DiseaseID,
			u.idfUserID,
			targetSite.idfsSite,
			targetSite.idfsSiteType,
			sampleDisease.idfsReference,
			sampleDisease.name,
			msDisease.idfsReference,
			msDisease.name,
			hdrDisease.idfsReference,
			hdrDisease.name,
			vdrDisease.idfsReference,
			vdrDisease.name,
			t.idfMaterial
		ORDER BY m.strBarcode OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS

		FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode,
		@returnMsg;
END;