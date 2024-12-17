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
            database_name.tbl_name

        으로 기재하는 것이 FM이나,
        현재 접속 DB에 한해서는 테이블 명만 기재해도 구동된다.

        동일 계정 내에서 잠시 타 DB의 테이블을 이용할때 유용한 구문.
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

/* ========================= [ 계층 질의 ] ========================= */
SELECT empno, ename, job, mgr, LEVEL, hiredate
FROM emp -- target table
-- 계층 추적 시작 : 상사가 없는 사원이 1, 상하관계에 따라 값 증가
START WITH mgr IS NULL
-- 계층 추적 조건 : 상사 사번과 이전 계층이 일치하는 값이 있다면 LEVEL++
CONNECT BY mgr = PRIOR empno
-- 계층 간 정렬 : 기본 LEVEL 오름차순, 같을 경우 입사 순서 내림차순 정렬
ORDER SIBLINGS BY hiredate DESC;