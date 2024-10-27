/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
Database Load Issues (follow if receiving permission denied when running SQL code below)

NOTE: If you are having issues with permissions. And you get error: 

'could not open file "[your file path]\job_postings_fact.csv" for reading: Permission denied.'

1. Open pgAdmin
2. In Object Explorer (left-hand pane), navigate to `sql_course` database
3. Right-click `sql_course` and select `PSQL Tool`
    - This opens a terminal window to write the following code
4. Get the absolute file path of your csv files
    1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
5. Paste the following into `PSQL Tool`, (with the CORRECT file path)

\copy company_dim FROM '[Insert File Path]/company_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_dim FROM '[Insert File Path]/skills_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy job_postings_fact FROM '[Insert File Path]/job_postings_fact.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_job_dim FROM '[Insert File Path]/skills_job_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

*/

-- NOTE: This has been updated from the video to fix issues with encoding

COPY company_dim
FROM 'C:\Program Files\PostgreSQL\16\data\Datasets\sql_course\company_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_dim
FROM 'C:\Program Files\PostgreSQL\16\data\Datasets\sql_course\skills_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY job_postings_fact
FROM 'C:\Program Files\PostgreSQL\16\data\Datasets\sql_course\job_postings_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_job_dim
FROM 'C:\Program Files\PostgreSQL\16\data\Datasets\sql_course\skills_job_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');



COPY company_dim
FROM 'C:\Program Files\PostgreSQL\Code\csv_files\company_dim.csv'
DELIMITER ',' CSV HEADER;

COPY skills_dim
FROM 'C:\Program Files\PostgreSQL\Code\csv_files\skills_dim.csv'
DELIMITER ',' CSV HEADER;

COPY job_postings_fact
FROM 'C:\Program Files\PostgreSQL\Code\csv_files\job_postings_fact.csv'
DELIMITER ',' CSV HEADER;


COPY skills_job_dim
FROM 'C:\Program Files\PostgreSQL\Code\csv_files\skills_job_dim.csv'
DELIMITER ',' CSV HEADER;


SELECT job_posted_date
FROM  job_postings_fact
LIMIT 100;

--Hnadling of Date manipulation
--Date: convert to date format by removing the time portion
--At Time Zone: Convert a timestamp to a specific time zone
--Extract: Get specific date part (e.g, year, month, day)


-- convert datatype using double calling SELECT statement & [::]

SELECT '20/08/2023'

SELECT 
    '10/04/2012':: DATE,
    '123':: INTEGER,
    'TRUE':: BOOLEAN,
    '3.14':: REAL; 

SELECT
    job_title_short AS tittle,
    job_location AS location,
    job_posted_date:: date AS date
FROM
    job_postings_fact
    LIMIT 100;


--AT Time Zone
SELECT
    job_title_short AS tittle,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' 
FROM
    job_postings_fact
LIMIT 5;

--Extract 
--AT Time Zone
SELECT
    job_title_short AS tittle,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(YEAR FROM job_posted_date) AS date_month,
    EXTRACT(MONTH FROM job_posted_date) AS date_year,
    EXTRACT(DAY FROM job_posted_date) AS date_day
FROM
    job_postings_fact
LIMIT 5;

-- a mixture of date manipulation and group by will give you trend analysis
SELECT
    COUNT(job_id) AS job_postes_count,
    EXTRACT(MONTH FROM job_posted_date) AS date_month
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY   
    date_month
ORDER BY
    date_month DESC
LIMIT 200;

--Practical Problem
SELECT
    job_posted_date AS job_date,
    AVG(salary_year_avg) AS sal_year_avg,
    AVG(salary_hour_avg) AS sal_hourly_avg
FROM
    job_postings_fact
WHERE
    (job_posted_date > '01/06/2023')
    AND salary_hour_avg IS NOT NULL 
GROUP BY 
    job_date
LIMIT 200;

-- Write a query t count number of jobs

SELECT
    job_id AS jobs,
    COUNT(job_id) AS count_jobs,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month
FROM
    job_postings_fact
WHERE 
    job_posted_date > '01-01-2023'
GROUP BY
    jobs, date_month
ORDER BY
    date_month
LIMIT 1000;


SELECT * FROM job_postings_fact LIMIT 1000;
SELECT * FROM company_dim LIMIT 1000;

--reference company_id
SELECT
    job_postings.company_id AS company_id,  
    company.name AS company_name
FROM 
    job_postings_fact job_postings
INNER JOIN
    company_dim company
    ON job_postings.company_id = company.company_id
