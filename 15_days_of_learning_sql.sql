
with cte_submissions_by_hacker AS
    (SELECT
    s.submission_date,
    Count(s.submission_id) as number_of_submissions,
    s.hacker_id,
    MAX(a.name) as name
    FROM Submissions s
    left join Hackers a
    on s.hacker_id=a.hacker_id
    group by s.submission_date,s.hacker_id),
cte_submissions_by_hacker2 AS (SELECT 
            submission_date,
            hacker_id,
            name,
            ROW_NUMBER() OVER (PARTITION BY submission_date ORDER BY number_of_submissions DESC, hacker_id ASC) AS Counter
FROM cte_submissions_by_hacker),
cte_present_all_days AS (
    SELECT 
        submission_date,
        hacker_id,
        ROW_NUMBER() OVER (PARTITION BY hacker_id ORDER BY submission_date) AS ALL_DAYS
    FROM 
        cte_submissions_by_hacker),
cte_max_submissions AS (
    select 
        submission_date, 
        ALL_DAYS,
        Count(*) as MAX_SUBMISSIONS
    from cte_present_all_days where substr(submission_date,length(submission_date)-1,length(submission_date))=ALL_DAYS
    group by submission_date, 
    ALL_DAYS
    order by submission_date asc, ALL_DAYS desc),
cte_max_hackers AS
    (SELECT 
      submission_date,
      hacker_id,
      name
    FROM cte_submissions_by_hacker2
    where Counter=1)
select 
    a.submission_date,
    a.MAX_SUBMISSIONS,
    b.hacker_id,
    b.name
from cte_max_submissions a
left join cte_max_hackers b
on a.submission_date=b.submission_date;

