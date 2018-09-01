1. For each Physician, produce a report of all patients they admitted in a given period. Output the Physician's full name, the patient's name, data admitted, care center, and bed number.
 
SELECT
    CONCAT(p1.lastname, ', ', p1.firstname) Physician,
    CONCAT(p2.lastname, ', ', p2.firstname) Patient,
    pat.AdmittanceDate 'Date Admitted',
    b.BedNumber 'Bed Number', 
    c.CareCenterName Carecenter
FROM
    physicianpatients p
    INNER JOIN
    person p2 ON p2.PersonRole LIKE '%Patient%'
    INNER JOIN
    person p1 ON p1.PersonRole LIKE '%Physician%'
    INNER JOIN patient pat ON p.PatientID = pat.PatientID
    INNER JOIN physician phy ON p.PhysicianID = phy.PhysicianID
    INNER JOIN bed b ON p.PatientID = b.PatientID
    INNER JOIN carecenter c ON pat.CareCenterID = c.CareCenterID
    WHERE 
    p2.PersonID IN (SELECT patient.PersonID FROM patient WHERE patient.PatientID = p.PatientID)
    AND
    p1.PersonID IN (SELECT physician.PersonID FROM physician WHERE physician.PhysicianID = p.PhysicianID)
    AND pat.AdmittanceDate BETWEEN '1983-01-01' AND '1995-12-29'
 
 
 
 
 
 
 
 
 
 
 
2. For any given medication (medication name to be supplied at run-time), list the first & last name each patient who received, and physician who prescribed the medication.
 
SELECT
    CONCAT(p2.lastname, ', ', p2.firstname) Patient,
    CONCAT(p1.lastname, ', ', p1.firstname) Physician,
    t.TreatmentTime TreatTime,
    i.ItemName, i.itemDescription
    FROM
    treatment t
    INNER JOIN person p2 ON p2.PersonRole LIKE '%Patient%'
    INNER JOIN person p1 ON p1.PersonRole LIKE '%Physician%'
    INNER JOIN patient pat ON t.PatientID = pat.PatientID
    INNER JOIN physician phy ON t.PhysicianID = phy.PhysicianID
    INNER JOIN treatmentitem ti ON t.TreatmentID = ti.TreatmentID
    INNER JOIN item i ON ti.ItemID = i.ItemID
    INNER JOIN treatmentmedication tmed ON t.TreatmentID = tmed.TreatmentID
    INNER JOIN medication med ON tmed.MedID = med.MedID
    WHERE 
    p2.PersonID IN (SELECT patient.PersonID FROM patient WHERE patient.PatientID = t.PatientID)
    AND
    p1.PersonID IN (SELECT physician.PersonID FROM physician WHERE physician.PhysicianID = t.PhysicianID)
    AND
    med.MedName = 'Morphine'
 
 
3. Produce a list of currently admitted patients.  Output the patient's first and last name, their admitting doctor, admittance date, care center, room and bed number, and attending head nurse.
 
SELECT
    CONCAT(p1.lastname, ', ', p1.firstname) Physician,
    CONCAT(p2.lastname, ', ', p2.firstname) Patient,
    pat.AdmittanceDate 'Date Admitted',
    c.CareCenterName Carecenter,
    b.BedNumber 'Bed Number',
    b.RoomNumber 'Room Number',
    CONCAT(n.lastname, ', ', n.firstname) 'Nurse In Charge'
FROM
    physicianpatients p
    INNER JOIN person p2 ON p2.PersonRole LIKE '%Patient%'
    INNER JOIN person p1 ON p1.PersonRole LIKE '%Physician%'
    INNER JOIN person n ON n.PersonRole LIKE '%Nurse%'
    INNER JOIN patient pat ON p.PatientID = pat.PatientID
    INNER JOIN physician phy ON p.PhysicianID = phy.PhysicianID
    INNER JOIN bed b ON p.PatientID = b.PatientID
    INNER JOIN carecenter c ON pat.CareCenterID = c.CareCenterID
    WHERE 
    p2.PersonID IN (SELECT patient.PersonID FROM patient WHERE patient.PatientID = p.PatientID)
    AND
    p1.PersonID IN (SELECT physician.PersonID FROM physician WHERE physician.PhysicianID = p.PhysicianID)
    AND
    n.PersonID IN (SELECT employee.PersonID FROM employee WHERE employee.EmployeeID IN (SELECT nurse.EmployeeID FROM nurse WHERE nurse.NurseID = c.NurseIDInCharge))
 
