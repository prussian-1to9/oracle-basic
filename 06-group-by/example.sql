/* ========================= [ group functions 종합 ] ========================= */
-- 사원들의 총 급여 합, 최대 & 최소 급여, 사원 수 조회
SELECT SUM(sal) "총 급여 합", MAX(sal) "최대 급여",
    MIN(sal) "최소 급여", COUNT(*) "사원 수"
FROM emp;

-- NULL 값이 0으로 치환되어, row 개수인 14로 나누어지면 157이 나옴.
SELECT AVG(comm) "평균 계산" FROM emp;

-- 직급 별 평균 급여 조회
SELECT job 직급, ROUND(AVG(sal), -1) "부서 평균 급여"
FROM emp
GROUP BY job
ORDER BY job;

-- 부서 별 평균 급여 조회(단, 평균 급여가 2000 이상인 부서만)
SELECT deptno "부서 번호",
    DECODE(deptno,
        10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS'
    ) "부서 이름", ROUND(AVG(sal), -1) "부서 평균 급여"
FROM emp
GROUP BY deptno
HAVING AVG(sal) >= 2000
ORDER BY deptno;

-- 직급 별 사원 수 조회(단, 사원 수가 1명인 직급은 제외)
SELECT job 직급, COUNT(*) "사원 수"
FROM emp
GROUP BY job
HAVING COUNT(*) > 1;