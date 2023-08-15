-- Create the Hospital Database

-- Create Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
);

-- Create Doctors table
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create Patients table
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender CHAR(1),
    ContactNumber VARCHAR(15),
    Address VARCHAR(100)
);

-- Create Appointments table
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    DoctorID INT,
    PatientID INT,
    AppointmentDate DATETIME,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Create Prescriptions table
CREATE TABLE Prescriptions (
    PrescriptionID INT PRIMARY KEY,
    AppointmentID INT,
    PrescriptionText TEXT,
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

-- Create LabTests table
CREATE TABLE LabTests (
    TestID INT PRIMARY KEY,
    PatientID INT,
    TestName VARCHAR(100),
    TestDate DATE,
    TestResult TEXT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);


-- Insert data into Departments table
INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
    (1, 'Cardiology'),
    (2, 'Orthopedics'),
    (3, 'Gastroenterology'),
    (4, 'Neurology');

-- Insert data into Doctors table
INSERT INTO Doctors (DoctorID, FirstName, LastName, DepartmentID)
VALUES
    (1, 'John', 'Smith', 1),
    (2, 'Jane', 'Doe', 2),
    (3, 'Michael', 'Johnson', 3),
    (4, 'Emily', 'Williams', 4);

-- Insert data into Patients table
INSERT INTO Patients (PatientID, FirstName, LastName, DateOfBirth, Gender, ContactNumber, Address)
VALUES
    (1, 'Alice', 'Johnson', '1990-05-15', 'F', '123-456-7890', '123 Main St'),
    (2, 'Bob', 'Smith', '1985-09-22', 'M', '987-654-3210', '456 Elm St');

-- Insert data into Appointments table
INSERT INTO Appointments (AppointmentID, DoctorID, PatientID, AppointmentDate)
VALUES
    (1, 1, 1, '2023-08-15 10:00:00'),
    (2, 2, 2, '2023-08-16 14:30:00');

-- Insert data into Prescriptions table
INSERT INTO Prescriptions (PrescriptionID, AppointmentID, PrescriptionText)
VALUES
    (1, 1, 'Take medication A twice daily for a week.'),
    (2, 2, 'Apply ointment B to the affected area.');

-- Insert data into LabTests table
INSERT INTO LabTests (TestID, PatientID, TestName, TestDate, TestResult)
VALUES
    (1, 1, 'Blood Test', '2023-08-15', 'Normal'),
    (2, 2, 'X-ray', '2023-08-16', 'Fracture detected');

-- Queries

SELECT DepartmentName FROM Departments;

SELECT
    A.AppointmentDate,
    D.FirstName AS DoctorFirstName,
    D.LastName AS DoctorLastName,
    P.FirstName AS PatientFirstName,
    P.LastName AS PatientLastName
FROM Appointments A
JOIN Doctors D ON A.DoctorID = D.DoctorID
JOIN Patients P ON A.PatientID = P.PatientID;

SELECT * FROM Patients WHERE Gender = 'F';

SELECT
    D.FirstName,
    D.LastName,
    COUNT(A.AppointmentID) AS TotalAppointments
FROM Doctors D
LEFT JOIN Appointments A ON D.DoctorID = A.DoctorID
GROUP BY D.DoctorID;


SELECT
    FirstName,
    LastName
FROM Patients
WHERE PatientID IN (
    SELECT PatientID
    FROM Appointments
    WHERE DoctorID = 1
);


SELECT
    FirstName,
    LastName,
    CASE Gender
        WHEN 'M' THEN 'Male'
        WHEN 'F' THEN 'Female'
        ELSE 'Other'
    END AS Gender
FROM Patients;


SELECT
    D1.FirstName AS Doctor1FirstName,
    D1.LastName AS Doctor1LastName,
    D2.FirstName AS Doctor2FirstName,
    D2.LastName AS Doctor2LastName,
    D1.DepartmentID
FROM Doctors D1
JOIN Doctors D2 ON D1.DepartmentID = D2.DepartmentID
WHERE D1.DoctorID < D2.DoctorID;
