/* ========================= [ type transformation ] ========================= */
-- TO_CHAR() --
/*
    사원들의 사원 이름, 한글 입사일, 부서 번호 조회
    (단, 입사일은 YYYY년 MM년 DD일의 형식으로 조회)
*/
SELECT ename "사원 이름", TO_CHAR(hiredate, 'YYYY"년 "MM"월 "DD"일"') "한글 입사일",
    deptno "부서 번호"
FROM emp;

/*
    사원들의 사원 이름, 급여  조회
    (단, 급여가 100 ~ 999 사이인 경우만)
*/
SELECT ename "사원 이름", sal 급여
FROM emp
WHERE LENGTH(TO_CHAR(sal)) = 3;
--WHERE TO_CHAR(sal) LIKE '___'; -- 해당 구문도 가능. 하지만 LIKE는 성능이 떨어진다.

/*
    사원들의 사원 이름,  급여, 문자급여 조회
    문자 급여 :
        맨 앞에 $를 붙이고, 3자리마다 ','를 붙여 조회
*/
SELECT ename "사원 이름", sal 급여,
    TO_CHAR(sal, '$9,999,999,999,999') 문자급여1,
    TO_CHAR(sal, '$0,000,000') 문자급여2 -- 자릿수가 fix된 경우
FROM emp;

-- TO_DATE() --
/*
    자신의 생존 일수 조회
    [HINT] 현재 시간 - 생년월일
*/
SELECT FLOOR(sysdate - TO_DATE('00/12/09')) "생존 일수"
FROM dual;

-- 아래의 경우도 가능하다.
SELECT FLOOR(sysdate - TO_DATE('00#12#09')) FROM dual;
SELECT sysdate - TO_DATE('00/12/09','YY/MM/DD') FROM dual;
SELECT sysdate - TO_DATE('20001209', 'YYYYMMDD') FROM dual;

-- TO_NUMBER() --
-- '123'과 '456'을 더한  결과를
SELECT '123' + '456' FROM dual; -- 형변환 함수가 자동호출 됨

-- FM case :
SELECT TO_NUMBER('123') + TO_NUMBER('456')
FROM dual;

-- '1,234' + '5,678' 을 형변환 함수를 사용해서 계산
SELECT TO_NUMBER('1,234', '9,999,999') + TO_NUMBER('5,678', '9,999,999')
FROM dual;

/* ========================= [ date : SYSDATE ] ========================= */
-- 사원들의 근무 일수 조회
SELECT ename "사원 이름", FLOOR(sysdate - hiredate) 근무일수
FROM emp; -- floor를 생략할 경우 시간까지 계산한 결과가 조회된다.

-- 현재 DB 시간의 10일 뒤 날짜 조회
SELECT sysdate + 10  "10일 후" FROM dual;

/* ========================= [ date : calculate ] ========================= */
-- ADD_MONTHS() --
SELECT ADD_MONTHS(SYSDATE, 4) "4개월 후", ADD_MONTHS(SYSDATE, -3) "3개월 전"
FROM dual;

-- MONTHS_BETWEEN() --
-- 사원들의 근무 개월 수 조회
SELECT ename "사원 이름", hiredate 입사일,
    TRUNC(MONTHS_BETWEEN(SYSDATE, hiredate)) "근무 개월 수"
FROM emp;

-- LAST_DAY() --
-- 현재 DB 시간의 이번달 마지막 날짜 조회
SELECT LAST_DAY(sysdate) FROM dual;

/*
    사원들의 사원 이름, 급여, 입사일, 첫 급여일 조회
    (단, 급여일은 매월 말일)
*/
SELECT ename "사원 이름", sal 급여, hiredate 입사일,
    LAST_DAY(hiredate) "첫 급여일"
FROM emp;

-- 급여일이 매월 1일인 경우
SELECT ename "사원 이름", sal 급여, hiredate 입사일,
    LAST_DAY(hiredate) + 1 "첫 급여일"
FROM emp;

-- LAST_DAY() --
-- 현재 DB 시간의 이번 주 일요일의 일자 조회
SELECT NEXT_DAY(sysdate, '일') FROM dual;
    
-- 이번 년도 성탄절 이후 첫 토요일
SELECT NEXT_DAY('24/12/25', '토')
FROM dual;   -- 문자 => 날짜 형변환 함수 자동 호출
-- 다른 방법
SELECT NEXT_DAY(TO_DATE('24/12/25','YY/MM/DD'), '토')
FROM dual;

-- ROUND() --
-- 현재 DB 시간을 년도 기준 반올림
SELECT ROUND(sysdate, 'YEAR')
FROM dual;
    
-- 현재 DB 시간을 월기준 반올림
SELECT ROUND(sysdate, 'MONTH') FROM dual;

/* ========================= [ null handling ] ========================= */
-- NVL() & NVL2() --
-- 사원들의 사원이름, 커미션 조회(단, 커미션이 없으면 'NONE'으로 출력)
SELECT ename "사원 이름",
    --  NVL(comm, 'NONE')       -- 불가 : 데이터 타입 불일치(number-string)
    NVL(TO_CHAR(comm), 'NONE') 커미션 -- 가능
FROM emp;

/*
    사원들의 사원이름, 급여 출력
    (단, 급여는 커미션을 포함)
*/
SELECT ename "사원 이름", NVL2(comm, sal + comm, sal) 급여
-- 이 경우, comm이 NULL일 때 무조건 NULL 값이 나오기 때문에 null handling이 필요하다.
FROM emp;

-- COALESCE() --
/*
    사원들의 사원 이름, 커미션 출력
    (단, 커미션이 NULL인 경우 급여 출력)
*/
SELECT ename "사원 이름", COALESCE(comm, sal, 0)
FROM emp;

/* ========================= [ 조건 처리 함수 ] ========================= */
-- DECODE() --
/*
    사원들의 사원 이름, 직급, 부서 번호, 부서 이름 조회

    부서 이름 매핑 :
        부서 번호 별 다음과 같이 처리
        10  - ACCOUNTING
        20  - RESEARCH
        30  - SALES
        40  - OPERATIONS
*/
SELECT ename "사원 이름", job 직급, deptno "부서 번호",
    DECODE(deptno,
        10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS'
    ) "부서 이름"
FROM emp
ORDER BY deptno, job;

-- CASE ~ WHEN --
SELECT ename "사원 이름", job 직급, sal 급여,
    ROUND(CASE
        WHEN sal < 1000 THEN sal * 1.2 -- 가장 먼저 처리됨
        WHEN sal < 3000 THEN sal * 1.15
        ELSE sal * 1.1
    END) "인상 급여"
FROM emp;
