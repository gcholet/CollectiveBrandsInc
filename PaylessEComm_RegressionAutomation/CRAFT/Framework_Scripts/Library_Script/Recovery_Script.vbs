Class RecoveryLoadScript

	Function UploadRecovery (strControlPath)
		''Teekam : added recovery scenario from EnvironmentSetUp.vbs
		
'		Set Folder_File_Obj=CreateObject("Scripting.FileSystemObject")
'		Recovery_Folder_Path=Folder_File_Obj.GetFolder(strControlPath&"Framework_Scripts\RecoveryScenarios").Path
'		Set Recovery_File_Collection=Folder_File_Obj.GetFolder(strControlPath&"Framework_Scripts\RecoveryScenarios").Files
'		Set app = CreateObject("QuickTest.Application")
'		set app_test=app.test
'		set script_settings=app_test.Settings
'		set Recovery_Obj=script_settings.Recovery
'		Recovery_Obj.RemoveAll
'		Recovery_Position=1
'		For Each Recovery_File In Recovery_File_Collection
'			If UCase(Right(Recovery_File.Name,3))="QRS" then	
'				Recovery_File_Path=Recovery_Folder_Path&"\"& Recovery_File.Name
'				Recovery_Obj.Add Recovery_File_Path, Mid(Recovery_File.Name,1,Instr(Recovery_File.Name,".")-1)
'				'Recovery.SetScenarioStatus Recovery_Position, True
'				'Recovery_Position=Recovery_Position+1
'			End If
'		Next
'		Recovery_Obj.SetActivationMode "OnError"
	End Function


End Class







