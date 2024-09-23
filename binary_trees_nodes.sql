
WITH cte_root AS (
    SELECT N AS Output, 
           'Root' AS Description
    FROM BST
    WHERE P IS NULL
),
cte_inner AS (
    SELECT P AS Output,
        'Inner' as Description
    FROM BST
    WHERE P IS NOT NULL AND P NOT IN (select N from BST WHERE P is NULL)
),
cte_leaf AS (
    SELECT 
        N AS Output,
        'Leaf' as Description
    FROM BST
    WHERE N NOT IN (SELECT P FROM BST WHERE P IS NOT NULL)
)
select * FROM 
    (
        SELECT * FROM cte_root
        UNION
        SELECT * FROM cte_inner
        UNION
        SELECT * FROM cte_leaf
    );

