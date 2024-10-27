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
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;