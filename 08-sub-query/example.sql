/* ========================= [ sub query : 기본적인 예시 ] ========================= */
/*
    사원들의 사원 이름, 부서번호, 부서 이름, 부서 위치 조회
    (단, sub query를 사용하여 부서 이름, 부서 위치 조회)
*/
SELECT ename "사원 이름", deptno "부서 번호",
    (SELECT dname FROM dept WHERE deptno = e.deptno) "부서 이름",
    (SELECT loc FROM dept WHERE deptno = e.deptno) "부서 위치"
FROM emp e;

/*
    10번 부서에 존재하는 직급을 가진 사원들의
    직급, 직급 급여 평균 조회
*/
SELECT job 직급, ROUND(AVG(sal)) "직급 급여 평균"
FROM emp
WHERE job IN (SELECT job FROM emp WHERE deptno = 10)
GROUP BY job;

/* ========================= [ sub query : WHERE 절에서의 사용 ] ========================= */
-- IN --
/*
    직급이 MANAGER인 사원과 같은 부서에 속한 사원들의
    사원 이름, 직급, 부서번호 조회
*/
SELECT ename "사원 이름", job 직급, deptno "부서 번호"
FROM emp
WHERE /* NOT 자리1 */ deptno /* NOT 자리2 */ IN (
    SELECT deptno FROM emp
    WHERE job = 'MANAGER'
);

-- ANY --
/*
    각 부서의 평균 급여 중 하나 이상 급여가 높은 사원들의
    사원 이름, 급여, 부서 번호 조회
*/
SELECT ename "사원 이름", sal 급여, deptno "부서 번호"
FROM emp
-- 조건에 GROUP BY가 들어가야 하니 sub query 사용
WHERE /* NOT 자리 */ sal > ANY ( -- 어떤 하나 이상의 값만 커도 됨
    SELECT AVG(sal) FROM emp
    GROUP BY deptno
);

-- ALL --
/*
    각 부서의 평균 급여보다 높은 급여를 받는 사원의
    이름, 급여, 부서 번호 조회
*/
SELECT ename "사원 이름", sal 급여, deptno "부서 번호"
FROM emp
WHERE /* NOT 자리 */ sal > ALL ( -- 괄호 안 모든 값보다 커야함
    SELECT AVG(sal) FROM emp
    GROUP BY deptno
);

-- EXISTS : 맛보기 개념 포함 --
/*
    40번 부서의 사원이 존재한다면 해당하는 모든 사원들의
    사원 이름, 부서 번호 조회
*/
SELECT ename "사원 이름", deptno "부서 번호"
FROM /* scott.*/emp
    /*
        테이블을 가리킬 때는
            user_name.tbl_name

        으로 기재하는 것이 FM이나,
        현재 계정(또는 접속 DB)에 한해서는 테이블 명만 기재해도 구동된다.

        현재 계정(또는 접속 DB)을 유지한 채
        잠시 타 계정(또는 접속 DB)의 테이블을 이용할때 유용한 구문.

        oracle의 경우 스키마(schema)가 <계정에 귀속>되어 계정 명을 기재했지만
        mySQL 등 타 DB에서는 스키마가 <database에 귀속>된다.
            이 경우 계정명 대신 DB명을 기재하면 똑같이 구동된다.
    */
WHERE /* NOT 자리 */ EXISTS (
    SELECT ename, sal, deptno FROM emp
    WHERE deptno = 40
);

/* ========================= [ sub query : 실전 예제 ] ========================= */
/*
    사원들의 사원 이름, 부서 번호,
    부서원 수, 부서 평균 급여, 부서 급여 합계 조회
*/
SELECT ename "사원 이름", deptno "부서 번호",
    cnt "부서원 수", avg "부서 평균 급여", sum "부서 급여 합계"
FROM emp, (
        SELECT deptno dno, COUNT(*) cnt -- 별칭(alias)를 사용해야 에러가 발생하지 않는다.
            , ROUND(AVG(sal), 2) as avg, sum(sal) as sum
        FROM emp
        GROUP BY deptno
    )
WHERE deptno = dno;

/*
    회사 평균 급여보다 급여가 적은 사원들의
    사원 이름, 직급, 입사일, 급여 조회
*/
SELECT ename "사원 이름", job 직급, hiredate 입사일, sal 급여
FROM emp
WHERE sal <  (SELECT ROUND(avg(sal)) FROM emp);

/* ========================= [ ROWNUM ] ========================= */
/*
    10번 부서에 속한 사원들의
    사원 이름, 직급, 급여, 부서 번호 조회
    이 때, 행 번호도 함께 조회

    (단, 사원 번호 내림차순 정렬)
*/
SELECT * FROM (
    SELECT ROWNUM rno, a.*
    FROM (
        SELECT empno, ename, job, sal, deptno
        FROM emp
        WHERE deptno = 10
        ORDER BY empno DESC
    ) a
);

-- 위 쿼리에서 2 ~ 4번째 행만 추출하는 경우
SELECT ROWNUM rno, a.*
FROM (
    SELECT empno, ename, job, sal, deptno
    FROM emp
    WHERE deptno = 10
    ORDER BY empno DESC
) a
WHERE rno BETWEEN 2 AND 4;

/*
    ROWNUM rno, WHERE rno BETWEEN 2 AND 4 가 inline view 안에 있다면?
    *쿼리 순서대로 설명

    1. FROM     - emp 테이블을 대상으로 하며 <<ROWNUM 부여>>
    2. WHERE    - 부서 번호 10인 사원, 1번 기준의 2~4번째 행만 추출
    3. SELECT   - ROWNUM, empno, ename, job, sal, deptno 조회

    때문에 엉뚱한 결과가 나올 가능성이 매우 높다.
*/
/*
    사원들의 사번, 사원 이름, 급여, 직급, 커미션,
    부서 번호, 부서 이름, 부서 위치 조회
    이 때, 행 번호도 함께 조회

    (단, 이름 내림차순 기준 4 ~ 6번째 행만 조회)
*/
SELECT ROWNUM rno, a.*
FROM (
    SELECT empno, ename, sal, job, comm,
        e.deptno, dname, loc
    FROM emp e
        JOIN dept d ON e.deptno = d.deptno
    ORDER BY ename DESC
) a
WHERE rno BETWEEN 4 AND 6;

/* ========================= [ 계층 질의 ] ========================= */
SELECT empno, ename, job, mgr, LEVEL, hiredate
FROM emp -- target table
-- 계층 추적 시작 : 상사가 없는 사원이 1, 상하관계에 따라 값 증가
START WITH mgr IS NULL
-- 계층 추적 조건 : 상사 사번과 이전 계층이 일치하는 값이 있다면 LEVEL++
CONNECT BY mgr = PRIOR empno
-- 계층 간 정렬 : 기본 LEVEL 오름차순, 같을 경우 입사 순서 내림차순 정렬
ORDER SIBLINGS BY hiredate DESC;