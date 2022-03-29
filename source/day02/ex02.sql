-- 금요일에 배운 내용 복습문제

/*
문제 1.
    사원의 이름, 직급, 입사일, 급여를 조회하시오.
    단, 급여를 기준으로 내림차순 출력하시오, */
SELECT
    ename "사원 이름", job 직급, hiredate 입사일, sal 급여
FROM
    emp
ORDER BY
    sal DESC;

/*
문제 2.
    사원들의
        사원 이름, 직급, 입사일, 부서번호를 조회하시오,
    
    단, 부서번호 순서대로 출력하고,
    같은 부서이면 입사일 순서대로 출력게 하시오.   */
SELECT
    ename "사원 이름", job 직급, hiredate 입사일, deptno "부서 번호"
FROM
    emp
ORDER BY
    deptno, hiredate;
    
/*
문제 3.
    입사월이 5월인 사원의
        사원이름, 직급, 입사일을 조회하시오.
    
    단, 입사일이 빠른 사람이 먼저 조회되도록 하시오.    */
SELECT
    ename "사원 이름", job 직급, hiredate 입사일
FROM
    emp
ORDER BY
    hiredate;
    
/*
문제 4.
    연산자를 사용해 해결하시오
    
    이름의 마지막 글자가 S인 사람의
        사원이름, 직급, 입사일을 조회하시오,
    
    단, 직급 순서대로 조회하고,
    같은 직급이면 입사일 순서대로 출력되도록 하시오. */
SELECT
    ename "사원 이름", job 직급, hiredate 입사일
FROM
    emp
WHERE
    ename LIKE '%S'
ORDER BY
    job, hiredate;
/*
문제 5.
    NVL()을 사용해 처리하시오.
    
    커미션을 27%인상하여 조회하시오.
    단, 커미션이 없는 사원은 커미션을 100 달러 지급하기로 하고
    27% 인상 계산은 똑같이 적용시키시오.
    소수 둘째 자리에서 반올림하여 출력하시오  */
SELECT
    ename "사원 이름", ROUND(NVL(comm, 100)*1.27, 2) "인상 커미션"
FROM
    emp;
/*
문제 6.
    급여의 15%를 인상한 금액과 커미션을 합쳐서
        사원 이름, 직급, 급여를 출력하시오.
    
    단, 급여는 소수 이상 첫째 자리에서 버림하여 출력하시오,
    커미션이 없는 사람은 0으로 가정하여 처리하시오, */
SELECT
    ename "사원 이름", job 직급, TRUNC(sal*1.15+NVL(comm,0), -1) "인상 급여"
FROM
    emp;

/*
    문제 7 ]
        급여를 100으로 나누어 떨어지는 사람만 
            사원이름, 직급, 급여를 조회하세요.    */
SELECT
    ename "사원 이름", job 직급, sal 급여
FROM
    emp
WHERE
    MOD(sal, 100)=0;