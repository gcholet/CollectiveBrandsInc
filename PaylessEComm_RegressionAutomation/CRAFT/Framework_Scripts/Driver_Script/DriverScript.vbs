Class DriverScript   

    '===================================================================================================
    ' Purpose       	: Main Function that handles entire execution of the script as Driver
    ' Author        		: Cognizant Tecnology Solutions
    ' Created Date  : 10-Aug-2009
    ' Reviewer      	:  Teekam Singh Karki
    '====================================================================================================

    Function DriverScripts(ByRef clsDatabase_Module, ByVal iSheetCnt, ByRef objEnvironmentVariables, ByVal IntSheetNo, ByVal total_iteration)		
			'Declares the variables	
			Dim clsInitScript, clsUtilityScript, clsKeywordDrivenActionsScript, clsReport
			
			'Desc: To handle QC integration			
			Dim clsQCIntegration,DownloadPath			
			
			'Instantiates object        
			Set clsInitScript = New InitScript
			Set clsUtilityScript = New UtilityScript
			Set clsKeywordDrivenActionsScript = New KeywordDrivenActionsScript
			Set clsReport = New Report		
		
			'Desc: To handle QC integration		
			Set clsQCIntegration = New QCIntegration_Module
				
			objEnvironmentVariables.ErrNum = 1
		
			'Sets the focus on the current row of the Master Excel
			DataTable.GetSheet("Master").SetCurrentRow(iSheetCnt)
		
			TestCase_excel_name=DataTable("TestCase_Name", "Master")	
			strControlPath=objEnvironmentVariables.CntrlPath
			TestCase_excel_path=strControlPath & "Business_Scripts\TestCase_Scripts\"&objEnvironmentVariables.ProjectName&"\" & strGroupName & "\" & TestCase_excel_name & ".xls"	
			
			strTestCaseTemp = Split(TestCase_excel_path, "\")
			strTestCase = Replace(strTestCaseTemp(UBound(strTestCaseTemp)), ".xls", "")  


			objEnvironmentVariables.TestCaseName = strTestCase
			
			'Desc: To handle QC integration		
			DownloadPath = strControlPath & "Business_Scripts\TestCase_Scripts\" & objEnvironmentVariables.ProjectName & "\"		
			''TestCaseNameFromQC=DataTable("TestCaseNameFromQC","Master") '' Column Removed from master sheet 
			TestCaseNameFromQC = "NA"
		
			objEnvironmentVariables.TestCaseNameFromQC  = TestCaseNameFromQC

			''Teekam , Here adding a sheet with QTP as name of test case.
			''and import the test case script data in to that sheet in QTP
		

''''Teekamm stat  3 Nov 
			''old 
'			Datatable.AddSheet strTestCase  ''tsk 30
'			DataTable.ImportSheet TestCase_excel_path,"Global", strTestCase      ''tsk 30

			''New 
			strTestCase = "Test Script"
			Datatable.AddSheet  strTestCase   ''tsk 30
			DataTable.ImportSheet TestCase_excel_path,"Global", strTestCase       ''tsk 30

'''Teekam End 
				
			'Undergoes execution of the scenario for the number of iterations specified.
			For iDiffCnt=1 to total_iteration
				objEnvironmentVariables.TestCaseStatus=True
				clsReport.WriteHTMLResultLog objEnvironmentVariables, "Iteration " & iDiffCnt & " execution started..", "START"	
				clsReport.WriteHTMLHeader objEnvironmentVariables
					
		
				objEnvironmentVariables.CompleteTestStepCount=0
				clsReport.WriteHTMLResultLog objEnvironmentVariables,"Test Case "&objEnvironmentVariables.TestCaseName&" execution started..", "START"		
		
				'Iterates for different actions within a test case
				For TestCaseStep=1 to DataTable.GetSheet(strTestCase).GetRowCount   ''tsk 30 					
						DataTable.GetSheet(strTestCase).SetCurrentRow(TestCaseStep)  ''tsk 30 
						If UCase(Left(Datatable("Action",strTestCase),6))=UCase("Action") then   ''tsk 30 ''currently action concept is not applicable with framework 
								Action_Script=Datatable.GetSheet(strTestCase).GetParameter("Action").ValueByRow(TestCaseStep)  ''tsk 30 
								Action_Iteration_Per_Cycle=Datatable.GetSheet(strTestCase).GetParameter("ReusableIteration").ValueByRow(TestCaseStep)	''str 30 
								Action_Sheet=Mid(Action_Script,Instr(Action_Script,"_")+1)
								
								On Error resume next
								set Datatable_Parameter=Datatable.GetSheet("Action_Sheet").GetParameter("Action")
								If err.number<>0 Then
										Datatable.AddSheet Action_Sheet
										Datatable.ImportSheet strControlPath & "Business_Scripts\TestCase_Scripts\"&objEnvironmentVariables.ProjectName&"\Action_Scripts\"&Action_Sheet&".xls","Global",Action_Sheet
										err.clear
								End If
								On Error goto 0
								objEnvironmentVariables.Iteration_Per_Cycle=Action_Iteration_Per_Cycle
								call clsKeywordDrivenActionsScript.KeywordDrivenActions(Action_Sheet,iDiffCnt,objEnvironmentVariables, clsDatabase_Module)
								
								If err.number <> 0 AND err.number <> 501 AND err.number <> 13 Then
										err.Clear
										Exit For
								End If	
		
						Else
								objEnvironmentVariables.CurrentTestStepCount=TestCaseStep
								
								call clsKeywordDrivenActionsScript.KeywordDrivenActions(strTestCase,iDiffCnt,objEnvironmentVariables, clsDatabase_Module)  ''tsk 30 
						
								If err.number <> 0 AND err.number <> 501 AND err.number <> 13 Then
										err.Clear
										Exit For
								End If


								'''-----------Teekam 18-Feb -----------------------
								''We have to uses below code of Action script use in eComm application automation
								'''-----------Teekam 18-Feb -----------------------


								''Teekam Currently "Action" method is not used in framework so commneted 
								''=============================================================
								'TestCaseStep=objEnvironmentVariables.CompleteTestStepCount-1	
								'if objEnvironmentVariables.CompleteTestStepCount=DataTable.GetSheet(strTestCase).GetRowCount then  'tsk 30 
								'		Exit For
								'End If	
								Exit for ''by Teekam 20 Nov
								''=============================================================
						End If
				Next

				''Teekam Opend again 9 April ,, It close the All browser which open through QTP				
				'SystemUtil.CloseDescendentProcesses  
								
				'Checks and creates Iterations column in the result sheet.
				On Error resume next				
				set Datatable_Parameter=Datatable.GetSheet("Master").GetParameter("Iteration_" & iDiffCnt)
		
				If err.number <> 0 AND err.number <> 501 AND err.number <> 13 Then	
						Datatable.GetSheet("Master").AddParameter "Iteration_" & iDiffCnt,""			
						err.clear	
				End If
		
				On Error goto 0		
				'Writes to the result sheet the execution status of the concerned Scenario.		
				For i=1 to intRowCountMaster
						If (DataTable.GetSheet("Master").GetParameter("TestCase_Name").ValueByRow(i)= objEnvironmentVariables.TestCaseName) Then
								DataTable.GetSheet("Master").GetParameter("Iteration_" & iDiffCnt).ValueByRow(i)=objEnvironmentVariables.TestCaseStatus
								Exit for
						End If
				Next		
				'SystemUtil.CloseDescendentProcesses
				
				'Finishes the Step-Wise Report.
				clsReport.WriteHTMLResultLog objEnvironmentVariables, "Iteration " & iDiffCnt & " execution completed.. ", "END"
				'Writes the Run-Time error report.
				clsReport.WriteHTML_Verification objEnvironmentVariables
				'Takes the backup of the Run-Time error report.
				clsUtilityScript.backUpReport objEnvironmentVariables,iDiffCnt
			
			Next
		
			For iSheetCnt = DataTable.GetSheetCount to IntSheetNo + 2 step -1
					Datatable.DeleteSheet iSheetCnt
			Next   
			         
    End Function
End Class
