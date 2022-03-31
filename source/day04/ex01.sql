/*
문제 1.
    직급이 MANAGER인 사원의
        사원 이름, 직급, 입사일, 급여, 부서 이름을 조회하시오.   */
SELECT
    ename "사원 이름", job 직급, hiredate 입사일, sal 급여,
    dname "부서 이름"
FROM
    emp, dept
WHERE
    job='MANAGER'
    AND dept.deptno=emp.deptno;
/*
문제 2.
    사원 이름이 5글자인 사원들의
        사원 이름, 입사일, 급여, 급여 등급을 조회하시오.
*/
SELECT
    ename "사원 이름", hiredate 입사일, sal 급여, grade "급여 등급"
FROM
    emp, salgrade
WHERE
    LENGTH(ename)=5
    AND sal BETWEEN losal AND hisal;
/*
문제 3.
    입사일이 81년이고, 직급이 MANAGER인 사원들의
        사원 이름, 직급, 입사일, 급여, 급여 등급, 부서이름, 부서 위치를 조회하시오.
*/
SELECT
    ename "사원 이름", job 직급, hiredate 입사일, sal 급여,
    grade "급여 등급", dname "부서 이름", loc "부서 위치"
FROM
    emp, dept, salgrade
WHERE
    TO_CHAR(hiredate, 'YY')=81
    AND job='MANAGER'
    AND emp.sal BETWEEN losal AND hisal
    AND emp.deptno=dept.deptno;
/*
문제 4.
    사원들의
    사원 이름, 직급, 급여, 급여등급, 상사이름 을 조회하시오.
*/
SELECT
    e.ename "사원 이름", e.job 직급, e.sal 급여, grade "급여 등급",
    s.ename "상사 이름"
FROM
    emp e, emp s, salgrade
WHERE
    e.sal BETWEEN losal AND hisal
    AND e.mgr=s.empno(+);
/*
문제 5.
    사원들의
        사원 이름, 직급, 급여, 상사이름, 부서이름, 급여 등급을 조회하시오.
*/
SELECT
    e.ename "사원 이름", e.job 직급, e.sal 급여,
    s.ename "상사 이름", dname "부서 이름", grade "급여 등급"
FROM
    emp e, emp s, dept, salgrade
WHERE
    e.mgr=s.empno
    AND e.deptno=dept.deptno
    AND e.sal BETWEEN losal AND hisal;

-- JOIN으로 풀어보기 --

-- 1. MANAGER 사원들의 이름, 직급, 입사일, 급여, 부서 번호, 부서 이름 조회하기
-- JOIN 할게 딱히 없으니 그냥 다시 풀기만 하는거로~
SELECT
    ename "사원 이름", job 직급, hiredate 입사일, sal 급여,
    deptno "부서 번호", dname "부서 이름"
FROM
    emp NATURAL JOIN dept
WHERE
    job='MANAGER'
;


-- 2. 이름이 5글자인 사원들의 이름, 입사일, 급여, 급여 등급을 조회하시오.
SELECT
    ename "사원 이름", hiredate 입사일, sal 급여, grade "급여 등급"
FROM
    emp
JOIN salgrade ON sal BETWEEN losal AND hisal
WHERE
    LENGTH(ename)=5
;

-- 3. 81년 입사, MANAGER 직급인 사원들의
--      이름, 직급, 입사일, 급여, 급여등급, 부서이름, 부서 위치를 조회하시오.
SELECT
    ename "사원 이름", job 직급, hiredate 입사일, sal 급여, grade "급여 등급",
    dname "부서 이름", loc "부서 위치"
FROM
    emp NATURAL JOIN dept
    JOIN salgrade ON sal BETWEEN losal AND hisal -- 서로 다른 형태의 join 혼용가능
WHERE
    TO_CHAR(hiredate, 'YY')='81'
    AND job='MANAGER'
;

-- 4. 사원들의 이름, 직급, 급여, 급여등급, 상사 이름을 조회하시오.
SELECT
    a.ename "사원 이름", a.job 직급, a.sal 급여, grade "급여 등급",
    b.ename "상사 이름"
FROM
    emp a
    JOIN salgrade ON a.sal BETWEEN losal AND hisal
    JOIN emp b ON b.empno=a.mgr
;

-- 5. 사원들의 이름, 직급, 급여, 상사이름, 부서 이름, 급여 등급을 조회하시오.
SELECT
    e.ename "사원 이름", e.job 직급, e.sal 급여,
    s.ename "상사 이름", dname "부서 이름", grade "급여 등급"
FROM
    emp e NATURAL JOIN dept
    JOIN salgrade ON e.sal BETWEEN losal AND hisal
    JOIN emp s ON e.mgr=s.empno
;