Add-Type -AssemblyName System.Windows.Forms

# Initialize deferral count
$deferralCount = 0

# Create a Windows Form
$form = New-Object Windows.Forms.Form
$form.Text = "Reboot Prompt"
$form.Size = New-Object Drawing.Size(350, 150)

# Create a label
$label = New-Object Windows.Forms.Label
$label.Location = New-Object Drawing.Point(10, 10)
$label.Size = New-Object Drawing.Size(330, 30)
$label.Text = "Do you want to reboot your computer now or defer for 15 minutes? (You can defer up to 2 times)"
$form.Controls.Add($label)

# Create "Reboot" button
$rebootButton = New-Object Windows.Forms.Button
$rebootButton.Location = New-Object Drawing.Point(50, 50)
$rebootButton.Size = New-Object Drawing.Size(80, 30)
$rebootButton.Text = "Reboot"
$rebootButton.Add_Click({
    $form.Close()
    shutdown.exe /r /t 0
})
$form.Controls.Add($rebootButton)

# Create "Defer" button
$deferButton = New-Object Windows.Forms.Button
$deferButton.Location = New-Object Drawing.Point(150, 50)
$deferButton.Size = New-Object Drawing.Size(80, 30)
$deferButton.Text = "Defer"
$deferButton.Add_Click({
    $deferralCount++
    if ($deferralCount -le 2) {
        $form.Close()
        Write-Host "Reboot deferred for 15 minutes ($deferralCount time(s) deferred). Please save your work."
        Start-Sleep -Seconds 900
        Show-RebootPrompt
    } else {
        $form.Close()
        shutdown.exe /r /t 0
    }
})
$form.Controls.Add($deferButton)

# Function to show the reboot prompt
function Show-RebootPrompt {
    $form.ShowDialog()
}

# Show the initial form
Show-RebootPrompt
