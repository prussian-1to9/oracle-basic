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


/* ========================= [ DISTINCT ] ========================= */
-- 사원들의 직급 조회(중복 제거)
SELECT DISTINCT job FROM emp;

-- 사원들의 직급, 부서번호 조회(중복 제거)
SELECT DISTINCT job, deptno FROM emp;
-- 직급 / 부서번호가 같은 row인 경우 출력되지 않는다.
-- row 14 => 9로 감소


/* ========================= [ 이후 토픽 맛보기 ] ========================= */
SELECT e.ename "사원 이름", e.sal 급여, e.mgr "상사 번호",
    s.ename "상사 이름", s.sal "상사 급여"
FROM emp e, emp s
WHERE e.mgr = s.empno(+);

SELECT ename "사원 이름", sal 급여, grade "급여 등급"
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal;