/*Question 3: What are the most in-demand skills for data analyst?
- Join job postings to inner join table similar to query 2
- Indentify the top 5 in-demand skills for data analyst jobs.
- Focus on all job posing
-Why? Retrieves the top skills with the highest demand in the job
market, providing insight into the most valuable skills for job seekers.
*/


SELECT
    skills,
    COUNT(job_postings_fact.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;


/*
Here’s a more concise analysis of the top 5 in-demand skills for data analyst roles in 2023:

SQL (92,628) is the most in-demand skill, essential for database management.
Excel (67,031) remains crucial for data manipulation.
Python (57,326) is important for analysis and automation.
Tableau (46,554) highlights the need for data visualisation.
Power BI (39,468) reflects demand for business intelligence skills.
This indicates a strong emphasis on technical and visualisation skills in data analytics.


[
  {
    "skills": "sql",
    "demand_count": "92628"
  },
  {
    "skills": "excel",
    "demand_count": "67031"
  },
  {
    "skills": "python",
    "demand_count": "57326"
  },
  {
    "skills": "tableau",
    "demand_count": "46554"
  },
  {
    "skills": "power bi",
    "demand_count": "39468"
  }
]
*/