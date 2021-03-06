'General Header
'#####################################################################################################################
'Script Description		: CRAFT Support Library
'Test Tool/Version		: HP Quick Test Professional 9.5 and above
'Test Tool Settings		: N.A.
'Application Automated		: Flight Application
'Author				: Cigniti
'Date Created			: 02/06/2014
'#####################################################################################################################
Option Explicit	'Forcing Variable declarations

'#####################################################################################################################
'Function Description   : Function to import specified Excel sheet into datatable
'Input Parameters 		: strFilePath, strSheetName
'Return Value    		: None
'Author					: Cigniti
'Date Created			: 30/05/2014
'#####################################################################################################################
Function CRAFT_ImportSheet (strFilePath, strSheetName)
	Datatable.Addsheet strSheetName
	Datatable.Importsheet strFilePath, strSheetName, strSheetName
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   : Function to set the current row in Business Flow Sheet based on the current test case
'Input Parameters 		: strBusinessFlowSheet,strCurrentTestCase
'Return Value    		: intCurrentRow
'Author				: Cigniti
'Date Created			: 03/06/2014
'#####################################################################################################################
Function CRAFT_SetBusinessFlowRow(strCurrentTestCase, strBusinessFlowSheet)
	Dim intCurrentRow, blnTestCaseFound
	intCurrentRow = 1
	blnTestCaseFound = False
	
	Do until Trim(DataTable.Value("TC_ID",strBusinessFlowSheet)) = ""
		If (DataTable.Value("TC_ID",strBusinessFlowSheet) = strCurrentTestCase) Then
			blnTestCaseFound = True
			Exit Do
		Else
			intCurrentRow = intCurrentRow + 1
			DataTable.GetSheet(strBusinessFlowSheet).SetCurrentRow(intCurrentRow)
		End If
	Loop
	
	If (blnTestCaseFound = False) Then
		CRAFT_ReportEvent Environment.Value("ReportedEventSheet"), "Error",_
					"Business flow of the test Case " & strCurrentTestCase &_
					" not found in the scenario " &_
					Environment.Value("CurrentScenario"), "Fail"
		'ExitRun
	End If
	
	CRAFT_SetBusinessFlowRow = intCurrentRow
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   : Function to set the current row in Test Data and Checkpoints sheet based on the current test case iteration
'Input Parameters	 	: strCurrentTestCase, intCurrentIteration, strTestDataSheet, strCheckpointSheet
'Return Value    		: intCurrentRow
'Author				: Cigniti
'Date Created			: 03/06/2014
'#####################################################################################################################
Function CRAFT_SetTestDataRow(strCurrentTestCase, intCurrentIteration, strTestDataSheet, strCheckpointSheet)
	Dim intCurrentRow
	intCurrentRow = DataTable.GetSheet(strTestDataSheet).GetCurrentRow()
	
	Do until Trim(DataTable.Value("TC_ID", strTestDataSheet)) = ""
		If (DataTable.Value("TC_ID", strTestDataSheet) = strCurrentTestCase And DataTable.Value("Iteration", strTestDataSheet) = CStr(intCurrentIteration)) Then
			Exit Do
		Else
			intCurrentRow = intCurrentRow + 1
			DataTable.GetSheet(strTestDataSheet).SetCurrentRow(intCurrentRow)
		End If
	Loop
	
	DataTable.GetSheet(strCheckpointSheet).SetCurrentRow(intCurrentRow)
	CRAFT_SetTestDataRow = intCurrentRow
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   	: Function to set the current row in Common Test Data sheet based on the referenced row
'Input Parameters	 	: strDataReference
'Return Value    		: None
'Author				: Cigniti
'Date Created			: 03/06/2014
'#####################################################################################################################
Function CRAFT_SetCommonDataRow(strDataReference)
	Dim intCurrentRow, blnReferenceFound
	intCurrentRow = 1
	blnReferenceFound = False
	
	DataTable.GetSheet("Common Testdata").SetCurrentRow(intCurrentRow)
	Do until Trim(DataTable.Value("TD_ID","Common Testdata")) = ""
		If (DataTable.Value("TD_ID","Common Testdata") = strDataReference) Then
			blnReferenceFound = True
			Exit Do
		Else
			intCurrentRow = intCurrentRow + 1
			DataTable.GetSheet("Common Testdata").SetCurrentRow(intCurrentRow)
		End If
	Loop
	
	If (blnReferenceFound = False) Then
		CRAFT_ReportEvent Environment.Value("ReportedEventSheet"), "Error",_
				"Missing data reference! Aborting current iteration...", "Fail"
		Environment.Value("ExitCurrentIteration") = True
	End If
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   : Function to invoke the corresponding Business component based on the keyword passed
'Input Parameters	 	: strCurrentKeyword
'Return Value    		: None
'Author				: Cigniti
'Date Created			: 03/06/2014
'#####################################################################################################################
Function CRAFT_InvokeBusinessComponent(strCurrentKeyword)
	If (Environment.Value("OnError") <> "NextStep") Then
		On Error Resume Next
	End If
	
	Execute strCurrentKeyword
	
	CRAFT_ErrHandler()
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   : Function to return the test data value corresponding to the field name passed
'Input Parameters		: strDataSheetName, strFieldName
'Return Value    		: strDataValue
'Author				: Cigniti
'Date Created			: 03/06/2014
'#####################################################################################################################
Function CRAFT_GetData(strTestDataSheet, strFieldName)
	'Initialise required variables
	Dim strReferenceIdentifier, strCurrentTestCase, intCurrentIteration, intCurrentSubIteration, strDatatableName, strFilePath
	Dim strConnectionString, strSql, objConn, objTestData, strDataValue, strFirstChar
	
	strReferenceIdentifier = CRAFT_GetConfig("DataReferenceIdentifier")
	strCurrentTestCase = Environment.Value("CurrentTestCase")
	intCurrentIteration = Environment.Value("CurrentIteration")
	intCurrentSubIteration = Environment.Value("CurrentSubIteration")
	strDatatableName = Environment.Value("CurrentScenario") & ".xls"
	strFilePath = PathFinder.Locate("Datatables\" & strDatatableName)
	strConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strFilePath + ";Extended Properties=""Excel 8.0;HDR=Yes;IMEX=2"""
	
	Set objConn = CreateObject("ADODB.Connection")
	objConn.Open strConnectionString
	Set objTestData = CreateObject("ADODB.Recordset")
	objTestData.CursorLocation = 3
	strSql = "SELECT " & strFieldName & " from [" & strTestDataSheet & "$] where TC_ID='" & strCurrentTestCase & "' and Iteration = '" & intCurrentIteration & "' and SubIteration = '" & intCurrentSubIteration & "'"
	objTestData.Open strSql, objConn
    
	If objTestData.RecordCount = 0 Then
		Err.Raise 2001, "CAFT", "No test data found for the current row: TC_ID = " &_
				strCurrentTestCase & ", Iteration = " & intCurrentIteration &_
								", SubIteration = " & intCurrentSubIteration
	End If
	strDataValue = Trim(objTestData(0).Value)
	strFirstChar = Left(strDataValue, 1)
	
	If strFirstChar = strReferenceIdentifier Then
		objConn.Close
		strDataValue = Split(strDataValue, strReferenceIdentifier)(1)
		strFilePath = PathFinder.Locate("Datatables\Common Testdata.xls")
		strConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strFilePath + ";Extended Properties=""Excel 8.0;HDR=Yes;IMEX=2"""
		objConn.Open strConnectionString
		strSql = "SELECT " & strFieldName & " from [Common Testdata$] where TD_ID='" & strDataValue & "'"
		objTestData.Open strSql,objConn

	   	If objTestData.RecordCount = 0 Then
			Err.Raise 2002, "CAFT", "No common test data found for the current row: TD_ID = " & strDataValue
		End If
		strDataValue = Trim(objTestData(0).Value)
	End If
	
	'Release all objects
	objTestData.Close
	objConn.Close
	Set objConn = Nothing
	Set objTestData = Nothing
	
	'Avoid returning Null value
	If IsNull(strDataValue) Then
		strDataValue = ""
	End If
	CRAFT_GetData = strDataValue
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   	: Function to output intermediate data (output values)  into the Test data sheet
'Input Parameters		: strFieldName, strDataValue
'Return Value    		: None
'Author				: Cigniti
'Date Created			: 04/06/2014
'#####################################################################################################################
Function CRAFT_PutData(strTestDataSheet, strFieldName, strDataValue)
	'Initialize required variables
	Dim strCurrentTestCase, intCurrentIteration, intCurrentSubIteration, strDatatableName, strFilePath, strConnectionString, objConn, strSql
	If(CBool(Environment.Value("RunIndividualComponent")) <> True) Then
		strCurrentTestCase = Environment.Value("CurrentTestCase")
		intCurrentIteration = Environment.Value("CurrentIteration")
		intCurrentSubIteration = Environment.Value("CurrentSubIteration")
		strDatatableName = Environment.Value("CurrentScenario") & ".xls"
		strFilePath = PathFinder.Locate("Datatables\" & strDatatableName)
		strConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strFilePath + ";Extended Properties=""Excel 8.0;HDR=Yes;IMEX=2"""
		
		'Write the output value into the test data sheet
		Set objConn = CreateObject("ADODB.Connection")
		objConn.Open strConnectionString
		strSql = "UPDATE [" & strTestDataSheet & "$] SET " & strFieldName & "='" & strDataValue & "' where TC_ID='" & strCurrentTestCase & "' and Iteration = '" & intCurrentIteration & "' and SubIteration = '" & intCurrentSubIteration & "'"
		objConn.Execute strSql
		objConn.Close
		Set objConn = Nothing
		
		'Report the output value to the results	
		CRAFT_ReportEvent Environment.Value("ReportedEventSheet"), "Output Value", "Output value '" & strDataValue & "' written into the '" & strFieldName & "' column", "Completed"
	End If
End Function

'#####################################################################################################################
'Function Description   	: Function to output intermediate data (output values)  into the Test data sheet
'Input Parameters		: strFieldName, strDataValue
'Return Value    		: None
'Author				: Ram Mohan
'Date Created			: 04/06/2014
'#####################################################################################################################
Function CRAFT_PutCommonData(strFieldRow, strFieldName, strDataValue)
	'Initialize required variables
	Dim  strFilePath, strConnectionString
	Dim objConn, strSql
	
	If(CBool(Environment.Value("RunIndividualComponent")) <> True) Then
		strFilePath = PathFinder.Locate("Datatables\Common Testdata.xls")
		
		Set objConn = CreateObject("ADODB.Connection")
		strConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strFilePath + ";Extended Properties=""Excel 8.0;HDR=Yes;IMEX=2"""
		
		objConn.Open strConnectionString
		'strSql = "SELECT " & strFieldName & " from [Common Testdata$] where TD_ID='" & strDataValue & "'"
		strDataValue = Replace (strDataValue, "'", "''")
		strSql = "UPDATE [Common Testdata$] SET " & strFieldName & "='" & strDataValue & "' where TD_ID='" & strFieldRow & "'"
		objConn.Execute strSql
		
		objConn.Close
		Set objConn = Nothing
		
	End If
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   	: Function to return the expected result data (from the Parameterized Checkpoints sheet) corresponding to the field name passed
'Input Parameters		: strFieldName
'Return Value    		: strDataValue
'Author				: Cigniti
'Date Created			: 04/06/2014
'#####################################################################################################################
Function CRAFT_GetExpectedResult(strFieldName)
	'Initialise required variables
	Dim strReferenceIdentifier, strCheckPointSheet, strCurrentTestCase, intCurrentIteration, strDatatableName, strFilePath
	Dim strConnectionString, strSql, objConn, objTestData, strDataValue, strFirstChar
	
	strReferenceIdentifier = CRAFT_GetConfig("DataReferenceIdentifier")
	strTestDataSheet = Environment.Value("CurrentFunctionalArea") + "_" + CRAFT_GetConfig("TestDataSheet")
	strCurrentTestCase = Environment.Value("CurrentTestCase")
	intCurrentIteration = Environment.Value("CurrentIteration")
	intCurrentSubIteration = Environment.Value("CurrentSubIteration")
	strDatatableName = Environment.Value("CurrentScenario") & ".xls"
	strFilePath = PathFinder.Locate("Datatables\" & strDatatableName)
	strConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + strFilePath + ";Extended Properties=""Excel 8.0;HDR=Yes;IMEX=2"""
	
	Set objConn = CreateObject("ADODB.Connection")
	objConn.Open strConnectionString
	Set objTestData = CreateObject("ADODB.Recordset")
	objTestData.CursorLocation = 3	
	strSql = "SELECT " & strFieldName & " from [" & strCheckPointSheet & "$] where TC_ID='" & strCurrentTestCase & "' and Iteration = '" & intCurrentIteration & "' and SubIteration = '" & intCurrentSubIteration & "'"
	objTestData.Open strSql, objConn
	
	If objTestData.RecordCount = 0 Then
		Err.Raise 2003, "CAFT", "No expected results found for the current row: TC_ID = " & strCurrentTestCase & ", Iteration = " & intCurrentIteration & ", SubIteration = " & intCurrentSubIteration
	End If
	strDataValue = Trim(objTestData(0).Value)
	
	'Release all objects
	objTestData.Close
	objConn.Close
	Set objConn = Nothing
	Set objTestData = Nothing
	
	'Avoid returning Null value
	If IsNull(strDataValue) Then
		strDataValue = ""
	End If
	CRAFT_GetExpectedResult = strDataValue
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   	: Function to get the configuration data from the CRAFT.ini configuration file
'Input Parameters		: strKey
'Return Value    		: Corresponding value from CRAFT.ini
'Author				: Cigniti
'Date Created			: 04/06/2014
'#####################################################################################################################
Function CRAFT_GetConfig(strKey)
	Dim objFso, objMyFile
	Dim strLine, arrLine, strValue, strConfigFilePath
	Set objFso = CreateObject ("Scripting.FileSystemObject")
	strConfigFilePath = PathFinder.Locate("CAFT.ini")
	Set objMyFile = objFso.OpenTextFile(strConfigFilePath,1)
	Do Until objMyFile.AtEndOfStream
		strLine = objMyFile.ReadLine
		If strLine <> "" Then
			arrLine = Split(strLine,"=")
			If arrLine(0) = strKey Then
				strValue = arrLine(1)
				Exit Do
			End If
		End If
	Loop
	
	objMyFile.Close()
	Set objMyFile = Nothing
	Set objFso = Nothing
	CRAFT_GetConfig = CStr(strValue)
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   	: Function to do calculate the execution time for the current iteration
'Input Parameters 		: None
'Return Value    		: None
'Author				: Cigniti
'Date Created			: 04/06/2014
'#####################################################################################################################
Function CRAFT_CalculateExecTime()
	Dim dtmIteration_EndTime, dtmIteration_StartTime, sngIteration_ExecutionTime
	Dim strReportedEventSheet,intCurrentReportedEventRow
	dtmIteration_StartTime = Environment.Value("Iteration_StartTime")
	dtmIteration_EndTime = Now()
	strReportedEventSheet = Environment.Value("ReportedEventSheet")
	
	'Report the total execution time for the current iteration and insert a blank row
	sngIteration_ExecutionTime = DateDiff("s", dtmIteration_StartTime, dtmIteration_EndTime)
	sngIteration_ExecutionTime = Round(CSng(sngIteration_ExecutionTime)/60, 2)
	DataTable.Value("Description", strReportedEventSheet) = "Execution Time (mins)"
	DataTable.Value("Time", strReportedEventSheet) = sngIteration_ExecutionTime
	Environment.Value("TestCase_ExecutionTime") = _
		Environment.Value("TestCase_ExecutionTime") + sngIteration_ExecutionTime
	intCurrentReportedEventRow = _
					DataTable.GetSheet(strReportedEventSheet).GetCurrentRow()
	DataTable.GetSheet(strReportedEventSheet).SetCurrentRow(intCurrentReportedEventRow + 2)
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   	: Function to do required wrap-up work after running a test case
'Input Parameters 		: strDatatableName
'Return Value    		: None
'Author				: Cigniti
'Date Created			: 05/06/2014
'#####################################################################################################################
Function CRAFT_WrapUp(strDatatableName)
	'Initialise required variables
	Dim strProjectName, strReportedEventSheet, strResultSheet, strCurrentTestCase, strDescription, strReportsTheme
	Dim bln_UploadResults, bln_OverallStatusPass, str_Dest_ComponentFolderPath, str_ServerPath

	bln_UploadResults = CBool(CRAFT_GetConfig("UploadResultsToServer"))

	'str_Dest_ComponentFolderPath = Environment.Value("PassedTcs")

	str_ServerPath = CRAFT_GetData("General_Data","ServerPath")

	strProjectName = CRAFT_GetConfig("ProjectName")
	strReportedEventSheet = Environment.Value("ReportedEventSheet")
	strResultSheet = Environment.Value("ResultSheet")
	strCurrentTestCase = TestArgs("CurrentTestCase")
	strDescription = TestArgs("TestCaseDescription")
	strReportsTheme = Environment.Value("ReportsTheme")
	
	'Update overall result of the test case
	If (Environment.Value("OverallStatus") <> "Fail") Then
		Environment.Value("OverallStatus") = "Pass"
	End If

	If Environment.Value("OverallStatus") = "Pass" Then
		bln_OverallStatusPass = True
	Else
		bln_OverallStatusPass = False
	End If

	'Export Results to Excel and HTML
	CRAFT_ExportReportedEventsToExcel strCurrentTestCase, strReportedEventSheet
	CRAFT_ExportReportedEventsToHtml strProjectName, strCurrentTestCase, strReportedEventSheet, strReportsTheme
	CRAFT_UpdateResultSummary strCurrentTestCase, strDescription, Environment.Value("TestCase_ExecutionTime"), strResultSheet
	CRAFT_ExportResultSummaryToExcel strResultSheet
	CRAFT_ExportResultSummaryToHtml strProjectName, strResultSheet, strReportsTheme

	If bln_OverallStatusPass Then
		'Copying all the passed TC's to "Passed TCs" Folder
		'Call CRAFT_CopyPassedTCs(str_Dest_ComponentFolderPath)

		'Copying all the passed TC's to "Server Shared Drive" Folder
		If bln_UploadResults Then
			Call CRAFT_CopyPassedTCs(str_ServerPath)
		End If
	End If
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   	: Function used to enable running of an individual business component independent of the Driver script
'Input Parameters 		: strScenarioName, strTestCaseName, intIteration
'Return Value    		: None
'Author				: Cigniti
'Date Created			: 05/06/2014
'#####################################################################################################################
Function CRAFT_RunIndividualComponent(strScenarioName, strTestCaseName, intIteration)
	Dim intCurrentTestDataRow
	
	Environment.Value("TestDataSheet") = CRAFT_GetConfig("TestDataSheet")
	CRAFT_ImportSheet PathFinder.Locate("Datatables\" & strScenarioName & ".xls"), Environment.Value("TestDataSheet")
	CRAFT_ImportSheet PathFinder.Locate("Datatables\Common Testdata.xls"), "Common Testdata"
	intCurrentTestDataRow = CRAFT_SetTestDataRow(strTestCaseName, intIteration, Environment.Value("TestDataSheet"), Environment.Value("TestDataSheet"))	
	Environment.Value("ReportedEventSheet") = "Dummy"
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   	: Function to report any event related to the current test case
'Input Parameters 		: strReportedEventSheet, strStepName, strDescription, strStatus
'Return Value    		: None
'Author				: Cigniti
'Date Created			: 05/06/2014
'#####################################################################################################################
Function CRAFT_ReportEvent(strReportedEventSheet, strStepName, strDescription, strStatus)
	'Report the event in QTP results
	Dim intStatus
	Select Case strStatus
		Case "Pass"
			intStatus = 0
		Case "Fail"
			intStatus = 1
		Case "Completed"
			intStatus = 2
		Case "Warning"
			intStatus = 3
	End Select
	Reporter.ReportEvent intStatus,strStepName,strDescription
	
	'Report the event in Excel/HTML results
	If(CBool(Environment.Value("RunIndividualComponent")) <> True) Then
		Dim strCurrentTime
		strCurrentTime = Time()
		DataTable.Value("Iteration",strReportedEventSheet) = Environment.Value("CurrentIteration")
		DataTable.Value("Step_Name",strReportedEventSheet) = strStepName
		DataTable.Value("Description",strReportedEventSheet) = strDescription
		DataTable.Value("Status",strReportedEventSheet) = strStatus
		DataTable.Value("Time",strReportedEventSheet) = strCurrentTime
		
		Dim objFso, strScreenshotPath
		Set objFso = CreateObject("Scripting.FileSystemObject")
		strScreenshotPath = Environment.Value("ResultPath") & "\" &_
							Environment.Value("TimeStamp") & "\Screenshots\" &_
								TestArgs("CurrentTestCase") & "_Iteration" &_
								Environment.Value("CurrentIteration") & "_" &_
								Replace(strCurrentTime,":","-") &".png"
		
		'Take screenshot if its a failed step or a warning (only if the user has enabled this setting, and another screenshot was not taken already in the very same second)
		If((strStatus = "Fail" Or strStatus = "Warning") And Environment.Value("TakeScreenshotFailedStep")) And objFso.FileExists(strScreenshotPath) = False Then
			Desktop.CaptureBitmap(strScreenshotPath)
		End If
		
		'Take screenshot if its a passed step (only if the user has enabled this setting, and another screenshot was not taken already in the very same second)
		If((strStatus = "Pass") And Environment.Value("TakeScreenshotPassedStep")) And objFso.FileExists(strScreenshotPath) = False Then
			Desktop.CaptureBitmap(strScreenshotPath)
		End If
		
		Set objFso = Nothing
		
		'Set next row in the Reported Events sheet
		Dim intCurrentRow
		intCurrentRow = DataTable.GetSheet(strReportedEventSheet).GetCurrentRow()
		DataTable.GetSheet(strReportedEventSheet).SetCurrentRow(intCurrentRow + 1)
		
		'Update the overall status of the test case
		If(Environment.Value("OverallStatus") <> "Fail") Then
			If(strStatus="Fail") Then
				Environment.Value("OverallStatus") = "Fail"
			End If
		End If
	End If
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   	: Function to export the reported events in the test case to Excel
'Input Parameters 		: strCurrentTestCase, strReportedEventSheet
'Return Value    		: None
'Author				: Cigniti
'Date Created			: 05/06/2014
'#####################################################################################################################
Function CRAFT_ExportReportedEventsToExcel(strCurrentTestCase, strReportedEventSheet)
	DataTable.ExportSheet Environment.Value("ResultPath") & "\" & Environment.Value("TimeStamp") & "\Excel Results\" & strCurrentTestCase & ".xls",strReportedEventSheet
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   	: Function to set the colors of the HTML report based on the theme specified by the user
'Input Parameters	 	: strReportsTheme, strHeadingColor, strSettingColor, strBodyColor 
'Return Value    		: strHeadingColor, strSettingColor, strBodyColor (through ByRef)
'Author				: Cigniti
'Date Created			: 05/06/2014
'#####################################################################################################################
Function CRAFT_SetReportsTheme(strReportsTheme, ByRef strHeadingColor, ByRef strSettingColor, ByRef strBodyColor)
	'Themes can be easily extended by expanding this function
	Select Case UCase(strReportsTheme)
		Case "AUTUMN"
			strHeadingColor="#7E5D56"
			strSettingColor="#EDE9CE"
			strBodyColor="#F6F3E4"
		Case "OLIVE"
			strHeadingColor="#686145"
			strSettingColor="#EDE9CE"
			strBodyColor="#E8DEBA"
		Case "CLASSIC"
			strHeadingColor="#687C7D"
			strSettingColor="#C6D0D1"
			strBodyColor="#EDEEF0"
		Case "RETRO"
			strHeadingColor="#CE824E"
			strSettingColor="#F3DEB1"
			strBodyColor="#F8F1E7"
		Case "MYSTIC"
			strHeadingColor="#4D7C7B"
			strSettingColor="#FFFFAE"
			strBodyColor="#FAFAC5"	
		Case "SERENE"
			strHeadingColor="#7B597A"
			strSettingColor="#ADE0FF"
			strBodyColor="#C5AFC6"
		Case "REBEL"
			strHeadingColor="#953735"
			strSettingColor="#A6A6A6"
			strBodyColor="#D9D9D9"
		Case Else
			strHeadingColor="#12579D"
			strSettingColor="#BCE1FB"
			strBodyColor="#FFFFFF"	
	End Select
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   : Function to export the reported events in the test case to Html
'Input Parameters	: strProjectName, strCurrentTestCase, strReportedEventSheet, strReportsTheme
'Return Value           : None
'Author			: Cigniti
'Date Created           : 06/06/2014
'#####################################################################################################################
Function CRAFT_ExportReportedEventsToHtml(strProjectName, strCurrentTestCase, strReportedEventSheet, strReportsTheme)
	Dim objFso, objMyFile
	Dim intPassCounter, intFailCounter, intVerificationNo
	Dim strIteration, strStepName, strDescription
	Dim strStatus, strTime, strExecutionTime
	Dim intRowcount, intRowCounter, strTempStatus
	Dim strPath, strScreenShotPath, strScreenShotName
	Dim arrSplitTimeStamp, strTimeStampDate, strTimeStampTime
	Dim strOnError, strIterationMode, intStartIteration, intEndIteration
	Dim strHeadColor, strSettColor, strContentBGColor
	
	arrSplitTimeStamp = Split(Environment.Value("TimeStamp"),"_")
	strTimeStampDate = Replace(arrSplitTimeStamp(1),"-","/")
	strTimeStampTime = Replace(arrSplitTimeStamp(2),"-",":")
	
	strPath = Environment.Value("ResultPath") & "\" &_
				Environment.Value("TimeStamp") & "\HTML Results\" &_
										strCurrentTestCase & ".html"	
	strScreenShotPath = "..\Screenshots\"
	intPassCounter = 0
	intFailCounter = 0
	intVerificationNo = 0
	
	strOnError = Environment.Value("OnError")
	
	Select Case TestArgs("IterationMode")
		Case "oneIteration"
			strIterationMode = "Run one iteration only"
		Case "rngIterations"
			strIterationMode = "Run from <i>Start Iteration</i> to <i>End Iteration</i>"
			
			intStartIteration = TestArgs("StartIteration")
			intEndIteration = TestArgs("EndIteration")
			If intStartIteration = "" Then
				intStartIteration = 1
			End if
			If intEndIteration = "" Then
				intEndIteration = 1
			End if
		Case "rngAll"
			strIterationMode = "Run all iterations"
	End Select
	
	strHeadColor = "#12579D"
	strSettColor = "#BCE1FB"
	strContentBGColor = "#FFFFFF"
	
	CRAFT_SetReportsTheme strReportsTheme,strHeadColor,strSettColor,strContentBGColor
	
	'Create a HTML file
	Set objFso = CreateObject("Scripting.FileSystemObject")
	Set objMyFile = objFso.CreateTextFile(strPath, True)
	objMyFile.Close

	'Open the HTML file for writing
	Set objMyFile = objFso.OpenTextFile(strPath,8)

	'Create the Report header
	objMyFile.Writeline("<html>")
		objMyFile.Writeline("<head>")
			objMyFile.Writeline("<meta http-equiv=" & "Content-Language" & "content=" & "en-us>")
			objMyFile.Writeline("<meta http-equiv="& "Content-Type" & "content=" & "text/html; charset=windows-1252" & ">")
			objMyFile.Writeline("<title> Test Case Automation Execution Results</title>")
			objMyFile.Writeline("<script>")
			objMyFile.Writeline("top.window.moveTo(0, 0);")
			objMyFile.Writeline("window.resizeTo(screen.availwidth, screen.availheight);")
			objMyFile.Writeline("</script>")		
		objMyFile.Writeline("</head>")
		
		objMyFile.Writeline("<body bgcolor = #FFFFFF>")
			objMyFile.Writeline("<blockquote>")			
				objMyFile.Writeline("<p align = center><table border=1 bordercolor=" & "#000000 id=table1 width=900 height=31 cellspacing=0 bordercolorlight=" & "#FFFFFF>")
					objMyFile.Writeline("<tr>")
						objMyFile.Writeline("<td COLSPAN = 6 bgcolor ="& strHeadColor & ">")
							objMyFile.Writeline("<p align=center><font color=#FFFFFF size=4 face= "& chr(34)&"Copperplate Gothic Bold"&chr(34) & ">&nbsp;" & strProjectName & " - " & strCurrentTestCase & " Automation Execution Results" & "</font><font face= " & chr(34)&"Copperplate Gothic Bold"&chr(34) & "></font> </p>")
						objMyFile.Writeline("</td>")
					objMyFile.Writeline("</tr>")
					
					objMyFile.Writeline("<tr>")
						objMyFile.Writeline("<td COLSPAN = 6 bgcolor ="& strHeadColor & ">")
							objMyFile.Writeline("<p align=center><b><font color=#FFFFFF size=2 face= Verdana>"& "&nbsp;"& "DATE: " &  strTimeStampDate & " " & strTimeStampTime)
						objMyFile.Writeline("</td>")					
					objMyFile.Writeline("</tr>")
					
					objMyFile.Writeline("<table border=1 bordercolor=" & "#000000 id=table1 width=900 height=31 cellspacing=0 bordercolorlight=" & "#FFFFFF>")				
					objMyFile.Writeline("<tr bgcolor = "& strSettColor & ">")
						objMyFile.Writeline("<td colspan =2>")
							objMyFile.Writeline("<p align=justify><b><font color=" & strHeadColor & " size=2 face= Verdana>"& "&nbsp;"& "OnError: " & strOnError)
						objMyFile.Writeline("</td>")					  
						
						objMyFile.Writeline("<td colspan =2>")
							objMyFile.Writeline("<p align=right><b><font color=" & strHeadColor & " size=2 face= Verdana>"& "&nbsp;"& "IterationMode: " &  strIterationMode )
						objMyFile.Writeline("</td>") 
					objMyFile.Writeline("</tr>") 	   
					
					If TestArgs("IterationMode")="rngIterations" Then
						objMyFile.Writeline("<tr bgcolor = "& strSettColor & ">")
							objMyFile.Writeline("<td COLSPAN = 4>")
								Dim strESpace, strSSpace
								strESpace="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
								strSSpace="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
								objMyFile.Writeline("<p align=justify><b><font color=" & strHeadColor & " size=2 face= Verdana>"& strSSpace & "Start Iteration: " & intStartIteration & strESpace & "End Iteration: " & intEndIteration)
							objMyFile.Writeline("</td>")					  
						objMyFile.Writeline("</tr>") 	   
					End If
				objMyFile.Writeline("<table>")				
				
				objMyFile.Writeline("<p align = center><table border=1 bordercolor=" & "#000000 id=table1 width=900 height=31 cellspacing=0 bordercolorlight=" & "#FFFFFF>")
					objMyFile.Writeline("<tr bgcolor=" & strHeadColor & ">")
						objMyFile.Writeline("<td width=" & "400")
							objMyFile.Writeline("<p align=" & "center><b><font color = white face=" & "Arial Narrow " & "size=" & "2" & ">" & "Iteration</b>")
						objMyFile.Writeline("</td>")
						
						objMyFile.Writeline("<td width=" & "400")
							objMyFile.Writeline("<p align=" & "center><b><font color = white face=" & "Arial Narrow " & "size=" & "2" & ">" & "Step Name</b>")
						objMyFile.Writeline("</td>")
						
						objMyFile.Writeline("<td width=" & "400")
							objMyFile.Writeline("<p align=" & "center><b><font color = white face=" & "Arial Narrow " & "size=" & "2" & ">" & "Description</b>")
						objMyFile.Writeline("</td>")
						
						objMyFile.Writeline("<td width=" & "400")
							objMyFile.Writeline("<p align=" & "center><b><font color = white face=" & "Arial Narrow " & "size=" & "2" & ">" & "Status</b>")
						objMyFile.Writeline("</td>")
						
						objMyFile.Writeline("<td width=" & "400")
							objMyFile.Writeline("<p align=" & "center><b><font color = white face=" & "Arial Narrow " & "size=" & "2" & ">" & "Time</b>")
						objMyFile.Writeline("</td>")
					objMyFile.Writeline("</tr>")
				'End of Header
				
				'Add Data to the Test Case Log HTML file from the excel file
					intRowcount = Datatable.GetSheet(strReportedEventSheet).GetRowCount
					For intRowCounter = 1 To intRowCount
						Datatable.GetSheet(strReportedEventSheet).SetCurrentRow(intRowCounter)	
						strIteration = Datatable("Iteration",strReportedEventSheet)
						strStepName = Datatable("Step_Name",strReportedEventSheet)
						strDescription = Datatable("Description",strReportedEventSheet)
						strStatus = Datatable("Status",strReportedEventSheet)
						strTime = Datatable("Time",strReportedEventSheet)
						
						If strIteration = "" Then
							objMyFile.Writeline("<tr bgcolor =" & strContentBGColor & ">")
								objMyFile.Writeline("<td COLSPAN = 6>")
									objMyFile.Writeline("<p align=center><b><font size=2 face= Verdana>"& "&nbsp;"& strDescription & ":&nbsp;&nbsp;" &  strTime  & "&nbsp")
								objMyFile.Writeline("</td>")
							objMyFile.Writeline("</tr>")
							intRowCounter = intRowCounter+1
						Else
							objMyFile.Writeline("<tr bgcolor =" & strContentBGColor & ">")
								objMyFile.Writeline("<td width=" & "400>")
									objMyFile.Writeline("<p align=" & "center><font face=" & "Verdana " & "size=" & "2" & ">"  &  strIteration)
								objMyFile.Writeline("</td>")
								
								objMyFile.Writeline("<td width=" & "400>")
									strScreenShotName = TestArgs("CurrentTestCase") & "_Iteration" & strIteration & "_" & Replace(strTime,":","-")
									If(UCase(strStatus) = "FAIL" And Environment.Value("TakeScreenshotFailedStep")) Then										
										objMyFile.Writeline("<p align=center><a href='" & strScreenShotPath & strScreenShotName & ".png" & "'><b><font face=" & "verdana" & "size=" & "2" & ">" & strStepName & "</font></b></a></p>")
									ElseIf(UCase(strStatus) = "PASS" And Environment.Value("TakeScreenshotPassedStep")) Then										
										objMyFile.Writeline("<p align=center><a href='" & strScreenShotPath & strScreenShotName & ".png" & "'><b><font face=" & "verdana" & "size=" & "2" & ">" & strStepName & "</font></b></a></p>")
									Else
										objMyFile.Writeline("<p align=" & "center><font face=" & "Verdana " & "size=" & "2" & ">"  &  strStepName)
									End If
								objMyFile.Writeline("</td>")
								
								objMyFile.Writeline("<td width=" & "400>")
									objMyFile.Writeline("<p align=" & "center><font face=" & "Verdana " & "size=" & "2" & ">"  &  strDescription)
								objMyFile.Writeline("</td>")
								
								objMyFile.Writeline("<td width=" & "400>")
									If UCase(strStatus) = "PASS" Then
										objMyFile.Writeline("<p align=" & "center" & ">" & "<b><font face=" & "Verdana " & "size=" & "2" & " color=" & "#008000" & ">" & strStatus & "</font></b>")
										intPassCounter=intPassCounter + 1	
										intVerificationNo=intVerificationNo + 1
									ElseIf UCase(strStatus) = "FAIL" Then
										objMyFile.Writeline("<p align=" & "center" & ">" & "<b><font face=" & "Verdana " & "size=" & "2" & " color=" & "#FF0000" & ">" & strStatus & "</font></b>")
										intFailCounter=intFailCounter + 1
										intVerificationNo=intVerificationNo + 1
									Else
										objMyFile.Writeline("<p align=" & "center" & ">" & "<b><font face=" & "Verdana " & "size=" & "2" & " color=" & "#8A4117" & ">" & strStatus & "</font></b>")		
									End If
								objMyFile.Writeline("</td>")
							
								objMyFile.Writeline("<td width=" & "400>")
									objMyFile.Writeline("<p align=" & "center><font face=" & "Verdana " & "size=" & "2" & ">"  &  strTime)
								objMyFile.Writeline("</td>")
							objMyFile.Writeline("</tr>")
						End If
					Next
				objMyFile.Writeline("</table>")				
				
				objMyFile.Writeline("<table border=1 bordercolor=" & "#000000 id=table1 width=900 height=31 cellspacing=0 bordercolorlight=" & "#FFFFFF>")
					objMyFile.Writeline("<tr bgcolor =" & strSettColor & ">")
						objMyFile.Writeline("<td colspan =1>")
							objMyFile.Writeline("<p align=justify><b><font color=" & strHeadColor & "  size=2 face= Verdana>"& "&nbsp;"& "No. Of Verification Points :&nbsp;&nbsp;" &  intVerificationNo & "&nbsp;")
						objMyFile.Writeline("</td>")
						
						objMyFile.Writeline("<td colspan =1>")	
							objMyFile.Writeline("<p align=justify><b><font color=" & strHeadColor & "  size=2 face= Verdana>"& "&nbsp;"& "Passed :&nbsp;&nbsp;" &  intPassCounter & "&nbsp;")
						objMyFile.Writeline("</td>")
						
						objMyFile.Writeline("<td colspan =1>")	
							objMyFile.Writeline("<p align=justify><b><font color=" & strHeadColor & "  size=2 face= Verdana>"& "&nbsp;"& "Failed :&nbsp;&nbsp;" &  intFailCounter & "&nbsp;")
						objMyFile.Writeline("</td>")	
					objMyFile.Writeline("</tr>")	
				objMyFile.Writeline("</table>")				
			objMyFile.Writeline("</blockquote>")			
		objMyFile.Writeline("</body>")
	objMyFile.Writeline("</html>")
	objMyFile.Close
	
	Set objMyFile = Nothing
	Set objFso = Nothing
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   	: Function to update the Results Summary with the current Test Case Iteration status
'Input Parameters	 	: strCurrentTestCase, strDescription, sngExecutionTime, strResultSheet
'Return Value    		: None
'Author				: Cigniti
'Date Created			: 27/05/2014
'#####################################################################################################################
Function CRAFT_UpdateResultSummary(strCurrentTestCase, strDescription, sngExecutionTime, strResultSheet)
	DataTable.GetSheet(strResultSheet).SetCurrentRow(DataTable.GetSheet(strResultSheet).GetRowCount+1)
	DataTable.Value("TC_ID",strResultSheet) = strCurrentTestCase
	DataTable.Value("Description",strResultSheet) = strDescription
	DataTable.Value("Execution_Time_Minutes",strResultSheet) = sngExecutionTime
	DataTable.Value("Status",strResultSheet) = Environment.Value("OverallStatus")
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   : Function to exported the Results Summary sheet to Excel
'Input Parameters 		: strResultSheet
'Return Value    		: None
'Author				: Cigniti
'Date Created			: 27/05/2014
'#####################################################################################################################
Function CRAFT_ExportResultSummaryToExcel(strResultSheet)
	DataTable.ExportSheet Environment.Value("ResultPath") & "\" & Environment.Value("TimeStamp") & "\Excel Results\Summary.xls",strResultSheet
End Function
'#####################################################################################################################

'#####################################################################################################################
'Function Description   	: Function to exported the Results Summary sheet to HTML
'Input Parameters 		: strResultSheet
'Return Value    		: None
'Author				: Cigniti
'Date Created			: 27/05/2014
'#####################################################################################################################
Function CRAFT_ExportResultSummaryToHtml(strProjectName, strResultSheet, strReportsTheme)
	Dim objFso, objMyFile
	Dim intPassCounter, intFailCounter, intNoRunCounter
	Dim intRowCount, intRowCounter
	Dim strTC_ID, strDescription, strExecutionTime, strStatus
	Dim strLnkFileName, strPath
	Dim intTotalExecTime, strExecTimeTemp, strUnit
	Dim arrSplitTimeStamp, strTimeStampDate, strTimeStampTime
	Dim strHeadColor, strSettColor, strContentBGColor
	
	arrSplitTimeStamp = Split(Environment.Value("TimeStamp"),"_")
	strTimeStampDate = Replace(arrSplitTimeStamp(1),"-","/")
	strTimeStampTime = Replace(arrSplitTimeStamp(2),"-",":")	
	intPassCounter = 0
	intFailCounter = 0
	intNoRunCounter = 0
	intTotalExecTime = 0
	strPath = Environment.Value("ResultPath") & "\" &_
				Environment.Value("TimeStamp") & "\HTML Results\Summary.html"
	
	'Default settings for theme
	strHeadColor = "#12579D"
	strSettColor = "#BCE1FB"
	strContentBGColor = "#FFFFFF"
	
	CRAFT_SetReportsTheme strReportsTheme, strHeadColor, strSettColor, strContentBGColor
	
	'Count the total Execution time
	intRowCount = Datatable.GetSheet(strResultSheet).GetRowCount
	For intRowCounter = 1 To intRowCount
		Datatable.GetSheet(strResultSheet).SetCurrentRow(intRowCounter)		
		strExecTimeTemp = Datatable("Execution_Time_Minutes",strResultSheet)
		intTotalExecTime = intTotalExecTime+CSng(strExecTimeTemp)	
	Next
	
	If intTotalExecTime = 1 Then
		strUnit = "minute"
	Else
		strUnit = "minutes"
	End If
	
	'Create a HTML file
	Set objFso = CreateObject("Scripting.FileSystemObject")
	Set objMyFile = objFso.CreateTextFile(strPath, True)
	objMyFile.Close
	
	'Open the HTML file for writing
	Set objMyFile = objFso.OpenTextFile(strPath,8)

	'Create the Report header
	objMyFile.Writeline("<html>")
		objMyFile.Writeline("<head>")
			objMyFile.Writeline("<meta http-equiv=" & "Content-Language" & "content=" & "en-us>")
			objMyFile.Writeline("<meta http-equiv="& "Content-Type" & "content=" & "text/html; charset=windows-1252" & ">")
			objMyFile.Writeline("<title> Automation Execution Results</title>")
		objMyFile.Writeline("</head>")
		
		objMyFile.Writeline("<body bgcolor = #FFFFFF>")
			objMyFile.Writeline("<blockquote>")
                objMyFile.Writeline("<p align = center><table border=1 bordercolor=" & "#000000 id=table1 width=900 height=31 cellspacing=0 bordercolorlight=" & "#FFFFFF>")
				
				objMyFile.Writeline("<tr>")
					objMyFile.Writeline("<td COLSPAN = 6 bgcolor =" & strHeadColor &">")
						objMyFile.Writeline("<p align=center><font color=#FFFFFF size=4 face= "& chr(34)&"Copperplate Gothic Bold"&chr(34) & ">&nbsp;Automation Execution Results - " & strProjectName  & "</font><font face= " & chr(34)&"Copperplate Gothic Bold"&chr(34) & "></font> </p>")
					objMyFile.Writeline("</td>")
				objMyFile.Writeline("</tr>")
				
				objMyFile.Writeline("<tr>")
					objMyFile.Writeline("<td COLSPAN = 2 bgcolor =" & strSettColor &">")
						objMyFile.Writeline("<p align=center><font color=" & strHeadColor &  "size=1 face= Verdana>" & "&nbsp;" & "Date: " & strTimeStampDate & " " & strTimeStampTime & "</font><font face= " & chr(34)&"Copperplate Gothic Bold"&chr(34) & "></font> </p>")
					objMyFile.Writeline("</td>")
					
					objMyFile.Writeline("<td COLSPAN = 4 bgcolor = " & strSettColor &">")
						objMyFile.Writeline("<p align=center><font color=" & strHeadColor &  "size=1 face= Verdana>" & "&nbsp;" & "Total Execution Time: " & intTotalExecTime & " " & strUnit  & "</font> </p>")
					objMyFile.Writeline("</td>")
				objMyFile.Writeline("</tr>")
				
				objMyFile.Writeline("<tr bgcolor=" & strHeadColor &">")
					objMyFile.Writeline("<td width=" & "400")
						objMyFile.Writeline("<p align=" & "center><b><font color = white face=" & "Arial Narrow " & "size=" & "2" & ">" & "Test Case ID</b>")
					objMyFile.Writeline("</td>")
					
					objMyFile.Writeline("<td width=" & "400")
						objMyFile.Writeline("<p align=" & "center><b><font color = white face=" & "Arial Narrow " & "size=" & "2" & ">" & "Description</b>")
					objMyFile.Writeline("</td>")
					
					objMyFile.Writeline("<td width=" & "400")
						objMyFile.Writeline("<p align=" & "center><b><font color = white face=" & "Arial Narrow " & "size=" & "2" & ">" & "Execution Time (Minutes)</b>")
					objMyFile.Writeline("</td>")
					
					objMyFile.Writeline("<td width=" & "400")
						objMyFile.Writeline("<p align=" & "center><b><font color = white face=" & "Arial Narrow " & "size=" & "2" & ">" & "Status</b>")
					objMyFile.Writeline("</td>")
				objMyFile.Writeline("</tr>")
				'End of Header
				
				'Add the data from the Summary file to the HTML file
				intRowCount = Datatable.GetSheet(strResultSheet).GetRowCount
				For intRowCounter = 1 To intRowCount
					Datatable.GetSheet(strResultSheet).SetCurrentRow(intRowCounter)	
					strTC_ID = Datatable("TC_ID", strResultSheet)
					strDescription = Datatable("Description", strResultSheet)
					strExecutionTime = Datatable("Execution_Time_Minutes", strResultSheet)
					strStatus = Datatable("Status", strResultSheet)
					strLnkFileName = strTC_ID
					
					objMyFile.Writeline("<tr bgcolor = " & strContentBGColor & ">")	
						objMyFile.Writeline("<td width=" & "400>")							
				        	objMyFile.Writeline("<p align=center><a href='" & strLnkFileName & ".html" & "'" & "target=" & "about_blank" & "><b><font face=" & "verdana" & "size=" & "2" & ">" & strTC_ID & "</font></b></a></p>")
						objMyFile.Writeline("</td>")
						
						objMyFile.Writeline("<td width=" & "400>")
					        objMyFile.Writeline("<p align=" & "center><font face=" & "Verdana " & "size=" & "2" & ">"  &  strDescription)
						objMyFile.Writeline("</td>")			
						
						objMyFile.Writeline("<td width=" & "400>")
					        objMyFile.Writeline("<p align=" & "center><font face=" & "Verdana " & "size=" & "2" & ">"  &  strExecutionTime)
						objMyFile.Writeline("</td>")		
						
						objMyFile.Writeline("<td width=" & "400>")
							If UCase(strStatus) = "PASS" Then
								objMyFile.Writeline("<p align=" & "center" & ">" & "<b><font face=" & "Verdana " & "size=" & "2" & " color=" & "#008000" & ">" & strStatus & "</font></b>")
								intPassCounter = intPassCounter + 1
							ElseIf UCase(strStatus) = "FAIL" Then
								objMyFile.Writeline("<p align=" & "center" & ">" & "<b><font face=" & "Verdana " & "size=" & "2" & " color=" & "#FF0000" & ">" & strStatus & "</font></b>")
								intFailCounter = intFailCounter + 1
							Else
								objMyFile.Writeline("<p align=" & "center" & ">" & "<b><font face=" & "Verdana " & "size=" & "2" & " color=" & "#8A4117" & ">" & strStatus & "</font></b>")
								intNoRunCounter=intNoRunCounter + 1
							End If
						objMyFile.Writeline("</td>")			
					objMyFile.Writeline("</tr>")	
				Next
				objMyFile.Writeline("</table>")
				
				objMyFile.Writeline("<table border=1 bordercolor=" & "#000000 id=table1 width=900 height=31 cellspacing=0 bordercolorlight=" & "#FFFFFF>")	
					objMyFile.Writeline("<tr bgcolor =" & strSettColor &">")
						objMyFile.Writeline("<td colspan =1>")
							objMyFile.Writeline("<p align=justify><b><font color=" & strHeadColor & " size=2 face= Verdana>"& "&nbsp;"& "Passed :&nbsp;&nbsp;" &  intPassCounter & "&nbsp;")
						objMyFile.Writeline("</td>")
						
						objMyFile.Writeline("<td colspan =1>")	
							objMyFile.Writeline("<p align=justify><b><font color=" & strHeadColor & " size=2 face= Verdana>"& "&nbsp;"& "Failed :&nbsp;&nbsp;" &  intFailCounter & "&nbsp;")
						objMyFile.Writeline("</td>")
						
						objMyFile.Writeline("<td colspan =1>")	
							objMyFile.Writeline("<p align=justify><b><font color=" & strHeadColor & " size=2 face= Verdana>"& "&nbsp;"& "InComplete :&nbsp;&nbsp;" &  intNoRunCounter & "&nbsp;")
						objMyFile.Writeline("</td>")	
					objMyFile.Writeline("</tr>")
				objMyFile.Writeline("</table>")
			objMyFile.Writeline("</blockquote>")				
		objMyFile.Writeline("</body>")
	objMyFile.Writeline("</html>")
	objMyFile.Close
	
	Set objMyFile = Nothing
	Set objFso = Nothing
End Function
'#####################################################################################################################


'#####################################################################################################################
'Function Description   	: Function to Generate Random String
'Input Parameters 		: strResultSheet
'Return Value    		: None
'Author				: Cigniti
'Date Created			: 27/05/2014
'#####################################################################################################################
Function CRAFT_RandomString(length)
    Randomize

    Dim CharacterSetArray, int_DesiredLength
	int_DesiredLength = length
    CharacterSetArray = Array(_
        Array(2, "abcdefghijklmnopqrstuvwxyz"), _
        Array(2, "0123456789"), _
		Array(2, "ABCDEFGHIJKLMNOPQRSTUVWXYZ") _
    )

    Dim i, j,Index
    Dim CountX, Chars1, Chars2
    Dim Temp,TempCopy, finalString

    For i = 0 to UBound(CharacterSetArray)

        CountX = CharacterSetArray(0)(0)
        Chars1 = CharacterSetArray(1)(1)
		Chars2 = CharacterSetArray(2)(1)

		For j = 1 to CountX
            Index = Int(Rnd() * Len(Chars1)) + 1
            Temp = Temp & Mid(Chars1, Index, 1)
			Temp = Temp & Mid(Chars2, Index, 1)
        Next
	Next

    Do until Len(Temp) = 0
        Index = Int(Rnd() * Len(Temp)) + 1
        TempCopy = TempCopy & Mid(Temp, Index, 1)
        Temp = Mid(Temp, 1, Index - 1) & Mid(Temp, Index + 1)
    Loop

	finalString = Left(TempCopy,int_DesiredLength)
    CRAFT_RandomString = finalString
End Function

'#####################################################################################################################
'Function Description   : Function to Copy the Passed TCs to a folder
'Input Parameters 	: NA
'Return Value    	: None
'Author			: Cigniti
'Date Created		: 27/05/2014
'#####################################################################################################################
Function CRAFT_CopyPassedTCs(ByVal str_Path)
   ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'Initalizing Folder Variables
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Dim str_Src_ScrshotPath, str_Src_ResultsPath, strCurrentTestCase
	Dim str_Dest_ScrnshotFolderPath, str_Dest_TCFolderPath
	Dim str_Dest_ComponentFolderPath, strComponentFolderName
	Dim oFSO, oScreenshotFolder, oScreenshotFiles, screenshotFile
	
	strCurrentTestCase = TestArgs("CurrentTestCase")

	strComponentFolderName = Environment.Value("CurrentScenario")

	str_Dest_ComponentFolderPath = str_Path & "\" & strComponentFolderName

	str_Dest_TCFolderPath = str_Dest_ComponentFolderPath & "\" & "HTML Results"

	'str_Dest_ScrnshotFolderPath = str_Dest_ComponentFolderPath & "\" & strCurrentTestCase & "\Screenshots"
	str_Dest_ScrnshotFolderPath = str_Dest_ComponentFolderPath & "\" & "Screenshots"
	
	str_Src_ResultsPath = Environment.Value("ResultPath") & "\" &_
				Environment.Value("TimeStamp") & "\HTML Results\" &_
										strCurrentTestCase & ".html"	

	str_Src_ScrshotPath = Environment.Value("ResultPath") & "\" &_
				Environment.Value("TimeStamp") & "\Screenshots\"

	'Check for overall Test Case Status
	If (Environment.Value("OverallStatus") = "Pass") Then
		'Creating Filesystem Objects
		Set oFSO = CreateObject("Scripting.Filesystemobject")
		Set oScreenshotFolder = oFSO.GetFolder(str_Src_ScrshotPath)

		If oFSO.FolderExists(str_Dest_ComponentFolderPath) Then

			If oFSO.FolderExists(str_Dest_TCFolderPath) Then
				'Copying HTML Results
				oFSO.CopyFile str_Src_ResultsPath,str_Dest_TCFolderPath & "\", True

				'Checkpoint for "Screenshot" Folder Exist
				If oFSO.FolderExists(str_Dest_ScrnshotFolderPath) Then
					Set oScreenshotFiles = oScreenshotFolder.Files
					'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
					'Copying only Current Test Case Screenshot Files
					'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
					For Each screenshotFile in oScreenshotFiles
						If Instr(1,screenshotFile.Name,strCurrentTestCase,1) > 0 Then
							oFSO.CopyFile str_Src_ScrshotPath & screenshotFile.Name,str_Dest_ScrnshotFolderPath & "\"
						End If
					Next
				Else
					'Creating "Screenshots" Folder
					oFSO.CreateFolder str_Dest_ScrnshotFolderPath
					Set oScreenshotFiles = oScreenshotFolder.Files
					'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
					'Copying only Current Test Case Screenshot Files
					'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
					For Each screenshotFile in oScreenshotFiles
						If Instr(1,screenshotFile.Name,strCurrentTestCase,1) > 0 Then
							oFSO.CopyFile str_Src_ScrshotPath & screenshotFile.Name,str_Dest_ScrnshotFolderPath & "\"
						End If
					Next
				End If
			Else
				'Creating "HTML Results" & "Screenshots" Folder
				oFSO.CreateFolder str_Dest_TCFolderPath : oFSO.CreateFolder str_Dest_ScrnshotFolderPath
					
				'Copying HTML Results
				oFSO.CopyFile str_Src_ResultsPath,str_Dest_TCFolderPath & "\", True
				Set oScreenshotFiles = oScreenshotFolder.Files
				'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
				'Copying only Current Test Case Screenshot Files
				'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
				For Each screenshotFile in oScreenshotFiles
					If Instr(1,screenshotFile.Name,strCurrentTestCase,1) > 0 Then
						oFSO.CopyFile str_Src_ScrshotPath & screenshotFile.Name,str_Dest_ScrnshotFolderPath & "\"
					End If
				Next
			End If
		Else
			'Creating "TC Folder", "HTML Results" & "Screenshots" Folder
			oFSO.CreateFolder str_Dest_ComponentFolderPath : oFSO.CreateFolder str_Dest_TCFolderPath : oFSO.CreateFolder str_Dest_ScrnshotFolderPath
			'Copying HTML Results
			oFSO.CopyFile str_Src_ResultsPath,str_Dest_TCFolderPath & "\", True
			Set oScreenshotFiles = oScreenshotFolder.Files
			'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			'Copying only Current Test Case Screenshot Files
			'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			For Each screenshotFile in oScreenshotFiles
				If Instr(1,screenshotFile.Name,strCurrentTestCase,1) > 0 Then
					oFSO.CopyFile str_Src_ScrshotPath & screenshotFile.Name,str_Dest_ScrnshotFolderPath & "\"
				End If
			Next
		End If
		'Destroying Filesystem Objects
		Set oFSO = Nothing : Set oScreenshotFolder = Nothing : Set oScreenshotFiles = Nothing
	End If
End Function

'#####################################################################################################################
'Function Description   : Function to Check Whether a folder is EMPTY or Not
'Input Parameters 	: strFolderPath
'Return Value    	: None
'Author			: Cigniti
'Date Created		: 27/05/2014
'#####################################################################################################################

Function CRAFT_IsEmptyFolder(strFolderPath)
	Dim oFSO, oFolder, bln_IsFolderEmpty
	bln_IsFolderEmpty = False

	Set oFSO = CreateObject("Scripting.Filesystemobject")
	Set oFolder = oFSO.GetFolder(strFolderPath)

	If (oFolder.Files.Count = 0) And (oFolder.SubFolders.Count = 0) Then
		bln_IsFolderEmpty = True
	End If
	'Returning Flag Value
	CRAFT_IsEmptyFolder = bln_IsFolderEmpty

	'Destroyinf Filesystem Objects
	Set oFSO = Nothing : Set oFolder = Nothing
End Function


''========================================================================================
'Function to Connect to the Database
''========================================================================================
Function CRAFT_ConnectDatabase(Byval strConName,Byval strDSNName,Byval strServerName,Byval strDataBaseName,Byval strUserID,Byval strPassword)
	'Assign Database Connection Information to the DB Variables
	DataSource = strDSNName
	Server = strServerName
	UserID_DB = strUserID
	Password_DB = strPassword
	DatabaseName_DB = strDataBaseName
    con=strConName
	Dim connItems(2)
	Dim connState
	'Declare Database Recordset variable
    conString = cstr("DSN="&DataSource&chr(59)&"Server="&Server&chr(59)&"UID="&UserID_DB&chr(59)&"Password="&Password_DB&chr(59)&"DATABASE="&DatabaseName_DB)

	'Create Database Connection Object
	Set conn = CreateObject("Adodb.Connection")

	'Open Database Connection
	conn.Open conString
	'Verify the Successful Database Connection Establishment
	If conn.State=1 Then
		Reporter.ReportEvent micDone,"Database Connection Success"," Database connection for " & DatabaseName_DB & "Database has been established Successfully"
		'MsgBox "Connection Estblished Successfully"
	Else
		Reporter.ReportEvent micDone,"Database Connection Failure"," Database connection for " & DatabaseName_DB & "Database is not been established successfully"
		'MsgBox "Connection Not Estblished"
	End If
	connItems(0) = conn.State
	connItems(1) = conn
	ConnectDatabase = connItems
End Function
'-----------------------------------------------------------------------------------------

''========================================================================================
'Function to Execute Any SQL Query
''========================================================================================
Function CRAFT_ExecuteSQLQuery(ByVal DBConnectionState,ByVal DBConnectionProperty,Query)
	If DBConnectionState = 1 Then
		Set rs = createobject("adodb.recordset")
		rs.Open Query,DBConnectionProperty
		index = 0
		Dim arrResultSet()
		While rs.EOF <> True
			ReDim Preserve arrResultSet(index)
			arrResultSet(index) = rs.Fields(0).Value
			rs.MoveNext
			index = index + 1
		Wend
	End If
	ExecuteQuery = arrResultSet
End Function
'---------------------------------------------------------------------------------------