4. Produce a list of nurses who have an RN certificate, but are *not* currently in charge of any care centres.
 
SELECT DISTINCT
    CONCAT(n.lastname, ', ', n.firstname) 'Nurse In Charge',
    nur.Certificate 
FROM
    nurse 
    INNER JOIN person n ON n.PersonRole LIKE '%Nurse%'
    INNER JOIN employee emp ON n.PersonID = emp.PersonID
    INNER JOIN carecenter c ON c.CareCenterID = emp.CareCenterID
    INNER JOIN nurse nur ON nur.EmployeeID = emp.EmployeeID
    WHERE 
     n.PersonID IN (SELECT employee.PersonID FROM employee
INNER JOIN carecenter ON carecenter.CareCenterID = employee.CareCenterID
INNER JOIN nurse ON nurse.EmployeeID = employee.EmployeeID
WHERE employee.EmployeeID IN 
(SELECT nurse.EmployeeID FROM nurse WHERE nurse.NurseID NOT IN (SELECT NurseIDInCharge FROM carecenter))
AND nurse.Certificate = 'yes')
 
 
  
 
5. Produce a report of all physicians who admitted patients within a specified period of time.  Output the admitting physician's name, patient names, and the admittance and discharge dates, and the names of the physician(s) who treated the patient.
 
SELECT
    CONCAT(p1.lastname, ', ', p1.firstname) Physician,
    CONCAT(p2.lastname, ', ', p2.firstname) Patient,
    CONCAT(p3.lastname, ', ', p3.firstname) 'Treatment Physician',
    pat.AdmittanceDate Admitted,
    pat.DischargeDate Discharged
FROM
    physicianpatients p
    INNER JOIN person p2 ON p2.PersonRole LIKE '%Patient%'
    INNER JOIN person p1 ON p1.PersonRole LIKE '%Physician%'
    INNER JOIN person p3 ON p3.PersonRole LIKE '%Physician%'
    INNER JOIN patient pat ON p.PatientID = pat.PatientID
    INNER JOIN physician phy ON p.PhysicianID = phy.PhysicianID
    INNER JOIN treatment tre ON tre.PatientID = pat.PatientID
    INNER JOIN carecenter c ON pat.CareCenterID = c.CareCenterID
    WHERE 
    p2.PersonID IN (SELECT patient.PersonID FROM patient WHERE patient.PatientID = p.PatientID)
    AND
    p1.PersonID IN (SELECT physician.PersonID FROM physician WHERE physician.PhysicianID = p.PhysicianID)
    AND
    p3.PersonID IN (SELECT physician.PersonID FROM physician WHERE physician.PhysicianID = tre.PhysicianID)
 
6. For each outpatient, list their name, the name of the physician they saw for each of their visits, and the date(s) of the visit(s), in chronological order.

SELECT
    CONCAT(p1.lastname, ', ', p1.firstname) Physician,
    CONCAT(p2.lastname, ', ', p2.firstname) Patient,
    v.Date 
FROM
    physicianpatients p
    INNER JOIN person p2 ON p2.PersonRole LIKE '%Patient%'
    INNER JOIN person p1 ON p1.PersonRole LIKE '%Physician%'
    INNER JOIN patient pat ON p.PatientID = pat.PatientID
    INNER JOIN physician phy ON p.PhysicianID = phy.PhysicianID
    INNER JOIN Visit v ON v.PatientID = pat.PatientID
    WHERE 
    p2.PersonID IN (SELECT patient.PersonID FROM patient WHERE patient.PatientID = p.PatientID)
    AND
    p1.PersonID IN (SELECT physician.PersonID FROM physician WHERE physician.PhysicianID = p.PhysicianID)
    AND
    pat.Outpatient = (SELECT outpatient FROM outpatient WHERE isOutpatient = 'yes')
    order by v.Date ASC
 
 
 
 
 
 
7. For each Care Center, list the full name of the Nurse in Charge, the full names of the patients in that care center, their bed number, and the patient's admitting physician, for any given time period.
 
