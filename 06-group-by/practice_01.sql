/* ========================= [ 쿼리 연습 정답 ] ========================= */
/*
    1.  부서 별 최소 급여 조회
        출력 : 부서번호, 최소 급여
*/
SELECT deptno "부서 번호", MIN(sal)"최소 급여"
FROM emp
GROUP BY deptno;

/*
    2.  직급 별 급여의 총액, 평균 급여 조회
        출력 : 직급, 총 급여, 평균 급여
*/
SELECT job 직급, SUM(sal) "총 급여", ROUND(AVG(sal), 1) "평균 급여"
FROM emp
GROUP BY job;

/*
    3.  입사 년도 별 평균 급여, 총 급여 조회
        출력 : 입사 년도, 평균 급여, 총 급여
        (단, 입사년도는 'YY년도' 형태로 출력)
*/
SELECT SUBSTR(hiredate, 0, 2) || '년도' "입사 년도",
    AVG(sal) "평균 급여", SUM(sal) "총 급여"
FROM emp
GROUP BY SUBSTR(hiredate, 0, 2)
ORDER BY SUBSTR(hiredate, 0, 2);

/*
    4.  년도 별 입사 사원 수 조회
        출력 : 입사 년도, 입사 사원 수
        (단, 입사년도는 'YY년도' 형태로 출력)
*/
SELECT SUBSTR(hiredate, 0, 2) || '년도' "입사 년도",
    COUNT(*) "입사 사원 수"
FROM emp
GROUP BY SUBSTR(hiredate, 0,2);

-- 다른 풀이
SELECT TO_CHAR(hiredate, 'YY') || '년도' "입사년도",
    COUNT(*) "입사 사원 수"
FROM emp
GROUP BY TO_CHAR(hiredate, 'YY');

/*
    5.  사원 이름의 글자 수 별 사원 수 조회
        출력 : 이름 글자 수, 사원 수

        조건 :
            사원 이름의 글자 수가 4, 5글자인 사원만 집계
            집계된 사원 이름의 글자 수는 'n글자' 형태로 출력
*/
SELECT LENGTH(ename) || '글자' "이름 글자 수", COUNT(*) "사원 수"
FROM emp
GROUP BY LENGTH(ename)
HAVING LENGTH(ename) = 4 OR LENGTH(ename) = 5;

/*
    6.  사원들 중 81년도에 입사한 사원의
        직급 별 사원 수 조회
        출력 : 직급, 사원 수
*/
SELECT job 직급, COUNT(*) "사원 수"
FROM emp
WHERE INSTR(hiredate, '81') > 0
GROUP BY job;

/*
    7.  부서 별, 이름 글자 수 별 사원 수 조회
        출력 : 부서 번호, 이름 글자 수, 사원 수

        조건 :
            사원 수가 한사람 이하인 부서는 조회에서 제외
            집계된 사원 이름의 글자 수는 'n글자' 형태로 출력
*/
SELECT deptno "부서 번호",
    LENGTH(ename) || '글자' "이름 글자 수", COUNT(*) "사원 수"
FROM emp
WHERE LENGTH(ename) = 4 OR LENGTH(ename) = 5
GROUP BY deptno, LENGTH(ename)
HAVING COUNT(*) > 1;

/*
    8.  81년도 입사한 사원들의 직급 별 전체 급여 조회
        출력 : 직급, 전체 급여
        (단, 직급 별 평균 급여가 1000 미만인 직급은 조회에서 제외)
*/
SELECT job 직급, SUM(sal) "전체 급여"
FROM emp
WHERE INSTR(hiredate, '81') > 0
GROUP BY job
HAVING SUM(sal) > 1000;

/*
    9.  81년도 입사한 사원들의
        사원 이름의 글자수 별 총 급여 조회
        출력 : 이름 글자 수, 총 급여

    조건 :
        사원 이름의 글자수 별 총 급여가 2000 미만인 경우 조회에서 제외
        집계된 사원 이름의 글자 수는 'n글자' 형태로 출력
        총 급여가 큰 순서로 정렬
*/
SELECT LENGTH(ename) || '글자' "이름 글자 수", SUM(sal) "총 급여"
FROM emp
WHERE INSTR(hiredate, '81') > 0
GROUP BY LENGTH(ename)
HAVING SUM(sal) >= 2000
ORDER BY SUM(sal) DESC;

/*
    10. 부서 별 사원 수 조회
        출력 : 부서 번호, 사원 수

    조건 :
        사원 이름의 글자 수가 4, 5글자 사원만 집계
        부서 별 사원 수가 0인 경우 조회에서 제외
        부서 번호 오름차순 정렬
*/
SELECT deptno "부서 번호", COUNT(*) "사원 수"
FROM emp
WHERE LENGTH(ename) = 4 OR LENGTH(ename) = 5
GROUP BY deptno
HAVING COUNT(*) > 0
ORDER BY deptno;
