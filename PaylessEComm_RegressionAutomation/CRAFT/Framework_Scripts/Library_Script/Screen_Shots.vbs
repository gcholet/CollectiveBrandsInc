
Class Screen_Shots

	'==========================================================================================
	' Purpose			: Function to create snap shots
	' Author				: Cognizant Tecnology Solutions
	' Created on   	   :  18-July-2009
	' Last Updated	: 
	' Reviewer			:
	'==========================================================================================
	Function Snap_Shots(ByRef objsub, ByVal Folder_Path,ByVal File_Name,ByRef objEnvironmentVariables)
		present_time=now
		present_time=Replace(present_time,"/","-")
		present_time=Replace(present_time," ","_")
		present_time=Replace(present_time,":","_")
		strpath=Folder_Path
		scr_path=Replace(strpath&"\"&File_Name&present_time&".png"," ","_")
		Desktop.CaptureBitmap scr_path
		objEnvironmentVariables.ScreenShotPath=scr_path
	End Function

End Class
