Class UtilityScript

	'-------------------------------------------------------------------------------------------------
	'Function Name		: BackUpReport
	'Input Parameter     :ObjEniron: Object for Environment Variables
	'Description        	 :This function takes back up of the Run-Time error reporting .HTML File to Central / Server Location
	' Calls              			:File System Object
	' Author					  :Cognizant Technology Solutions  
	'-------------------------------------------------------------------------------------------------
	Function backUpReport(ByRef ObjEniron, ByVal Iterate)

		Dim fso, flDest, flSource
	
		Set fso = CreateObject("Scripting.FileSystemObject")
	
		strErrorLogPath = ObjEniron.RunTimeReportPath & "\" & Replace(CStr(Date()),"/","-")&"_"&Iterate

		sourceFile = ObjEniron.TempFilePath & "\" & ObjEniron.TestCaseName & ".html"
	
		If fso.FolderExists(strErrorLogPath) = FALSE Then
			fso.CreateFolder strErrorLogPath
		End If
	
		destFile = strErrorLogPath & "\" & ObjEniron.TestCaseName & ".html"

		If fso.FileExists(destFile)=FALSE Then
			Set flDest = fso.CreateTextFile(destFile,TRUE)
			Set flSource = fso.OpenTextFile(sourceFile,1)
			strAppendString = Split(flSource.ReadAll,VbCrlf)

			For iCnt = 1 To UBound(strAppendString)-1
				flDest.Write strAppendString(iCnt)
			Next
		Else
			Set flDest = fso.OpenTextFile(destFile,2)
			Set flSource = fso.OpenTextFile(sourceFile,1)
			strAppendString = Split(flSource.ReadAll,vbcrlf)

			flDest.Write "</TABLE><BR><BR>"

			For iCnt = 4 To UBound(strAppendString)-1
				flDest.Write strAppendString(iCnt)
			Next
		End If
		
		flSource.Close
		flDest.Close
	
		Set flSource = fso.GetFile(sourceFile)
		flSource.Delete(TRUE)

		Set flSource = Nothing
		Set flDest = Nothing
		Set fso = Nothing
	
	End Function

End Class