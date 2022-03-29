/*  문자열 관련 함수 이어서~~

    9. REPLACE()
    ==> 문자열의 특정 부분을 다른 문자열로 대체하여 반환해 주는 함수
    
        REPLACE(데이터, 타겟문자, 대체문자)    */

SELECT
    REPLACE('glitch mode', 'gl', 'sw') "글리치 모드(?)"
    -- 얘는 최초 해당부분 하나만 바꾸는게 아니라, 해당부분 모두를 바꾼다.
FROM
    dual;
    
/*
    10. TRIM
    ==> 문자열 중, 앞 또는 뒤에 있는 지정한 문자를 삭제해 반환해주는 함수.
        (중간에 있는 문자를 삭제하진 못함, 이 경우 replave 쓰는게 빠르고 편리)
        
        TRIM([삭제할문자 FROM] 데이터)
        
        같은 문자가 연속되어 있으면 모두 지운다.
        데이터 앞, 뒤에 공백 문자가 들어간 경우를 대비해 많이 쓰인다.    */

SELECT
    TRIM(' ' FROM '   glitch mode   ')
FROM
    dual;

/*
    10-1. LTRIM, RTRIM
        
            LTRIM(데이터, 삭제문자)
*/

SELECT
    LTRIM('dreamed', 'd')
FROM
    dual;
----
SELECT
    RTRIM('dreamed', 'd')
FROM
    dual;
    
/*
    11. CHR()
    ==> ascii 코드를 알려주면, 그 코드에 해당하는 문자를 알려줌.
    
        CHAR(숫자)
    
    12. ASCII()
    ==> 문자열의 ascii코드를 알려줌. (chr함수와 정 반대)
    
        ASCII(데이터)
        
        젤 앞 글자만 알려준다.
*/
SELECT
    ASCII('buff') 코드값,
    CHR(ASCII('buff'))
FROM
    dual;
    
/*
    13. TRANSLATE
    ==> REPLACE와 마찬가지로, 문자열 중 지정한 부분을 다른 문자열로 바꿔줌.
    
        TRANSLATE(데이터, 바꿀문자열, 대체문자열)
    
        REPLACE : 바꿀 문자열 전체를 바꿈
        TRANSLATE : 문자열 단위로 처리  */

SELECT
    TRANSLATE('ADBC', 'ABCD', '1234')  --A는 1, B는 2, C는 3, D는 4로 바꿈
FROM
    dual;
    
--------------------------------------------------------------------------------
/*
    날짜 처리 함수
    
  **SYSDATE
    ==> 현재 시스템과 시각을 미리 알려주는 예약어
        (의사 칼럼으로 보면 됨)
        
      + oracle은 날짜 - 날짜의 연산이 가능하다.
        날짜 데이터의 기준 1970년 1월 1이 0시 0분 0초 이다.     
        날짜 연번끼리 -연산식을 하게 된다.
        (날짜 끼리의 연산은 뺄셈만 가능!!)
        
        + 날짜 +(or -) 숫자
          ==> 날짜에서 원하는 숫자만큼 이동한 날짜를 표시한다.   */
        
-- 사원들의 근무 일수를 조회하세요.
SELECT
    ename "사원 이름", FLOOR(sysdate-hiredate) 근무일수
FROM
    emp;
---
SELECT
    sysdate+10  "10일 후"
FROM
    dual;
--------------------------------------------------------------------------------
/*
    날짜 데이터 처리 함수
    
    1. ADD.MONTHS()
    ==> 날짜에 지정한 달수를 더하거나 뺀 날짜를 알려준다
    
    ADD+MONTHS(날짜, 더할 개월 수) 
    
    더할 개월 수에 음수를 입력하면, 해당 개월 수를 뺀 날짜를 알려준다. */
    
SELECT
    ADD_MONTHS(SYSDATE, 4) "4개월 후",
    ADD_MONTHS(SYSDATE, -3) "3개월 전"
FROM
    dual;

/*
    2. MONTHS_BETWEEN
    ==> 두 날짜 데이터의 개월수를 알려주는 함수
    
    MONTHS_BETWEEN (날짜1, 날짜2)   */

-- 사원들의 근무 개월수를 조회하시오.
SELECT
    ename "사원 이름", hiredate 입사일,
    TRUNC(MONTHS_BETWEEN(SYSDATE, hiredate)) "근무 개월 수"
FROM
    emp;
    
/*
    3. LAST_DAY
*/

-- 이번달 마지막 날짜를 조회하시오,
SELECT LAST_DAY(sysdate) FROM dual;

