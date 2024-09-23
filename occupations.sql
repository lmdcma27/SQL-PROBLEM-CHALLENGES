
WITH cte_occupations_ind AS
    (SELECT
        Name,
        Occupation,
        ROW_NUMBER() OVER (Partition by Occupation order by Name asc) as 'ind'
    FROM OCCUPATIONS
    )
select
    MAX(CASE WHEN cte_occupations_ind.Occupation='Doctor' THEN cte_occupations_ind.Name ELSE NULL END) AS 'Doctors',
    MAX(CASE WHEN cte_occupations_ind.Occupation='Professor' THEN cte_occupations_ind.Name ELSE NULL END) AS 'Professor',
    MAX(CASE WHEN cte_occupations_ind.Occupation='Singer' THEN cte_occupations_ind.Name ELSE NULL END) AS 'Singer',
    MAX(CASE WHEN cte_occupations_ind.Occupation='Actor' THEN cte_occupations_ind.Name ELSE NULL END) AS 'Actor'
FROM cte_occupations_ind
GROUP BY cte_occupations_ind.ind
