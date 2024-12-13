/* ========================= [ 쿼리 연습 정답 ] ========================= */
/*
    1.  사원들의 사원 이름, 급여, 커미션, 지급 급여 조회

    지급 급여 계산 :
        커미션 별 다음과 같이 처리
            NULL    - 급여의 5%  인상액 + 100
            그 외   - 급여의 10% 인상액 + 커미션
*/
SELECT ename "사원 이름", sal 급여, comm 커미션,
    NVL2(comm, sal * 1.1 + comm, sal * 1.05 + 100) "지급 급여"
FROM emp;
-- 다른 풀이
SELECT ename "사원 이름", sal 급여, comm 커미션,
    COALESCE(sal * 1.1 + comm, sal * 1.05 + 100) "지급 급여" -- comm IS NULL인 경우 자동 NULL 연산됨
FROM emp;

/*
    2.  사원들의 사원 이름, 급여, 커미션, 지급 커미션 조회

    지급 커미션 계산 :
        커미션 별 다음과 같이 처리
            NULL    - 급여의 10% 인상액
            그 외   - 커미션의 50% 인상액
*/
SELECT ename "사원 이름", sal 급여, comm 커미션,
    COALESCE(comm * 1.5 + sal, sal * 1.1) "지급 커미션"
FROM emp;
-- 다른 풀이
SELECT ename "사원 이름", sal 급여, comm 커미션,
    NVL2(comm, comm * 1.5 + sal, sal * 1.1) "지급 커미션"
FROM emp;