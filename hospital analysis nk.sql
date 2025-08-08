-- Hospital Dataset ANalysis -- 

create database if not exists hsp_db;
use hsp_db;

-- importing csv and table as per data

show tables ;  -- it shows all tables in a data base

show columns from hsp_info ;  -- it shows all column of a table
Desc hsp_info ;  -- It shows column_names and its data type (same as above)

select * from hsp_info;

-- Name changed due to loading it has some extra sopecial characters
ALTER TABLE hsp_info
CHANGE `ï»¿Hospital Name` Hospital_name VARCHAR(50);

--  total rows
select count(*) as total_rows from hsp_info;

--  Total Columns
select count(*) as total_columns 
from information_schema.columns
where table_schema = "hsp_db" AND
table_name = "hsp_info" ;

## Q1. Total Number of Patients
select count(*)as total_count from hsp_info; 

## Q2. Average Number of Doctors per Hospital
select hospital_name , avg(`Doctors Count`) as avg_doctor_count from hsp_info group by hospital_name ;   -- if a column name contains space it should be enclosed with``

-- as we can see all columns name have space which is not a standard way of column name so we have to correct it 
show columns from hsp_info ;

ALTER TABLE hsp_info CHANGE `Doctors Count` doctors_count int;
ALTER TABLE hsp_info CHANGE `patientss_count` patients_count INT;
ALTER TABLE hsp_info CHANGE `Admission Date` Admission_Date varchar(20) ;
ALTER TABLE hsp_info CHANGE `Discharge Date` Discharge_Date varchar(20) ;
ALTER TABLE hsp_info CHANGE `Medical Expenses` Medical_Expenses double;

## Q3. Top 3 Departments with the Highest Number of Patients
select department , sum(patients_count) as total_patients from hsp_info group by department order by total_patients desc limit 3 ;

## Q4.  Hospital with the Maximum Medical Expenses 
select hospital_name , sum(medical_expenses) as total_expense from hsp_info group by hospital_name order by total_expense desc limit 1 ; 

## Q5. Calculate the average medical expenses per day for each hospital.
select hospital_name , 
str_to_date(admission_date , "%d-%m-%Y") as admission_dt ,
str_to_date(discharge_date , "%d-%m-%Y") as discharge_dt from hsp_info ;   --- it will show hospital ame , admission date and discharge date with data type as DATE

SELECT 
  hospital_name,
  SUM(Medical_Expenses) AS total_expense,
  SUM(DATEDIFF(
    STR_TO_DATE(Discharge_Date, '%d-%m-%Y'),
    STR_TO_DATE(Admission_Date, '%d-%m-%Y')
  )) AS total_days,
  round(SUM(Medical_Expenses) / SUM(DATEDIFF(
    STR_TO_DATE(Discharge_Date, '%d-%m-%Y'),
    STR_TO_DATE(Admission_Date, '%d-%m-%Y')
  )),2) AS avg_expense_per_day
FROM 
  hsp_info
GROUP BY 
  hospital_name;
  
## Q6.   Find the hospital with the longest stay by calculating the difference between Discharge Date and Admission Date.
  select hospital_name , 
  sum(datediff(str_to_date(Discharge_date , "%d-%m-%Y") , str_to_date(admission_date, "%d-%m-%Y"))) as total_stay_days 
  from hsp_info 
  group by 1 order by total_stay_days desc ;


## Q7. Count the total number of patients treated in each city.
select location , sum(patients_count) as count_patient from hsp_info group by 1 order by count_patient desc ;

## Q8. Calculate the average number of days patients spend in each department. 
select department , avg(datediff(str_to_date(discharge_date , "%m-%d-%Y") , str_to_date(admission_date , "%m-%d-%Y"))) as avg_day_spent from hsp_info group by 1 ;

## Q9.  Find the department with the least number of patients.
select department , sum(patients_count) as total_patient from hsp_info group by 1 order by total_patient asc limit 1 ;

## Q10. Group the data by month and calculate the total medical expenses for each month.
select month(str_to_date(admission_date , "%d-%m-%Y")) as month_no , round(sum(medical_expenses),2) as total_expense
from hsp_info group by 1 order by month_no ;

-- 2nd way-- extract month & year together
SELECT DATE_FORMAT(STR_TO_DATE(Admission_date, '%d-%m-%Y'), '%Y-%m') AS month_year,
round(SUM(Medical_Expenses),2) AS total_expenses
FROM hsp_info group by 1 order by month_year ;

-- -------
## END ##
-- -------


















