CREATE DATABASE IF NOT EXISTS lab3;
USE lab3;

-- Tables
CREATE TABLE Hospital (
    HID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Region VARCHAR(50)
);

CREATE TABLE Department (
    DEP_ID INT PRIMARY KEY,
    HID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Specialty VARCHAR(100),
    CONSTRAINT fk_department_hospital FOREIGN KEY (HID) REFERENCES Hospital(HID)
);

CREATE TABLE Patient (
    IID INT PRIMARY KEY,
    CIN VARCHAR(10) UNIQUE NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Birth DATE,
    Sex ENUM('M','F') NOT NULL,
    BloodGroup ENUM('A+','A-','B+','B-','O+','O-','AB+','AB-'),
    Phone VARCHAR(15),
    Email VARCHAR(160) NULL
);

CREATE TABLE Staff (
    STAFF_ID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Status ENUM('Active','Retired') DEFAULT 'Active'
);

CREATE TABLE Insurance (
    InsID INT PRIMARY KEY,
    Type ENUM('CNOPS','CNSS','RAMED','Private','None') NOT NULL
);

CREATE TABLE Medication (
    MID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Form VARCHAR(50),
    Strength VARCHAR(50),
    ActiveIngredient VARCHAR(100),
    TherapeuticClass VARCHAR(100),
    Manufacturer VARCHAR(100)
);

CREATE TABLE ClinicalActivity (
    CAID INT PRIMARY KEY,
    IID INT NOT NULL,
    STAFF_ID INT NOT NULL,
    DEP_ID INT NOT NULL,
    Date DATE NOT NULL,
    Time TIME,
    CONSTRAINT fk_ca_patient FOREIGN KEY (IID) REFERENCES Patient(IID),
    CONSTRAINT fk_ca_staff FOREIGN KEY (STAFF_ID) REFERENCES Staff(STAFF_ID),
    CONSTRAINT fk_ca_department FOREIGN KEY (DEP_ID) REFERENCES Department(DEP_ID)
);

