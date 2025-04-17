-- Ex1:
WITH job_count AS
(SELECT company_id, title, description,
COUNT (job_id) AS job_count
FROM job_listings
GROUP BY company_id, title, description)
SELECT COUNT (DISTINCT company_id) AS duplicate_companies
FROM job_count
WHERE job_count>1

-- Ex3:
WITH call_count AS
(SELECT policy_holder_id,
COUNT(case_id) AS call_count
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id)>=3)
SELECT
COUNT(policy_holder_id) AS policy_holder_count
FROM call_count
