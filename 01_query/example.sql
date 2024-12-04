/* ========================= [ 기본 select ] ========================= */
-- 부서 정보 테이블(dept)에서 정보 조회
SELECT deptno, dnmae, loc
FROM dept;

-- 1+4의 결과 조회
SELECT 1 + 4;
SELECT 1 + 4 from dual; -- dual은 오라클에서 제공하는 가상 테이블, 타 DB에서는 사용 불가
SELECT 1 + 4 from emp; -- 테이블의 row만큼 결과값인 5가 출력

-- 사원 정보 테이블(emp)에서 임의의 이름 출력
SELECT '최이지' FROM emp; -- 마찬가지로 테이블의 row만큼 결과값인 '최이지'가 출력

/* ========================= [ 단순 연산자 ] ========================= */
SELECT ename 이름, sal 원급여, sal + 10000 "보너스 적용 급여",
    sal * 1.5 "인상 급여", sal * 12 연봉
FROM emp;

/* ========================= [ 결합 연산자 || ] ========================= */
SELECT 10 || 20 FROM dual; -- 1020

-- 사원들 이름에 Mr. 를 붙여 조회
SELECT
    'Mr.' || ename "사원 이름", sal || '$' 급여, hiredate 입사일
FROM emp;

/* ========================= [ 단순 조건 연산자 ] ========================= */
/*
    사원 중 직급이 MANAGER이고, 부서번호가 10번인 사원의 이름 조회
*/
SELECT ename
FROM emp
WHERE
    job = 'MANAGER'
    AND deptno = 10;  -- 가장 많이 필터링 되는 조건을 우선으로 하는게 좋다.

/*
    이름이 SMITH인 사원의
    이름, 직급, 입사일 조회
*/
SELECT ename, job, hiredate
FROM emp
WHERE ename = 'SMITH';

/*
    직급이 MANAGER인 사원의
    이름, 직급, 급여 조회
*/
SELECT ename, job, sal
FROM emp
WHERE job = 'MANAGER';

/*
    급여가 1500을 넘는 사원들의
    이름, 직급, 급여 조회
*/
SELECT ename, job, sal
FROM emp
WHERE sal > 1500;

/*
    'S' 이후의 문자로 이름이 시작하는 사원들의
    이름, 직급, 급여 조회
*/
SELECT ename, job, sal
FROM emp
WHERE ename > 'S';

/*
    입사일이 81년 8월 이전인 사원들의
    이름, 입사일, 급여 조회
*/
SELECT ename, hiredate, sal
FROM emp
WHERE hiredate < '81/08/01';

/*
    급여가 1000~3000인 사원들의
    이름, 직급, 급여 조회
*/
SELECT ename, job, sal
FROM emp
WHERE sal <= 3000 AND sal >= 1000;

/*
    직급이 MANAGER 이면서 급여가 1000이상인 사원들의
    이름, 직급, 입사일, 급여 조회
*/
SELECT ename, job, hiredate, sal
FROM emp
WHERE job = 'MANAGER'
    AND sal >= 1000;

/*
    부서번호가 10번이 **아닌** 사원들의
    이름, 직급, 부서 번호 조회
*/
SELECT ename, job, deptno
FROM emp
WHERE -- 아래의 조건 모두 다 같은 조건임
    NOT deptno = 10;
    OR deptno != 10;
    OR deptno <> 10;

/* ========================= [ 조건 연산자 : IN , BETWEEN, LIKE... ] ========================= */
/*
    부서 번호가 10번 또는 30번인 사원의
    이름, 직급, 부서번호 조회
*/
SELECT ename, job, deptno
FROM emp
WHERE
--  deptno=10 OR deptno=30; -- 또는
    deptno IN(10, 30); -- IN으로 묶기

-- 이름이 5글자인 사원들의 이름, 직급 조회
SELECT ename, job
FROM emp
WHERE ename LIKE '_____';

-- 입사일이 1월인 사원들의 이름, 입사일 조회
SELECT ename, hiredate
FROM emp
WHERE hiredate LIKE '__/01/__';
    --TO_CHAR(hiredate, 'YY/MM/DD') LIKE '__/01/__';  -- 가 사실 정확하다.

/* ========================= [ 이후 토픽 맛보기 ] ========================= */
SELECT e.ename "사원 이름", e.sal 급여, e.mgr "상사 번호",
    s.ename "상사 이름", s.sal "상사 급여"
FROM emp e, emp s
WHERE e.mgr = s.empno(+);

SELECT ename "사원 이름", sal 급여, grade "급여 등급"
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal;