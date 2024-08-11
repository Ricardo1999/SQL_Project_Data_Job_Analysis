
/*
Question: What are the most optimal skills to learn?

*/

WITH 
    most_indemand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_dim.skills) AS skill_count

    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Scientist' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = True

    GROUP BY skills_dim.skill_id),
    
    top_skills_salary AS (
    SELECT
        skills_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg),2) AS avg_salary_year_by_skill

    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

    WHERE
        job_title_short = 'Data Scientist' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = True

    GROUP BY skills_dim.skill_id)


SELECT 
    most_indemand.skill_id,
    most_indemand.skills,
    most_indemand.skill_count,
    top_skills_salary.avg_salary_year_by_skill

FROM most_indemand
INNER JOIN top_skills_salary ON most_indemand.skill_id = top_skills_salary.skill_id
WHERE 
    skill_count > 10
ORDER BY
    avg_salary_year_by_skill DESC,
    skill_count DESC
LIMIT 10

