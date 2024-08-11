/*
Question: What are the skills required for these  top-paying roles?

*/



WITH 
    skill_jobs AS(
    SELECT
    job_id,
    skills_job_dim.skill_id,
    skills,
    type

    FROM skills_job_dim
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    ),

    top_payed_jobs AS(
    SELECT 
        job_id,
        job_title,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date,
        name AS company_name

    FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10)

SELECT
    top_payed_jobs.job_id,
    top_payed_jobs.job_title,
    skill_jobs.skills,
    top_payed_jobs.salary_year_avg

FROM skill_jobs
INNER JOIN top_payed_jobs ON skill_jobs.job_id = top_payed_jobs.job_id;




