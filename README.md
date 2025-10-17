# ⚙️ ps-process-monitor

A universal **PowerShell tool** for monitoring the performance of any Windows process — including CPU, memory, thread, and handle usage — in real time.  
It automatically logs all metrics to a timestamped CSV file for easy analysis or performance testing.

---

##  Features

-  Monitor **any process** by name (e.g., `chrome`, `notepad`, `MISTRAL Client`)
-  Tracks **CPU time**, **memory usage (MB)**, **thread count**, and **handle count**
-  Automatically updates **maximum values** during runtime
-  Saves detailed logs to a **CSV file** for later analysis
-  Customizable monitoring **interval**
-  No dependencies — works with native PowerShell on Windows 10/11 and Server

---

##  Installation

1. Clone or download this repository:
```
git clone https://github.com/<your-username>/ps-process-monitor.git
```

2. Open PowerShell and navigate to the folder:
```
cd ps-process-monitor
```

(Optional) If you get an execution policy warning, allow scripts for this session:
```
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

## Usage
- Basic Example:
Monitor a process named chrome every 2 seconds and save logs in the current directory:

```
.\scriptPerformanceGlobal.ps1 -ProcessName "chrome"
```

- Another Example:
Custom Log Directory and Interval Monitor of a process every 5 seconds, storing logs in D:\Logs:

```
.\scriptPerformanceGlobal.ps1 -ProcessName "chrome" -OutputDirectory "D:\Logs" -IntervalSeconds 5
```

## Output
Each run generates a log file named:

<ProcessName>_PerformanceLog_<YYYYMMDD>.csv
```
Example CSV data:
Time	CPU Total (s)	Memory Total (MB)	Threads	Handles	Max CPU (s)	Max Mem (MB)	Max Threads	Max Handles
2025-10-15 09:43:00	10.21	134.52	43	1290	10.21	134.52	43	1290
2025-10-15 09:43:02	10.33	135.00	45	1302	10.33	135.00	45	1302
...	...	...	...	...	...	...	...	...
```

When the monitored application closes, the script automatically appends:
- Application start time
- End time
- Total duration
- Max values summary
