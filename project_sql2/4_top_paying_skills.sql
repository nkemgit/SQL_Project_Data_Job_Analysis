/*Question 4: What are the top skills based on salary
- Look at the average salary associated with each skill for data analyst positions
- Focuses on roles with specified salaries , regardless of location
- Why? it reveals how different skills impact salary levels for data analyst and help 
identify the most financially rewarding skills to acquire or improve
*/


SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND 
    salary_year_avg IS NOT NULL AND
    job_work_from_home IS TRUE
GROUP BY
    skills
ORDER BY
    average_salary DESC
LIMIT 25;


/* The top-paying data analyst skills reflect trends towards cloud technologies like PySpark and GCP, 
AI integration with tools like Watson, and strong programming capabilities using Python. Collaboration 
tools such as Bitbucket and CI/CD practices are essential, alongside data visualisation skills,
 indicating a rapidly evolving and competitive job market.

[
  {
    "skills": "pyspark",
    "average_salary": "208172.25"
  },
  {
    "skills": "bitbucket",
    "average_salary": "189154.50"
  },
  {
    "skills": "couchbase",
    "average_salary": "160515.00"
  },
  {
    "skills": "watson",
    "average_salary": "160515.00"
  },
  {
    "skills": "datarobot",
    "average_salary": "155485.50"
  },
  {
    "skills": "gitlab",
    "average_salary": "154500.00"
  },
  {
    "skills": "swift",
    "average_salary": "153750.00"
  },
  {
    "skills": "jupyter",
    "average_salary": "152776.50"
  },
  {
    "skills": "pandas",
    "average_salary": "151821.33"
  },
  {
    "skills": "elasticsearch",
    "average_salary": "145000.00"
  },
  {
    "skills": "golang",
    "average_salary": "145000.00"
  },
  {
    "skills": "numpy",
    "average_salary": "143512.50"
  },
  {
    "skills": "databricks",
    "average_salary": "141906.60"
  },
  {
    "skills": "linux",
    "average_salary": "136507.50"
  },
  {
    "skills": "kubernetes",
    "average_salary": "132500.00"
  },
  {
    "skills": "atlassian",
    "average_salary": "131161.80"
  },
  {
    "skills": "twilio",
    "average_salary": "127000.00"
  },
  {
    "skills": "airflow",
    "average_salary": "126103.00"
  },
  {
    "skills": "scikit-learn",
    "average_salary": "125781.25"
  },
  {
    "skills": "jenkins",
    "average_salary": "125436.33"
  },
  {
    "skills": "notion",
    "average_salary": "125000.00"
  },
  {
    "skills": "scala",
    "average_salary": "124903.00"
  },
  {
    "skills": "postgresql",
    "average_salary": "123878.75"
  },
  {
    "skills": "gcp",
    "average_salary": "122500.00"
  },
  {
    "skills": "microstrategy",
    "average_salary": "121619.25"
  }
]
*/