SELECT
    CONCAT(p1.lastname, ', ', p1.firstname) Physician,
    CONCAT(p2.lastname, ', ', p2.firstname) Patient,
    c.CareCenterName Carecenter,
    b.BedNumber 'Bed Number',
    CONCAT(p3.lastname, ', ', p3.firstname) 'Nurse In Charge'
FROM
    physicianpatients p
    INNER JOIN person p2 ON p2.PersonRole LIKE '%Patient%'
    INNER JOIN person p1 ON p1.PersonRole LIKE '%Physician%'
    INNER JOIN person p3 ON p3.PersonRole LIKE '%Nurse%'
    INNER JOIN patient pat ON p.PatientID = pat.PatientID
    INNER JOIN physician phy ON p.PhysicianID = phy.PhysicianID
    INNER JOIN bed b ON p.PatientID = b.PatientID
    INNER JOIN carecenter c ON pat.CareCenterID = c.CareCenterID
    WHERE 
    p2.PersonID IN (SELECT patient.PersonID FROM patient WHERE patient.PatientID = p.PatientID)
    AND
    p1.PersonID IN (SELECT physician.PersonID FROM physician WHERE physician.PhysicianID = p.PhysicianID)
    AND
    p3.PersonID IN (SELECT employee.PersonID FROM employee WHERE employee.EmployeeID IN (SELECT nurse.EmployeeID FROM nurse WHERE nurse.NurseID = c.NurseIDInCharge))
 
 
8. List the complete medical history of a patient (name to be provided at run-time), including the admitting physician, hospital stay info (date of admittance, checkout, length of stay, care center and bed number) and/or visits (date/time of appointment), and any Treatments and/or Medications used.

SELECT
    CONCAT(p1.lastname, ', ', p1.firstname) Physician,
    sh.DateIn 'Day in', 
    sh.DateOut 'Day out', 
    DATEDIFF(sh.DateIn, sh.DateOut) Days,
    b.BedNumber 'Bed Number',
    c.CareCenterName, 
    i.ItemName,
    med.medName
    FROM patient pat
    INNER JOIN person p1 ON p1.PersonRole LIKE '%Physician%'
    INNER JOIN physician phy ON pat.PhysicianID = phy.PhysicianID
    INNER JOIN carecenter c ON pat.CareCenterID = c.CareCenterID
    INNER JOIN stayhistory sh ON sh.PatientID = pat.PatientID
    INNER JOIN bed b ON b.PatientID = pat.PatientID
    INNER JOIN treatmenthistory th ON th.HistoryID = sh.HistoryID
    INNER JOIN treatment tre ON th.TreatmentID = tre.TreatmentID
    INNER JOIN treatmentitem trei ON tre.TreatmentID = trei.TreatmentID
    INNER JOIN treatmentmedication trem ON tre.TreatmentID = trem.TreatmentID
    INNER JOIN item i ON i.ItemID = trei.ItemID
    INNER JOIN medication med ON med.MedID = trem.MedID
    WHERE 
    p1.PersonID IN (SELECT physician.PersonID FROM physician WHERE physician.PhysicianID = pat.PhysicianID)
 
 
9. Produce a 'bill' of medical expenses for a given patient for a particular admittance (date(s) to be provided at run time).  Output the length of stay (the difference in days between admittance date and discharge date), and the quantity, individual cost, and total cost of all items, medications, and procedures used to treat the patient.
 
SELECT
    CONCAT(p1.lastname, ', ', p1.firstname) Physician,
    DATEDIFF(sh.DateIn, sh.DateOut) Days,
    i.ItemName,
    trei.Quantity,
    i.ItemUnitCost 'Item Cost',
    med.medName,
    trem.Quantity,
    med.MedUnitCost 'Med Cost',
    TRUNCATE(((i.ItemUnitCost * trei.Quantity) + (med.MedUnitCost * trem.Quantity)), 2) Total
    FROM patient pat
    INNER JOIN person p1 ON p1.PersonRole LIKE '%Physician%'
    INNER JOIN person p2 ON p2.PersonRole LIKE '%Patient%'
    INNER JOIN physician phy ON pat.PhysicianID = phy.PhysicianID
    INNER JOIN carecenter c ON pat.CareCenterID = c.CareCenterID
    INNER JOIN stayhistory sh ON sh.PatientID = pat.PatientID
    INNER JOIN bed b ON b.PatientID = pat.PatientID
    INNER JOIN treatmenthistory th ON th.HistoryID = sh.HistoryID
    INNER JOIN treatment tre ON th.TreatmentID = tre.TreatmentID
    INNER JOIN treatmentitem trei ON tre.TreatmentID = trei.TreatmentID
    INNER JOIN treatmentmedication trem ON tre.TreatmentID = trem.TreatmentID
    INNER JOIN item i ON i.ItemID = trei.ItemID
    INNER JOIN medication med ON med.MedID = trem.MedID
    WHERE 
    p1.PersonID IN (SELECT physician.PersonID FROM physician WHERE physician.PhysicianID = pat.PhysicianID)
    AND
    CONCAT(p2.FirstName, " ", p2.LastName) = 
 
 
