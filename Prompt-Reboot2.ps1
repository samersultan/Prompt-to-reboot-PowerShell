Add-Type -AssemblyName PresentationFramework
$defer = $true
$deferals = 0
while($defer) {
    Set-ForegroundWindow (Get-Process PowerShell).MainWindowHandle
    $answer = [System.Windows.MessageBox]::Show("To complete VPN install your computer must reboot, reboot now or defer? (You can defer up to 2 times)", "Forticlient EMS Installation", [System.Windows.MessageBoxButton]::YesNo)
    if ($answer -eq "Yes") {
        # Do something if the user enters 'Yes'
        $defer = $false
        shutdown.exe /r /t 0 #Shutdown now
    } elseif ($answer -eq "No") {
        # Do something else if the user enters 'No'
        $deferals++
        Start-Sleep -Seconds 900 #15 minutes
        if ($deferals -eq 2) {
            shutdown.exe /r /t 0 #Shutdown now
        }
    } else {
        [System.Windows.MessageBox]::Show("Invalid input. Please enter either 'Yes' or 'No'.", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
}
