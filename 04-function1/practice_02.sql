/* ========================= [ 쿼리 연습 정답 ] ========================= */
/*
    1.  사원들의 이름, 직급, 입사일, 급여 조회
        (단, 급여를 기준으로 내림차순 출력)
*/
SELECT ename "사원 이름", job 직급, hiredate 입사일, sal 급여
FROM emp
ORDER BY sal DESC;

/*
    2. 사원들의 사원 이름, 직급, 입사일, 부서번호 조회
        (단, 부서번호 오름차순 출력. 부서 번호가 같다면 입사일 오름차순 출력)
*/
SELECT ename "사원 이름", job 직급, hiredate 입사일, deptno "부서 번호"
FROM emp
ORDER BY deptno, hiredate;

/*
    3.  사원들 중 입사월이 5월인 사원들의
        사원이름, 직급, 입사일 조회
        (단, 입사일 오름차순 정렬)
*/
SELECT ename "사원 이름", job 직급, hiredate 입사일
FROM emp
ORDER BY hiredate;

/*
    4.  사원들 중 이름의 마지막 글자가 S인 사람의
        사원이름, 직급, 입사일 조회

    조건 :
        직급 오름차순 조회
        같은 직급일 경우 입사일 오름차순 조회
        연산자 사용
*/
SELECT ename "사원 이름", job 직급, hiredate 입사일
FROM emp
WHERE ename LIKE '%S'
ORDER BY job, hiredate;

/*
    5.  사원들의 이름과 커미션을 조회

    조건 :
        NVL() 사용
        커미션이 없다면 100달러 일괄 지급
        커미션을 27% 인상 계산 (모든 사원 동일 적용)
        인상된 커미션은 소수 둘째자리 반올림
*/
SELECT ename "사원 이름",
    ROUND(NVL(comm, 100) * 1.27, 2) "인상 커미션"
FROM emp;

/*
    6.  사원들의 사원 이름, 직급, 급여 출력

    조건 :
        급여는 급여의 15%를 인상한 금액 + 커미션 합산
        커미션이 없는 경우 0으로 가정하여 처리
        계산된 급여는 소수 이상 첫째 자리에서 버림
*/
SELECT ename "사원 이름", job 직급,
    TRUNC(sal * 1.15 + NVL(comm, 0), -1) "인상 급여"
FROM emp;

/*
    7. 사원들 중 급여가 100으로 나누어 떨어지는 사원들의
        사원이름, 직급, 급여 조회
*/
SELECT ename "사원 이름", job 직급, sal 급여
FROM emp
WHERE MOD(sal, 100) = 0;