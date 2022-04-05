/*  employees 테이블의 사원들 중, 전화번호가 011로 시작하는 사원들만 조회해서
    다섯명 씩 한 페이지에 보여주고 싶다.
    이때, 3페이지에 표시될 사원을 이름순으로 조회하시오. */
SELECT
    *
FROM
    (
    SELECT
        ROWNUM rno, e.*
    FROM
        (
        SELECT
            employee_id, first_name, last_name, email, phone_number,
            hire_date, job_id, salary, commission_pct, manager_id, department_id
        FROM
            employees
        WHERE
            phone_number LIKE '011%'
        ) e
    )
WHERE
    rno between 11 and 15
;