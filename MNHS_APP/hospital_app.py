import os
import random
import time
from dotenv import load_dotenv
import mysql.connector

load_dotenv()
cfg = dict(
    host=os.getenv("MYSQL_HOST", "localhost"),
    port=int(os.getenv("MYSQL_PORT", 3306)),
    database=os.getenv("MYSQL_DB", "lab3"),
    user=os.getenv("MYSQL_USER", "mnhs_user"),
    password=os.getenv("MYSQL_PASSWORD", "MNHS_secure123!"),
)


def get_connection():
    return mysql.connector.connect(**cfg)

# MINI-TASK 1: List Patients
def list_patients_ordered_by_last_name(limit=20):
    sql = """
    SELECT IID, FullName
    FROM Patient
    ORDER BY SUBSTRING_INDEX(FullName, ' ', -1), FullName
    LIMIT %s
    """
    with get_connection() as cnx:
        with cnx.cursor(dictionary=True) as cur:
            cur.execute(sql, (limit,))
            return cur.fetchall()
        
        
# MINI-TASK 2: Schedule Appointment
def schedule_appointment(caid, iid, staff_id, dep_id, date_str, time_str, reason):
    ins_ca = """
    INSERT INTO ClinicalActivity(CAID, IID, STAFF_ID, DEP_ID, Date, Time)
    VALUES (%s, %s, %s, %s, %s, %s)
    """
    ins_appt = """
    INSERT INTO Appointment(CAID, Reason, Status)
    VALUES (%s, %s, 'Scheduled')
    """
    with get_connection() as cnx:
        try:
            with cnx.cursor() as cur:
                cur.execute(ins_ca, (caid, iid, staff_id, dep_id, date_str, time_str))
                cur.execute(ins_appt, (caid, reason))
                cnx.commit()
        except Exception:
            cnx.rollback()
            raise


# MINI-TASK 3: Low Stock (Per Hospital)
def low_stock():
    sql = """
    SELECT 
        H.Name AS HospitalName, 
        M.Name AS MedicationName, 
        IFNULL(S.Qty, 0) as Qty, 
        IFNULL(S.ReorderLevel, 0) as ReorderLevel,
        CASE WHEN S.Qty IS NULL THEN 'Missing Stock' ELSE 'Low Stock' END as Status
    FROM Hospital H
    CROSS JOIN Medication M
    LEFT JOIN Stock S ON H.HID = S.HID AND M.MID = S.MID
    WHERE (S.Qty < S.ReorderLevel) OR (S.Qty IS NULL)
    ORDER BY H.Name, M.Name
    """
    
    try:
        with get_connection() as cnx:
            with cnx.cursor(dictionary=True) as cur:
                cur.execute(sql)
                results = cur.fetchall()
                return results  # Make sure to return the results
    except Exception as e:
        print(f"Error in low_stock: {e}")
        return []

# MINI-TASK 4: Staff Workload Share
def staff_share():
    print("\n=== MINI-TASK 4: Staff Appointment Share ===")

    sql = """
    SELECT
        s.STAFF_ID,
        s.FullName AS StaffName,
        h.Name AS HospitalName,
        COUNT(DISTINCT ca.CAID) AS TotalAppointments,

        -- Subquery: total appointments in this staff’s hospital
        CASE 
            WHEN (
                SELECT COUNT(DISTINCT ca2.CAID)
                FROM ClinicalActivity ca2
                JOIN Staff s2 ON ca2.STAFF_ID = s2.STAFF_ID
                JOIN Work_in w2 ON s2.STAFF_ID = w2.STAFF_ID
                JOIN Department d2 ON w2.DEP_ID = d2.DEP_ID
                WHERE d2.HID = h.HID
            ) > 0
            THEN (
                COUNT(DISTINCT ca.CAID) * 100.0 /
                (
                    SELECT COUNT(DISTINCT ca2.CAID)
                    FROM ClinicalActivity ca2
                    JOIN Staff s2 ON ca2.STAFF_ID = s2.STAFF_ID
                    JOIN Work_in w2 ON s2.STAFF_ID = w2.STAFF_ID
                    JOIN Department d2 ON w2.DEP_ID = d2.DEP_ID
                    WHERE d2.HID = h.HID
                )
            )
            ELSE 0
        END AS PercentageShare

    FROM Staff s
    JOIN Work_in w ON s.STAFF_ID = w.STAFF_ID
    JOIN Department d ON w.DEP_ID = d.DEP_ID
    JOIN Hospital h ON d.HID = h.HID
    LEFT JOIN ClinicalActivity ca ON s.STAFF_ID = ca.STAFF_ID

    GROUP BY s.STAFF_ID, s.FullName, h.Name, h.HID
    ORDER BY h.Name, PercentageShare DESC;
    """

    try:
        with get_connection() as cnx:
            with cnx.cursor(dictionary=True) as cur:
                cur.execute(sql)
                results = cur.fetchall()

                print(f"{'Staff Name':<20} | {'Hospital':<20} | {'Appts':<5} | {'Share %'}")
                print("-" * 65)
                for row in results:
                    share = row['PercentageShare'] or 0
                    print(f"{row['StaffName'][:20]:<20} | "
                          f"{row['HospitalName'][:20]:<20} | "
                          f"{row['TotalAppointments']:<5} | "
                          f"{float(share):.1f}%")

                return results
    except Exception:
        cnx.rollback()
        raise

# MAIN EXECUTION
if __name__ == "__main__":
    # 1. List Patients
    print("=== MINI-TASK 1: Patient List ===")
    for row in list_patients_ordered_by_last_name():
        print(f"{row['IID']} {row['FullName']}")

    # 2. Schedule Appointment
    dummy_caid = random.randint(10000, 99999) 
    schedule_appointment(
        caid=dummy_caid,
        iid=1,           
        staff_id=501,    
        dep_id=10,       
        date_str='2025-12-01',
        time_str='09:00:00',
        reason='Routine Checkup'
    )
    
    # 3. Low Stock Report
    low_stock()
    
    # 4. Staff Share Analysis
    staff_share()  
