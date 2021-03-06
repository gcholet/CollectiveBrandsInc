'**********************************************************************************************
'**********************************************************************************************
' objFunctions.vbs  ---> Contains General function
' Functions - See individual Function Headers for
'       A detail description of function functionality
'       checkBoxChecker
'       checkBoxCheckerWIndex
'       checkBoxFinder
'       checkBoxFinderWIndex
'       copyrightCheck
'       getTableRowCount
'       imageClicker
'       imageClickerWIndex
'       imageFinder
'       imageFinderWIndex
'       linkClicker
'       linkClickerWIndex
'       linkFinder
'       linkFinderWIndex
'		objectAction 					' To perform the action on Object which is identified
'		objectFinder 					' To Identify the Object availability on screen
'       pageTitleCheck
'		VerifyWebTableColAllVals 		' To Verify the data sent is available in the entire column
'		verifyWebTableHeader 			' To Verify Webtable Header on screen
'		verifyWebTableSort				'To Verify the data after sort (ASC/DESC) in WebTable
'       verifyWebTableVals
'		waitForObject					' Wait For Object till the Process Image disappears on screen
'       webButtonFinder
'       webButtonFinderWIndex
'       webButtonClicker
'       webButtonClickerWIndex
'		WebButtonStatus
'       webEditEnter
'       webEditEnterWIndex
'       webEditFinder
'       webEditFinderWIndex
'		webEditStatus
'       webElementFinder
'       webElementFinderWIndex
'       webElementClicker
'       webElementClickerWIndex
'       webElementStatus 				'check the obj status (e.g., disabled/active/inactive)
'       webFileFinder
'       webFileFinderWIndex
'       webFileEnter
'       webFileEnterWIndex
'		Weblistcnt
'       webListFinder
'       webListFinderWIndex
'       webListSelect
'       webListSelectWIndex
'       webRadioGrpFinder
'       webRadioGrpFinderWIndex
'       webRadioGrpSelect
'       webRadioGrpSelectWIndex
'       webRadioGrpSelectWExpVal
'       webRadioGrpSelectWIndexWExpVal
'       webTableAction
'       webTableSearch
'       WebTableStatus
'**********************************************************************************************
'**********************************************************************************************
Option Explicit