-- 사원들의 첫 번째 월급을 조회하시오. (급여지급은 매월 말일)
SELECT
    ename "사원 이름", sal 급여, hiredate 입사일, LAST_DAY(hiredate) "첫 급여일"
FROM
    emp;
    
-- 사원들의 첫 번째 월급을 조회하시오. (급여지급은 매월 1일)
SELECT
    ename "사원 이름", sal 급여, hiredate 입사일,
    LAST_DAY(hiredate)+1 "첫 급여일"
FROM
    emp;
    
/*
    4. NEXT_DAY
    ==> 지정한 날짜 이후, 가장 처음 오는 지정 요일에 해당하는 날짜를 알려준다.
    
        NEXT_DAY(날짜, '요일')
        
        요일 정하는 방법
        
            1. 한글 세팅된 oracle인 경우 : '월', '월요일' 등...
            2. 영문 세팅된 oracle인 경우 : 'MON', 'MONDAY' etc...   */
    
-- 이번주 일요일이 며칠인지 조회하시오
SELECT
    NEXT_DAY(sysdate, '일')
FROM
    dual;
    
-- 올해 성탄절 이후 첫 토요일은??
SELECT
    NEXT_DAY('22/12/25', '토')
FROM
    dual;   -- 문자->날짜 데이터로 바뀌는 함수 자동 호출됨
/*    
SELECT
    NEXT_DAY(TO_DATE('22/12/25','YY/MM/DD'), '토')
FROM
    dual;       과 동일!   */
    
/*
    5. ROUND()
    ==> 지정한 단위에서 날짜를 반올림하는 함수
        (지정 단위 : 년, 월, 일 등...)
        
        ROUND(날짜, 기준단위) */
        
-- 현재 시간을 년도를 기준으로 반올림 하시오
SELECT
    ROUND(sysdate, 'YEAR')
FROM
    dual;
    
-- 현지시간을 월기준으로 반올림 하시오.
SELECT
    ROUND(sysdate, 'MONTH') "월 반올림"
FROM
    dual;

--------------------------------------------------------------------------------
/*
    변환 함수
    ==> 함수는 데이터 형태에 따라, 사용하는 함수가 달라진다.
        그런데 만약 사용하려는 데이터가 함수와 형태가 맞지 않는다면
        변환함수를 이용해 데이터의 형태를 변환한다.
        
                숫자 <-> 문자열 <-> 날짜
        1. TO_CHAR()
        ==> TO_CHAR(데이터, 형식)
            TO_CHAR(데이터)    */
            
/*
    사원들의 사원이름, 입사일, 부서번호를 조회하세요.
    단, 입사일은 '0000년 00월 00일' 의 형식으로 조회되게 하시오.
*/
SELECT
    ename "사원 이름", TO_CHAR(hiredate, 'YYYY"년 "MM"월 "DD"일"') "한글 입사일",
    deptno "부서 번호"
FROM
    emp;

-- 급여가 100 ~ 999 사이인 사원의 정보를 조회하시오. (형변환 사용)

SELECT
    ename "사원 이름", sal 급여
FROM
    emp
WHERE
--    TO_CHAR(sal) LIKE '___'
    LENGTH(TO_CHAR(sal))=3;

-- 사원 급여를 조회하는데 앞에는 $를 붙이고 3자리마다 , 를 붙여서 조회하세요.
SELECT
    ename 사원이름, sal 급여, TO_CHAR(sal, '$9,999,999,999,999') 문자급여1,
    TO_CHAR(sal, '$0,000,000') 문자급여2
FROM
    emp;
    
/*
    숫자-> 문자 형변환 형식에 있어 0과 9
    
        0 : 무효한 숫자여도 0을 표시해준다.
        9 : 무효하면 표시 X   */
        
/*      2. TO_DATE()
        ==> TO_DATE(날짜형식문자열)
            TO_DATE(날짜형식문자열, '변환형식')    : oracle이 지정하는 날짜 형식 外            
*/

-- 자신이 지금까지 며칠동안 살고 있는지를 알아보자.
-- hint : 현재 시간-생년월일
SELECT
    FLOOR(sysdate-TO_DATE('00/12/09')) "이지의 역사"
    -- /도 되고 #도 됨! 00#12#09
FROM
    dual;
    
SELECT sysdate-TO_DATE('00/12/09','YY/MM/DD') FROM dual;

SELECT sysdate-TO_DATE('20001209', 'YYYYMMDD') FROM dual;


/*      3. TO_NUMBER()
        ==> TO_NUMBER(데이터)
            TO_NUMBER(데이터, 변환형식) 
        
        변환형식은 TO_CHAR에서 썼던 숫자 변환 형식과 동일.
*/