WHERE 
    job_health_insurance IS TRUE
    AND (job_posted_date BETWEEN '01-04-2023' AND '01-08-2023')
ORDER BY
    company_name ASC;

-- Extract months, but no specific month, justll month
SELECT 
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
LIMIT 10;

--Extrat date where job posed date is january, there condition for filter
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1
LIMIT 10;

-- Create Table for job postings for janury
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1
LIMIT 10;

--Created table using the extract function
DROP TABLE IF EXISTS first_month;
-- Create table for January job postings
CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- Create table for February job postings
CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- Create table for March job postings
CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;


SELECT *
FROM march_jobs
LIMIT 20;

--if you want to create column based on certain condition CASE statment is applied
--Example 1, condirion
--jobs in New York, local
--jobs anywhere, remote
--jobs other place onsite

SELECT
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'New York, NY' THEN 'local'
        WHEN job_location = 'Anywhere' THEN 'remote'
        ELSE
            'Onsite'
    END AS location_category
FROM job_postings_fact
LIMIT 10;

/*More Analysis, i want analyse how many jobs i can apply to, by applying
aggregate function, such as GROUP BY to agreggate the values */


SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'New York, NY' THEN 'local'
        WHEN job_location = 'Anywhere' THEN 'remote'
        ELSE
            'Onsite'
    END AS location_category
FROM job_postings_fact
GROUP BY
    location_category
LIMIT 100;


-- I am interested in Data Analyst Job
SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'New York, NY' THEN 'local'
        WHEN job_location = 'Anywhere' THEN 'remote'
        ELSE
            'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY
    location_category
LIMIT 100;



/* I want to categorise the salaries from each job posting to see if it fits in my desired 
salary range; Condition
-put the salary into one butcket
define high, standard, and low salary with our condition
*/

SELECT * FROM job_postings_fact LIMIT 20
SELECT * FROM company_dim LIMIT 20


SELECT
    job_title_short AS jobs,
    COUNT(job_id) AS number_of_jobs,
    AVG(salary_year_avg) AS annual_sal,
    CASE
        WHEN AVG(salary_year_avg) >= 120000 THEN 'high salary'
        WHEN AVG(salary_year_avg) >= 100000 THEN 'standard salary'
        WHEN AVG(salary_year_avg) >= 70000 THEN 'low salary'
        ELSE 'poor salary'
    END AS sal_category
FROM
    job_postings_fact
GROUP BY
    job_title_short
HAVING
    AVG(salary_year_avg) > 70000
ORDER BY 
    annual_sal DESC;

--SUBQURIES AND CTEs
/*This is use to organise and simplyfy quries to
more smaller manageable size */

--Create temp table with subquieris
--create table where job are janury

SELECT *
FROM
    job_postings_fact
WHERE  
    EXTRACT(MONTH FROM job_posted_date) = 1
LIMIT 100;

SELECT *
FROM (SELECT *
FROM
    job_postings_fact
WHERE  
    EXTRACT(MONTH FROM job_posted_date) = 1
LIMIT 100
    ) AS january_job_table;

--CTEs is almost inverse of excusion order of subquery
WITH jan_table AS
    (
    SELECT *
    FROM
        job_postings_fact
    WHERE  
        EXTRACT(MONTH FROM job_posted_date) = 1
    LIMIT 100
    )
SELECT *
FROM jan_table;


-- let analyse jobs with no degree rquirement
SELECT
    company_id,
    job_no_degree_mention
FROM
    job_postings_fact
WHERE 
    job_no_degree_mention IS TRUE;

/*example 3, we can extract a column feom another table instead
of using left join, we can subquery it, especially for 
a specific column*/

SELECT 
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT
        company_id
    FROM
        job_postings_fact
    WHERE 
        job_no_degree_mention IS TRUE
);

/*Example 4, Analysis using CTE, want find the 
companies with highest job openeings, where job_id
and company name is in each different table
*/

SELECT
    company_id,
    COUNT(*)
FROM
    job_postings_fact
GROUP BY company_id
LIMIT 20;

WITH company_job_count AS 
    (
    SELECT
        company_id,
        COUNT(*)
    FROM
        job_postings_fact
    GROUP BY company_id
    LIMIT 20
    )
SELECT *
FROM company_job_count ;

--combine CTE and JOIN, that joining a temp table with perment table

WITH company_job_count AS 
    (
    SELECT
        company_id,
        COUNT(*)
    FROM
        job_postings_fact
    GROUP BY company_id
    LIMIT 20
    )
SELECT name
FROM company_dim
LEFT JOIN company_job_count 
    ON company_dim.company_id = company_job_count.company_id;

