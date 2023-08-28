use hospital_management;

# 1. Obtain the names of all physicians that have performed a medical procedure they have never been certified to perform. 

SELECT * from Trained_in;
select * from physician;
select * from undergoes;

SELECT name FROM physician where employeeID in (select physician from undergoes u where not exists 
(select * from trained_in where treatment = u.procedures and physician = u.physician ));
 
-- or
SELECT Name FROM Physician WHERE EmployeeID IN
(SELECT U.Physician FROM Undergoes u LEFT JOIN Trained_In T
ON u.Physician=T.Physician
AND u.Procedures=T.Treatment
WHERE Treatment IS NULL);

-- or 
SELECT Name FROM physician p INNER JOIN undergoes u ON p.employeeID = u.physician 
LEFT JOIN trained_in t ON u.procedures = t.treatment AND p.employeeID = t.physician 
WHERE t.treatment IS NULL;

# 2. Same as the previous query, but include the following information in the results:
 -- Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on.
 
SELECT p.Name, pr.name,u.dateundergoes,u.patient FROM physician p INNER JOIN undergoes u ON p.employeeID = u.physician 
LEFT JOIN trained_in t ON u.procedures = t.treatment AND p.employeeID = t.physician 
INNER JOIN procedures pr on u.procedures = pr.Code
WHERE t.treatment IS NULL;

-- or
 SELECT P.Name AS Physician, Pr.Name AS Procedures, U.dateundergoes, Pt.Name AS Patient 
  FROM Physician P, Undergoes U, Patient Pt, Procedures Pr
  WHERE U.Patient = Pt.SSN
    AND U.Procedures = Pr.Code
    AND U.Physician = P.EmployeeID
    AND NOT EXISTS 
              (
                SELECT * FROM Trained_In T
                WHERE T.Treatment = U.Procedures 
                AND T.Physician = U.Physician
              );

# 3. Obtain the names of all physicians that have performed a medical procedure that they are certified to perform,
-- but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires).

SELECT p.name FROM physician p INNER JOIN undergoes u ON p.employeeID = u.physician 
LEFT JOIN trained_in t ON p.employeeID = t.physician 
WHERE U.dateundergoes>T.CertificationExpires;

-- or

SELECT P.Name FROM 
 Physician AS P,    
 Trained_In T,
 Undergoes AS U
 WHERE T.Physician=U.Physician AND T.Treatment=U.Procedures AND U.dateundergoes>T.CertificationExpires AND P.EmployeeID=U.Physician;

# 4. Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, 
-- name of the patient the procedure was carried out on, and date when the certification expired.

SELECT p.name AS Physician, pr.name AS Procedures, U.dateundergoes, u.patient,T.CertificationExpires FROM physician p INNER JOIN undergoes u ON p.employeeID = u.physician 
LEFT JOIN trained_in t ON p.employeeID = t.physician INNER JOIN procedures pr ON t.treatment = pr.code
WHERE U.dateundergoes>T.CertificationExpires;

-- or

SELECT P.Name AS Physician, Pr.Name AS Procedures, U.dateundergoes, Pt.Name AS Patient, T.CertificationExpires
  FROM Physician P, Undergoes U, Patient Pt, Procedures Pr, Trained_In T
  WHERE U.Patient = Pt.SSN
    AND U.Procedures = Pr.Code
    AND U.Physician = P.EmployeeID
    AND Pr.Code = T.Treatment
    AND P.EmployeeID = T.Physician
    AND U.dateundergoes > T.CertificationExpires;
    
# 5. Obtain the information for appointments where a patient met with a physician other than his/her primary care physician. Show the following information: 
-- Patient name, physician name, nurse name (if any), start and end time of appointment, examination room, and the name of the patient's primary care physician.

SELECT Pt.Name AS Patient, Ph.Name AS Physician, N.Name AS Nurse, A.Starto, A.Endo, A.ExaminationRoom, PhPCP.Name AS PCP
  FROM Patient Pt, Physician Ph, Physician PhPCP, Appointment A LEFT JOIN Nurse N ON A.PrepNurse = N.EmployeeID
 WHERE A.Patient = Pt.SSN
   AND A.Physician = Ph.EmployeeID
   AND Pt.PCP = PhPCP.EmployeeID
   AND A.Physician <> Pt.PCP;
   
# 6. The Patient field in Undergoes is redundant, since we can obtain it from the Stay table. 
-- There are no constraints in force to prevent inconsistencies between these two tables. 
-- More specifically, the Undergoes table may include a row where the patient ID does not match the one we would obtain from the Stay table through the Undergoes.
-- Stay foreign key. Select all rows from Undergoes that exhibit this inconsistency.

SELECT * FROM Undergoes U
 WHERE Patient <> 
   (
     SELECT Patient FROM Stay S
      WHERE U.Stay = S.StayID
   );


# 7. Obtain the names of all the nurses who have ever been on call for room 123.
CREATE VIEW x as (
SELECT n.name , r.roomNumber from nurse n INNER JOIN on_call oc ON 
n.employeeID = oc.nurse RIGHT JOIN block b ON  
oc.blockcode = b.blockcode inner join room r ON
b.blockcode = r.blockcode GROUP BY  n.name , r.roomNumber 
having r.roomNumber = 123); 
SELECT name FROM x;

-- or 

SELECT N.Name FROM Nurse N
 WHERE EmployeeID IN
   (
     SELECT OC.Nurse FROM On_Call OC, Room R
      WHERE OC.BlockFloor = R.BlockFloor
        AND OC.BlockCode = R.BlockCode
        AND R.roomNumber = 123
   );
   
# 8. The hospital has several examination rooms where appointments take place. Obtain the number of appointments that have taken place in each examination room.
SELECT ExaminationRoom, COUNT(AppointmentID) AS Number FROM Appointment
GROUP BY ExaminationRoom;

# 9. Obtain the names of all patients (also include, for each patient, the name of the patient's primary care physician), such that \emph{all} the following are true:
-- The patient has been prescribed some medication by his/her primary care physician.
-- The patient has undergone a procedure with a cost larger that $5,000
-- The patient has had at least two appointment where the nurse who prepped the appointment was a registered nurse.
-- The patient's primary care physician is not the head of any department.

SELECT Pt.Name, PhPCP.Name FROM Patient Pt, Physician PhPCP
 WHERE Pt.PCP = PhPCP.EmployeeID
   AND EXISTS
       (
         SELECT * FROM Prescribes Pr
          WHERE Pr.Patient = Pt.SSN
            AND Pr.Physician = Pt.PCP
       )
   AND EXISTS
       (
         SELECT * FROM Undergoes U, Procedures Pr
          WHERE U.Procedure = Pr.Code
            AND U.Patient = Pt.SSN
            AND Pr.Cost > 5000
       )
   AND 2 <=
       (
         SELECT COUNT(A.AppointmentID) FROM Appointment A, Nurse N
          WHERE A.PrepNurse = N.EmployeeID
            AND N.Registered = 1
            AND A.Patient = Pt.SSN
       )
   AND NOT Pt.PCP IN
       (
          SELECT Head FROM Department
       );
       
# 10. From the nurse table, find those nurses who are yet to be registered. Return all the fields of nurse table.

SELECT * FROM nurse WHERE registered = 0;


