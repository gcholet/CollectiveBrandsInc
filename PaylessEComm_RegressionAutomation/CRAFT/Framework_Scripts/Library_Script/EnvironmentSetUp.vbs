Dim App 'As Application
Set App=CreateObject("QuickTest.Application")
App.Visible=True
set script=App.Test
set script_settings=script.Settings
set script_run_settings=script_settings.Run
script_run_settings.IterationMode="oneIteration"
'script_run_settings.OnError = "Dialog"
script_run_settings.OnError = "NextStep"
script_run_settings.ObjectSyncTimeOut=60000
set script_option=App.Options

set script_run_option=script_option.Run
script_run_option.ViewResults=False
script_run_option.RunMode = "Normal"
set script_recovery_settings = script_settings.Recovery
'script_recovery_settings.Enabled = False
'script_recovery_settings.Enabled = True
'script_recovery_settings.SetActivationMode "OnError"
''script_recovery_settings.Add "C:\PaylessEComm_RegressionAutomation\CRAFT\Framework_Scripts\RecoveryScenarios\IE_Exception.qrs", "IE_Exception", 1
''script_recovery_settings.Item(1).Enabled = True 
''script_recovery_settings.Add "C:\PaylessEComm_RegressionAutomation\CRAFT\Framework_Scripts\RecoveryScenarios\Dont_Send.qrs", "Dont_Send", 2
''script_recovery_settings.Item(2).Enabled = True 
''script_recovery_settings.Add "C:\PaylessEComm_RegressionAutomation\CRAFT\Framework_Scripts\RecoveryScenarios\Caught Exception.qrs", "Caught Exception", 3
''script_recovery_settings.Item(3).Enabled = True 
''script_recovery_settings.Add "C:\PaylessEComm_RegressionAutomation\CRAFT\Framework_Scripts\RecoveryScenarios\User_Connected-MIE.qrs", "User_Connected-MIE", 4
''script_recovery_settings.Item(4).Enabled = True 
''script_recovery_settings.Add "C:\PaylessEComm_RegressionAutomation\CRAFT\Framework_Scripts\RecoveryScenarios\User_Connected-WIE.qrs", "User_Connected-WIE", 5
''script_recovery_settings.Item(5).Enabled = True 
''script_recovery_settings.Add "C:\PaylessEComm_RegressionAutomation\CRAFT\Framework_Scripts\RecoveryScenarios\Caught Exception2.qrs", "Caught-Exception2", 6
''script_recovery_settings.Item(6).Enabled = True 
''script_recovery_settings.Add "C:\PaylessEComm_RegressionAutomation\CRAFT\Framework_Scripts\RecoveryScenarios\IE_Exception_CloseBtn.qrs", "IE-Exception_Closebtn", 7
''script_recovery_settings.Item(7).Enabled = True 
''script_recovery_settings.Add "C:\PaylessEComm_RegressionAutomation\CRAFT\Framework_Scripts\RecoveryScenarios\IE_Explorer_2.qrs", "IE_Explorer_2", 8
''script_recovery_settings.Item(8).Enabled = True 