--get a total num of job posting per company_id

WITH company_job_count AS 
    (
    SELECT
        company_id,
        COUNT(*) AS job_count
    FROM
        job_postings_fact
    GROUP BY company_id
    )
SELECT 
    company_dim.name,
    company_job_count.job_count 
FROM company_dim
LEFT JOIN company_job_count
    ON company_dim.company_id = 
    company_job_count.company_id
ORDER BY
    job_count DESC;


/* Example 5, identify the top 5 skills that are most frequently mentioned in the job posting.
Use subquery to find the skills ID with highest count in the 'skills_job_dim table and then
join the result with the 'skills_dim' table to get the skills names*/


--subquery
WITH skills_job_count AS
    (
    SELECT 
        skill_id,
        COUNT(*) AS skills_count
    FROM 
        skills_job_dim
    GROUP BY
        skill_id
    )
SELECT *
FROM skills_job_count 
LIMIT 10; 

-- to left join the 'skills_dim' table

WITH skills_job_count AS
    (
    SELECT 
        skill_id,
        COUNT(*) AS skills_count
    FROM 
        skills_job_dim
    GROUP BY
        skill_id
    )
SELECT 
    skills_dim.skills, 
    skills_job_count.skills_count
FROM 
    skills_dim
LEFT JOIN skills_job_count 
    ON skills_dim.skill_id =
    skills_job_count.skill_id 
ORDER BY
    skills_count DESC
;

/*example 6, determine the size category (small, medium, or large) from each company by
identifying the number of job posting they have. Use subquery to calcuate the total job 
posting per company. A company is considered 'small, if it has less than 10 jobs, medium
if the number of job posting is between 10 and 50 and large, if it has more than 50 job
postings. implement a subquery to aggregate job counts per company befor calsifying them 
based on the size*/

-- identify area of interest
-- reference compamy_id

SELECT
    job_id,
    COUNT(*) AS job_count
FROM 
    job_postings_fact
GROUP BY
    job_id

-- use subquery
WITH company_size AS
    (
     SELECT
    job_id,
    COUNT(*) AS job_count
FROM 
    job_postings_fact
GROUP BY
    job_id
LIMIT 1000   
    )
SELECT *
FROM company_size;

-- LEFT JOIN the 'company_dim' table

WITH company_size AS
(
    SELECT
        company_id,
        job_title_short,
        COUNT(job_id) AS job_count 
    FROM
        job_postings_fact
    GROUP BY
        company_id,
        job_title_short
)
SELECT 
    company_dim.name AS company_name, 
    company_size.company_id,
    company_size.job_count,
        CASE
            WHEN job_count < 10 THEN 'small company'
            WHEN job_count BETWEEN 10 AND 50 THEN 'medium company'
            WHEN job_count > 50 THEN 'large company'
            ELSE 'new company'
        END AS size_category
FROM 
    company_dim
LEFT JOIN 
    company_size
    ON company_dim.company_id = company_size.company_id
ORDER BY
    size_category ASC
LIMIT 1000;

/* Example 7 find the count of the number of remote job posting perskills
-- display the top 5 skills by their demand in remote jobs
- Include skills ID, name and count of posting requireing skills
*/

--Area of interest skill, skills_id

SELECT 
    skill_to_job.skill_id, 
    job_postings.job_id
FROM 
    skills_job_dim AS skill_to_job
INNER JOIN job_postings_fact AS job_postings
    ON skill_to_job.job_id =
    job_postings.job_id
LIMIT 5

-- find the count of remote job

SELECT 
    skill_to_job.skill_id, 
    job_postings.job_id,
    job_postings.job_work_from_home
FROM 
    skills_job_dim AS skill_to_job
INNER JOIN job_postings_fact AS job_postings
    ON skill_to_job.job_id =
    job_postings.job_id
WHERE job_postings.job_work_from_home IS TRUE
LIMIT 5

-- Get account of remove job

SELECT 
    skill_id, 
    COUNT(*) AS skill_count
FROM 
    skills_job_dim AS skill_to_job
INNER JOIN job_postings_fact AS job_postings
    ON skill_to_job.job_id =
    job_postings.job_id
WHERE job_postings.job_work_from_home IS TRUE
GROUP BY
    skill_id
LIMIT 5

--build CTE
WITH remote_job_skill AS
(
    SELECT 
        skill_id, 
        COUNT(*) AS skill_count
    FROM 
        skills_job_dim AS skill_to_job
    INNER JOIN job_postings_fact AS job_postings
        ON skill_to_job.job_id =
        job_postings.job_id
    WHERE job_postings.job_work_from_home IS TRUE
    GROUP BY
        skill_id
    LIMIT 100  
)
SELECT *
FROM remote_job_skill;

