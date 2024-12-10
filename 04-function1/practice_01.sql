/*
    1.  사원 이름이 5글자 이하인 사원들의
        사번, 사원 이름, 이름의 글자 수, 직급, 급여 조회
        (단, 글자수가 작은 사원의 이름 순서로 정렬)
*/
SELECT empno 사번, ename "사원 이름", LENGTH(ename) "이름 글자수", job 직급, sal 급여
FROM emp
ORDER BY LENGTH(ename);

/*
    2.  사원 이름 앞에 '사원'을 붙여
        사원 이름, 직급, 입사일 조회
*/
SELECT CONCAT('사원 ', ename) "사원 이름", job 직급, hiredate 입사일
FROM emp;

/*
    3. 사원이름의 마지막 글자가 'N'인 사원들의
        사원 이름, 입사일, 부서번호 조회
        (단, 부서 번호 순으로 정렬. 부서 번호가 같다면 이름 순 정렬)
*/
SELECT ename "사원 이름", hiredate 입사일, deptno "부서 번호"
FROM emp
ORDER BY deptno, ename;

-- 4. 사원이름 중 'a'가 존재하지 않는 사원의 정보 조회
SELECT empno 사번, ename "사원 이름", job 직급
FROM emp 
WHERE INSTR(ename, 'A') = 0;

/*
    5. 사원 이름 중, 뒤 2글자만 남기고
        앞글자는 모두 '#'로 대체하여
        사원 이름, 입사일, 급여 조회
*/
SELECT LPAD(SUBSTR(ename, -2), LENGTH(ename), '#') "사원 이름",
    hiredate 입사일, sal 급여
FROM emp;