-- JOIN 및 sub query 관련 문제들 --
/*
문제 1.
    이름이 SMITH인 사원과 동일한 직급을 가진 사원들의 정보를 출력하시오.
*/
SELECT
    empno 사번, ename "사원 이름", job 직급, mgr "상사 사번",
    hiredate 입사일, sal 급여, NVL(comm, 0) 커미션, deptno "부서 번호"
FROM
    emp
WHERE
    job IN (
        SELECT
            job
        FROM
            emp
        WHERE
            ename='SMITH'
    )
;
/*
문제 2.
    회사 평균 급여보다 급여를 적게 받는 사원들의
        이름, 직급, 급여[, 회사 평균 급여] 를 조회하시오.
*/
SELECT
    ename "사원 이름", job 직급, sal 급여, (
        SELECT
            ROUND(AVG(sal))
        FROM
            emp
    ) "회사 평균 급여"
FROM
    emp
WHERE
    sal < (
        SELECT
            AVG(sal)
        FROM
            emp
    )
;
/*
문제 3.
    사원들 중 급여가 제일 높은 사원의
        이름, 직급, 급여[, 최고 급여] 를 조회하시오.
*/
SELECT
    ename "사원 이름", job 직급, sal 급여, (
        SELECT
            sal
        FROM
            emp
        WHERE
            sal >= ALL(
          SELECT
                sal
          FROM
             emp
        )
    ) "최고 급여"
FROM
    emp
WHERE
    sal >= ALL(
        SELECT
            sal
        FROM
            emp
    )
;
/*
문제 4.
    KING 사원보다 이후에 입사한 사원들의
        사원 이름, 직급, 입사일[, KING사원 입사일] 을 조회하시오.
*/
SELECT
    ename "사원 이름", job 직급, hiredate "입사일", (
        SELECT
            hiredate
        FROM
            emp
        WHERE
            ename='KING'
    ) "KING 사원 입사일"
FROM
    emp
WHERE
    hiredate > (
        SELECT
            hiredate
        FROM
            emp
        WHERE
            ename='KING'
    )
;
/*
문제 5.
    각 사원의 급여와 회사 평균 급여의 차를 출력하시오.
    
    조회 형식 : 사원 이름, 급여, 급여의 차, 회사 평균 급여
*/
SELECT
    ename "사원 이름", sal 급여, ROUND(ABS(sal-(
        SELECT
            AVG(sal)
        FROM
            emp
    ))) "급여의 차", ROUND((
        SELECT
            AVG(sal)
        FROM
            emp
    )) "회사 평균 급여"
FROM
    emp
GROUP BY
    ename, sal
;
/*
문제 6.
    부서별 급여의 합이 제일 높은 부서 사원들의
     사원 이름, 직급, 부서번호, 부서이름, 부서 급여 합계, 부서원 수 를 조회하시오.
*/
SELECT
    ename "사원 이름", job 직급, dno "부서 번호", dept.dname "부서 이름",
    sum "부서 급여 합계", co "부서원 수"
FROM
    emp
JOIN dept ON dept.deptno=emp.deptno
JOIN (

    SELECT
        dept.deptno dno, SUM(sal) sum, COUNT(*) co
    FROM
        emp, dept
    WHERE
        emp.deptno=dept.deptno
    GROUP BY
        dept.deptno
    HAVING
        SUM(sal)>= ALL (SELECT SUM(sal) FROM emp GROUP BY deptno)
        
    ) ON dno=emp.deptno
;

/*
문제 7.
    커미션을 받는 사원이 한 명이라도 있는 부서의 사원들의
        사원 이름, 직급, 부서 번호, 커미션 을 조회하시오.
*/
SELECT
    ename "사원 이름", job 직급, deptno "부서 번호", comm 커미션
FROM
    emp
WHERE
    deptno IN (
        SELECT
            deptno
        FROM
            emp
        WHERE
            comm IS NOT NULL
    )
;
/*
문제 8.
    회사 평균 급여보다 급여가 높고, 이름이 4-5글자인 사원들의
        사원 이름, 급여, 이름글자수[, 회사 평균 급여]를 조회하시오.
*/
SELECT
    ename "사원 이름", sal 급여, LENGTH(ename) "이름 글자 수", (
        SELECT
            ROUND(AVG(sal))
        FROM
            emp
    ) "회사 평균 급여"
FROM
    emp
WHERE
    sal > (
        SELECT
            AVG(sal) av
        FROM
            emp
    )
    AND (LENGTH(ename)=4 OR LENGTH(ename)=5)
;
/*
문제 9.
    사원이름의 글자수가 4글자인 사원과 같은 직급을 가진 사원들의
        사원 이름, 직급, 급여 를 조회하시오.
*/
SELECT
    ename "사원 이름", job 직급, sal 급여
FROM
    emp
WHERE
    job IN (
        SELECT
            job
        FROM
            emp
        WHERE
            LENGTH(ename)=4
    )
;
/*
문제 10.
    입사년도가 81년이 아닌 사원과 같은 부서에 있는 사원들의
        사원 이름, 직급, 급여, 입사일, 부서번호 를 조회하시오.
*/
SELECT
    ename "사원 이름", job 직급, sal 급여, hiredate 입사일, deptno "부서 번호"
FROM
    emp
WHERE
    deptno IN(
        SELECT
            deptno
        FROM
            emp
        WHERE
            TO_CHAR(hiredate, 'YY')!='81'
    )
;
/*
문제 11.
    직급별 평균 급여 중, 하나이상 급여가 높은 사원의
        사원 이름, 직급, 급여, 입사일 을 조회하시오.
*/
SELECT
    ename "사원 이름", job 직급, sal 급여, hiredate 입사일
FROM
    emp
WHERE
    sal > ANY (
        SELECT
            AVG(sal)
        FROM
            emp
        GROUP BY
            job
    )
;
/*
문제 12.
    입사 연도별 평균 급여 중, 하나 이상 급여가 높은 사원의
        사원 이름, 직급, 급여, 입사년도 를 조회하시오.
*/
SELECT
    ename "사원 이름", job 직급, sal 급여, hiredate "입사 년도"
FROM
    emp
WHERE
    sal > ANY (
        SELECT
            AVG(sal)
        FROM
            emp
        GROUP BY
            TO_CHAR(hiredate, 'YY')
    )
;
/*
문제 13.
    최고액 급여자의 이름글자수와 같은 글자수의 직원이 존재하면
    모든 사원의 사원 이름, 이름 글자수, 직급, 급여 를 조회하고
    
    존재하지 않으면
    어떠한 정보도 조회되지 않도록 하시오.
*/
SELECT
    ename "사원 이름", LENGTH(ename) "이름 글자수", job 직급, sal 급여
FROM
    emp
WHERE
    EXISTS (
        SELECT
            ename
        FROM
            emp
        WHERE
            LENGTH(ename) IN (
                SELECT
                    LENGTH(ename)
                FROM
                    emp
                WHERE
                    ename IN (
                        SELECT
                            ename
                        FROM
                            emp
                        WHERE
                            sal >= ALL (
                                SELECT
                                    sal
                                FROM
                                    emp
                            )
                    )
            )
    )
;

