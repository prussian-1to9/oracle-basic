/* ========================= [ 단순 연산자 ] ========================= */
SELECT ename 이름, sal 원급여, sal + 10000 "보너스 적용 급여",
    sal * 1.5 "인상 급여", sal * 12 연봉
FROM emp;

-- 사원들의 이름, 급여, 10% 인상된 급여 조회
SELECT ename as "사원 이름", sal AS 원급여, sal*1.1 "인상 급여"
FROM emp;


/* ========================= [ 결합 연산자 || ] ========================= */
SELECT 10 || 20 FROM dual; -- 1020

-- 사원들 이름에 Mr. 를 붙여 조회
SELECT 'Mr.' || ename "사원 이름", sal || '$' 급여, hiredate 입사일
FROM emp;

/*
    사원들의 사번과 사원 이름 조회
    (단, 한 column에 사원번호 - 사원이름 형식으로 조회)
*/
SELECT empno || ' - ' || ename 사원
FROM emp;

/*
    사원들의 사원번호, 사원 이름 조회
    (단, 사원번호는 '{empno}번', 사원이름은 '{ename}님'의 형식으로 조회)
*/
SELECT empno || '번' 사번, ename || '님' "사원 이름"
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