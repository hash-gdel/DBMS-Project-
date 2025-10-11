
CREATE TABLE Patient (
  IID VARCHAR(20) NOT NULL,
  CIN VARCHAR(100),
  pa_name VARCHAR(100),
  Birth DATE,
  Sex VARCHAR(100),
  BloodGroup VARCHAR(5),
  Phone VARCHAR(20),
  PRIMARY KEY(IID)
);

CREATE TABLE Contact_Location (
  CLID VARCHAR(50) NOT NULL,
  City VARCHAR(20),
  Province VARCHAR(50),
  Street INT,
  contact_number INT,
  Postal_code VARCHAR(30),
  contact_Phone VARCHAR(20),
  PRIMARY KEY(CLID)
);

CREATE TABLE Have (
  CLID VARCHAR(50),
  IID VARCHAR(20),
  PRIMARY KEY(CLID, IID),
  FOREIGN KEY (CLID) REFERENCES Contact_Location(CLID),
  FOREIGN KEY (IID) REFERENCES Patient(IID)
);

CREATE TABLE Insurance (
  InsID VARCHAR(100) NOT NULL,
  Type_Ins VARCHAR(100),
  PRIMARY KEY(InsID)
);

CREATE TABLE Covers (
  IID VARCHAR(20),
  InsID VARCHAR(100),
  PRIMARY KEY (IID, InsID),
  FOREIGN KEY (IID) REFERENCES Patient(IID),
  FOREIGN KEY (InsID) REFERENCES Insurance(InsID)
);

CREATE TABLE Expense_Attached (
  Total VARCHAR(100),
  ExID VARCHAR(100) NOT NULL,
  InsID VARCHAR(100),
  PRIMARY KEY(ExID),
  FOREIGN KEY(InsID) REFERENCES Insurance(InsID)
);

CREATE TABLE Hospital (
  HID VARCHAR(100) NOT NULL,
  Name_H VARCHAR(100),
  City VARCHAR(100),
  Region VARCHAR(100),
  PRIMARY KEY(HID)
);

CREATE TABLE Department_belongs (
  Name_Dep VARCHAR(100),
  DEP_ID VARCHAR(100) NOT NULL,
  Specialty VARCHAR(100),
  HID VARCHAR(100),
  FOREIGN KEY(HID) REFERENCES Hospital(HID),
  PRIMARY KEY (DEP_ID)
);

CREATE TABLE Staff (
  Staff_ID VARCHAR(20) NOT NULL,
  Staff_Name VARCHAR(100),
  Staff_Status VARCHAR(100),
  PRIMARY KEY(Staff_ID)
);

CREATE TABLE Caregiving (
  Staff_ID VARCHAR(20),
  Grade INT,
  Ward VARCHAR(100),
  PRIMARY KEY (Staff_ID),
  FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID) ON DELETE CASCADE
);

CREATE TABLE Technical (
  Staff_ID VARCHAR(20),
  Modality VARCHAR(100),
  Certifications VARCHAR(100),
  PRIMARY KEY (Staff_ID),
  FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID) ON DELETE CASCADE
);

CREATE TABLE Practionner (
  Staff_ID VARCHAR(20),
  licenseNumber INT,
  Speciality VARCHAR(100),
  PRIMARY KEY (Staff_ID),
  FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID) ON DELETE CASCADE
);

CREATE TABLE Work_In (
  Staff_ID VARCHAR(20) ,
  DEP_ID VARCHAR(100),
  PRIMARY KEY (Staff_ID),
  FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID),
  FOREIGN KEY (DEP_ID) REFERENCES Department_belongs(DEP_ID)
);

CREATE TABLE ClinicalActivity(
  CAID VARCHAR(100),
  activity_time TIME,
  activity_date DATE,
  DEP_ID VARCHAR(100) NOT NULL,
  Staff_ID VARCHAR(20) NOT NULL,
  IID VARCHAR(20) NOT NULL,
  generates_expense VARCHAR(100),
  generate_prescription VARCHAR(100),
  PRIMARY KEY(CAID),
  FOREIGN KEY(IID) REFERENCES Patient(IID),
  FOREIGN KEY(DEP_ID) REFERENCES Department_belongs(DEP_ID),
  FOREIGN KEY(Staff_ID) REFERENCES Staff(Staff_ID)
);

CREATE TABLE Appointment (
  CAID VARCHAR(100),
  Reason VARCHAR(100),
  Appointment_Status VARCHAR(100),
  PRIMARY KEY(CAID),
  FOREIGN KEY (CAID) REFERENCES ClinicalActivity(CAID) ON DELETE CASCADE
);

CREATE TABLE Emergency (
  CAID VARCHAR(100),
  Triage_Level VARCHAR(100),
  Outcome VARCHAR(100),
  PRIMARY KEY(CAID),
  FOREIGN KEY (CAID) REFERENCES ClinicalActivity(CAID) ON DELETE CASCADE
);

