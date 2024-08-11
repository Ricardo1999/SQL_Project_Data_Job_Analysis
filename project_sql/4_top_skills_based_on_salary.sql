/*
Question: What are the top skills based on salary for my role?

*/


SELECT
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg),2) AS avg_salary_year_by_skill

FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE
    job_postings_fact.salary_year_avg IS NOT NULL
    AND job_title_short = 'Data Scientist'

GROUP BY skills_dim.skills
ORDER BY avg_salary_year_by_skill DESC
LIMIT 10

