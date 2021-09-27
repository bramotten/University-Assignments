-- sqlite3 ".read setup.sql" ".read part12.sql"

-- PRAGMA foreign_keys = ON; -- makes constraints be... constraints.

DROP TABLE IF EXISTS has_Record;
CREATE TABLE has_Record(
    -- Slide 3.24
    pid INTEGER,
    rid INTEGER,
    description STRING,
    PRIMARY KEY(pid, rid),
    FOREIGN KEY(pid) REFERENCES checks_Patient ON DELETE CASCADE
);

DROP TABLE IF EXISTS checks_Patient;
CREATE TABLE checks_Patient(
    -- Slide 3.22
    pid INTEGER,
    name STRING,
    age INTEGER,
    ssn INTEGER,
    PRIMARY KEY(pid),
    FOREIGN KEY(ssn) REFERENCES Doctor
);

DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee(
    ssn INTEGER,
    name STRING,
    adress STRING,
    PRIMARY KEY(ssn)
);

DROP TABLE IF EXISTS Doctor;
CREATE TABLE Doctor(
    ssn INTEGER,
    specialty STRING,
    qualification STRING,
    PRIMARY KEY(ssn),
    FOREIGN KEY(ssn) REFERENCES Employee ON DELETE CASCADE
);

DROP TABLE IF EXISTS Nurse;
CREATE TABLE Nurse(
    ssn INTEGER,
    rank STRING,
    PRIMARY KEY(ssn),
    FOREIGN KEY(ssn) REFERENCES Employee ON DELETE CASCADE
);

DROP TABLE IF EXISTS governs;
CREATE TABLE governs(
    -- Slide 3.21
    ssn INTEGER,
    num INTEGER,
    PRIMARY KEY(num),
    FOREIGN KEY(ssn) REFERENCES Nurse
    FOREIGN KEY(num) REFERENCES Room
);

DROP TABLE IF EXISTS Room;
CREATE TABLE Room(
    num INTEGER,
    capacity INTEGER,
    PRIMARY KEY(num)
);