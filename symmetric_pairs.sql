/*
A best solution could be create a third cte after cte_function_sum to remove duplicates
but in this case i want to use only two cte.
*/


WITH cte_function_sum AS (
    SELECT
        x,
        y,
        ROW_NUMBER() OVER(PARTITION BY x,y ORDER BY x,y) AS RANK,
        SUM(1) OVER(ORDER BY x,y) AS ENUM
    FROM Functions
), cte_self_ranked_join AS (
SELECT
    a.x as x,
    a.y as y,
    b.x as bx,
    b.y as b_y    
FROM cte_function_sum a
JOIN cte_function_sum b
ON (a.x=b.y AND a.y=b.x AND a.ENUM!=b.ENUM)
WHERE a.x<=a.y AND a.RANK=1
)
SELECT x,y from cte_self_ranked_join 
UNION
SELECT x,y FROM cte_function_sum WHERE RANK=2
ORDER BY  x;