'**********************************************************************************************
'**********************************************************************************************
'ChartSyncBatchJobs.vbs
' Functions - See individual Function Headers for a detail description of function functionality
'	addressMatchInboundLoad 	' To Create Address Match Inbound file for the Input (Proj_key, File Name) passed and load on to System
'	BatchJobDBErrCodeCheck - InProgress		
'	BatchJobFileLoadCheck 		' After Running the Batch Job Verifying the Query Status thru DataBase
'	BatchJobFileLoadStatus - New	
'	CheckForBashString - Done		
'	CheckForBashStringWithOutAddin - Done		
'	CheckForTeScreenString - Done		
'	connectPutty - Done		
' 	connectPuttyWithOutAddin - New		
'	CreateDuplicateRuleFiles		
'	createProjectLoadFile		'To Generate a Project File with the Template passed as Input
'	DuplicateRuleCheck		
'	ExecuteCommand - Done		
'	FolderFiles - Done		
'	GetProc - Copied
'   getVisibleText      'Get text from a Window object (e.g., Putty) via obj.GetVisibleText		
'	loadChartImage		' To Load Charts of format chart|echart to the Project specified
'	loadDXInbound		' To Load Normal DX Inbound File for the project Specified
'	loadNewandUnique	' To Load New & Unique Inbound File for the Project/Chart as Specified
'   loginPutty          ' login to a unix server via Putty utility
'	loginVerifyPutty - Done		
' 	loginVerifyPuttyWithOutAddin - New		
'	PuttyWait - New		
'	randomDataGeneration       'This Will generate Random data as selected by user for ALPHANUMERIC, COMBINATION...
'	RandomNumberDateTime - Done		
'  	RandomNumberGeneration - Done	
'	RmChr - Copied		
'	RulesEngineDXlevelDBErrCodeCheck		
'	RulesEngineReport		
'	runCmdLine - Copied		

'**********************************************************************************************
'**********************************************************************************************
Option Explicit

'<@class_summary>
'**********************************************************************************************
' <@purpose>
'   This Class is used to interact with the Batch Job related Process
'   Execution of this Class File will create a ChartSyncBatchJobs Object automatically
'   Object Name equals "ChSyBatJob"
' </@purpose>
'
' <@author>
'	Govardhan Choletti, Ambavarapu Mrudula
' </@author>
'
' <@creation_date>
'   21-09-2011
' </@creation_date>
'
'**********************************************************************************************
'</@class_summary>

