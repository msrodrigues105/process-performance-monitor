<#
.SYNOPSIS
    Monitors CPU, memory, thread, and handle usage of a specified process.

.DESCRIPTION
    This script continuously monitors one or more processes by name and logs 
    CPU time, memory usage, thread count, and handle count to a CSV file. 
    It also tracks maximum observed values during the session.

.PARAMETER ProcessName
    Name of the process (or processes) to monitor. Example: "chrome", "notepad"

.PARAMETER OutputDirectory
    Directory to store the performance log. Defaults to current directory.

.PARAMETER IntervalSeconds
    Time (in seconds) between data collection intervals. Default: 2 seconds.

.EXAMPLE
    .\Monitor-ProcessPerformance.ps1 -ProcessName "chrome"

.EXAMPLE
    .\Monitor-ProcessPerformance.ps1 -ProcessName "MISTRAL Client" -OutputDirectory "D:\Logs" -IntervalSeconds 5

.NOTES
    Author: <Your Name or Org>
    Version: 1.0
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$ProcessName,

    [Parameter(Mandatory = $false)]
    [string]$OutputDirectory = (Get-Location).Path,

    [Parameter(Mandatory = $false)]
    [int]$IntervalSeconds = 2
)

# Ensure output directory exists
if (-not (Test-Path $OutputDirectory)) {
    New-Item -ItemType Directory -Path $OutputDirectory | Out-Null
}

# Generate log file name
$dateString = (Get-Date).ToString("yyyyMMdd")
$logFile = Join-Path $OutputDirectory "${ProcessName}_PerformanceLog_${dateString}.csv"

# Initialize tracking variables
$maxCPU = 0
$maxMemory = 0
$maxThreads = 0
$maxHandles = 0
$culture = [System.Globalization.CultureInfo]::InvariantCulture
$appStartTime = $null
$appEndTime = $null

# Write CSV header
"Time;CPU Total (s);Memory Total (MB);Threads;Handles;Max CPU (s);Max Mem (MB);Max Threads;Max Handles" |
    Out-File -FilePath $logFile -Encoding utf8 -Force

Write-Host "Monitoring process: '$ProcessName'"
Write-Host "Logging to: $logFile"
Write-Host "Interval: $IntervalSeconds seconds"
Write-Host "Press Ctrl + C to stop monitoring.`n"

try {
    while ($true) {
        $procs = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        if ($procs) {
            if (-not $appStartTime) {
                $appStartTime = Get-Date
                Write-Host "Application(s) started at $appStartTime"
                "Application Start Time:;$($appStartTime.ToString('yyyy-MM-dd HH:mm:ss'))" |
                    Out-File -FilePath $logFile -Append -Encoding utf8
            }

            $cpu = ($procs | Measure-Object -Property CPU -Sum).Sum
            $mem = ($procs | Measure-Object -Property WorkingSet64 -Sum).Sum / 1MB
            $threads = ($procs | ForEach-Object { $_.Threads.Count }) | Measure-Object -Sum | Select-Object -ExpandProperty Sum
            $handles = ($procs | Measure-Object -Property HandleCount -Sum).Sum

            if ($cpu -gt $maxCPU) { $maxCPU = $cpu }
            if ($mem -gt $maxMemory) { $maxMemory = $mem }
            if ($threads -gt $maxThreads) { $maxThreads = $threads }
            if ($handles -gt $maxHandles) { $maxHandles = $handles }

            $output = ("{0} | CPU: {1} s, Mem: {2} MB, Threads: {3}, Handles: {4} | Max CPU: {5}, Max Mem: {6}, Max Threads: {7}, Max Handles: {8}" -f `
                $timestamp, `
                $cpu.ToString("F2", $culture), `
                $mem.ToString("F2", $culture), `
                $threads, `
                $handles, `
                $maxCPU.ToString("F2", $culture), `
                $maxMemory.ToString("F2", $culture), `
                $maxThreads, `
                $maxHandles)
            Write-Host $output

            "{0};{1};{2};{3};{4};{5};{6};{7};{8}" -f `
                $timestamp, `
                $cpu.ToString("F2", $culture), `
                $mem.ToString("F2", $culture), `
                $threads, `
                $handles, `
                $maxCPU.ToString("F2", $culture), `
                $maxMemory.ToString("F2", $culture), `
                $maxThreads, `
                $maxHandles |
                Out-File -FilePath $logFile -Append -Encoding utf8
        }
        else {
            if ($appStartTime -and -not $appEndTime) {
                $appEndTime = Get-Date
                Write-Host "Application(s) closed at $appEndTime"
                "Application End Time:;$($appEndTime.ToString('yyyy-MM-dd HH:mm:ss'))" |
                    Out-File -FilePath $logFile -Append -Encoding utf8

                $duration = ($appEndTime - $appStartTime).TotalSeconds
                "Application Duration (s):;$([Math]::Round($duration, 2))" |
                    Out-File -FilePath $logFile -Append -Encoding utf8
            }

            $msg = "$timestamp | No instances found. Waiting..."
            Write-Host $msg
            $msg | Out-File -FilePath $logFile -Append -Encoding utf8
        }

        Start-Sleep -Seconds $IntervalSeconds
    }
}
finally {
    $summary = "MAX VALUES;;;;;{0};{1};{2};{3}" -f `
        $maxCPU.ToString("F2", $culture), `
        $maxMemory.ToString("F2", $culture), `
        $maxThreads, `
        $maxHandles

    Write-Host "`nWriting max values summary to log..."
    $summary | Out-File -FilePath $logFile -Append -Encoding utf8

    Write-Host "`nMonitoring ended successfully."
}