10. Produce a report of employees who worked at a particular care center during some period of time (info to be provided at run time).  Output the care center id, employee full name, the dates and number of hours that the employee worked, and the total number of hours worked by the employee during that period.
  
SELECT
    cc.CareCenterID,
    CONCAT(p1.lastname, ', ', p1.firstname) Employee,
    cr.EmployeeHours
    FROM clinicrecords cr
    INNER JOIN employee emp ON emp.EmployeeID = cr.EmployeeID
    INNER JOIN person p1 ON p1.PersonID = emp.PersonID
    INNER JOIN carecenter cc ON cc.CareCenterID = emp.CareCenterID
    WHERE
      <date> BETWEEN cr.DateStart AND cr.DateEnd
 
 
11. For each Employee, list the employee's full name, and all employment assignments (labs or care centers) since they were hired.  Output the employee's full name, the care center or lab, the start and end dates of the assignment. Order the report by employee last name, and sort by assignment start date, with their most recent assignment listed first.
    
SELECT
    p1.LastName 'Employee Lastname',
    p1.FirstName 'Employee Firstname',
    cc.CareCenterName,
    cr.DateStart, cr.DateEnd
    FROM clinicrecords cr
    INNER JOIN employee emp ON emp.EmployeeID = cr.EmployeeID
    INNER JOIN person p1 ON p1.PersonID = emp.PersonID
    INNER JOIN carecenter cc ON cc.CareCenterID = emp.CareCenterID  
ORDER BY `Employee Lastname` ASC
 
 
12. Hospital is missing a scalpel! It may be in a patient! List all the patient names, bed #, care center name, and physician name, where their treatment(s) used a scalpel, between two specified dates.
  
SELECT
    CONCAT(p1.FirstName, ' ', p1.LastName) 'Physician Name',
    CONCAT(p2.FirstName, ' ', p2.LastName) 'Patient Name',
    cc.CareCenterName,
    b.BedNumber
    FROM treatment t
    INNER JOIN patient pat ON pat.PatientID = t.PatientID
    INNER JOIN person p2 ON p2.PersonID = pat.PersonID
    INNER JOIN physician phy ON phy.PhysicianID = t.PhysicianID
    INNER JOIN person p1 ON p1.PersonID = phy.PersonID
    INNER JOIN bed b ON b.PatientID = pat.PatientID
    INNER JOIN carecenter cc ON cc.CareCenterID = pat.CareCenterID
    INNER JOIN treatmenthistory th ON th.TreatmentID = t.TreatmentID
    INNER JOIN treatmentitem ti ON ti.TreatmentID = t.TreatmentID
    INNER JOIN item i ON i.ItemID = ti.ItemID
    WHERE i.ItemName = 'Scalpel' AND t.TreatmentDate BETWEEN <start date> AND <end date>
 
 
 
13. For a given employee (name to be supplied at run-time), list each care center that they have worked at. Output the employee's name, the list the care center names, the start and end dates of the assignment to that care center, and the role they worked as.
 
  SELECT
    CONCAT(p2.FirstName, ' ', p2.LastName) 'Employee Name',
    cc.CareCenterName,
    cr.DateStart,
    cr.DateEnd,
    p2.PersonRole
    
    FROM employee emp
    
    INNER JOIN person p2 ON p2.PersonID = emp.PersonID
    INNER JOIN clinicrecords cr ON cr.EmployeeID = emp.EmployeeID
    INNER JOIN carecenter cc ON cc.CareCenterID = emp.CareCenterID
    
      WHERE CONCAT(p2.FirstName, ' ', p2.LastName) = 'NAME'

