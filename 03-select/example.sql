/* ========================= [ IS, IS NOT ] ========================= */
/*
    커미션이 있는 사원들의 사원 번호, 사원 이름, 급여, 커미션 조회
    (단, 커미션은 100을 더하여 조회)
*/
SELECT empno 사번, ename "사원 이름", sal 급여, (comm + 100) 커미션
FROM emp
WHERE
    comm IS NOT NULL;
--  NOT comm IS NULL -- 동일 효과

/* ========================= [ ORDER BY ] ========================= */
/*
    사원들의 이름, 직급, 입사일 조회
    (단, 이름 내림차순 정렬)
*/
SELECT ename "사원 이름", job 직급, hiredate 입사일
FROM emp
ORDER BY ename DESC;

-- 위 문제를 입사일 기준 오름차순 정렬해 재조회
SELECT ename "사원 이름", job 직급, hiredate 입사일
FROM emp
ORDER BY hiredate ASC; -- ASC 생략 가능

/*
    사원들의 사원 이름, 급여, 부서번호 조회
    (단, 부서번호 기준 오름차순 정렬. 같은 부서의 경우 급여 내림차순 정렬)
*/
SELECT ename "사원 이름", sal 급여, deptno "부서 번호"
FROM emp
ORDER BY deptno, sal DESC;
