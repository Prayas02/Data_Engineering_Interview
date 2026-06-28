import os
os.system("cls")  
from rich.traceback import install
install()

def process_logs(logs):

    report={}

    for log in logs:
        parts = log.split()
        timestamp = parts[0].split("T")[0]  # Extract date part
        log_level = parts[1]
        user=parts[2]

        # if log_level=='ERROR' (additional filter)
        
        if timestamp not in report:
            report[timestamp]={}      # observe this
        report[timestamp][user]=report[timestamp].get(user,0)+1
    
    return report

def process_report(logs):

    report_list=[]

    for log in logs:
        values=log.split()
        report={
            "date" : values[0].split('T')[0],
            "ts": values[0].split('T')[1],
            "code": values[1],
            "user_id": values[2],
            "message": values[3]
        }
        report_list.append(report)

    return report_list





def main():
    
    logs = [
    "2024-01-01T08:15:30 INFO user101 login",
    "2024-01-01T09:20:10 ERROR user102 failed",
    
    "2024-01-02T10:45:00 ERROR user103 high_memory_usage",
    "2024-01-02T11:00:25 ERROR user103 upload_success",
    
    "2024-01-03T09:10:45 ERROR user101 timeout",
    "2024-01-03T09:30:00 ERROR user105 logout",
    
    "2024-01-04T10:05:15 ERROR user105 database_crash",
    "2024-01-04T10:20:40 INFO user104 disk_space_low"
    ]

    report = process_logs(logs)

    print(report)

    report_list=process_report(logs)

    print(report_list)

if __name__ == "__main__":
    main()



