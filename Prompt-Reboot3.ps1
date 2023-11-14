# Taken from https://modalyitblog.wordpress.com/2016/10/03/powershell-gui-reboot-prompt/

# Ninja One Notes: https://ninjarmm.zendesk.com/hc/en-us/community/posts/6374538061325-End-User-Reboot-Prompt

<#
 .NOTES
 --------------------------------------------------------------------------------
 Code generated by: SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.128
 Generated on: 04/10/2016 10:13
 Generated by: Maurice.Daly
 --------------------------------------------------------------------------------
 .DESCRIPTION
 Provides an reboot prompt which counts down from 3 minutes and allows the
 end user to schedule or cancel the reboot.
#>

#----------------------------------------------
#region Import Assemblies
#----------------------------------------------
[void][Reflection.Assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][Reflection.Assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][Reflection.Assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
#endregion Import Assemblies
 
#Define a Param block to use custom parameters in the project
#Param ($CustomParameter)
 
function Main {
<#
 .SYNOPSIS
 The Main function starts the project application.
 
 .PARAMETER Commandline
 $Commandline contains the complete argument string passed to the script packager executable.
 
 .NOTES
 Use this function to initialize your script and to call GUI forms.
 
 .NOTES
 To get the console output in the Packager (Forms Engine) use:
 $ConsoleOutput (Type: System.Collections.ArrayList)
#>
 Param ([String]$Commandline)
 
 #--------------------------------------------------------------------------
 #TODO: Add initialization script here (Load modules and check requirements)
 
 #--------------------------------------------------------------------------
 
 if((Call-MainForm_psf) -eq 'OK')
 {
 
 }
 
 $global:ExitCode = 0 #Set the exit code for the Packager
}
 
#endregion Source: Startup.pss
 
#region Source: MainForm.psf
function Call-MainForm_psf
{
 
 #----------------------------------------------
 #region Import the Assemblies
 #----------------------------------------------
 [void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
 [void][reflection.assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
 [void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
 #endregion Import Assemblies
 
 #----------------------------------------------
 #region Generated Form Objects
 #----------------------------------------------
 [System.Windows.Forms.Application]::EnableVisualStyles()
 $MainForm = New-Object 'System.Windows.Forms.Form'
 $panel2 = New-Object 'System.Windows.Forms.Panel'
 $ButtonCancel = New-Object 'System.Windows.Forms.Button'
 $ButtonSchedule = New-Object 'System.Windows.Forms.Button'
 $ButtonRestartNow = New-Object 'System.Windows.Forms.Button'
 $panel1 = New-Object 'System.Windows.Forms.Panel'
 $labelITSystemsMaintenance = New-Object 'System.Windows.Forms.Label'
 $labelSecondsLeftToRestart = New-Object 'System.Windows.Forms.Label'
 $labelTime = New-Object 'System.Windows.Forms.Label'
 $labelInOrderToApplySecuri = New-Object 'System.Windows.Forms.Label'
 $timerUpdate = New-Object 'System.Windows.Forms.Timer'
 $InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
 #endregion Generated Form Objects
 
 #----------------------------------------------
 # User Generated Script
 #----------------------------------------------
 $TotalTime = 300 #in seconds
 
 $MainForm_Load={
 #TODO: Initialize Form Controls here
 $labelTime.Text = "{0:D2}" -f $TotalTime #$TotalTime
 #Add TotalTime to current time
 $script:StartTime = (Get-Date).AddSeconds($TotalTime)
 #Start the timer
 $timerUpdate.Start()
 }
 
 $timerUpdate_Tick={
 # Define countdown timer
 [TimeSpan]$span = $script:StartTime - (Get-Date)
 # Update the display
 $mins = "{0:00}" -f $span.Minutes
 $secs = "{0:00}" -f $span.Seconds
 $labelTime.Text = "{0}:{1}" -f $mins, $secs
 $timerUpdate.Start()
 if ($span.TotalSeconds -le 0)
 {
 $timerUpdate.Stop()
 Restart-Computer -Force
 }
 
 }
 
 $ButtonRestartNow_Click = {
 # Restart the computer immediately
 Restart-Computer -Force
 }
 
 $ButtonSchedule_Click={
 # Schedule restart for 11pm
 #remove old task
 Unregister-ScheduledTask -TaskName "RetterTEK Reboot" -Confirm:$false
 # Create task action
 $taskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument 'shutdown /r /f /t 300'
 # Create a trigger
 $taskTrigger = New-ScheduledTaskTrigger -Once -At 23:00pm
 # The name of the scheduled task.
 $taskName = "RetterTEK Reboot"
 # Describe the scheduled task.
 $description = "Force reboot the computer at 11pm"
 # Register the scheduled task
 Register-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $taskTrigger -Description $description 
 $MainForm.Close()
 }
 
 $ButtonCancel_Click={
 #TODO: Place custom script here
 $MainForm.Close()
 }
 
 $labelITSystemsMaintenance_Click={
 #TODO: Place custom script here
 
 }
 
 $panel2_Paint=[System.Windows.Forms.PaintEventHandler]{
 #Event Argument: $_ = [System.Windows.Forms.PaintEventArgs]
 #TODO: Place custom script here
 
 }
 
 $labelTime_Click={
 #TODO: Place custom script here
 
 }
 # --End User Generated Script--
 #----------------------------------------------
 #region Generated Events
 #----------------------------------------------
 
 $Form_StateCorrection_Load=
 {
 #Correct the initial state of the form to prevent the .Net maximized form issue
 $MainForm.WindowState = $InitialFormWindowState
 }
 
 $Form_StoreValues_Closing=
 {
 #Store the control values
 }
 
 $Form_Cleanup_FormClosed=
 {
 #Remove all event handlers from the controls
 try
 {
 $ButtonSchedule.remove_Click($ButtonSchedule_Click)
 $ButtonRestartNow.remove_Click($ButtonRestartNow_Click)
 $panel2.remove_Paint($panel2_Paint)
 $labelITSystemsMaintenance.remove_Click($labelITSystemsMaintenance_Click)
 $labelTime.remove_Click($labelTime_Click)
 $MainForm.remove_Load($MainForm_Load)
 $timerUpdate.remove_Tick($timerUpdate_Tick)
 $MainForm.remove_Load($Form_StateCorrection_Load)
 $MainForm.remove_Closing($Form_StoreValues_Closing)
 $MainForm.remove_FormClosed($Form_Cleanup_FormClosed)
 }
 catch [Exception]
 { }
 }
 #endregion Generated Events
 
 #----------------------------------------------
 #region Generated Form Code
 #----------------------------------------------
 $MainForm.SuspendLayout()
 $panel2.SuspendLayout()
 $panel1.SuspendLayout()
 #
 # MainForm
 #
 $MainForm.ControlBox = $False
 $MainForm.Controls.Add($panel2)
 $MainForm.Controls.Add($panel1)
 $MainForm.Controls.Add($labelSecondsLeftToRestart)
 $MainForm.Controls.Add($labelTime)
 $MainForm.Controls.Add($labelInOrderToApplySecuri)
 $MainForm.AutoScaleDimensions = '6, 13'
 $MainForm.AutoScaleMode = 'Font'
 $MainForm.BackColor = 'White'
 $MainForm.ClientSize = '373, 279'
 $MainForm.MaximizeBox = $False
 $MainForm.MinimizeBox = $False
 $MainForm.Name = 'MainForm'
 $MainForm.ShowIcon = $False
 $MainForm.ShowInTaskbar = $False
 $MainForm.StartPosition = 'CenterScreen'
 $MainForm.Text = 'System Maintenance'
 $MainForm.TopMost = $True
 $MainForm.add_Load($MainForm_Load)
 #
 # panel2
 #
 $panel2.Controls.Add($ButtonSchedule)
 $panel2.Controls.Add($ButtonRestartNow)
 $panel2.BackColor = 'ScrollBar'
 $panel2.Location = '0, 205'
 $panel2.Name = 'panel2'
 $panel2.Size = '378, 80'
 $panel2.TabIndex = 9
 $panel2.add_Paint($panel2_Paint)
 #
 # ButtonSchedule
 #
 $ButtonSchedule.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
 $ButtonSchedule.Location = '175, 17'
 $ButtonSchedule.Name = 'ButtonSchedule'
 $ButtonSchedule.Size = '105, 45'
 $ButtonSchedule.TabIndex = 6
 $ButtonSchedule.Text = 'Restart at 11pm'
 $ButtonSchedule.UseVisualStyleBackColor = $True
 $ButtonSchedule.add_Click($ButtonSchedule_Click)
 #
 # ButtonRestartNow
 #
 $ButtonRestartNow.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
 $ButtonRestartNow.ForeColor = 'DarkRed'
 $ButtonRestartNow.Location = '75, 17'
 $ButtonRestartNow.Name = 'ButtonRestartNow'
 $ButtonRestartNow.Size = '91, 45'
 $ButtonRestartNow.TabIndex = 0
 $ButtonRestartNow.Text = 'Restart Now'
 $ButtonRestartNow.UseVisualStyleBackColor = $True
 $ButtonRestartNow.add_Click($ButtonRestartNow_Click)
 #
 # panel1
 #
 $panel1.Controls.Add($labelITSystemsMaintenance)
 $panel1.BackColor = '51, 51, 51'
 $panel1.Location = '0, 0'
 $panel1.Name = 'panel1'
 $panel1.Size = '375, 67'
 $panel1.TabIndex = 8
 #
 # labelITSystemsMaintenance
 #
 $labelITSystemsMaintenance.Font = 'Book Antiqua, 18pt, style=Bold'
 $labelITSystemsMaintenance.ForeColor = 'Gold'
 $labelITSystemsMaintenance.Location = '11, 18'
 $labelITSystemsMaintenance.Name = 'labelITSystemsMaintenance'
 $labelITSystemsMaintenance.Size = '350, 23'
 $labelITSystemsMaintenance.TabIndex = 1
 $labelITSystemsMaintenance.Text = 'RetterTEK'
 $labelITSystemsMaintenance.TextAlign = 'MiddleLeft'
 $labelITSystemsMaintenance.add_Click($labelITSystemsMaintenance_Click)
 #
 # labelSecondsLeftToRestart
 #
 $labelSecondsLeftToRestart.AutoSize = $True
 $labelSecondsLeftToRestart.Font = 'Microsoft Sans Serif, 9pt, style=Bold'
 $labelSecondsLeftToRestart.Location = '87, 176'
 $labelSecondsLeftToRestart.Name = 'labelSecondsLeftToRestart'
 $labelSecondsLeftToRestart.Size = '155, 15'
 $labelSecondsLeftToRestart.TabIndex = 5
 $labelSecondsLeftToRestart.Text = 'Auto Reboot In :'
 #
 # labelTime
 #
 $labelTime.AutoSize = $True
 $labelTime.Font = 'Microsoft Sans Serif, 9pt, style=Bold'
 $labelTime.ForeColor = '192, 0, 0'
 $labelTime.Location = '190, 174'
 $labelTime.Name = 'labelTime'
 $labelTime.Size = '43, 15'
 $labelTime.TabIndex = 3
 $labelTime.Text = '00:60'
 $labelTime.TextAlign = 'MiddleCenter'
 $labelTime.add_Click($labelTime_Click)
 #
 # labelInOrderToApplySecuri
 #
 $labelInOrderToApplySecuri.Font = 'Microsoft Sans Serif, 9pt'
 $labelInOrderToApplySecuri.Location = '12, 84'
 $labelInOrderToApplySecuri.Name = 'labelInOrderToApplySecuri'
 $labelInOrderToApplySecuri.Size = '350, 83'
 $labelInOrderToApplySecuri.TabIndex = 2
 $labelInOrderToApplySecuri.Text = 'Your machine exceeds 15 days of uptime.

For optimal system performance, please save your work and restart your machine.'
 #
 # timerUpdate
 #
 $timerUpdate.add_Tick($timerUpdate_Tick)
 $panel1.ResumeLayout()
 $panel2.ResumeLayout()
 $MainForm.ResumeLayout()
 #endregion Generated Form Code
 
 #----------------------------------------------
 
 #Save the initial state of the form
 $InitialFormWindowState = $MainForm.WindowState
 #Init the OnLoad event to correct the initial state of the form
 $MainForm.add_Load($Form_StateCorrection_Load)
 #Clean up the control events
 $MainForm.add_FormClosed($Form_Cleanup_FormClosed)
 #Store the control values when form is closing
 $MainForm.add_Closing($Form_StoreValues_Closing)
 #Show the Form
 return $MainForm.ShowDialog()
 
}
#endregion Source: MainForm.psf
 
#Start the application
Main ($CommandLine)
