select 
    T1.order_name
FROM 
    (select 
        CONCAT(Name,'(',substring(Occupation,1,1),')') as 'order_name'
    FROM Occupations
    GROUP BY NAME,Occupation
    ORDER BY NAME asc)
T1
UNION ALL
select 
concat('There are a total of ',T2.count,' ',T2.occupation)
FROM
    (select
    concat(lower(Occupation),'s.') as 'occupation',count(Occupation) as 'count'
    FROM OCCUPATIONS
    GROUP BY Occupation
    order by count(Occupation) asc, Occupation asc) 
T2