CREATE TABLE Medication (
  Drug_ID VARCHAR(100) NOT NULL,
  Class VARCHAR(100),
  Med_Name VARCHAR(100),
  Form VARCHAR(100),
  Strength VARCHAR(100),
  Manufacturer CHAR(100),
  Active_ingredient VARCHAR(100),
  PRIMARY KEY (Drug_ID)
);

CREATE TABLE Stock (
  Drug_ID VARCHAR(100),
  HID VARCHAR(100),
  Unit_Price INT,
  Stock_Timestamp INT,
  Qty INT,
  Reorder_level VARCHAR(100),
  PRIMARY KEY(Drug_ID,HID),
  FOREIGN KEY (Drug_ID) REFERENCES Medication(Drug_ID),
  FOREIGN KEY (HID) REFERENCES Hospital(HID)
);

CREATE TABLE Prescription_generate (
  PID VARCHAR(100),
  DateIssued DATE,
  PRIMARY KEY (PID)
);

CREATE TABLE include (
  PID VARCHAR(100),
  Drug_ID VARCHAR(100),
  duration INT,
  Dosage VARCHAR(100),
  PRIMARY KEY(PID,Drug_ID),
  FOREIGN KEY (PID) REFERENCES Prescription_generate(PID),
  FOREIGN KEY (Drug_ID) REFERENCES Medication(Drug_ID)
);



INSERT INTO Patient (IID, pa_name, Birth, Sex) VALUES
('P001', 'Karim El Amrani', '1985-01-12', 'M'),
('P002', 'Yasmine Bouziane', '1992-06-23', 'F');

INSERT INTO Contact_Location (CLID, City, contact_Phone) VALUES
('CL01', 'Benguerir', '+212537000001'),
('CL02', 'Marrakech', '+212524000002');

INSERT INTO Have (CLID, IID) VALUES
('CL01', 'P001'),
('CL02', 'P002');

INSERT INTO Insurance (InsID, Type_Ins) VALUES
('I001', 'Health Insurance'),
('I002', 'Basic Insurance');

INSERT INTO Covers (IID, InsID) VALUES
('P001', 'I001'),
('P002', 'I002');

INSERT INTO Expense_Attached (ExID, Total, InsID) VALUES
('E001', '1500', 'I001'),
('E002', '2300', 'I002');

INSERT INTO Hospital (HID, Name_H, City) VALUES
('H001', 'Marrakech General Hospital', 'Marrakech'),
('H002', 'Benguerir Clinic', 'Benguerir');

INSERT INTO Department_belongs (DEP_ID, Name_Dep, HID) VALUES
('D001', 'Cardiology', 'H001'),
('D002', 'Neurology', 'H002');

INSERT INTO Staff (Staff_ID, Staff_Name, Staff_Status) VALUES
('S001', 'Dr. Ahmed El Fassi', 'Cardiologist'),
('S002', 'Nadia Bensalem', 'Nurse');

INSERT INTO Caregiving (Staff_ID, Grade, Ward) VALUES
('S001', 1, 'Ward A'),
('S002', 2, 'Ward B');

INSERT INTO Technical (Staff_ID, Modality, Certifications) VALUES
('S001', 'MRI', 'Certified'),
('S002', 'X-Ray', 'Certified');

INSERT INTO Practionner (Staff_ID, licenseNumber, Speciality) VALUES
('S001', 12345, 'Cardiology'),
('S002', 54321, 'Neurology');

INSERT INTO Work_In (Staff_ID, DEP_ID) VALUES
('S001', 'D001'),
('S002', 'D002');

INSERT INTO ClinicalActivity (CAID, activity_date, DEP_ID, Staff_ID, IID) VALUES
('CA001', '2025-03-10', 'D001', 'S001', 'P001'),
('CA002', '2025-04-15', 'D002', 'S002', 'P002');

INSERT INTO Appointment (CAID, Reason, Status) VALUES
('CA001', 'Checkup', 'Done'),
('CA002', 'Consultation', 'Pending');

INSERT INTO Emergency (CAID, Triage_Level, Outcome) VALUES
('CA001', 'High', 'Stable'),
('CA002', 'Medium', 'Recovered');

INSERT INTO Medication (Drug_ID, Med_Name, Strength) VALUES
('M001', 'Paracetamol', '500mg'),
('M002', 'Amoxicillin', '250mg');

INSERT INTO Stock (Drug_ID, HID, Unit_Price, Stock_Timestamp, Qty) VALUES
('M001', 'H001', 5, 20251010, 500),
('M002', 'H002', 10, 20251010, 300);

INSERT INTO Prescription_generate (PID, DateIssued) VALUES
('PRG001', '2025-02-01'),
('PRG002', '2025-03-10');

INSERT INTO include (PID, Drug_ID, duration, Dosage) VALUES
('PRG001', 'M001', 5, '2/day'),
('PRG002', 'M002', 7, '3/day');


SELECT DISTINCT p.pa_name
FROM Patient p
JOIN ClinicalActivity ca ON p.IID = ca.IID
JOIN Department_belongs d ON ca.DEP_ID = d.DEP_ID
JOIN Hospital h ON d.HID = h.HID
JOIN Appointment a ON a.CAID = ca.CAID
WHERE h.City = 'Benguerir';

