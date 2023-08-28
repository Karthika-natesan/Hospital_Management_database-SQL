# Hospital_Management_database-SQL

Tables Description
physician:
•	employeeid — this is a unique ID of a physician
•	name — this is the name of a physician
•	position — this is the designation of a physician
•	ssn — this is a security number of a physician
department:
•	departmentid — this is a unique ID for a department
•	name — this is the name of a department
•	head — this is the ID of the physician who is the head of a department, referencing to the column employeeid of the table physician
affiliated_with:
•	physician — this is the ID of the physicians which is referencing to the column employeeid of the physician table
•	department — this is the ID the department which is referencing to the column departmentid of the department table
•	primaryaffiliation — this is a logical column which indicate that whether the physicians are yet to be affiliated or not
•	Note: The combination of physician, department will come once in that table.
procedure:
•	code — this is the unique ID of a medical procedure
•	name — the name of the medical procedure
•	cost — the cost for the procedure
trained_in:
•	physician — this is ID of the physicians which is referencing to the column employeeid of the physician table
•	treatment — this is the ID of the medical procedure which is referencing to the column code of the procedure table
•	certificationdate — this is the starting date of certification
•	certificationexpires — this is the expiry date of certification
•	Note: The combination of physician and treatement will come once in that table.
patient:
•	ssn — this is a unique ID for each patient
•	name — this is the name of the patient
•	address — this is the address of the patient
•	phone — this is the phone number of the patient
•	insuranceid — this is the insurance id of the patient
•	pcp — this is the ID of the physician who primarily checked up the patient which is referencing to the column employeeid of the physician table
nurse:
•	employeeid — this is the unique ID for a nurse
•	name — name of the nurses
•	position — the designation of the nurses
•	registered — this is a logical column which indicate that whether the nurses are registered for nursing or not
•	ssn — this is the security number of a nurse
appointment:
•	appointmentid — this is the unique ID for an appointment
•	patient — this is the ID of each patient which is referencing to the ssn column of patient table
•	prepnurse — the ID of the nurse who may attend the patient with the physician, which is referencing to the column employeeid of the nurse table
•	physician — this is the ID the physicians which is referencing to the employeeid column of the physician table
•	start_dt_time — this is the schedule date and approximate time to meet the physician
•	end_dt_time — this is the schedule date and approximate time to end the meeting
•	examinationroom — this the room where to meet a patient to the physician
medication:
•	code — this is the unique ID for a medicine
•	name — this is the name of the medicine
•	brand — this is the brand of the medicine
•	description — this is the description of the medicine
prescribes:
•	physician — this is the ID of the physician referencing to the employeeid column of the physician table
•	patient — this is the ID of the patient which is referencing to the ssn column of the patient table
•	medication — the ID of the medicine which is referencing to the code of the medication table
•	date — the date and time of the prescribed medication
•	appointment — the prescription made by the physician to a patient who may taken an appointment which is referencing to column appointmentid of appointment table
•	dose — the dose prescribed by the physician
•	Note: The combination of physician, patient, medication, date will come once in that table.
block:
•	blockfloor — ID of the floor
•	blockcode — ID of the block
•	Note: The combination of blockfloor, blockcode will come once in that table.
room:
•	roomnumber — this is the unique ID of a room
•	roomtype — this is type of room
•	blockfloor — this is the floor ID where the room in
•	blockcode — this is the ID of the block where the room in
•	unavailable — this is the logical column which indicate that whether the room is available or not
•	Note: The blockfloor and blockcode columns are referring to the combination of blockfloor and blockcode columns of the table block.
on_call:
•	nurse — this is ID of the nurse which is referencing to the employeeid column of the table nurse
•	blockfloor — this is the ID of the floor
•	blockcode — this is the ID of block
•	oncallstart — the starting date and time of on call duration
•	oncallend — the ending date and time of on call duration
•	Note: The combination of nurse, blockfloor, blockcode, oncallstart, oncallend will come once in that table and the combination of blockfloor, blockcode columns are referring to the combination of blockfloor and blockcode columns of the table block.


QUESTIONS: 
1.	 Obtain the names of all physicians that have performed a medical procedure they have never been certified to perform.
2.	Same as the previous query, but include the following information in the results:Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on.
3.	Obtain the names of all physicians that have performed a medical procedure that they are certified to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires).
4.	Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on, and date when the certification expired.
5.	Obtain the information for appointments where a patient met with a physician other than his/her primary care physician. Show the following information: Patient name, physician name, nurse name (if any), start and end time of appointment, examination room, and the name of the patient's primary care physician.
6.	The Patient field in Undergoes is redundant, since we can obtain it from the Stay table. There are no constraints in force to prevent inconsistencies between these two tables. More specifically, the Undergoes table may include a row where the patient ID does not match the one we would obtain from the Stay table through the Undergoes. Stay foreign key. Select all rows from Undergoes that exhibit this inconsistency.
7.	Obtain the names of all the nurses who have ever been on call for room 123.
8.	The hospital has several examination rooms where appointments take place. Obtain the number of appointments that have taken place in each examination room.
9.	Obtain the names of all patients (also include, for each patient, the name of the patient's primary care physician), such that \emph{all} the following are true:
•	The patient has been prescribed some medication by his/her primary care physician.
•	The patient has undergone a procedure with a cost larger that $5,000
•	The patient has had at least two appointment where the nurse who prepped the appointment was a registered nurse.
•	The patient's primary care physician is not the head of any department.