CREATE TABLE Appointment (
    CAID INT PRIMARY KEY,
    Reason VARCHAR(100),
    Status ENUM('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled',
    CONSTRAINT fk_appt_caid FOREIGN KEY (CAID) REFERENCES ClinicalActivity(CAID) ON DELETE CASCADE
);

CREATE TABLE Emergency (
    CAID INT PRIMARY KEY,
    TriageLevel INT CHECK (TriageLevel BETWEEN 1 AND 5),
    Outcome ENUM('Discharged','Admitted','Transferred','Deceased'),
    CONSTRAINT fk_er_caid FOREIGN KEY (CAID) REFERENCES ClinicalActivity(CAID) ON DELETE CASCADE
);

CREATE TABLE Expense (
    ExpID INT PRIMARY KEY,
    InsID INT,
    CAID INT UNIQUE NOT NULL,
    Total DECIMAL(10,2) NOT NULL CHECK (Total >= 0),
    CONSTRAINT fk_exp_ins FOREIGN KEY (InsID) REFERENCES Insurance(InsID),
    CONSTRAINT fk_exp_caid FOREIGN KEY (CAID) REFERENCES ClinicalActivity(CAID)
);

CREATE TABLE Prescription (
    PID INT PRIMARY KEY,
    CAID INT UNIQUE NOT NULL,
    DateIssued DATE NOT NULL,
    CONSTRAINT fk_rx_caid FOREIGN KEY (CAID) REFERENCES ClinicalActivity(CAID)
);

CREATE TABLE Includes (
    PID INT,
    MID INT,
    Dosage VARCHAR(100),
    Duration VARCHAR(50),
    PRIMARY KEY(PID,MID),
    CONSTRAINT fk_inc_rx FOREIGN KEY (PID) REFERENCES Prescription(PID) ON DELETE CASCADE,
    CONSTRAINT fk_inc_med FOREIGN KEY (MID) REFERENCES Medication(MID)
);

CREATE TABLE Stock (
    HID INT,
    MID INT,
    StockTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    UnitPrice DECIMAL(10,2) CHECK(UnitPrice >= 0),
    Qty INT DEFAULT 0 CHECK(Qty >= 0),
    ReorderLevel INT DEFAULT 10 CHECK(ReorderLevel >= 0),
    PRIMARY KEY(HID,MID,StockTimestamp),
    CONSTRAINT fk_stock_hospital FOREIGN KEY(HID) REFERENCES Hospital(HID),
    CONSTRAINT fk_stock_med FOREIGN KEY(MID) REFERENCES Medication(MID)
);

CREATE TABLE Work_in (
    STAFF_ID INT,
    DEP_ID INT,
    PRIMARY KEY(STAFF_ID,DEP_ID),
    CONSTRAINT fk_workin_staff FOREIGN KEY(STAFF_ID) REFERENCES Staff(STAFF_ID) ON DELETE CASCADE,
    CONSTRAINT fk_workin_department FOREIGN KEY(DEP_ID) REFERENCES Department(DEP_ID) ON DELETE CASCADE
);

CREATE TABLE ContactLocation (
    CLID INT PRIMARY KEY,
    City VARCHAR(50),
    Province VARCHAR(50),
    Street VARCHAR(100),
    Number VARCHAR(10),
    PostalCode VARCHAR(10),
    Phone_Location VARCHAR(15)
);

CREATE TABLE have (
    IID INT,
    CLID INT,
    PRIMARY KEY(IID,CLID),
    CONSTRAINT fk_have_patient FOREIGN KEY(IID) REFERENCES Patient(IID) ON DELETE CASCADE,
    CONSTRAINT fk_have_contact FOREIGN KEY(CLID) REFERENCES ContactLocation(CLID) ON DELETE CASCADE
);

-- Data Insertions
INSERT INTO Hospital(HID,Name,City,Region) VALUES
(1,'Benguerir Central Hospital','Benguerir','Marrakech-Safi'),
(2,'Casablanca University Hospital','Casablanca','Casablanca-Settat'),
(3,'Rabat Clinical Center','Rabat','Rabat-Sal-Knitra'),
(4,'Marrakech Regional Hospital','Marrakech','Marrakech-Safi'),
(5,'Agadir City Hospital','Agadir','Souss-Massa');

INSERT INTO Department(DEP_ID,HID,Name,Specialty) VALUES
(10,1,'Cardiology','Heart Care'),
(11,1,'Pediatrics','Child Care'),
(20,2,'Radiology','Imaging'),
(30,3,'Oncology','Cancer Care'),
(40,4,'Emergency','Acute Care'),
(50,5,'Internal Medicine','General');

INSERT INTO Patient(IID,CIN,FullName,Birth,Sex,BloodGroup,Phone) VALUES
(1,'CIN001','Sara El Amrani','1999-04-10','F','A+','0612345678'),
(2,'CIN002','Youssef Benali','1988-09-22','M','O-','0678912345'),
(3,'CIN003','Hajar Berrada','1995-01-18','F','B+','0600112233'),
(4,'CIN004','Ayoub El Khattabi','1992-07-06','M','AB-','0600223344'),
(5,'CIN005','Imane Othmani','2001-03-30','F','O+','0600334455');

-- STAFF
INSERT INTO Staff(STAFF_ID,FullName,Status) VALUES
(501,'Dr. Amina Idrissi','Active'),
(502,'Dr. Mehdi Touil','Active'),
(503,'Nurse Firdawse Guerbouzi','Active'),
(504,'Technician Omar Lahlou','Active'),
(505,'Dr. Khaoula Messari','Active');

-- INSURANCE
INSERT INTO Insurance(InsID,Type) VALUES
(100,'CNOPS'),
(101,'CNSS'),
(102,'RAMED'),
(103,'Private'),
(104,'None');

-- MEDICATION
INSERT INTO Medication(MID,Name,Form,Strength,ActiveIngredient,TherapeuticClass,Manufacturer) VALUES
(1001,'Amoxicillin','Tablet','500 mg','Amoxicillin','Antibiotic','PharmaMA'),
(1002,'Ibuprofen','Tablet','400 mg','Ibuprofen','Analgesic','MediCare'),
(1003,'Azithromycin','Tablet','250 mg','Azithromycin','Antibiotic','HealthCo'),
(1004,'Paracetamol','Syrup','120 mg/5 ml','Acetaminophen','Analgesic','MediCare'),
(1005,'Ceftriaxone','Injection','1g','Ceftriaxone','Antibiotic','PharmaMA');

-- CONTACTLOCATION
INSERT INTO ContactLocation(CLID,City,Province,Street,Number,PostalCode,Phone_Location) VALUES
(201,'Benguerir','Rehamna','Avenue Mohammed VI','12','43150','0523000001'),
(202,'Casablanca','Anfa','Bd Zerktouni','77','20000','0522000002'),
(203,'Rabat','Agdal','Rue Oued Ziz','5','10000','0537000003'),
(204,'Marrakech','Gueliz','Rue de la Libert','9','40000','0524000004'),
(205,'Agadir','Cit Dakhla','Rue Al Atlas','3','80000','0528000005');

-- HAVE (Patient-ContactLocation)
INSERT INTO have(IID,CLID) VALUES
(1,201),
(1,202),
(2,202),
(3,203),
(4,204),
(5,205);

-- WORK_IN (Staff-Department)
INSERT INTO Work_in(STAFF_ID,DEP_ID) VALUES
(501,10),
(502,10),
(503,11),
(504,20),
(505,40),
(501,30);

-- CLINICALACTIVITY - Appointments
INSERT INTO ClinicalActivity(CAID,IID,STAFF_ID,DEP_ID,Date,Time) VALUES
(1001,1,501,10,'2025-10-10','10:00:00'),
(1002,2,502,10,'2025-10-12','11:00:00'),
(1003,3,503,11,'2025-10-15','09:30:00'),
(1004,4,504,20,'2025-10-20','14:00:00'),
(1005,5,505,40,'2025-10-22','16:15:00');

-- CLINICALACTIVITY - Emergencies
INSERT INTO ClinicalActivity(CAID,IID,STAFF_ID,DEP_ID,Date,Time) VALUES
(1011,1,505,40,'2025-10-25','01:10:00'),
(1012,2,501,40,'2025-10-26','02:25:00'),
(1013,3,502,40,'2025-10-27','03:05:00'),
(1014,4,503,40,'2025-10-28','05:40:00'),
(1015,5,504,40,'2025-10-29','06:55:00');

-- APPOINTMENT
INSERT INTO Appointment(CAID,Reason,Status) VALUES
(1001,'Routine check-up','Scheduled'),
(1002,'Follow-up imaging','Completed'),
(1003,'Pediatric visit','Cancelled'),
(1004,'X-ray review','Scheduled'),
(1005,'Triage follow-up','Completed');

-- EMERGENCY
INSERT INTO Emergency(CAID,TriageLevel,Outcome) VALUES
(1011,3,'Admitted'),
(1012,2,'Discharged'),
(1013,4,'Transferred'),
(1014,5,'Admitted'),
(1015,1,'Discharged');

-- EXPENSE
INSERT INTO Expense(ExpID,InsID,CAID,Total) VALUES
(9001,100,1001,250.00),
(9002,101,1002,400.00),
(9003,103,1011,1200.00),
(9004,104,1012,80.00),
(9005,102,1004,150.00);

-- PRESCRIPTION
INSERT INTO Prescription(PID,CAID,DateIssued) VALUES
(8001,1001,'2025-10-10'),
(8002,1002,'2025-10-12'),
(8003,1004,'2025-10-20'),
(8004,1011,'2025-10-25'),
(8005,1013,'2025-10-27');

-- INCLUDES
INSERT INTO Includes(PID,MID,Dosage,Duration) VALUES
(8001,1001,'1 tab BID','5 days'),
(8001,1002,'1 tab PRN','3 days'),
(8002,1003,'1 tab OD','3 days'),
(8003,1004,'10 ml Q6H','2 days'),
(8004,1005,'1 g IV','1 day'),
(8005,1002,'1 tab TID','4 days');

-- STOCK (Inventory)
INSERT INTO Stock(HID,MID,StockTimestamp,UnitPrice,Qty,ReorderLevel) VALUES
(1,1001,'2025-10-10 08:00:00',22.00,120,20),
(1,1002,'2025-10-10 08:00:00',6.50,300,50),
(2,1003,'2025-10-12 08:00:00',35.00,80,15),
(3,1004,'2025-10-15 08:00:00',4.00,500,60),
(4,1005,'2025-10-20 08:00:00',120.00,40,10);

-- UPDATES
UPDATE Patient SET Phone='0611111111' WHERE IID=1;
UPDATE Hospital SET Region='Grand Casablanca' WHERE HID=2;

-- DELETE Cancelled Appointment
DELETE FROM Appointment WHERE CAID=1003 AND Status='Cancelled';