Class ChartSyncBatchJobs

	'<@comments>
	'**********************************************************************************************
	' <@name>RandomNumberGeneration</@name>
	'
	' <@purpose>
	'   Generates a Random Number which will be used for Member ID, Provider ID, HIC # in IRADS application
	'
	' </@purpose>
	'
	' <@parameters>
	'	None
	' </@parameters>
	'
	' <@return>
	'   Integer
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created 
	' </@assumptions>
	'
	' <@example_usage>ChSyBatJob.RandomNumberGeneration</@example_usage>
	'
	' <@author>Dhushanth S</@author>
	'
	' <@creation_date>03/29/2010</@creation_date>
	'
	' <@mod_block>
	'   Modifications: 09/23/2011 - Govardhan, Choletti - Customized for ChartSync application
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function RandomNumberGeneration ' <@as> Integer
	
	  Services.StartTransaction "RandomNumberGeneration" ' Timer Begin
	  Reporter.ReportEvent micDone, "RandomNumberGeneration", "Function Begin"
		
	  ' Variable Declaration / Initialization 
	  Dim iRndNo, iRndNo1, iRndNo2, iRandomNo
	   	
	  iRndNo = RandomNumber(999999, 999999999)
	  iRndNo1 = RandomNumber(1, 999)
	  iRndNo2 = RandomNumber(1, 9)
	  iRandomNo = Int((iRndNo1 * iRndNo) + iRndNo2)   ' Generate random number between 7 and 12.
	  RandomNumberGeneration = iRandomNo
		
	  Reporter.ReportEvent micDone, "RandomNumberGeneration", "Function End"
	  Services.EndTransaction "RandomNumberGeneration" ' Timer End
	 		
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>RandomNumberDateTime</@name>
	'
	' <@purpose>
	'   Generates a Random Number with  current date and time  which can be used for the field which need unique date in IRADS application
	'
	' </@purpose>
	'
	' <@parameters>
	'	None
	' </@parameters>
	'
	' <@return>
	'   String
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created 
	' </@assumptions>
	'
	' <@example_usage>ChSyBatJob.RandomNumberDateTime</@example_usage>
	'
	' <@author>Dhushanth S</@author>
	'
	' <@creation_date>04/26/2010</@creation_date>
	'
	' <@mod_block>
	'   Modifications: 09/23/2011 - Govardhan, Choletti - Customized for ChartSync application
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function RandomNumberDateTime ' <@as> String
	
	  Services.StartTransaction "RandomNumberDateTime" ' Timer Begin
	  Reporter.ReportEvent micDone, "RandomNumberDateTime", "Function Begin"
		
	  ' Variable Declaration / Initialization 
	  Dim iRndNo, iRndNo1, iRndNo2, iRandomNo
	   	
	  iRndNo = Now
	  iRndNo = Replace(iRndNo, "/", "")
	  iRndNo = Replace(iRndNo, ":", "")
	  iRndNo = Replace(iRndNo, " ", "")
	  
	  RandomNumberDateTime = iRndNo
		
	  Reporter.ReportEvent micDone, "RandomNumberDateTime", "Function End"
	  Services.EndTransaction "RandomNumberDateTime" ' Timer End
	 		
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>BatchJobFileLoadCheck</@name>
	'
	' <@purpose>
	'   verifies if the file is loaded and updated in the DB after running the Batch Job
	' </@purpose>
	'
	' <@parameters>
	'   sFileName (ByVal) = string - FileName to query the database
	' </@parameters>
	'
	' <@return>
	'   Boolean - -1 , If File N/A
	'              0 , If File Loaded and Process Status key is other than Specified
	'			   1 , If File Loaded and Process Status key is same as specified
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created 
	' </@assumptions>
	'
	' <@example_usage>ChSyBatJob.BatchJobFileLoadCheck("UHG_AMERIH0972_1298019")</@example_usage>
	'
	' <@author>Govardhan C</@author>
	'
	' <@creation_date>04/27/2010</@creation_date>
	'
	' <@mod_block>
	'	  Modifications: 09/23/2011 - Govardhan, Choletti - Customized for ChartSync application
	'					 09/24/2012 - Govardhan, Choletti - Can Work to test for all the File Loads
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>

	Public Function BatchJobFileLoadCheck(ByVal sFileName, ByVal iProcessKey) ' <@as> Boolean	
	  Services.StartTransaction "BatchJobFileLoadCheck" ' Timer Begin
	  Reporter.ReportEvent micDone, "BatchJobFileLoadCheck", "Function Begin"

	   ' Variable Declaration / Initialization
	   Dim sQuery, oRS, sFileNameDB
	   Dim iProcessKeyDB	
	   
	  'verifies that the passed parameter is not null or an empty string.
	  If IsNull(sFileName) Or sFileName = "" Then
	   	Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the BatchJobFileLoadCheck function check passed parameters"
	   	Services.EndTransaction "BatchJobFileLoadCheck" ' Timer End
	   	Exit Function
	  End If
	  
	  sQuery = "select file_name, process_sts_key from ravas.frmk_stg_fileinfo where file_name= '"&sFileName&"'"	
	
	  set oRS = db.executeDBQuery(sQuery, Environment.Value("DB"))	
		If LCase(typeName(oRS)) <> "recordset" Then
			Reporter.ReportEvent micFail, "invalid recordset", "The database connection did not open or invalid parameters were passed."
			BatchJobFileLoadCheck = -1
		ElseIf oRS.bof And oRS.eof Then
			Reporter.ReportEvent micWarning, "Project Load File", "Project File "&sFileName& " not uploaded in the db after executing upload job command"
			BatchJobFileLoadCheck = -1
		Else
			Reporter.ReportEvent micPass, "valid recordset", "The returned recordset is valid and contains records."
			sFileNameDB = oRS.fields(0).Value
			iProcessKeyDB = oRS.fields(1).Value
			
			'Check if the Error Code is updated correctly for the Encounter
			If Cint(iProcessKeyDB) = Cint(iProcessKey) Then
				Reporter.ReportEvent micPass, "File Upload", "File "&sFileName& " uploaded in the db after executing upload job command and Process Status Key is shown as '"& Cint(iProcessKeyDB) &"', as Expected"
				BatchJobFileLoadCheck = 1
			Else
				Reporter.ReportEvent micWarning, "File Upload", "File "&sFileName& " loaded on to the db after executing upload job command and Process Status Key is shown as '"& Cint(iProcessKeyDB) &"' instead of '"& Cint(iProcessKey) &"', Which is NOT as Expected"
				BatchJobFileLoadCheck = 0
			End If
		End If
	
	  Reporter.ReportEvent micDone, "BatchJobFileLoadCheck", "Function End"
	  Services.EndTransaction "BatchJobFileLoadCheck" ' Timer End
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>BatchJobFileLoadStatus</@name>
	'
	' <@purpose>
	'   verifies if the file is loaded and updated in the DB for Rules engine module
	' </@purpose>
	'
	' <@parameters>
	'   sFileName (ByVal) = string - FileName to query the database
	' </@parameters>
	'
	' <@return>
	'   Boolean - TRUE if pass
	'             FALSE if failed 
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created 
	' </@assumptions>
	'
	' <@example_usage>ChSyBatJob.BatchJobFileLoadStatus("UHG_AMERIH0972_1298019", 4)</@example_usage>
	'
	' <@author>Govardhan, Choletti</@author>
	'
	' <@creation_date>09/29/2011</@creation_date>
	'
	'**********************************************************************************************
	'</@comments>


	Public Function BatchJobFileLoadStatus(ByVal sFileName, ByVal sStatusKey) ' <@as> Boolean
		
	  Services.StartTransaction "BatchJobFileLoadStatus" ' Timer Begin
	  Reporter.ReportEvent micDone, "BatchJobFileLoadStatus", "Function Begin"

	   ' Variable Declaration / Initialization
	   Dim sQuery, oRS
	   Dim sFName, sKeyNoFromDB, sKeyValFromDB, sErrMsgFromDB
	   
	  'verifies that the passed parameter is not null or an empty string.
	  If IsNull(sFileName) Or sFileName = "" Then
	   	Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the BatchJobFileLoadStatus function check passed parameters"
	   	Services.EndTransaction "BatchJobFileLoadStatus" ' Timer End
	   	Exit Function
	  End If
	  
	  sQuery = "select file_name, process_sts_key, file_key from Ravas.frmk_stg_fileinfo where file_name='"&sFileName&"'"	
	
	  set oRS = db.executeDBQuery(sQuery, Environment.Value("DB"))	
		
		If LCase(typeName(oRS)) <> "recordset" Then
			Reporter.ReportEvent micFail, "invalid recordset", "The database connection did not open or invalid parameters were passed."
			BatchJobFileLoadStatus = FALSE
		ElseIf oRS.bof And oRS.eof Then
			Reporter.ReportEvent micFail, "invalid recordset", "File "&sFileName& " not uploaded in the db after executing upload job command"
			BatchJobFileLoadStatus = FALSE
		Else
			Reporter.ReportEvent micPass, "valid recordset", "The returned recordset is valid and contains records."
			BatchJobFileLoadStatus = TRUE

			sFName = oRS.fields("FILE_NAME").Value
			sKeyNoFromDB = oRS.fields("PROCESS_STS_KEY").Value
			sKeyValFromDB = oRS.fields("FILE_KEY").Value
			
			'Check if the Error Code is updated correctly for the Encounter
			If Trim(sFileName) = Trim(sFName) And Trim(sStatusKey) = Trim(sKeyNoFromDB) Then
				Reporter.ReportEvent micPass, "File Loaded", "File "&sFileName& " uploaded in the db with out any Error Messages with the Key value = "& sStatusKey &" after executing OutBound job command"
				BatchJobFileLoadStatus = TRUE
			ElseIf Trim(sFileName) = Trim(sFName) And Trim(sStatusKey) <> Trim(sKeyNoFromDB) Then
				' Get the Error Message and Print on the Reports
				sQuery = "select error_msg, file_nm from Ravas.frmk_stg_errors where file_key = " & sKeyValFromDB
				set oRS = db.executeDBQuery(sQuery, Environment.Value("DB"))
				If LCase(typeName(oRS)) <> "recordset" And oRS.bof And oRS.eof Then
					sErrMsgFromDB = oRS.fields("ERROR_MSG").Value
					Reporter.ReportEvent micFail, "File Loaded", "File "&sFileName& " uploaded in the db with Error Messages '"& sErrMsgFromDB &"' with the process Status Key value = "& sStatusKey &" after executing OutBound job command"
					BatchJobFileLoadStatus = FALSE
				Else
					Reporter.ReportEvent micFail, "File Loaded", "File "&sFileName& " uploaded in the db with the process Status Key value = "& sStatusKey &" after executing OutBound job command"
					BatchJobFileLoadStatus = FALSE
				End If
			Else
				Reporter.ReportEvent micFail, "File Upload", "File "&sFileName& " not uploaded in the db after executing OutBound job command"
				BatchJobFileLoadStatus = FALSE
			End If
		End If
	
	  Reporter.ReportEvent micDone, "BatchJobFileLoadStatus", "Function End"
	  Services.EndTransaction "BatchJobFileLoadStatus" ' Timer End
	End Function
	
	'<@comments>
	'**********************************************************************************************
	' <@name>BatchJobDBErrCodeCheck</@name>
	'
	' <@purpose>
	'   verifies the Error Code and Error Message in the DB for Rules engine module
	' </@purpose>
	'
	' <@parameters>
	'   sEncounterNo (ByVal) = string - Encounter No to query the database
	' </@parameters>
	'
	' <@return>
	'   None
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created 
	' </@assumptions>
	'
	' <@example_usage>ChSyBatJob.BatchJobDBErrCodeCheck("3487384dj983498" , "X02", "SNF")</@example_usage>
	'
	' <@author>Dhushanth S</@author>
	'
	' <@creation_date>03/30/2010</@creation_date>
	'
	' <@mod_block>
	'	  Modifications: 09/23/2011 - Govardhan, Choletti - Customized for ChartSync application
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>


	Sub BatchJobDBErrCodeCheck(ByVal sEncounterNo, ByVal sErrorCode, ByVal sErrorMessage) ' <@as> None
		
	  Services.StartTransaction "BatchJobDBErrCodeCheck" ' Timer Begin
	  Reporter.ReportEvent micDone, "BatchJobDBErrCodeCheck", "Function Begin"

	   ' Variable Declaration / Initialization
	   Dim sQuery, oRS
	   Dim sErCode, sErDesc, sDesc
	   
	  'verifies that the passed parameter is not null or an empty string.
	  If IsNull(sEncounterNo) Or sEncounterNo = "" Or IsNull(sErrorCode) Or sErrorCode = "" Or IsNull(sErrorMessage) Or sErrorMessage = ""Then
	   	Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the BatchJobDBErrCodeCheck function check passed parameters"
	   	Services.EndTransaction "BatchJobDBErrCodeCheck" ' Timer End
	   	Exit Sub
	  End If
	  
	  sQuery = "select er.error_cd,er.error_desc, ee.error_key, ee.encounter_key ,ee.active_flg, en.encounter_nbr from ir_encountererror ee, ir_error er,ir_encounter en  where ee.error_key=er.error_key and ee.active_flg='Y'and ee.encounter_key=en.encounter_key and en.encounter_nbr='"&sEncounterNo&"'"
	  'sQuery = "select er.error_cd,er.error_desc, ee.error_key, ee.encounter_key ,ee.active_flg, en.encounter_nbr from irads.ir_encountererror ee, irads.ir_error er,irads.ir_encounter en  where ee.error_key=er.error_key and ee.active_flg='Y'and ee.encounter_key=en.encounter_key and en.encounter_nbr='"&sEncounterNo&"'"	
	  
	  set oRS = db.executeDBQuery(sQuery, Environment.Value("DB"))	
		
		If LCase(typeName(oRS)) <> "recordset" Then
			Reporter.ReportEvent micFail, "invalid recordset", "The database connection did not open or invalid parameters were passed."
			sDesc = "The database connection did not open or invalid parameters were passed."
			RulesEngineReport sEncounterNo, "", "", sDesc, "Fail"
			ElseIf oRS.bof And oRS.eof Then
			Reporter.ReportEvent micFail, "invalid recordset", "The returned recordset contains no records."
			sDesc = "The returned recordset contains no records."
			RulesEngineReport sEncounterNo, "", "", sDesc, "Fail"
			Else
			Reporter.ReportEvent micPass, "valid recordset", "The returned recordset is valid and contains records."
			'sDesc = "The returned recordset is valid and contains records."
			'RulesEngineReport sEncounterNo, "", "", sDesc, "Pass"

			sErCode = oRS.fields("ERROR_CD").Value
			sErDesc = oRS.fields("ERROR_DESC").Value
			
			'Check if the Error Code is updated correctly for the Encounter
			If Trim(sErCode) = Trim(sErrorCode) Then
				Reporter.ReportEvent micPass, "DB_ErrorCode", "Error Code is updated as "&sErCode&" in the database for Encounter # "&sEncounterNo
				'sDesc = "Error Code is updated as "&sErCode&" in the database for Encounter # "&sEncounterNo
				'RulesEngineReport sEncounterNo, sErCode, "", sDesc, "Pass"							
			Else
				Reporter.ReportEvent micFail, "DB_ErrorCode", "Error Code is updated as "&sErCode&" instead of "&sErrorCode&" in the database for Encounter # "&sEncounterNo
				'sDesc = "Error Code is updated as "&sErCode&" instead of "&sErrorCode&" in the database for Encounter # "&sEncounterNo
				'RulesEngineReport sEncounterNo, sErCode, "", sDesc, "Fail"				
			End If
			
			'Check if the Error Message is updated correctly for the Encounter
			If Trim(sErDesc) = Trim(sErrorMessage) Then
				Reporter.ReportEvent micPass, "DB_ErrorMessage", "Error Message is updated as "&sErDesc&" in the database for Encounter # "&sEncounterNo
				'sDesc = "Error Message is updated as "&sErDesc&" in the database for Encounter # "&sEncounterNo
				'RulesEngineReport sEncounterNo, "", sErDesc, sDesc, "Pass"				
			Else
				Reporter.ReportEvent micFail, "DB_ErrorMessage", "Error Message is updated as "&sErDesc&" instead of "&sErrorMessage&" in the database for Encounter # "&sEncounterNo
				'sDesc = "Error Message is updated as "&sErDesc&" instead of "&sErrorMessage&" in the database for Encounter # "&sEncounterNo
				'RulesEngineReport sEncounterNo, "", sErDesc, sDesc, "Fail"				
			End If

			'Excel Reporting
			If Trim(sErCode) = Trim(sErrorCode) and Trim(sErDesc) = Trim(sErrorMessage) Then
				sDesc = "Error Code and Message is updated as expected in the database for the Encounter #"
				RulesEngineReport sEncounterNo, sErCode, sErDesc, sDesc, "Pass"							
			Else
				sDesc = "Error Code and Message is not updated as expected in the database for the Encounter # Expected ErrorCode = "&sErrorCode& " and Expected Error Message = "&sErrorMessage
				RulesEngineReport sEncounterNo, sErCode, sErDesc, sDesc, "Fail"
			End If							
		End If

	  Reporter.ReportEvent micDone, "BatchJobDBErrCodeCheck", "Function End"
	  Services.EndTransaction "BatchJobDBErrCodeCheck" ' Timer End
	End Sub	
	
	
	'<@comments>
	'**********************************************************************************************
	' <@name>RulesEngineDXlevelDBErrCodeCheck</@name>
	'
	' <@purpose>
	'   verifies the Error Code and Error Message in the DB for Rules engine module in the linelevel
	' </@purpose>
	'
	' <@parameters>
	'   sEncounterNo (ByVal) = string - Encounter No to query the database
	' </@parameters>
	'
	' <@return>
	'   None
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created 
	' </@assumptions>
	'
	' <@example_usage>ChSyBatJob..RulesEngineDXlevelDBErrCodeCheck("3487384dj983498" , "X17", "NONEQUAL")</@example_usage>
	'
	' <@author>Krishna .K</@author>
	'
	' <@creation_date>05/11/2010</@creation_date>
	'
	' <@mod_block>
	'
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>


	Sub RulesEngineDXlevelDBErrCodeCheck(ByVal sEncounterNo, ByVal sErrorCode, ByVal sErrorMessage) ' <@as> None
		
	  Services.StartTransaction "RulesEngineDXlevelDBErrCodeCheck" ' Timer Begin
	  Reporter.ReportEvent micDone, "RulesEngineDXlevelDBErrCodeCheck", "Function Begin"

	   ' Variable Declaration / Initialization
	   Dim sQuery, oRS
	   Dim sErCode, sErDesc, sDesc
	   
	  'verifies that the passed parameter is not null or an empty string.
	  If IsNull(sEncounterNo) Or sEncounterNo = "" Or IsNull(sErrorCode) Or sErrorCode = "" Or IsNull(sErrorMessage) Or sErrorMessage = ""Then
	   	Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the RulesEngineDXlevelDBErrCodeCheck function check passed parameters"
	   	Services.EndTransaction "RulesEngineDXlevelDBErrCodeCheck" ' Timer End
	   	Exit Sub
	  End If
	  
	  'sQuery = "select er.error_cd,er.error_desc, ee.error_key, ee.encounter_key ,ee.active_flg, en.encounter_nbr from ir_encountererror ee, ir_error er,ir_encounter en  where ee.error_key=er.error_key and ee.active_flg='Y'and ee.encounter_key=en.encounter_key and en.encounter_nbr='"&sEncounterNo&"'"
	  sQuery = "select  ie.error_cd,ie.error_desc from irads.ir_encounter ec,irads.ir_diagnosis id, irads.ir_diagnosiserror ide ,irads.ir_error ie where  ec.encounter_key =id.encounter_key and ide.diagnosis_key=id.diagnosis_key and ie.error_key=ide.error_key and ec.encounter_nbr='"&sEncounterNo&"'"	
	  
	  set oRS = db.executeDBQuery(sQuery, Environment.Value("DB"))	
		
		If LCase(typeName(oRS)) <> "recordset" Then
			Reporter.ReportEvent micFail, "invalid recordset", "The database connection did not open or invalid parameters were passed."
			sDesc = "The database connection did not open or invalid parameters were passed."
			RulesEngineReport sEncounterNo, "", "", sDesc, "Fail"
			ElseIf oRS.bof And oRS.eof Then
			Reporter.ReportEvent micFail, "invalid recordset", "The returned recordset contains no records."
			sDesc = "The returned recordset contains no records."
			RulesEngineReport sEncounterNo, "", "", sDesc, "Fail"
			Else
			Reporter.ReportEvent micPass, "valid recordset", "The returned recordset is valid and contains records."
			'sDesc = "The returned recordset is valid and contains records."
			'RulesEngineReport sEncounterNo, "", "", sDesc, "Pass"

			sErCode = oRS.fields("ERROR_CD").Value
			sErDesc = oRS.fields("ERROR_DESC").Value
			
			'Check if the Error Code is updated correctly for the Encounter
			If Trim(sErCode) = Trim(sErrorCode) Then
				Reporter.ReportEvent micPass, "DB_ErrorCode", "Error Code is updated as "&sErCode&" in the database for the DX code inthe  Encounter # "&sEncounterNo
				'sDesc = "Error Code is updated as "&sErCode&" in the database for Encounter # "&sEncounterNo
				'RulesEngineReport sEncounterNo, sErCode, "", sDesc, "Pass"							
			Else
				Reporter.ReportEvent micFail, "DB_ErrorCode", "Error Code is updated as "&sErCode&" instead of "&sErrorCode&" in the database for the DX code inthe  Encounter # "&sEncounterNo
				'sDesc = "Error Code is updated as "&sErCode&" instead of "&sErrorCode&" in the database for Encounter # "&sEncounterNo
				'RulesEngineReport sEncounterNo, sErCode, "", sDesc, "Fail"				
			End If
			
			'Check if the Error Message is updated correctly for the Encounter
			If Trim(sErDesc) = Trim(sErrorMessage) Then
				Reporter.ReportEvent micPass, "DB_ErrorMessage", "Error Message is updated as "&sErDesc&" in the database for the DX code inthe  Encounter # "&sEncounterNo
				'sDesc = "Error Message is updated as "&sErDesc&" in the database for Encounter # "&sEncounterNo
				'RulesEngineReport sEncounterNo, "", sErDesc, sDesc, "Pass"				
			Else
				Reporter.ReportEvent micFail, "DB_ErrorMessage", "Error Message is updated as "&sErDesc&" instead of "&sErrorMessage&" in the database for the DX code inthe  Encounter # "&sEncounterNo
				'sDesc = "Error Message is updated as "&sErDesc&" instead of "&sErrorMessage&" in the database for Encounter # "&sEncounterNo
				'RulesEngineReport sEncounterNo, "", sErDesc, sDesc, "Fail"				
			End If

			'Excel Reporting
			If Trim(sErCode) = Trim(sErrorCode) and Trim(sErDesc) = Trim(sErrorMessage) Then
				sDesc = "Error Code and Message is updated as expected in the database for the DX code inthe  the Encounter #"
				RulesEngineReport sEncounterNo, sErCode, sErDesc, sDesc, "Pass"							
			Else
				sDesc = "Error Code and Message is not updated as expected in the database for the DX code inthe  the Encounter # Expected ErrorCode = "&sErrorCode& " and Expected Error Message = "&sErrorMessage
				RulesEngineReport sEncounterNo, sErCode, sErDesc, sDesc, "Fail"
			End If							
		End If

	  Reporter.ReportEvent micDone, "RulesEngineDXlevelDBErrCodeCheck", "Function End"
	  Services.EndTransaction "RulesEngineDXlevelDBErrCodeCheck" ' Timer End
	End Sub	

	'<@comments>
	'**********************************************************************************************
	' <@name>DuplicateRuleCheck</@name>
	'
	' <@purpose>
	'   verifies if the Duplicate Encounter No is listed in the Duplicate Table in database
	' </@purpose>
	'
	' <@parameters>
	'   sEncounterNo (ByVal) = string - Encounter No to be checked in the Duplicate table
	' </@parameters>
	'
	' <@return>
	'   Boolean - TRUE if pass
	'             FALSE if failed 
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created 
	' </@assumptions>
	'
	' <@example_usage>ChSyBatJob..DuplicateRuleCheck("98452313353")</@example_usage>
	'
	' <@author>Dhushanth S</@author>
	'
	' <@creation_date>05/24/2010</@creation_date>
	'
	' <@mod_block>
	'
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>


	Public Function DuplicateRuleCheck(ByVal sEncounterNo) ' <@as> Boolean
		
	  Services.StartTransaction "DuplicateRuleCheck" ' Timer Begin
	  Reporter.ReportEvent micDone, "DuplicateRuleCheck", "Function Begin"

	   ' Variable Declaration / Initialization
	   Dim sQuery, oRS
	   Dim sEnctNo
	   
	  'verifies that the passed parameter is not null or an empty string.
	  If IsNull(sEncounterNo) Or sEncounterNo = "" Then
	   	Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the DuplicateRuleCheck function check passed parameters"
	   	Services.EndTransaction "DuplicateRuleCheck" ' Timer End
	   	Exit Function
	  End If
	  
	  sQuery = "select * from irads.ir_encounterdup where encounter_nbr='"&sEncounterNo&"'"	
	  
	  set oRS = db.executeDBQuery(sQuery, Environment.Value("DB"))	
		
		If LCase(typeName(oRS)) <> "recordset" Then
			Reporter.ReportEvent micFail, "invalid recordset", "The database connection did not open or invalid parameters were passed."
			DuplicateRuleCheck = FALSE
			'sDesc = "The database connection did not open or invalid parameters were passed."
			'RulesEngineReport sEncounterNo, "", "", sDesc, "Fail"
			ElseIf oRS.bof And oRS.eof Then
			Reporter.ReportEvent micFail, "invalid recordset", "File "&sFileName& " not uploaded in the db after executing upload job command"
			DuplicateRuleCheck = FALSE
			'sDesc = "The returned recordset contains no records."
			'RulesEngineReport sEncounterNo, "", "", sDesc, "Fail"
			Else
			Reporter.ReportEvent micPass, "valid recordset", "The returned recordset is valid and contains records."
			DuplicateRuleCheck = TRUE
			'sDesc = "The returned recordset is valid and contains records."
			'RulesEngineReport sEncounterNo, "", "", sDesc, "Pass"

			sEnctNo = oRS.fields("ENCOUNTER_NBR").Value
			
			'Check if the Error Code is updated correctly for the Encounter
			If Trim(sEncounterNo) = Trim(sEnctNo) Then
				Reporter.ReportEvent micPass, "Encounter No", "Encounter No "&sEncounterNo& " uploaded in the Duplicate db table"
				DuplicateRuleCheck = TRUE
				'sDesc = "Error Code is updated as "&sErCode&" in the database for Encounter # "&sEncounterNo
				'RulesEngineReport sEncounterNo, sErCode, "", sDesc, "Pass"							
			Else
				Reporter.ReportEvent micFail, "Encounter No", "Encounter No "&sEncounterNo& " not uploaded in the Duplicate db table"
				DuplicateRuleCheck = FALSE
				'sDesc = "Error Code is updated as "&sErCode&" instead of "&sErrorCode&" in the database for Encounter # "&sEncounterNo
				'RulesEngineReport sEncounterNo, sErCode, "", sDesc, "Fail"				
			End If
		End If
	
	  Reporter.ReportEvent micDone, "DuplicateRuleCheck", "Function End"
	  Services.EndTransaction "DuplicateRuleCheck" ' Timer End
	End Function



	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>loginVerifyPutty</@name>
	'  <@purpose>
	'    loginVerifyPutty is a public method which login to putty for the given user name and navigate upto the given folder
	'  </@purpose>
	'  Start: 
	'  End: 
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.loginVerifyPutty("cseuser", "password","10.236.235.23","/data/qa/QA_Utilities")
	'  Parameters:  
	'  sUserName - string - Username to access the given machine
	'  sPassword - string - Password for the given user
	'  sMachineIP - string - Givewn machine IP
	'  sNavigateFolder - string - Folder to execute the shell script
	'  Calls: 
	'  Author: Bharathkumar G
	'  Date: 11/03/2009     (Created)
	'
	'  Modifications: 04/01/2010 - Dhushanth S - Customized for IRADS application
	'  Modifications: 09/23/2011 - Govardhan, Choletti - Customized for ChartSync application
	'**********************************************************************************************************************************      
	'</@comments>	
	Public Function loginVerifyPutty(ByVal sUserName, ByVal sPassword, ByVal sMachineIP, ByVal sNavigateFolder)

		Services.StartTransaction "loginVerifyPutty" ' Timer Begin
		Reporter.ReportEvent micDone, "loginVerifyPutty", "Function Begin"
		
		Dim sString
		
		sString = "login as:"
		If ChSyBatJob.CheckForTeScreenString(sString) Then
			If ChSyBatJob.ExecuteCommand(sUserName,"") Then
				sString = sUserName & "@" & sMachineIP & "'s password:"
				If ChSyBatJob.CheckForTeScreenString(sString) Then
					If ChSyBatJob.ExecuteCommand(sPassword,"") Then
						sString = "bash"
						If ChSyBatJob.CheckForTeScreenString(sString) Then
							sCommand = "cd " & sNavigateFolder														
							If ChSyBatJob.ExecuteCommand(sCommand,"") Then								
								If ChSyBatJob.CheckForTeScreenString(sString) Then
									loginVerifyPutty = True
								Else
									Reporter.ReportEvent micDone, sString & " check", "Failed in '" & sString & " check"
									loginVerifyPutty = False
									Exit Function
								End If
							Else								
								Reporter.ReportEvent micDone, sCommand & " Command execution", "Failed in '" & sCommand & " Command execution"
								loginVerifyPutty = False
								Exit Function
							End If
						Else
							Reporter.ReportEvent micDone, sString & " check", "Failed in '" & sString & " check"
							loginVerifyPutty = False
							Exit Function
						End If
					Else
						Reporter.ReportEvent micDone, sPassword & " Command execution", "Failed in '" & sPassword & " Command execution"
						loginVerifyPutty = False
						Exit Function
					End If
				Else
					Reporter.ReportEvent micDone, sString & " check", "Failed in '" & sString & " check"
					loginVerifyPutty = False
					Exit Function									
				End If
			Else
				Reporter.ReportEvent micDone, sUserName & " Command execution", "Failed in '" & sUserName & " Command execution"
				loginVerifyPutty = False
				Exit Function
			End If
		Else
			Reporter.ReportEvent micDone, sString & " check", "Failed in '" & sString & " check"
			loginVerifyPutty = False
			Exit Function
		End If 
		
		Reporter.ReportEvent micDone, "loginVerifyPutty", "Function End"
		Services.EndTransaction "loginVerifyPutty" ' Timer End
	End Function
	
	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>connectPutty</@name>
	'  <@purpose>
	'    connectPutty is a public method which connect to the given machine ip through putty
	'  </@purpose>
	'  Start: 
	'  End: 
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.connectPutty(installpath, "10.236.214.222","33")
	'  Parameters:  
	'  sPuttyInstallPath - string - Install path of the Putty exe
	'  sMachineIP - string - IP of the given machine
	'  sPortNumber - integer - port number to connect
	'  Calls: 
	'  Author: Govardhan Choletti
	'  Date: 21/09/2011     (Created)
	'
	'  Modifications: 
	'
	'**********************************************************************************************************************************      
	'</@comments>	
	Public Function connectPutty(ByVal sPuttyInstallPath, ByVal sMachineIP, ByVal sPortNumber) 'as boolean

		Services.StartTransaction "connectPutty" ' Timer Begin
		Reporter.ReportEvent micDone, "connectPutty", "Function Begin"
		
		' Kill all previously existing putty instances
		ChSyBatJob.GetProc "putty.exe", True, False

		' Invoke Putty
		Systemutil.run(sPuttyInstallPath)

		' Connect to the server if the Putty screen loaded
		If  window("regexpwndtitle:=putty configuration").Exist(50) Then
			window("regexpwndtitle:=putty configuration").activate
			wait(3) 'sync
			window("regexpwndtitle:=putty configuration").winedit("nativeclass:=edit","attached text:=Host.*").Set sMachineIP
			'window("regexpwndtitle:=putty configuration").winedit("nativeclass:=edit","attached text:=&Port").DblClick 10,10
			'window("regexpwndtitle:=putty configuration").winedit("nativeclass:=edit","attached text:=&Port").Type ""
			Wait(1)
			window("regexpwndtitle:=putty configuration").winedit("nativeclass:=edit","attached text:=&Port").Set sPortNumber
			window("regexpwndtitle:=putty configuration").winradiobutton("nativeclass:=button","text:=&SSH").set
			window("regexpwndtitle:=putty configuration").winbutton("text:=&open").click
		Else
			Reporter.ReportEvent "Open Putty", "Could not load the putty exe. Please check the path of the exe."
		End If

		wait(3)
		If TeWindow("short name:=A").Exist(20) Then 
			'Verify that whether Putty got opened or not
			If TeWindow("name:=TeWindow").TeTextScreen("name:=TeTextScreen").GetText() <> ""  Then
				Reporter.ReportEvent micPass, "Open Putty", "Putty is opened successfully for the given IP " & sMachineIP
				connectPutty = True
			Else
				' Handling the Connection Timed out/Refused Error
				If window("nativeclass:=putty").Dialog("text:=PuTTY Fatal Error").Exist(30) Then
					Reporter.ReportEvent micFail, "Open Putty", "Connection Timed out/ Connection Refused Error. Fatal error occured while connecting putty."
					connectPutty = False
					ChSyBatJob.GetProc "putty.exe", True, False
					Exit Function
				End If
				'Handle any other failure conditions 
				Reporter.ReportEvent micFail, "Open Putty", "Unable to open the Putty. Please check the IP/install path provided"
				ChSyBatJob.GetProc "putty.exe", True, False
				connectPutty = False
			End If
		Else
			Reporter.ReportEvent micFail,"Putty Load", "Putty window load failed"
		End If
		
		Reporter.ReportEvent micDone, "connectPutty", "Function End"
		Services.EndTransaction "connectPutty" ' Timer End
		
	End Function

	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>ExecuteCommand</@name>
	'  <@purpose>
	'    ExecuteCommand is a public method which executes the given command with the given argument
	'  </@purpose>
	'  Start: 
	'  End: 
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.ExecuteCommand("cd /data/qa/QA_Utilities","")
	'  Parameters:  
	'  sCommand - string - Command to execute
	'  sArgList - string - argument for the given command
	'  Calls: 
	'  Author: Bharathkumar G
	'  Date: 11/03/2009     (Created)
	' 
	'  Modifications: 09/23/2011 - Govardhan, Choletti - Customized for ChartSync application
	'**********************************************************************************************************************************      
	'</@comments>
	Public Function ExecuteCommand(ByVal sCommand, ByVal sArgList)

		Services.StartTransaction "ExecuteCommand" ' Timer Begin
		Reporter.ReportEvent micDone, "ExecuteCommand", "Function Begin"
		
		Dim oTeWindow, oTeTextScreen
		Dim sChar, sCommandLength, sArgLength, intI, intJ, sText, intK
		Dim sSplitVal

		'Piclink the appropriate data based on the Environment
	  	If Instr(1, sArgList, ";") <> 0 Then
			sSplitVal = Split(sArgList, ";")
			If Environment.Value("RunEnv") = "TEST" Then
				sArgList = sSplitVal(0)
			'ElseIf Environment.Value("RunEnv") = "TEST1" Then
			'	sArgList = sSplitVal(1)
			Else
				sArgList = sSplitVal(0)	
			End If
		End If

		set oTeWindow = Description.Create()
		oTeWindow("short name").Value = "A"
		
		set oTeTextScreen = Description.Create()
		oTeTextScreen("name").Value = "TeTextScreen"
		

		If TeWindow(oTeWindow).Exist(15) Then			
			
			If sCommand = Environment("UnixPassword") Then
				TeWindow(oTeWindow).TeTextScreen(oTeTextScreen).Type(sCommand)
				TeWindow(oTeWindow).TeTextScreen(oTeTextScreen).Type(micReturn)
				ExecuteCommand = True
				Reporter.ReportEvent micDone, "ExecuteCommand", "Function End"
				Services.EndTransaction "ExecuteCommand" ' Timer End
				Exit Function
			End If
			
			If sArgList = "" Then 
				For intI = 1 to 3
					sText = ""
					TeWindow(oTeWindow).TeTextScreen(oTeTextScreen).Type(sCommand)
					wait (1)
					sText = TeWindow(oTeWindow).TeTextScreen(oTeTextScreen).GetText()
					'sText = util.RmChr(sText,Chr(10))	 
					For intK = 1 to 32	
						If Instr(1,sText, chr(intK)) and intK <>32Then
							sText = Replace(sText, chr(intK),"")
						End If
					Next   			
					
					If Instr(1,sText,sCommand) > 0 Then
						TeWindow(oTeWindow).TeTextScreen(oTeTextScreen).Type(micReturn)
						Reporter.ReportEvent micPass, "String Text found","The given string '" & sCommand & "' is found in the TeTextScreen"
						intI = 3
					Else
						sCommandLength = Len(sCommand)
						For intJ = 1 to sCommandLength
							TeWindow(oTeWindow).TeTextScreen(oTeTextScreen).Type(micBack)
						Next
						Reporter.ReportEvent micInfo, "String Text found","The given string '" & sCommand & "' is not found in the TeTextScreen and the text displayed is '" & sText & "'"			
					End If	
				Next
				
				
				Reporter.ReportEvent micPass, "Execute Command ", "Command '" & sCommand & "' is executed successfully"
				ExecuteCommand = True
			Else
				
				sCommand = sCommand & " " & (sArgList)
							
				For intI = 1 to 3
					sText = ""
					TeWindow(oTeWindow).TeTextScreen(oTeTextScreen).Type(sCommand)
										wait (1)
					
					sText = TeWindow(oTeWindow).TeTextScreen(oTeTextScreen).GetText()
					'sText = util.RmChr(sText,Chr(10))		
					For intK = 1 to 32	
						If Instr(1,sText, chr(intK)) and intK <>32Then
							sText = Replace(sText, chr(intK),"")
						End If
					Next  
					
					If Instr(1,sText,sCommand) > 0 Then
						TeWindow(oTeWindow).TeTextScreen(oTeTextScreen).Type(micReturn)
						Reporter.ReportEvent micPass, "String Text found","The given string '" & sCommand & "' is found in the TeTextScreen"
						intI = 3
					Else
						sCommandLength = Len(sCommand)
						For intJ = 1 to sCommandLength
							TeWindow(oTeWindow).TeTextScreen(oTeTextScreen).Type(micBack)
						Next
						Reporter.ReportEvent micInfo, "String Text found","The given string '" & sCommand & "' is not found in the TeTextScreen and the text displayed is '" & sText & "'"			
					End If	
				Next

				Reporter.ReportEvent micPass, "Execute Command ", "Command '" & sCommand & "' is executed with the argument '" & sArgList & "' successfully"
				ExecuteCommand = True
				
			End If
		Else
			Reporter.ReportEvent micFail, "Execute Command ", "Unable to find the PUTTY window"
			ExecuteCommand = False
		End If

		Reporter.ReportEvent micDone, "ExecuteCommand", "Function End"
		Services.EndTransaction "ExecuteCommand" ' Timer End
		
	End Function

	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>CheckForTeScreenString</@name>
	'  <@purpose>
	'    CheckForTeScreenString is a public method which verifies the given string is available in the TeScreen or not
	'  </@purpose>
	'  Start: 
	'  End: 
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.CheckForTeScreenString("login as")
	'  Parameters:  
	'  sString - string - String to be verified in the TeScreen
	'  Calls: 
	'  Author: Bharathkumar G
	'  Date: 11/03/2009     (Created)
	'
	'Modifications: 04/01/2010 - Govardhan Choletti - Customized for ChartSync application
	'**********************************************************************************************************************************      
	'</@comments>
	Public Function CheckForTeScreenString(ByVal sString)

		Services.StartTransaction "CheckForTeScreenString" ' Timer Begin
		Reporter.ReportEvent micDone, "CheckForTeScreenString", "Function Begin"
		
		Dim oTeWindow, oTeTextScreen, sText 

		'Creating descriptions for TEWindow and TEScreen
		set oTeWindow = Description.Create()
		oTeWindow("short name").Value = "A"
		
		set oTeTextScreen = Description.Create()
		oTeTextScreen("name").Value = "TeTextScreen"
		
		'Getting the text from the TEScreen
		sText = TeWindow(oTeWindow).TeTextScreen(oTeTextScreen).GetText()
		sText = ChSyBatJob.RmChr(sText,Chr(10))		
		'If the string is available, then [proceed further else wait for the string for some period and report FAIL
		If Instr(1,sText,sString) > 0 Then
			Reporter.ReportEvent micPass, "String Text found","The given string '" & sString & "' is found in the TeTextScreen"
			CheckForTeScreenString = True
		Else			
			TeWindow(oTeWindow).TeTextScreen(oTeTextScreen).WaitString(sString)
			sText = TeWindow(oTeWindow).TeTextScreen(oTeTextScreen).GetText()
			sText = ChSyBatJob.RmChr(sText,Chr(10))		
			If Instr(1,sText,sString) > 0 Then
				Reporter.ReportEvent micPass, "String Text found","The given string '" & sString & "' is found in the TeTextScreen"
				CheckForTeScreenString = True
			Else
				Reporter.ReportEvent micFail, "String Text found","The given string '" & sString & "' is not found in the TeTextScreen and the text displayed is '" & sText & "'"			
				CheckForTeScreenString = False
			End If		
		End If
		
		Reporter.ReportEvent micDone, "CheckForTeScreenString", "Function End"
		Services.EndTransaction "CheckForTeScreenString" ' Timer End
		
	End Function

	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>CheckForBashString</@name>
	'  <@purpose>
	'    CheckForBashString is a public method which verifies the given string is available in the TeScreen or not within 2 minutes
	'  </@purpose>
	'  Start: 
	'  End: 
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.CheckForBashString("bash$")
	'  Parameters:  
	'  sString - string - String to be verified in the TeScreen
	'  Calls: 
	'  Author: Dhushanth S
	'  Date: 06/21/2010     (Created)
	'
	'Modifications: 04/01/2010 - Govardhan Choletti - Customized for ChartSync application
	'
	'**********************************************************************************************************************************      
	Public Function CheckForBashString(ByVal sString)
	
		Services.StartTransaction "CheckForBashString" ' Timer Begin
		Reporter.ReportEvent micDone, "CheckForBashString", "Function Begin"
		
		Dim oTeWindow, oTeTextScreen, sText 
		Dim iCounter
		
		'Creating descriptions for TEWindow and TEScreen
		set oTeWindow = Description.Create()
		oTeWindow("short name").Value = "A"
		
		set oTeTextScreen = Description.Create()
		oTeTextScreen("name").Value = "TeTextScreen"
		
		'If the string is available, then [proceed further else wait for the string for some period and report FAIL
		For iCounter =1 to 12
			Wait(10)
			sText = TeWindow(oTeWindow).TeTextScreen(oTeTextScreen).GetText()

			'Check if the string is present in the TE Screen
			If Instr(1, sText, sString) > 0 Then
				Exit For
			End If	
		Next	

		Reporter.ReportEvent micDone, "CheckForBashString", "Function End"
		Services.EndTransaction "CheckForBashString" ' Timer End
			
	End Function


	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>createProjectLoadFile</@name>
	'  <@purpose>
	'    createProjectLoadFile is a public method which creates a new Project file from the available template file specific to the test
	'	 i.e This Function will pick up the Project File with Format LOADCR_INGENIX_XXXXXXXXXXXX
	'    Update the Content of project file with New, Unique data
	'  </@purpose>
	'  Start: 
	'  End: 
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.createProjectLoadFile("LOADCR_INGENIX_20120924122733")
	'  Parameters:  
	'  sProjectTemplate - string - Template file path in the NAS drive
	'  Calls: 
	'  Author: Govardhan Choletti
	'  Date: 09/21/2010     (Created)
	'  Modifications: Govardhan Choletti - 09/24/2012 - Updated as per New Project Load Format 
	'
	'**********************************************************************************************************************************      

	Public Function  createProjectLoadFile(ByVal sProjectTemplate)
		Services.StartTransaction "createProjectLoadFile" ' Timer Begin
		Reporter.ReportEvent micDone, "createProjectLoadFile", "Function Begin"

		Dim fso, f1, ts, oRS
		Dim i ,j ,iTotalEncounters, iHealthPlanProducts, iRepeat, iMember
		Dim s, sTime, sFileName, sNewProjectFile, sSplitString, sHDR_TRAField2, sField2, sField3, sField4, sField5, sField6, sField41, sField42, sHealthPlanDB, sHealthPlanProductDB, sHealthPlanProductLOBDB, sQuery, sRecord, sField19, sField24, sField25, sField26, sField27
		Dim bDTLSegmentCreation
		Const ForReading = 1

	   	'To Create a random rule no for the file
		sTime = Now				' Retrieving Date + Time i.e 
		'sTime = Replace(sTime, ":", "")
		'sTime=  Replace(sTime, " ","")
		'sTime=  Replace(sTime, "/","")
		' Retrieving Date + Time in Format YYYYMMDDHHMMSS
		sTime = Year(sTime) & Right("0"& Month(sTime), 2) & Right("0"& Day(sTime), 2) & Right("0"& Hour(sTime), 2) & Right("0"& Minute(sTime), 2) & Right("0"& Second(sTime), 2)
		Environment.Value("sTimeStamp") = sTime

		sNewProjectFile = Split(sProjectTemplate, "_")
		sFileName = Replace(sProjectTemplate, sNewProjectFile(2) , "")
		i = 0
		j = 0
		'sFileName = Replace(sProjectTemplate, "Template", "")

	   	Set fso = CreateObject("Scripting.FileSystemObject")
		'Check if the Template file for the test exists in the \\Nas00582pn\istarr\Automation\Application\ChartSync\BatchJobTemplates\QA\<Test Case Name>
		If Not(fso.FileExists(Environment.Value("Batch_Job_Path")& sProjectTemplate&""))Then
			Reporter.ReportEvent micFail, "Template File" , "Template file "&sProjectTemplate&" does not exist within the '"& Environment.Value("Batch_Job_Path") &"' folder in the NAS drive"
			createProjectLoadFile = False 'Return Value
			Services.EndTransaction "createProjectLoadFile" ' Timer End
			Exit Function
		End If
	
		'Creating folder with current date in NAS Drive \Automation\Application\ChartSync\BatchJobs\QA
		If Not(fso.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate"))) Then 'Checking if the folder with current date is already created
			fso.CreateFolder ""&Environment.Value("Jobs_Path")&Environment.Value("CurDate") 'creating a new folder with the date in NAS drive
			 If Not(fso.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate"))) Then 'Report if the folder is not created
				Reporter.ReportEvent micFail, "Jobs_Path" , "Folder with current date was not created inside '"& Environment.Value("Jobs_Path") &"' folder" 
				createProjectLoadFile = False 'Return Value
				Services.EndTransaction "createProjectLoadFile" ' Timer End
				Exit Function
			End If	
		End If

		'Creating folder with current date\TestName in NAS Drive IRADS\Rules
		If Not(fso.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName"))) Then 'Checking if the folder with current date is already created
			fso.CreateFolder ""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName") 'creating a new folder with the test name in NAS drive
			 If Not(fso.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName"))) Then 'Report if the folder is not created
				Reporter.ReportEvent micFail, "Jobs_Path" , "Folder with Test Name was not created inside '"& Environment.Value("Jobs_Path") &"' folder"
				createProjectLoadFile = False 'Return Value
				Services.EndTransaction "createProjectLoadFile" ' Timer End
				Exit Function
			End If	
		End If
		
	   	'Creating a new file in \\Nas00582pn\istarr\Automation\Application\IRADS\Rules folder\CurDate\TestName
	   	Set f1 = fso.CreateTextFile(Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName")&"\"&sFileName & Environment.Value("sTimeStamp")&".DAT", True)
	
	   	'Opening the text file, Reading the contents and writing it in a new file
	   	Set ts = fso.OpenTextFile(Environment("Batch_Job_Path")&"\"&sProjectTemplate&"", ForReading)
		
		Do while ts.AtEndofStream <> True
			s = ts.ReadLine
			sSplitString = Split(s, "|")

			If sSplitString(0) = "HDR"  Then
				sHDR_TRAField2 = "OPTUM AUTOMATION "&Right(sTime,12)
				s = Replace(s, "|" & sSplitString(1) & "|", "|" & sHDR_TRAField2 & "|")
				f1.write ""&s
				f1.WriteBlankLines(1)
			End If
		
	'If Users asks for Mutiple Members for all Health Plans
			bDTLSegmentCreation = True
			If Instr(1,UCASE(Environment.Value("TestName")), "MULTIPLE_MEMBER" , 1) > 0 Then
				If sSplitString(0) = "DTL" AND bDTLSegmentCreation Then
					bDTLSegmentCreation = False
					sQuery = "SELECT A.hp_cd, A.hp_product, A.Hp_product_Lob FROM ravas.Rv_hp_product A" 
					Set oRS = db.executeDBQuery(sQuery, Environment.Value("DB"))
					If LCase(typeName(oRS)) <> "recordset" Then
						Reporter.ReportEvent micFail, "invalid recordset", "The database connection did not open or invalid parameters were passed."
						Exit Function
					ElseIf oRS.bof And oRS.eof Then
						Reporter.ReportEvent micFail, "invalid recordset", "The returned recordset contains no records."
						Exit Function
					Else
						iRepeat = 0
						Do 
							sRecord = s
							sHealthPlanDB = oRS.fields(0).Value
							sHealthPlanProductDB = oRS.fields(1).Value
							sHealthPlanProductLOBDB = oRS.fields(2).Value
							sRecord = Replace(sRecord, "|" & sSplitString(8) & "|" & sSplitString(9) & "|"& sSplitString(10) & "|" & sSplitString(11) & "|"& sSplitString(12) & "|", "|" & sHealthPlanDB & "|" & sHealthPlanProductDB & "|"& sSplitString(10) & "|" & sSplitString(11) & "|"& sHealthPlanProductLOBDB & "|")
													
							'Record Creation 
							i = i + 1
							iTotalEncounters = i
							
							'Replace the Field 2 i.e Sequence Number & Member Information repeated twice
							sField2 = i
							If iRepeat < 2 Then
								iMember = i
								iHealthPlanProducts = i
							Else
								iMember = i - (Cint(iRepeat\2) * iHealthPlanProducts)
							End If
							sField3 = "AUTOID"&Right(sTime,12)& iMember
							sField4 = "AUTOMN"&Right(sTime,12)& iMember
							sField5 = "AUTO MBR LNAME "&Right(sTime,12)& iMember
							sField6 = "AUTO MBR FNAME "&Right(sTime,12)& iMember
							sRecord = Replace(sRecord, "|" & sSplitString(1) & "|" & sSplitString(2) & "|" & sSplitString(3) & "|" & sSplitString(4) & "|" & sSplitString(5) & "|", "|" & sField2 & "|" & sField3 & "|" & sField4 & "|" & sField5 & "|" & sField6 & "|")

				
							'Replace the Field i.e Provider Information unique
							sField19 = "AUTOPROVID"&Right(sTime,12)&i
							sRecord = Replace(sRecord, "|" & sSplitString(18) & "|", "|" & sField19 & "|")
							
							sField24 = "AUTO PROV LNAME "&Right(sTime,12)&i
							sField25 = "AUTO PROV FNAME "&Right(sTime,12)&i
							sField26 = "AUTO PROV ADD-1 "&Right(sTime,12)&i
							sField27 = "AUTO PROV ADD-2 "&Right(sTime,12)&i
							sRecord = Replace(sRecord, "|" & sSplitString(23) & "|" & sSplitString(24) & "|" & sSplitString(25) & "|" & sSplitString(26) & "|", "|" & sField24 & "|" & sField25 & "|" & sField26 & "|" & sField27 & "|")
														
							'Write to the File
							f1.Write ""&sRecord
							f1.WriteBlankLines(1)							
							oRS.moveNext
							If (oRS.eof)  Then
								iRepeat = iRepeat + 1
								If iRepeat < 4 Then
									oRS.moveFirst
								End If
							End If
						Loop Until (oRS.eof)
					End If
				End If
			ElseIf Instr(1,UCASE(Environment.Value("TestName")), "PRODUCT_TYPE_TWICE" , 1) > 0 Then
				If sSplitString(0) = "DTL" AND bDTLSegmentCreation Then
					bDTLSegmentCreation = False
					sQuery = "SELECT A.hp_cd, A.hp_product, A.Hp_product_Lob FROM ravas.Rv_hp_product A" 
					Set oRS = db.executeDBQuery(sQuery, Environment.Value("DB"))
					If LCase(typeName(oRS)) <> "recordset" Then
						Reporter.ReportEvent micFail, "invalid recordset", "The database connection did not open or invalid parameters were passed."
						Exit Function
					ElseIf oRS.bof And oRS.eof Then
						Reporter.ReportEvent micFail, "invalid recordset", "The returned recordset contains no records."
						Exit Function
					Else
						iRepeat = 0
						Do 
							sRecord = s
							sHealthPlanDB = oRS.fields(0).Value
							sHealthPlanProductDB = oRS.fields(1).Value
							sHealthPlanProductLOBDB = oRS.fields(2).Value
							sRecord = Replace(sRecord, "|" & sSplitString(8) & "|" & sSplitString(9) & "|"& sSplitString(10) & "|" & sSplitString(11) & "|"& sSplitString(12) & "|", "|" & sHealthPlanDB & "|" & sHealthPlanProductDB & "|"& sSplitString(10) & "|" & sSplitString(11) & "|"& sHealthPlanProductLOBDB & "|")
													
							'Record Creation 
							i = i + 1
							iTotalEncounters = i
							
							'Replace the Field 2 i.e Sequence Number & Unique Member Information
							sField2 = i
							sField3 = "AUTOID"&Right(sTime,12)& i
							sField4 = "AUTOMN"&Right(sTime,12)& i
							sField5 = "AUTO MBR LNAME "&Right(sTime,12)& i
							sField6 = "AUTO MBR FNAME "&Right(sTime,12)& i
							sRecord = Replace(sRecord, "|" & sSplitString(1) & "|" & sSplitString(2) & "|" & sSplitString(3) & "|" & sSplitString(4) & "|" & sSplitString(5) & "|", "|" & sField2 & "|" & sField3 & "|" & sField4 & "|" & sField5 & "|" & sField6 & "|")

				
							'Replace the Field i.e Same Provider Information
							sField19 = "AUTOPROVID"&Right(sTime,12)
							sRecord = Replace(sRecord, "|" & sSplitString(18) & "|", "|" & sField19 & "|")
							
							sField24 = "AUTO PROV LNAME "&Right(sTime,12)
							sField25 = "AUTO PROV FNAME "&Right(sTime,12)
							sField26 = "AUTO PROV ADD-1 "&Right(sTime,12)
							sField27 = "AUTO PROV ADD-2 "&Right(sTime,12)
							sRecord = Replace(sRecord, "|" & sSplitString(23) & "|" & sSplitString(24) & "|" & sSplitString(25) & "|" & sSplitString(26) & "|", "|" & sField24 & "|" & sField25 & "|" & sField26 & "|" & sField27 & "|")
														
							'Write to the File
							f1.Write ""&sRecord
							f1.WriteBlankLines(1)							
							oRS.moveNext
							If (oRS.eof)  Then
								iRepeat = iRepeat + 1
								If iRepeat < 2 Then
									oRS.moveFirst
								End If
							End If
						Loop Until (oRS.eof)
					End If
				End If		
			ElseIf Instr(1,UCASE(Environment.Value("TestName")), "PRODUCT_TYPE" , 1) > 0 Then
				If sSplitString(0) = "DTL" AND bDTLSegmentCreation Then
					bDTLSegmentCreation = False
					sQuery = "SELECT A.hp_cd, A.hp_product, A.Hp_product_Lob FROM ravas.Rv_hp_product A" 
					Set oRS = db.executeDBQuery(sQuery, Environment.Value("DB"))
					If LCase(typeName(oRS)) <> "recordset" Then
						Reporter.ReportEvent micFail, "invalid recordset", "The database connection did not open or invalid parameters were passed."
						Exit Function
					ElseIf oRS.bof And oRS.eof Then
						Reporter.ReportEvent micFail, "invalid recordset", "The returned recordset contains no records."
						Exit Function
					Else
						Do 
							sRecord = s
							sHealthPlanDB = oRS.fields(0).Value
							sHealthPlanProductDB = oRS.fields(1).Value
							sHealthPlanProductLOBDB = oRS.fields(2).Value
							sRecord = Replace(sRecord, "|" & sSplitString(8) & "|" & sSplitString(9) & "|"& sSplitString(10) & "|" & sSplitString(11) & "|"& sSplitString(12) & "|", "|" & sHealthPlanDB & "|" & sHealthPlanProductDB & "|"& sSplitString(10) & "|" & sSplitString(11) & "|"& sHealthPlanProductLOBDB & "|")
													
							'Record Creation 
							i = i + 1
							iTotalEncounters = i
							
							'Replace the Field 2 i.e Sequence Number
							sField2 = i
							sField3 = "AUTOID"&Right(sTime,12)&i
							sField4 = "AUTOMN"&Right(sTime,12)&i
							sField5 = "AUTO MBR LNAME "&Right(sTime,12)&i
							sField6 = "AUTO MBR FNAME "&Right(sTime,12)&i
							sRecord = Replace(sRecord, "|" & sSplitString(1) & "|" & sSplitString(2) & "|" & sSplitString(3) & "|" & sSplitString(4) & "|" & sSplitString(5) & "|", "|" & sField2 & "|" & sField3 & "|" & sField4 & "|" & sField5 & "|" & sField6 & "|")
							
							'Write to the File
							f1.Write ""&sRecord
							f1.WriteBlankLines(1)							
							oRS.moveNext
						Loop Until (oRS.eof)
					End If
				End If	
			ElseIf sSplitString(0) = "DTL" Then
				i = i + 1
				iTotalEncounters = i
						
				'Replace the Field 2 i.e Sequence Number
				sField2 = i
				s = Replace(s, "|" & sSplitString(1) & "|", "|" & sField2 & "|")
				
				'Replace the Field 3 i.e Member ID
				sField3 = "AUTOID"&Right(sTime,12)&i
				s = Replace(s, "|" & sSplitString(2) & "|", "|" & sField3 & "|")
				
				'Replace the Field 4 i.e Member HIC Number
				sField4 = "AUTOMN"&Right(sTime,12)&i
				s = Replace(s, "|" & sSplitString(3) & "|", "|" & sField4 & "|")
				
				'Replace the Field 5 i.e Member Last Name
				sField5 = "AUTO LAST NAME "&Right(sTime,12)&i
				s = Replace(s, "|" & sSplitString(4) & "|", "|" & sField5 & "|")
				
				'Replace the Field 6 i.e Member First Name
				sField6 = "AUTO FIRST NAME "&Right(sTime,12)&i
				s = Replace(s, "|" & sSplitString(5) & "|", "|" & sField6 & "|")
				
				'Replace the Field 41 i.e Project ID
				sField41 = "AUTO-PROJID-"&Right(sTime,12)
				If sSplitString(41) = "" Then
					'Do Nothing
				Else
					s = Replace(s, "|" & sSplitString(41) & "|", "|" & sField41 & "|")
				End If

				'Replace the Field 42 i.e Chart ID
				sField42 = "AUTO-CHARTID-"&Right(sTime,12)&i
				If sSplitString(42) = "" Then
					'Do Nothing
				Else
					s = Replace(s, "|" & sSplitString(42) & "|", "|" & sField42 & "|")				
				End If
		
				f1.Write ""&s
				f1.WriteBlankLines(1)
			End If

			If sSplitString(0) = "TRA" Then
				s = Replace(s, "|" & sSplitString(1) & "|", "|" & sHDR_TRAField2 & "|")
				s = Replace(s, "|" & sSplitString(3) & "|", "|" & iTotalEncounters & "|")
				f1.Write ""&s
				f1.WriteBlankLines(1)
			End If		
		Loop	
		
		f1.Close
		ts.Close

		'Clear object variables
		Set f1 = Nothing
		Set ts = Nothing
		Set fso = Nothing
		
		Reporter.ReportEvent micDone, "createProjectLoadFile", "Function End"
		Services.EndTransaction "createProjectLoadFile" ' Timer End
	End Function

	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>CreateDuplicateRuleFiles</@name>
	'  <@purpose>
	'    CreateDuplicateRuleFiles is a public method which creates a rules file with duplicate encounter from the Rule Template
	'  </@purpose>
	'  Start: 
	'  End: 
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.CreateDuplicateRuleFiles("UHG_AMERIHFileName", "078292")
	'  Parameters:  
	'  sBatchTemplate - String - Template file to be used for the script
	'  iHICNo -  Integer - HICNo to be used when creating the Rules File
	'  Calls: 
	'  Author: Dhushanth S
	'  Date: 05/20/2010     (Created)
	'
	'  Modifications: 
	'
	'**********************************************************************************************************************************      
	'</@comments>
	Public Function  CreateDuplicateRuleFiles(ByVal sBatchTemplate, ByVal iHICNo)
			Services.StartTransaction "CreateDuplicateRuleFiles" ' Timer Begin
			Reporter.ReportEvent micDone, "CreateDuplicateRuleFiles", "Function Begin"
	
			Dim fso, f1, ts, s, sTime, sFileName, sSplitString, iMemberID, i ,iTotalEncounters, iHICNumber,iProviderID
			Const ForReading = 1
	
		   	'To Create a random rule no for the file
			sTime = Now
			sTime = Replace(sTime, ":", "")
			sTime=  Replace(sTime, " ","")
			sTime=  Replace(sTime, "/","")
			Environment.Value("JobNo") = sTime
			sNewBatchName = Split(sBatchTemplate, "_")
			sFileName = Replace(sBatchTemplate, sNewBatchName(2) , "")
			i = 0
			'sFileName = Replace(sBatchTemplate, "Template", "")
	
		   	Set fso = CreateObject("Scripting.FileSystemObject")
		
			'Check if the Template file for the test exists in the \\Nas00582pn\istarr\Automation\Application\IRADS\RuleTemplates path
			If Not(fso.FileExists(Environment.Value("Batch_Job_Path")&sBatchTemplate&""))Then
				Reporter.ReportEvent micFail, "Template File" , "Template file "&sBatchTemplate&" does not exist within the RuleTemplates folder in the NAS drive"
				CreateDuplicateRuleFiles = "fail" 'Return Value
				Services.EndTransaction "CreateBatchJob" ' Timer End
				Exit Function
			End If
		
			'Creating folder with current data in NAS Drive IRADS\Rules
			If Not(fso.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate"))) Then 'Checking if the folder with current date is already created
				fso.CreateFolder ""&Environment.Value("Jobs_Path")&Environment.Value("CurDate") 'creating a new folder with the date in NAS drive
				 If Not(fso.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate"))) Then 'Report if the folder is not created
					Reporter.ReportEvent micFail, "Jobs_Path" , "Folder with current date was not created inside Rules folder" 
					CreateDuplicateRuleFiles = "fail" 'Return Value
					Services.EndTransaction "CreateBatchJob" ' Timer End
					ExitFunction
				End If	
			End If
	
			'Creating folder with current data in NAS Drive IRADS\Rules
			If Not(fso.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName"))) Then 'Checking if the folder with current date is already created
				fso.CreateFolder ""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName") 'creating a new folder with the test name in NAS drive
				 If Not(fso.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName"))) Then 'Report if the folder is not created
					Reporter.ReportEvent micFail, "Jobs_Path" , "Folder with Test Name was not created inside Rules folder" 
					CreateDuplicateRuleFiles = "fail" 'Return Value
					Services.EndTransaction "CreateBatchJob" ' Timer End
					ExitFunction
				End If	
			End If
			
			'Creating a new file in \\Nas00582pn\istarr\Automation\Application\IRADS\Rules folder\CurDate\TestName
			Set f1 = fso.CreateTextFile(Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName")&"\"&sFileName&""&Environment.Value("JobNo")&".DAT", True)
		
			'Opening the text file, Reading the contents and writing it in a new file
			Set ts = fso.OpenTextFile(Environment("Batch_Job_Path")&"\"&sBatchTemplate&"", ForReading)
			 Do while ts.AtEndofStream <> True
				s = ts.ReadLine
				sSplitString = Split(s, "|")
	
				If sSplitString(0) = "HDR"  Then
					'Environment.Value("EncounterNo") = ChSyBatJob.RandomNumberGeneration
					f1.write ""&s
					f1.WriteBlankLines(1)
				End If
		
				If sSplitString(0) = "CLM" Then
					i = i + 1
					iTotalEncounters = i
					Environment.Value("TotalEncounters") = iTotalEncounters
					Environment.Value("EncounterNo"&i) = ChSyBatJob.RandomNumberGeneration
					'Replace the Encounter No
					s = Replace(s, sSplitString(3), Environment.Value("EncounterNo"&i))
	
					If  i = 1 Then
					'Replace the Member ID
						iMemberID = ChSyBatJob.RandomNumberGeneration
						s = Replace(s, sSplitString(11), iMemberID)
					
						'Replace the HIC NO
						If iHICNo = "" Then
							iHICNumber = ChSyBatJob.RandomNumberGeneration
							s = Replace(s, sSplitString(15), iHICNumber)
						Else
							s = Replace(s, sSplitString(15), iHICNo)
						End If
					Else
						'Replace the Member ID
						s = Replace(s, sSplitString(11), iMemberID)
					
						'Replace the HIC NO
						If iHICNo = "" Then
							s = Replace(s, sSplitString(15), iHICNumber)
						Else
							s = Replace(s, sSplitString(15), iHICNo)
						End If								
					End If	
					f1.Write ""&s
					f1.WriteBlankLines(1)
				End If
		
				If sSplitString(0) = "ICD" Then
					'Replace the Encounter No
					s = Replace(s, sSplitString(3), Environment.Value("EncounterNo"&i))
					f1.Write ""&s
					f1.WriteBlankLines(1)
				End If
				
				If sSplitString(0) = "PRV" Then
					'Replace the Encounter No
					s = Replace(s, sSplitString(3), Environment.Value("EncounterNo"&i))
					
					'ProviderID Randomly generating
					If i = 1 Then
						'Replace the ProviderID
						iProviderID = ChSyBatJob.RandomNumberGeneration
						s = Replace(s, sSplitString(6), iProviderID)
					Else
						s = Replace(s, sSplitString(6), iProviderID)
					End If	
					f1.Write ""&s
					f1.WriteBlankLines(1)
				End If
	
				If sSplitString(0) = "SVC" Then
					'Replace the Encounter No
					s = Replace(s, sSplitString(3), Environment.Value("EncounterNo"&i))
					f1.Write ""&s
					f1.WriteBlankLines(1)
				End If
		
				If sSplitString(0) = "TRA" Then
					f1.Write ""&s
					f1.WriteBlankLines(1)
				End If		
			Loop	
			
			f1.Close
			ts.Close
	
			'Clear object variables
			Set f1 = Nothing
			Set ts = Nothing
			
			Reporter.ReportEvent micDone, "CreateDuplicateRuleFiles", "Function End"
			Services.EndTransaction "CreateDuplicateRuleFiles" ' Timer End
	End Function
	


	'<@comments>
	'**********************************************************************************************
	' <@name>FolderFiles</@name>
	'
	' <@purpose>
	'   To check if the Template Files exist within the BatchJobTemplates folder for the test and retrieves all the file names within that folder
	'
	' </@purpose>
	'
	' <@parameters>
	'	None
	' </@parameters>
	'
	' <@return>
	'   Boolean - True - If Pass
	'	      False - If Fail
	' </@return>
	'
	' <@assumptions>
	'
	' </@assumptions>
	'
	' <@example_usage>ChSyBatJob.FolderFiles</@example_usage>
	'
	' <@author/>Govardhan Choletti </@author>
	'
	' <@creation_date>09/21/2011</@creation_date>
	'
	' <@mod_block>
	'
	' </@mod_block>
	'
	'**********************************************************************************************
	Public Function FolderFiles ' <@as> Bool

		Services.StartTransaction "FolderFiles" ' Timer Begin
		Reporter.ReportEvent micDone, "FolderFiles", "Function Begin"
			
		Dim oFso, oFile, oFile1, oFileCount, sFiles
		Set oFso = CreateObject("Scripting.FileSystemObject")
		   
		'Checking if the Rules Template folder for the test is present
		If Not(oFso.FolderExists (Environment.Value("Batch_Job_Path"))) Then 'Report if the folder is not created
			Reporter.ReportEvent micFail, "Batch_Job_Template" , "'BatchJobTemplates' Template folder for "&Environment.Value("TestName")& " does not exist within the Batch Job Template folder"
			FolderFiles = False 'Return Value
			Services.EndTransaction "FolderFiles" ' Timer End
			Exit Function
		Else
			FolderFiles = True	
		End If		
				
		Set oFile = oFso.GetFolder(Environment.Value("Batch_Job_Path"))
		Set oFileCount = oFile.Files
		
		If oFileCount.Count = 0 Then
			Reporter.ReportEvent micFail, "Template File" , "Template files does not exist within "&Environment.Value("Batch_Job_Path")& " folder"
			FolderFiles = False 'Return Value
			Services.EndTransaction "FolderFiles" ' Timer End			
			Exit Function

		Else
			FolderFiles = True	
		End If
		
		For Each oFile1 in oFileCount
			sFiles = sFiles & oFile1.name 
			sFiles = sFiles &   ";"
		Next
		FolderFiles = sFiles

		'Clear object variables
		Set oFso = Nothing
		Set oFile = Nothing
		Set oFile1 = Nothing
		Set oFileCount = Nothing
	
		Reporter.ReportEvent micDone, "FolderFiles", "Function End"
		Services.EndTransaction "FolderFiles" ' Timer End
				
	End Function

	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>RulesEngineReport</@name>
	'  <@purpose>
	'    RulesEngineReport is a public method which is used for Excel reporting purpose
	'  </@purpose>
	'  Start: 
	'  End: 
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.RulesEngineReport("487234729074", "E09", "H# INVALID", ""HIC No is Invalid", "Pass")
	'  Parameters:  
	'  sEncounterNo - string - Encounter No
	'  sErCode - string - Error Code
	'  sErDesc - string - Error Description
	'  sDesc - string - Description
	'  sStatus - string - Pass/Fail
	'  Calls: 
	'  Author: Dhushanth S
	'  Date: 04/20/2010     (Created)
	'
	'  Modifications: 
	'
	'**********************************************************************************************************************************      

	Public Function RulesEngineReport(sEncounterNo, sErCode, sErDesc, sDesc,sStatus)
		Dim iRowCount, SheetName
		Dim Excel
	
		If Environment.Value("RunEnv") = "TEST" Then
			SheetName = "RulesEngine_Ovations"
		ElseIf    Environment.Value("RunEnv") = "TEST1" Then
			SheetName = "RulesEngine_Commercial"
	   End If
	
	   Set Excel = FileIO.OpenExcel(Environment.Value("ReportPath"))
	
			Excel.Sheets(SheetName).Select
			iRowCount = Excel.Sheets(SheetName).UsedRange.Rows.Count
			Excel.Sheets(SheetName).Cells(iRowCount+1,1).Value = iRowCount 
			Excel.Sheets(SheetName).Cells(iRowCount+1,2).Value = Environment.Value("TestName")
			Excel.Sheets(SheetName).Cells(iRowCount+1,3).Value = sEncounterNo
			Excel.Sheets(SheetName).Cells(iRowCount+1,4).Value = sErCode
			Excel.Sheets(SheetName).Cells(iRowCount+1,5).Value = sErDesc
			Excel.Sheets(SheetName).Cells(iRowCount+1,6).Value = sDesc
			Excel.Sheets(SheetName).Cells(iRowCount+1,7).Value = sStatus
			Excel.Sheets(SheetName).Cells(iRowCount+1,8).Value = Cstr(Now)
			Excel.ActiveWorkBook.Save
			Excel.DisplayAlerts = False
			FileIO.CloseExcel(Excel)
	
	   Set Excel = Nothing
	End Function

	
	'<@comments>
	'**********************************************************************************************
	'	<@name>runCmdLine</@name>
	'
	' <@purpose>
	'   Runs command line (sCmd) parameter within a command window (DOS Prompt)
	'   and waits until execution of the command is complete, if bWait parameter is true
	' </@purpose>
	'
	' <@parameters>
	'   sCmd - (ByVal) = String - Command Line to run within the command window (DOS Prompt)
	'                             You must include any parameters you want to pass to the executable file.
	'   bWait - (ByVal) = Boolean - (True/False) - Should script halt until process is complete
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'            True -  If found
	'            False - If not found or other function error
	' </@return>
	'
	' <@assumptions>None</@assumptions>
	'
	' <@example_usage>
	'   ChSyBatJob.runCmdLine("ipconfig -all", True)
	' </@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@mod_block>
	'			Govardhan, Choletti -- Copied the Function from IRADS Team UtilFunction_IRADS.vbs
	' </@mod_block> 
	'
	'**********************************************************************************************
	'</@comments>
	Public Function runCmdLine(ByVal sCmd, ByVal bWait) ' <@as> Boolean
		
		Reporter.ReportEvent micDone, "runCmdLine Function", "Function Begin" 
		Services.StartTransaction "runCmdLine" ' Timer Begin
		
		' Variable Declaration / Initialization
		Dim oWShell, iReturn
		
		' Check to verify passed parameters that they are not null or an empty string
		If IsNull(sCmd) or sCmd = "" or IsNull(bWait) or bWait = "" Then
	 		Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the runCmdLine function check passed parameters"
	 		runCmdLine = False ' Return Value
	 		Services.EndTransaction "runCmdLine" ' Timer End
	 		Exit Function
	  End If
	  
	  ' Create WScript Shell Object
	  Set oWShell = CreateObject("WScript.Shell")
	
	  On Error Resume Next
	  If InStr(1, LCase(sCmd), "cmd", 1) > 0 Then
	  	iReturn = oWShell.run(sCmd, 1, bWait) ' 1 Argument - Displays and activates the window
	  Else ' Non cmd run command - run the dos window command with the the window hidden
	  	iReturn = oWShell.run(sCmd, 0, bWait) ' 0 Argument - Hides the window and activates another window
	  End If
	
	  If Err.Number <> 0 Then
		  Reporter.ReportEvent micFail, "Run Command", "Error Thrown " & Err.Number _
		                                                               & vbNewLine & Err.Description _
		                                                               & "while trying to run command" _
		                                                               & vbNewLine & sCmd
		  runCmdLine = False ' Return Value
	  Else ' No Error Thrown
		  If iReturn = 0 Then ' Process complete without error
				runCmdLine = True ' Return Value
		  Else ' Process complete with error
				runCmdLine = False ' Return Value
		  End If	
	  End If
	 
	  ' Clear Object Variables
	  Set oWShell = Nothing
		
		Reporter.ReportEvent micDone, "runCmdLine Function", "Function End" 
		Services.EndTransaction "runCmdLine" ' Timer End
		
	End Function
	
	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>GetProc</@name>
	'
	'  <@purpose>
	'    GetProc is a public method which gets the processes running on a windows device and, optionally,
	'    terminates them
	'  </@purpose>
	'
	'  Start: 
	'
	'  End: 
	'
	'  Assumptions: 
	'
	'  Example Usage: Util.GetProc(process, kill process boolean, name boolean)
	'
	'  Parameters:  sProc - string - the process we're looking for.  This should match the             
	'                                                        Image Name column on the Processes tab of the                
	'                                                        Windows Task Manager.    
	'                             bKill - boolean - if set to TRUE, we'll terminate any processes matching the proc passed in.
	'                                                            if set to FALSE, the function will count processes matching the proc passed in     
	'                             bName - boolean - if set to TRUE, return the user name associated with the process                       
	'
	'  Notes: If we're killing the process, this method returns TRUE or FALSE based on its ability to terminate the 
	'                specified process.  If we're counting processes, the method returns a count of specified processes.
	'                If the name boolean is set to TRUE, the method returns the user name associated with the speicified
	'                process.
	'
	'  Calls: 
	'
	'  Author: Jeff Rippey
	'
	'  Date: 11/30/2006     (Created)
	' <@mod_block>
	'			Modifications: 09/23/2011 - Govardhan, Choletti - Customized for ChartSync application
	' </@mod_block>
	'**********************************************************************************************************************************      
	'</@comments>
	'001 begin
		public Function GetProc(sProc,bKill,bName) ' <@as> Boolean 
		  Dim WMIService
		  Dim Processes
		  Dim Process
		  Dim iProcCount
		  Dim sUserName '006
		  Dim sUserDomain '006
		  
			'set the WMIService object to the win management system
			set WMIService = GetObject("winmgmts:\\.\root\cimv2")
			'set the processes object to the result of a query from win32_processes where the process
			'name is the process we're interested in
			set Processes = WMIService.ExecQuery("Select * from Win32_Process where Name = " & "'" & sProc & "'")

	'006 begin
			'if we're looking for the process owner
			If bName Then
				Reporter.ReportEvent micDone,"GetProc","Retrieving process owner's name"
				'get the user name and domain tied to the process, we're only returning the user name
				For each Process in Processes
					Process.GetOwner sUserName,sUserDomain
					GetProc = sUserName
					'exit after setting user name
					Exit Function
				Next
			End If
	'006 end

			'check and see if we're killing processes
			If bKill Then
				Reporter.ReportEvent micDone,"GetProc","Killing the process " & sProc
				'loop through the processes and terminate them
				for each Process in Processes
					Process.Terminate
				next
				GetProc = TRUE
			else
				Reporter.ReportEvent micDone,"GetProc","Counting running processes for " & sProc
				'we're here if we just want to count running processes
				GetProc = Processes.Count
			End If
			
		end Function
	
	
	'<@comments>
	'**********************************************************************************************
	' <@name>RmChr</@name>
	'
	' <@purpose>
	'   Removes the specified set of characters from the STRING provided
	' </@purpose>
	'
	' <@parameters>
	'       sProvidedString = String  - String in which characters are to be removed
 	'       remove  = Integer - What has to be removed?
 	' </@parameters>
	'
	' <@return>
	'  		 Returns the modified string, which has all the disallowed characters removed
	' </@return>
	'
	' <@assumptions>
	'   None
	' </@assumptions>
	'
	' <@example_usage>
	'   ChSyBatJob.RmChr(IMBRUtil.GetTagValue(sFileContent,"summary"), vbTab & vbCrLf)
	' </@example_usage>
	'
	' <@author>Karthik Bapu</@author>
	'
	' <@creation_date>04-28-2009</@creation_date>
	'
	' <@mod_block>
	'			Modifications: 09/23/2011 - Govardhan, Choletti - Customized for ChartSync application
	' </@mod_block>
	'
	'**********************************************************************************************
	Public Function RmChr(byVal sProvidedString, byVal remove) '<@as> STRING  
	  Services.StartTransaction "RmChr" ' Timer Begin   
	  Reporter.ReportEvent micDone, "RmChr Function", "Function begin"
	  
   	 ' Check to verify passed parameters that they are not null or an empty string
	   If isNull(sProvidedString) or sProvidedString="" or remove = "" or isNull(remove) Then
		   Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to  RmChr function check passed parameters"
		   RmChr = False ' Return Value
		   Services.EndTransaction "RmChr"
		   Exit Function
	   End If
	  
		Dim i, j, tmp, strOutput
		strOutput = ""
		for j = 1 to len(sProvidedString)
			tmp = Mid(sProvidedString, j, 1)
			for i = 1 to len(remove)
				tmp = replace( tmp, Mid(remove, i, 1), "")
				if len(tmp) = 0 then exit for
			next
			strOutput = strOutput & tmp
		next
		RmChr = strOutput
		
	 Reporter.ReportEvent micDone, "RmChr Function", "Function End"
	 Services.EndTransaction "RmChr"
	End Function
	
	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>connectPuttyWithOutAddin</@name>
	'  <@purpose>
	'    connectPuttyWithOutAddin is a public method which connect to the given machine ip through putty 
	'	 With out any additional Addins
	'  </@purpose>
	'  Start: 
	'  End: 
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.connectPuttyWithOutAddin(installpath, "10.236.214.222","33")
	'  Parameters:  
	'  sPuttyInstallPath - string - Install path of the Putty exe
	'  sMachineIP - string - IP of the given machine
	'  sPortNumber - integer - port number to connect
	'  Calls: 
	'  Author: Govardhan Choletti
	'  Date: 23/09/2011     (Created)
	'
	'  Modifications:
	'
	'**********************************************************************************************************************************      
	'</@comments>	
	Public Function connectPuttyWithOutAddin(ByVal sPuttyInstallPath, ByVal sMachineIP, ByVal sPortNumber) 'as boolean

		Services.StartTransaction "connectPuttyWithOutAddin" ' Timer Begin
		Reporter.ReportEvent micDone, "connectPuttyWithOutAddin", "Function Begin"
		
		' Kill all previously existing putty instances
		ChSyBatJob.GetProc "putty.exe", True, False

		' Invoke Putty
		Systemutil.run(sPuttyInstallPath)

		' Connect to the server if the Putty screen loaded
		If  window("regexpwndtitle:=putty configuration").Exist(50) Then
			With Window("regexpwndtitle:=PuTTY Configuration")  
			  'Enter IP address and press open button  
			  .activate
			  .WinEdit("nativeclass:= Edit", "attached text:=Host \&Name \(or IP address\)").Set sMachineIP  
			  .winedit("nativeclass:=edit","attached text:=&Port").Set sPortNumber
			  .winradiobutton("nativeclass:=button","text:=&SSH").set
			  .WinButton("text:= \&Open").Click  
			End With
		Else
			Reporter.ReportEvent "Open Putty", "Could not load the putty exe. Please check the path of the exe."
		End If
		
		' Verify If the Command Window is populated
		wait(3)
		If Window("regexpwndtitle:=PuTTY", "regexpwndclass:=PuTTY").Exist(20) Then 
			'Verify that whether Putty got opened or not
			If Window("regexpwndtitle:=PuTTY", "regexpwndclass:=PuTTY").GetVisibleText <> ""  Then
				Reporter.ReportEvent micPass, "Open Putty", "Putty is opened successfully for the given IP " & sMachineIP
				connectPuttyWithOutAddin = True
			Else
				' Handling the Connection Timed out/Refused Error
				If window("nativeclass:=putty").Dialog("text:=PuTTY Fatal Error").Exist(30) Then
					Reporter.ReportEvent micFail, "Open Putty", "Connection Timed out/ Connection Refused Error. Fatal error occured while connecting putty."
					connectPuttyWithOutAddin = False
					ChSyBatJob.GetProc "putty.exe", True, False
					Exit Function
				End If
				'Handle any other failure conditions 
				Reporter.ReportEvent micFail, "Open Putty", "Unable to open the Putty. Please check the IP/install path provided"
				ChSyBatJob.GetProc "putty.exe", True, False
				connectPuttyWithOutAddin = False
			End If
		Else
			Reporter.ReportEvent micFail,"Putty Load", "Putty window load failed"
		End If
		Reporter.ReportEvent micDone, "connectPuttyWithOutAddin", "Function End"
		Services.EndTransaction "connectPuttyWithOutAddin" ' Timer End

	End Function
	
	
	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>loginVerifyPuttyWithOutAddin</@name>
	'  <@purpose>
	'    loginVerifyPuttyWithOutAddin is a public method which login to putty for the given user name and navigate upto the given folder
	'  </@purpose>
	'  Start: 
	'  End: 
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.loginVerifyPuttyWithOutAddin("cseuser", "password","10.236.235.23","/data/qa/QA_Utilities")
	'  Parameters:  
	'  sUserName - string - Username to access the given machine
	'  sPassword - string - Password for the given user
	'  sMachineIP - string - Givewn machine IP
	'  sNavigateFolder - string - Folder to execute the shell script
	'  Calls: 
	'  Author: Govardhan, Choletti
	'  Date: 11/03/2009     (Created)
	'
	'  Modifications: 09/23/2011 - Govardhan, Choletti - Customized for ChartSync application
	'**********************************************************************************************************************************      
	'</@comments>	
	Public Function loginVerifyPuttyWithOutAddin(ByVal sUserName, ByVal sPassword, ByVal sMachineIP, ByVal sNavigateFolder)

		Services.StartTransaction "loginVerifyPuttyWithOutAddin" ' Timer Begin
		Reporter.ReportEvent micDone, "loginVerifyPuttyWithOutAddin", "Function Begin"
		
		Dim sString, sCommand
		wait (5)
		sString = "login as:"
		'Window("regexpwndtitle:=PuTTY", "regexpwndclass:=PuTTY").Resize 500, 125
		With Window("regexpwndtitle:=PuTTY", "regexpwndclass:=PuTTY")  
			.Activate
			If ChSyBatJob.PuttyWait(sString) Then 
				.Type sUserName  
				.Type micReturn 
				If Environment.Value("RUN_ENV") = "TEST" Then
					'sString = sUserName & "@" & sMachineIP & "'s password:"
					sString = sUserName & "'s Password:"
				ElseIf Environment.Value("RUN_ENV") = "STG" Then
					sString = sUserName & "'s Password:"
				End If
				If ChSyBatJob.PuttyWait(sString) Then
					Reporter.ReportEvent micPass, sUserName & " Command execution", "passed in '" & sUserName & " Command execution"
					.Type sPassword
					.Type micReturn
					wait (3)
					sString = "bash"
					If Environment.Value("RUN_ENV") = "TEST" Then
						.Type "exit"
						.Type micReturn
					End If
					If ChSyBatJob.PuttyWait(sString) Then
						Reporter.ReportEvent micPass, sPassword & " Command execution", "passed in '" & sPassword & " Command execution"
						sCommand = "cd " & sNavigateFolder
						.Type sCommand  
						.Type micReturn
						If ChSyBatJob.PuttyWait(sString) Then
							Reporter.ReportEvent micPass, sCommand & " Command execution", "Passed in '" & sCommand & " Command execution"
							loginVerifyPuttyWithOutAddin = True
						Else
							Reporter.ReportEvent micFail, sCommand & " Command execution", "Failed in '" & sCommand & " Command execution"
							Reporter.ReportEvent micFail, sString & " check", "Failed in '" & sString & " check"
							loginVerifyPuttyWithOutAddin = False
							Exit Function
						End If
					Else
						Reporter.ReportEvent micFail, sPassword & " Command execution", "Failed in '" & sPassword & " Command execution"
						Reporter.ReportEvent micFail, sString & " check", "Failed in '" & sString & " check"
						loginVerifyPuttyWithOutAddin = False
						Exit Function
					End If
				Else
					Reporter.ReportEvent micFail, sUserName & " Command execution", "Failed in '" & sUserName & " Command execution"
					Reporter.ReportEvent micFail, sString & " check", "Failed in '" & sString & " check"
					loginVerifyPuttyWithOutAddin = False
					Exit Function									
				End If			
			Else
				Reporter.ReportEvent micFail, sString & " check", "Failed in '" & sString & " check"
				loginVerifyPuttyWithOutAddin = False
				Exit Function
			End If 
		
		End With 
		Reporter.ReportEvent micDone, "loginVerifyPuttyWithOutAddin", "Function End"
		Services.EndTransaction "loginVerifyPuttyWithOutAddin" ' Timer End
	End Function
	
	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>PuttyWait</@name>
	'  <@purpose>
	'    PuttyWait is a public method which verifies the given string is available in the TeScreen or not after having a suitab wait routine
	'  </@purpose>
	'  Start: 
	'  End: 
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.PuttyWait("login as")
	'  Parameters:  
	'  sString - string - String to be verified in the TeScreen
	'  Calls: 
	'  Author: Govardhan Choletti
	'  Date: 09/26/2011     (Created)
	'
	'Modifications: 04/01/2010 - Govardhan Choletti - Customized for ChartSync application
	'**********************************************************************************************************************************      
	'</@comments>
	Public Function PuttyWait(ByRef sString)
		Dim sText, iCount, iMyPos, iHeight, iWidth
		iCount = 0
		Services.StartTransaction "PuttyWait" ' Timer Begin
		Reporter.ReportEvent micDone, "PuttyWait", "Function Begin"
		
		' Get the Height and width of the putty Command prompt box
		iHeight = Window("regexpwndtitle:=PuTTY", "regexpwndclass:=PuTTY").GetROProperty("height")
		iWidth = Window("regexpwndtitle:=PuTTY", "regexpwndclass:=PuTTY").GetROProperty("width")

		Do  
			wait(1) 
			iCount = iCount + 1
			' If the Visible text of the bottom screen is empty then fetch the complete content of the Box
			sText= Window("regexpwndtitle:=PuTTY", "regexpwndclass:=PuTTY").GetVisibleText (0, iHeight-125 ,iWidth, iHeight)
			If IsNull(sText) or Trim(sText) = "" or Len(sText)=1 or Len(sText)=2 Then
				sText= Window("regexpwndtitle:=PuTTY", "regexpwndclass:=PuTTY").GetVisibleText
			End If
			'sText = ChSyBatJob.RmChr(sText,Chr(10))	
			'If the string is available, then [proceed further after wait of some period say 25 Seconds for the string and report FAIL
			If Instr(1,Trim(sText),Trim(sString)) > 0 Then
				Reporter.ReportEvent micPass, "String Text found","The given string '" & sString & "' is found in the TeTextScreen"
				PuttyWait = True
				Exit Do
			End If
			iMyPos = Instr(sText, sString)  
		loop until (iMyPos >0  AND iCount<=25)
		
		If (iCount >= 25) Then
			Reporter.ReportEvent micFail, "String Text found","The given string '" & sString & "' is not found in the TeTextScreen and the text displayed is '" & sText & "'"			
			PuttyWait = False
		End If
		
		Reporter.ReportEvent micDone, "PuttyWait", "Function End"
		Services.EndTransaction "PuttyWait" ' Timer End
	End Function

	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>ExecuteCommandWithOutAddin</@name>
	'  <@purpose>
	'    ExecuteCommandWithOutAddin is a public method which executes the given command with the given argument thru PLink
	'  </@purpose>
	'  Start: 
	'  End: 
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.ExecuteCommandWithOutAddin("cd /data/qa/QA_Utilities","")
	'  Parameters:  
	'  sCommand - string - Command to execute
	'  sArgList - string - argument for the given command
	'  Calls: 
	'  Author: Govardhan, Choletti 
	'  Date: 09/26/2011     (Created)
	' 
	'  Modifications: 09/23/2011 - Govardhan, Choletti - Customized for ChartSync application
	'**********************************************************************************************************************************      
	'</@comments>
	Public Function ExecuteCommandWithOutAddin(ByVal sCommand, ByVal sArgList)

		Services.StartTransaction "ExecuteCommandWithOutAddin" ' Timer Begin
		Reporter.ReportEvent micDone, "ExecuteCommandWithOutAddin", "Function Begin"		
		Dim oTeWindow, oTeTextScreen
		Dim sChar, sCommandLength, sArgLength, intI, intJ, sText, intK
		Dim sSplitVal, iHeight, iWidth

		'Piclink the appropriate data based on the Environment
	  	If Instr(1, sArgList, ";") <> 0 Then
			sSplitVal = Split(sArgList, ";")
			If Environment.Value("RunEnv") = "TEST" Then
				sArgList = sSplitVal(0)
			'ElseIf Environment.Value("RunEnv") = "TEST1" Then
			'	sArgList = sSplitVal(1)
			Else
				sArgList = sSplitVal(0)	
			End If
		End If
		With Window("regexpwndtitle:=PuTTY", "regexpwndclass:=PuTTY")  
				
			If .Exist(15) Then
				' Get the Position coordinates of the Window
				iHeight = .GetROProperty("height")
				iWidth = .GetROProperty("width")
		
				' Check If the Execute command is to enter the "UNIX Password" on the Screen
				If sCommand = Environment("UnixPassword") Then
					.Type(sCommand)
					.Type(micReturn)
					ExecuteCommandWithOutAddin = True
					Reporter.ReportEvent micDone, "ExecuteCommandWithOutAddin", "Function End"
					Services.EndTransaction "ExecuteCommandWithOutAddin" ' Timer End
					Exit Function
				End If
				
				' If No Arguments are passed as Input
				If sArgList = "" Then 
					For intI = 1 to 3
						sText = ""
						.Type(sCommand)
						wait (1)
						sText= .GetVisibleText (0, iHeight-125 ,iWidth, iHeight)
						'sText = util.RmChr(sText,Chr(10))	 
						For intK = 1 to 32	
							If Instr(1,sText, chr(intK)) and intK <>32Then
								sText = Replace(sText, chr(intK),"")
							End If
						Next   			
						
						If Instr(1,sText,sCommand) > 0 Then
							.Type(micReturn)
							Reporter.ReportEvent micPass, "String Text found","The given string '" & sCommand & "' is found in the TeTextScreen"
							intI = 3
						Else
							sCommandLength = Len(sCommand)
							For intJ = 1 to sCommandLength
								.Type(micBack)
							Next
							Reporter.ReportEvent micInfo, "String Text found","The given string '" & sCommand & "' is not found in the TeTextScreen and the text displayed is '" & sText & "'"			
						End If	
					Next
									
					Reporter.ReportEvent micPass, "ExecuteCommandWithOutAddin ", "Command '" & sCommand & "' is executed successfully"
					ExecuteCommandWithOutAddin = True
				' If Arguments are passed as Input
				Else
					sCommand = sCommand & " " & (sArgList)
								
					For intI = 1 to 3
						sText = ""
						.Type(sCommand)
						wait (1)
						
						sText= .GetVisibleText (0, iHeight-125 ,iWidth, iHeight)
						'sText = util.RmChr(sText,Chr(10))		
						For intK = 1 to 32	
							If Instr(1,sText, chr(intK)) and intK <> 32Then
								sText = Replace(sText, chr(intK),"")
							End If
						Next 
						
						If Instr(1,sText,sCommand) > 0 Then
							.Type(micReturn)
							Reporter.ReportEvent micPass, "String Text found","The given string '" & sCommand & "' is found in the TeTextScreen"
							intI = 3
						Else
							sCommandLength = Len(sCommand)
							For intJ = 1 to sCommandLength
								.Type(micBack)
							Next
							Reporter.ReportEvent micInfo, "String Text found","The given string '" & sCommand & "' is not found in the TeTextScreen and the text displayed is '" & sText & "'"			
						End If	
					Next

					Reporter.ReportEvent micPass, "Execute Command WithOutAddin", "Command '" & sCommand & "' is executed with the argument '" & sArgList & "' successfully"
					ExecuteCommandWithOutAddin = True
					
				End If
			Else
				Reporter.ReportEvent micFail, "Execute Command WithOutAddin", "Unable to find the PUTTY window"
				ExecuteCommandWithOutAddin = False
			End If
		End With
		Reporter.ReportEvent micDone, "ExecuteCommandWithOutAddin", "Function End"
		Services.EndTransaction "ExecuteCommandWithOutAddin" ' Timer End
	End Function
	
	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>CheckForBashStringWithOutAddin</@name>
	'  <@purpose>
	'    CheckForBashStringWithOutAddin is a public method which verifies the given string is available in the TeScreen or not within 2 minutes
	'  </@purpose>
	'  Start: 
	'  End: 
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.CheckForBashStringWithOutAddin("bash$")
	'  Parameters:  
	'  sString - string - String to be verified in the TeScreen
	'  Calls: 
	'  Author: Dhushanth S
	'  Date: 06/21/2010     (Created)
	'
	'Modifications: 04/01/2010 - Govardhan Choletti - Customized for ChartSync application
	'
	'**********************************************************************************************************************************      
	Public Function CheckForBashStringWithOutAddin(ByVal sString)
	
		Services.StartTransaction "CheckForBashStringWithOutAddin" ' Timer Begin
		Reporter.ReportEvent micDone, "CheckForBashStringWithOutAddin", "Function Begin"
		
		Dim sText, iCount, iMyPos, iHeight, iWidth
		iCount = 0
		
		' Get the Height and width of the putty Command prompt box
		iHeight = Window("regexpwndtitle:=PuTTY", "regexpwndclass:=PuTTY").GetROProperty("height")
		iWidth = Window("regexpwndtitle:=PuTTY", "regexpwndclass:=PuTTY").GetROProperty("width")
		CheckForBashStringWithOutAddin = False
		
		Do  
			wait(1) 
			iCount = iCount + 1
			' If the Visible text of the bottom screen is empty then fetch the complete content of the Box
			sText= Window("regexpwndtitle:=PuTTY", "regexpwndclass:=PuTTY").GetVisibleText (0, iHeight-150 ,iWidth, iHeight)
			
			If IsNull(sText) or Trim(sText) = "" or Len(sText)=1 Then
				sText= Window("regexpwndtitle:=PuTTY", "regexpwndclass:=PuTTY").GetVisibleText
			End If
			
			'sText = ChSyBatJob.RmChr(sText,Chr(10))	
			'If the string is available, then [proceed further after wait of some period say 25 Seconds for the string and report FAIL
			If Instr(1,Trim(Right(sText,8)),Trim(sString)) > 0 Then
				Reporter.ReportEvent micPass, "String Text found","The given string '" & sString & "' is found in the TeTextScreen"
				CheckForBashStringWithOutAddin = True
				Exit Do
			End If
			iMyPos = Instr(1,Trim(Right(sText,8)),Trim(sString))
		loop until (iMyPos >0  AND iCount<=45)
		
		If (iCount >= 45) And Not(CheckForBashStringWithOutAddin) Then
			Reporter.ReportEvent micFail, "String Text found","The given string '" & sString & "' is not found in the TeTextScreen and the text displayed is '" & sText & "'"			
		End If	

		Reporter.ReportEvent micDone, "CheckForBashStringWithOutAddin", "Function End"
		Services.EndTransaction "CheckForBashStringWithOutAddin" ' Timer End
	End Function
		
	'<@comments>
	'**********************************************************************************************
	'  <@name>randomDataGeneration</@name>
	'  <@purpose>
	'    randomDataGeneration is a public method that will create a Random Data as opted by user
	'	 sRndGenType - ALPHA, NUMBER, SPECIALCHAR, COMBO, ALPHANUMERIC, SPACE
	'	 iRndGenLen - Length of the Record
	'  </@purpose>
	'  Start: 
	'  End: 
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.randomDataGeneration("ALPHANUMERIC", 10)
	'  Parameters:  
	'  sString - string - String to be verified in the TeScreen
	'  Calls: 
	'  Author: Govardhan Choletti
	'  Date: 09/24/2012     (Created)
	'**********************************************************************************************
	'</@comments>
	Public Function randomDataGeneration (ByVal sRndGenType, ByVal iRndGenLen)
		
		'Initialise Variable
		Dim iCnt
		Dim	sRandomType, sFinalString
		Dim aSelection
		Services.StartTransaction "randomDataGeneration" ' Timer Begin
		Reporter.ReportEvent micDone, "randomDataGeneration", "Function Begin"
		
	' Check to verify passed parameters that they are not null or an empty string
	   If Instr(1, "ALPHABET~NUMBER~SPECIALCHAR~SPACE~COMBO~ALPHANUMERIC" ,UCase(sRndGenType), 1) = 0 Then
		    Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters '"& sRndGenType &"' were passed to the randomDataGeneration function check passed parameters"
		    Services.EndTransaction "randomDataGeneration" ' Timer End
		    Exit Function
	   End If
	   
	' Verify Random data Generation Length is an Numeric
		If Not(IsNumeric(iRndGenLen)) Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters '"& sRndGenType &"' were passed to the randomDataGeneration function check passed parameters"
		    Services.EndTransaction "randomDataGeneration" ' Timer End
		    Exit Function
		End If
	   
	' Variable Declaration / Initialization
		sFinalString = ""
		For iCnt = 1 to iRndGenLen
			If	Instr(1, "ALPHANUMERIC" ,UCase(sRndGenType), 1) > 0 Then
				aSelection = Array("ALPHABET","SPACE","NUMBER")
				'sRandomType = aSelection(Int((UBound(aSelection)+1)*Rnd))
				sRandomType = aSelection(RandomNumber(0,2))
			ElseIf	Instr(1, "COMBO" ,UCase(sRndGenType), 1) > 0 Then
				aSelection = Array("ALPHABET","SPACE","NUMBER","SPECIALCHAR")
				'sRandomType = aSelection(Int((UBound(aSelection)+1)*Rnd))
				sRandomType = aSelection(RandomNumber(0,3))
			Else
				sRandomType = sRndGenType
			End If
			
			'Generate Random data as requested by User
			Select Case UCASE(TRIM(sRandomType))
				Case "ALPHABET"
					sFinalString = sFinalString & CHR(RandomNumber(97,122))
				Case "NUMBER"
					'sFinalString = sFinalString & Int((10*Rnd)+0) 	' Generates a Random value between 0 & 9
					sFinalString = sFinalString & RandomNumber(0,9)
				Case "SPACE"
					sFinalString = sFinalString & " "
				Case "SPECIALCHAR"
					sFinalString = sFinalString & CHR(RandomNumber(33,40))
			End Select
		Next
		
		' Random String prepared for Input passed
		Reporter.ReportEvent micDone, "randomDataGeneration ==> Date Generation", "Successfully generated random data i.e - '"& sFinalString &"' as Expected"
		randomDataGeneration = sFinalString
		
	  Reporter.ReportEvent micDone, "randomDataGeneration", "Function End"
	  Services.EndTransaction "randomDataGeneration" ' Timer End	
	End Function
	
	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>addressMatchInboundLoad</@name>
	'    addressMatchInboundLoad is a public method that will create a valid Address Match Inbound File for the Input parameter passed
	'	 sDBSearchInput - Run the DB Query as per the input supplied
	'	 iRecordCnt - No of Records to be created for 1 Retrieval Provider passed as Input (Max Value - 999)
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.addressMatchInboundLoad("ProjKey~100303349", 125)
	'  Example Usage: ChSyBatJob.addressMatchInboundLoad("FileName~LOADCR_INGENIX_20120824120827.Dat", 10)
	'  Parameters: 
	'  Calls: ChSyBatJob.randomDataGeneration("NUMBER", 5)
	'  Author: Govardhan Choletti
	'  Date: 09/24/2012     (Created)
	'  Modifications: 
	'
	'**********************************************************************************************************************************      
	Public Function addressMatchInboundLoad(ByVal sDBSearchInput, ByVal iRecordCnt)
	  'Variable Initialization
		Dim sTime, sFileName, sQueryInput, sMainQuery, sSubQuery, sClientID, sProviderID, sAddressID, sState, sNPI, sTaxID, sLastName, sFirstName, sMiddleName, sSuffix, sPhoneNumber, sAddress1, sAddress2, sCity, sZip, sExtZip, sRecord
		Dim iReqRec, iCnt
		Dim aDBSearchInput
		Dim oFSO, oFileAddInbnd, oRSMain, oRSSub
	
		Services.StartTransaction "addressMatchInboundLoad" ' Timer Begin
		Reporter.ReportEvent micDone, "addressMatchInboundLoad", "Function Begin"

		'Verify Input Parameters
		aDBSearchInput = Split(sDBSearchInput, "~")
		If UBound(aDBSearchInput)= 1 Then
			Select Case UCASE(TRIM(aDBSearchInput(0)))
				Case "PROJKEY"
					sQueryInput = "A.proj_key = '"& aDBSearchInput(1) &"'"
				Case "FILENAME"
					sQueryInput = "A.FileName = '"& aDBSearchInput(1) &"'"
				Case Else
					Reporter.ReportEvent micFail, "addressMatchInboundLoad ==> Invalid Input" , "Please check the First Input parameter i.e., '"& sDBSearchInput &"' and Valid Input Format is 1. (ProjKey~100303349) OR  2.(FileName~LOADCR_INGENIX_20120824120827.Dat)"
					Exit Function
			End Select
		End If

        If Not IsNumeric(iRecordCnt) AND iRecordCnt = 0 Then
			Reporter.ReportEvent micFail, "addressMatchInboundLoad ==> Invalid Input" , "Please check the Second Input parameter i.e., '"& iRecordCnt &"' and Valid Input Format is any Natural Number between 1 and 999"
			Exit Function
		Else
			iRecordCnt = CInt(Left(iRecordCnt, 3))			' Considering only the Left 3 Numbers if User pass and input of more than 3 digit
		End If
		
		' Retrieving Date + Time in Format YYYYMMDDHHMMSS
		sFileName = "ADDRESSMATCHP360CHARTSYNCIN_"
		sTime = Year(Now) & Right("0"& Month(Now), 2) & Right("0"& Day(Now), 2) & Right("0"& Hour(Now), 2) & Right("0"& Minute(Now), 2) & Right("0"& Second(Now), 2)
		Environment.Value("sTimeStamp") = sTime
		iReqRec = 0

		'Create File System Object
        Set oFSO = CreateObject("Scripting.FileSystemObject")

		'Creating folder with current date in NAS Drive \Automation\Application\ChartSync\BatchJobs\QA
		If Not(oFSO.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate"))) Then 'Checking if the folder with current date is already created
			oFSO.CreateFolder ""&Environment.Value("Jobs_Path")&Environment.Value("CurDate") 'creating a new folder with the date in NAS drive
			 If Not(oFSO.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate"))) Then 'Report if the folder is not created
				Reporter.ReportEvent micFail, "addressMatchInboundLoad ==>Jobs_Path" , "Folder with current date was not created inside '"& Environment.Value("Jobs_Path") &"' folder" 
				Services.EndTransaction "addressMatchInboundLoad" ' Timer End
				Exit Function
			End If	
		End If

		'Creating folder with current date\TestName in NAS Drive IRADS\Rules
		If Not(oFSO.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName"))) Then 'Checking if the folder with current date is already created
			oFSO.CreateFolder ""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName") 'creating a new folder with the test name in NAS drive
			 If Not(oFSO.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName"))) Then 'Report if the folder is not created
				Reporter.ReportEvent micFail, "addressMatchInboundLoad ==>Jobs_Path" , "Folder with Test Name was not created inside '"& Environment.Value("Jobs_Path") &"' folder"
				Services.EndTransaction "addressMatchInboundLoad" ' Timer End
				Exit Function
			End If	
		End If

		' Run the Query to Fetch the different Prov Request Key for the User
		sMainQuery = "SELECT Distinct C.Prov_Req_key, C.Prov_Hashcode, A.proj_key, A.FileName FROM ravas.rv_project A "_
							&"INNER JOIN ravas.rv_proj_content_provider B ON B.proj_key = A.proj_key "_ 
							&"INNER JOIN ravas.prov_request C ON C.Prov_Hashcode = B.Prov_Hashcode "_
							&"AND "& sQueryInput	
		set oRSMain = db.executeDBQuery(sMainQuery, Environment.Value("DB"))	
		If LCase(typeName(oRSMain)) <> "recordset" Then
			Reporter.ReportEvent micFail, "addressMatchInboundLoad ==> invalid recordset (Main)", "The database connection did not open or invalid parameters were passed."
		ElseIf oRSMain.bof And oRSMain.eof Then
			Reporter.ReportEvent micFail, "addressMatchInboundLoad ==> Project Load File", "Project File with data "& sDBSearchInput & " is not available in the db, Please Re-Check Input Parameters"
		Else
			Reporter.ReportEvent micDone, "addressMatchInboundLoad ==> valid recordset (Main)", "The returned recordset is valid and contains records."

			 'Creating a new file in \\Nas00582pn\istarr\Automation\Application\IRADS\Rules folder\CurDate\TestName
			Set oFileAddInbnd = oFSO.CreateTextFile(Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName")&"\"&sFileName & Environment.Value("sTimeStamp")&".DAT", True)
			
			Do
				sClientID = oRSMain.fields(0).Value		'Will Fetch From DB Query		'Client  ID from Source System (30)    '****** PROV_REQ_KEY*********
				sSubQuery = "SELECT A.Prov_Resp_key FROM ravas.prov_response A WHERE A.Prov_Req_key = '"& sClientID &"'"	
				set oRSSub = db.executeDBQuery(sSubQuery, Environment.Value("DB"))	
				If LCase(typeName(oRSSub)) <> "recordset" Then
					Reporter.ReportEvent micFail, "addressMatchInboundLoad ==>invalid recordset (Sub)", "The database connection did not open or invalid parameters were passed."
				ElseIf oRSSub.bof And oRSSub.eof Then
					
					' Fixed Fields for 1 records
					'sClientID = 	
					iReqRec = iReqRec + 1
					'sProviderID = sTime & Right(("000000"& iReqRec), 2)		'Unique provider id
					sProviderID = ChSyBatJob.randomDataGeneration("NUMBER", RandomNumber(1,6)) & Right(("000000"& iReqRec), 2)		'Unique provider id
					sAddressID = ChSyBatJob.randomDataGeneration("NUMBER", RandomNumber(1,6)) & Right(("000000"& iReqRec), 2)		'Unique address id
					sState = "AL"
					sNPI = ChSyBatJob.randomDataGeneration("NUMBER", RandomNumber(1,5)) & Right(("000000"& iReqRec), 2)		' Generating Unique Data from digits between 1 and 5
					sTaxID = ChSyBatJob.randomDataGeneration("NUMBER", RandomNumber(1,7)) & Right(("000000"& iReqRec), 2)
		
					'Variable Fields for 1 Record
					For iCnt =1 to iRecordCnt STEP 1
						If iCnt<> 1 Then
							sClientID = ""
						End If
						
						'Creating Empty Blank Lines Immediately after creating First Record
						If iReqRec > 1 OR iCnt<> 1 Then
							oFileAddInbnd.WriteBlankLines(1)
						End If
						sLastName = ChSyBatJob.randomDataGeneration("ALPHANUMERIC", RandomNumber(1,50))
						sFirstName = ChSyBatJob.randomDataGeneration("ALPHANUMERIC", RandomNumber(1,25))
						sMiddleName = ChSyBatJob.randomDataGeneration("ALPHANUMERIC", RandomNumber(1,25))
						sSuffix = ChSyBatJob.randomDataGeneration("ALPHANUMERIC",  RandomNumber(1,5))
						sPhoneNumber = ChSyBatJob.randomDataGeneration("NUMBER", 10)
						sAddress1 = ChSyBatJob.randomDataGeneration("ALPHANUMERIC", RandomNumber(1,100))
						sAddress2 = ChSyBatJob.randomDataGeneration("ALPHANUMERIC", RandomNumber(1,100))
						sCity = ChSyBatJob.randomDataGeneration("ALPHANUMERIC", RandomNumber(1,50))
						sZip = ChSyBatJob.randomDataGeneration("NUMBER", 5)
						sExtZip = ChSyBatJob.randomDataGeneration("NUMBER", 4)
			
					' Prepare a DB Query to generate data for address Match In bound
						sRecord = sClientID &"|"& sProviderID &"|"& sAddressID &"|"& sLastName &"|"& sFirstName &"|"& sMiddleName &"|"& sSuffix &"|"& sPhoneNumber &"|"& sAddress1 &"|"& sAddress2 &"|"& sCity &"|"& sState &"|"& sZip &"|"& sExtZip &"|"& sNPI & Right(("000000"& iCnt), Len(iRecordCnt))& "|"& sTaxID &"|"
						oFileAddInbnd.Write "" &sRecord
					Next
				Else
					Reporter.ReportEvent micWarning, "addressMatchInboundLoad ==> File Creation", "Address Match Inbound File cann't be prepared as Prov_response_key '"& oRSSub.fields(0).Value &"' is already created for the Project '"& aDBSearchInput(1) &"'"
				End If
				oRSMain.MoveNext
			Loop Until  (oRSMain.eof )
		End If
		oFileAddInbnd.Close
		
		If iReqRec <> 0 Then
			addressMatchInboundLoad = sFileName & Environment.Value("sTimeStamp")&".DAT"
			Reporter.ReportEvent micPass, "addressMatchInboundLoad ==> File Creation", "Address Match Inbound File '"& sFileName & Environment.Value("sTimeStamp")&".DAT" &"' prepared successfully, as Expected"
		End If
		Reporter.ReportEvent micDone, "addressMatchInboundLoad", "Function End"
		Services.EndTransaction "addressMatchInboundLoad" ' Timer End

		'Clear object variables
        Set oFSO = Nothing
		Set oFileAddInbnd = Nothing
		Set oRSMain = Nothing
		Set oRSSub = Nothing
	End Function
	
	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>loadChartImage</@name>
	'    loadChartImage is a public method that will create a valid Chart & load on to application thru Batch Job
	'	 sDBSearchInput - Run the DB Query as per the input supplied
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.loadChartImage("ProjKey~100303349", "TCS", "INGENIX CODING")
	'  Example Usage: ChSyBatJob.loadChartImage("FileName~LOADCR_INGENIX_20120824120827.Dat", "", "")
	'  Parameters: 
	'  Calls:	util.AssignOrganizationInformation("",sRetOrgVal, sCodOrgVal)
	'	 		ChSyBatJob.FolderFiles()
	'			ChSyBatJob.runCmdLine(sCommand, TRUE)
	'			ChSyBatJob.connectPuttyWithOutAddin(Environment("puttyexepath"), Environment("UnixServer"),Environment("PortNumber"))
	'			ChSyBatJob.ExecuteCommandWithOutAddin("sh ravasbatchclient.sh","RVUI0003")
	'			ChSyBatJob.BatchJobFileLoadCheck(sFileName, 4)
	'  Author: Govardhan Choletti
	'  Date: 10/04/2012     (Created)
	'  Modifications: 
	'**********************************************************************************************************************************      
	Public Function loadChartImage(ByVal sDBSearchInput, ByVal sRetOrgVal, ByVal sCodOrgVal)

	  'Variable Initialization
		Dim sProjCodeSTD, sProjCodePAF, sQueryInput, sMainQuery, sVendorCode, sBarcode, sExtChartID, sRetReqSts, sProjType, sProjID, sTime, sFileName, sFileTempName
		Dim aDBSearchInput, aFileName, sCommand
		Dim iLoopCnt, i
		Dim bFileLoad
		Dim oRSMain, oFSO
        	
		Services.StartTransaction "loadChartImage" ' Timer Begin
		Reporter.ReportEvent micDone, "loadChartImage", "Function Begin"

		'Variable Initialisation
		loadChartImage = False
		sProjCodeSTD = "INGENIX"
		sProjCodePAF = "CF"

		'Verify Input Parameters
		aDBSearchInput = Split(sDBSearchInput, "~")
		If UBound(aDBSearchInput)= 1 Then
			Select Case UCASE(TRIM(aDBSearchInput(0)))
				Case "PROJKEY"
					sQueryInput = "B.proj_key = '"& aDBSearchInput(1) &"'"
				Case "FILENAME"
					sQueryInput = "B.FileName = '"& aDBSearchInput(1) &"'"
				Case Else
					Reporter.ReportEvent micFail, "loadChartImage ==> Invalid Input" , "Please check the First Input parameter i.e., '"& sDBSearchInput &"' and Valid Input Format is 1. (ProjKey~100303349) OR  2.(FileName~LOADCR_INGENIX_20120824120827.Dat)"
					Exit Function
			End Select
		End If

		' Run the Query to Fetch the different Prov Request Key for the User
		sMainQuery = "SELECT C.vendor_code, A.proj_content_barcode, A.External_Chart_Id, A.retrieval_request_status, B.Proj_review_type, A.proj_key "_
					&"FROM ravas.rv_proj_content A "_
					&"INNER JOIN ravas.rv_project B ON B.proj_key = A.proj_key "_
					&"INNER JOIN ravas.rv_vendor C ON C.vendor_name = B.proj_retrieval_vendor "_
					&"AND "& sQueryInput	
		Set oRSMain = db.executeDBQuery(sMainQuery, Environment.Value("DB"))	
		If LCase(typeName(oRSMain)) <> "recordset" Then
			Reporter.ReportEvent micFail, "loadChartImage ==> invalid recordset (Main)", "The database connection did not open or invalid parameters were passed."
		ElseIf oRSMain.bof And oRSMain.eof Then
			Reporter.ReportEvent micFail, "loadChartImage ==> Project Load File", "Project File with data "& sDBSearchInput & " is not available in the db, Please Re-Check Input Parameters"
		Else
			Reporter.ReportEvent micDone, "loadChartImage ==> valid recordset (Main)", "The returned recordset is valid and contains records."
			sVendorCode = oRSMain.fields(0).Value		'Will Fetch From DB Query		'Vendor Code i.e TCS, ECS, ECSPI,....
			sBarcode = oRSMain.fields(1).Value		'Will Fetch From DB Query		'Barcode i.e 346f1c38-25e2-4563-9375-68d01e447bdc,  
			sExtChartID = oRSMain.fields(2).Value		'Will Fetch From DB Query		'Chart External ID & will be available only for PAF/CAPE/COI/HQPAF/PAF_HQ Projects only
			sRetReqSts = oRSMain.fields(3).Value		'Will Fetch From DB Query		'Project Status i.e New, Released....
			sProjType = oRSMain.fields(4).Value		'Will Fetch From DB Query		'Project Type i.e.. STD, ENH, PAF, CAPE,.....
			sProjID = oRSMain.fields(5).Value		'Will Fetch From DB Query		'Project Key i.e 100306403....

			'Create File System Object
			Set oFSO = CreateObject("Scripting.FileSystemObject")
	
			'Creating folder with current date in NAS Drive \Automation\Application\ChartSync\BatchJobs\QA
			If Not(oFSO.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate"))) Then 'Checking if the folder with current date is already created
				oFSO.CreateFolder ""&Environment.Value("Jobs_Path")&Environment.Value("CurDate") 'creating a new folder with the date in NAS drive
				 If Not(oFSO.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate"))) Then 'Report if the folder is not created
					Reporter.ReportEvent micFail, "loadChartImage ==>Jobs_Path" , "Folder with current date was not created inside '"& Environment.Value("Jobs_Path") &"' folder" 
					Services.EndTransaction "loadChartImage" ' Timer End
					Exit Function
				End If	
			End If
	
			'Creating folder with current date\TestName in NAS Drive IRADS\Rules
			If Not(oFSO.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName"))) Then 'Checking if the folder with current date is already created
				oFSO.CreateFolder ""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName") 'creating a new folder with the test name in NAS drive
				 If Not(oFSO.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName"))) Then 'Report if the folder is not created
					Reporter.ReportEvent micFail, "loadChartImage ==>Jobs_Path" , "Folder with Test Name was not created inside '"& Environment.Value("Jobs_Path") &"' folder"
					Services.EndTransaction "loadChartImage" ' Timer End
					Exit Function
				End If	
			End If

			' If Project Status is in NEW, Make it to Released
			If Instr(1, UCase(sRetReqSts) , "NEW" , 1) > 0 Then
				' Log in to Application Search for Project and make ot Released
				If of.linkClicker("Go to Sign In") = True Then
					Reporter.ReportEvent micPass,"loadChartImage ==>Link : Go to Sign In","Successfully Clicked on Link 'Go to Sign In' Page as Expected"
				Else
					Reporter.ReportEvent micInfo,"loadChartImage ==>Link : Go to Sign In","Link 'Go to Sign In' Page is Not displayed on Screen"
				End If

				' App-1 . Login to the Application
				If lin.loginUser  ("sysadmintest51", "password") = True Then
					Reporter.ReportEvent micPass,"loadChartImage ==> loginUser","SysAdmin User has been successfully  logged in to chartsync "
				
					' App-2 . Click on Data Summary Tab
					Browser("name:="&Environment("BROWSER_TITLE")).Sync 
					If of.webElementClicker("manageProjectTabLabel")= True  Then
						Reporter.ReportEvent micPass,"loadChartImage ==> Click Data Summary Tab","Data Summary Tab is clicked Succesfully"

						' App-3 . Select the Project status as New
						wait(3)
						If of.webEditEnter("commonSearchForm:projectIdSearchValue", sProjID) = True  Then
							Reporter.ReportEvent micPass,"loadChartImage ==> WebEdit - Set Value","successfully entered the value : '"& sProjID &"' in Project ID Text Box"
	
							' App-6 . Click on Search button
							If of.webButtonClicker("commonSearchForm:searchButton")= True  Then
								Reporter.ReportEvent micPass,"loadChartImage ==> WebButton - Click Search","Search Button is clicked Succesfully"
								Call ajaxSync.ajaxSyncRequest("Processing Request",60)

								' Expected - Webtable should display the Project Name
								If of.verifyWebTableVals("projectForm:projectTable","Project Information", sProjID, 1, 3) = True  Then
									Reporter.ReportEvent micPass,"loadChartImage ==> Verify WebTable Data - "& sProjID,"WebTable 'Project Information' contains the value '"& sProjID &" under Column - 'Project ID' as Expected"

									'Verify If retrieval and coding organisations are Null
									If sRetOrgVal = "" Then
										sRetOrgVal = "TCS"
									End If
							
									If sCodOrgVal = "" Then
										sCodOrgVal = "INGENIX CODING"
									End If

									' App - 7 Assign External Coding Organisation and then Change the Status to Release
									If util.AssignOrganizationInformation("",sRetOrgVal, sCodOrgVal) = True Then
										If  util.Subtab_menu_clicker ("projectForm:projectTable:0:activityValueLinkIcon", "projectForm:projectTable:0:setReleaseProject")= True  Then
											of.webButtonClicker("confirmStatusChangeModalPanelForm:confirmStatusChangeModalPanelConfirmButton")
											Wait (4)
											Reporter.ReportEvent micPass,"loadChartImage ==> Link - Select Project Status --> Released","Successfully changed the Project Status from NEW --> Released in submenu options"
										Else
											Reporter.ReportEvent micFail,"loadChartImage ==> Link - Select Project Status --> Released","Unable to change the Project Status from NEW --> Released in submenu options"
										End If
									End If
								Else
									Reporter.ReportEvent micFail,"loadChartImage ==> Verify WebTable Data - "& sProjID,"WebTable 'Project Information' doesn't contains the value '"& sProjID &" under  Column - 'Project ID', which is NOT as Expected"
								End If
							Else
								Reporter.ReportEvent micFail,"loadChartImage ==> WebButton - Click Search","Unable to perform Click operation on Search button"
							End If
						Else
							Reporter.ReportEvent micFail,"loadChartImage ==> Set Text in Edit Box - Project ID ", "Unable to set the value : '" & sProjID & "' in Text Box Project ID"
						End If
					Else
						Reporter.ReportEvent micFail,"loadChartImage ==> Click Data Summary Tab","Unable to perform Click operation on Data Summary Tab"
					End If
				Else
					Reporter.ReportEvent micFail,"loadChartImage ==> loginUser","Login has failed. Check the user Id credentials "
				End If

				' App - Logout the Application and Close the Browser
				Wait (2)
				If  lout.logout() = True  Then
					Reporter.ReportEvent micPass,"loadChartImage ==> Log Out Application","User 'System Admin' is signed out of chartsync Application and Closing the Browser"
				Else
					Reporter.ReportEvent micFail,"loadChartImage ==> Log Out Application","User 'System Admin'  unable to sign out the chartsync Application"
				End If
			End If

			Do
				sBarcode = oRSMain.fields(1).Value		'Will Fetch From DB Query		'Barcode i.e 346f1c38-25e2-4563-9375-68d01e447bdc,  
				sExtChartID = oRSMain.fields(2).Value		'Will Fetch From DB Query		'Chart External ID & will be available only for 
                ' Identify the Project Type i.e., STD, ENH, PAF,CAPE...
				If Instr(1, "STD~ENH", UCase(sProjType) , 1) > 0 Then
					' Project Type - Standard, Enhanced
					' Retrieving Date + Time in Format YYYYMMDDHHMMSS
					sTime = Year(Now) & Right("0"& Month(Now), 2) & Right("0"& Day(Now), 2) & Right("0"& Hour(Now), 2) & Right("0"& Minute(Now), 2) & Right("0"& Second(Now), 2)
					Environment.Value("sTimeStamp") = sTime
					sFileName = "chart_"& sVendorCode &"_"& sProjCodeSTD &"_"& sBarcode &"_"& sTime
				Else
					' Project Type - PAF, CAPE, COI, HQPAF, PAF_HQ
					sFileName = "echart_"& sProjCodePAF &"_"& sExtChartID
				End If

				'Make Use of Pdf File placed in Template Location
				If ChSyBatJob.FolderFiles() <> False Then
					Reporter.ReportEvent micPass, "loadChartImage ==>Batch Job Template", "Batch Job Templates found for "&Environment.Value("TestName")& " in the 'BatchJobTemplates' Templates folder in Nas drive"
					sFileTempName = ChSyBatJob.FolderFiles() 	'Retreiving all the file names specific to the test
					aFileName = Split(sFileTempName, ";") 	'Storing the file names in an array
				
					'Generate the Chat File and move it to the Folder
					For i = 0 to Ubound(aFileName) - 1 	'Iterating between the template files found with the particular test folder in the NAS drive
						If Instr(1, UCase(aFileName(i)), "CHART", 1) > 0 Then
							oFSO.CopyFile Environment("Batch_Job_Path") & aFileName(i), Environment.Value("Jobs_Path") & Environment.Value("CurDate") &"\"& Environment.Value("TestName") &"\"& sFileName &".PDF"
						End If
					Next

					'Transfer the File to winscp Box
					sCommand = "cmd /c " & Environment("winscppath") & "winscpputrun.bat " & Environment("winscppath") & "WinSCP " & Environment("UnixUserName") & " " & Environment("UnixPassword") & " " & Environment("UnixServer") & " " & Environment("PortNumber") & " " & Environment("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName")&"\"  & sFileName &".PDF" & " " & Environment("DestFolder") & "/" 
					If ChSyBatJob.runCmdLine(sCommand, TRUE) Then	
						Reporter.ReportEvent micPass, "loadChartImage ==> WinScp", "Winscp command executed successfully '"& sFileName &".PDF' file successfully moved to the landing zone"
						loadChartImage = sFileName &".PDF"
					Else
						Reporter.ReportEvent micFail, "loadChartImage ==> WinScp", "Winscp command not  successful "
					End If
				Else
					Reporter.ReportEvent micFail, "loadChartImage ==> Batch Job Template", "Batch Job Templates is not found for "&Environment.Value("TestName")& " in the 'BatchJobTemplates' Templates folder in Nas drive, NOT as Expected"
					Exit Function
				End If
				oRSMain.MoveNext
			Loop Until  (oRSMain.eof )
		End If
		
		Reporter.ReportEvent micDone, "loadChartImage", "Function End"
		Services.EndTransaction "loadChartImage" ' Timer End

		'Clear object variables
        Set oFSO = Nothing
		Set oRSMain = Nothing
	End Function
	
	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>loadDXInbound</@name>
	'    loadDXInbound is a public method that will create a valid DX Inbound for STD/ENH/RADV  load on to application thru Batch Job
	'	 sDBSearchInput - Run the DB Query as per the input supplied
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.loadDXInbound("ProjKey~100303349", "ALL", "UNIQUE~4", "RANDOM~2")
	'  Example Usage: ChSyBatJob.loadDXInbound("FileName~LOADCR_INGENIX_20120824120827.Dat", "FEW~2", "REPEAT~4", 2)	'If Nothing specified This will create Uniquely
	'  Example Usage: ChSyBatJob.loadDXInbound("FileName~LOADCR_INGENIX_20120824120827.Dat", "ALL", "", "")	'If Empty parameters passed Data will be created with 1 DOS & 1 ICD Segments
	'  Parameters: 
	'  Calls:	util.AssignOrganizationInformation("",sRetOrgVal, sCodOrgVal)
	'	 		ChSyBatJob.FolderFiles()
	'			ChSyBatJob.runCmdLine(sCommand, TRUE)
	'			ChSyBatJob.connectPuttyWithOutAddin(Environment("puttyexepath"), Environment("UnixServer"),Environment("PortNumber"))
	'			ChSyBatJob.ExecuteCommandWithOutAddin("sh ravasbatchclient.sh","RVUI0003")
	'			ChSyBatJob.BatchJobFileLoadCheck(sFileName, 4)
	'  Author: Govardhan Choletti
	'  Date: 11/14/2012     (Created)
	'  Modifications: 
	'**********************************************************************************************************************************      
	Public Function loadDXInbound(ByVal sDBSearchInput, ByVal sBarcodes, ByVal sDOSRecCnt, ByVal sICDRecCnt)

	  'Variable Initialization
		Dim aState, aSpecialCode, aDBSearchInput, aDBBarcodes, aDOSRecCnt, aICDRecCnt, aValidDxCodes
		Dim sProjCodeSTD, sQueryInput, sMainQuery, sVendorCode, sBarcode, sProjID, sProjName, sTimeStmp, sTransactDate, sFileName, sCommand
		Dim sRecordID, sSequenceNumber, sFileID, sProjectID, sProjectName, sAAA
		Dim sBarcodeID, sImageStatus, sBBB
		Dim sFromDateService, sFromToService, sServiceType, sEOCode1, sEOCode2, sEOCode3, sPageNumber, sRendRetrieval, sRendProvNPI, sRendProvFName, sRendProvMName, sRendProvLName, sRendProvGroupName, sRendProvAdd1, sRendProvAdd2, sRendProvCity, sRendProvState, sRendProvZip, sRendProvPhone, sRendProvFax, sRendProvMail, sRendProvSpecial, sCCC
		Dim sDiagnosisCode, sPrimaryIndicator, sDDD
		Dim sWWW, sXXX, sYYY, sZZZ
		Dim iBarcodeCnt, iDBBarcodeCnt, iDOSCnt, iDXCnt, iBBCnt, iCCCnt, iDDCnt, iDateVariation
		Dim oRSMain, oFSO, oFileDXInbnd
        	
		Services.StartTransaction "loadDXInbound" ' Timer Begin
		Reporter.ReportEvent micDone, "loadDXInbound", "Function Begin"

		'Variable Initialisation
		loadDXInbound = False
		sProjCodeSTD = "INGENIX"
		aState = Array("AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY", "PR")
		aSpecialCode = Array("01","02","03","04","05","06","07","08","10","11","12","13","14","16","18","19","20","22","24","25","26","28","29","33","34","35","36","37","38","39","40","41","42","43","44","46","48","50","62","64","65","66","67","68","70","72","76","77","78","79","80","81","82","83","84","85","86","89","90","91","92","93","94","97","98","99")
		aValidDxCodes = Array("250.00", "255.0", "114.4", "427.81", "417.1", "197.3", "344.40", "342.80", "260", "292.0", "046.19")
		
		'Verify Input Parameters Type of Project Selection
		aDBSearchInput = Split(sDBSearchInput, "~")
		If UBound(aDBSearchInput)= 1 Then
			Select Case UCASE(TRIM(aDBSearchInput(0)))
				Case "PROJKEY"
					sQueryInput = "B.proj_key = '"& aDBSearchInput(1) &"'"
				Case "FILENAME"
					sQueryInput = "B.FileName = '"& aDBSearchInput(1) &"'"
				Case Else
					Reporter.ReportEvent micFail, "loadDXInbound ==> Invalid Input" , "Please check the First Input parameter i.e., '"& sDBSearchInput &"' and Valid Input Format is 1. (ProjKey~100303349) OR  2.(FileName~LOADCR_INGENIX_20120824120827.Dat)"
					Exit Function
			End Select
		End If

		'Verify Input Parameters Type of Barcodes
		aDBBarcodes = Split(sBarcodes, "~")
		If UBound(aDBBarcodes)= 1 Then
			Select Case UCASE(TRIM(aDBBarcodes(0)))
				Case "FEW"
					iBarcodeCnt = CInt(aDBBarcodes(1))
				Case Else
					Reporter.ReportEvent micFail, "loadDXInbound ==> Invalid Input" , "Please check the Second Input parameter i.e., '"& sBarcodes &"' and Valid Input Format is 1. (FEW~4) OR  2.(ALL) OR 3.(24). MAX, limiting Charts is '10,000'"  
					Exit Function
			End Select
		ElseIf IsNumeric(sBarcodes) Then
			iBarcodeCnt = sBarcodes
		ElseIf UCase(sBarcodes) = "ALL" OR sBarcodes = "" Then
			iBarcodeCnt = 10000
		Else
			Reporter.ReportEvent micFail, "loadDXInbound ==> Invalid Input" , "Please check the Second Input parameter i.e., '"& sBarcodes &"' and Valid Input Format is 1. (FEW~4) OR  2.(ALL) OR 3.(24). MAX, limiting Charts is '10,000'"  
			Exit Function
		End If
		
		'Verify Input Parameters Type of DOS Records
		aDOSRecCnt = Split(sDOSRecCnt, "~")
		If UBound(aDOSRecCnt)= 1 Then
			Select Case UCASE(TRIM(aDOSRecCnt(0)))
				Case "UNIQUE", "RANDOM", "REPEAT"
					iDOSCnt = CInt(aDOSRecCnt(1))
				Case Else
					Reporter.ReportEvent micFail, "loadDXInbound ==> Invalid Input" , "Please check the Third Input parameter i.e., '"& sDOSRecCnt &"' and Valid Input Format is 1. (UNIQUE~4) OR  2.(RANDOM~2) OR 3.(REPEAT~8)."  
					Exit Function
			End Select
		ElseIf IsNumeric(sDOSRecCnt) Then
			iDOSCnt = sDOSRecCnt
		ElseIf sDOSRecCnt = "" Then
			iDOSCnt = 10
		Else
			Reporter.ReportEvent micFail, "loadDXInbound ==> Invalid Input" , "Please check the Third Input parameter i.e., '"& sDOSRecCnt &"' and Valid Input Format is 1. (UNIQUE~4) OR  2.(RANDOM~2) OR 3.(REPEAT~8)."  
			Exit Function
		End If
		
		'Verify Input Parameters Type of DX Records
		aICDRecCnt = Split(sICDRecCnt, "~")
		If UBound(aICDRecCnt)= 1 Then
			Select Case UCASE(TRIM(aICDRecCnt(0)))
				Case "UNIQUE", "RANDOM", "REPEAT"
					iDXCnt = CInt(aICDRecCnt(1))
				Case Else
					Reporter.ReportEvent micFail, "loadDXInbound ==> Invalid Input" , "Please check the Third Input parameter i.e., '"& sICDRecCnt &"' and Valid Input Format is 1. (UNIQUE~4) OR  2.(RANDOM~2) OR 3.(REPEAT~8)."  
					Exit Function
			End Select
		ElseIf IsNumeric(sICDRecCnt) Then
			iDXCnt = sICDRecCnt
		ElseIf sICDRecCnt = "" Then
			iDXCnt = 10
		Else
			Reporter.ReportEvent micFail, "loadDXInbound ==> Invalid Input" , "Please check the Third Input parameter i.e., '"& sICDRecCnt &"' and Valid Input Format is 1. (UNIQUE~4) OR  2.(RANDOM~2) OR 3.(REPEAT~8)."  
			Exit Function
		End If
		
		' Run the Query to Fetch the different Prov Request Key for the User
		sMainQuery = "SELECT C.vendor_code, A.proj_content_barcode, A.proj_key, B.Proj_Name, (Select Count(*) FROM Ravas.rv_proj_content WHERE proj_key = B.proj_key AND Retrieval_Request_Status = 'RELEASED') "_
					&"FROM Ravas.rv_proj_content A "_
					&"INNER JOIN Ravas.rv_project B ON B.proj_key = A.proj_key "_
					&"INNER JOIN Ravas.rv_vendor C ON C.vendor_name = B.proj_retrieval_vendor "_
					&"AND A.Retrieval_Request_Status = 'RELEASED' "_
					&"AND B.Proj_coding = 'EXTCODING' "_
					&"AND B.Proj_Review_type IN ('STD','ENH','RADV') "_
					&"AND "& sQueryInput	
		Set oRSMain = db.executeDBQuery(sMainQuery, Environment.Value("DB"))	
		If LCase(typeName(oRSMain)) <> "recordset" Then
			Reporter.ReportEvent micFail, "loadDXInbound ==> invalid recordset (Main)", "The database connection did not open or invalid parameters were passed."
		ElseIf oRSMain.bof And oRSMain.eof Then
			Reporter.ReportEvent micFail, "loadDXInbound ==> Project Data", "Query '"& sMainQuery &"' with Project data "& sDBSearchInput & " fetches empty Records from DB, Please Re-Check Input Parameters"
		Else
			sVendorCode = oRSMain.fields(0).Value		'Will Fetch From DB Query		'Vendor Code i.e TCS, ECS, ECSPI,....
			sBarcode = oRSMain.fields(1).Value		'Will Fetch From DB Query		'Barcode i.e 346f1c38-25e2-4563-9375-68d01e447bdc,  
			sProjID = oRSMain.fields(2).Value		'Will Fetch From DB Query		'Project Key i.e 100306403....
			sProjName = oRSMain.fields(3).Value		'Will Fetch From DB Query		'Project Name i.e OPTUM AUTOMATION....	
			iDBBarcodeCnt = CInt(oRSMain.fields(4).Value)
			
			'Update the Barcode Count sent by the user to Max Db Barcode Count
			If iDBBarcodeCnt < iBarcodeCnt Then
				iBarcodeCnt = iDBBarcodeCnt
			End If
			Reporter.ReportEvent micDone, "loadDXInbound ==> valid recordset (Main)", "The returned recordset is valid and contains records."

			'Create File System Object
			Set oFSO = CreateObject("Scripting.FileSystemObject")
	
			'Creating folder with current date in NAS Drive \Automation\Application\ChartSync\BatchJobs\QA
			If Not(oFSO.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate"))) Then 'Checking if the folder with current date is already created
				oFSO.CreateFolder ""&Environment.Value("Jobs_Path")&Environment.Value("CurDate") 'creating a new folder with the date in NAS drive
				 If Not(oFSO.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate"))) Then 'Report if the folder is not created
					Reporter.ReportEvent micFail, "loadDXInbound ==>Jobs_Path" , "Folder with current date was not created inside '"& Environment.Value("Jobs_Path") &"' folder" 
					Services.EndTransaction "loadDXInbound" ' Timer End
					Exit Function
				End If	
			End If
	
			'Creating folder with current date\TestName in NAS Drive IRADS\Rules
			If Not(oFSO.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName"))) Then 'Checking if the folder with current date is already created
				oFSO.CreateFolder ""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName") 'creating a new folder with the test name in NAS drive
				 If Not(oFSO.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName"))) Then 'Report if the folder is not created
					Reporter.ReportEvent micFail, "loadDXInbound ==>Jobs_Path" , "Folder with Test Name was not created inside '"& Environment.Value("Jobs_Path") &"' folder"
					Services.EndTransaction "loadDXInbound" ' Timer End
					Exit Function
				End If	
			End If
	
		' Retrieving Date + Time in Format YYYYMMDDHHMMSS
			sTimeStmp = Year(Now) & Right("0"& Month(Now), 2) & Right("0"& Day(Now), 2) & Right("0"& Hour(Now), 2) & Right("0"& Minute(Now), 2) & Right("0"& Second(Now), 2)
			sTransactDate = Right("0"& Month(Now), 2) &"/"& Right("0"& Day(Now), 2) &"/"& Year(Now) &":"& Right("0"& Hour(Now), 2) & Right("0"& Minute(Now), 2) & Right("0"& Second(Now), 2) 
			Environment.Value("sTimeStamp") = sTimeStmp
			sFileName = "DX_"& sVendorCode &"_"& sProjCodeSTD &"_"& Environment.Value("sTimeStamp")
			
		'Creating a new file in \\Nas00582pn\istarr\Automation\Application\ChartSync\BatchJobs folder\CurDate\TestName
			Set oFileDXInbnd = oFSO.CreateTextFile(Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName")&"\"& sFileName &".DAT", True)
			
		' To Generate 'AAA' Segment
			sRecordID = "AAA"
			sSequenceNumber = ChSyBatJob.randomDataGeneration("NUMBER", RandomNumber(1,9))
			sFileID = ChSyBatJob.randomDataGeneration("NUMBER", RandomNumber(1,9))
			sProjectID = sProjID
			sProjectName = sProjName
			sAAA = sRecordID &"|"& sSequenceNumber &"|"& sFileID &"|"& sTransactDate &"|"& sProjectID &"|"& sProjectName &"|"
			oFileDXInbnd.Write "" & sAAA
			oFileDXInbnd.WriteBlankLines(1)
				
			For iBBCnt = 1 to iBarcodeCnt Step 1
				sBarcode = oRSMain.fields(1).Value		'Will Fetch From DB Query		'Barcode i.e 346f1c38-25e2-4563-9375-68d01e447bdc,  
				
				'To Generate 'BBB' Segement
				sRecordID = "BBB"
				sBarcodeID = sBarcode		'Will Fetch From DB Query		'Barcode i.e 346f1c38-25e2-4563-9375-68d01e447bdc, 
				sProjectID = sProjID				
				sImageStatus = ""
				sBBB = sRecordID &"|"& sBarcodeID &"|"& sProjectID &"|"& sImageStatus &"|"
				oFileDXInbnd.Write "" & sBBB
				oFileDXInbnd.WriteBlankLines(1)
				
				For iCCCnt = 1 to iDOSCnt Step 1
					'To Generate 'CCC' Segment
					sRecordID = "CCC"
					sBarcodeID = sBarcode		'Will Fetch From DB Query		'Barcode i.e 346f1c38-25e2-4563-9375-68d01e447bdc, 
					Select Case RandomNumber (1,4)
						Case 1
							sServiceType = "IP"
							iDateVariation = RandomNumber(1, 150)
						Case 2
							sServiceType = "OP"
							iDateVariation = 0
						Case 3
							sServiceType = "SNF"
							iDateVariation = RandomNumber(1, 150)
						Case 4
							sServiceType = "HOP"
							iDateVariation = RandomNumber(1, 150)
					End Select
					sFromDateService = Right("0"& Month(Now-iDateVariation), 2) &"/"& Right("0"& Day(Now-iDateVariation), 2) &"/"& Year(Now-iDateVariation)
					sFromToService = Right("0"& Month(Now), 2) &"/"& Right("0"& Day(Now), 2) &"/"& Year(Now)
					sEOCode1 = ""
					sEOCode2 = ""
					sEOCode3 = ""
					sPageNumber = "9999999999"
					sRendRetrieval = "N"
					sRendProvNPI = ChSyBatJob.randomDataGeneration("NUMBER", 10)
					sRendProvFName = ChSyBatJob.randomDataGeneration("ALPHANUMERIC", RandomNumber(1,35))
					sRendProvMName = ChSyBatJob.randomDataGeneration("ALPHANUMERIC", RandomNumber(1,1))
					sRendProvLName = ChSyBatJob.randomDataGeneration("ALPHANUMERIC", RandomNumber(1,50))
					sRendProvGroupName = ChSyBatJob.randomDataGeneration("ALPHANUMERIC", RandomNumber(1,35))
					sRendProvAdd1 = ChSyBatJob.randomDataGeneration("ALPHANUMERIC", RandomNumber(1,50))
					sRendProvAdd2 = ChSyBatJob.randomDataGeneration("ALPHANUMERIC", RandomNumber(1,50))
					sRendProvCity = ChSyBatJob.randomDataGeneration("ALPHANUMERIC", RandomNumber(1,50))
					sRendProvState = aState(RandomNumber (0, UBound(aState)))
					sRendProvZip = ChSyBatJob.randomDataGeneration("NUMBER", 5) &"-"& ChSyBatJob.randomDataGeneration("NUMBER", 4)
					sRendProvPhone = ChSyBatJob.randomDataGeneration("NUMBER", 10)
					sRendProvFax = ChSyBatJob.randomDataGeneration("NUMBER", 10)
					sRendProvMail = ChSyBatJob.randomDataGeneration("ALPHABET", 19) &"@"& ChSyBatJob.randomDataGeneration("ALPHABET", 19) &"."& ChSyBatJob.randomDataGeneration("ALPHABET", 10)
					sRendProvSpecial = aSpecialCode(RandomNumber(0, UBound(aSpecialCode)))
					sCCC = sRecordID &"|"& sBarcodeID &"|"& sFromDateService &"|"& sFromToService &"|"& sServiceType &"|"& sEOCode1 &"|"& sEOCode2 &"|"& sEOCode3 &"|"& sPageNumber &"|"& sRendRetrieval &"|"& sRendProvNPI &"|"& sRendProvFName &"|"& sRendProvMName &"|"& sRendProvLName &"|"& sRendProvGroupName &"|"& sRendProvAdd1 &"|"& sRendProvAdd2 &"|"& sRendProvCity &"|"& sRendProvState &"|"& sRendProvZip &"|"& sRendProvPhone &"|"& sRendProvFax &"|"& sRendProvMail &"|"& sRendProvSpecial &"|"
					oFileDXInbnd.Write "" & sCCC
					oFileDXInbnd.WriteBlankLines(1)
					
					sPrimaryIndicator = ""
					For iDDCnt = 1 to iDXCnt Step 1
						'To Generate 'DDD' Segment
						sRecordID = "DDD"
						sBarcodeID = sBarcode
						sDiagnosisCode = aValidDxCodes (iDDCnt)
						If sPrimaryIndicator <> "" Then
							sPrimaryIndicator = "Y"
						End If
						sEOCode1 = ""
						sEOCode2 = ""
						sEOCode3 = ""
						sDDD = sRecordID &"|"& sBarcodeID &"|"& sDiagnosisCode &"|"& sPrimaryIndicator &"|"& sEOCode1 &"|"& sEOCode2 &"|"& sEOCode3 &"|"
						oFileDXInbnd.Write "" & sDDD
						oFileDXInbnd.WriteBlankLines(1)
					Next
					
					'To Generate 'WWW' Segment
					sRecordID = "WWW"
					sBarcodeID = sBarcode
					sWWW = sRecordID &"|"& sBarcodeID &"|"& iDXCnt &"|"
					oFileDXInbnd.Write "" & sWWW
					oFileDXInbnd.WriteBlankLines(1)
				Next
				
				'To Generate 'XXX' Segment
				sRecordID = "XXX"
				sBarcodeID = sBarcode
				sProjectID = sProjID
				sXXX = sRecordID &"|"& sBarcodeID &"|"& sProjectID &"|"& iDOSCnt &"|"
				oFileDXInbnd.Write "" & sXXX
				oFileDXInbnd.WriteBlankLines(1)
				oRSMain.MoveNext
			Next
			
			'To Generate 'YYY' Segment
			sRecordID = "YYY"
			sProjectID = sProjID
			sYYY = sRecordID &"|"& sProjectID &"|"& iBarcodeCnt &"|"
			oFileDXInbnd.Write "" & sYYY
			oFileDXInbnd.WriteBlankLines(1)
			
			'To Generate 'ZZZ' Segment
			sRecordID = "ZZZ"
			sZZZ = sRecordID &"|"& sFileID &"|1|"
			oFileDXInbnd.Write "" & sZZZ
			
			'Transfer the File to winscp Box
			sCommand = "cmd /c " & Environment("winscppath") & "winscpputrun.bat " & Environment("winscppath") & "WinSCP " & Environment("UnixUserName") & " " & Environment("UnixPassword") & " " & Environment("UnixServer") & " " & Environment("PortNumber") & " " & Environment("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName")&"\"  & sFileName &".DAT" & " " & Environment("DestFolder") & "/" 
			If ChSyBatJob.runCmdLine(sCommand, TRUE) Then	
				Reporter.ReportEvent micPass, "loadDXInbound ==> WinScp", "Winscp command executed successfully '"& sFileName &".DAT' file successfully moved to the landing zone"
				loadDXInbound = sFileName &".DAT"
			Else
				Reporter.ReportEvent micFail, "loadDXInbound ==> WinScp", "Winscp command not  successful "
			End If
		End If
		
		Reporter.ReportEvent micDone, "loadDXInbound", "Function End"
		Services.EndTransaction "loadDXInbound" ' Timer End

		'Clear object variables
        Set oFSO = Nothing
		Set oRSMain = Nothing
		Set oFileDXInbnd = Nothing
	End Function
	
	'<@comments>
	'**********************************************************************************************************************************
	'  <@name>loadNewandUnique</@name>
	'    loadNewandUnique is a public method that will create a New & Unique File thru DataBase Query based on type of Input passed
	'	 sDBSearchInput - Run the DB Query as per the input supplied
	'  Assumptions: 
	'  Example Usage: ChSyBatJob.loadNewandUnique("ProjKey~100303349")
	'  Example Usage: ChSyBatJob.loadNewandUnique("FileName~LOADCR_INGENIX_20120824120827.Dat")
	'  Example Usage: ChSyBatJob.loadNewandUnique("ChartName~2f335b47-2dfe-492c-9ff6-c55f481e2d3c")
	'  Parameters: 
	'  Calls:	util.AssignOrganizationInformation("",sRetOrgVal, sCodOrgVal)
	'	 		ChSyBatJob.FolderFiles()
	'			ChSyBatJob.runCmdLine(sCommand, TRUE)
	'			ChSyBatJob.connectPuttyWithOutAddin(Environment("puttyexepath"), Environment("UnixServer"),Environment("PortNumber"))
	'			ChSyBatJob.ExecuteCommandWithOutAddin("sh ravasbatchclient.sh","RVUI0003")
	'			ChSyBatJob.BatchJobFileLoadCheck(sFileName, 4)
	'  Author: Govardhan Choletti
	'  Date: 15/11/2012     (Created)
	'  Modifications: 
	'**********************************************************************************************************************************      
	Public Function loadNewandUnique(ByVal sDBSearchInput)

	  'Variable Initialization
		Dim aDBSearchInput
		Dim sMainQuery, sRecordQuery, sCountQuery, sNandURecord, sRecordCount, sTime, sFileName, sHeader, sTrailer, sCommand
		Dim oRSMain, oFSO, oNewAndUnique
        	
		Services.StartTransaction "loadNewandUnique" ' Timer Begin
		Reporter.ReportEvent micDone, "loadNewandUnique", "Function Begin"

		'Variable Initialisation
		loadNewandUnique = False

		'Verify Input Parameters
		aDBSearchInput = Split(sDBSearchInput, "~")
		If UBound(aDBSearchInput)= 1 Then
			Select Case UCASE(TRIM(aDBSearchInput(0)))
				Case "PROJKEY"
					sRecordQuery = "A.proj_key = '"& aDBSearchInput(1) &"'"
					sCountQuery = "Proj_key = A.Proj_key"
				Case "FILENAME"
					sRecordQuery = "E.FileName = '"& aDBSearchInput(1) &"'"
					sCountQuery = "Proj_key = A.Proj_key"
				Case "CHARTNAME"
					sRecordQuery = "A.Proj_Content_barcode = '"& aDBSearchInput(1) &"'"
					sCountQuery = "Proj_Content_barcode = A.Proj_Content_barcode"
				Case Else
					Reporter.ReportEvent micFail, "loadNewandUnique ==> Invalid Input" , "Please check the First Input parameter i.e., '"& sDBSearchInput &"' and Valid Input Format is 1. (ProjKey~100303349) OR  2.(FileName~LOADCR_INGENIX_20120824120827.Dat) OR 3.(ChartName~c2bd4cd0-0268-4e8c-99b4-f8971320e017)"
					Exit Function
			End Select
		End If

		' Run the Query to Fetch the different Prov Request Key for the User
		sMainQuery = "SELECT 'DTL|'||A.Encounter_key||'|'||B.Seq_key||'|'||D.Mbr_HIC||'|'||TO_CHAR(B.Dos_From_Dt,'MM/DD/YYYY')||'|'||TO_CHAR(B.Dos_Thru_Dt,'MM/DD/YYYY')||'|'||B.Dx_cd||'|'||B.Service_Type||'|Y|'||A.Proj_Content_barcode||'|', "_
					&"(SELECT COUNT(*) FROM Ravas.Rv_chart_enc_prov WHERE "& sCountQuery &") "_
					&"FROM Ravas.Rv_chart_enc_prov A "_
					&"INNER JOIN Ravas.Rv_chart_Enc_dx B ON B.Encounter_key = A.Encounter_key "_
					&"INNER JOIN Ravas.Rv_proj_content C ON C.Proj_Content_barcode = A.Proj_Content_barcode "_
					&"INNER JOIN Ravas.Rv_proj_content_member D ON D.Proj_Content_Mbr_key = C.Proj_Content_Mbr_key "_
					&"INNER JOIN Ravas.Rv_Project E ON E.Proj_key = A.Proj_key "_
					&"AND "& sRecordQuery	
		Set oRSMain = db.executeDBQuery(sMainQuery, Environment.Value("DB"))	
		If LCase(typeName(oRSMain)) <> "recordset" Then
			Reporter.ReportEvent micFail, "loadNewandUnique ==> invalid recordset (Main)", "The database connection did not open or invalid parameters were passed."
		ElseIf oRSMain.bof And oRSMain.eof Then
			Reporter.ReportEvent micFail, "loadNewandUnique ==> New & Unique Load File", "New & Unique Query '"& sMainQuery &"' with data "& sDBSearchInput & " is not available in the db, Please Re-Check Input Parameters"
		Else
			Reporter.ReportEvent micDone, "loadNewandUnique ==> valid recordset (Main)", "The returned recordset is valid and contains records."
			sNandURecord = oRSMain.fields(0).Value		'Will Fetch From DB Query		'Record for Each Encounter for the project / Chart Specified
			sRecordCount = oRSMain.fields(1).Value		'Will Fetch From DB Query		'Total Number of Record(s) for project / Chart Specified
				
			'Create File System Object
			Set oFSO = CreateObject("Scripting.FileSystemObject")
	
			'Creating folder with current date in NAS Drive \Automation\Application\ChartSync\BatchJobs\QA
			If Not(oFSO.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate"))) Then 'Checking if the folder with current date is already created
				oFSO.CreateFolder ""&Environment.Value("Jobs_Path")&Environment.Value("CurDate") 'creating a new folder with the date in NAS drive
				 If Not(oFSO.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate"))) Then 'Report if the folder is not created
					Reporter.ReportEvent micFail, "loadNewandUnique ==>Jobs_Path" , "Folder with current date was not created inside '"& Environment.Value("Jobs_Path") &"' folder" 
					Services.EndTransaction "loadNewandUnique" ' Timer End
					Exit Function
				End If	
			End If
	
			'Creating folder with current date\TestName in NAS Drive IRADS\Rules
			If Not(oFSO.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName"))) Then 'Checking if the folder with current date is already created
				oFSO.CreateFolder ""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName") 'creating a new folder with the test name in NAS drive
				 If Not(oFSO.FolderExists (""&Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName"))) Then 'Report if the folder is not created
					Reporter.ReportEvent micFail, "loadNewandUnique ==>Jobs_Path" , "Folder with Test Name was not created inside '"& Environment.Value("Jobs_Path") &"' folder"
					Services.EndTransaction "loadNewandUnique" ' Timer End
					Exit Function
				End If	
			End If
			
		' Retrieving Date + Time in Format YYYYMMDDHHMMSS
			sTime = Year(Now) & Right("0"& Month(Now), 2) & Right("0"& Day(Now), 2) & Right("0"& Hour(Now), 2) & Right("0"& Minute(Now), 2) & Right("0"& Second(Now), 2)
			Environment.Value("sTimeStamp") = sTime
			sFileName = "NAU_FINANCE_CS_IN_"& sTime
			
			'Creating a new file in \\Nas00582pn\istarr\Automation\Application\IRADS\Rules folder\CurDate\TestName
			Set oNewAndUnique = oFSO.CreateTextFile(Environment.Value("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName")&"\"& sFileName &".DAT", True)
			sHeader = "HDR|"& sFileName &".DAT|"
			oNewAndUnique.Write "" & sHeader
			oNewAndUnique.WriteBlankLines(1)
			
			Do
				sNandURecord = oRSMain.fields(0).Value
				oNewAndUnique.Write "" & sNandURecord
				oNewAndUnique.WriteBlankLines(1)
				oRSMain.MoveNext
			Loop Until (oRSMain.EOF )
			
			sTrailer = "TRA|"& sFileName &".DAT|"& sRecordCount &"|"
			oNewAndUnique.Write "" & sTrailer
			
			'Transfer the File to winscp Box
			sCommand = "cmd /c " & Environment("winscppath") & "winscpputrun.bat " & Environment("winscppath") & "WinSCP " & Environment("UnixUserName") & " " & Environment("UnixPassword") & " " & Environment("UnixServer") & " " & Environment("PortNumber") & " " & Environment("Jobs_Path")&Environment.Value("CurDate")&"\"&Environment.Value("TestName")&"\"  & sFileName &".PDF" & " " & Environment("DestFolder") & "/" 
			If ChSyBatJob.runCmdLine(sCommand, TRUE) Then	
				Reporter.ReportEvent micPass, "loadNewandUnique ==> WinScp", "Winscp command executed successfully '"& sFileName &".PDF' file successfully moved to the landing zone"
				loadNewandUnique = sFileName &".DAT"
			Else
				Reporter.ReportEvent micFail, "loadNewandUnique ==> WinScp", "Winscp command not successful "
			End If
		End If
		
		Reporter.ReportEvent micDone, "loadNewandUnique", "Function End"
		Services.EndTransaction "loadNewandUnique" ' Timer End

		'Clear object variables
        Set oFSO = Nothing
		Set oRSMain = Nothing
		Set oNewAndUnique = Nothing
	End Function
	
	Function loginPutty(sUserid,sPwd,sServer)
		'*******************************************************************************************************************************
		'Purpose: QTP script - Login to a unix server specified via PuTTY utility
		'                   For use in ChartSync application
		'NOTEs: This is used to login as a regular user as the Shell prompt '$' will be checked to return pass/fail
		'       Putty utility is located here "\\Nas00582pn\istarr\Automation\Application\ChartSync\ExeFiles\Putty\putty.exe"
		
		'Parameters:  sUserid = user id 
		'             sPwd = password
		'             sServer = host name or ip address of the unix server
		'Calls: ChSyBatJob.getVisibleText
		'Usage: 
		'		If ChSyBatJob.loginPutty(sUserid,sPwd,sServer) Then 
		'			Set oPuttyLogin=Environment("PUTTY_LOGIN")	
		'			Wait(10)	'let me see what I want to do...
					
		'			oPuttyLogin.Type "ls -al"		'send the ls command
		'			oPuttyLogin.Type  micReturn 	'hit Enter
		'			Wait(2)
					
					''logout	
		'			If Not unixLin.logoutPutty(sServer)	Then MsgBox "call to logout returns a fail status."
					
		'			Set oPuttyLogin=Nothing
		'       Else
		'			msgbox "call to login returns a fail status."
		'		End If 
		'           
		'Returns: True/False
		'         If return True, the Environment("PUTTY_LOGIN") object is available
		'Created by: Hung Nguyen 7-3-12
		'Modified: Hung Nguyen 4/09/13 - Modify from Symmetry app to use in ChartSync app
		'          Hung Nguyen 4/09/13 - After enter userid and password the prompt '>' will return. Now enter 'exit' and Return So the 'bash$' promp will appear
		'**********************************************************************************************************************************
		Services.StartTransaction "loginPutty"
		loginPutty=False	'init return value
		
		Dim aParams,sParam,oPutty,oPuttyLogin,iTimeout,i,aExpectText,aEnterText,sGetText,cnt,iPrompt,sPuttyPath
	
		''verify parameters
		aParams=array(sUserid,sPwd,sServer)
		For each sParam in aParams
			If sParam="" or isempty(sParam) Then
				reporter.ReportEvent micFail,"Invalid parameter","Parameter can't be empty."
				Exit Function
			End If
		Next
	
		iTimeout=120	'2 mins max waiting for the Shell prompt returns

		'Launch remote Putty
		sPuttyPath=Environment("puttyexepath")    '="\\Nas00582pn\istarr\Automation\Application\ChartSync\ExeFiles\Putty\putty.exe"
		'SystemUtil.Run "C:\Program Files\PuTTY\putty.exe","","C:\Program Files\PuTTY","open"
		SystemUtil.Run sPuttyPath,"","","open"
		
		'''1. The PuTTY Configuration window obj	
		Set oPutty=Window("regexpwndtitle:=PuTTY Configuration","regexpwndclass:=PuTTYConfigBox")
		
		If oPutty.Exist(30) Then
			oPutty.WaitProperty "enabled",true,30000 
			oPutty.Activate
		
			'enter hostname/ip address and click Open
			oPutty.WinEdit("nativeclass:=Edit","attached text:=Host .*").Set sServer
			oPutty.WinButton("nativeclass:=Button","text:=&Open").Click
	
			'''2. The PuTTY login window
			Set oPuttyLogin=Window("regexpwndtitle:=PuTTY","regexpwndclass:=PuTTY","text:=" &sServer &".*")
			If oPuttyLogin.Exist(60) Then
				oPuttyLogin.WaitProperty "enabled",True,30000
				oPuttyLogin.Activate
	
				''enter userid and password	and prompt '>'
				aExpectText=array("login","Password",">")			
				aEnterText=array(sUserid,sPwd)
				For i=0 to ubound(aExpectText)
					oPuttyLogin.Activate
					
					iPrompt=0
					cnt=0
					Do While cnt <= iTimeout 	'loop per time out til the prompt return - DO NOT REMOVE!
						'sGetText=util.getVisibleText(oPuttyLogin,iTimeout)	'call to get visible text w/time out waiting for the obj to be ready
						sGetText=ChSyBatJob.getVisibleText(oPuttyLogin,30)	'call to get visible text w/time out waiting for the obj to be ready
						If instr(1,sGetText,aExpectText(i),1) > 0 Then
							If i < UBound(aExpectText) Then 	'enter userid and password only
								oPuttyLogin.Type aEnterText(i)
								oPuttyLogin.Type  micReturn 		'hit Enter
								reporter.reportevent micInfo,"Enter text","text '" &aEnterText(i) &"' was typed."
							Else
								'if similar string appears => ostdvu@apsp9052 (/home/ostdvu)> 
								'then type 'exit' hit return - the prompt 'bash$' will appear
								If instr(1,sGetText,aExpectText(i),1) > 0 Then
									oPuttyLogin.Type "exit"
									oPuttyLogin.Type  micReturn 		'hit Enter
									reporter.reportevent micInfo,"Enter text","text 'exit' was typed."
								End If 
							End If 
							iPrompt=1
							Exit Do
						End If 
						cnt=cnt+1
						Wait(1)							
					Loop 			
					
					If iPrompt=0 Then 
						reporter.reportevent micfail,"Expected prompt '" &aExpectText(i) &"' does not exist",""
						Exit Function
					End If 
					
				Next	'expect text
	
				''check the user Shell prompt
				sGetText=ChSyBatJob.getVisibleText(oPuttyLogin,30)	'call to get visible text w/time out waiting for the obj to be ready
				If instr(1,sGetText,"$",1) > 0 Then
					Environment("PUTTY_LOGIN")=oPuttyLogin
					loginPutty=True		'return value
					reporter.ReportEvent micPass,"loginPutty","Login was successful. Login message: " &sGetText
				Else
					reporter.ReportEvent micFail,"loginPutty","Login was NOT successful. Login message: " &sGetText
				End If
			Else	'the Login window 
				reporter.ReportEvent micFail,"PuTTY Login Window","Does not exist. Loading the Putty login window was not successful."
			End If 
		Else	'failed to load Putty 
			reporter.ReportEvent micFail,"PuTTY Configuration Window","Does not exist. Loading the Putty Configuration window was not successful."
		End If 
	
		Set oPuttyLogin=Nothing
		Set oPutty=Nothing 
		Services.EndTransaction "loginPutty"
	End Function 

	Function getVisibleText(oWinObject,iTimeout)
		'***************************************************************************************************
		'Purpose: Get text from a Window object via obj.GetVisibleText
		'Parameters: oWinObject = a valid Window object variable
		'            iTimeout = seconds waiting for the Window object to be ready prior to getting text
		'Calls: None
		'Returns: Text or Empty if fails
		'Usage: Set oPuttyLogin=Window("regexpwndtitle:=PuTTY","regexpwndclass:=PuTTY","text:=.*")
		'       If IsObject(oPuttylogin) then sText=getVisibleText(oPuttyLogin,30)
		'Created by: Hung Nguyen 7/11/12
		'Modified: 
		'***************************************************************************************************
		services.starttransaction "getVisibleText"	
		getVisibleText=Empty	'init return value
		
		Dim sGetText,cnt,iTextFound
		If IsNumeric(iTimeout) Then 
			If IsObject(oWinObject) Then	
			
				''let me sync before getting visible text. Otherwise there will be 
				''   an unknown error calling the obj.GetVisibleText property
				On error resume Next
				Err.Clear
				
				cnt=0
				iTextFound=0
				Do While cnt <= iTimeout
					oWinObject.WaitProperty "enabled",True,30000
					oWinObject.Activate
					sGetText=oWinObject.GetVisibleText	'for reporting
					If Err.Number = 0 Then
						getVisibleText=sGetText	'return value
						iTextFound=1
						reporter.ReportEvent micPass,"getVisibleText","Text found = " &sGetText &"'"
						Exit Do
					Else
						Err.Clear	'clear err
						cnt=cnt+1
						Wait(1)
					End If 
				Loop
				On error goto 0 	'reset
				If iTextFound=0 Then 
					reporter.reportevent,micFail,"getVisibleText","Text not found within " &iTimeout &" seconds."
				End If 
			Else
				reporter.ReportEvent micFail,"getVisibleText","The Windows object '" &oWinObject &"' specified is not a valid object variable."
			End If
		Else
			reporter.ReportEvent micFail,"getVisibleText","Time out must be a numeric value."
		End If 
		services.endtransaction "getVisibleText"
	End Function	
End Class

'**********************************************************************************************
'*                            Class Instantiation                                         
'**********************************************************************************************
dim ChSyBatJob

set ChSyBatJob = new ChartSyncBatchJobs