'<@class_summary>
'**********************************************************************************************
' <@purpose>
'   This Class is used to interact with different objects in an (web) application
'     Such as (links, images, checkboxes, lists, etc...)
'   Execution of this Class File will create a objFunctions Object automatically
'   Object Name equals "of"
' </@purpose>
'
' <@author>
'		Mike Millgate
' </@author>
'
' <@creation_date>
'   07-27-2006
' </@creation_date>
'
'**********************************************************************************************
'</@class_summary>
Class objFunctions

	'<@comments>
	'**********************************************************************************************
	' <@name>linkFinder</@name>
	'
	' <@purpose>
	'   To verify that the Link exists on current visible browser page
	'   Will check using the Text Property value first then use the HTML ID Property
	'   If not found by the Text Property
	' </@purpose>
	'
	' <@parameters>
	'        sTextOrHTMLIDProperty (ByVal) = String - Text or HTML ID of the link to be verified
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'            True -  If found
	'            False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.linkFinder("Modifier Crosswalk")</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>07-27-2006</@creation_date>
	'
	' <@mod_block>
	'   10-02-2006 - MM - Changed all .Exist statements to a default timeout of 1 second
	'   10-11-2006 - MM - Added logic to use Environment Variable BROWSER_TITLE set by the initialize script
	'   02-28-2007 - MM - Added name of function to error messages where invalid parameters are passed
	'   10-22-2007 - MM - Added Transaction Timer Command
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the HTML ID property
	'                     if not found by the TEXT Property
	' </@mod_block>
	' 
	'**********************************************************************************************
	'</@comments>
	Public Function linkFinder(ByVal sTextOrHTMLIDProperty) ' <@as> Boolean
	
	   Services.StartTransaction "linkFinder" ' Timer Begin
	   Reporter.ReportEvent micDone, "linkFinder", "Function Begin"
	   
	   Dim oAppBrowser, oAppObj
	   Dim bFound
	
	   ' Check to verify passed parameters that they are not null or an empty string
	   If IsNull(sTextOrHTMLIDProperty) or sTextOrHTMLIDProperty = "" Then
	           Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the linkFinder function check passed parameters"
	           linkFinder = False ' Return Value
	           Services.EndTransaction "linkFinder" ' Timer End
	           Exit Function
	   End If
	
	   ' Description Object Declarations/Initializations
	   Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	   
		 ' Adds a "\" before special characters.
     sTextOrHTMLIDProperty = Replace(Replace(Replace(Replace(sTextOrHTMLIDProperty, "(", "\("), ")", "\)"), "?", "\?"), "$", "\$")
	
	   Set oAppObj = Description.Create()
	   oAppObj("MicClass").Value = "Link"
	   oAppObj("text").Value = sTextOrHTMLIDProperty
	   
	   ' Verification of the Object
	   If Browser(oAppBrowser).Link(oAppObj).Exist(1) Then
	   	bFound = True
	   Else ' check using the html id property
	   	oAppObj.Remove "text" ' Remove text property
	   	oAppObj("html id").Value = sTextOrHTMLIDProperty
	   	If Browser(oAppBrowser).Link(oAppObj).Exist(1) Then
	   		bFound = True
	   	Else ' Not found
	   		bFound = False
	   	End If
	   End If
	   
	   If bFound Then
	   	linkFinder = True ' Return Value
	   Else ' Not Found
	   	linkFinder = False ' Return Value
	   End If
		 
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "linkFinder", "Function End"
		Services.EndTransaction "linkFinder" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>linkFinderWIndex</@name>
	'
	' <@purpose>
	'   To verify that the Link exists on current visible browser page using the index property
	'   Will check using the Text Property value first then use the HTML ID Property
	'   If not found by the Text Property
	' </@purpose>
	'
	' <@parameters>
	'        sTextOrHTMLIDProperty (ByVal) = String - Text or HTML ID of the link to be verified
	'        iIndex (ByVal) = Integer - Index Property Value for Link to be verified
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'            True -  If found
	'            False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.linkFinderWIndex("Modifier Crosswalk", 0)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>10-12-2006</@creation_date>
	'
	' <@mod_block>
	'   02-28-2007 - MM - Added name of function to error messages where invalid parameters are passed
	'   10-22-2007 - MM - Added Transaction Timer Command
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the HTML ID property
	'                     if not found by the TEXT Property
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function linkFinderWIndex(ByVal sTextOrHTMLIDProperty, ByVal iIndex) ' <@as> Boolean
	
	   Services.StartTransaction "linkFinderWIndex" ' Timer Begin
	   Reporter.ReportEvent micDone, "linkFinderWIndex", "Function Begin"
	   
	   ' Variable Declaration / Initialization
	   Dim oAppBrowser, oAppObj
	   Dim bFound
	   
	   ' Check to verify passed parameters that they are not null or an empty string
	   If IsNull(sTextOrHTMLIDProperty) or sTextOrHTMLIDProperty = "" or IsNull(iIndex) or iIndex = "" Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the linkFinderWIndex function check passed parameters"
	   	linkFinderWIndex = False ' Return Value
	   	Services.EndTransaction "linkFinderWIndex" ' Timer End
	   	Exit Function
	   End If
	   
	   ' Description Object Declarations/Initializations
	   Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	   
		 ' Adds a "\" before special characters.
     sTextOrHTMLIDProperty = Replace(Replace(Replace(Replace(sTextOrHTMLIDProperty, "(", "\("), ")", "\)"), "?", "\?"), "$", "\$")
	   
	   Set oAppObj = Description.Create()
	   oAppObj("micclass").Value = "Link"
	   oAppObj("text").Value = sTextOrHTMLIDProperty
	   oAppObj("index").Value = iIndex
	   
	   ' Verification of the Object
	   If Browser(oAppBrowser).Link(oAppObj).Exist(1) Then
	   	bFound = True
	   Else ' check using the html id property
	   	oAppObj.Remove "text" ' Remove text property
	   	oAppObj("html id").Value = sTextOrHTMLIDProperty
	   	If Browser(oAppBrowser).Link(oAppObj).Exist(1) Then
	   		bFound = True
	   	Else ' Not found
	   		bFound = False
	   	End If
	   End If
	   
	   If bFound Then
	   	linkFinderWIndex = True ' Return Value
	   Else ' Not Found
	   	linkFinderWIndex = False ' Return Value
	   End If
	   
	   ' Clear Object Variables
	   Set oAppBrowser = Nothing
	   Set oAppObj = Nothing
		   
		 Reporter.ReportEvent micDone, "linkFinderWIndex", "Function End"
		 Services.EndTransaction "linkFinderWIndex" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>linkClicker</@name>
	'
	' <@purpose>
	'   verifies that the link exists on current visible browser page and if so,
	'		is clicked.
	'   Will check using the TEXT Property value first then use the HTML ID Property
	'   If not found by the TEXT Property  
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - Name or HTML ID of the link to be verified and clicked
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            	true -  if found
	'            	false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.linkClicker("Modifier Crosswalk")</@example_usage>
	'
	' <@author>craig cardall</@author>
	'
	' <@creation_date>04-24-07</@creation_date>
	'
	' <@mod_block>
	'   10-22-2007 - MM - Added Transaction Timer Command
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the HTML ID property
	'                     if not found by the TEXT Property
	'                     Added logic to verify the link is enabled
	'                     Added Transaction Timer to the click functionality
	'   06-23-2008 - MM - Added logic to escape special characters ()$?
	'   08-19-2008 - MM - Removed the Transaction Timers and waitProperty logic after clicking the
	'                     Link.
	'
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function linkClicker(ByVal sNameOrHTMLIDProperty) ' <@as> Boolean
	
	 	Services.StartTransaction "linkClicker" ' Timer Begin
		Reporter.ReportEvent micDone, "linkClicker", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj, iDisabled
		Dim bFound
	
		'check to verify passed parameters that they are not null or an empty string.
		If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Then
			Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the linkClicker function check passed parameters"
			linkClicker = False ' Return Value
			Services.EndTransaction "linkClicker" ' Timer End
			Exit Function
		End If
		
		' Adds a "\" before special characters.
    sNameOrHTMLIDProperty = Replace(Replace(Replace(Replace(sNameOrHTMLIDProperty, "(", "\("), ")", "\)"), "?", "\?"), "$", "\$")
	
		'object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "Link"
		oAppObj("text").Value = sNameOrHTMLIDProperty
	
		' Verification of the object. 
		If Browser(oAppBrowser).Link(oAppObj).Exist(1) Then
			bFound = True
		Else ' Check using the HTML ID Property
			oAppObj.Remove "text" ' Remove TEXT Property
			oAppObj("html id").Value = sNameOrHTMLIDProperty ' Add HTML ID Property
			If Browser(oAppBrowser).Link(oAppObj).Exist(1) Then
				bFound = True
			Else ' Not Found
				bFound = False
			End If
		End If
		
		' Object Found click it if enabled
		If bFound Then
			
			' Check to see if the Link is enabled
	  	iDisabled = Browser(oAppBrowser).Link(oAppObj).GetROProperty("disabled")
	  	
			If iDisabled = 1 Then
				Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' Link", "The '" & sNameOrHTMLIDProperty & "' Link is disabled"
				linkClicker = False ' Return Value
			Else ' Link Enabled
				Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' Link", "The '" & sNameOrHTMLIDProperty & "' Link is enabled"
				
				' Click the Link
				Browser(oAppBrowser).Link(oAppObj).Click
				linkClicker = True ' Return Value
				
			End If		
			
		Else ' Object Not Found
			linkClicker = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "linkClicker", "Function End"
		Services.EndTransaction "linkClicker" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>linkClickerWIndex</@name>
	'
	' <@purpose>
	'   verifies that the link exists on current visible browser page using the index property, and if so,
	'		is clicked.
	'   Will check using the TEXT Property value first then use the HTML ID Property
	'   If not found by the TEXT Property   
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - Name or HTML ID of the link to be verified and clicked
	'		iIndex = integer (ByVal) - index value of the link to be verified and clicked
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            	true -  if found
	'            	false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.linkClickerWIndex("Modifier Crosswalk", 0)</@example_usage>
	'
	' <@author>craig cardall</@author>
	'
	' <@creation_date>05-08-07</@creation_date>
	'
	' <@mod_block>
	'   10-22-2007 - MM - Added Transaction Timer Command
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the HTML ID property
	'                     if not found by the TEXT Property
	'                     Added logic to verify the link is enabled
	'                     Added Transaction Timer to the click functionality
	'   06-23-2008 - MM - Added logic to escape special characters ()$?
	'   08-19-2008 - MM - Removed the Transaction Timers and waitProperty logic after clicking the
	'                     Link.
	'
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function linkClickerWIndex(ByVal sNameOrHTMLIDProperty, ByVal iIndex) ' <@as> Boolean
	
	 	Services.StartTransaction "linkClickerWIndex" ' Timer Begin
		Reporter.ReportEvent micDone, "linkClickerWIndex", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj, iDisabled
		Dim bFound
	
		'check to verify passed parameters that they are not null or an empty string.
		If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Or IsNull(iIndex) Or iIndex = "" Then
			Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the linkClickerWIndex function check passed parameters"
			linkClickerWIndex = False ' Return Value
			Services.EndTransaction "linkClickerWIndex" ' Timer End
			Exit Function
		End If
	
		'object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
				
		' Adds a "\" before special characters.
    sNameOrHTMLIDProperty = Replace(Replace(Replace(Replace(sNameOrHTMLIDProperty, "(", "\("), ")", "\)"), "?", "\?"), "$", "\$")
	
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "Link"
		oAppObj("text").Value = sNameOrHTMLIDProperty
		oAppObj("index").Value = iIndex
	
		' Verification of the object. 
		If Browser(oAppBrowser).Link(oAppObj).Exist(1) Then
			bFound = True
		Else ' Check using the HTML ID Property
			oAppObj.Remove "text" ' Remove TEXT Property
			oAppObj("html id").Value = sNameOrHTMLIDProperty ' Add HTML ID Property
			If Browser(oAppBrowser).Link(oAppObj).Exist(1) Then
				bFound = True
			Else ' Not Found
				bFound = False
			End If
		End If
		
		' Object Found click it if enabled
		If bFound Then
			
			' Check to see if the Link is enabled
	  	iDisabled = Browser(oAppBrowser).Link(oAppObj).GetROProperty("disabled")
	  	
			If iDisabled = 1 Then
				Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' Link", "The '" & sNameOrHTMLIDProperty & "' Link is disabled"
				linkClickerWIndex = False ' Return Value
			Else ' Link Enabled
				Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' Link", "The '" & sNameOrHTMLIDProperty & "' Link is enabled"
				
				' Click the Link
				Browser(oAppBrowser).Link(oAppObj).Click
				linkClickerWIndex = True ' Return Value
				
			End If		
			
		Else ' Object Not Found
			linkClickerWIndex = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "linkClickerWIndex", "Function End"
		Services.EndTransaction "linkClickerWIndex" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>imageFinder</@name>
	'
	' <@purpose>
	'   To verify that the Image exists on current visible browser page
	'   Will check using the Name Property value first then use the file name Property
	'   If not found by the Name Property, then use the HTML ID if not found by file name
	' </@purpose>
	'
	' <@parameters>
	'        sNameOrHTMLIDProperty (ByVal) = String - Name or HTML ID of the image to be verified
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'            True -  If found
	'            False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	'   If the image is not found by the name property it will 
	'   check for the image based on the file name property
	' </@assumptions>
	'
	' <@example_usage>
	'   of.imageFinder("Modifier Crosswalk_99211")
	'   of.imageFinder("ico_modifiers.gif")
	' </@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>07-27-2006</@creation_date>
	'
	' <@mod_block>
	'   10-03-2006 - MM - Added additional logic to verify if the image is broken (i.e. red x icon)
	'   11-14-2006 - MM - Changed the order to check for the filename property after the name and then do the
	'                     other checks if it is not found as the filename (speed up test using the filename)
	'   12-14-2006 - MM - Changed the logic to use attribute/name property instead of name and removed
	'                     all other workaround logic until Mercury QTP can get bug 1-539543563 fixed
	'   02-28-2007 - MM - Added name of function to error messages where invalid parameters are passed   
	'   10-22-2007 - MM - Added Transaction Timer Command
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the HTML ID property
	'                     if not found by the NAME or FILENAME Property
	' </@mod_block>
	' 
	'**********************************************************************************************
	'</@comments>
	Public Function imageFinder(ByVal sNameOrHTMLIDProperty) ' <@as> Boolean
	
		Services.StartTransaction "imageFinder" ' Timer Begin
	  Reporter.ReportEvent micDone, "imageFinder", "Function Begin"
	
	  ' Variable Declaration / Initialization   
	  Dim oAppBrowser, oAppObj
	  Dim bFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sNameOrHTMLIDProperty) or sNameOrHTMLIDProperty = "" Then
	    Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the imageFinder function check passed parameters"
	    imageFinder = False ' Return Value
	    Services.EndTransaction "imageFinder" ' Timer End
	    Exit Function
	  End If
	
	  ' Description Object Declarations/Initializations
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
	  Set oAppObj = Description.Create()
	  oAppObj("micclass").Value = "Image"
	  oAppObj("attribute/name").Value = sNameOrHTMLIDProperty
	
	  ' Verification of the Object 
	  If Browser(oAppBrowser).Image(oAppObj).Exist(1) Then ' Check for image based on name
	  	bFound = True
	  Else ' Try using the filename property
	  	oAppObj.Remove "attribute/name" ' Remove name property
	  	oAppObj("file name").Value = sNameOrHTMLIDProperty ' Add File Name Property
	  	If Browser(oAppBrowser).Image(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Try using the html id property
	  		oAppObj.Remove "file name" ' Remove file name property
	  		oAppObj("html id").Value = sNameOrHTMLIDProperty ' Add HTML ID Property
	  		If Browser(oAppBrowser).Image(oAppObj).Exist(1) Then
	  			bFound = True
	  		Else ' Not Found
	  			bFound = False
	  		End If
	  	End If
	  End If
	  	
	  ' Check that the image is not broken if found
	  If bFound Then
	  	If Browser(oAppBrowser).Image(oAppObj).Object.complete Then ' Check that the image is not broken
	  		imageFinder = True ' Return Value
	  	Else ' Image found but is broken
	  		imageFinder = False ' Return Value
	  	End If
	  Else ' Image not Found
			imageFinder = False ' Return Value
		End If
	   
	  ' Clear Object Variables
	  Set oAppBrowser = Nothing
	  Set oAppObj = Nothing
	   
	  Reporter.ReportEvent micDone, "imageFinder", "Function End"
	  Services.EndTransaction "imageFinder" ' Timer End
	   
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>imageFinderWIndex</@name>
	'
	' <@purpose>
	'   To verify that the Image exists on current visible browser page using the index property
	'   Will check using the Name Property value first then use the file name Property
	'   If not found by the Name Property, then use the HTML ID if not found by file name
	' </@purpose>
	'
	' <@parameters>
	'        sNameOrHTMLIDProperty (ByVal) = String - Name or HTML ID of the image to be verified
	'        iIndex (ByVal) = Integer - Index Property Value for Image to be verified
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'            True -  If found
	'            False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	'   If the image is not found by the name property it will 
	'   check for the image based on the file name property
	' </@assumptions>
	'
	' <@example_usage>of.imageFinderWIndex("ico_modifiers.gif", 0)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>01-11-2007</@creation_date>
	'
	' <@mod_block>
	'   02-28-2007 - MM - Added name of function to error messages where invalid parameters are passed
	'   10-22-2007 - MM - Added Transaction Timer Command   
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the HTML ID property
	'                     if not found by the NAME or FILENAME Property
	' </@mod_block>
	'               
	'**********************************************************************************************
	'</@comments>
	Public Function imageFinderWIndex(ByVal sNameOrHTMLIDProperty, ByVal iIndex) ' <@as> Boolean
	
	  Services.StartTransaction "imageFinderWIndex" ' Timer Begin
	  Reporter.ReportEvent micDone, "imageFinderWIndex", "Function Begin"
	
	  ' Variable Declaration / Initialization   
	  Dim oAppBrowser, oAppObj
	  Dim bFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sNameOrHTMLIDProperty) or sNameOrHTMLIDProperty = "" or IsNull(iIndex) or iIndex = "" Then
	    Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the imageFinderWIndex function check passed parameters"
	    imageFinderWIndex = False ' Return Value
	    Services.EndTransaction "imageFinderWIndex" ' Timer End
	    Exit Function
	  End If
	
	  ' Description Object Declarations/Initializations
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
	  Set oAppObj = Description.Create()
	  oAppObj("micclass").Value = "Image"
	  oAppObj("attribute/name").Value = sNameOrHTMLIDProperty
	  oAppObj("index").Value = iIndex
	
	  ' Verification of the Object 
	  If Browser(oAppBrowser).Image(oAppObj).Exist(1) Then ' Check for image based on name
	  	bFound = True
	  Else ' Try using the filename property
	  	oAppObj.Remove "attribute/name" ' Remove name property
	  	oAppObj("file name").Value = sNameOrHTMLIDProperty ' Add File Name Property
	  	If Browser(oAppBrowser).Image(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Try using the html id property
	  		oAppObj.Remove "file name" ' Remove file name property
	  		oAppObj("html id").Value = sNameOrHTMLIDProperty ' Add HTML ID Property
	  		If Browser(oAppBrowser).Image(oAppObj).Exist(1) Then
	  			bFound = True
	  		Else ' Not Found
	  			bFound = False
	  		End If
	  	End If
	  End If
	  	
	  ' Check that the image is not broken if found
	  If bFound Then
	  	If Browser(oAppBrowser).Image(oAppObj).Object.complete Then ' Check that the image is not broken
	  		imageFinderWIndex = True ' Return Value
	  	Else ' Image found but is broken
	  		imageFinderWIndex = False ' Return Value
	  	End If
	  Else ' Image not Found
			imageFinderWIndex = False ' Return Value
		End If
	   
	  ' Clear Object Variables
	  Set oAppBrowser = Nothing
	  Set oAppObj = Nothing
	
	  Reporter.ReportEvent micDone, "imageFinderWIndex", "Function End"
	  Services.EndTransaction "imageFinderWIndex" ' Timer End
	   
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>imageClicker</@name>
	'
	' <@purpose>
	'   verifies that the image exists on current visible browser page and if so,
	'		is clicked.
	'   Will check using the Name Property value first then use the file name Property
	'   If not found by the Name Property, then use the HTML ID if not found by file name
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - file name or HTML ID of the image to be verified and clicked
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            	true -  if found
	'            	false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.imageClicker("create-new-claim-down.jpg")</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>09-25-2007</@creation_date>
	'
	' <@mod_block>
	'   10-22-2007 - MM - Added Transaction Timer Command
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the HTML ID property
	'                     if not found by the FILENAME Property
	'                     Added logic to verify the IMAGE is enabled
	'                     Added Transaction Timer to the click functionality
	'   08-19-2008 - MM - Removed the Transaction Timers and waitProperty logic after clicking the
	'                     Image.
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function imageClicker(ByVal sNameOrHTMLIDProperty) ' <@as> Boolean
	
		Services.StartTransaction "imageClicker" ' Timer Begin
		Reporter.ReportEvent micDone, "imageClicker", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj, iDisabled
		Dim bFound
	
		'check to verify passed parameters that they are not null or an empty string.
		If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Then
			Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the imageClicker function check passed parameters"
			imageClicker = False ' Return Value
			Services.EndTransaction "imageClicker" ' Timer End
			Exit Function
		End If
	
		'object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "Image"
	  oAppObj("attribute/name").Value = sNameOrHTMLIDProperty
	
	  ' Verification of the Object 
	  If Browser(oAppBrowser).Image(oAppObj).Exist(1) Then ' Check for image based on name
	  	bFound = True
	  Else ' Try using the filename property
	  	oAppObj.Remove "attribute/name" ' Remove name property
	  	oAppObj("file name").Value = sNameOrHTMLIDProperty ' Add File Name Property
	  	If Browser(oAppBrowser).Image(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Try using the html id property
	  		oAppObj.Remove "file name" ' Remove file name property
	  		oAppObj("html id").Value = sNameOrHTMLIDProperty ' Add HTML ID Property
	  		If Browser(oAppBrowser).Image(oAppObj).Exist(1) Then
	  			bFound = True
	  		Else ' Not Found
	  			bFound = False
	  		End If
	  	End If
	  End If
		
	  ' Check that the image is not broken if found
	  If bFound Then
	  	If Browser(oAppBrowser).Image(oAppObj).Object.complete Then ' Check that the image is not broken
	  		Reporter.ReportEvent micPass, sNameOrHTMLIDProperty & " Image", "The " & sNameOrHTMLIDProperty & " image was found and was not broken"
	  		
				' Check to see if the Image is enabled
		  	iDisabled = Browser(oAppBrowser).Image(oAppObj).GetROProperty("disabled")
		  	
				If iDisabled = 1 Then
					Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' Image", "The '" & sNameOrHTMLIDProperty & "' Image is disabled"
					imageClicker = False ' Return Value
				Else ' Image Enabled
					Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' Image", "The '" & sNameOrHTMLIDProperty & "' Image is enabled"
					
					' Click the Image
					Browser(oAppBrowser).Image(oAppObj).Click
					imageClicker = True ' Return Value
					
				End If
	  		
	  	Else ' Image found but is broken
	  		Reporter.ReportEvent micFail, sNameOrHTMLIDProperty & " Image", "The " & sNameOrHTMLIDProperty & " image was found and was broken"
	  		imageClicker = False ' Return Value
	  	End If
	  Else ' Image not Found
			imageClicker = False ' Return Value
		End If
	
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "imageClicker", "Function End"
		Services.EndTransaction "imageClicker" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>imageClickerWIndex</@name>
	'
	' <@purpose>
	'   verifies that the image exists on current visible browser page using the index property, and if so,
	'		is clicked.
	'   Will check using the Name Property value first then use the file name Property
	'   If not found by the Name Property, then use the HTML ID if not found by file name
	' </@purpose>
	'
	' <@parameters>
	'        sNameOrHTMLIDProperty (ByVal) = String - File name or HTML ID of the image to be verified and clicked
	'        iIndex (ByVal) = Integer - Index Property Value for Image to be verified and clicked
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            	true -  if found
	'            	false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.imageClickerWIndex("create-new-claim-down.jpg", 1)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>09-25-2007</@creation_date>
	'
	' <@mod_block>
	'   10-22-2007 - MM - Added Transaction Timer Command
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the HTML ID property
	'                     if not found by the FILENAME Property
	'                     Added logic to verify the IMAGE is enabled
	'                     Added Transaction Timer to the click functionality
	'   08-19-2008 - MM - Removed the Transaction Timers and waitProperty logic after clicking the
	'                     Image.
	'
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function imageClickerWIndex(ByVal sNameOrHTMLIDProperty, ByVal iIndex) ' <@as> Boolean
	
		Services.StartTransaction "imageClickerWIndex" ' Timer Begin
		Reporter.ReportEvent micDone, "imageClickerWIndex", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj, iDisabled
		Dim bFound
	
	   ' Check to verify passed parameters that they are not null or an empty string
	   If IsNull(sNameOrHTMLIDProperty) or sNameOrHTMLIDProperty = "" or IsNull(iIndex) or iIndex = "" Then
	           Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the imageClickerWIndex function check passed parameters"
	           imageClickerWIndex = False ' Return Value
	           Services.EndTransaction "imageClickerWIndex" ' Timer End
	           Exit Function
	   End If
	
		'object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "Image"
	  oAppObj("attribute/name").Value = sNameOrHTMLIDProperty
	  oAppObj("index").Value = iIndex
	
	  ' Verification of the Object 
	  If Browser(oAppBrowser).Image(oAppObj).Exist(1) Then ' Check for image based on name
	  	bFound = True
	  Else ' Try using the filename property
	  	oAppObj.Remove "attribute/name" ' Remove name property
	  	oAppObj("file name").Value = sNameOrHTMLIDProperty ' Add File Name Property
	  	If Browser(oAppBrowser).Image(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Try using the html id property
	  		oAppObj.Remove "file name" ' Remove file name property
	  		oAppObj("html id").Value = sNameOrHTMLIDProperty ' Add HTML ID Property
	  		If Browser(oAppBrowser).Image(oAppObj).Exist(1) Then
	  			bFound = True
	  		Else ' Not Found
	  			bFound = False
	  		End If
	  	End If
	  End If
		
	  ' Check that the image is not broken if found
	  If bFound Then
	  	If Browser(oAppBrowser).Image(oAppObj).Object.complete Then ' Check that the image is not broken
	  		Reporter.ReportEvent micPass, sNameOrHTMLIDProperty & " Image", "The " & sNameOrHTMLIDProperty & " image was found and was not broken"
	  		
				' Check to see if the Image is enabled
		  	iDisabled = Browser(oAppBrowser).Image(oAppObj).GetROProperty("disabled")
		  	
				If iDisabled = 1 Then
					Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' Image", "The '" & sNameOrHTMLIDProperty & "' Image is disabled"
					imageClickerWIndex = False ' Return Value
				Else ' Image Enabled
					Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' Image", "The '" & sNameOrHTMLIDProperty & "' Image is enabled"
					
					' Click the Image
					Browser(oAppBrowser).Image(oAppObj).Click
					imageClickerWIndex = True ' Return Value
					
				End If
	  		
	  	Else ' Image found but is broken
	  		Reporter.ReportEvent micFail, sNameOrHTMLIDProperty & " Image", "The " & sNameOrHTMLIDProperty & " image was found and was broken"
	  		imageClickerWIndex = False ' Return Value
	  	End If
	  Else ' Image not Found
			imageClickerWIndex = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "imageClickerWIndex", "Function End"
		Services.EndTransaction "imageClickerWIndex" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>checkBoxFinder</@name>
	'
	' <@purpose>
	'   verifies that the checkbox object exists on the current visible browser page
	'   Will check using the HTML ID Property value first then use the Name Property
	'   If not found by the HTML ID Property  
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - Name or HTML ID of the checkbox to be verified
	' </@parameters>
	'
	' <@return>
	'   String
	'				"-1" - if not found or the passed parameter is invalid	
	'				"0" - if found and the checkbox is not checked
	'				"1" - if found and the checkbox is checked
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.checkBoxFinder("cbStatusList_2")</@example_usage>
	'
	' <@author>craig cardall</@author>
	'
	' <@creation_date>02-28-07</@creation_date>
	'
	' <@mod_block>
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the NAME property
	'                     if not found by the HTML ID Property
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function checkBoxFinder(ByVal sNameOrHTMLIDProperty) ' <@as> String
	
	 	Services.StartTransaction "checkBoxFinder" ' Timer Begin
		Reporter.ReportEvent micDone, "checkBoxFinder", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj
		Dim bFound
	
		'checks to verify that the passed parameter is not null or an empty string.
		'returns a "-1" if the parameter is invalid.
		If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Then
			Reporter.ReportEvent micFail, "invalid parameter", "an invalid parameter was passed to the checkBoxFinder function check passed parameters"
			checkBoxFinder = "-1" ' Return Value
			Services.EndTransaction "checkBoxFinder" ' Timer End
			Exit Function
		End If
	
		'description object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebCheckBox"
		oAppObj("html id").Value = sNameOrHTMLIDProperty
		
		' Verification of the Object
		If Browser(oAppBrowser).WebCheckBox(oAppObj).Exist(1) Then
			bFound = True
		Else ' Check using NAME Property
			oAppObj.Remove "html id" ' Remove HTML ID Property
			oAppObj("name").Value = sNameOrHTMLIDProperty ' Add the NAME Property
			If Browser(oAppBrowser).WebCheckBox(oAppObj).Exist(1) Then
				bFound = True
			Else ' Not Found
				bFound = False
			End If
		End If
		
		If bFound Then
			checkBoxFinder = Browser(oAppBrowser).WebCheckBox(oAppObj).GetROProperty("checked") ' Return Value
		Else ' Object Not Found
			checkBoxFinder = -1 ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
	
		Reporter.ReportEvent micDone, "checkBoxFinder", "Function End"
		Services.EndTransaction "checkBoxFinder" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>checkBoxFinderWIndex</@name>
	'
	' <@purpose>
	'   verifies that the checkbox object exists on the current visible browser page using the index property
	'   Will check using the HTML ID Property value first then use the Name Property
	'   If not found by the HTML ID Property  
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - Name or HTML ID of the checkbox to be verified
	'   iIndex (ByVal) = Integer - Index Property Value for checkbox
	' </@parameters>
	'
	' <@return>
	'   String
	'				"-1" - if not found or the passed parameter is invalid	
	'				"0" - if found and the checkbox is not checked
	'				"1" - if found and the checkbox is checked
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.checkBoxFinderWIndex("cbStatusList_2", 0)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>05-12-2008</@creation_date>
	'
	' <@mod_block>
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function checkBoxFinderWIndex(ByVal sNameOrHTMLIDProperty, ByVal iIndex) ' <@as> String
	
	 	Services.StartTransaction "checkBoxFinderWIndex" ' Timer Begin
		Reporter.ReportEvent micDone, "checkBoxFinderWIndex", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj
		Dim bFound
	
		'checks to verify that the passed parameter is not null or an empty string.
		'returns a "-1" if the parameter is invalid.
		If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Or IsNull(iIndex) Or iIndex = "" Then
			Reporter.ReportEvent micFail, "invalid parameter", "an invalid parameter was passed to the checkBoxFinderWIndex function check passed parameters"
			checkBoxFinderWIndex = "-1" ' Return Value
			Services.EndTransaction "checkBoxFinderWIndex" ' Timer End
			Exit Function
		End If
	
		'description object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebCheckBox"
		oAppObj("html id").Value = sNameOrHTMLIDProperty
		oAppObj("index").Value = iIndex
		
		' Verification of the Object
		If Browser(oAppBrowser).WebCheckBox(oAppObj).Exist(1) Then
			bFound = True
		Else ' Check using NAME Property
			oAppObj.Remove "html id" ' Remove HTML ID Property
			oAppObj("name").Value = sNameOrHTMLIDProperty ' Add the NAME Property
			If Browser(oAppBrowser).WebCheckBox(oAppObj).Exist(1) Then
				bFound = True
			Else ' Not Found
				bFound = False
			End If
		End If
		
		If bFound Then
			checkBoxFinderWIndex = Browser(oAppBrowser).WebCheckBox(oAppObj).GetROProperty("checked") ' Return Value
		Else ' Object Not Found
			checkBoxFinderWIndex = -1 ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
	
		Reporter.ReportEvent micDone, "checkBoxFinderWIndex", "Function End"
		Services.EndTransaction "checkBoxFinderWIndex" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>checkBoxChecker</@name>
	'
	' <@purpose>
	'   changes the "checked" state of the checkbox object to either "Off" or "On"
	'   Will check using the HTML ID Property value first then use the Name Property
	'   If not found by the HTML ID Property
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - Name or HTML ID of the checkbox to be checked/unchecked
	'   sCheckState (ByVal) = string - state of the checkbox ("Off" or "On")
	' </@parameters>
	'								   
	' <@return>
	'   boolean value
	'				false - if not found or the passed parameters are invalid	
	'				true - if found
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.checkBoxChecker("cbStatusList_2","Off")</@example_usage>
	'
	' <@author>craig cardall</@author>
	'
	' <@creation_date>02-28-07</@creation_date>
	'
	' <@mod_block>
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the NAME property
	'                     if not found by the HTML ID Property
	'                     Added logic to verify the checkbox state after it is set
	' </@mod_block>
	'                     
	'**********************************************************************************************
	'</@comments>
	Public Function checkBoxChecker(ByVal sNameOrHTMLIDProperty, ByVal sCheckState) ' <@as> Boolean
	
		Services.StartTransaction "checkBoxChecker" ' Timer Begin
		Reporter.ReportEvent micDone, "checkBoxChecker", "Function Begin"
	
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj, iDisabled, iCheckedVal
		Dim bFound
	
		'checks to verify that the passed parameters are not null or empty strings.
		'returns false if the parameters are invalid.
		If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Or IsNull(sCheckState) Or sCheckState = "" Then
			Reporter.ReportEvent micFail, "invalid parameters", "invalid parameters were passed to the checkBoxChecker function."
			checkBoxChecker = False
			Services.EndTransaction "checkBoxChecker" ' Timer End
			Exit Function
		End If
		
		'description object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebCheckBox"
		oAppObj("html id").Value = sNameOrHTMLIDProperty
		
		' Verification of Object
		If Browser(oAppBrowser).WebCheckBox(oAppObj).Exist(1) Then
			bFound = True
		Else ' Check using the name property
			oAppObj.Remove "html id" ' Remove HTML ID Property
			oAppObj("name").Value = sNameOrHTMLIDProperty ' Add the name property
			If Browser(oAppBrowser).WebCheckBox(oAppObj).Exist(1) Then
				bFound = True
			Else ' Not Found
				bFound = False
			End If
		End If
		
		' Verify the Object is enabled if found
		If bFound Then
			
			' Get the disabled property
			iDisabled = Browser(oAppBrowser).WebCheckBox(oAppObj).GetROProperty("disabled")
			
			If iDisabled = 1 Then
				Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' checkbox", "The '" & sNameOrHTMLIDProperty & "' checkbox is disabled"
				checkBoxChecker = False ' Return Value
			Else ' Checkbox is enabled
				Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' checkbox", "The '" & sNameOrHTMLIDProperty & "' checkbox is enabled"
				
				' Changes the "checked" state of the checkbox, based on the parameter
				Browser(oAppBrowser).WebCheckBox(oAppObj).Set sCheckState
				
				' Verify checkbox was set correctly
				Select Case LCase(sCheckState)
					Case "on"
						iCheckedVal = 1
					Case "off"
						iCheckedVal = 0
					Case Else
						Reporter.ReportEvent micFail, "Invalid Parameter", "No Select Case Found for sCheckState Parameter Value '" & sCheckState & "' in checkBoxChecker function check passed parameter"
						checkBoxChecker = False ' Return Value
						Services.EndTransaction "checkBoxChecker" ' Timer End
						Exit Function
				End Select
				
				' Get the value from the checkbox and compare with iCheckedVal (sCheckState) value
				If Browser(oAppBrowser).WebCheckBox(oAppObj).GetROProperty("checked") = iCheckedVal Then
					checkBoxChecker = True ' Return Value
				Else ' Checkbox does not match desired state
					checkBoxChecker = False ' Return Value
				End If
			End If
		Else ' Not Found
			checkBoxChecker = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "checkBoxChecker", "Function End"
		Services.EndTransaction "checkBoxChecker" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>checkBoxCheckerWIndex</@name>
	'
	' <@purpose>
	'   changes the "checked" state of the checkbox object using the index property, to either "Off" or "On"
	'   Will check using the HTML ID Property value first then use the Name Property
	'   If not found by the HTML ID Property
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - Name or HTML ID of the checkbox to be checked/unchecked
	'		sCheckState = string - state of the checkbox ("Off" or "On")
	'   iIndex (ByVal) = Integer - Index Property Value for checkbox
	' </@parameters>
	'								   
	' <@return>
	'   boolean value
	'				false - if not found or the passed parameters are invalid	
	'				true - if found
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.checkBoxCheckerWIndex("cbStatusList_2","Off", 0)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>05-12-2008</@creation_date>
	'
	' <@mod_block>
	' </@mod_block>	
	'                     
	'**********************************************************************************************
	'</@comments>
	Public Function checkBoxCheckerWIndex(ByVal sNameOrHTMLIDProperty, ByVal sCheckState, ByVal iIndex) ' <@as> Boolean
	
		Services.StartTransaction "checkBoxCheckerWIndex" ' Timer Begin
		Reporter.ReportEvent micDone, "checkBoxCheckerWIndex", "Function Begin"
	
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj, iDisabled, iCheckedVal
		Dim bFound
	
		'checks to verify that the passed parameters are not null or empty strings.
		'returns false if the parameters are invalid.
		If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Or IsNull(sCheckState) Or sCheckState = "" Or IsNull(iIndex) Or iIndex = "" Then
			Reporter.ReportEvent micFail, "invalid parameters", "invalid parameters were passed to the checkBoxCheckerWIndex function, check passed parameters"
			checkBoxCheckerWIndex = False
			Services.EndTransaction "checkBoxCheckerWIndex" ' Timer End
			Exit Function
		End If
		
		'description object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebCheckBox"
		oAppObj("html id").Value = sNameOrHTMLIDProperty
		oAppObj("index").Value = iIndex
		
		' Verification of Object
		If Browser(oAppBrowser).WebCheckBox(oAppObj).Exist(1) Then
			bFound = True
		Else ' Check using the name property
			oAppObj.Remove "html id" ' Remove HTML ID Property
			oAppObj("name").Value = sNameOrHTMLIDProperty ' Add the name property
			If Browser(oAppBrowser).WebCheckBox(oAppObj).Exist(1) Then
				bFound = True
			Else ' Not Found
				bFound = False
			End If
		End If
		
		' Verify the Object is enabled if found
		If bFound Then
			
			' Get the disabled property
			iDisabled = Browser(oAppBrowser).WebCheckBox(oAppObj).GetROProperty("disabled")
			
			If iDisabled = 1 Then
				Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' checkbox", "The '" & sNameOrHTMLIDProperty & "' checkbox is disabled"
				checkBoxCheckerWIndex = False ' Return Value
			Else ' Checkbox is enabled
				Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' checkbox", "The '" & sNameOrHTMLIDProperty & "' checkbox is enabled"
				
				' Changes the "checked" state of the checkbox, based on the parameter
				Browser(oAppBrowser).WebCheckBox(oAppObj).Set sCheckState
				
				' Verify checkbox was set correctly
				Select Case LCase(sCheckState)
					Case "on"
						iCheckedVal = 1
					Case "off"
						iCheckedVal = 0
					Case Else
						Reporter.ReportEvent micFail, "Invalid Parameter", "No Select Case Found for sCheckState Parameter Value '" & sCheckState & "' in checkBoxCheckerWIndex function check passed parameter"
						checkBoxCheckerWIndex = False ' Return Value
						Services.EndTransaction "checkBoxCheckerWIndex" ' Timer End
						Exit Function
				End Select
				
				' Get the value from the checkbox and compare with iCheckedVal (sCheckState) value
				If Browser(oAppBrowser).WebCheckBox(oAppObj).GetROProperty("checked") = iCheckedVal Then
					checkBoxCheckerWIndex = True ' Return Value
				Else ' Checkbox does not match desired state
					checkBoxCheckerWIndex = False ' Return Value
				End If
			End If
		Else ' Not Found
			checkBoxCheckerWIndex = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "checkBoxCheckerWIndex", "Function End"
		Services.EndTransaction "checkBoxCheckerWIndex" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webListFinder</@name>
	'
	' <@purpose>
	'   To verify that the webList exists on current visible browser page.
	'   Will check using the HTML ID Property value first then use the Name Property
	'   If not found by the HTML ID Property
	' </@purpose>
	'
	' <@parameters>
	'        sNameOrHTMLIDProperty (ByVal) = String - Name or HTML ID of the webList to be verified
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'            True -  If found
	'            False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webListFinder("drpSelectView")</@example_usage>
	'
	' <@author>Kevin Webb</@author>
	'
	' <@creation_date>07-11-2007</@creation_date>
	'
	' <@mod_block>
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the NAME property
	'                     if not found by the HTML ID Property
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webListFinder(ByVal sNameOrHTMLIDProperty) ' <@as> Boolean
	
		Services.StartTransaction "webListFinder" ' Timer Begin
		Reporter.ReportEvent micDone, "webListFinder", "Function Begin"
		
		' Variable Declaration / Initialization
	  Dim oAppBrowser, oAppObj
	  Dim bFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sNameOrHTMLIDProperty) or sNameOrHTMLIDProperty = "" Then
	    Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the webListFinder function check passed parameters"
	    webListFinder = False ' Return Value
	    Services.EndTransaction "webListFinder" ' Timer End
	    Exit Function
	  End If
	  
	  ' Description Object Declarations/Initializations
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	  
	  Set oAppObj = Description.Create()
	  oAppObj("micclass").Value = "WebList"
	  oAppObj("html id").Value = sNameOrHTMLIDProperty
	  
	  ' Verification of the Object 
	  If Browser(oAppBrowser).WebList(oAppObj).Exist(1) Then
	  	bFound = True
	  Else ' Check using the name property
	  	oAppObj.Remove "html id" ' Remove HTML ID Property
	  	oAppObj("name").Value = sNameOrHTMLIDProperty
	  	If Browser(oAppBrowser).WebList(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Not Found
	  		bFound = False
	  	End If
	  End If
	
	  If bFound Then
	  	webListFinder = True ' Return Value
	  Else ' Not Found
	  	webListFinder = False ' Return Value
	  End If
	
	  ' Clear Object Variables
	  Set oAppBrowser = Nothing
	  Set oAppObj = Nothing
	  
		Reporter.ReportEvent micDone, "webListFinder", "Function End"
		Services.EndTransaction "webListFinder" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webListFinderWIndex</@name>
	'
	' <@purpose>
	'   To verify that the webList exists on current visible browser page using the index property
	'   Will check using the HTML ID Property value first then use the Name Property
	'   If not found by the HTML ID Property
	' </@purpose>
	'
	' <@parameters>
	'        sNameOrHTMLIDProperty (ByVal) = String - Name or HTML ID of the webList to be verified
	'        iIndex (ByVal) = Integer - Index Property Value for webList
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'            True -  If found
	'            False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webListFinderWIndex("drpSelectView", 0)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>05-12-2008</@creation_date>
	'
	' <@mod_block>
	' </@mod_block>  
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webListFinderWIndex(ByVal sNameOrHTMLIDProperty, ByVal iIndex) ' <@as> Boolean
	
		Services.StartTransaction "webListFinderWIndex" ' Timer Begin
		Reporter.ReportEvent micDone, "webListFinderWIndex", "Function Begin"
		
		' Variable Declaration / Initialization
	  Dim oAppBrowser, oAppObj
	  Dim bFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sNameOrHTMLIDProperty) or sNameOrHTMLIDProperty = "" Or IsNull(iIndex) or iIndex = "" Then
	    Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the webListFinderWIndex function check passed parameters"
	    webListFinderWIndex = False ' Return Value
	    Services.EndTransaction "webListFinderWIndex" ' Timer End
	    Exit Function
	  End If
	  
	  ' Description Object Declarations/Initializations
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	  
	  Set oAppObj = Description.Create()
	  oAppObj("micclass").Value = "WebList"
	  oAppObj("html id").Value = sNameOrHTMLIDProperty
	  oAppObj("index").Value = iIndex
	  
	  ' Verification of the Object 
	  If Browser(oAppBrowser).WebList(oAppObj).Exist(1) Then
	  	bFound = True
	  Else ' Check using the name property
	  	oAppObj.Remove "html id" ' Remove HTML ID Property
	  	oAppObj("name").Value = sNameOrHTMLIDProperty
	  	If Browser(oAppBrowser).WebList(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Not Found
	  		bFound = False
	  	End If
	  End If
	
	  If bFound Then
	  	webListFinderWIndex = True ' Return Value
	  Else ' Not Found
	  	webListFinderWIndex = False ' Return Value
	  End If
	
	  ' Clear Object Variables
	  Set oAppBrowser = Nothing
	  Set oAppObj = Nothing
	  
		Reporter.ReportEvent micDone, "webListFinderWIndex", "Function End"
		Services.EndTransaction "webListFinderWIndex" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webListSelect</@name>
	'
	' <@purpose>
	'   To verify that the webList exists on current visible browser page and if so,
	'		the sSelection paramter is selected, if the sSelection value is in the list.
	'   Will check using the HTML ID Property value first then use the Name Property
	'   If not found by the HTML ID Property  
	' </@purpose>
	'
	' <@parameters>
	'       sNameOrHTMLIDProperty (ByVal) = String - Name or HTML ID of the webList to be verified
	'				sSelection (ByVal) = String - Name of the webList selection
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'            True -  If found
	'            False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webListSelect("drpSelectView", "View Only Mine")</@example_usage>
	'
	' <@author>Kevin Webb</@author>
	'
	' <@creation_date>07-11-2007</@creation_date>
	'
	' <@mod_block>
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the NAME property
	'                     if not found by the HTML ID Property
	'                     Added logic to verify the weblist is enabled before trying
	'                     to make a selection
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webListSelect(ByVal sNameOrHTMLIDProperty, ByVal sSelection) ' <@as> Boolean
	
	  Services.StartTransaction "webListSelect" ' Timer Begin
		Reporter.ReportEvent micDone, "webListSelect", "Function Begin"
		
		' Variable Declaration / Initialization
	  Dim oAppBrowser, oAppObj, aListAllItems, sListItem, sListVal, iDisabled, bFound
	  Dim SSplitVal
	  
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Or IsNull(sSelection) Or sSelection = "" Then
	          Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the webListSelect function check passed parameters"
	          webListSelect = False ' Return Value
	          Services.EndTransaction "webListSelect" ' Timer End
	          Exit Function
	  End If

	  'Picking the appropriate data based on the Environment
	  If Instr(1, sSelection, ";") <> 0 Then
		sSplitVal = Split(sSelection, ";")
		If Environment.Value("RunEnv") = "TEST" Then
			sSelection = sSplitVal(0)
		ElseIf Environment.Value("RunEnv") = "TEST1" Then
			sSelection = sSplitVal(1)
		Else
			sSelection = sSplitVal(0)	
		End If
	  End If
	
	  ' Description Object Declarations/Initializations
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
	  Set oAppObj = Description.Create()
	  oAppObj("micclass").Value = "WebList"
	  oAppObj("html id").Value = sNameOrHTMLIDProperty
	
	  ' Verification of the Object 
	  If Browser(oAppBrowser).webList(oAppObj).Exist(1) Then
	  	bFound = True
	  Else ' Check Using the Name Property
	  	oAppObj.Remove "html id" ' Remove HTML ID Property
	  	oAppObj("name").Value = sNameOrHTMLIDProperty
	  	If Browser(oAppBrowser).webList(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Not Found
	  		bFound = False
	  	End If
	  End If
	  
	  ' If weblist found, verify it is enabled before trying to make the selection
	  If bFound Then
	  	
	  	' Check to see if the weblist is enabled
	  	iDisabled = Browser(oAppBrowser).webList(oAppObj).GetROProperty("disabled")
	  	
			If iDisabled = 1 Then
				Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' weblist", "The '" & sNameOrHTMLIDProperty & "' weblist is disabled"
				webListSelect = False ' Return Value
				
			Else ' WebList Enabled
				Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' weblist", "The '" & sNameOrHTMLIDProperty & "' weblist is enabled"
	  	
		  	' Get all items property value from WebList to verify that sSelection is in the list before trying to select it
		  	aListAllItems = Split(Browser(oAppBrowser).WebList(oAppObj).GetROProperty("all items"), ";")
		  	
		  	' Loop through aListAllItems array to Verify sSelection is in the list
		  	For each sListItem in aListAllItems
		  		If StrComp(LCase(sListItem), LCase(sSelection), 1) = 0 Then ' sSelection String found, select it
		  			bFound = True
		  			Exit For
		  		Else ' Not Found
		  			bFound = False
		  		End If
		  	Next
		  		
		    ' sSelection String found, select it
		  	If bFound Then
		  		Reporter.ReportEvent micPass, "WebList Selection", "The value '" & sSelection & "' was found in the '" & sNameOrHTMLIDProperty & "' WebList List"
		  			
		  		' Select the Value (sListItem which equals the sSelection Parameter) and verify that it was made
		  		Browser(oAppBrowser).WebList(oAppObj).Select sListItem 			
		  			
		  		'Get value property value from WebList to verify that sSelection was selected
				Wait(5)
		  		sListVal = LCase(Browser(oAppBrowser).WebList(oAppObj).GetROProperty("value"))
		  			
		  		'Verify the sSelection was actually chosen
		  		If StrComp(sListVal, LCase(sSelection), 1) = 0 Then ' If sSelection value was chosen
		  			Reporter.ReportEvent micPass, "WebList Selection", "The value '" & sSelection & "' was chosen in the '" & sNameOrHTMLIDProperty & "' WebList List"
		  			webListSelect = True ' Return Value
		  		Else ' sSelection value was not chosen
		  			Reporter.ReportEvent micFail, "WebList Selection", "The value '" & sSelection & "' was not chosen in the '" & sNameOrHTMLIDProperty & "' WebList List"
		  			webListSelect = False ' Return Value
		  		End If
		
		  	Else ' sSelection not found
		  		Reporter.ReportEvent micFail, "WebList Selection", "The value '" & sSelection & "' was not found in the '" & sNameOrHTMLIDProperty & "' WebList List"
		  		webListSelect = False ' Return Value
		  	End If
		  End If
	  		
	  Else ' Object Not Found
	      webListSelect = False ' Return Value
	  End If
	  
	  ' Clear Object Variables
	  Set oAppBrowser = Nothing
	  Set oAppObj = Nothing
	  
		Reporter.ReportEvent micDone, "webListSelect", "Function End"
		Services.EndTransaction "webListSelect" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webListSelectWIndex</@name>
	'
	' <@purpose>
	'   To verify that the webList exists on current visible browser page using the index property, and if so,
	'		the sSelection paramter is selected, if the sSelection value is in the list.
	'   Will check using the HTML ID Property value first then use the Name Property
	'   If not found by the HTML ID Property  
	' </@purpose>
	'
	' <@parameters>
	'       sNameOrHTMLIDProperty (ByVal) = String - Name or HTML ID of the webList to be verified
	'				sSelection = String - Value of the webList selection to select
	'       iIndex (ByVal) = Integer - Index Property Value for webList
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'            True -  If found
	'            False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webListSelectWIndex("drpSelectView", "View Only Mine", 0)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>05-12-2008</@creation_date>
	'
	' <@mod_block>
	' </@mod_block>  
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webListSelectWIndex(ByVal sNameOrHTMLIDProperty, ByVal sSelection, ByVal iIndex) ' <@as> Boolean
	
	  Services.StartTransaction "webListSelectWIndex" ' Timer Begin
		Reporter.ReportEvent micDone, "webListSelectWIndex", "Function Begin"
		
		' Variable Declaration / Initialization
	  Dim oAppBrowser, oAppObj, aListAllItems, sListItem, sListVal, iDisabled, bFound
	  
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Or IsNull(sSelection) Or sSelection = "" Or IsNull(iIndex) or iIndex = "" Then
	    Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the webListSelectWIndex function check passed parameters"
	    webListSelectWIndex = False ' Return Value
	    Services.EndTransaction "webListSelectWIndex" ' Timer End
	    Exit Function
	  End If
	
	  ' Description Object Declarations/Initializations
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
	  Set oAppObj = Description.Create()
	  oAppObj("micclass").Value = "WebList"
	  oAppObj("html id").Value = sNameOrHTMLIDProperty
	  oAppObj("index").Value = iIndex
	
	  ' Verification of the Object 
	  If Browser(oAppBrowser).webList(oAppObj).Exist(1) Then
	  	bFound = True
	  Else ' Check Using the Name Property
	  	oAppObj.Remove "html id" ' Remove HTML ID Property
	  	oAppObj("name").Value = sNameOrHTMLIDProperty
	  	If Browser(oAppBrowser).webList(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Not Found
	  		bFound = False
	  	End If
	  End If
	  
	  ' If weblist found, verify it is enabled before trying to make the selection
	  If bFound Then
	  	
	  	' Check to see if the weblist is enabled
	  	iDisabled = Browser(oAppBrowser).webList(oAppObj).GetROProperty("disabled")
	  	
			If iDisabled = 1 Then
				Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' weblist", "The '" & sNameOrHTMLIDProperty & "' weblist is disabled"
				webListSelectWIndex = False ' Return Value
				
			Else ' WebList Enabled
				Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' weblist", "The '" & sNameOrHTMLIDProperty & "' weblist is enabled"
	  	
		  	' Get all items property value from WebList to verify that sSelection is in the list before trying to select it
		  	aListAllItems = Split(Browser(oAppBrowser).WebList(oAppObj).GetROProperty("all items"), ";")
		  	
		  	' Loop through aListAllItems array to Verify sSelection is in the list
		  	For each sListItem in aListAllItems
		  		If StrComp(LCase(sListItem), LCase(sSelection), 1) = 0 Then ' sSelection String found, select it
		  			bFound = True
		  			Exit For
		  		Else ' Not Found
		  			bFound = False
		  		End If
		  	Next
		  		
		    ' sSelection String found, select it
		  	If bFound Then
		  		Reporter.ReportEvent micPass, "WebList Selection", "The value '" & sSelection & "' was found in the '" & sNameOrHTMLIDProperty & "' WebList List"
		  			
		  		' Select the Value (sListItem which equals the sSelection Parameter) and verify that it was made
		  		Browser(oAppBrowser).WebList(oAppObj).Select sListItem 			
		  			
		  		'Get value property value from WebList to verify that sSelection was selected
		  		sListVal = LCase(Browser(oAppBrowser).WebList(oAppObj).GetROProperty("value"))
		  			
		  		'Verify the sSelection was actually chosen
		  		If StrComp(sListVal, LCase(sSelection), 1) = 0 Then ' If sSelection value was chosen
		  			Reporter.ReportEvent micPass, "WebList Selection", "The value '" & sSelection & "' was chosen in the '" & sNameOrHTMLIDProperty & "' WebList List"
		  			webListSelectWIndex = True ' Return Value
		  		Else ' sSelection value was not chosen
		  			Reporter.ReportEvent micFail, "WebList Selection", "The value '" & sSelection & "' was not chosen in the '" & sNameOrHTMLIDProperty & "' WebList List"
		  			webListSelectWIndex = False ' Return Value
		  		End If
		
		  	Else ' sSelection not found
		  		Reporter.ReportEvent micFail, "WebList Selection", "The value '" & sSelection & "' was not found in the '" & sNameOrHTMLIDProperty & "' WebList List"
		  		webListSelectWIndex = False ' Return Value
		  	End If
		  End If
	  		
	  Else ' Object Not Found
	      webListSelectWIndex = False ' Return Value
	  End If
	  
	  ' Clear Object Variables
	  Set oAppBrowser = Nothing
	  Set oAppObj = Nothing
	  
		Reporter.ReportEvent micDone, "webListSelectWIndex", "Function End"
		Services.EndTransaction "webListSelectWIndex" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webEditFinder</@name>
	'
	' <@purpose>
	'   verifies that the specified webedit is displayed on the page.
	'   Will check using the HTML ID Property value first then use the Name Property
	'   If not found by the HTML ID Property  
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - Name or HTML ID of the webedit to be searched
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            true -  if found
	'            false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webEditFinder("tbStartDate")</@example_usage>
	'
	' <@author>craig cardall</@author>
	'
	' <@creation_date>7/12/2007</@creation_date>
	'
	' <@mod_block>
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the NAME property
	'                     if not found by the HTML ID Property
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webEditFinder(ByVal sNameOrHTMLIDProperty) ' <@as> Boolean
	
	  Services.StartTransaction "webEditFinder" ' Timer Begin
		Reporter.ReportEvent micDone, "webEditFinder", "Function Begin"
		
		' Variable Declaration / Initialization
	 	Dim oAppBrowser, oAppObj
	 	Dim bFound 	
	 	
	 	'verifies that the passed parameter is not null or an empty string.
	 	If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Then
	  	Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the webEditFinder function check passed parameters"
	   	webEditFinder = False ' Return Value
	   	Services.EndTransaction "webEditFinder" ' Timer End
	   	Exit Function
	 	End If
	
		'sets the browser object.
	 	Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	   
	 	'sets the webedit object.
	 	Set oAppObj = Description.Create()
	 	oAppObj("micclass").Value = "WebEdit"
		oAppObj("html id").Value = sNameOrHTMLIDProperty
	
	 	'verifies that the webedit is displayed on the page.
		If Browser(oAppBrowser).WebEdit(oAppObj).Exist(1) Then 
			bFound = True
		Else ' Check using the NAME Property
			oAppObj.Remove "html id" ' Remove HTML ID Property
			oAppObj("name").Value = sNameOrHTMLIDProperty ' Add the NAME Property
			If Browser(oAppBrowser).WebEdit(oAppObj).Exist(1) Then 
				bFound = True
			Else ' Not Found
				bFound = False
			End If
		End If
		
		If bFound Then
			webEditFinder = True ' Return Value
		Else
			webEditFinder = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
	  
		Reporter.ReportEvent micDone, "webEditFinder", "Function End"
		Services.EndTransaction "webEditFinder" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webEditFinderWIndex</@name>
	'
	' <@purpose>
	'   verifies that the specified webedit is displayed on the page using the index property
	'   Will check using the HTML ID Property value first then use the Name Property
	'   If not found by the HTML ID Property  
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - Name or HTML ID of the webedit to be searched
	'   iIndex (ByVal) = Integer - Index Property Value for webEdit
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            true -  if found
	'            false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webEditFinderWIndex("tbStartDate", 0)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>05-12-2008</@creation_date>
	'
	' <@mod_block>
	'   08-15-2008 - MM - Corrected syntax error was still using sObjProperty instead of sNameOrHTMLIDProperty
	'                     as the variable name in the passed parameter verification
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webEditFinderWIndex(ByVal sNameOrHTMLIDProperty, ByVal iIndex) ' <@as> Boolean
	
	  Services.StartTransaction "webEditFinderWIndex" ' Timer Begin
		Reporter.ReportEvent micDone, "webEditFinderWIndex", "Function Begin"
		
		' Variable Declaration / Initialization
	 	Dim oAppBrowser, oAppObj
	 	Dim bFound   	
	 	
	 	'verifies that the passed parameter is not null or an empty string.
	 	If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Or IsNull(iIndex) or iIndex = "" Then
	  	Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the webEditFinderWIndex function check passed parameters"
	   	webEditFinderWIndex = False ' Return Value
	   	Services.EndTransaction "webEditFinderWIndex" ' Timer End
	   	Exit Function
	 	End If
	
		'sets the browser object.
	 	Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	   
	 	'sets the webedit object.
	 	Set oAppObj = Description.Create()
	 	oAppObj("micclass").Value = "WebEdit"
		oAppObj("html id").Value = sNameOrHTMLIDProperty
		oAppObj("index").Value = iIndex
	
	 	'verifies that the webedit is displayed on the page.
		If Browser(oAppBrowser).WebEdit(oAppObj).Exist(1) Then 
			bFound = True
		Else ' Check using the NAME Property
			oAppObj.Remove "html id" ' Remove HTML ID Property
			oAppObj("name").Value = sNameOrHTMLIDProperty ' Add the NAME Property
			If Browser(oAppBrowser).WebEdit(oAppObj).Exist(1) Then 
				bFound = True
			Else ' Not Found
				bFound = False
			End If
		End If
		
		If bFound Then
			webEditFinderWIndex = True ' Return Value
		Else
			webEditFinderWIndex = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
	  
		Reporter.ReportEvent micDone, "webEditFinderWIndex", "Function End"
		Services.EndTransaction "webEditFinderWIndex" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webEditEnter</@name>
	'
	' <@purpose>
	'   verifies that the specified webedit is displayed on the page and if so,
	'		the string parameter is entered.
	'   Will check using the HTML ID Property value first then use the Name Property
	'   If not found by the HTML ID Property  
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - Name or HTML ID of the webedit to be searched
	'		sEnterString (ByVal) = string - string to be entered in the webedit
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            true -  if found
	'            false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created 
	' </@assumptions>
	'
	' <@example_usage>of.webEditEnter("tbStartDate", "01/21/2008")</@example_usage>
	'
	' <@author>craig cardall</@author>
	'
	' <@creation_date>7/12/2007</@creation_date>
	'
	' <@mod_block>
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the NAME property
	'                     if not found by the HTML ID Property
	'                     Added logic to verify the webedit object is enabled
	'                     Added logic to verify that the webedit value after it is set
	'   08-14-2008 - MM - Removed the logic to verify sEnterString variable isNull or empty
	'
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webEditEnter(ByVal sNameOrHTMLIDProperty, ByVal sEnterString) ' <@as> Boolean
	
	  Services.StartTransaction "webEditEnter" ' Timer Begin
		Reporter.ReportEvent micDone, "webEditEnter", "Function Begin"
		
		' Variable Declaration / Initialization 
	  Dim oAppBrowser, oAppObj
	  Dim bFound, iDisabled, sEditVal, sSplitVal
	   	
	  'verifies that the passed parameter is not null or an empty string.
	  If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Then
	   	Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the webEditEnter function check passed parameters"
	   	webEditEnter = False ' Return Value
	   	Services.EndTransaction "webEditEnter" ' Timer End
	   	Exit Function
	  End If
	
	  'Picking the appropriate data based on the Environment
	  If Instr(1, sEnterString, ";") <> 0 Then
		sSplitVal = Split(sEnterString, ";")
		If Environment.Value("RunEnv") = "TEST" Then
			sEnterString = sSplitVal(0)
		ElseIf Environment.Value("RunEnv") = "TEST1" Then
			sEnterString = sSplitVal(1)
		Else
			sEnterString = sSplitVal(0)	
		End If
	  End If

		'sets the browser object.
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	   
	 	'sets the webedit object.
	 	Set oAppObj = Description.Create()
	 	oAppObj("micclass").Value = "WebEdit"
		oAppObj("html id").Value = sNameOrHTMLIDProperty
	
	  ' Verification of the Object
		If Browser(oAppBrowser).WebEdit(oAppObj).Exist(1) Then
			bFound = True
		Else ' Check using the NAME Property
			oAppObj.Remove "html id" ' Remove HTML ID Property
			oAppObj("name").Value = sNameOrHTMLIDProperty
			If Browser(oAppBrowser).WebEdit(oAppObj).Exist(1) Then
				bFound = True
			Else ' Not Found
				bFound = False
			End If
		End If
		
		' Object Found set the value if enabled
		If bFound Then
			
			' Check to see if the webedit is enabled
			iDisabled = Browser(oAppBrowser).webEdit(oAppObj).GetROProperty("disabled")
	  	
			If iDisabled = 1 Then
				Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' webedit", "The '" & sNameOrHTMLIDProperty & "' webedit is disabled"
				webEditEnter = False ' Return Value
			Else ' WebEdit Enabled
				Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' webedit", "The '" & sNameOrHTMLIDProperty & "' webedit is enabled"
				
				' Set the WebEdit
				Browser(oAppBrowser).WebEdit(oAppObj).Set sEnterString
				
				' Get the current value of the webedit object
				sEditVal = LCase(Browser(oAppBrowser).WebEdit(oAppObj).GetROProperty("value"))
				
		  	'Verify the sEnterString was set
		  	If StrComp(sEditVal, LCase(sEnterString), 1) = 0 Then ' If sEnterString value was set
		  		webEditEnter = True ' Return Value
		  	Else ' sEnterString value was not set
		  		webEditEnter = False ' Return Value
		  	End If
		  End If
	
		Else ' Object Not Found
			webEditEnter = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "webEditEnter", "Function End"
		Services.EndTransaction "webEditEnter" ' Timer End
	 
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webEditEnterWIndex</@name>
	'
	' <@purpose>
	'   verifies that the specified webedit is displayed on the page using the index property, and if so,
	'		the string parameter is entered.
	'   Will check using the HTML ID Property value first then use the Name Property
	'   If not found by the HTML ID Property  
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - Name or HTML ID of the webedit to be searched
	'		sEnterString (ByVal)= string - string to be entered in the webedit
	'   iIndex (ByVal) = Integer - Index Property Value for webEdit
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            true -  if found
	'            false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created 
	' </@assumptions>
	'
	' <@example_usage>of.webEditEnterWIndex("tbStartDate", "01/21/2008", 0)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>05-12-2008</@creation_date>
	'
	' <@mod_block>
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webEditEnterWIndex(ByVal sNameOrHTMLIDProperty, ByVal sEnterString, ByVal iIndex) ' <@as> Boolean
	
	  Services.StartTransaction "webEditEnterWIndex" ' Timer Begin
		Reporter.ReportEvent micDone, "webEditEnterWIndex", "Function Begin"
		
		' Variable Declaration / Initialization 
	  Dim oAppBrowser, oAppObj
	  Dim bFound, iDisabled, sEditVal
	   	
	  'verifies that the passed parameter is not null or an empty string.
	  If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Or IsNull(iIndex) or iIndex = "" Then
	   	Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the webEditEnterWIndex function check passed parameters"
	   	webEditEnterWIndex = False ' Return Value
	   	Services.EndTransaction "webEditEnterWIndex" ' Timer End
	   	Exit Function
	  End If
	
		'sets the browser object.
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	   
	 	'sets the webedit object.
	 	Set oAppObj = Description.Create()
	 	oAppObj("micclass").Value = "WebEdit"
		oAppObj("html id").Value = sNameOrHTMLIDProperty
		oAppObj("index").Value = iIndex
	
	  ' Verification of the Object
		If Browser(oAppBrowser).WebEdit(oAppObj).Exist(1) Then
			bFound = True
		Else ' Check using the NAME Property
			oAppObj.Remove "html id" ' Remove HTML ID Property
			oAppObj("name").Value = sNameOrHTMLIDProperty
			If Browser(oAppBrowser).WebEdit(oAppObj).Exist(1) Then
				bFound = True
			Else ' Not Found
				bFound = False
			End If
		End If
		
		' Object Found set the value if enabled
		If bFound Then
			
			' Check to see if the webedit is enabled
			iDisabled = Browser(oAppBrowser).webEdit(oAppObj).GetROProperty("disabled")
	  	
			If iDisabled = 1 Then
				Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' webedit", "The '" & sNameOrHTMLIDProperty & "' webedit is disabled"
				webEditEnterWIndex = False ' Return Value
			Else ' WebEdit Enabled
				Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' webedit", "The '" & sNameOrHTMLIDProperty & "' webedit is enabled"
				
				' Set the WebEdit
				Browser(oAppBrowser).WebEdit(oAppObj).Set sEnterString
				
				' Get the current value of the webedit object
				sEditVal = LCase(Browser(oAppBrowser).WebEdit(oAppObj).GetROProperty("value"))
				
		  	'Verify the sEnterString was set
		  	If StrComp(sEditVal, LCase(sEnterString), 1) = 0 Then ' If sEnterString value was set
		  		webEditEnterWIndex = True ' Return Value
		  	Else ' sEnterString value was not set
		  		webEditEnterWIndex = False ' Return Value
		  	End If
		  End If
	
		Else ' Object Not Found
			webEditEnterWIndex = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "webEditEnterWIndex", "Function End"
		Services.EndTransaction "webEditEnterWIndex" ' Timer End
	 
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webButtonFinder</@name>
	'
	' <@purpose>
	'   verifies that the specified webbutton is displayed on the page.
	'   Will check using the HTML ID Property value first then use the Name Property
	'   If not found by the HTML ID Property  
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - Name or HTML ID of the webbutton to be searched
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            true -  if found
	'            false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created 
	' </@assumptions>
	'
	' <@example_usage>of.webButtonFinder("Search")</@example_usage>
	'
	' <@author>craig cardall</@author>
	'
	' <@creation_date>7/12/2007</@creation_date>
	'
	' <@mod_block>
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the NAME property
	'                     if not found by the HTML ID Property
	'   09-25-2008 - MM - Added logic to escape special characters ()$?
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webButtonFinder(ByVal sNameOrHTMLIDProperty) ' <@as> Boolean
	
	 	Services.StartTransaction "webButtonFinder" ' Timer Begin
		Reporter.ReportEvent micDone, "webButtonFinder", "Function Begin"
		
		' Variable Declaration / Initialization
	 	Dim oAppBrowser, oAppObj
	 	Dim bFound
	  	
	 	'verifies that the passed parameter is not null or an empty string.
	 	If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Then
	   	Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the webButtonFinder function check passed parameters."
	   	webButtonFinder = False ' Return Value
	   	Services.EndTransaction "webButtonFinder" ' Timer End
	   	Exit Function
	 	End If
	
		'sets the browser object.
	 	Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	 	
		'adds a "\" before special characters.
	  sNameOrHTMLIDProperty = Replace(Replace(Replace(Replace(sNameOrHTMLIDProperty, "(", "\("), ")", "\)"), "?", "\?"), "$", "\$")
	   
	 	'sets the webbutton object.
	 	Set oAppObj = Description.Create()
	 	oAppObj("micclass").Value = "WebButton"
		oAppObj("html id").Value = sNameOrHTMLIDProperty
	
	 	' Verification of the Object
		If Browser(oAppBrowser).WebButton(oAppObj).Exist(1) Then 
			bFound = True
		Else ' Check using the NAME Property
			oAppObj.Remove "html id" ' Remove HTML ID Property
			oAppObj("name").Value = sNameOrHTMLIDProperty
			If Browser(oAppBrowser).WebButton(oAppObj).Exist(1) Then 
				bFound = True
			Else ' Not Found
				bFound = False
			End If
		End If
		
		If bFound Then
			webButtonFinder = True ' Return Value
		Else
			webButtonFinder = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
	
		Reporter.ReportEvent micDone, "webButtonFinder", "Function End"
		Services.EndTransaction "webButtonFinder" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webButtonFinderWIndex</@name>
	'
	' <@purpose>
	'   verifies that the specified webbutton is displayed on the page using the index property
	'   Will check using the HTML ID Property value first then use the Name Property
	'   If not found by the HTML ID Property  
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - Name or HTML ID of the webbutton to be searched
	'   iIndex (ByVal) = Integer - Index Property Value for webButton
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            true -  if found
	'            false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created 
	' </@assumptions>
	'
	' <@example_usage>of.webButtonFinderWIndex("Search", 0)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>05-12-2008</@creation_date>
	'
	' <@mod_block>
	'   09-25-2008 - MM - Added logic to escape special characters ()$?
	' </@mod_block>  
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webButtonFinderWIndex(ByVal sNameOrHTMLIDProperty, ByVal iIndex) ' <@as> Boolean
	
	 	Services.StartTransaction "webButtonFinderWIndex" ' Timer Begin
		Reporter.ReportEvent micDone, "webButtonFinderWIndex", "Function Begin"
		
		' Variable Declaration / Initialization
	 	Dim oAppBrowser, oAppObj
	 	Dim bFound
	  	
	 	'verifies that the passed parameter is not null or an empty string.
	 	If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Or IsNull(iIndex) Or iIndex = "" Then
	   	Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the webButtonFinderWIndex function check passed parameters."
	   	webButtonFinderWIndex = False ' Return Value
	   	Services.EndTransaction "webButtonFinderWIndex" ' Timer End
	   	Exit Function
	 	End If
	
		'sets the browser object.
	 	Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	 	
		'adds a "\" before special characters.
	  sNameOrHTMLIDProperty = Replace(Replace(Replace(Replace(sNameOrHTMLIDProperty, "(", "\("), ")", "\)"), "?", "\?"), "$", "\$")
	   
	 	'sets the webbutton object.
	 	Set oAppObj = Description.Create()
	 	oAppObj("micclass").Value = "WebButton"
		oAppObj("html id").Value = sNameOrHTMLIDProperty
		oAppObj("index").Value = iIndex
	
	 	' Verification of the Object
		If Browser(oAppBrowser).WebButton(oAppObj).Exist(1) Then 
			bFound = True
		Else ' Check using the NAME Property
			oAppObj.Remove "html id" ' Remove HTML ID Property
			oAppObj("name").Value = sNameOrHTMLIDProperty
			If Browser(oAppBrowser).WebButton(oAppObj).Exist(1) Then 
				bFound = True
			Else ' Not Found
				bFound = False
			End If
		End If
		
		If bFound Then
			webButtonFinderWIndex = True ' Return Value
		Else
			webButtonFinderWIndex = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
	
		Reporter.ReportEvent micDone, "webButtonFinderWIndex", "Function End"
		Services.EndTransaction "webButtonFinderWIndex" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webButtonClicker</@name>
	'
	' <@purpose>
	'   verifies that the specified webbutton is displayed on the page, and if so,
	'		is clicked.
	'   Will check using the HTML ID Property value first then use the Name Property
	'   If not found by the HTML ID Property  
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - Name or HTML ID of the webbutton to be clicked
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            true -  if found
	'            false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created 
	' </@assumptions>
	'
	' <@example_usage>of.webButtonClicker("Search")</@example_usage>
	'
	' <@author>craig cardall</@author>
	'
	' <@creation_date>7/12/2007</@creation_date>
	'
	' <@mod_block>
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the NAME property
	'                     if not found by the HTML ID Property
	'                     Added logic to verify the webbutton is enabled
	'                     Added Transaction Timer to the click functionality
	'   08-19-2008 - MM - Removed the Transaction Timers and waitProperty logic after clicking the
	'                     Button.
	'   09-25-2008 - MM - Added logic to escape special characters ()$?
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webButtonClicker(ByVal sNameOrHTMLIDProperty) ' <@as> Boolean
	
	 	Services.StartTransaction "webButtonClicker" ' Timer Begin
		Reporter.ReportEvent micDone, "webButtonClicker", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj, iDisabled
		Dim bFound
	   	
	  'verifies that the passed parameter is not null or an empty string.
	  If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Then
	   	Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the webButtonClicker function check passed parameters"
	   	webButtonClicker = False ' Return Value
	   	Services.EndTransaction "webButtonClicker" ' Timer End
	   	Exit Function
	  End If
	
		'sets the browser object.
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	  
		'adds a "\" before special characters.
	  sNameOrHTMLIDProperty = Replace(Replace(Replace(Replace(sNameOrHTMLIDProperty, "(", "\("), ")", "\)"), "?", "\?"), "$", "\$")
	  
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebButton"
		oAppObj("html id").Value = sNameOrHTMLIDProperty
	   
	 	' Verification of the Object
		If Browser(oAppBrowser).WebButton(oAppObj).Exist(1) Then 
			bFound = True
		Else ' Check using the NAME Property
			oAppObj.Remove "html id" ' Remove HTML ID Property
			oAppObj("name").Value = sNameOrHTMLIDProperty
			If Browser(oAppBrowser).WebButton(oAppObj).Exist(1) Then 
				bFound = True
			Else ' Not Found
				bFound = False
			End If
		End If
		
		' Object Found click it if enabled
		If bFound Then
			
			' Check to see if the webbutton is enabled
			iDisabled = Browser(oAppBrowser).WebButton(oAppObj).GetROProperty("disabled")
	  	
			If iDisabled = 1 Then
				Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' webButton", "The '" & sNameOrHTMLIDProperty & "' webButton is disabled"
				webButtonClicker = False ' Return Value
			Else ' webButton Enabled
				Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' webButton", "The '" & sNameOrHTMLIDProperty & "' webButton is enabled"
				
				' Click the Button
				Browser(oAppBrowser).WebButton(oAppObj).Click
				webButtonClicker = True ' Return Value
	
			End If
		
		Else ' Object Not Found
			webButtonClicker = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
	
		Reporter.ReportEvent micDone, "webButtonClicker", "Function End"
		Services.EndTransaction "webButtonClicker" ' Timer End
	 
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webButtonClickerWIndex</@name>
	'
	' <@purpose>
	'   verifies that the specified webbutton is displayed on the page using the index property, and if so,
	'		is clicked.
	'   Will check using the HTML ID Property value first then use the Name Property
	'   If not found by the HTML ID Property  
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - Name or HTML ID of the webbutton to be clicked
	'   iIndex (ByVal) = Integer - Index Property Value for WebButton to be verified and clicked
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            true -  if found
	'            false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created 
	' </@assumptions>
	'
	' <@example_usage>of.webButtonClickerWIndex("Search", 0)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>02/11/2008</@creation_date>
	'
	' <@mod_block>
	'   08-19-2008 - MM - Removed the Transaction Timers and waitProperty logic after clicking the
	'                     Button.
	'   09-25-2008 - MM - Added logic to escape special characters ()$?
	' </@mod_block>  
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webButtonClickerWIndex(ByVal sNameOrHTMLIDProperty, ByVal iIndex) ' <@as> Boolean
	
	 	Services.StartTransaction "webButtonClickerWIndex" ' Timer Begin
		Reporter.ReportEvent micDone, "webButtonClickerWIndex", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj, iDisabled
		Dim bFound
	   	
	  'verifies that the passed parameter is not null or an empty string.
	  If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Or IsNull(iIndex) Or iIndex = "" Then
	   	Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the webButtonClickerWIndex function check passed parameters"
	   	webButtonClickerWIndex = False ' Return Value
	   	Services.EndTransaction "webButtonClickerWIndex" ' Timer End
	   	Exit Function
	  End If
	
		'sets the browser object.
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	  
		'adds a "\" before special characters.
	  sNameOrHTMLIDProperty = Replace(Replace(Replace(Replace(sNameOrHTMLIDProperty, "(", "\("), ")", "\)"), "?", "\?"), "$", "\$")
	  
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebButton"
		oAppObj("html id").Value = sNameOrHTMLIDProperty
		oAppObj("index").Value = iIndex
	   
	 	' Verification of the Object
		If Browser(oAppBrowser).WebButton(oAppObj).Exist(1) Then 
			bFound = True
		Else ' Check using the NAME Property
			oAppObj.Remove "html id" ' Remove HTML ID Property
			oAppObj("name").Value = sNameOrHTMLIDProperty
			If Browser(oAppBrowser).WebButton(oAppObj).Exist(1) Then 
				bFound = True
			Else ' Not Found
				bFound = False
			End If
		End If
		
		' Object Found click it if enabled
		If bFound Then
			
			' Check to see if the webbutton is enabled
			iDisabled = Browser(oAppBrowser).WebButton(oAppObj).GetROProperty("disabled")
	  	
			If iDisabled = 1 Then
				Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' webButton", "The '" & sNameOrHTMLIDProperty & "' webButton is disabled"
				webButtonClickerWIndex = False ' Return Value
			Else ' webButton Enabled
				Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' webButton", "The '" & sNameOrHTMLIDProperty & "' webButton is enabled"
				
				' Click the Button
				Browser(oAppBrowser).WebButton(oAppObj).Click
				webButtonClickerWIndex = True ' Return Value
	
			End If
		
		Else ' Object Not Found
			webButtonClickerWIndex = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
	
		Reporter.ReportEvent micDone, "webButtonClickerWIndex", "Function End"
		Services.EndTransaction "webButtonClickerWIndex" ' Timer End
	 
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webRadioGrpFinder</@name>
	'
	' <@purpose>
	'   verifies that the WebRadioGroup object exists on the current visible browser page
	'   Will check using the NAME Property value first then use the HTML ID Property
	'   If not found by the NAME Property   
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - Name or HTML ID of the radio group to be verified
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            	true -  if found
	'            	false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webRadioGrpFinder("outFlight")</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>01-14-2008</@creation_date>
	'
	' <@mod_block>
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the HTML ID property
	'                     if not found by the NAME Property
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webRadioGrpFinder(ByVal sNameOrHTMLIDProperty) ' <@as> Boolean
	
	 	Services.StartTransaction "webRadioGrpFinder" ' Timer Begin
		Reporter.ReportEvent micDone, "webRadioGrpFinder", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj
		Dim bFound
	
		'checks to verify that the passed parameter is not null or an empty string.
		If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Then
			Reporter.ReportEvent micFail, "invalid parameter", "an invalid parameter was passed to the webRadioGrpFinder function check passed parameters"
			webRadioGrpFinder = False ' Return Value
			Services.EndTransaction "webRadioGrpFinder" ' Timer End
			Exit Function
		End If
	
		'description object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebRadioGroup"
		oAppObj("name").Value = sNameOrHTMLIDProperty
		
	  ' Verification of the Object 
	  If Browser(oAppBrowser).WebRadioGroup(oAppObj).Exist(1) Then
	  	bFound = True
	  Else ' Check using HTML ID Property
	  	oAppObj.Remove "name" ' Remove NAME Property
	  	oAppObj("html id").Value = sNameOrHTMLIDProperty
	  	If Browser(oAppBrowser).WebRadioGroup(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Not found
	  		bFound = False
	  	End If
	  End If
	  
	  If bFound Then
	  	webRadioGrpFinder = True ' Return Value
	  Else
	  	webRadioGrpFinder = False ' Return Value
	  End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
	
		Reporter.ReportEvent micDone, "webRadioGrpFinder", "Function End"
		Services.EndTransaction "webRadioGrpFinder" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webRadioGrpFinderWIndex</@name>
	'
	' <@purpose>
	'   verifies that the WebRadioGroup object exists on the current visible browser page using the index property
	'   Will check using the NAME Property value first then use the HTML ID Property
	'   If not found by the NAME Property   
	' </@purpose>
	'
	' <@parameters>
	'   sNameOrHTMLIDProperty (ByVal) = string - Name or HTML ID of the radio group to be verified
	'   iIndex (ByVal) = Integer - Index Property Value for WebRadioGroup
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            	true -  if found
	'            	false - if not found or other function errors
	' </@return>
	'   
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webRadioGrpFinderWIndex("outFlight", 0)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>05-12-2008</@creation_date>
	'
	' <@mod_block>
	' </@mod_block>  
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webRadioGrpFinderWIndex(ByVal sNameOrHTMLIDProperty, ByVal iIndex) ' <@as> Boolean
	
	 	Services.StartTransaction "webRadioGrpFinderWIndex" ' Timer Begin
		Reporter.ReportEvent micDone, "webRadioGrpFinderWIndex", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj
		Dim bFound
	
		'checks to verify that the passed parameter is not null or an empty string.
		If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Or IsNull(iIndex) Or iIndex = "" Then
			Reporter.ReportEvent micFail, "invalid parameter", "an invalid parameter was passed to the webRadioGrpFinderWIndex function check passed parameters"
			webRadioGrpFinderWIndex = False ' Return Value
			Services.EndTransaction "webRadioGrpFinderWIndex" ' Timer End
			Exit Function
		End If
	
		'description object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebRadioGroup"
		oAppObj("name").Value = sNameOrHTMLIDProperty
		oAppObj("index").Value = iIndex
		
	  ' Verification of the Object 
	  If Browser(oAppBrowser).WebRadioGroup(oAppObj).Exist(1) Then
	  	bFound = True
	  Else ' Check using HTML ID Property
	  	oAppObj.Remove "name" ' Remove NAME Property
	  	oAppObj("html id").Value = sNameOrHTMLIDProperty
	  	If Browser(oAppBrowser).WebRadioGroup(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Not found
	  		bFound = False
	  	End If
	  End If
	  
	  If bFound Then
	  	webRadioGrpFinderWIndex = True ' Return Value
	  Else
	  	webRadioGrpFinderWIndex = False ' Return Value
	  End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
	
		Reporter.ReportEvent micDone, "webRadioGrpFinderWIndex", "Function End"
		Services.EndTransaction "webRadioGrpFinderWIndex" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webRadioGrpSelect</@name>
	'
	' <@purpose>
	'   To verify that the WebRadioGroup exists on current visible browser page and if so,
	'		the sSelection parameter is selected, if the sSelection value is in the list.
	'   Will check using the NAME Property value first then use the HTML ID Property
	'   If not found by the NAME Property  
	' </@purpose>
	'
	' <@parameters>
	'       sNameOrHTMLIDProperty (ByVal) = String - Name or HTML ID of the WebRadioGroup to be verified
	'				sSelection (ByVal) = String - Name of the WebRadioGroup selection
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'            True -  If found
	'            False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webListSelect("tripType", "oneway")</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>01-14-2008</@creation_date>
	'
	' <@mod_block>
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-04-2008 - MM - Added logic to search for the object using the HTML ID property
	'                     if not found by the NAME Property
	'                     Added logic to verify the WebRadioGroup is enabled
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webRadioGrpSelect(ByVal sNameOrHTMLIDProperty, ByVal sSelection) ' <@as> Boolean
	  
	  Services.StartTransaction "webRadioGrpSelect" ' Timer Begin
		Reporter.ReportEvent micDone, "webRadioGrpSelect", "Function Begin"
		
		' Variable Declaration / Initialization
	  Dim oAppBrowser, oAppObj, aGrpAllItems, sListItem, sGrpVal, iDisabled, bFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Or IsNull(sSelection) Or sSelection = "" Then
	    Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the webRadioGrpSelect function check passed parameters"
	    webRadioGrpSelect = False ' Return Value
	    Services.EndTransaction "webRadioGrpSelect" ' Timer End
	    Exit Function
	  End If
	
	  ' Description Object Declarations/Initializations
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebRadioGroup"
		oAppObj("name").Value = sNameOrHTMLIDProperty
	
	  ' Verification of the Object 
	  If Browser(oAppBrowser).WebRadioGroup(oAppObj).Exist(1) Then
	  	bFound = True
	  Else ' Check using HTML ID Property
	  	oAppObj.Remove "name" ' Remove NAME Property
	  	oAppObj("html id").Value = sNameOrHTMLIDProperty
	  	If Browser(oAppBrowser).WebRadioGroup(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Not found
	  		bFound = False
	  	End If
	  End If
	  
	  ' If webRadioGrp found, verify it is enabled before trying to make the selection
	  If bFound Then
	  	
	  	' Check to see if the webRadioGrp is enabled
	  	iDisabled = Browser(oAppBrowser).WebRadioGroup(oAppObj).GetROProperty("disabled")
	  	
			If iDisabled = 1 Then
				Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' WebRadioGroup", "The '" & sNameOrHTMLIDProperty & "' WebRadioGroup is disabled"
				webRadioGrpSelect = False ' Return Value
				
			Else ' WebRadioGroup Enabled
				Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' WebRadioGroup", "The '" & sNameOrHTMLIDProperty & "' WebRadioGroup is enabled"
	  	
		  	' Get all items property value from WebRadioGroup to verify that sSelection is in the list before trying to select it
	  		aGrpAllItems = Split(Browser(oAppBrowser).WebRadioGroup(oAppObj).GetROProperty("all items"), ";")
		  	
	  		' Loop through aGrpAllItems array to Verify sSelection is in the list
		  	For each sListItem in aGrpAllItems
	  			If StrComp(LCase(sListItem), LCase(sSelection), 1) = 0 Then ' sSelection String found, select it
	  				bFound = True
	  				Exit For
		  		Else ' Not Found
	  				bFound = False
	  			End If
	  		Next
		  		
		     ' sSelection String found, select it
		  	If bFound Then
		  		Reporter.ReportEvent micPass, "WebRadioGroup Selection", "The value '" & sSelection & "' was found in the '" & sNameOrHTMLIDProperty & "' WebRadioGroup List"
		  			
		  		' Select the Value (sListItem which equals the sSelection Parameter) and verify that it was made
		  		Browser(oAppBrowser).WebRadioGroup(oAppObj).Select sListItem 			
		  			
		  		'Get value property value from WebRadioGroup to verify that sSelection was selected
		  		sGrpVal = LCase(Browser(oAppBrowser).WebRadioGroup(oAppObj).GetROProperty("value"))
		  		
		  		'Verify the sSelection was actually chosen
		  		If StrComp(sGrpVal, LCase(sSelection), 1) = 0 Then ' If sSelection value was chosen
		  			Reporter.ReportEvent micPass, "WebRadioGroup Selection", "The value '" & sSelection & "' was chosen in the '" & sNameOrHTMLIDProperty & "' WebRadioGroup List"
		  			webRadioGrpSelect = True ' Return Value
		  		Else ' sSelection value was not chosen
		  			Reporter.ReportEvent micFail, "WebRadioGroup Selection", "The value '" & sSelection & "' was not chosen in the '" & sNameOrHTMLIDProperty & "' WebRadioGroup List"
		  			webRadioGrpSelect = False ' Return Value
		  		End If
		
		  	Else ' sSelection not found
		  		Reporter.ReportEvent micFail, "WebRadioGroup Selection", "The value '" & sSelection & "' was not found in the '" & sNameOrHTMLIDProperty & "' WebRadioGroup List"
		  		webRadioGrpSelect = False ' Return Value
		  	End If
		  End If
	  		
	  Else ' Object Not Found
	  	webRadioGrpSelect = False ' Return Value
	  End If
	  
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
	  
		Reporter.ReportEvent micDone, "webRadioGrpSelect", "Function End"
		Services.EndTransaction "webRadioGrpSelect" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webRadioGrpSelectWIndex</@name>
	'
	' <@purpose>
	'   To verify that the WebRadioGroup exists on current visible browser page using the index property, and if so,
	'		the sSelection parameter is selected, if the sSelection value is in the list.
	'   Will check using the NAME Property value first then use the HTML ID Property
	'   If not found by the NAME Property  
	' </@purpose>
	'
	' <@parameters>
	'       sNameOrHTMLIDProperty (ByVal) = String - Name or HTML ID of the WebRadioGroup to be verified
	'				sSelection (ByVal) = String - Name of the WebRadioGroup selection
	'       iIndex (ByVal) = Integer - Index Property Value for WebRadioGroup
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'            True -  If found
	'            False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webRadioGrpSelectWIndex("tripType", "oneway", 0)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>05-12-2008</@creation_date>
	'
	' <@mod_block>
	' </@mod_block>  
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webRadioGrpSelectWIndex(ByVal sNameOrHTMLIDProperty, ByVal sSelection, ByVal iIndex) ' <@as> Boolean
	  
	  Services.StartTransaction "webRadioGrpSelectWIndex" ' Timer Begin
		Reporter.ReportEvent micDone, "webRadioGrpSelectWIndex", "Function Begin"
		
		' Variable Declaration / Initialization
	  Dim oAppBrowser, oAppObj, aGrpAllItems, sListItem, sGrpVal, iDisabled, bFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Or IsNull(sSelection) Or sSelection = "" Or IsNull(iIndex) Or iIndex = "" Then
	          Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the webRadioGrpSelectWIndex function check passed parameters"
	          webRadioGrpSelectWIndex = False ' Return Value
	          Services.EndTransaction "webRadioGrpSelectWIndex" ' Timer End
	          Exit Function
	  End If
	
	  ' Description Object Declarations/Initializations
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebRadioGroup"
		oAppObj("name").Value = sNameOrHTMLIDProperty
		oAppObj("index").Value = iIndex
	
	  ' Verification of the Object 
	  If Browser(oAppBrowser).WebRadioGroup(oAppObj).Exist(1) Then
	  	bFound = True
	  Else ' Check using HTML ID Property
	  	oAppObj.Remove "name" ' Remove NAME Property
	  	oAppObj("html id").Value = sNameOrHTMLIDProperty
	  	If Browser(oAppBrowser).WebRadioGroup(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Not found
	  		bFound = False
	  	End If
	  End If
	  
	  ' If webRadioGrp found, verify it is enabled before trying to make the selection
	  If bFound Then
	  	
	  	' Check to see if the webRadioGrp is enabled
	  	iDisabled = Browser(oAppBrowser).WebRadioGroup(oAppObj).GetROProperty("disabled")
	  	
			If iDisabled = 1 Then
				Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' WebRadioGroup", "The '" & sNameOrHTMLIDProperty & "' WebRadioGroup is disabled"
				webRadioGrpSelectWIndex = False ' Return Value
				
			Else ' WebRadioGroup Enabled
				Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' WebRadioGroup", "The '" & sNameOrHTMLIDProperty & "' WebRadioGroup is enabled"
	  	
		  	' Get all items property value from WebRadioGroup to verify that sSelection is in the list before trying to select it
	  		aGrpAllItems = Split(Browser(oAppBrowser).WebRadioGroup(oAppObj).GetROProperty("all items"), ";")
		  	
	  		' Loop through aGrpAllItems array to Verify sSelection is in the list
		  	For each sListItem in aGrpAllItems
	  			If StrComp(LCase(sListItem), LCase(sSelection), 1) = 0 Then ' sSelection String found, select it
	  				bFound = True
	  				Exit For
		  		Else ' Not Found
	  				bFound = False
	  			End If
	  		Next
		  		
		     ' sSelection String found, select it
		  	If bFound Then
		  		Reporter.ReportEvent micPass, "WebRadioGroup Selection", "The value '" & sSelection & "' was found in the '" & sNameOrHTMLIDProperty & "' WebRadioGroup List"
		  			
		  		' Select the Value (sListItem which equals the sSelection Parameter) and verify that it was made
		  		Browser(oAppBrowser).WebRadioGroup(oAppObj).Select sListItem 			
		  			
		  		'Get value property value from WebRadioGroup to verify that sSelection was selected
		  		sGrpVal = LCase(Browser(oAppBrowser).WebRadioGroup(oAppObj).GetROProperty("value"))
		  		
		  		'Verify the sSelection was actually chosen
		  		If StrComp(sGrpVal, LCase(sSelection), 1) = 0 Then ' If sSelection value was chosen
		  			Reporter.ReportEvent micPass, "WebRadioGroup Selection", "The value '" & sSelection & "' was chosen in the '" & sNameOrHTMLIDProperty & "' WebRadioGroup List"
		  			webRadioGrpSelectWIndex = True ' Return Value
		  		Else ' sSelection value was not chosen
		  			Reporter.ReportEvent micFail, "WebRadioGroup Selection", "The value '" & sSelection & "' was not chosen in the '" & sNameOrHTMLIDProperty & "' WebRadioGroup List"
		  			webRadioGrpSelectWIndex = False ' Return Value
		  		End If
		
		  	Else ' sSelection not found
		  		Reporter.ReportEvent micFail, "WebRadioGroup Selection", "The value '" & sSelection & "' was not found in the '" & sNameOrHTMLIDProperty & "' WebRadioGroup List"
		  		webRadioGrpSelectWIndex = False ' Return Value
		  	End If
		  End If
	  		
	  Else ' Object Not Found
	  	webRadioGrpSelectWIndex = False ' Return Value
	  End If
	  
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
	  
		Reporter.ReportEvent micDone, "webRadioGrpSelectWIndex", "Function End"
		Services.EndTransaction "webRadioGrpSelectWIndex" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webRadioGrpSelectWExpVal</@name>
	'
	' <@purpose>
	'   To verify that the WebRadioGroup exists on current visible browser page and if so,
	'		the sSelection parameter is selected, if the sSelection value is in the list, then
	'   verifies that the sExpVal Parameter was selected.  This function can
	'   be used for those instances where the value of the radial button is not the same
	'   as the label  
	' </@purpose>
	'
	' <@parameters>
	'       sNameOrHTMLIDProperty (ByVal) = String - Name or HTML ID of the WebRadioGroup to be verified
	'				sSelection (ByVal) = String - Name of the WebRadioGroup selection
	'       sExpVal (ByVal) = String - Expected Value of the Radio Button after selection is made
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'            True -  If found
	'            False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webRadioGrpSelectWExpVal("tripType", "oneway", "#3")</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>05-14-2008</@creation_date>
	'
	' <@mod_block>
	' </@mod_block>  
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webRadioGrpSelectWExpVal(ByVal sNameOrHTMLIDProperty, ByVal sSelection, ByVal sExpVal) ' <@as> Boolean
	  
	  Services.StartTransaction "webRadioGrpSelectWExpVal" ' Timer Begin
		Reporter.ReportEvent micDone, "webRadioGrpSelectWExpVal", "Function Begin"
		
		' Variable Declaration / Initialization
	  Dim oAppBrowser, oAppObj, aGrpAllItems, sListItem, sGrpVal, iDisabled, bFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Or IsNull(sSelection) Or sSelection = "" Or IsNull(sExpVal) Or sExpVal = "" Then
	          Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the webRadioGrpSelectWExpVal function check passed parameters"
	          webRadioGrpSelectWExpVal = False ' Return Value
	          Services.EndTransaction "webRadioGrpSelectWExpVal" ' Timer End
	          Exit Function
	  End If
	
	  ' Description Object Declarations/Initializations
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebRadioGroup"
		oAppObj("name").Value = sNameOrHTMLIDProperty
		oAppObj("index").Value = iIndex
	
	  ' Verification of the Object 
	  If Browser(oAppBrowser).WebRadioGroup(oAppObj).Exist(1) Then
	  	bFound = True
	  Else ' Check using HTML ID Property
	  	oAppObj.Remove "name" ' Remove NAME Property
	  	oAppObj("html id").Value = sNameOrHTMLIDProperty
	  	If Browser(oAppBrowser).WebRadioGroup(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Not found
	  		bFound = False
	  	End If
	  End If
	  
	  ' If webRadioGrp found, verify it is enabled before trying to make the selection
	  If bFound Then
	  	
	  	' Check to see if the webRadioGrp is enabled
	  	iDisabled = Browser(oAppBrowser).WebRadioGroup(oAppObj).GetROProperty("disabled")
	  	
			If iDisabled = 1 Then
				Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' WebRadioGroup", "The '" & sNameOrHTMLIDProperty & "' WebRadioGroup is disabled"
				webRadioGrpSelectWExpVal = False ' Return Value
				
			Else ' WebRadioGroup Enabled
				Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' WebRadioGroup", "The '" & sNameOrHTMLIDProperty & "' WebRadioGroup is enabled"
	  	
		  	' Get all items property value from WebRadioGroup to verify that sSelection is in the list before trying to select it
	  		aGrpAllItems = Split(Browser(oAppBrowser).WebRadioGroup(oAppObj).GetROProperty("all items"), ";")
		  	
	  		' Loop through aGrpAllItems array to Verify sSelection is in the list
		  	For each sListItem in aGrpAllItems
	  			If StrComp(LCase(sListItem), LCase(sSelection), 1) = 0 Then ' sSelection String found, select it
	  				bFound = True
	  				Exit For
		  		Else ' Not Found
	  				bFound = False
	  			End If
	  		Next
		  		
		     ' sSelection String found, select it
		  	If bFound Then
		  		Reporter.ReportEvent micPass, "WebRadioGroup Selection", "The value '" & sSelection & "' was found in the '" & sNameOrHTMLIDProperty & "' WebRadioGroup List"
		  			
		  		' Select the Value (sListItem which equals the sSelection Parameter) and verify that it was made
		  		Browser(oAppBrowser).WebRadioGroup(oAppObj).Select sListItem 			
		  			
		  		'Get value property value from WebRadioGroup to verify that sSelection was selected
		  		sGrpVal = LCase(Browser(oAppBrowser).WebRadioGroup(oAppObj).GetROProperty("value"))
		  		
		  		'Verify the sSelection was actually chosen, based on the sExpVal parameter
			  	If StrComp(sGrpVal, LCase(sExpVal), 1) = 0 Then ' If sSelection value was chosen using the sExpVal for comparison
		  			Reporter.ReportEvent micPass, "WebRadioGroup Selection", "The value '" & sSelection & "' was chosen in the '" & sNameOrHTMLIDProperty & "' WebRadioGroup List"
		  			webRadioGrpSelectWExpVal = True ' Return Value
		  		Else ' sSelection value was not chosen
		  			Reporter.ReportEvent micFail, "WebRadioGroup Selection", "The value '" & sSelection & "' was not chosen in the '" & sNameOrHTMLIDProperty & "' WebRadioGroup List, expected: '" & sExpVal & "'"
		  			webRadioGrpSelectWExpVal = False ' Return Value
		  		End If
		
		  	Else ' sSelection not found
		  		Reporter.ReportEvent micFail, "WebRadioGroup Selection", "The value '" & sSelection & "' was not found in the '" & sNameOrHTMLIDProperty & "' WebRadioGroup List"
		  		webRadioGrpSelectWExpVal = False ' Return Value
		  	End If
		  End If
	  		
	  Else ' Object Not Found
	  	webRadioGrpSelectWExpVal = False ' Return Value
	  End If
	  
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
	  
		Reporter.ReportEvent micDone, "webRadioGrpSelectWExpVal", "Function End"
		Services.EndTransaction "webRadioGrpSelectWExpVal" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webRadioGrpSelectWIndexWExpVal</@name>
	'
	' <@purpose>
	'   To verify that the WebRadioGroup exists on current visible browser page using the index property, and if so,
	'		the sSelection parameter is selected, if the sSelection value is in the list, then
	'   verifies that the sExpVal Parameter was selected.  This function can
	'   be used for those instances where the value of the radial button is not the same
	'   as the label  
	' </@purpose>
	'
	' <@parameters>
	'       sNameOrHTMLIDProperty (ByVal) = String - Name or HTML ID of the WebRadioGroup to be verified
	'				sSelection (ByVal) = String - Name of the WebRadioGroup selection
	'       iIndex (ByVal)= Integer - Index Property Value for WebRadioGroup
	'       sExpVal (ByVal) = String - Expected Value of the Radio Button after selection is made
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'            True -  If found
	'            False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webRadioGrpSelectWIndexWExpVal("tripType", "oneway", 0, "#3")</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>05-14-2008</@creation_date>
	'
	' <@mod_block>
	' </@mod_block>  
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webRadioGrpSelectWIndexWExpVal(ByVal sNameOrHTMLIDProperty, ByVal sSelection, ByVal iIndex, ByVal sExpVal) ' <@as> Boolean
	  
	  Services.StartTransaction "webRadioGrpSelectWIndexWExpVal" ' Timer Begin
		Reporter.ReportEvent micDone, "webRadioGrpSelectWIndexWExpVal", "Function Begin"
		
		' Variable Declaration / Initialization
	  Dim oAppBrowser, oAppObj, aGrpAllItems, sListItem, sGrpVal, iDisabled, bFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Or IsNull(sSelection) Or sSelection = "" Or IsNull(iIndex) Or iIndex = "" Or IsNull(sExpVal) Or sExpVal = "" Then
	          Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the webRadioGrpSelectWIndexWExpVal function check passed parameters"
	          webRadioGrpSelectWIndexWExpVal = False ' Return Value
	          Services.EndTransaction "webRadioGrpSelectWIndexWExpVal" ' Timer End
	          Exit Function
	  End If
	
	  ' Description Object Declarations/Initializations
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebRadioGroup"
		oAppObj("name").Value = sNameOrHTMLIDProperty
		oAppObj("index").Value = iIndex
	
	  ' Verification of the Object 
	  If Browser(oAppBrowser).WebRadioGroup(oAppObj).Exist(1) Then
	  	bFound = True
	  Else ' Check using HTML ID Property
	  	oAppObj.Remove "name" ' Remove NAME Property
	  	oAppObj("html id").Value = sNameOrHTMLIDProperty
	  	If Browser(oAppBrowser).WebRadioGroup(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Not found
	  		bFound = False
	  	End If
	  End If
	  
	  ' If webRadioGrp found, verify it is enabled before trying to make the selection
	  If bFound Then
	  	
	  	' Check to see if the webRadioGrp is enabled
	  	iDisabled = Browser(oAppBrowser).WebRadioGroup(oAppObj).GetROProperty("disabled")
	  	
			If iDisabled = 1 Then
				Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' WebRadioGroup", "The '" & sNameOrHTMLIDProperty & "' WebRadioGroup is disabled"
				webRadioGrpSelectWIndexWExpVal = False ' Return Value
				
			Else ' WebRadioGroup Enabled
				Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' WebRadioGroup", "The '" & sNameOrHTMLIDProperty & "' WebRadioGroup is enabled"
	  	
		  	' Get all items property value from WebRadioGroup to verify that sSelection is in the list before trying to select it
	  		aGrpAllItems = Split(Browser(oAppBrowser).WebRadioGroup(oAppObj).GetROProperty("all items"), ";")
		  	
	  		' Loop through aGrpAllItems array to Verify sSelection is in the list
		  	For each sListItem in aGrpAllItems
	  			If StrComp(LCase(sListItem), LCase(sSelection), 1) = 0 Then ' sSelection String found, select it
	  				bFound = True
	  				Exit For
		  		Else ' Not Found
	  				bFound = False
	  			End If
	  		Next
		  		
		     ' sSelection String found, select it
		  	If bFound Then
		  		Reporter.ReportEvent micPass, "WebRadioGroup Selection", "The value '" & sSelection & "' was found in the '" & sNameOrHTMLIDProperty & "' WebRadioGroup List"
		  			
		  		' Select the Value (sListItem which equals the sSelection Parameter) and verify that it was made
		  		Browser(oAppBrowser).WebRadioGroup(oAppObj).Select sListItem 			
		  			
		  		'Get value property value from WebRadioGroup to verify that sSelection was selected
		  		sGrpVal = LCase(Browser(oAppBrowser).WebRadioGroup(oAppObj).GetROProperty("value"))
		  		
		  		'Verify the sSelection was actually chosen, based on the sExpVal parameter
			  	If StrComp(sGrpVal, LCase(sExpVal), 1) = 0 Then ' If sSelection value was chosen using the sExpVal for comparison
		  			Reporter.ReportEvent micPass, "WebRadioGroup Selection", "The value '" & sSelection & "' was chosen in the '" & sNameOrHTMLIDProperty & "' WebRadioGroup List"
		  			webRadioGrpSelectWIndexWExpVal = True ' Return Value
		  		Else ' sSelection value was not chosen
		  			Reporter.ReportEvent micFail, "WebRadioGroup Selection", "The value '" & sSelection & "' was not chosen in the '" & sNameOrHTMLIDProperty & "' WebRadioGroup List, expected: '" & sExpVal & "'"
		  			webRadioGrpSelectWIndexWExpVal = False ' Return Value
		  		End If
		
		  	Else ' sSelection not found
		  		Reporter.ReportEvent micFail, "WebRadioGroup Selection", "The value '" & sSelection & "' was not found in the '" & sNameOrHTMLIDProperty & "' WebRadioGroup List"
		  		webRadioGrpSelectWIndexWExpVal = False ' Return Value
		  	End If
		  End If
	  		
	  Else ' Object Not Found
	  	webRadioGrpSelectWIndexWExpVal = False ' Return Value
	  End If
	  
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
	  
		Reporter.ReportEvent micDone, "webRadioGrpSelectWIndexWExpVal", "Function End"
		Services.EndTransaction "webRadioGrpSelectWIndexWExpVal" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webElementFinder</@name>
	'
	' <@purpose>
	'   Verifies that the webelement exists on current visible browser page
	'   Will check using the INNERTEXT Property value first then use the HTML ID Property
	'   If not found by the INNERTEXT Property
	' </@purpose>
	'
	' <@parameters>
	'   sInnerTextOrHTMLIDProperty (ByVal) = String - InnerText or HTML ID of the WebElement to be verified
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            	true -  if found
	'            	false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webElementFinder("Advanced Search")</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>04-17-2008</@creation_date>
	'
	' <@mod_block>
	'   04-21-2008 - MM - Added Replace Statement to put in escape character for
	'                     special characters ()?$
	'   04-28-2008 - MM - Added logic to look for the object using the OUTERHTML Property
	'                     value if not found with HTML ID
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webElementFinder(ByVal sInnerTextOrHTMLIDProperty) ' <@as> Boolean
	
		Services.StartTransaction "webElementFinder" ' Timer Begin
		Reporter.ReportEvent micDone, "webElementFinder", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj
		Dim bFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sInnerTextOrHTMLIDProperty) or sInnerTextOrHTMLIDProperty = "" Then
			Reporter.ReportEvent micFail, "Invalid Parameter", "An invalid parameter was passed to the webElementFinder function check passed parameters"
			webElementFinder = False ' Return Value
			Services.EndTransaction "webElementFinder" ' Timer End
			Exit Function
		End If
	
		'object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
		
		'adds a "\" before special characters.
	  sInnerTextOrHTMLIDProperty = Replace(Replace(Replace(Replace(sInnerTextOrHTMLIDProperty, "(", "\("), ")", "\)"), "?", "\?"), "$", "\$")
	
		Set oAppObj = Description.Create()
		oAppObj("MicClass").Value = "WebElement"
		oAppObj("innertext").Value = sInnerTextOrHTMLIDProperty
		
	  ' Verification of the Object 
	  If Browser(oAppBrowser).WebElement(oAppObj).Exist(1) Then
	    bFound = True
	  Else ' check using the html id property
	  	oAppObj.Remove "innertext" ' Remove INNERTEXT property
	  	oAppObj("html id").Value = sInnerTextOrHTMLIDProperty ' Add the HTML ID Property
	  	If Browser(oAppBrowser).WebElement(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' check using the outerhtml property
	  		oAppObj.Remove "html id" ' Remove HTML ID property
	  		oAppObj("outerhtml").Value = sInnerTextOrHTMLIDProperty ' Add the OUTERHTML Property
	  		If Browser(oAppBrowser).WebElement(oAppObj).Exist(1) Then
	  			bFound = True
	  		Else ' Not Found
	  			bFound = False
	  		End If
	  	End If
	  End If
	
		' If Object Found
		If bFound Then
			webElementFinder = True ' Return Value
		Else ' WebElement does not exist
			webElementFinder = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "webElementFinder", "Function End"
		Services.EndTransaction "webElementFinder" ' Timer End
	
	End Function
	
	'<@comments>
	'**********************************************************************************************
	' <@name>webElementFinderWIndex</@name>
	'
	' <@purpose>
	'   Verifies that the webelement exists on current visible browser page using the index property
	'   Will check using the INNERTEXT Property value first then use the HTML ID Property
	'   If not found by the INNERTEXT Property
	' </@purpose>
	'
	' <@parameters>
	'   sInnerTextOrHTMLIDProperty (ByVal) = String - InnerText or HTML ID of the WebElement to be verified
	'   iIndex (ByVal) = Integer - Index Property Value for WebElement to be verified
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            	true -  if found
	'            	false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webElementFinderWIndex("Advanced Search", 0)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>04-17-2008</@creation_date>
	'
	' <@mod_block>
	'   04-21-2008 - MM - Added Replace Statement to put in escape character for
	'                     special characters ()?$
	'   04-28-2008 - MM - Added logic to look for the object using the OUTERHTML Property
	'                     value if not found with HTML ID
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webElementFinderWIndex(ByVal sInnerTextOrHTMLIDProperty, ByVal iIndex) ' <@as> Boolean
	
		Services.StartTransaction "webElementFinderWIndex" ' Timer Begin
		Reporter.ReportEvent micDone, "webElementFinderWIndex", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj
		Dim bFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sInnerTextOrHTMLIDProperty) or sInnerTextOrHTMLIDProperty = "" Or IsNull(iIndex) Or iIndex = "" Then
			Reporter.ReportEvent micFail, "Invalid Parameter", "An invalid parameter was passed to the webElementFinderWIndex function check passed parameters"
			webElementFinderWIndex = False ' Return Value
			Services.EndTransaction "webElementFinderWIndex" ' Timer End
			Exit Function
		End If
	
		'object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
		
		'adds a "\" before special characters.
	  sInnerTextOrHTMLIDProperty = Replace(Replace(Replace(Replace(sInnerTextOrHTMLIDProperty, "(", "\("), ")", "\)"), "?", "\?"), "$", "\$")
	
		Set oAppObj = Description.Create()
		oAppObj("MicClass").Value = "WebElement"
		oAppObj("innertext").Value = sInnerTextOrHTMLIDProperty
		oAppObj("index").Value = iIndex
		
	  ' Verification of the Object 
	  If Browser(oAppBrowser).WebElement(oAppObj).Exist(1) Then
	    bFound = True
	  Else ' check using the html id property
	  	oAppObj.Remove "innertext" ' Remove INNERTEXT property
	  	oAppObj("html id").Value = sInnerTextOrHTMLIDProperty ' Add the HTML ID Property
	  	If Browser(oAppBrowser).WebElement(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' check using the outerhtml property
	  		oAppObj.Remove "html id" ' Remove HTML ID property
	  		oAppObj("outerhtml").Value = sInnerTextOrHTMLIDProperty ' Add the OUTERHTML Property
	  		If Browser(oAppBrowser).WebElement(oAppObj).Exist(1) Then
	  			bFound = True
	  		Else ' Not Found
	  			bFound = False
	  		End If
	  	End If
	  End If
	
		' If Object Found
		If bFound Then
			webElementFinderWIndex = True ' Return Value
		Else ' WebElement does not exist
			webElementFinderWIndex = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "webElementFinderWIndex", "Function End"
		Services.EndTransaction "webElementFinderWIndex" ' Timer End
	
	End Function
	
	'<@comments>
	'**********************************************************************************************
	' <@name>webElementClicker</@name>
	'
	' <@purpose>
	'   verifies that the webelement exists on current visible browser page and if so,
	'   is clicked.
	'   Will check using the INNERTEXT Property value first then use the HTML ID Property
	'   If not found by the INNERTEXT Property
	' </@purpose>
	'
	' <@parameters>
	'   sInnerTextOrHTMLIDProperty (ByVal) = String - InnerText or HTML ID of the WebElement to be verified
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'         	true -  if found
	'         	false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webElementClicker("Advanced Search")</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>04-17-2008</@creation_date>
	'
	' <@mod_block>
	'   04-21-2008 - MM - Added Replace Statement to put in escape character for
	'                     special characters ()?$
	'   04-28-2008 - MM - Added logic to look for the object using the OUTERHTML Property
	'                     value if not found with HTML ID
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webElementClicker(ByVal sInnerTextOrHTMLIDProperty) ' <@as> Boolean
	
		Services.StartTransaction "webElementClicker" ' Timer Begin
		Reporter.ReportEvent micDone, "webElementClicker", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj
		Dim bFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sInnerTextOrHTMLIDProperty) or sInnerTextOrHTMLIDProperty = "" Then
			Reporter.ReportEvent micFail, "Invalid Parameter", "An invalid parameter was passed to the webElementClicker function check passed parameters"
			webElementClicker = False ' Return Value
			Services.EndTransaction "webElementClicker" ' Timer End
			Exit Function
		End If
	
		'object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
		
		'adds a "\" before special characters.
	  sInnerTextOrHTMLIDProperty = Replace(Replace(Replace(Replace(sInnerTextOrHTMLIDProperty, "(", "\("), ")", "\)"), "?", "\?"), "$", "\$")
	
		Set oAppObj = Description.Create()
		oAppObj("MicClass").Value = "WebElement"
		oAppObj("innertext").Value = sInnerTextOrHTMLIDProperty
		
	  ' Verification of the Object 
	  If Browser(oAppBrowser).WebElement(oAppObj).Exist(1) Then
	    bFound = True
	  Else ' check using the html id property
	  	oAppObj.Remove "innertext" ' Remove INNERTEXT property
	  	oAppObj("html id").Value = sInnerTextOrHTMLIDProperty ' Add the HTML ID Property
	  	If Browser(oAppBrowser).WebElement(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' check using the outerhtml property
	  		oAppObj.Remove "html id" ' Remove HTML ID property
	  		oAppObj("outerhtml").Value = sInnerTextOrHTMLIDProperty ' Add the OUTERHTML Property
	  		If Browser(oAppBrowser).WebElement(oAppObj).Exist(1) Then
	  			bFound = True
	  		Else ' Not Found
	  			bFound = False
	  		End If
	  	End If
	  End If
	
		' If Object Found, click it 
		If bFound Then
			Browser(oAppBrowser).WebElement(oAppObj).Click
			webElementClicker = True ' Return Value
		Else ' WebElement does not exist
			webElementClicker = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "webElementClicker", "Function End"
		Services.EndTransaction "webElementClicker" ' Timer End
	
	End Function
	
	'<@comments>
	'**********************************************************************************************
	' <@name>webElementClickerWIndex</@name>
	'
	' <@purpose>
	'   verifies that the webelement exists on current visible browser page using the index property, and if so,
	'   is clicked.
	'   Will check using the INNERTEXT Property value first then use the HTML ID Property
	'   If not found by the INNERTEXT Property
	' </@purpose>
	'
	' <@parameters>
	'   sInnerTextOrHTMLIDProperty (ByVal) = String - InnerText or HTML ID of the WebElement to be verified
	'   iIndex (ByVal) = Integer - Index Property Value for WebElement to be verified and clicked
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'         	true -  if found
	'         	false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webElementClickerWIndex("Advanced Search", 0)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>04-17-2008</@creation_date>
	'
	' <@mod_block>
	'   04-21-2008 - MM - Added Replace Statement to put in escape character for
	'                     special characters ()?$
	'   04-28-2008 - MM - Added logic to look for the object using the OUTERHTML Property
	'                     value if not found with HTML ID
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function webElementClickerWIndex(ByVal sInnerTextOrHTMLIDProperty, ByVal iIndex) ' <@as> Boolean
	
		Services.StartTransaction "webElementClickerWIndex" ' Timer Begin
		Reporter.ReportEvent micDone, "webElementClickerWIndex", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj
		Dim bFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sInnerTextOrHTMLIDProperty) or sInnerTextOrHTMLIDProperty = "" Or IsNull(iIndex) Or iIndex = "" Then
			Reporter.ReportEvent micFail, "Invalid Parameter", "An invalid parameter was passed to the webElementClickerWIndex function check passed parameters"
			webElementClickerWIndex = False ' Return Value
			Services.EndTransaction "webElementClickerWIndex" ' Timer End
			Exit Function
		End If
	
		'object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
		
		'adds a "\" before special characters.
	  sInnerTextOrHTMLIDProperty = Replace(Replace(Replace(Replace(sInnerTextOrHTMLIDProperty, "(", "\("), ")", "\)"), "?", "\?"), "$", "\$")
	
		Set oAppObj = Description.Create()
		oAppObj("MicClass").Value = "WebElement"
		oAppObj("innertext").Value = sInnerTextOrHTMLIDProperty
		oAppObj("index").Value = iIndex
		
	  ' Verification of the Object 
	  If Browser(oAppBrowser).WebElement(oAppObj).Exist(1) Then
	    bFound = True
	  Else ' check using the html id property
	  	oAppObj.Remove "innertext" ' Remove INNERTEXT property
	  	oAppObj("html id").Value = sInnerTextOrHTMLIDProperty ' Add the HTML ID Property
	  	If Browser(oAppBrowser).WebElement(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' check using the outerhtml property
	  		oAppObj.Remove "html id" ' Remove HTML ID property
	  		oAppObj("outerhtml").Value = sInnerTextOrHTMLIDProperty ' Add the OUTERHTML Property
	  		If Browser(oAppBrowser).WebElement(oAppObj).Exist(1) Then
	  			bFound = True
	  		Else ' Not Found
	  			bFound = False
	  		End If
	  	End If
	  End If
	
		' If Object Found, click it 
		If bFound Then
			Browser(oAppBrowser).WebElement(oAppObj).Click
			webElementClickerWIndex = True ' Return Value
		Else ' WebElement does not exist
			webElementClickerWIndex = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "webElementClickerWIndex", "Function End"
		Services.EndTransaction "webElementClickerWIndex" ' Timer End
	
	End Function

	Public Function webElementStatus(ByVal HTMLID_Property)
	'***********************************************************************************************************
	'Purpose: Check the WebElement object status (e.g., disabled, active, inactive) via the 
	'                   object "outerhtml" property value
	'Parameters: HTMLID_Property = the object "html id" property value
	'Returns: string: disabled -  object is disabled
	'                              active - object is active
	'                              inactive - object is inactive
	'                             not exist - the object specified does not exist
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: sGetValue = util.webElementStatus("j_id132_lbl")
	'                msgbox "The WebElement object current status = " &sGetValue
	'Created by: Hung Nguyen 12/2/10
	'Modified:
	'***********************************************************************************************************
	Services.StartTransaction "webElementStatus" ' Timer start
	  ' verify passed parameters are not empty strings
	  If HTMLID_Property = "" Then
			Reporter.ReportEvent micFail, "Invalid Parameter", "Parameter cannot be empty. Abort."
			webElementStatus = "not exist" ' Return Value
			Services.EndTransaction "webElementStatus" ' Timer End
			Exit Function
		End If
		
		Dim oAppBrowser,iStatus
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))
		
		'report
		If oAppBrowser.WebElement("html id:=" &HTMLID_Property).Exist(2) Then
			iStatus=oAppBrowser.WebElement("html id:=" &HTMLID_Property).GetROProperty("outerhtml")
			If Instr(1,iStatus,"rich-tab-active",1) Then
				webElementStatus = "active"		'return value
			ElseIf Instr(1,iStatus,"rich-tab-inactive",1) Then
				webElementStatus = "inactive"	'return value
			ElseIf Instr(1,iStatus,"rich-tab-disabled",1) Then
				webElementStatus = "disabled"	'return value
			ElseIf Instr(1,iStatus,"rich-menu-item-disabled",1) > 0 OR Instr(1,iStatus,"rich-menu-item-label-disabled",1) > 0 Then
				webElementStatus = "disabled"	'return value
			ElseIf Instr(1,iStatus,"rich-menu-item-label",1) Then
				webElementStatus = "enabled"	'return value
			End If
		Else
			webElementStatus = "not exist"	'return value
		End If
		Set oAppBrowser = Nothing
	Services.EndTransaction "webElementStatus" ' Timer end
	End Function	
	
	'<@comments>
	'**********************************************************************************************
	' <@name>webFileFinder</@name>
	'
	' <@purpose>
	'    To verify that the WebFile exists on current visible browser page
	'    Will check using the NAME Property value first then use the HTML ID Property
	'    If not found by the NAME Property
	' </@purpose>
	'
	' <@parameters>
	'    sNameOrHTMLIDProperty (ByVal) = String - Name or HTML ID of the WebFile to be verified
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'         True -  If found
	'         False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webFileFinder("RcnFile")</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>04-04-2008</@creation_date>
	'
	' <@mod_block>
	' </@mod_block>
	' 
	'**********************************************************************************************
	'</@comments>
	Public Function webFileFinder(ByVal sNameOrHTMLIDProperty) ' <@as> Boolean
	  
	  Services.StartTransaction "webFileFinder" ' Timer Begin
	  Reporter.ReportEvent micDone, "webFileFinder", "Function Begin"
	  
	  ' Variable Declaration / Initialization 
	  Dim oAppBrowser, oAppObj
	  Dim bFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sNameOrHTMLIDProperty) or sNameOrHTMLIDProperty = "" Then
	  	Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the webFileFinder function check passed parameters"
	    webFileFinder = False ' Return Value
	    Services.EndTransaction "webFileFinder" ' Timer End
	    Exit Function
	  End If
	
	  ' Description Object Declarations/Initializations
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
	  Set oAppObj = Description.Create()
	  oAppObj("micclass").Value = "WebFile"
	  oAppObj("name").Value = sNameOrHTMLIDProperty
	
	  ' Verification of the Object 
	  If Browser(oAppBrowser).WebFile(oAppObj).Exist(1) Then
	    bFound = True
	  Else ' check using the html id property
	  	oAppObj.Remove "text" ' Remove text property
	  	oAppObj("html id").Value = sNameOrHTMLIDProperty
	  	If Browser(oAppBrowser).WebFile(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Not found
	  		bFound = False
	  	End If
	  End If
	  
	  If bFound Then
	  	webFileFinder = True ' Return Value
	  Else ' Not Found
	  	webFileFinder = False ' Return Value
	  End If
	   
	  ' Clear Object Variables
	  Set oAppBrowser = Nothing
	  Set oAppObj = Nothing
	  
	  Reporter.ReportEvent micDone, "webFileFinder", "Function End"
	  Services.EndTransaction "webFileFinder" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>webFileFinderWIndex</@name>
	'
	' <@purpose>
	'    To verify that the WebFile exists on current visible browser page using the index property
	'    Will check using the NAME Property value first then use the HTML ID Property
	'    If not found by the NAME Property
	' </@purpose>
	'
	' <@parameters>
	'    sNameOrHTMLIDProperty (ByVal) = String - Name or HTML ID of the WebFile to be verified
	'    iIndex (ByVal) = Integer - Index Property Value for WebFile to be verified
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'         True -  If found
	'         False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webFileFinderWIndex("RcnFile", 0)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>04-04-2008</@creation_date>
	'
	' <@mod_block>
	' </@mod_block>
	' 
	'**********************************************************************************************
	'</@comments>
	Public Function webFileFinderWIndex(ByVal sNameOrHTMLIDProperty, ByVal iIndex) ' <@as> Boolean
	  
	  Services.StartTransaction "webFileFinderWIndex" ' Timer Begin
	  Reporter.ReportEvent micDone, "webFileFinderWIndex", "Function Begin"
	  
	  ' Variable Declaration / Initialization 
	  Dim oAppBrowser, oAppObj
	  Dim bFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sNameOrHTMLIDProperty) or sNameOrHTMLIDProperty = "" Or IsNull(iIndex) or iIndex = "" Then
	  	Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the webFileFinderWIndex function check passed parameters"
	    webFileFinderWIndex = False ' Return Value
	    Services.EndTransaction "webFileFinderWIndex" ' Timer End
	    Exit Function
	  End If
	
	  ' Description Object Declarations/Initializations
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
	  Set oAppObj = Description.Create()
	  oAppObj("micclass").Value = "WebFile"
	  oAppObj("name").Value = sNameOrHTMLIDProperty
	  oAppObj("index").Value = iIndex
	
	  ' Verification of the Object 
	  If Browser(oAppBrowser).WebFile(oAppObj).Exist(1) Then
	    bFound = True
	  Else ' check using the html id property
	  	oAppObj.Remove "name" ' Remove name property
	  	oAppObj("html id").Value = sNameOrHTMLIDProperty
	  	If Browser(oAppBrowser).WebFile(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Not found
	  		bFound = False
	  	End If
	  End If
	  
	  If bFound Then
	  	webFileFinderWIndex = True ' Return Value
	  Else ' Not Found
	  	webFileFinderWIndex = False ' Return Value
	  End If
	   
	  ' Clear Object Variables
	  Set oAppBrowser = Nothing
	  Set oAppObj = Nothing
	  
	  Reporter.ReportEvent micDone, "webFileFinderWIndex", "Function End"
	  Services.EndTransaction "webFileFinderWIndex" ' Timer End
	
	End Function
	
	'<@comments>
	'**********************************************************************************************
	' <@name>webFileEnter</@name>
	'
	' <@purpose>
	'   To verify that the WebFile exists on current visible browser page and if so,
	'		the sInputPathFile parameter is entered.
	'   Will check using the NAME Property value first then use the HTML ID Property
	'   If not found by the NAME Property
	' </@purpose>
	'
	' <@parameters>
	'     sNameOrHTMLIDProperty (ByVal) = String - Name or HTML ID of the WebFile to be verified
	'     sInputPathFile - (ByVal) string = name of the file to be used including the path
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'         True -  If found
	'         False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webFileEnter("RcnFile", "C:\Temp\test.txt")</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>04-04-2008</@creation_date>
	'
	' <@mod_block>
	' </@mod_block>
	' 
	'**********************************************************************************************
	'</@comments>
	Public Function webFileEnter(ByVal sNameOrHTMLIDProperty, ByVal sInputPathFile) ' <@as> Boolean
	  
	  Services.StartTransaction "webFileEnter" ' Timer Begin
	  Reporter.ReportEvent micDone, "webFileEnter", "Function Begin"
	  
	  ' Variable Declaration / Initialization 
	  Dim oAppBrowser, oAppObj, oFSO, iDisabled, sEditVal
	  Dim bFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sNameOrHTMLIDProperty) or sNameOrHTMLIDProperty = "" Or IsNull(sInputPathFile) or sInputPathFile = "" Then
	  	Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the webFileEnter function check passed parameters"
	    webFileEnter = False ' Return Value
	    Services.EndTransaction "webFileEnter" ' Timer End
	    Exit Function
	  End If
	  
		' Create a FileySystemObject
		Set oFSO = CreateObject("Scripting.FileSystemObject")
	
		' Check the sInputPathFile File Exists, if it does not exit function
		If Not oFSO.FileExists(sInputPathFile) Then
			Reporter.ReportEvent micFail, "Invalid Parameter", "File '" & sInputPathFile & "' does not exist when using the webFileEnter function check passed parameters"
			webFileEnter = False ' Return Value
			Services.EndTransaction "webFileEnter" ' Timer End
			Exit Function
		End If
	
	  ' Description Object Declarations/Initializations
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
	  Set oAppObj = Description.Create()
	  oAppObj("micclass").Value = "WebFile"
	  oAppObj("name").Value = sNameOrHTMLIDProperty
	
	  ' Verification of the Object 
	  If Browser(oAppBrowser).WebFile(oAppObj).Exist(1) Then
	    bFound = True
	  Else ' check using the html id property
	  	oAppObj.Remove "name" ' Remove name property
	  	oAppObj("html id").Value = sNameOrHTMLIDProperty ' Add HTML ID Property
	  	If Browser(oAppBrowser).WebFile(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Not found
	  		bFound = False
	  	End If
	  End If
	  
		' Object Found set the value if enabled
		If bFound Then
			
			' Check to see if the WebFile is enabled
			iDisabled = Browser(oAppBrowser).WebFile(oAppObj).GetROProperty("disabled")
			
			If iDisabled = 1 Then
				Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' WebFile", "The '" & sNameOrHTMLIDProperty & "' WebFile is disabled"
				webFileEnter = False ' Return Value
			Else ' WebFile Enabled
				Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' WebFile", "The '" & sNameOrHTMLIDProperty & "' WebFile is enabled"
				
				' Set the WebFile
				Browser(oAppBrowser).WebFile(oAppObj).Set sInputPathFile
				
				' Get the current value of the WebFile object
				sEditVal = LCase(Browser(oAppBrowser).WebFile(oAppObj).GetROProperty("value"))
				
				'Verify the sInputPathFile was set
				If StrComp(sEditVal, LCase(sInputPathFile), 1) = 0 Then ' If sInputPathFile value was set
					webFileEnter = True ' Return Value
				Else ' sInputPathFile value was not set
					webFileEnter = False ' Return Value
				End If
			End If
		  
		Else ' Object Not Found
			webFileEnter = False ' Return Value
		End If
	   
	  ' Clear Object Variables
	  Set oAppBrowser = Nothing
	  Set oAppObj = Nothing
	  Set oFSO = Nothing
	  
	  Reporter.ReportEvent micDone, "webFileEnter", "Function End"
	  Services.EndTransaction "webFileEnter" ' Timer End
	
	End Function
	
	'<@comments>
	'**********************************************************************************************
	' <@name>webFileEnterWIndex</@name>
	'
	' <@purpose>
	'   To verify that the WebFile exists on current visible browser page using the index property, and if so,
	'		the sInputPathFile parameter is entered.
	'   Will check using the NAME Property value first then use the HTML ID Property
	'   If not found by the NAME Property
	' </@purpose>
	'
	' <@parameters>
	'     sNameOrHTMLIDProperty (ByVal) = String - Name or HTML ID of the WebFile to be verified
	'     sInputPathFile - (ByVal) string = name of the file to be used including the path
	'     iIndex (ByVal) = Integer - Index Property Value for WebFile to be verified
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'         True -  If found
	'         False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.webFileEnterWIndex("RcnFile", "C:\Temp\Test.txt", 0)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>04-04-2008</@creation_date>
	'
	' <@mod_block>
	' </@mod_block>
	' 
	'**********************************************************************************************
	'</@comments>
	Public Function webFileEnterWIndex(ByVal sNameOrHTMLIDProperty, ByVal sInputPathFile, ByVal iIndex) ' <@as> Boolean
	  
	  Services.StartTransaction "webFileEnterWIndex" ' Timer Begin
	  Reporter.ReportEvent micDone, "webFileEnterWIndex", "Function Begin"
	  
	  ' Variable Declaration / Initialization 
	  Dim oAppBrowser, oAppObj, oFSO, iDisabled, sEditVal
	  Dim bFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
	  If IsNull(sNameOrHTMLIDProperty) or sNameOrHTMLIDProperty = "" Or IsNull(sInputPathFile) or sInputPathFile = ""  Or IsNull(iIndex) or iIndex = "" Then
	  	Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the webFileEnterWIndex function check passed parameters"
	    webFileEnterWIndex = False ' Return Value
	    Services.EndTransaction "webFileEnterWIndex" ' Timer End
	    Exit Function
	  End If
	  
		' Create a FileySystemObject
		Set oFSO = CreateObject("Scripting.FileSystemObject")
	
		' Check the sInputPathFile File Exists, if it does not exit function
		If Not oFSO.FileExists(sInputPathFile) Then
			Reporter.ReportEvent micFail, "Invalid Parameter", "File '" & sInputPathFile & "' does not exist when using the webFileEnterWIndex function check passed parameters"
			webFileEnterWIndex = False ' Return Value
			Services.EndTransaction "webFileEnterWIndex" ' Timer End
			Exit Function
		End If
	
	  ' Description Object Declarations/Initializations
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
	  Set oAppObj = Description.Create()
	  oAppObj("micclass").Value = "WebFile"
	  oAppObj("name").Value = sNameOrHTMLIDProperty
	  oAppObj("index").Value = iIndex
	
	  ' Verification of the Object 
	  If Browser(oAppBrowser).WebFile(oAppObj).Exist(1) Then
	    bFound = True
	  Else ' check using the html id property
	  	oAppObj.Remove "name" ' Remove name property
	  	oAppObj("html id").Value = sNameOrHTMLIDProperty ' Add HTML ID Property
	  	If Browser(oAppBrowser).WebFile(oAppObj).Exist(1) Then
	  		bFound = True
	  	Else ' Not found
	  		bFound = False
	  	End If
	  End If
	  
		' Object Found set the value if enabled
		If bFound Then
			
			' Check to see if the WebFile is enabled
			iDisabled = Browser(oAppBrowser).WebFile(oAppObj).GetROProperty("disabled")
			
			If iDisabled = 1 Then
				Reporter.ReportEvent micFail, "'" & sNameOrHTMLIDProperty & "' WebFile", "The '" & sNameOrHTMLIDProperty & "' WebFile is disabled"
				webFileEnterWIndex = False ' Return Value
			Else ' WebFile Enabled
				Reporter.ReportEvent micPass, "'" & sNameOrHTMLIDProperty & "' WebFile", "The '" & sNameOrHTMLIDProperty & "' WebFile is enabled"
				
				' Set the WebFile
				Browser(oAppBrowser).WebFile(oAppObj).Set sInputPathFile
				
				' Get the current value of the WebFile object
				sEditVal = LCase(Browser(oAppBrowser).WebFile(oAppObj).GetROProperty("value"))
				
				'Verify the sInputPathFile was set
				If StrComp(sEditVal, LCase(sInputPathFile), 1) = 0 Then ' If sInputPathFile value was set
					webFileEnterWIndex = True ' Return Value
				Else ' sInputPathFile value was not set
					webFileEnterWIndex = False ' Return Value
				End If
			End If
		  
		Else ' Object Not Found
			webFileEnterWIndex = False ' Return Value
		End If
	   
	  ' Clear Object Variables
	  Set oAppBrowser = Nothing
	  Set oAppObj = Nothing
	  Set oFSO = Nothing
	  
	  Reporter.ReportEvent micDone, "webFileEnterWIndex", "Function End"
	  Services.EndTransaction "webFileEnterWIndex" ' Timer End
	
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>getTableRowCount</@name>
	'
	' <@purpose>
	'   To verify that the WebTable exists on current visible browser page
	'   and return the total number of rows
	' </@purpose>
	'
	' <@parameters>
	'    bHdrRow (ByVal) - Boolean Value (True\False)
	'                         True = Table to check has a header row
	'                         False = Table to check has no header row
	'    sHtmlID (ByVal) - String = HTML ID of webTable to check
	' </@parameters>
	'
	' <@return>
	'   Integer Value
	'            number of rows in the table - If found
	'            zero - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.getTableRowCount(True, "_dataGrid")</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>08-17-2006</@creation_date>
	'
	' <@mod_block>
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function getTableRowCount(ByVal bHdrRow, ByVal sHtmlID) ' <@as> Integer
	
	   Services.StartTransaction "getTableRowCount" ' Timer Begin
	   Reporter.ReportEvent micDone, "getTableRowCount", "Function Begin"
	
	   ' Variable Declaration / Initialization   
	   Dim oAppBrowser, oAppObj
	
	   ' Check to verify passed parameters that they are not null or an empty string
	   If IsNull(bHdrRow) or bHdrRow = "" or IsNull(sHtmlID) or sHtmlID = "" Then
	           Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the getTableRowCount function check passed parameters"
	           getTableRowCount = 0 ' Return Value
	           Services.EndTransaction "getTableRowCount" ' Timer End
	           Exit Function
	   End If
	
	   ' Description Object Declarations/Initializations
	   Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
	   Set oAppObj = Description.Create()
	   oAppObj("micclass").Value = "WebTable"
	   oAppObj("html id").Value = sHtmlID
	
	   ' Verification of the Object 
	   If Browser(oAppBrowser).WebTable(oAppObj).Exist(1) Then ' Check for WebTable
	       Select Case LCase(bHdrRow)
	                Case "true" ' If there is a header row get the rowcount from webtable and subtract 1 from total
	                        getTableRowCount = Browser(oAppBrowser).WebTable(oAppObj).RowCount - 1
	                Case "false" ' No Header row get the rowcount from webtable
	                        getTableRowCount = Browser(oAppBrowser).WebTable(oAppObj).RowCount
	                Case Else ' Invalid Parameter 
	                        Reporter.ReportEvent micFail, "Invalid Parameters", "No Select Case statement found for '" & bHdrRow & "'"
	                        getTableRowCount = 0
	       End Select
	   Else' WebTable Not found
	                Reporter.ReportEvent micFail, "WebTable", "WebTable was not found"
	                getTableRowCount = 0
	   End If
	   
	   ' Clear Object Variables
	   Set oAppBrowser = Nothing
	   Set oAppObj = Nothing
	
	   Reporter.ReportEvent micDone, "getTableRowCount", "Function End"
	   Services.EndTransaction "getTableRowCount" ' Timer End
	   
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>pageTitleCheck</@name>
	'
	' <@purpose>
	'   To verify Browser Page Title on the current visible browser page
	' </@purpose>
	'
	' <@parameters>
	'        sPageTitle (ByVal) = String - Title of the Browser Page
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'            True -  If found
	'            False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.pageTitleCheck("UBEditor Pro - Outpatient Calculator")</@example_usage>
	'
	' <@calls>util.browserStatus</@calls>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>11-15-2006</@creation_date>
	'
	' <@mod_block>
	'   02-28-2007 - MM - Added name of function to error messages where invalid parameters are passed
	'   10-22-2007 - MM - Added Transaction Timer Command
	'   01-30-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'   03-18-2008 - MM - Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	'   04-16-2008 - MM - Added Warning Message to display the page title found
	'                     if the page title is not correct
	'   09-02-2008 - MM - Added logic to use the util.browserStatus function
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function pageTitleCheck(ByVal sPageTitle) ' <@as> Boolean
	
		Services.StartTransaction "pageTitleCheck" ' Timer Begin
		Reporter.ReportEvent micDone, "pageTitleCheck", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, sTitle
		
		' Check to verify passed parameters that they are not null or an empty string
		If IsNull(sPageTitle) or sPageTitle = "" Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the pageTitleCheck function check passed parameters"
			pageTitleCheck = False ' Return Value
			Services.EndTransaction "pageTitleCheck" ' Timer End
			Exit Function
		End If
		
		' Description Object Declarations/Initializations
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
		
		' Will wait up to 10 seconds for Browser to get to a readyState		
		util.browserStatus(10)
		
		' Get the Application Page Title
		sTitle = Browser(oAppBrowser).GetROProperty("title")
		
		' Verification of the Page Title
		If StrComp(LCase(sTitle), LCase(sPageTitle), 1) = 0 Then
			pageTitleCheck = True ' Return Value
		Else ' Check Page Title using the Instr Function
			If InStr(1, LCase(sTitle), LCase(sPageTitle), 1) > 0 Then
				pageTitleCheck = True ' Return Value
			Else
				Reporter.ReportEvent micWarning, "Page Title", "Page Title do not match" _
				                                               & vbNewLine & "Expected: '" & sPageTitle & "'" _
				                                               & vbNewLine & "Found: '" & sTitle & "'"
				pageTitleCheck = False ' Return Value
			End If
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		
		Reporter.ReportEvent micDone, "pageTitleCheck", "Function End"
		Services.EndTransaction "pageTitleCheck" ' Timer End
	   
	End Function

	'<@comments>
	'**********************************************************************************************
	' <@name>copyrightCheck</@name>
	'
	' <@purpose>
	'   To verify copyright footer is on the current visible browser page
	' </@purpose>
	'
	' <@parameters>
	'   None
	' </@parameters>
	'        
	' <@return>
	'   Boolean Value (True/False)
	'            True -  If found
	'            False - If not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.copyrightCheck()</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>02-06-2008</@creation_date>
	'
	' <@mod_block>
	'   11-03-2008 - MM - Added Warning Reporter Message to show the expected copyright text that
	'                     was used in the method to locate the copyright webelement
	'   11-13-2008 - MM - Added Index Property Value and removed HTML Tag Property Value
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function copyrightCheck() ' <@as> Boolean
	
		Services.StartTransaction "copyrightCheck" ' Timer Begin
		Reporter.ReportEvent micDone, "copyrightCheck", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oCopyRight
		
		' Description Object Declarations/Initializations
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
		
    Set oCopyRight = Description.Create()
	  oCopyRight("micclass").Value = "WebElement"
	  oCopyRight("innertext").Value = "Copyright © 2001-2007 Ingenix\. All rights reserved\."
	  oCopyRight("index").Value = 0
		
		' Verification of the object
		If Browser(oAppBrowser).WebElement(oCopyRight).Exist(1) Then
		       copyrightCheck = True ' Return Value
		Else ' Copyright Not Found
		       copyrightCheck = False ' Return Value
		       Reporter.ReportEvent micWarning, "copyrightCheck", "Expected Copyright" & vbNewLine _
		                                                         & Replace(Browser(oAppBrowser).WebElement(oCopyright).GetTOProperty("innertext"), "\", "")
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oCopyRight = Nothing
		
		Reporter.ReportEvent micDone, "copyrightCheck", "Function End"
		Services.EndTransaction "copyrightCheck" ' Timer End
	   
	End Function
	
	'<@comments>
	'**********************************************************************************************
	' <@name>verifyWebTableVals</@name>
	'
	' <@purpose>
	'   To verify that the webtable exists and that the string value is found within
  '   the webtable contents
  ' </@purpose>
	'
	' <@parameters>
	'          sTableTextProperty (ByVal) = String - Text Property Value of the WebTable Object
	'          sTableName (ByVal) = String - Name of the WebTable
	'          sVerifyString (ByVal) = String - Value to verify within the WebTable Contents
	'          iColCheck (ByVal) = integer - WebTable Column number to check for contents
	'          iRowMaxCol (ByVal) = integer - WebTable Row number that has the highest number of columns for the table
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'              True -  If found
	'              False - If not found or other function errors
	' </@return>
	'   
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'  
	' <@example_usage>of.verifyWebTableVals("Flight Confirmation #", "Flight Confirmation" "Frankfurt to Zurich", 1, 3)</@example_usage>
	'
	' <@author>Mike Millgate</@author>
	'
	' <@creation_date>05-07-2008</@creation_date>
	'
	' <@mod_block>
	'   05-13-2008 - MM - Added new parameter (iRowMaxCol) and logic to go along with new parameter
	'	09-30-2011 - GOV - Added the property html id in case WebTable Object is not identified using property name
	' </@mod_block>
	' 
	'**********************************************************************************************
	'</@comments>
	Public Function verifyWebTableVals(ByVal sTableTextProperty, ByVal sTableName, ByVal sVerifyString, ByVal iColCheck, ByVal iRowMaxCol) ' <@as> Boolean
	
	   Services.StartTransaction "verifyWebTableVals" ' Timer Begin
	   Reporter.ReportEvent micDone, "verifyWebTableVals", "Function Begin"
	
	   ' Variable Declaration / Initialization
	   Dim oAppBrowser ' Browser Object
	   Dim oWebTable ' WebTable Object
	   Dim i ' For Loop Counter
	   Dim bFound ' For Loop Return Value
	   Dim aParams ' Array to hold passed parameter values and verify they are not null or empty strings
	   Dim sParam ' To hold each parameter in the For Loop
	
	   ' Check to verify passed parameters that they are not null or an empty string
	   aParams = Array(sTableTextProperty, sTableName, sVerifyString, iColCheck, iRowMaxCol)
	   For Each sParam In aParams
		   If IsNull(sParam) or sParam = "" Then
			   Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the verifyWebTableVals function check passed parameters"
	           verifyWebTableVals = False ' Return Value
	           Services.EndTransaction "verifyWebTableVals" ' Timer End
			   Exit Function
		   End If
	   Next
	
	   ' Check that the iColCheck and iRowMaxCol value is Numeric
	   If Not isNumeric(aParams(3)) or Not isNumeric(aParams(4)) Then
		   Reporter.ReportEvent micFail, "Invalid Parameters", "The iColCheck and iRowMaxCol Parameters must be numeric when passed to the verifyWebTableVals function check passed parameters"
		   verifyWebTableVals = False ' Return Value
		   Services.EndTransaction "verifyWebTableVals" ' Timer End
		   Exit Function
	   End If
	   
	   ' Description Object Declarations/Initializations
	   Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
	   ' create object for the WebTable
	   Set oWebTable = Description.Create()
	   oWebTable("MicClass").Value = "WebTable"
	   oWebTable("name").Value = sTableTextProperty
	   oWebTable("index").Value = 0 ' Using this to find the first instance of the table when there are multiple tables with the same property values
	
		' Verification of the Object
		bFound = False
		If Browser(oAppBrowser).WebTable(oWebTable).Exist(3) Then
			bFound = True
		Else ' check using the html id property
			oWebTable.Remove "name" ' Remove name property
			oWebTable("html id").Value = sTableTextProperty
			If Browser(oAppBrowser).WebTable(oWebTable).Exist(1) Then
				bFound = True
			Else ' Not found
				bFound = False
			End If
		End If
	   
	   ' Check for the existence of the sTableName webtable
	   If bFound Then
		   Reporter.ReportEvent micPass, "WebTable", "The '" & sTableName & "' WebTable was found"
		   
		   ' Check the number of rows is less than or equal to iRowMaxCol
		   Dim iRowCount
		   iRowCount = Browser(oAppBrowser).WebTable(oWebTable).RowCount
	
		   If Not ((iRowMaxCol > 0) And (iRowMaxCol <= iRowCount)) Then
		   	Reporter.ReportEvent micFail, "Invalid Parameters", "The iRowMaxCol Parameter must be between 1 and " & iRowCount & " when checking the '" & sTableName & "' WebTable in the verifyWebTableVals function check passed parameters"
		   	verifyWebTableVals = False ' Return Value
		   	Services.EndTransaction "verifyWebTableVals" ' Timer End
		   	Exit Function
		   End If	   	
	
		   ' Check the number of columns is greater than or equal to iColCheck
		   Dim iColCount ' WebTable Column Count
		   iColCount = Browser(oAppBrowser).WebTable(oWebTable).ColumnCount(iRowMaxCol)
	   
		   If Not ((iColCheck >= 1) and (iColCheck <= iColCount)) Then
			   Reporter.ReportEvent micFail, "Invalid Parameters", "The iColCheck Parameter must be between 1 and " & iColCount & " when checking the '" & sTableName & "' WebTable in the verifyWebTableVals function check passed parameters"
			   verifyWebTableVals = False ' Return Value
			   Services.EndTransaction "verifyWebTableVals" ' Timer End
			   Exit Function
		   End If
	
	     ' Loop through column iColCheck of each row of the webtable checking for the sVerifyString values
		   bFound = False ' Default For Loop Return Value
		   For i = 1 to Browser(oAppBrowser).WebTable(oWebTable).RowCount
			   If Instr(1, LCase(Browser(oAppBrowser).WebTable(oWebTable).GetCellData(i, iColCheck)), LCase(sVerifyString), 1) > 0 Then
				   bFound = True
				   Exit For ' Exit the For Loop
			   Else ' Keep checking each row, until end of table
				   bFound = False
			   End If
		   Next
	
		   ' Check to see if values were found
		   If bFound Then
			   verifyWebTableVals = True ' Return Value
		   Else
			   verifyWebTableVals = False ' Return Value
		   End If
	   Else ' WebTable Not found
		   Reporter.ReportEvent micFail, "WebTable", "The '" & sTableName & "' WebTable was not found"
		   verifyWebTableVals = False ' Return Value
	   End If
	   
	   ' Clear Object Variables
	   Set oAppBrowser = Nothing
	   Set oWebTable = Nothing
	
	   Reporter.ReportEvent micDone, "verifyWebTableVals", "Function End"
	   Services.EndTransaction "verifyWebTableVals" ' Timer End
																						 
	End Function
	
	'<@comments>	
	'***************************************************************************************************************************
	' <@name>webTableSearch</@name>
	'
	' <@purpose>
	'   Search a webtable in a web page
	' </@purpose>
	'
	' <@parameters>
	'   oWebTableID (ByVal) = html id value (if not available, use index value assigned by QTP)
	' </@parameters>
	'
	' <@return>
	'   Boolean value (true/false)
	'            	true -  if found
	'            	false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>
	'   of.webTableSearch("myWebTable")  '<=html id
	'   of.webTableSearch(4)             '<=QTP assigned index value
	' </@example_usage>
	'
	' Comments: Verify that counts on row and column to match with webtable object in report.
	'
	' <@author>Hung Nguyen</@author>
	'
	' <@creation_date>9/1/07</@creation_date>
	'
	' <@mod_block>
	'   03-18-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'                     Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	' </@mod_block>
	'
	'***************************************************************************************************************************
	'</@comments>
	Public Function webTableSearch(ByVal oWebTableID) ' <@as> Boolean
	
		Services.StartTransaction "webTableSearch" 'Timer Begin
		Reporter.ReportEvent micDone, "webTableSearch", "Function Begin"
		
		Dim oAppBrowser, oWebTable, iTotalRows, iTotalCols
	
		'---verify passed parameters are not empty
		If IsNull(oWebTableID) or oWebTableID = "" Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the webTableSearch function check passed parameters"
			webTableSearch=False
			Services.EndTransaction "webTableSearch" 'Timer End
			Exit function 
		End If
	
		'object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
		
		'---webtable obj
		Set oWebTable=description.Create
		oWebTable("micclass").value="WebTable"
		oWebTable("html tag").Value = "TABLE"
		
		' Build oWebTable Object based on oWebTableID parameter	
		If Not IsNumeric(oWebTableID) Then
			oWebTable("html id").value=oWebTableID
		Else
			oWebTable("index").value=oWebTableID
		End If
	
		'---verify if WebTable obj description exists
		If Browser(oAppBrowser).WebTable(oWebTable).Exist(2) Then
			iTotalRows=Browser(oAppBrowser).WebTable(oWebTable).RowCount ' Get Total Row Count
			iTotalCols=Browser(oAppBrowser).WebTable(oWebTable).ColumnCount(2) 'Get Total Column Count on row2	
			Reporter.ReportEvent micPass, "WebTable Object", "WebTable ID: " & oWebTableID & vbNewLine & "Total rows: " & iTotalRows & vbNewLine & "Total columns: " & iTotalCols
			webTableSearch = True ' Return Value
		Else ' WebTable Not Found
			Reporter.ReportEvent micFail, "WebTable Object", "WebTable ID: " & oWebTableID & " does not exist."
			webTableSearch = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oWebTable = Nothing
	
		Reporter.ReportEvent micDone, "webTableSearch", "Function End"
		Services.EndTransaction "webTableSearch" 'Timer End	
	
	End Function
	
	'<@comments>	
	'***************************************************************************************************************************
	' <@name>webTableAction</@name>
	'
	' <@purpose>
	'    1. Set value in edit fields (WebEdit obj) in a webtable
  '    2. Select an option in option lists (WebList obj) in a webtable (can select option 
	'    3. Click a link (Link obj) in a webtable
	'    4. Check/uncheck checkboxes (WebCheckBox obj) in a webtable
	' </@purpose>
	'
	' <@parameters>
	'   oWebTableID (ByVal) = html id value (if not available, use index value assigned by QTP)
	'   sAction (ByVal) = valid actions: set, select, click, check, and uncheck
	'   sFieldName (ByVal) = Object property 'name' (of WebEdit, WebList, or Link obj.)
	'                        semicolon separated if more than one field to set (WebEdit and WebList only!)
	'                        Object property 'html id' (of WebCheckBox obj.) semicolon separated if more than one field to set
	'   vSetValue (ByVal) = value to set semicolon separated if more than one value for WebEdit, WebList only!
	'                       use "null" for Link and WebCheckBox objects!
	' </@parameters>
	'
	' <@return>
	'   Boolean value (true/false)
	'            	true -  if found and item action is taken
	'            	false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created'
	'   Correct WebTable description - A MUST! (meaning: does the column and row counts match with the webtable you're about to perform an action?)
	' </@assumptions>
	'
	' <@example_usage>
	'   of.webTableAction(4,"set","TextField;TextField_0","0003T;mycode") OR WebTableAction(4,"set","TextField","0003T")
	'   of.webTableAction(4,"select","PropertySelection;PropertySelection_0;PropertySelection_1","yes;cpt;e/m") OR WebTableAction(4,"select","PropertySelection","yes")
	'   of.webTableAction("presentationDataList","click","00104","null")  '<=supply "null" value for parameter vSetValue for link obj
	'   of.webTableAction("codeList","check","0_0;1;2;3;4;5","null")  '<=supply "null" value for parameter vSetValue for checkbox obj
	' </@example_usage>
	'
	' Comments: None
	'
	' <@author>Hung Nguyen</@author>
	'
	' <@creation_date>9/1/07</@creation_date>
	'
	' <@mod_block>
	'   03-18-2008 - MM - Added logic to use the Environment Variable BROWSER_OBJ
	'                     instead of building new object.
	'                     Added ByVal References to the function parameters
	'                     Added Logic to Clear Object Variables to free memory
	' </@mod_block>
	'
	'***************************************************************************************************************************
	'</@comments>
	Public Function webTableAction(ByVal oWebTableID, ByVal sAction, ByVal sFieldName, ByVal vSetValue) ' <@as> Boolean
	
		Services.StartTransaction "webTableAction" 'Timer Begin
		Reporter.ReportEvent micDone, "webTableAction", "Function Begin"
		
		Dim args, arg, oAppBrowser, oWebTable, oDesc, arrFieldName, arrSetValue, fieldFound, valueCnt
		Dim row, columnCnt, col, childItem, sPropName, arrItemLists, itemList, isChecked, arrActions, validAction
		Dim action, fieldName, itemListFound, bChecked, iRowCnt, iColCnt
		
		'---verify passed parameters are not empty
		args=Array(oWebTableID,sAction,sFieldName,vSetValue)
		For each arg in args
			If isnull(arg) or arg="" Then
				Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the webTableAction function check passed parameters"
				webTableAction = False ' Return Value
				Services.EndTransaction "webTableAction" 'Timer End
				Exit function 
			End If
		Next
	
		'---validate actions
		arrActions=Array("set","select","click","check","uncheck")
		validAction=0
		For each action in arrActions
			If action=lcase(trim(sAction)) Then
				Reporter.ReportEvent micDone, "Validate Action", "Action '" &sAction &"' is a valid action."
				validAction=1
				Exit For
			End If
		Next
		If validAction<>1Then
			Reporter.ReportEvent micFail, "Validate Action", "Action '" &sAction &"' is not a valid action."
			WebTableAction = False ' Return Value
			Services.EndTransaction "webTableAction" 'Timer End
			Exit function 
		End If
	
		'object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
		
		'---webtable obj
		Set oWebTable=description.Create
		oWebTable("micclass").value="WebTable"
		
		' Build oWebTable Object based on oWebTableID parameter	
		If Not IsNumeric(oWebTableID) Then
			oWebTable("html id").value=oWebTableID
		Else
			oWebTable("index").value=oWebTableID
		End If
	
		'---verify if WebTable obj description exists
		If Browser(oAppBrowser).WebTable(oWebTable).Exist(2) Then
			iRowCnt=Browser(oAppBrowser).WebTable(oWebTable).RowCount
			iColCnt=Browser(oAppBrowser).WebTable(oWebTable).ColumnCount(2) 'count at row2 (header row)
			Reporter.ReportEvent micDone, "WebTable Object", "WebTable ID: " & oWebTableID & vbNewLine & "Total rows: " & iRowCnt & vbNewLine & "Total columns: " & iColCnt 
		Else ' WebTable Not Found
			Reporter.ReportEvent micFail, "WebTable Object", "WebTable ID: " & oWebTableID & " does not exist."
			WebTableAction = False ' Return Value
			Services.EndTransaction "webTableAction" 'Timer End
			Exit Function
		End If
		
		'---set action to obj type
		If lcase(trim(sAction))="set" Then oDesc="WebEdit"
		If lcase(trim(sAction))="select" Then oDesc="WebList"
		If lcase(trim(sAction))="click" Then oDesc="Link"
		If lcase(trim(sAction))="check" or lcase(trim(sAction))="uncheck" Then oDesc="WebCheckBox"
		
		'---build arguments array
		arrFieldName=split(sFieldName,";")
		arrSetValue=split(vSetValue,";")
	
		'---loop all cells in WebTable for obj. to perform action
		fieldFound=0
		valueCnt=0
		For each fieldName in arrFieldName
			For row=1 to iRowCnt
				columnCnt=Browser(oAppBrowser).WebTable(oWebTable).ColumnCount(row) 'count column at each row 
				For col=1 to columnCnt
					Set childItem=Nothing 
					Set childItem = Browser(oAppBrowser).WebTable(oWebTable).ChildItem(row, col,oDesc,0)
					 
					If Not childItem is Nothing Then 'if obj exists
						If sAction="check" or sAction="uncheck" Then  'if obj is WebCheckBox obj.
							sPropName="html id"
						Else 'WebEdit, WebList, Link objs.
							 sPropName="name"
						End if 
	   	
						If childItem.getroproperty( sPropName)=fieldName Then 'if field name exists
							If childItem.GetROProperty("disabled")=0 Then 'not disabled
								Select Case  lcase(trim(sAction)) 'perform action
									Case "set" 
										childItem.set arrSetValue(valueCnt)
		
										'verify result
										If childItem.GetROProperty("value")=arrSetValue(valueCnt) Then
											 Reporter.ReportEvent micPass,"Object", "Successfully " &sAction &" value " &arrSetValue(valueCnt)
											 valueCnt=valueCnt+1
										Else
											Reporter.ReportEvent micFail,"Object", "Failed to " &sAction &" value " &arrSetValue(valueCnt)
											WebTableAction = False ' Return Value
											Services.EndTransaction "webTableAction" 'Timer End
											Exit Function   																		
										End If									   								
									Case "select"
										arrItemLists=split(childItem.getroproperty("all items"),";")
										itemListFound=0
										For each itemList in arrItemLists
											If lcase(trim(itemList))=lcase(trim(arrSetValue(valueCnt))) Then 'if option exists in lists
												childItem.select itemList
												valueCnt=valueCnt+1
												itemListFound=1											
												Exit For
											End If
										Next
												
										'verify result
										If childItem.GetROProperty("value")=itemList Then
											 Reporter.ReportEvent micPass,"Object", "Successfully " &sAction &" option " &itemList
										Else
											Reporter.ReportEvent micFail,"Object", "Option " &itemList &" exists but failed to " &sAction
											WebTableAction = False ' Return Value
											Services.EndTransaction "webTableAction" 'Timer End
											Exit Function   																		
										End If											
	
										If itemListFound<>1Then
											Reporter.ReportEvent micFail,"Object", "Option " &lcase(trim(arrSetValue(valueCnt))) &" is invalid or does not exist."
											webTableAction = False ' Return Value
											Services.EndTransaction "webTableAction" 'Timer End
											Exit Function 											
										End If								   							
									Case "click" 
										childItem.click
										Reporter.ReportEvent micPass,"Object", "Successfully " &sAction &" the link " &fieldName
	
									Case "check" 
										If childItem.GetROProperty("checked")=0 Then 'not checked
											childItem.set "on"
	
											'verify result
											isChecked=Browser(oAppBrowser).WebTable(oWebTable).ChildItem(row,col,oDesc,0).GetROProperty("checked")
											
											If isChecked=1Then
												Reporter.ReportEvent micPass,"Object", "Successfully " &sAction &" the field " &fieldName &" checkbox."
											Else
												Reporter.ReportEvent micFail,"Object", "Checkbox " &fieldName &" exists but failed to " &sAction &" the checkbox."
												WebTableAction = False ' Return Value
												Services.EndTransaction "webTableAction" 'Timer End
												Exit Function   																		
											End If											   									
										Else 'already checked
											Reporter.ReportEvent micWarning,"Object", "Checkbox exists and is already checked."
										End If
	
									Case "uncheck" 
										If childItem.GetROProperty("checked")=1 Then 'checked
											childItem.set "off"
											
											'verify result
											isChecked=Browser(oAppBrowser).WebTable(oWebTable).ChildItem(row,col,oDesc,0).GetROProperty("checked")
	
											If isChecked=0 Then
												Reporter.ReportEvent micPass,"Object", "Successfully " &sAction &" the field " &fieldName &" checkbox."
												valueCnt=valueCnt+1
											Else
												Reporter.ReportEvent micFail,"Object", "Failed to " &sAction &" the field " &fieldName &" checkbox."
												WebTableAction = False ' Return Value
												Services.EndTransaction "webTableAction" 'Timer End
												Exit Function   																		
											End If											   									
										Else 'already unchecked
											Reporter.ReportEvent micWarning,"Object", "Checkbox exists and is already unchecked."
										End If
								End Select
								webTableAction = True ' Return Value
								fieldFound=1
								Exit For 'exit col							
							Else 'is disabled
								Reporter.ReportEvent micFail, "Object Action", "Field name " &fieldName &" exists but is currently disabled. Unable to perform action " &sAction
								webTableAction = False ' Return Value
								Services.EndTransaction "webTableAction" 'Timer End
								Exit Function 
							End If  			
						End If  	
					End if 
				Next 'col
				If fieldFound=1Then Exit For 'exit row
			Next 'row
	
			If fieldFound<>1Then
				Reporter.ReportEvent micFail,"Field Name", "Field " &fieldName &" is invalid or does not exist."
				webTableAction = False ' Return Value
			Else
				fieldFound=0 'reset
			End If 
		Next
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oWebTable = Nothing
	
		Reporter.ReportEvent micDone, "webTableAction", "Function End"
		Services.EndTransaction "webTableAction" 'Timer End
		
	End Function
	'<@comments>	
	'***************************************************************************************************************************
		Public Function WebTableStatus(ByVal HTMLID_Property)
	'***********************************************************************************************************
	'Purpose: Check the WebTable object status (e.g., disabled, active, inactive) via the 
	'                   object "outerhtml" property value
	'Parameters: HTMLID_Property = the object "html id" property value
	'Returns: string: disabled -  object is disabled
	'                              active - object is active
	'                              inactive - object is inactive
	'                             not exist - the object specified does not exist
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: sGetValue =of.WebTableStatus ("j_id29_shifted")
	'Created by: Suajtha Kandikonda 03/18/2011
	'***********************************************************************************************************
	Services.StartTransaction "WebTableStatus" ' Timer start
	  ' verify passed parameters are not empty strings
	  If HTMLID_Property = "" Then
			Reporter.ReportEvent micFail, "Invalid Parameter", "Parameter cannot be empty. Abort."
			WebTableStatus = "not exist" ' Return Value
			Services.EndTransaction "WebTableStatus" ' Timer End
			Exit Function
		End If
		
		Dim oAppBrowser,iStatus
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))
		
		'report
		If oAppBrowser.WebTable("html id:=" &HTMLID_Property).Exist(2) Then
			iStatus=oAppBrowser.WebTable("html id:=" &HTMLID_Property).GetROProperty("innerhtml")
			If Instr(1,iStatus,"rich-tab-active",1) Then
				WebTableStatus = "active"		'return value
			ElseIf Instr(1,iStatus,"rich-tab-inactive",1) Then
				WebTableStatus = "inactive"	'return value
			ElseIf Instr(1,iStatus,"rich-tab-disabled",1) Then
				WebTableStatus = "disabled"	'return value
			End If
		Else
			WebTableStatus = "not exist"	'return value
		End If
		Set oAppBrowser = Nothing
	Services.EndTransaction "WebTableStatus" ' Timer end
	End Function	
		'<@comments>	
	'***************************************************************************************************************************
	Public Function WebButtonStatus(ByVal HTMLID_Property)
	'**********************************************************************************************************************************
		'Purpose: Check the Webbutton object is enabled or disabled
	'                   object "disabled" property value
	'Parameters: HTMLID_Property = the object "html id" property value
	'Returns: '0' for enabled and '1' for disabled
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: btnstatus = of.WebButtonStatus ("intakeReviewintakeReviewDecisionForm:intReviewAcceptButton")
	'Created by: Sujatha Kandikonda 03/18/2011
	'Modified by: Govardhan Choletti 1/9/2012
				' Changed the reporting status to MicInfo <-- From MicPass, MicFail
	'*************************************************************************************************************************************
	Services.StartTransaction "WebButtonStatus" ' Timer start
	  ' verify passed parameters are not empty strings
	  If HTMLID_Property = "" Then
			Reporter.ReportEvent micFail, "Invalid Parameter", "Parameter cannot be empty. Abort."
			webElementStatus = "not exist" ' Return Value
			Services.EndTransaction "WebButtonStatus" ' Timer End
			Exit Function
		End If
		
		Dim oAppBrowser, oAppObj, iStatus, Btn_name, bFound
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))
		
		'sets the webbutton object.
	 	Set oAppObj = Description.Create()
	 	oAppObj("micclass").Value = "WebButton"
		oAppObj("html id").Value = HTMLID_Property
	
	 	' Verification of the Object
		If oAppBrowser.WebButton(oAppObj).Exist(1) Then 
			bFound = True
		Else ' Check using the NAME Property
			oAppObj.Remove "html id" ' Remove HTML ID Property
			oAppObj("name").Value = HTMLID_Property
			If oAppBrowser.WebButton(oAppObj).Exist(1) Then 
				bFound = True
			Else ' Not Found
				bFound = False
			End If
		End If
		
		'report
		If oAppBrowser.WebButton("html id:=" &HTMLID_Property).Exist(2) Then
			iStatus=oAppBrowser.WebButton("html id:=" &HTMLID_Property).GetROProperty("disabled")
			Btn_name = oAppBrowser.WebButton("html id:=" &HTMLID_Property).GetROProperty("name")
			If Instr(1,iStatus,0,1) Then
				WebButtonStatus = "active"		'return value
				Reporter.ReportEvent micInfo, "Web Button", "Web button '"&Btn_name& "' is enabled"
			ElseIf Instr(1,iStatus,1,1) Then
				WebButtonStatus = "inactive"	'return value
				Reporter.ReportEvent micInfo,  "Web Button", "Web button '"&Btn_name& "' is disabled"
			End If			
		Else
			WebButtonStatus= "not exist"	'return value
			Reporter.ReportEvent micFail, "Web Button", "Web button does not exist"
		End If
		Set oAppBrowser = Nothing
	Services.EndTransaction "WebButtonStatus" ' Timer end
	End Function	
	'<@comments>	
	'***************************************************************************************************************************
	Public Function Weblistcnt(ByVal sNameOrHTMLIDProperty, itemscnt)
'***************************************************************************************
		'Purpose: Verify that the Count of a weblist is same as expected
		'Parameter: ByVal sNameOrHTMLIDProperty -  Html Id property of weblist
		'						itemscnt -  count of weblist  items that need to be validated
		'Returns: True/False
		'Usage Example:of.Weblistcnt("commonSearchForm:projectStatusSearchValueList", 11)
		'Author: Sujatha Kandikonda 04/07/2011
'************************************************************************************************************************************************************
   	Dim oAppBrowser, oAppObj, cnt
			'sets the browser object.
		  Set oAppBrowser = Environment("BROWSER_OBJ") 

		 	Set oAppObj = Description.Create()
		  oAppObj("MicClass").Value = "WebList"
	    oAppObj("html id").Value = sNameOrHTMLIDProperty
	   
			 	If Browser(oAppBrowser).WebList(oAppObj).Exist(1) Then 
					 Reporter.ReportEvent 0, "WebList", "WebList"&weblistname&" does exist"
					cnt =Browser(oAppBrowser).WebList(oAppObj ).GetROProperty("items count")
				   If itemscnt = cnt Then
					  Reporter.ReportEvent 0, "Weblistcount", "Weblist count in the UI is as expected and is: "&cnt
					else
				        Reporter.ReportEvent 1, "Weblistcount", "Weblist count in the UI is not as expected  "
				   End If
				else
					Reporter.ReportEvent 1,  "WebList", "WebList"&weblistname&" does not exist"
				End If
		' Clear Object Variables
			Set oAppObj = Nothing
	End Function
	
'<@comments>	
'***************************************************************************************************************************
	Public Function webEditStatus(ByVal sNameOrHTMLIDProperty) 
'***************************************************************************************
		'Purpose: Verify whether web edit field is editable or not
		'Parameter: ByVal sNameOrHTMLIDProperty -  Html Id property of weblist
		'Returns: True/False
		'Usage Example:of.webEditStatus("editProjectDetailForm:projectCommentValue")
		'Author: Sujatha Kandikonda 07/11/2011
'***************************************************************************************************************************
	  Services.StartTransaction "webEditStatus" ' Timer Begin
		Reporter.ReportEvent micDone, "webEditStatus", "Function Begin"
		
		' Variable Declaration / Initialization 
	  Dim oAppBrowser, oAppObj
	  Dim bFound, iDisabled
	   	
	  'verifies that the passed parameter is not null or an empty string.
	  If IsNull(sNameOrHTMLIDProperty) Or sNameOrHTMLIDProperty = "" Then
	   	Reporter.ReportEvent micFail, "invalid parameter", "An invalid parameter was passed to the webEditEnter function check passed parameters"
	   webEditStatus = False ' Return Value
	   	Exit Function
	  End If
		'sets the browser object.
	  Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	   
	 	'sets the webedit object.
	 	Set oAppObj = Description.Create()
	 	oAppObj("micclass").Value = "WebEdit"
		oAppObj("html id").Value = sNameOrHTMLIDProperty
	
	  ' Verification of the Object
			If Browser(oAppBrowser).WebEdit(oAppObj).Exist(1) Then
				bFound = True
			Else ' Not Found
				bFound = False
			End If
		
		' Object Found set the value if enabled
		If bFound Then		
			' Check to see if the webedit is enabled
			iDisabled = Browser(oAppBrowser).webEdit(oAppObj).GetROProperty("disabled")
  	
				If iDisabled = 0 Then 'Web Edit is enabled
				 webEditStatus = True' Return Value
				Else								 ' Web Edit  disabled
        	    webEditStatus = False' Return Value	
			   End If
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		Set bFound = Nothing
		Set iDisabled = Nothing
		Reporter.ReportEvent micDone, "webEditStatus", "Function End"
		Services.EndTransaction "webEditStatus" ' Timer End	 
	End Function
	
	'<@comments>
	'**********************************************************************************************
	' <@name>VerifyWebTableColAllVals</@name>
	'
	' <@purpose>
	'   To verify that the webtable exists and that the string value is found in all the Rows for a particular 
	'   column Content
	' </@purpose>
	'
	' <@parameters>
	'          sTableName (ByVal) = String - Name of the WebTable
	'          sTableHtmlId (ByVal) = String - HTML ID Property Value of the WebTable Object
	'          sColName (ByVal) = String - WebTable Column Name as displayed
	'          sVerifyString (ByVal) = String - Value to verify within the WebTable Contents
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'              True -  If found
	'              False - If not found or other function errors
	' </@return>
	'   
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'  
	' <@example_usage>of.VerifyWebTableColAllVals("Project Information", "projectForm:projectTable" "Status", "InProgress")</@example_usage>
	'
	' <@author>Govardhan Choletti</@author>
	'
	' <@creation_date>19-09-2011</@creation_date>
	'
	' <@mod_block>
	'   Govardhan Choletti - Date '10/1/2012
	'		Added Code to validate the Column Header i.e available in any row of the table in UI
	'		Modified Code from micfail to Throw a Warning Message if the data available is Mismatched
	' </@mod_block>
	' 
	'**********************************************************************************************
	'</@comments>
	Public Function VerifyWebTableColAllVals(ByVal sTableName, ByVal sTableHtmlId, ByVal sColName, ByVal sVerifyString) ' <@as> Boolean
	
		Services.StartTransaction "VerifyWebTableColAllVals" ' Timer Begin
	    Reporter.ReportEvent micDone, "VerifyWebTableColAllVals", "Function Begin"
	
	   ' Variable Declaration / Initialization
		Dim oAppBrowser ' Browser Object
		Dim oWebTable ' WebTable Object
		Dim iColVal, iRowVal, iRowWise, iColReq, iRowReq ' For Loop Counter
		Dim bFound ' For Loop Return Value
		Dim aParams ' Array to hold passed parameter values and verify they are not null or empty strings
		Dim sParam, sActualValue ' To hold each parameter in the For Loop
		iColReq = 0

		' Check to verify passed parameters that they are not null or an empty string
		aParams = Array(sTableName, sTableHtmlId, sColName, sVerifyString)
		For Each sParam In aParams
			If IsNull(sParam) or sParam = "" Then
				Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the VerifyWebTableColAllVals function check passed parameters"
				VerifyWebTableColAllVals = False ' Return Value
				Services.EndTransaction "VerifyWebTableColAllVals" ' Timer End
				Exit Function
			End If
		Next
	   
	   ' Description Object Declarations/Initializations
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
	   ' create object for the WebTable
		Set oWebTable = Description.Create()
		oWebTable("MicClass").Value = "WebTable"
		oWebTable("html id").Value = sTableHtmlId
		oWebTable("index").Value = 0 ' Using this to find the first instance of the table when there are multiple tables with the same property values
	
	   ' Check for the existence of the sTableName webtable
		If Browser(oAppBrowser).WebTable(oWebTable).Exist(3) Then
			Reporter.ReportEvent micPass, "WebTable", "The '" & sTableName & "' WebTable was found"
		   
			' Check the number of rows is less than or equal to iRowMaxCol
			Dim iRowCount
			iRowCount = Browser(oAppBrowser).WebTable(oWebTable).RowCount
		
			' Check the Name of columns Exist in WebTable
			Dim iColCount ' WebTable Column Count
			iColCount = Browser(oAppBrowser).WebTable(oWebTable).ColumnCount(iRowCount-1)
			For iRowVal = 1 to iRowCount
				For iColVal = 1 to iColCount
					If Instr(1, LCase(Browser(oAppBrowser).WebTable(oWebTable).GetCellData(iRowVal, iColVal)), LCase(sColName), 1) = 1 Then
						iColReq = iColVal
						iRowReq = iRowVal
						Exit for
					End If
				Next
				If iColReq<>0 Then
					Exit for
				End If
			Next
	
	     ' Loop through column iRowWise of each row of the webtable checking for the sVerifyString values, if Not Found in any one column Fail it
		   bFound = False ' Default For Loop Return Value
		   For iRowWise = iRowReq to (Browser(oAppBrowser).WebTable(oWebTable).RowCount - 1)
			   sActualValue = LCase(Browser(oAppBrowser).WebTable(oWebTable).GetCellData(iRowWise, iColReq))
				If Instr(1, sActualValue, LCase(sVerifyString), 1) > 0 Then
					bFound = True
					Reporter.ReportEvent micPass, "WebTable", "Column Value '"& sActualValue &"' is available under Column '"&sColName&"' at Row : "& iRowWise &" , as Expected"
				ElseIf (iRowWise > 5 ) Then' Keep checking each row, until end of table
					bFound = False
					Reporter.ReportEvent micFail, "WebTable", "Column Value '"& sActualValue &"' is available instead of '"& sVerifyString &"' under Column '"&sColName&"' at Row : "& iRowWise &" , NOT as Expected"
					Exit For   ' Exiting For Loop as Data available in MisMatched
				Else ' Keep checking each row, until end of table
					bFound = False
					Reporter.ReportEvent micWarning, "WebTable", "Column Value '"& sActualValue &"' is available instead of '"& sVerifyString &"' under Column '"&sColName&"' at Row : "& iRowWise &" , NOT as Expected"
				End If
			Next
	
		   ' Check to see if values were found
		   If bFound Then
			   VerifyWebTableColAllVals = True ' Return Value
		   Else
			   VerifyWebTableColAllVals = False ' Return Value
		   End If
	   Else ' WebTable Not found
		   Reporter.ReportEvent micFail, "WebTable", "The '" & sTableName & "' WebTable was not found"
		   VerifyWebTableColAllVals = False ' Return Value
	   End If
	   
	   ' Clear Object Variables
	   Set oAppBrowser = Nothing
	   Set oWebTable = Nothing
	
	   Reporter.ReportEvent micDone, "VerifyWebTableColAllVals", "Function End"
	   Services.EndTransaction "VerifyWebTableColAllVals" ' Timer End
																						 
	End Function
	
	'<@comments>
	'**********************************************************************************************
	' <@name>objectFinder</@name>
	'
	' <@purpose>
	'   Verifies that the Object(Web Element, Link, Image, Text Box, List Box, CheckBox ) passed as input exists on current visible browser page
	'   Will check using the Object Property/properties and value, when passed as an Array
	'   Will also validate based on the value passed is a regular expression
	' </@purpose>
	'
	' <@parameters>
	'   sObject (ByVal) = String - "WebElement","Link","Image","WebTable","WebList","WebEdit".......
	'   sProperty (ByVal) = String - "innertext~html id"
	'   sValue (ByVal) = String - "Ingenix~corresponding Html ID"
	'  sRegularExpression(ByVal) = "True~False"
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            	true -  if found
	'            	false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.ObjectFinder("WebElement","innertext~html tag","© Copyright 2009 Ingenix ~TD","False~False")
	'				  of.ObjectFinder("Link","innertext","Click Here to Sign In","False")
	'</@example_usage>
	'
	' <@author>Govardhan Choletti</@author>
	'
	' <@creation_date>09-15-2008</@creation_date>
	'
	' <@mod_block>
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function objectFinder(ByVal sObject, ByVal sProperty, ByVal sValue, ByVal sRegularExpression) ' <@as> Boolean
		Services.StartTransaction "objectFinder" ' Timer Begin
		Reporter.ReportEvent micDone, "objectFinder", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj, i
		Dim aProperties, aValues, aRegularExpression, sRegEx, sMsgProperty, bObjFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
		If IsNull(sProperty) or sProperty = "" OR IsNull(sValue) or sValue = "" OR IsNull(sRegularExpression) or sRegularExpression = "" Then
			Reporter.ReportEvent micFail, "Invalid Parameter", "An invalid parameter was passed to the objectFinder function check passed parameters"
			objectFinder = False ' Return Value
			Services.EndTransaction "objectFinder" ' Timer End
			Exit Function
		End If

		aProperties = Split ( sProperty , "~")
		aValues = Split ( sValue , "~")
		aRegularExpression = Split ( sRegularExpression , "~")

		If UBound(aProperties) = UBound(aValues) And UBound(aProperties) = UBound(aRegularExpression) Then
			'	object declarations/initializations.
				Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
               	
			'  Create a Description Object
				Set oAppObj = Description.Create()
				If sObject = "Image" OR sObject = "Link" OR sObject = "WebButton" OR sObject = "WebCheckBox" OR sObject = "WebEdit" OR sObject = "WebElement" OR sObject = "WebList" OR sObject = "WebRadioGroup" OR sObject = "WebTable" Then
						oAppObj("MicClass").Value = sObject
						' Iterate thru Each property and set the corresponding Value
						For i = 0 to UBound(aProperties)
								If UCase(aRegularExpression(i)) = "TRUE" Then
										oAppObj(aProperties(i)).RegularExpression = True
								Else
										'adds a "\" before special characters.
										aValues(i) = Replace(Replace(Replace(Replace(aValues(i), "(", "\("), ")", "\)"), "?", "\?"), "$", "\$")
									'	oAppObj(aProperties(i)).RegularExpression = False
								End If
								oAppObj(aProperties(i)).Value = aValues(i)
								sMsgProperty = sMsgProperty&vbnewline&aProperties(i)&" : "&aValues(i)
						Next
						' Verification of the Object 
						bObjFound = False
						Select Case Ucase(sObject)
							Case "IMAGE"
								If Browser(oAppBrowser).Image(oAppObj).Exist(2) Then
									Browser(oAppBrowser).Image(oAppObj).Highlight
									bObjFound = True
								End If
							Case "LINK"
								If Browser(oAppBrowser).Link(oAppObj).Exist(2) Then
									Browser(oAppBrowser).Link(oAppObj).Highlight
									bObjFound = True
								End If
							Case "WEBBUTTON"
								If Browser(oAppBrowser).WebButton(oAppObj).Exist(2) Then
									Browser(oAppBrowser).WebButton(oAppObj).Highlight
									bObjFound = True
								End If
							Case "WEBCHECKBOX"
								If Browser(oAppBrowser).WebCheckBox(oAppObj).Exist(2) Then
									Browser(oAppBrowser).WebCheckBox(oAppObj).Highlight
									bObjFound = True
								End If
							Case "WEBEDIT"
								If Browser(oAppBrowser).WebEdit(oAppObj).Exist(2) Then
									Browser(oAppBrowser).WebEdit(oAppObj).Highlight
									bObjFound = True
								End If
							Case "WEBELEMENT"
								If Browser(oAppBrowser).WebElement(oAppObj).Exist(2) Then
									Browser(oAppBrowser).WebElement(oAppObj).Highlight
									bObjFound = True
								End If
							Case "WEBLIST"
								If Browser(oAppBrowser).WebList(oAppObj).Exist(2) Then
									Browser(oAppBrowser).WebList(oAppObj).Highlight
									bObjFound = True
								End If
							Case "WEBRADIOGROUP"
								If Browser(oAppBrowser).WebRadioGroup(oAppObj).Exist(2) Then
									Browser(oAppBrowser).WebRadioGroup(oAppObj).Highlight
									bObjFound = True
								End If
							Case "WEBTABLE"
								If Browser(oAppBrowser).WebTable(oAppObj).Exist(2) Then
									Browser(oAppBrowser).WebTable(oAppObj).Highlight
									bObjFound = True
								End If
							Case Else 
								msgbox "Send the Object Property"
						End Select
						If bObjFound Then
								Reporter.ReportEvent micInfo, "Object Finder", "An Object of type '"&sObject&"'  with properties "&sMsgProperty&vbnewline&" is found."
								objectFinder = True ' Return Value
						Else ' WebElement does not exist
							Reporter.ReportEvent micInfo, "Object Finder", "An Object of type '"&sObject&"'  with properties "&sMsgProperty&vbnewline&" is Not found."
							objectFinder = False ' Return Value
						End If
				Else
					' Clear Object Variables
						Set oAppBrowser = Nothing
						Set oAppObj = Nothing
						Reporter.ReportEvent micFail, "Invalid Object parameter", "An invalid parameter '"&sObject&"'  was passed to the objectFinder function, check passed parameters"
						objectFinder = False ' Return Value
				End If
		Else
				Reporter.ReportEvent micFail, "Invalid parameter Count", "An invalid Number of property or Value parameters are passed to the objectFinder function, check passed parameters"
				objectFinder = False ' Return Value
		End If
	
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "objectFinder", "Function End"
		Services.EndTransaction "objectFinder" ' Timer End
	End Function
	
	'<@comments>
	'**********************************************************************************************
	' <@name>objectAction</@name>
	'
	' <@purpose>
	'   Verifies that the Object(Web Element, Link, Image, Text Box, List Box, CheckBox ) passed as 
	'   input exists on current visible browser page and Performs the respective Action as supplied by the User
	'   Will check using the Object Property/properties and value, when passed as an Array
	'   Will also validate based on the value passed is a regular expression
	' </@purpose>
	'
	' <@parameters>
	'   sObject (ByVal) = String - "WebElement","Link","Image","WebTable","WebList","WebEdit".......
	'   sAction (ByVal) = String - "Set~UserName"
	'   sProperty (ByVal) = String - "innertext~html id"
	'   sValue (ByVal) = String - "Ingenix~corresponding Html ID"
	'  sRegularExpression(ByVal) = "True~False"
	' </@parameters>
	'
	' <@return>
	'   boolean value (true/false)
	'            	true -  if found
	'            	false - if not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'
	' <@example_usage>of.objectAction("WebElement","Click","innertext~html tag","© Copyright 2009 Ingenix ~TD","False~False")
	'				  of.objectAction("Link","Click","innertext","Click Here to Sign In","False")
	'				  of.objectAction("WebEdit","Set~Username","html id","loginForm:usrNameValue","False")
	'</@example_usage>
	'
	' <@author>Govardhan Choletti</@author>
	'
	' <@creation_date>10-05-2011</@creation_date>
	'
	' <@mod_block>
	' Govardhan Choletti - 09/21/2012 - Added additional properties 'All items', 'Items count' to be fetched thru GetRoProperty 
	' Govardhan Choletti - 09/21/2012 - Removed .Highlight method to stop highlighting the object in application as it consumes lot of time
	' Govardhan Choletti - 03/06/2012 - Added additional properties 'innerhtml' to be fectched
	' </@mod_block>
	'
	'**********************************************************************************************
	'</@comments>
	Public Function objectAction(ByVal sObject, ByVal sAction, ByVal sProperty, ByVal sValue, ByVal sRegularExpression) ' <@as> Boolean
		Services.StartTransaction "objectAction" ' Timer Begin
		Reporter.ReportEvent micDone, "objectAction", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj, oWebObj, i
		Dim aAction, aProperties, aValues, aRegularExpression, sRegEx, sMsgProperty, bObjFound
	
	  ' Check to verify passed parameters that they are not null or an empty string
		If IsNull(sProperty) or sProperty = "" OR IsNull(sAction) or sAction = "" OR IsNull(sValue) or sValue = "" OR IsNull(sRegularExpression) or sRegularExpression = "" Then
			Reporter.ReportEvent micFail, "Invalid Parameter", "An invalid parameter was passed to the objectAction function check passed parameters"
			objectAction = False ' Return Value
			Services.EndTransaction "objectAction" ' Timer End
			Exit Function
		End If

		aAction = Split ( sAction , "~")
		aProperties = Split ( sProperty , "~")
		aValues = Split ( sValue , "~")
		aRegularExpression = Split ( sRegularExpression , "~")

		If UBound(aProperties) = UBound(aValues) And UBound(aProperties) = UBound(aRegularExpression) Then
			'	object declarations/initializations.
				Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
               	
			'  Create a Description Object
				Set oAppObj = Description.Create()
				If sObject = "Image" OR sObject = "Link" OR sObject = "WebButton" OR sObject = "WebCheckBox" OR sObject = "WebEdit" OR sObject = "WebElement" OR sObject = "WebList" OR sObject = "WebRadioGroup" OR sObject = "WebTable" Then
						oAppObj("MicClass").Value = sObject
						' Iterate thru Each property and set the corresponding Value
						For i = 0 to UBound(aProperties)
								If UCase(aRegularExpression(i)) = "TRUE" Then
										oAppObj(aProperties(i)).RegularExpression = True
								Else
										'adds a "\" before special characters.
										aValues(i) = Replace(Replace(Replace(Replace(aValues(i), "(", "\("), ")", "\)"), "?", "\?"), "$", "\$")
									'	oAppObj(aProperties(i)).RegularExpression = False
								End If
								oAppObj(aProperties(i)).Value = aValues(i)
								sMsgProperty = sMsgProperty&vbnewline&aProperties(i)&" : "&aValues(i)
						Next
						' Verification of the Object 
						bObjFound = False
						Select Case Ucase(sObject)
							Case "IMAGE"
								If Browser(oAppBrowser).Image(oAppObj).Exist(2) Then
									'Browser(oAppBrowser).Image(oAppObj).Highlight
									Set oWebObj = Browser(oAppBrowser).Image(oAppObj)
									bObjFound = True
								End If
							Case "LINK"
								If Browser(oAppBrowser).Link(oAppObj).Exist(2) Then
									'Browser(oAppBrowser).Link(oAppObj).Highlight
									Set oWebObj = Browser(oAppBrowser).Link(oAppObj)
									bObjFound = True
								End If
							Case "WEBBUTTON"
								If Browser(oAppBrowser).WebButton(oAppObj).Exist(2) Then
									'Browser(oAppBrowser).WebButton(oAppObj).Highlight
									Set oWebObj = Browser(oAppBrowser).WebButton(oAppObj)
									bObjFound = True
								End If
							Case "WEBCHECKBOX"
								If Browser(oAppBrowser).WebCheckBox(oAppObj).Exist(2) Then
									'Browser(oAppBrowser).WebCheckBox(oAppObj).Highlight
									Set oWebObj = Browser(oAppBrowser).WebCheckBox(oAppObj)
									bObjFound = True
								End If
							Case "WEBEDIT"
								If Browser(oAppBrowser).WebEdit(oAppObj).Exist(2) Then
									'Browser(oAppBrowser).WebEdit(oAppObj).Highlight
									Set oWebObj = Browser(oAppBrowser).WebEdit(oAppObj)
									bObjFound = True
								End If
							Case "WEBELEMENT"
								If Browser(oAppBrowser).WebElement(oAppObj).Exist(2) Then
									'Browser(oAppBrowser).WebElement(oAppObj).Highlight
									Set oWebObj = Browser(oAppBrowser).WebElement(oAppObj)
									bObjFound = True
								End If
							Case "WEBLIST"
								If Browser(oAppBrowser).WebList(oAppObj).Exist(2) Then
									'Browser(oAppBrowser).WebList(oAppObj).Highlight
									Set oWebObj = Browser(oAppBrowser).WebList(oAppObj)
									bObjFound = True
								End If
							Case "WEBRADIOGROUP"
								If Browser(oAppBrowser).WebRadioGroup(oAppObj).Exist(2) Then
									'Browser(oAppBrowser).WebRadioGroup(oAppObj).Highlight
									Set oWebObj = Browser(oAppBrowser).WebRadioGroup(oAppObj)
									bObjFound = True
								End If
							Case "WEBTABLE"
								If Browser(oAppBrowser).WebTable(oAppObj).Exist(2) Then
									'Browser(oAppBrowser).WebTable(oAppObj).Highlight
									Set oWebObj = Browser(oAppBrowser).WebTable(oAppObj)
									bObjFound = True
								End If
							Case Else 
								msgbox "Send the Object Property"
						End Select
						If bObjFound Then
							Reporter.ReportEvent micInfo, "Object Finder", "An Object of type '"&sObject&"'  with properties "&sMsgProperty&vbnewline&" is found."
							If aAction(0) = "Click" OR aAction(0) = "Set" OR aAction(0) = "Select" OR aAction(0) = "Type" OR aAction(0) = "GetRoProperty" Then
								Select Case Ucase(aAction(0))
									Case "CLICK"
										oWebObj.Click
										objectAction = True ' Return Value
									Case "SET"
										oWebObj.Set aAction(1)
										objectAction = True ' Return Value
									Case "TYPE"
										oWebObj.Type aAction(1)
										objectAction = True ' Return Value
									Case "SELECT"
										oWebObj.Select aAction(1)
										objectAction = True ' Return Value
									Case "GETROPROPERTY"
										If aAction(1) = "innertext" OR aAction(1) = "html id" OR aAction(1) = "html tag" OR aAction(1) = "name" OR aAction(1) = "value" OR aAction(1) = "visible" OR aAction(1) = "disabled" OR aAction(1) = "checked" OR aAction(1) = "all items" OR aAction(1) = "items count" OR aAction(1) = "innerhtml" Then
											Select Case Ucase(aAction(1))
												Case "INNERTEXT"
													objectAction = oWebObj.GetROProperty("innertext") 	' Return Value
												Case "HTML ID"
													objectAction = oWebObj.GetROProperty("html id") ' Return Value
												Case "HTML TAG"
													objectAction = oWebObj.GetROProperty("html tag") ' Return Value
												Case "NAME"
													objectAction = oWebObj.GetROProperty("name") ' Return Value
												Case "VALUE"
													objectAction = oWebObj.GetROProperty("value") ' Return Value
												Case "VISIBLE"
													objectAction = oWebObj.GetROProperty("visible") ' Return Value
												Case "DISABLED"
													objectAction = oWebObj.GetROProperty("disabled") ' Return Value
												Case "CHECKED"
													objectAction = oWebObj.GetROProperty("checked") ' Return Value
												Case "ALL ITEMS"
													objectAction = oWebObj.GetROProperty("all items") ' Return Value
												Case "ITEMS COUNT"
													objectAction = oWebObj.GetROProperty("items count") ' Return Value
												Case "INNERHTML"
													objectAction = oWebObj.GetROProperty("innerhtml") ' Return Value
												Case Else
													msgbox "Send the Action Property"
											End Select
										Else ' Pass Action command say Set~Hello
											Reporter.ReportEvent micFail, "Invalid Action parameter", "An invalid parameter '"&sAction&"'  was passed to the objectAction function, check passed parameters"
											objectAction = False ' Return Value
										End If	
									Case Else 
										msgbox "Send the Action Property"
								End Select
							Else ' Pass Action command say Set~Hello
								Reporter.ReportEvent micFail, "Invalid Action parameter", "An invalid parameter '"&sAction&"'  was passed to the objectAction function, check passed parameters"
								objectAction = False ' Return Value
							End If					
						Else ' WebElement does not exist
							Reporter.ReportEvent micInfo, "Object Finder", "An Object of type '"&sObject&"'  with properties "&sMsgProperty&vbnewline&" is Not found."
							objectAction = False ' Return Value
						End If
				Else
					Reporter.ReportEvent micFail, "Invalid Object parameter", "An invalid parameter '"&sObject&"'  was passed to the objectAction function, check passed parameters"
					objectAction = False ' Return Value
				End If
		Else
			Reporter.ReportEvent micFail, "Invalid parameter Count", "An invalid Number of property or Value parameters are passed to the objectAction function, check passed parameters"
			objectAction = False ' Return Value
		End If
			
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		Set oWebObj = Nothing
		
		Reporter.ReportEvent micDone, "objectAction", "Function End"
		Services.EndTransaction "objectAction" ' Timer End
	End Function
	
	'<@comments>
	'***************************************************************************************************************************
	Public Function verifyWebTableSort(sWebTableHtmlIDorName, sColumnName, iRowPosition, sSortType, sDataType)
	'************************************************************************************************************************************************************
	'Purpose: ChartSync - Verify column Data in WebTable is sorted in ascending or descending as specified by user
	'Parameters: sWebTableHtmlIDorName = string - HTML ID (or) Name Property of Webtable
	'            sColumnName = string - Column Header in WebTable
	'            iRowPosition = integer - Row Position of corresponding Header in WebTable 
	'            sSortType = ASC or DESC - Sorting Technique to be evaluated on the corresponding column passed as input
	'			 sDataType = NUM or STR - Mode of Sort Comparison i.e, Numeric or String
	'Returns: True/False
	'Usage: of.verifyWebTableSort("cvQAcurrentReviewForm:cvQAreviewCurrentTable","CVQA Auditor",2,"DESC", "STR")	'start from row2
	'       of.verifyWebTableSort("cvQAcurrentReviewForm:cvQAreviewCurrentTable","Status",2,"ASC", "NUM")	'aHeader is an array	'start from row2
	'Created by: Govardhan Choletti 11/09/11
	'Modified by: Govardhan Choletti 01/09/2012, 02/09/2012
				' While Verifying the Date Field converting Date from MM/DD/YYYY --> YYYY/MM/DD and Validating it
				' Validated Date Field even if it contains any extra string appended to it
				' Another Parameter added to Sort to Verify the Datatype need to be Validate
	'************************************************************************************************************************************************************
		Services.StartTransaction "verifyWebTableSort"
		Reporter.ReportEvent micDone, "verifyWebTableSort", "Function Begin"

		' Variable Declaration / Initialization
		Dim oAppBrowser ' Browser Object
		Dim oWebTable ' WebTable Object
	    Dim i,j ' For Loop Counter
		Dim bFound, bColFound ' For Loop Return Value
	    Dim aParams ' Array to hold passed parameter values and verify they are not null or empty strings
	    Dim sParam ' To hold each parameter in the For Loop
		Dim sColVal 'To Store WebTable Header Value
		Dim sColValCurr,sColValNext ' To Store WebTable Current and Next Column Values
		Dim aColValCurr, aColValNext ' To check for Date Format
	
	' Check to verify passed parameters that they are not null or an empty string
		aParams = Array(sWebTableHtmlIDorName, sColumnName, iRowPosition, sSortType, sDataType)
		For Each sParam In aParams
			If IsNull(sParam) or sParam = "" Then
				Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the verifyWebTableSort function, Check passed parameters"
				verifyWebTableSort = False ' Return Value
				Services.EndTransaction "verifyWebTableSort" ' Timer End
				Exit Function
			End If
		Next
	
	   ' Check that the iRowPosition value is Numeric
		If Not isNumeric(aParams(2)) Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "The iRowPosition Parameters must be numeric when passed to the verifyWebTableSort function check passed parameters"
			verifyWebTableSort = False ' Return Value
			Services.EndTransaction "verifyWebTableSort" ' Timer End
			Exit Function
		End If
		
		' Check that Sort Type Values when passed as Input
		If Not (UCase(sSortType) = "ASC" OR UCase(sSortType) = "DESC") Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "The sSortType Parameters must be either 'ASC' or 'DESC' when passed to the verifyWebTableSort function check passed parameters"
			verifyWebTableSort = False ' Return Value
			Services.EndTransaction "verifyWebTableSort" ' Timer End
			Exit Function
		End If
		
		' Check that Data Type Values when passed as Input
		If Not (UCase(sDataType) = "NUM" OR UCase(sDataType) = "STR") Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "The sDataType Parameters must be either 'NUM' or 'STR' when passed to the verifyWebTableSort function check passed parameters"
			verifyWebTableSort = False ' Return Value
			Services.EndTransaction "verifyWebTableSort" ' Timer End
			Exit Function
		End If
	   
	   ' Description Object Declarations/Initializations
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
	   ' create object for the WebTable
		Set oWebTable = Description.Create()
		oWebTable("MicClass").Value = "WebTable"
		oWebTable("name").Value = sWebTableHtmlIDorName
	  ' oWebTable("index").Value = 0 ' Using this to find the first instance of the table when there are multiple tables with the same property values
		
		' Verification of the Object
		bFound = False
		If Browser(oAppBrowser).WebTable(oWebTable).Exist(3) Then
			Browser(oAppBrowser).WebTable(oWebTable).Highlight
			bFound = True
		Else ' check using the html id property
			oWebTable.Remove "name" ' Remove name property
			oWebTable("html id").Value = sWebTableHtmlIDorName
			If Browser(oAppBrowser).WebTable(oWebTable).Exist(1) Then
				bFound = True
			Else ' Not found
				bFound = False
			End If
		End If
	   
	   ' Check for the existence of the sTableName webtable
		If bFound Then
			Reporter.ReportEvent micPass, "WebTable", "The WebTable with HTML ID or NAME : "& sWebTableHtmlIDorName &" is found in Application"
		   
		   ' Check the number of rows is less than or equal to iHeaderPosition
			Dim iRowCount
			iRowCount = (Browser(oAppBrowser).WebTable(oWebTable).RowCount - 1)
	
			If Not ((iRowPosition > 0) And (iRowPosition <= iRowCount)) Then
				Reporter.ReportEvent micFail, "Invalid Parameters", "The Row Position Parameter passed '"& iRowPosition &"' must be between 1 and " & iRowCount & " when checking the WebTable in the verifyWebTableSort function check passed parameters"
				verifyWebTableSort = False ' Return Value
				Services.EndTransaction "verifyWebTableSort" ' Timer End
				Exit Function
			End If	   	
	
		   ' get the number of columns for the particular Row passed as input and get Column Position for the Column Name passed as Input
			Dim iColCount, icolPosition ' WebTable Column Count
			iColCount = Browser(oAppBrowser).WebTable(oWebTable).ColumnCount(iRowPosition)

			' Loop through column iColCount of particular row of the webtable checking for the Column Name, which is passed as Input
			bColFound = False ' Default For Loop Return Value
			For i = 1 to iColCount
				sColVal = Browser(oAppBrowser).WebTable(oWebTable).GetCellData(iRowPosition, i)
				If Instr(1, LCase(sColVal), LCase(sColumnName), 1) > 0 Then
					Reporter.ReportEvent micPass, "verifyWebTableSort", "WebTable Contains the Column Name '"&sColVal&"' at position : "&i&" as Expected"
					icolPosition = i
					bColFound = True
					Exit For
			   End If
		   Next
	
		   ' Check the Values are in Sorted as specified by user
			If bColFound Then
				sColValCurr = Browser(oAppBrowser).WebTable(oWebTable).GetCellData(iRowPosition + 1, icolPosition)
				' In order to Validate the Date Format converting MM/DD/YYYY --> YYYY/MM/DD
				aColValCurr = Split(sColValCurr,"/")
				If UBound(aColValCurr) = 2 Then		'And Len(sColValCurr) = 10 Then
					sColValCurr = Left(aColValCurr(2), 4)&"/"&aColValCurr(0)&"/"&aColValCurr(1)
				End If
				For j = iRowPosition + 2 to iRowCount
					sColValNext = Browser(oAppBrowser).WebTable(oWebTable).GetCellData(j, icolPosition)
				' In order to Validate the Date Format converting MM/DD/YYYY --> YYYY/MM/DD
					aColValNext = Split(sColValNext,"/")
					If UBound(aColValNext) = 2 Then 	'And Len(sColValNext) = 10 Then
						sColValNext = Left(aColValNext(2), 4)&"/"&aColValNext(0)&"/"&aColValNext(1)
					End If
					Select Case UCASE(TRIM(sSortType))
						Case "ASC"
							If sDataType = "STR" Then
								If StrComp(sColValCurr, sColValNext, 1) <= 0 Then
									Reporter.ReportEvent micPass, "verifyWebTableSort - STRING COMPARISON", "WebTable, When Sorted in Ascending Contains the Value '"&sColValCurr&"' at position : "&(j-1)&" and '"&sColValNext&"' at position : "&j&" as Expected"
								ElseIf (j = iRowPosition + 2) And (sWebTableHtmlIDorName = "projectForm:projectTable")Then
									Reporter.ReportEvent micWarning, "verifyWebTableSort - STRING COMPARISON", "WebTable, When Sorted in Ascending Contains the Value '"&sColValCurr&"' at position : "&(j-1)&" and '"&sColValNext&"' at position : "&j&" as Expected, Needs to verify Once Manually"
								Else
									Reporter.ReportEvent micFail, "verifyWebTableSort - STRING COMPARISON", "WebTable, When Sorted in Ascending doesn't Contains the Value '"&sColValNext&"' at position : "&(j-1)&" and '"&sColValCurr&"' at position : "&j&", which is NOT as Expected"
									bColFound = False
								End If
							ElseIf sDataType = "NUM" Then
								If sColValCurr <> "" And sColValNext <> "" Then
									If CInt(sColValCurr) <= CInt(sColValNext) OR (sColValCurr = "" AND sColValNext = "") OR (sColValCurr = "" AND sColValNext <> "") Then
										Reporter.ReportEvent micPass, "verifyWebTableSort - NUMERIC COMPARISON", "WebTable, When Sorted in Ascending Contains the Value '"&sColValCurr&"' at position : "&(j-1)&" and '"&sColValNext&"' at position : "&j&" as Expected"
									ElseIf (j = iRowPosition + 2) And (sWebTableHtmlIDorName = "projectForm:projectTable")Then
										Reporter.ReportEvent micWarning, "verifyWebTableSort - NUMERIC COMPARISON", "WebTable, When Sorted in Ascending Contains the Value '"&sColValCurr&"' at position : "&(j-1)&" and '"&sColValNext&"' at position : "&j&" as Expected, Needs to verify Once Manually"
									Else
										Reporter.ReportEvent micFail, "verifyWebTableSort - NUMERIC COMPARISON", "WebTable, When Sorted in Ascending doesn't Contains the Value '"&sColValNext&"' at position : "&(j-1)&" and '"&sColValCurr&"' at position : "&j&", which is NOT as Expected"
										bColFound = False
									End If
								Else
									Reporter.ReportEvent micWarning, "verifyWebTableSort - NUMERIC COMPARISON", "WebTable, When Sorted in Ascending Contains the Value '"&sColValCurr&"' at position : "&(j-1)&" and '"&sColValNext&"' at position : "&j&", cann't be compared"
								End If	
							End If
						Case "DESC"
							If sDataType = "STR" Then
								If StrComp(sColValCurr, sColValNext, 1) >= 0 Then
									Reporter.ReportEvent micPass, "verifyWebTableSort - STRING COMPARISON", "WebTable, When Sorted in Descending Contains the Value '"&sColValCurr&"' at position : "&(j-1)&" and '"&sColValNext&"' at position : "&j&" as Expected"
								ElseIf (j = iRowPosition + 2) And (sWebTableHtmlIDorName = "projectForm:projectTable")Then
									Reporter.ReportEvent micWarning, "verifyWebTableSort - STRING COMPARISON", "WebTable, When Sorted in Descending Contains the Value '"&sColValCurr&"' at position : "&(j-1)&" and '"&sColValNext&"' at position : "&j&" as Expected, Needs to Verify Once Manually"
								Else
									Reporter.ReportEvent micFail, "verifyWebTableSort - STRING COMPARISON", "WebTable, When Sorted in Descending doesn't Contains the Value '"&sColValNext&"' at position : "&(j-1)&" and '"&sColValCurr&"' at position : "&j&", which is NOT as Expected"
									bColFound = False
								End If
							ElseIf sDataType = "NUM" Then
								If sColValCurr <> "" And sColValNext <> "" Then
									If CInt(sColValCurr) >= CInt(sColValNext) OR (sColValCurr = "" AND sColValNext = "") OR (sColValCurr <> "" AND sColValNext = "") Then
										Reporter.ReportEvent micPass, "verifyWebTableSort - NUMERIC COMPARISON", "WebTable, When Sorted in Descending Contains the Value '"&sColValCurr&"' at position : "&(j-1)&" and '"&sColValNext&"' at position : "&j&" as Expected"
									ElseIf (j = iRowPosition + 2) And (sWebTableHtmlIDorName = "projectForm:projectTable")Then
										Reporter.ReportEvent micWarning, "verifyWebTableSort - NUMERIC COMPARISON", "WebTable, When Sorted in Descending Contains the Value '"&sColValCurr&"' at position : "&(j-1)&" and '"&sColValNext&"' at position : "&j&" as Expected, Needs to Verify Once Manually"
									Else
										Reporter.ReportEvent micFail, "verifyWebTableSort - NUMERIC COMPARISON", "WebTable, When Sorted in Descending doesn't Contains the Value '"&sColValNext&"' at position : "&(j-1)&" and '"&sColValCurr&"' at position : "&j&", which is NOT as Expected"
										bColFound = False
									End If
								Else
									Reporter.ReportEvent micWarning, "verifyWebTableSort - NUMERIC COMPARISON", "WebTable, When Sorted in Descending Contains the Value '"&sColValCurr&"' at position : "&(j-1)&" and '"&sColValNext&"' at position : "&j&", cann't be compared"
								End If	
							End If
					End Select
					sColValCurr = sColValNext
				Next
			End If
			
			' If Sorting is verified as expected
			If bColFound Then
				verifyWebTableSort = True ' Return Value
			Else
				verifyWebTableSort = False ' Return Value
			End If
		Else  ' WebTable Not found
			Reporter.ReportEvent micFail, "WebTable", "The WebTable with HTML ID or NAME : "& sWebTableHtmlIDorName &" was not found in Application"
			verifyWebTableSort = False ' Return Value
		End If
	   
	   ' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oWebTable = Nothing
		Services.EndTransaction "verifyWebTableSort"
	End Function
	
	'<@comments>
	'**********************************************************************************************
	' <@name>verifyWebTableHeader</@name>
	'
	' <@purpose>
	'   To verify that the webtable Header exists as Specified
	' </@purpose>
	'
	' <@parameters>
	'          sTableNameorHtmlIDProperty(ByVal) = String - Text Property Value of the WebTable Object
	'          sTableName (ByVal) = String - Name of the WebTable
	'          aHeaderData (ByVal) = String - Array Values to verify the Header Content
	'          iHeaderPosition (ByVal) = integer - WebTable Header Position in WebTable
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'              True -  If found
	'              False - If not found or other function errors
	' </@return>
	'   
	' <@assumptions>
	'   Environment Variable "BROWSER_OBJ" has been initialized/created
	' </@assumptions>
	'  
	' <@example_usage>of.verifyWebTableHeader("Flight Confirmation #", "Flight Confirmation" ,Array("A","B","C"), 1)</@example_usage>
	'
	' <@author>Govardhan Choletti</@author>
	'
	' <@creation_date>11-04-2011</@creation_date>
	'
	' <@mod_block>
	'  
	' </@mod_block>
	' 
	'**********************************************************************************************
	'</@comments>
	Public Function verifyWebTableHeader(ByVal sTableNameorHtmlIDProperty, ByVal sTableName, ByVal aHeaderData, ByVal iHeaderPosition) ' <@as> Boolean
	
		Services.StartTransaction "verifyWebTableHeader" ' Timer Begin
		Reporter.ReportEvent micDone, "verifyWebTableHeader", "Function Begin"

		' Variable Declaration / Initialization
		Dim oAppBrowser ' Browser Object
		Dim oWebTable ' WebTable Object
	    Dim i ' For Loop Counter
		Dim bFound ' For Loop Return Value
	    Dim aParams ' Array to hold passed parameter values and verify they are not null or empty strings
	    Dim sParam ' To hold each parameter in the For Loop
		Dim sColVal 'To Store WebTable Cell Value
	
	   ' Check to verify passed parameters that they are not null or an empty string
		aParams = Array(sTableNameorHtmlIDProperty, sTableName, Join(aHeaderData,","), iHeaderPosition)
		For Each sParam In aParams
			If IsNull(sParam) or sParam = "" Then
				Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the verifyWebTableHeader function, Check passed parameters"
				verifyWebTableHeader = False ' Return Value
				Services.EndTransaction "verifyWebTableHeader" ' Timer End
				Exit Function
			End If
		Next
	
	   ' Check that the iColCheck and iRowMaxCol value is Numeric
		If Not isNumeric(aParams(3)) Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "The iColCheck and iRowMaxCol Parameters must be numeric when passed to the verifyWebTableHeader function check passed parameters"
			verifyWebTableHeader = False ' Return Value
			Services.EndTransaction "verifyWebTableHeader" ' Timer End
			Exit Function
		End If
	   
	   ' Description Object Declarations/Initializations
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
	   ' create object for the WebTable
		Set oWebTable = Description.Create()
		oWebTable("MicClass").Value = "WebTable"
		oWebTable("name").Value = sTableNameorHtmlIDProperty
	  ' oWebTable("index").Value = 0 ' Using this to find the first instance of the table when there are multiple tables with the same property values
		
		' Verification of the Object
		bFound = False
		If Browser(oAppBrowser).WebTable(oWebTable).Exist(3) Then
			Browser(oAppBrowser).WebTable(oWebTable).Highlight
			bFound = True
		Else ' check using the html id property
			oWebTable.Remove "name" ' Remove name property
			oWebTable("html id").Value = sTableNameorHtmlIDProperty
			If Browser(oAppBrowser).WebTable(oWebTable).Exist(1) Then
				bFound = True
			Else ' Not found
				bFound = False
			End If
		End If
	   
	   ' Check for the existence of the sTableName webtable
		If bFound Then
			Reporter.ReportEvent micPass, "WebTable", "The '" & sTableName & "' WebTable was found"
		   
		   ' Check the number of rows is less than or equal to iHeaderPosition
			Dim iRowCount
			iRowCount = Browser(oAppBrowser).WebTable(oWebTable).RowCount
	
			If Not ((iHeaderPosition > 0) And (iHeaderPosition <= iRowCount)) Then
				Reporter.ReportEvent micFail, "Invalid Parameters", "The Header Position Parameter must be between 1 and " & iRowCount & " when checking the '" & sTableName & "' WebTable in the verifyWebTableHeader function check passed parameters"
				verifyWebTableHeader = False ' Return Value
				Services.EndTransaction "verifyWebTableHeader" ' Timer End
				Exit Function
			End If	   	
	
		   ' Check the number of columns is greater than or equal to Column Values passed in Array
			Dim iColCount ' WebTable Column Count
			iColCount = Browser(oAppBrowser).WebTable(oWebTable).ColumnCount(iHeaderPosition)
	   
			If Not (UBound(aHeaderData)+1 = iColCount) Then
				Reporter.ReportEvent micFail, "WebTable Header", "The Column Count passed : "& UBound(aHeaderData)+1&" is different with WebTable Header Count "&iColCount
				verifyWebTableHeader = False ' Return Value
				Services.EndTransaction "verifyWebTableHeader" ' Timer End
				Exit Function
			End If
	
			' Loop through column iColCheck of each row of the webtable checking for the sVerifyString values
			bFound = True ' Default For Loop Return Value
			For i = 1 to iColCount
				sColVal = Browser(oAppBrowser).WebTable(oWebTable).GetCellData(iHeaderPosition, i)
				If Instr(1, LCase(sColVal), LCase(aHeaderData(i-1)), 1) > 0 Then
					Reporter.ReportEvent micPass, "verifyWebTableHeader", "WebTable "&sTableName&" Contains the Column Name '"&aHeaderData(i-1)&"' at position : "&i&" in Column : "&iHeaderPosition&" as Expected"
				Else ' Keep checking each row, until end of table
					Reporter.ReportEvent micFail, "verifyWebTableHeader", "WebTable "&sTableName&" doesn't contain the Column Name '"&aHeaderData(i-1)&"' instead contains as '"&sColVal&"' at position : "&i&" Which is NOT as Expected"
					bFound = False
					Exit For ' Exit the For Loop
			   End If
		   Next
	
		   ' Check to see if values were found
			If bFound Then
				verifyWebTableHeader = True ' Return Value
			Else
				verifyWebTableHeader = False ' Return Value
			End If
		Else ' WebTable Not found
			Reporter.ReportEvent micFail, "WebTable", "The '" & sTableName & "' WebTable was not found"
			verifyWebTableHeader = False ' Return Value
		End If
	   
	   ' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oWebTable = Nothing
	
		Reporter.ReportEvent micDone, "verifyWebTableHeader", "Function End"
		Services.EndTransaction "verifyWebTableHeader" ' Timer End
	End Function
	
	'<@comments>
	'**********************************************************************************************
	' <@name>waitForObject</@name>
	'
	' <@purpose>
	'   Wait on the Page until the Object found OR Max Wait Time is Reached
	' </@purpose>
	'
	' <@parameters>
	'        object - Complete Object Hierarchy
	'		 iMaxTime(Secs) - Maximium Time to identify the Object
	'		 iTimeSpan(Secs) - Time Interval to check the Object
	' </@parameters>
	'
	' <@return>
	'   Boolean Value (True/False)
	'            True -  If Object found
	'            False - If Object not found or other function errors
	' </@return>
	'
	' <@assumptions>
	'   First 3 Parameters to be passed
	' </@assumptions>
	'
	' <@example_usage>
	'   of.waitForObject(Browser("name:=Ingenix chartsync").WebButton("html id:=commonSearchForm:cancelButton"), 20, 3)
	'   of.waitForObject(Browser("name:=Ingenix chartsync").WebButton("html id:=commonSearchForm:cancelButton"), 20)
	' </@example_usage>
	'
	' <@author>Govardhan Choletti</@author>
	'
	' <@creation_date>01-11-2012</@creation_date>
	'
	' <@mod_block>
	' </@mod_block>
	' 
	'**********************************************************************************************
	'</@comments>
	Public Function waitForObject(ByVal objHierarchy, ByVal iMaxTime, ByVal iTimeSpan) ' <@as> Boolean
	
		Services.StartTransaction "waitForObject" ' Timer Begin
		Reporter.ReportEvent micDone, "waitForObject", "Function Begin"
	
		' Declaration or Initialisation
		Dim iLoadTime
		iLoadTime = 0
	  
		' Check to verify passed parameters that they are not null or an empty string
		If IsNull(iMaxTime) Or iMaxTime = "" Or IsNull(iTimeSpan) Or iTimeSpan = "" Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the waitForObject function check passed parameters"
			waitForObject = False ' Return Value
			Services.EndTransaction "waitForObject" ' Timer End
			Exit Function
		End If
	  
		' Check that the iMaxTime and iTimeSpan value is Numeric
		If Not isNumeric(Round(iMaxTime)) Or Not isNumeric(Round(iTimeSpan)) Or iMaxTime < 1 Or iTimeSpan < 1 Or iMaxTime<iTimeSpan Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "The iMaxTime and iTimeSpan Parameters must be numeric, greater than 1 and Max Time should be more than Interval Specified when passed to the waitForObject function, check passed parameters"
			waitForObject = False ' Return Value
			Services.EndTransaction "waitForObject" ' Timer End
			Exit Function
		End If
		
		If iMaxTime < 1 Then
		End If
		' Wait for the Object to load
		Do
			iLoadTime = iLoadTime + Round(iTimeSpan)
			Wait(Round(iTimeSpan))
		Loop Until (objHierarchy.Exist(0) OR Round(iMaxTime) <= iLoadTime)
		
		If Round(iMaxTime) >= iLoadTime Then
			waitForObject = True
			Reporter.ReportEvent micInfo, "waitForObject", "Object Found after waiting for '"& iLoadTime &"' Seconds"
		Else
			waitForObject = False
			Reporter.ReportEvent micInfo, "waitForObject", "Object NOT Found even after waiting for '"& iLoadTime &"' Seconds"
		End If 
		
		Reporter.ReportEvent micDone, "waitForObject", "Function End"
		Services.EndTransaction "waitForObject" ' Timer End	   
	End Function
End Class
'**********************************************************************************************
'*                            Class Instantiation                                         
'**********************************************************************************************
dim of

set of = new objFunctions