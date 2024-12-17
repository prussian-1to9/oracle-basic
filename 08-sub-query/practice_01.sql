/* ========================= [ 쿼리 연습 정답 ] ========================= */
/*
    1.  이름이 SMITH인 사원과 동일한 직급을 가진 사원들의
        사번, 사원 이름, 직급, 상사 사번,
        입사일, 급여, 커미션, 부서 번호 조회
        (단, 커미션이 존재하지 않을 경우 0으로 처리)
*/
SELECT empno 사번, ename "사원 이름", job 직급, mgr "상사 사번",
    hiredate 입사일, sal 급여, NVL(comm, 0) 커미션, deptno "부서 번호"
FROM emp
WHERE job IN (
    SELECT job FROM emp
    WHERE ename = 'SMITH'
);

/*
    2.  회사 평균 급여보다 급여가 적은 사원들의
        이름, 직급, 급여[, 회사 평균 급여] 조회
        (회사 평균 급여는 선택 사항이므로 자유롭게 조회)
*/
SELECT ename "사원 이름", job 직급, sal 급여,
    (SELECT ROUND(AVG(sal)) FROM emp) "회사 평균 급여"
FROM emp
WHERE sal < (SELECT AVG(sal) FROM emp);
-- sal 외 필드와 그룹함수 혼용 불가함으로 sub query 사용

/*
    3.  급여가 제일 높은 사원의
        이름, 직급, 급여[, 최고 급여] 조회
        (최고 급여는 선택 사항이므로 자유롭게 조회)
*/
SELECT ename "사원 이름", job 직급, sal 급여, (
        SELECT sal FROM emp
        WHERE sal >= ALL(SELECT sal FROM emp)
    ) "최고 급여"
FROM emp
WHERE sal >= ALL(SELECT sal FROM emp);

/*
    4.  KING 사원 이후 입사한 사원들의
        사원 이름, 직급, 입사일[, KING 사원 입사일] 조회
        (KING 사원 입사일은 선택 사항이므로 자유롭게 조회)
*/
SELECT ename "사원 이름", job 직급, hiredate "입사일", (
        SELECT hiredate FROM emp
        WHERE ename = 'KING'
    ) "KING 사원 입사일"
FROM emp
WHERE hiredate > (
    SELECT hiredate FROM emp
    WHERE ename = 'KING'
);

/*
    5.  사원들의 사원 이름, 급여, 회사 평균 급여, 급여의 차 조회
        
    급여의 차 계산 :
        | 회사 평균 급여 - 각 사원의 급여 |
*/
SELECT ename "사원 이름", sal 급여,
    ROUND(ABS(sal - (SELECT AVG(sal) FROM emp))) "급여의 차",
    ROUND((SELECT AVG(sal) FROM emp)) "회사 평균 급여"
FROM emp
GROUP BY ename, sal;

/*
    6.  부서 별 급여의 합이 가장 높은 부서의
        사원들의 사원 이름, 직급, 부서 번호,
        부서 이름, 부서 급여 합계, 부서원 수 조회
*/
SELECT ename "사원 이름", job 직급, dno "부서 번호",
    d.dname "부서 이름", sal_sum "부서 급여 합계", cnt "부서원 수"
FROM emp e
    JOIN dept d ON d.deptno = e.deptno
    JOIN (
        SELECT
            dept.deptno dno, SUM(sal) sal_sum, COUNT(*) cnt
        FROM emp se, dept sd
        WHERE se.deptno = sd.deptno
        GROUP BY sd.deptno
        HAVING SUM(sal)>= ALL (
            SELECT SUM(sal) FROM emp GROUP BY deptno
        )
    ) s ON s.dno = emp.deptno;

/*
    7.  커미션을 받는 사원이 존재하는 부서의
        사원들의 사원 이름, 직급, 부서 번호, 커미션 조회
*/
SELECT ename "사원 이름", job 직급, deptno "부서 번호", comm 커미션
FROM emp
WHERE deptno IN (
    SELECT deptno FROM emp
    WHERE comm IS NOT NULL
);

/*
    8.  회사 평균 급여보다 높은 급여이고, 이름이 4-5글자인 사원들의
        사원 이름, 급여, 이름글자수[, 회사 평균 급여] 조회
        (회사 평균 급여는 선택 사항이므로 자유롭게 조회)
*/
SELECT ename "사원 이름", sal 급여, LENGTH(ename) "이름 글자 수",
    (SELECT ROUND(AVG(sal)) FROM emp) "회사 평균 급여"
FROM emp
WHERE sal > (SELECT AVG(sal) FROM emp)
    AND (LENGTH(ename) = 4 OR LENGTH(ename) = 5); -- like, in 구문으로 대체 가능

/*
    9.  사원 이름의 글자수가 4글자인 사원과 동일 직급을 가진 사원들의
        사원 이름, 직급, 급여 조회
*/
SELECT ename "사원 이름", job 직급, sal 급여
FROM emp
WHERE job IN (
    SELECT job FROM emp
    WHERE LENGTH(ename) = 4
);

/*
    10. 입사년도가 81년이 아닌 사원과 같은 부서에 있는 사원들의
        사원 이름, 직급, 급여, 입사일, 부서번호 조회
*/
SELECT ename "사원 이름", job 직급, sal 급여, hiredate 입사일, deptno "부서 번호"
FROM emp
WHERE deptno IN (
    SELECT deptno FROM emp
    WHERE TO_CHAR(hiredate, 'YY') != '81'
);

/*
    11. 직급 별 평균 급여 중, 하나이상 급여가 높은 사원들의
        사원 이름, 직급, 급여, 입사일 조회
*/
SELECT ename "사원 이름", job 직급, sal 급여, hiredate 입사일
FROM emp
WHERE sal > ANY (SELECT AVG(sal) FROM emp GROUP BY job); -- MIN(), > 로 대체 가능

/*
    12. 입사 연도 별 평균 급여 중, 하나 이상 급여가 높은 사원들의
        사원 이름, 직급, 급여, 입사 년도 조회
*/
SELECT ename "사원 이름", job 직급, sal 급여, hiredate "입사 년도"
FROM emp
WHERE sal > ANY (
    SELECT AVG(sal) FROM emp
    GROUP BY TO_CHAR(hiredate, 'YY')
); -- MIN(), > 로 대체 가능

/*
    13. 급여가 가장 높은 사원과
        -   이름 글자수가 같은 직원이 존재하면
            모든 사원의 사원 이름, 이름 글자수, 직급, 급여 를 조회

        -   존재하지 않으면
            어떠한 정보도 조회하지 않음
*/
SELECT ename "사원 이름", LENGTH(ename) "이름 글자수", job 직급, sal 급여
FROM emp
WHERE EXISTS (
    SELECT ename FROM emp
    WHERE LENGTH(ename) IN (
        SELECT LENGTH(ename) FROM emp
        WHERE ename IN (
            SELECT ename FROM emp
            WHERE sal >= ALL (SELECT sal FROM emp)
        )
    )
);