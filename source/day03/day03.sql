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
        날짜 연번끼리 -연산식을 하게 된다. (덧셈 뺄셈 외의 연산은 불가능!!)
        
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