--include the 3rd table 'skill_dim'

WITH remote_job_skill AS
(
    SELECT 
        skill_id, 
        COUNT(*) AS skill_count
    FROM 
        skills_job_dim AS skill_to_job
    INNER JOIN job_postings_fact AS job_postings
        ON skill_to_job.job_id =
        job_postings.job_id
    WHERE 
        job_postings.job_work_from_home IS TRUE AND 
        job_postings.job_title_short = 'Data Analyst'

    GROUP BY
        skill_id
    LIMIT 100  
)
SELECT 
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skill
INNER JOIN skills_dim AS skills
    ON skills.skill_id =
    remote_job_skill.skill_id
ORDER BY
    skill_count DESC
LIMIT 5  


/* Union is use to combine two or more select result
into a single result set
*/

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    march_jobs;

-- UNION ALL return all the result set
SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    march_jobs;


/* Example 8, get a corresponding skill and skill type for each job posting in Q1, 
include those without any skills too, also look at skills and skill type for each job
in Q1 that has a salary > 70,000 */

-- col of interest, skill_id, skill, job_title_short


  SELECT * FROM skills_dim LIMIT 5;
  SELECT * FROM skills_job_dim LIMIT 50;
  SELECT * FROM job_postings_fact LIMIT 5;

SELECT 
    skills_to_job.skill_id,
    job_postings.job_id,
    job_posted_date
FROM 
    skills_job_dim AS skills_to_job
LEFT JOIN 
    job_postings_fact AS job_postings
    ON skills_to_job.job_id = job_postings.job_id
WHERE 
    EXTRACT(MONTH FROM job_posted_date) BETWEEN 1 AND 3
LIMIT 1000

-- put in CTE with name Q1_job_postings

WITH Q1_job_postings AS (
    SELECT 
        job_postings.job_title_short,
        skills_to_job.skill_id,
        job_postings.job_id,
        job_posted_date
    FROM 
        skills_job_dim AS skills_to_job
    LEFT JOIN 
        job_postings_fact AS job_postings
        ON skills_to_job.job_id = job_postings.job_id
    WHERE 
        EXTRACT(MONTH FROM job_posted_date) BETWEEN 1 AND 3
    LIMIT 1000
)
SELECT 
    Q1_job_postings.job_title_short,
    Q1_job_postings.job_posted_date,   -- Corrected to reference Q1_job_postings
    Q1_job_postings.skill_id,          -- Corrected to reference Q1_job_postings
    skill.type AS skills_type          -- Corrected to reference 'skill' table with alias
FROM 
    Q1_job_postings
LEFT JOIN 
    skills_dim AS skill
    ON Q1_job_postings.skill_id = skill.skill_id;

-- job post for the first Q1 with salary > 70,000

WITH Q1_job_postings AS (
    SELECT 
        job_postings.salary_year_avg,
        job_postings.job_title_short,
        skills_to_job.skill_id,
        job_postings.job_id,
        job_posted_date
    FROM 
        skills_job_dim AS skills_to_job
    LEFT JOIN 
        job_postings_fact AS job_postings
        ON skills_to_job.job_id = job_postings.job_id
    WHERE 
        EXTRACT(MONTH FROM job_posted_date) BETWEEN 1 AND 3 
        AND salary_year_avg > 70000
    LIMIT 1000
)
SELECT 
    Q1_job_postings.job_title_short,
    Q1_job_postings.salary_year_avg,
    Q1_job_postings.job_posted_date,   -- Corrected to reference Q1_job_postings
    Q1_job_postings.skill_id,          -- Corrected to reference Q1_job_postings
    skill.type AS skills_type          -- Corrected to reference 'skill' table with alias
FROM 
    Q1_job_postings
LEFT JOIN 
    skills_dim AS skill
    ON Q1_job_postings.skill_id = skill.skill_id
ORDER BY
    salary_year_avg ASC;

    SELECT * FROM january_jobs LIMIT 5


    --Using UNION to join three similar table

SELECT 
    quartly_job_postings.job_title_short,
    quartly_job_postings.job_location,
    quartly_job_postings.job_via,
    quartly_job_postings.job_posted_date::DATE,
    quartly_job_postings.salary_year_avg
FROM
(
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quartly_job_postings
WHERE
    quartly_job_postings.salary_year_avg > 70000
    AND quartly_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    quartly_job_postings.job_title_short
LIMIT 50;
