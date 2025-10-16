# ⚙️ ps-process-monitor

A universal **PowerShell tool** for monitoring the performance of any Windows process — including CPU, memory, thread, and handle usage — in real time.  
It automatically logs all metrics to a timestamped CSV file for easy analysis or performance testing.

---

## 🚀 Features

- 🧩 Monitor **any process** by name (e.g., `chrome`, `notepad`, `MISTRAL Client`)
- 🧠 Tracks **CPU time**, **memory usage (MB)**, **thread count**, and **handle count**
- 📈 Automatically updates **maximum values** during runtime
- 💾 Saves detailed logs to a **CSV file** for later analysis
- ⏱ Customizable monitoring **interval**
- ✅ No dependencies — works with native PowerShell on Windows 10/11 and Server

---

## 📂 Installation

1. Clone or download this repository:
   ```powershell
   git clone https://github.com/<your-username>/ps-process-monitor.git
Open PowerShell and navigate to the folder:

powershell
Copy code
cd ps-process-monitor
(Optional) If you get an execution policy warning, allow scripts for this session:

powershell
Copy code
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
🧭 Usage
Basic Example
Monitor a process named chrome every 2 seconds and save logs in the current directory:

powershell
Copy code
.\scriptPerformanceGlobal.ps1 -ProcessName "chrome"
Custom Log Directory and Interval
Monitor MISTRAL Client every 5 seconds, storing logs in D:\Logs:

powershell
Copy code
.\scriptPerformanceGlobal.ps1 -ProcessName "MISTRAL Client" -OutputDirectory "D:\Logs" -IntervalSeconds 5
Parameters
Parameter	Type	Default	Description
-ProcessName	string	(required)	Name of the process to monitor (e.g., "notepad")
-OutputDirectory	string	Current directory	Folder where the CSV file will be saved
-IntervalSeconds	int	2	Time interval (in seconds) between samples

🧾 Output
Each run generates a log file named:

php-template
Copy code
<ProcessName>_PerformanceLog_<YYYYMMDD>.csv
Example CSV data:
Time	CPU Total (s)	Memory Total (MB)	Threads	Handles	Max CPU (s)	Max Mem (MB)	Max Threads	Max Handles
2025-10-15 09:43:00	10.21	134.52	43	1290	10.21	134.52	43	1290
2025-10-15 09:43:02	10.33	135.00	45	1302	10.33	135.00	45	1302
...	...	...	...	...	...	...	...	...

When the monitored application closes, the script automatically appends:

Application start time

End time

Total duration

Max values summary

🧩 Example Console Output
yaml
Copy code
Monitoring process: 'MISTRAL Client'
Logging to: C:\Logs\MISTRAL Client_PerformanceLog_20251015.csv
Interval: 2 seconds
Press Ctrl + C to stop monitoring.

2025-10-15 09:43:00 | CPU: 10.21 s, Mem: 134.52 MB, Threads: 43, Handles: 1290 | Max CPU: 10.21, Max Mem: 134.52, Max Threads: 43, Max Handles: 1290
2025-10-15 09:43:02 | CPU: 10.33 s, Mem: 135.00 MB, Threads: 45, Handles: 1302 | Max CPU: 10.33, Max Mem: 135.00, Max Threads: 45, Max Handles: 1302
...
🧑‍💻 Example Use Cases
Performance testing for custom applications

Continuous process monitoring for DevOps and QA

Detecting memory leaks or thread handle growth

Logging system resource consumption for reports
