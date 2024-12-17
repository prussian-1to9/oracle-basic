/* ========================= [ 쿼리 연습 정답 : WHERE 절 ver. ] ========================= */
/*
    1.  직급이 MANAGER인 사원들의
        사원 이름, 직급, 입사일, 급여, 부서 번호, 부서 이름 조회
*/
SELECT ename "사원 이름", job 직급, hiredate 입사일,
    sal 급여, d.deptno "부서 번호", dname "부서 이름"
FROM emp e, dept d
WHERE d.deptno = e.deptno -- join 조건을 먼저 기재해 주는 것이 좋다.
    AND e.job = 'MANAGER';

/*
    2.  사원 이름이 5글자인 사원들의
        사원 이름, 입사일, 급여, 급여 등급 조회
*/
SELECT ename "사원 이름", hiredate 입사일, sal 급여, grade "급여 등급"
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal -- non-eq join : emp-salgrade
    AND LENGTH(ename) = 5;

/*
    3.  입사일이 81년이고, 직급이 MANAGER인 사원들의
        사원 이름, 직급, 입사일, 급여,
        급여 등급, 부서이름, 부서 위치 조회
*/
SELECT ename "사원 이름", job 직급, hiredate 입사일, sal 급여,
    grade "급여 등급", dname "부서 이름", loc "부서 위치"
FROM emp, dept, salgrade
WHERE emp.deptno = dept.deptno -- eq join : emp-dept
    AND emp.sal BETWEEN losal AND hisal -- non-eq join : emp-salgrade
    AND job = 'MANAGER' -- 연산이 적고, 범위가 좁아지는 조건 먼저 기재하는 것을 권장
    AND TO_CHAR(hiredate, 'YY') = 81;

--  4. 사원들의 사원 이름, 직급, 급여, 급여등급, 상사 이름 조회
SELECT e.ename "사원 이름", e.job 직급, e.sal 급여,
    grade "급여 등급", s.ename "상사 이름"
FROM emp e, emp s, salgrade
WHERE e.mgr = s.empno(+) -- left outer join, eq join : emp-emp(계층)
    and e.sal BETWEEN losal AND hisal; -- non-eq join : emp-salgrade

--  5. 사원들의 사원 이름, 직급, 급여, 상사 이름, 부서 이름, 급여 등급 조회
SELECT
    e.ename "사원 이름", e.job 직급, e.sal 급여,
    s.ename "상사 이름", dname "부서 이름", grade "급여 등급"
FROM
    emp e, emp s, dept d, salgrade
WHERE e.deptno = d.deptno -- eq join : emp-dept
    AND e.mgr = s.empno(+) -- left outer join, eq join : emp-emp(계층)
    AND e.sal BETWEEN losal AND hisal; -- non-eq join : emp-salgrade

/* ========================= [ 쿼리 연습 정답 : JOIN 구문 ver. ] ========================= */
/*
    1.  직급이 MANAGER인 사원들의
        사원 이름, 직급, 입사일, 급여, 부서 이름 조회
*/
SELECT ename "사원 이름", job 직급, hiredate 입사일,
    sal 급여, deptno "부서 번호", dname "부서 이름"
FROM emp NATURAL JOIN dept -- 자동 eq join : emp-dept
WHERE job = 'MANAGER';

/*
    2.  사원 이름이 5글자인 사원들의
        사원 이름, 입사일, 급여, 급여 등급 조회
*/
SELECT ename "사원 이름", hiredate 입사일, sal 급여, grade "급여 등급"
FROM emp
    JOIN salgrade ON sal BETWEEN losal AND hisal -- non-eq join : emp-salgrade
WHERE LENGTH(ename) = 5;

/*
    3.  입사일이 81년이고, 직급이 MANAGER인 사원들의
        사원 이름, 직급, 입사일, 급여,
        급여 등급, 부서이름, 부서 위치 조회
*/
SELECT ename "사원 이름", job 직급, hiredate 입사일, sal 급여,
    grade "급여 등급", dname "부서 이름", loc "부서 위치"
FROM emp NATURAL JOIN dept -- 자동 eq join : emp-dept
    -- 서로 다른 형태의 join 혼용가능
    JOIN salgrade ON sal BETWEEN losal AND hisal -- non-eq join : emp-salgrade
WHERE job = 'MANAGER'
    AND TO_CHAR(hiredate, 'YY') = '81';

--  4. 사원들의 사원 이름, 직급, 급여, 급여등급, 상사 이름 조회
SELECT a.ename "사원 이름", a.job 직급, a.sal 급여,
    grade "급여 등급", b.ename "상사 이름"
FROM emp a
    LEFT OUTER JOIN emp b ON b.empno = a.mgr -- left outer join, eq join : emp-emp(계층)
    JOIN salgrade ON a.sal BETWEEN losal AND hisal; -- non-eq join : emp-salgrade

--  5. 사원들의 사원 이름, 직급, 급여, 상사 이름, 부서 이름, 급여 등급 조회
SELECT e.ename "사원 이름", e.job 직급, e.sal 급여,
    s.ename "상사 이름", dname "부서 이름", grade "급여 등급"
FROM emp e NATURAL JOIN dept -- 자동 eq join
    LEFT OUTER JOIN emp s ON e.mgr = s.empno -- left outer join, eq join : emp-emp(계층)
    JOIN salgrade ON e.sal BETWEEN losal AND hisal; -- non-eq join : emp-salgrade