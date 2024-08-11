/*
Question: What are the most in-demand skills for my role?

*/

WITH data_analyst_jobs AS (SELECT 
        job_id,
        job_title,
        job_title_short

    FROM job_postings_fact
    WHERE 
        job_title_short = 'Data Analyst')
--        job_location = 'Anywhere')

SELECT
--    data_analyst_jobs.job_id,
--    data_analyst_jobs.job_title,
--    data_analyst_jobs.job_title_short,
    skills_dim.skills,
    COUNT(skills_dim.skills) AS skill_count

FROM data_analyst_jobs
INNER JOIN skills_job_dim ON data_analyst_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

GROUP BY skills_dim.skills
ORDER BY skill_count DESC
LIMIT 5