-- '123'과 '456'을 더한  결과를
SELECT '123'+'456' FROM dual;   -- 형변환 함수가 자동호출

SELECT
    TO_NUMBER('123')+TO_NUMBER('456')
FROM
    dual;       -- 사실 이게 정석

-- SELECT '1,234'+'5,678' FROM dual; 을

SELECT
    TO_NUMBER('1,234', '9,999,999') + TO_NUMBER('5,678', '9,999,999')
FROM
    dual;
    
--------------------------------------------------------------------------------
/*
    기타 함수
    
    1. NVL()
    ==> null 값들을 대체할 데이터를 입력해주는 함수
    
        NVL(데이터or필드, 대체데이터)
        
      ※ 지정한 데이터와 바뀔 데이터 내용의 형태가 일치해야 함! (숫자-숫자 문자-문자)  
*/
SELECT
    ename "사원 이름", --  NVL(comm, 'NONE')   타입이 달라서 안됨
    NVL(TO_CHAR(comm), 'NONE') 커미션 --얜 가능
FROM
    emp;
    
/*
    2. NVL2()
    ==> 필드 내용이 null이면 처리내용2, 아니면 처리내용1로 처리
    
        NVL2(필드이름, 처리내용1, 처리내용2)
*/

-- 커미션이 있으면 급여+커미션, 없으면 급여만 출력하시오.
SELECT
    ename "사원 이름", NVL2(comm, sal+comm, sal) 급여
FROM
    emp;
    
/*
    3. NULLIF()
    ==> 두 데이터가 같으면 null로, 다르면 데이터1으로 처리하시오.
        
        NULLIF(데이터1, 데이터2)
        
    4. COALESCE()
    ==> 괄호 속 나열된 데이터 중, 가장 첫번째로 null이 아닌 데이터를 출력하시오.
        
        COALESCE(데이터1, 데이터2, . . .)
*/

-- 커미션이 null 이면, 커미션 대신 급여를 출력하도록 하시오.
SELECT
    ename "사원 이름", COALESCE(comm, sal, 0)
FROM
    emp;
    
--------------------------------------------------------------------------------
/*
문제 1.
    comm이 존재하면 현재 급여의 10% 인상 금액 + comm
    존재하지 않으면 현재급여의 5% 인상금액 + 100
    
    으로 조회하시오.
    조회 내용 : 사원 이름, 급여, 커미션, 지급 급여   */
SELECT
    ename "사원 이름", sal 급여, comm 커미션,
--  COALESCE(sal*1.1+comm, sal*1.05+100) "지급 급여"
    NVL2(comm, sal*1.1+comm, sal*1.05+100) "지급 급여"
FROM
    emp;
/*
문제 2.
    커미션에 50%를 추가하여 지급하고자 한다.
    만약 커미션이 존재하지 않으면, 급여의 10%를 추가해 지급하고자 한다.
    
    사원이름, 급여, 커미션, 지급 커미션    를 조회하시오.    */
    
SELECT
    ename "사원 이름", sal 급여, comm 커미션,
--  NVL2(comm, comm*1.5+sal, sal*1.1) "지급 급여"
    COALESCE(comm*1.5+sal, sal*1.1) "지급 커미션"
FROM
    emp;
    
--------------------------------------------------------------------------------
/*
    조건 처리 함수
    ==> function 이라기보단 명령에 가깝다.
        java의 swtich~case, if 를 대신하기 위해 만들어 놓음.
        
        1. DECODE : switch~case와 일맥상통.
        
            DECODE(필드이름, '값1', 처리내용1, '값2', 처리내용2, . . . 처리내용n)
            맨 마지막에 오는게 default
         ※ DECODE문 안에 조건문이 올 수 없다.  */

-- 사원들의 이름, 직급, 부서 번호, 부서 이름을 조회하시오.
-- 단, 부서 이름은 10-회계부, 20-연구부, 30-영업부, 40-관리부 로 처리하시오.
SELECT
    ename "사원 이름", job 직급, deptno "부서 번호",
    DECODE(deptno, 10, 'ACCOUNTING', 20,
    'RESEARCH', 30, 'SALES', 40, 'OPERATIONS') "부서 이름"
FROM
    emp
ORDER BY
    deptno, job;
/*
    2. CASE : if에 해당하는 '명령'
    
    1)  CASE WHEN 조건식1 THEN 실행내용1
        WHEN 조건식2 THEN 실행내용2
        . . .
        ELSE 실행내용n
        END (꼭 써줘야 됨!!!)
        
        후술할 CASE 형식2와 DECODE 구문과 달리, 동등비교가 아닌 조건식도 가능하다.
        
        
    2)  CASE 필드이름 WHEN 값1 THEN 실행내용1
        WHEN 값2 THEN 실행내용2
        . . .
        ELSE 실행내용n
        END
*/

