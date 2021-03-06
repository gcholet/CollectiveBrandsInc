Class RepositoryLoadScript

	Function UploadRepository (strControlPath)
		
		Set Folder_File_Obj=CreateObject("Scripting.FileSystemObject")
		Rep_Folder_Path=Folder_File_Obj.GetFolder(strControlPath&"Framework_Scripts\ObjectRepository").Path
		Set Rep_File_Collection=Folder_File_Obj.GetFolder(strControlPath&"Framework_Scripts\ObjectRepository").Files
		Set app = CreateObject("QuickTest.Application")

		set app_test=app.test
		set test_actions=app_test.Actions
		If Environment.Value( "TestName" ) = "RunManager" Then
			set test_action=test_actions.Item(1)
		Else
			set test_action=test_actions.Item(2)
		End If
		set test_rep=test_action.ObjectRepositories
		test_rep.RemoveAll
		For Each Rep_File In Rep_File_Collection
			If UCase(Right(Rep_File.Name,3))="TSR" then
				Rep_File_Path=Rep_Folder_Path&"\"& Rep_File.Name
				test_rep.Add Rep_File_Path
			End If
		Next
		
	End Function	

End Class