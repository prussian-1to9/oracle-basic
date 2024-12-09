/* ========================= [ 쿼리 연습 정답 ] ========================= */
/*
    1.  부서번호가 10번인 사원들의
        이름, 직급, 입사일, 부서번호 조회
*/
SELECT ename "사원 이름", job 직급, hiredate, deptno "부서 번호"
FROM emp
WHERE deptno = 10;

/*
    2.  직급이 salesman인 사원들의
        이름, 직급, 급여 를 조회 (단, 필드 이름은 제시한 이름)
*/
SELECT ename "사원 이름", job 직급, sal 급여
FROM emp
WHERE job = 'SALESMAN';

/*
    3.  급여가 1000보다 적은 사원들의
        이름, 직급, 급여 조회 (단, 필드 이름은 제시된 이름)
*/
SELECT ename "사원 이름", job 직급, sal 급여
FROM emp
WHERE sal < 1000;

/*
    4.  사원 이름이 'M'이전의 문자로 시작하는 사원들의
        이름, 직급, 급여 조회 (단, 필드 이름은 제시된 이름)
*/
SELECT ename "사원 이름", job 직급, sal 급여
FROM emp
WHERE ename <= 'M';

/*
    5.  입사일이 81년 9월 8일 입사한 사원의
        이름, 직급, 입사일 조회 (단, 필드 이름은 제시된 이름)
*/
SELECT ename "사원 이름", job 직급, hiredate 입사일
FROM emp
WHERE hiredate = '81/09/08';

/*
    6.  사원 이름이 'M'이후 문자로 시작하는 사원 중
        급여가 1000 이상인 사원의
        이름, 급여, 직급 조회 (단, 필드 이름은 제시된 이름)
*/
SELECT ename "사원 이름", sal 급여, job 직급
FROM emp
WHERE ename >= 'M';

/*
    7.  직급이 manager이며 급여가 1000보다 크고
        부서번호가 10번인 사원의
        이름, 직급, 급여, 부서번호 조회 (단, 필드 이름은 제시된 이름)
*/
SELECT ename "사원 이름", job 직급, sal 급여, deptno "부서 번호"
FROM emp
WHERE job = 'MANAGER'
    AND sal > 1000;

/*
    8.  직급이 manager인 사원을 제외한 사원들의
        이름, 직급, 입사일 조회 (단, NOT 연산자 사용, 필드 이름은 제시된 이름)
*/
SELECT ename "사원 이름", job 직급, hiredate 입사일
FROM emp
WHERE NOT job = 'MANAGER';

/*
    9.  사원이름이 'C'로 시작하는 것보다 크고
        'M'으로 시작하는것 보다 작은 사원만
        이름, 직급, 급여 조회 (단, BETWEEN 연산자 사용, 필드 이름은 제시된 이름)
*/
SELECT ename "사원 이름", job 직급, sal 급여
FROM emp
WHERE ename BETWEEN 'C' AND 'M';

/*
    10. 급여가 800, 950이 아닌 사원들의
        이름, 직급, 급여 조회 (단, IN 연산자를 사용하며, 필드 이름은 제시된 이름)
*/
SELECT ename "사원 이름", job 직급, sal 급여
FROM emp
WHERE sal NOT IN (800, 950);

/*
    11. 사원 이름이 'S'로 시작하고, 5글자인 사원들의
        이름, 직급, 급여 조회 (단, 필드 이름은 제시된 이름)
*/
SELECT ename "사원 이름", job 직급, sal 급여
FROM emp
WHERE ename LIKE 'S____';

/*
    12. 입사일이 3일인 사원들의
        이름, 직급, 입사일 조회 (단, 필드 이름은 제시된 이름)
*/
SELECT ename "사원 이름", job 직급, hiredate 입사일
FROM emp
WHERE hiredate LIKE '%03';

/*
    13. 사원 이름의 글자수가 4글자이거나 5글자인 사원들의
        이름, 직급 조회 (단, 필드 이름은 제시된 이름)
*/
SELECT ename "사원 이름", job 직급
FROM emp
WHERE
    ename LIKE '____'
    OR ename LIKE'_____';

/*
    14. 입사년도가 81년도이거나 82년도인 사원들의
        이름, 급여, 입사일 조회  (단, 필드 이름은 제시된 이름)
*/
SELECT ename "사원 이름", sal 급여, hiredate 입사일
FROM emp
WHERE
    hiredate LIKE '81%'
    OR hiredate LIKE '82%';

/*
    15. 사원 이름이 'S'로 끝나는 사원의
    이름, 급여, 커미션 조회  (단, 필드 이름은 제시된 이름)
*/
SELECT ename "사원 이름", sal 급여, COMM 커미션
FROM emp
WHERE ename LIKE '%S';
