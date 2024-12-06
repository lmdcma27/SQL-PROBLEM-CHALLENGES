
with cte_position_counter AS (
    SELECT 
    ct.company_code,
    ct.founder,
    ROW_NUMBER() OVER(PARTITION BY ct.company_code,lmt.lead_manager_code ORDER BY ct.company_code) AS lead_manager_counter,
    ROW_NUMBER() OVER(PARTITION BY ct.company_code,lmt.lead_manager_code, smt.senior_manager_code ORDER BY ct.company_code) AS senior_manager_counter,
    ROW_NUMBER() OVER(PARTITION BY ct.company_code,lmt.lead_manager_code, smt.senior_manager_code,mt.manager_code ORDER BY ct.company_code) AS manager_counter,
    ROW_NUMBER() OVER(PARTITION BY ct.company_code,lmt.lead_manager_code, smt.senior_manager_code,mt.manager_code,et.employee_code ORDER BY ct.company_code) AS employee_counter
FROM 
    Company ct 
    RIGHT JOIN Lead_Manager lmt 
    on ct.company_code=lmt.company_code
    RIGHT JOIN Senior_Manager smt
    on lmt.lead_manager_code=smt.lead_manager_code
    RIGHT JOIN Manager mt
    on smt.senior_manager_code=mt.senior_manager_code
    RIGHT JOIN Employee et
    on mt.manager_code=et.manager_code
ORDER BY ct.company_code asc
),
cte_true_positions AS (select 
    cte_position_counter.company_code,
    cte_position_counter.founder,
    CASE cte_position_counter.lead_manager_counter 
    WHEN 1 THEN 1 ELSE 0 END AS lead_manager_1,
    CASE cte_position_counter.senior_manager_counter 
    WHEN 1 THEN 1 ELSE 0 END AS senior_manager_1,
    CASE cte_position_counter.manager_counter 
    WHEN 1 THEN 1 ELSE 0 END AS manager_1,
    CASE cte_position_counter.employee_counter 
    WHEN 1 THEN 1 ELSE 0 END AS employee_1
from cte_position_counter)
select
    company_code,
    MAX(founder),
    sum(lead_manager_1),
    sum(senior_manager_1),
    sum(manager_1),
    sum(employee_1)
from cte_true_positions
group by cte_true_positions.company_code;