/* 급여가 1000미만이면 20%를, 1000이상 3000미만이면 15%, 3000이상이면 10%씩
    급여를 인상하시오.
    
    사원 이름, 직급, 급여, 인상급여 를 조회하시오,    */
SELECT
    ename "사원 이름", job 직급, sal 급여,
    ROUND(
        CASE WHEN sal<1000 THEN sal*1.2
        WHEN sal<3000 THEN sal*1.15
        ELSE sal*1.1            -- 윗부분부터 처리가 된다는걸 기억하자!
        END
    ) "인상 급여"
FROM
    emp;
    
--------------------------------------------------------------------------------
/*
    GROUP function
    ==> 여러 행의 데이터를 하나로 만들어, 뭔가를 계산하는 함수
    
*** + 그룹함수는 오직 하나의 결과가 나온다!
    -> 결과가 여러개 나오는 단일행함수, 필드 각각과는 혼용해 사용할 수 없다.
    
    공통 형식 : 함수명(필드이름)
    
    1. SUM
    
    2. AVG
    
    3. COUNT : 지정한 필드 중, 유효한 데이터 개수
    ==> 필드 이름 대신 *를 사용하면, 각 필드마다 count함수를 실행하고
        가장 큰 값을 반환해 준다.
    
    4. MAX / MIN
    
    + null 데이터는 모든 연산에서 제외가 된다는 점을 잊지 말자!

------------절취선---------이런게 있다 정도임 몰라도 됨---------절취선------------
    5. STDDEV : 표준 편차를 도출
    
    6. VARIANCE : 분산 도출
*/

-- 사원들의 급여의 합을 조회하시오.
SELECT
    SUM(sal) "총 급여 합", MAX(sal) "최대 급여", MIN(sal) "최소 급여",
    COUNT(*) "사원 수"
FROM
    emp;
    
SELECT AVG(comm) "avg 계산" FROM emp;  -- null 값은 제외된것!
-- null 값이 0으로 치환되고, row 개수인 14로 나누어지면 157이 나옴.

--------------------------------------------------------------------------------
/*
    GROUP BY
    ==> 그룹 함수에 적용되는 범위(그룹)를 지정.
        조회할 때, 대상을 grouping 해 조회.
        
        SELECT ~ FROM ~ [WHERE ~ ]  --> 필터링된 결과를 갖고 (일반 조건절)
       [GROUP BY
            ~]          --> grouping
       [HAVING
            ~]          --> 2차 필터링 (grouping 조건절)
       [ORDER BY
            ~]          --> 정렬 방식 선택
            
    + grouping이 되었을 경우, grouping이 적용된 필드는 같이 조회할 수 있다.
*/

-- 직급별 평균 급여를 조회하시오.
SELECT
    job 직급, ROUND(AVG(sal), -1) "부서 평균 급여"
FROM
    emp
GROUP BY
    job
ORDER BY
    job;
    
/* 부서별 최대 급여를 조회하시오.
    부서 번호가 10 : ACCOUNTING, 20 : RESEARCH, 30 : SALES, 40 : OPERATIONS
    로 조회되게 하시오.
    
    출력 내용 : 부서 번호, 부서이름, 부서 최대 급여   */
SELECT
    deptno "부서 번호",
    DECODE(
        deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS'
    ) "부서 이름", MAX(sal) "부서 최대 급여"
FROM
    emp
GROUP BY
    deptno
ORDER BY
    deptno;
    
/*
    앞서 잠깐 언급된
    HAVING
    ==> grouping 된 것들 중, 출력에 적용될 그룹을 지정하는 조건절
    
    + WHERE와의 차이점
        WHERE   : grouping 계산 전 데이터 필터링, 그룹함수 사용 X
        HAVING  : grouping 계산 후 데이터 필터링, 그룹함수 사용 O
*/
-- 부서별 평균 급여를 조회하시오.
-- 단, 부서 평균 급여가 2000 이상인 부서만 출력되게 하시오.
SELECT
    deptno "부서 번호",
    DECODE(
        deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS'
    ) "부서 이름", ROUND(AVG(sal), -1) "부서 평균 급여"
FROM
    emp
GROUP BY
    deptno
HAVING
    AVG(sal)>=2000
ORDER BY
    deptno;
    
-- 직급별 사원 수를 조회하시오.
-- 단, 사원 수가 1명인 직급은 출력에서 제외하시오.

SELECT
    job 직급, COUNT(*) "사원 수"
FROM
    emp
GROUP BY
    job
HAVING
    COUNT(*)>1;