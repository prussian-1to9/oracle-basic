-- day02

/*
    + oracle이 데이터를 보관하는 방법
      : 테이블(entity) 단위
      
    + ERD : Entity Realtion Diagram
      테이블간의 관계를 도식화 한 다이어그램.
      
    + oracle은 테이블들 간의 관계를 형성해 데이터를 저장함.
      이런 종류의 DB관리 시스템을 관계형 데이터베이스 관리시스템 이라 캄.
      
      RDBMS : 개체들의 관계를 형성해 데이터를 관리하는 시스템.
    
    + 정형 DB   : 데이터 추가시, 형태가 갖춰져야 추가되는 데이터
      비정형 DB : 데이터 추가시, 형태가 갖춰지지 않아도 추가되는 데이터
      
    + 테이블이란 필드와 레코드(RDW, 행)으로 구성된 DB를 보관하는 가장 작은 단위.
    
        필드      : 같은 개념의 데이터 모임 (컬럼, 열, 칸 . . .)
        레코드    : 같은 목적을 가진 데이터 모임. (행, 로우 . . .)
        
        필드엔, 그 항목마다 붙여진 이름이 있다 (필드 이름)
        '원칙적으로' 레코드는 각 행을 구분하는 방법이 존재하지 X.
        
    + '세션이 열렸다.'
      oracle을 실행했을 때, 접속자에게 메모리를 할당해 놓은 상태.
      세션은 oracle이 접속을 표현하는 단어다.
      확보된 메모리 안에서만 작업(DML 명령)한다.
      최종적으로 DB에 적용시키는 작업은 별도의 TCL 명령이 필요하다.
      
      oracle에서는 같은 계정으로 여러 컴퓨터에서 동시에 접속이 가능하다.
      이 때, 확보된 메모리 공간은 서로 공유하지 않는다.
*/

-- 내가 접속한 계정 안의 테이블 이름들을 조회해 보자.
SELECT
    tname
FROM
    tab;
    
-- oracle은 명령 / 테이블 이름 / 필드 이름 을 구분하는데 대소문자 구분이 없다.
-- ※ 데이터는 구분함.
--------------------------------------------------------------------------------
/*
    조회된 데이터 중, 중복된 데이터를 한 번만 조회하도록 하는 법
    ==> 같은 데이터는 한번만 출력되도록.
    
        SELECT
            DISTINCT 칼럼이름
        FROM
            테이블이름;
            
        ※ 이 명령은 질의 명령에서 한 번만 사용해야 하고
          조회된 데이터의 각 행들이 같은 경우에만 적용 됨.
          ==> 각 필드의 데이터들 모두 동일해야 중복된 데이터로 간주.
*/
-- 사원들의 직급을 조회하시오. 근데 이제 중복은 한번 출력을 곁들인...
SELECT
    DISTINCT job
FROM
    emp;
    
-- 사원들의 직급 / 부서번호 출력, 중복데이터 X
SELECT
    DISTINCT job, deptno
FROM
    emp;    -- 14개이던 데이터가 9개로 줄긴 함.
            -- 직급+부서번호 모두가 중복된 데이터가 사라진 것.
/*
    원칙적으로 데이터를 조회할 때, 조회할 field 이름을 정확히 나열하는게 원칙.
    
    간혹, 모든 정보(모든 field)를 보고 싶은 경우,
    필드 이름을 나열하지 않고 *로 대신할 수 있다.
    하지만 실무에선 절대로 사용하지 않음 (민감한 정보가 있을 수 있으니...)
*/

-- 질의 명령 안에 연산식이 포함될 수 있다.
-- 사원들의 이름, 급여, 10%인상된 급여를 조회하시오.
SELECT
    ename as "사원 이름", sal AS 원급여, sal*1.1 "인상 급여"
FROM
    emp;
    
/*
    DUAL 테이블
    ==> 우리가 조회하게 되면
        테이블에 저장된 데이터 중 필터링을 해 결과를 보여주게 된다.
        
        그런데 데이터 '자체'를 조회하게 되면, (SELECT절에 데이터 나열)
        조회되는 데이터는 필터링 된 데이터 개수만큼 출력이 된다.
        
        간단한 계산식 결과만 원하는 경우, 이런 식은 불리하다.
        이 때 사용할 수 있는 테이블이 DUAL 테이블이다.
        
        이 테이블은 물리적으로 데이터가 저장된 테이블이 아닌,
        oracle 시스템이 제공하는 가상의 테이블이다.
        DUAL 테이블은 한개의 row만 갖는다.
*/
-- 뭔말이냐면
SELECT
    '런쥔'
FROM
    emp;    -- 14개의 런쥔이가 조회된다.
----
SELECT
    '런쥔'
FROM
    dual;   -- 1개의 런쥔이가 조회된다.
    
-- example
SELECT sysdate FROM dual;   -- 현지 시간이 한 줄에 조회된다.

/*
    sysdate : 현재 시간을 반환해 주는 연산자.
    (sql은 기본적으로, 날짜와 시각을 분리해 기억하지 않는다.)    */

/*
    oracle에서 사용하는 산술 연산자
        + - * /     (밖에 없음!!)   */
SELECT 10/3 FROM dual;  -- 자동으로 실수 연산이 됨.

--------------------------------------------------------------------------------
/*
    NULL 데이터
    ==> 필드 안에 데이터가 보관돼야 하는디, 데이터가 없을 수도 있조.
        이 데이터를 NULL 데이터라고 함다.
        
    *** NULL 데이터는, 모든 연산에서 제외됨다. (연산에 껴버리면, 결과 조회 자체가 X)
    
    *** NVL 함수
        NULL 값을 대체해 주는 함수. NULL데이터->'대신할데이터'로 바뀜.
        
        NVL(필드이름 (또는 필드 계산식), 대신할데이터)
        
*/

-- 사원들의 상사 번호 맨 앞자리에 1을 추가하여 사원이름, 상사번호 를 조회하시오.
SELECT
    ename "사원 이름", mgr+10000 "상사 번호"
FROM
    emp;
    
-- 사원들의 연봉을 계산해 사원 이름, 입사일, 연봉을 조회하시오.
-- (연봉=급여*12+커미션)
SELECT
    ename "사원 이름", hiredate 입사일, (sal*12+NVL(comm, 0)) 연봉
FROM
    emp;
    
-- 이렇게도 가능
SELECT
    ename "사원 이름", hiredate 입사일, NVL(sal*12+comm, sal*12) 연봉
FROM
    emp;
    
--------------------------------------------------------------------------------
/*
    결한 연산자
    ==> oracle에서도 문자열 결합이 가능하다.
        이 때, 두개의 필드를 결합할 수도 있고, 데이터를 결합할 수도 있음. */
        
SELECT 10||20 FROM dual;    -- 문자열로 만들어줌.

-- 사번과 사원 이름을 조회한다.
-- (단, 사원번호 - 사원이름 의 형식으로 조회하시오.)
SELECT
    empno||' - '||ename 사원
FROM
    emp;
    
-- 사원번호, 사원 이름을 조회하는데
-- 0000번, 홍길동 님
-- 의 형식으로 조회하시오.
SELECT
    empno||'번' 사번, ename||'님' "사원 이름"
    -- 숫자는 오른쪽 정렬, 문자는 왼쪽 정렬된다. (엑셀과 마찬가지)
FROM
    emp;
    
--------------------------------------------------------------------------------
/*
    조건 조회에서의 NULL 검색
    ==> NULL 데이터는 모든 연산에서 제외된다.
        조건 조회에서도 마찬가지.
        
        따라서 NULL데이터의 비교는, 비교 연산자가 아닌
            IS NULL, IS NOT NULL
        을 사용하여 비교한다.        */
        
-- 커미션이 없는 사원들의 이름, 급여, 커미션 을 조회하시오.
SELECT
    ename "사원 이름", sal 급여, comm 커미션
FROM
    emp
WHERE
--  comm=NULL;    이러면 하나도 안나옴!!
    comm IS NULL;   -- 이래야 나옴!
    
-- 커미션이 있는 사원들의 사원 번호, 사원 이름, 급여, 커미션 을 조회하시오.
-- 단, 커미션은 100을 추가하여 조회하시오.
SELECT
    empno 사번, ename "사원 이름", sal 급여, comm+100 커미션
FROM
    emp
WHERE
    comm IS NOT NULL;
--  NOT comm IS NULL 도 가능하긴 함.

--------------------------------------------------------------------------------
/*
    조회된 결과 정렬하기
    ==> 원칙적으로 DB는 종류에 따라 나름의 기준을 갖고 데이터를 조회 함.
        (반드시 입력 순서대로 조회되진 않는다.
        oracle 내부의 인덱스를 이용해, 출력 순서를 조절한다.)
        ==> 출력 순서는 모르는 일!
        
    조회된 결과를 원하는 순서대로 정렬하기~
    
        SELECT
            ~
        FROM
            ~
        WHERE
            ~
        ORDER BY
            필드이름 [ASC||DESC], 필드이름 [ASC||DESC], . . .;
            
        + ASC : 오름차순 정렬 (ascendent)
          DESC : 내림차순 정렬 (descendent)    */

-- 사원의 이름, 직급, 입사일을 조회하시오.
-- (단, 이름을 내림차순 정렬해 조회하시오)
SELECT
    ename "사원 이름", job 직급, hiredate 입사일
FROM
    emp
ORDER BY
    ename DESC;
    
-- 위 문제를 입사일 기준으로 오름차순 정렬해 조회하시오.
SELECT
    ename "사원 이름", job 직급, hiredate 입사일
FROM
    emp
ORDER BY
    hiredate ASC;
/*
    정렬할 때, 오름차순 정렬의 경우 ASC를 생략해도 됨  */
    
-- 사원들의 사원 이름, 급여, 부서번호 를 조회하시오.
-- 부서번호 기준 오름차순, 같은 부서의 경우 급여 내림차순 정렬로 조회하시오.
SELECT
    ename "사원 이름", sal 급여, deptno "부서 번호"
FROM
    emp
ORDER BY
    deptno, sal DESC;
/* 전술된 절들의 실행 결과를 갖고 정렬하기 때문에
    ORDER BY 절은 다른 절들 이후에 기술되어야 한다. */
    
/*
    문자열의 길이를 알려주는 함수
        LENGTH()    : 문자열의 문자열 수를 반환해주는 함수  */
        
-- 사원 이름, 직급, 급여를 조회하시오.
-- (단, 이름 길이가 짧은 사람이 먼저 출력되게 하고, 같은 길이면 알파벳 오름차순 정렬)
SELECT
    ename "사원 이름", job 직급, sal 급여
FROM
    emp
ORDER BY
    LENGTH(ename), ename;
    
-- LENGTH는 문자 수를 반환한다. LENGTHB는 바이트 수!
SELECT
    LENGTH('동혀기') 문자수, LENGTHB('런지니') 바이트수
FROM
    dual;

--------------------------------------------------------------------------------
/*
    집합 연산자
    ==> 두 개 이상의 SELECT 질의 명령을 이용해
        그 결과의 집합을 얻어내는 방법
        
        SELECT . . . 집합연산자 SELECT . . . ;
        
    종류
        UNION
        ==> 합집합 개념
            두 가지 질의 명령의 결과를 하나로 합쳐 조회.
        UNION ALL
        ==> UNION과 달리 중복 데이터여도 그대로 출력함.
        
        INTERSECT
        ==> 교집합 개념
            조회 질의명령의 결과 중, 양쪽 모두 존재하는 결과만 출력
        
        MINUS
        ==> 차지합 개념.
            앞 질의 명령 결과 - 뒤 질의 명령 결과
            를 출력해줌!
            
      + 공통적인 특징
        (0. 잘 안쓴다...)
        1. 두 질의 명령에서 나온 결과는 같은 field의 개수를 가져야 함.
        2. 두 질의 명령의 결과는 같은 형태(타입)의 필드면 된다.  */

SELECT
    ename "사원 이름", sal 급여  -- 필드 이름은 이걸 따라감.
FROM
    emp
UNION
SELECT
    job 직급, comm 커미션
FROM
    emp;

--------------------------------------------------------------------------------
/*
    함수 (Function, java처럼 Method라 부르지 않음!)
    ==> 데이터를 가공하기 위해 oracle이 제시한 명령 또는 개체...
    
      + DBMS는 DB 밴더들마다 다르다.
        그런데 함수 부분은 DBMS들마다 매우 다르다.
        
    oracle 함수 종류
        1. 단일행 함수
            ==> 한줄 한줄마다 매번 명령이 실행되는 함수
                단일행 함수의 결과는 출력되는 데이터의 개수와 동일하다.
            
        2. 그룹 함수
            ==> 여러 행이 모여 한 번만 실행되는 함수
                그룹 함수는 출력 개수가 오직 한개다.
                집계 함수들이 그룹 함수에 해당된다.
                max(), min(), sum(), ave(), count() 등...
                (count : 개수)
                
*****   단일행 함수, 일반 필드와 그룹함수는 절대 같이 사용할 수 없다!

*/

-- 사원들의 사원 이름, 이름의 문자수 F를 조회하시오.
SELECT
    ename "사원 이름", LENGTH(ename) "이름 문자수"
FROM
    emp;
    
-- 10번 부서의 사원들의 사원 수를 조회하시오.
SELECT
    count(*) "사원 수"
FROM
    emp
WHERE
    deptno=10;
    
-- 커미션이 없는 사원들의 수를 조회하시오.
SELECT
    count(*) "커미션 없는 사원 수"
FROM
    emp
WHERE
    comm IS NULL;
    
-- null 데이터는 모든 연산에서 제외된다.
-- 따라서 함수에서도 제외된다.
SELECT
    (count(*)-count(comm)) "커미션 없는 사원 수"
FROM
    emp;
    
--------------------------------------------------------------------------------
/*
    단일행 함수 : 데이터 타입 함수
    
    *** 숫자 <->  문자  <-> 날짜  (숫자<->날짜 직통은 불가능!)
        1. 숫자 함수
            ==> 데이터가 숫자인 경우에만 사용 가능.
                자릿수가 음수일 경우->소수점 위 자릿수.
                
                1) ABS()    : 절대값 도출
                ==> ABS(데이터 or 필드 or 연산식)   */
SELECT ABS(-3.14) pi FROM dual;

/*              2) ROUND()  : 지정 자릿수에서 반올림 해줌
                ==> ROUND(데이터 or 필드 or 연산식[, 자릿수])
                    생략시 소수 첫째자리에서 반올림
                    
                3) FLOOR()  : 소수점 이하 무조건 버림 해줌
                ==> FLOOR(데이터 or 필드 or 연산식)
                
                4) TRUNC()  : 지정 자릿수 이하 버림
                ==> TRUNC(데이터[, 자릿수])   */
SELECT TRUNC(3.14) FROM dual;

-- 15% 인상된 사원들의 급여를 조회하시오.
SELECT
    ename "사원 이름", sal 원급여, sal*1.15 계산값, ROUND(sal*1.15) "인상 급여",
    FLOOR(sal*1.15) 버림함수, TRUNC(sal*1.15, -1) "자릿수 지정 버림"
FROM
    emp;
    
--              5) MOD()    : 나머지 도출 (java의 %)
--              ==> MOD(데이터, 나눌숫자)
SELECT MOD(10,3) "10을 3으로 나눈 나머지" FROM dual;

-- 급여가 짝수인 사원만 출력하시오.
SELECT
    ename "사원 이름", job 직급, sal 급여
FROM
    emp
WHERE
    MOD(sal, 2)=0;

/*      2. 문자 함수
            
            대/소문자 관련 함수
            1) LOWER()
            2) UPPER()
            3) INITCAP()    */
SELECT
    LOWER(ename) "소문자 이름", UPPER(LOWER(ename)) "대문자 이름",
    INITCAP(ename) "첫 글자만 대문자"
FROM
    emp;

SELECT INITCAP('yes dr are gay') FROM dual;

/*          4) LENGTH() / LENGTHB()
            ==> LENGTH(문자열데이터)
            
            LENGTH는 문자수, LENGTHB는 바이트 수 반환
            
            5) CONCAT() : 결합연산자 ||와 같은 기능.
            ==> CONCAT(데이터1, 데이터2)
            
사원들의 이름, 직급, 급여를 조회하시오.
(출력 형식 : Mr.이름  직급 직급  급여$)    */
SELECT
    CONCAT('Mr.',ename) "사원 이름", CONCAT(job, ' 직급'), CONCAT(sal, '$') 급여
FROM
    emp;
            
/*          6) SUBSTR() / SUBSTRB() : 문자열 중, 특정 위치의 문자열만 추출해 반환.
            ==> SUBSTR(데이터, 시작위치[, 꺼낼 개수])  개수 미기입시 끝까지 추출
                        
              ※ DB에서의 index는 1부터 시작한다. 모두!! 반드시!!
                시작 위치가 음수일 경우, 문자열의 끝에서 부터 센다.
                B함수의 경우는 index 단위가 글자수가 아닌 바이트 수!   */

SELECT SUBSTR('Hello World!', 1, 5) "문자열 추출" FROM dual;

SELECT SUBSTR('Hello World!', -6, 6) "문자열 추출" FROM dual;

/*          7) INSTR() / INSTRB() : 문자열 중 원하는 문자열의 index 도출
            ==> INSTR(데이터1, 데이터2[,시작위치[, 출현 순서])    */
SELECT INSTR ('foxy boy renjun', 'y', 2, 2) FROM dual;

/*          8) LPAD() / RPAD() : 문자열의 길이를 지정한 후, 문자열을 만든다.
                                 남는 공간은 지정한 문자로 채움.
                                 (L/R은 지정한 문자를 채우는 방향)

            ==> LPAD(데이터, 만들길이, 채울문자)   */

-- 사원 이름을 10글자로 만들어 조회하시오.
SELECT
    LPAD(ename, 10, '*') "오른쪽 정렬", RPAD(ename, 10, '*') "왼쪽 정렬"
FROM
    emp;
    
-- 사원들의 이름 앞 두글자만 표시하고, 나머지는 *로 표시하시오.
SELECT
    RPAD(SUBSTR(ename, 1, 2), LENGTH(ename), '*') "꺼내 온 이름",
    ename "원래 이름"
FROM
    emp;
    
--------------------------------------------------------------------------------
-- 문제 나갑니다!
/*
문제 1.
    사원 이름이 5글자 이하인 사원들의
         사번, 사원 이름, 이름의 글자 수, 직급, 급여 를 조회하시오.
         
    글자수가 작은 사원의 이름 순으로 정렬하여 조회하시오.  */
SELECT
    empno 사번, ename "사원 이름", LENGTH(ename) "이름 글자수", job 직급, sal 급여
FROM
    emp
ORDER BY
    LENGTH(ename);
/*
문제 2.
    사원 이름 앞에 '사원'을 붙여
        사원 이름, 직급, 입사일 을 조회하시오. */
SELECT
    CONCAT('사원 ', ename) "사원 이름", job 직급, hiredate 입사일
FROM
    emp;
/*
문제 3.
    사원이름의 마지막 글자가 'N'인 사원들의
        사원 이름, 입사일, 부서번호를 조회하시오.
        
    부서 번호 순으로 정렬하고, 같은 부서는 이름 순으로 정렬 해 조회하시오.   */
SELECT
    ename "사원 이름", hiredate 입사일, deptno "부서 번호"
FROM
    emp
ORDER BY
    deptno, ename;
/*
문제 4.
    사원이름 중 'a'가 존재하지 않는 사원의 정보를 조회하시오.  */
SELECT
    empno 사번, ename "사원 이름", job 직급
FROM
    emp 
WHERE
    INSTR(ename, 'A')=0;
/*
문제 5.
    사원 이름 중, 뒤 2글자만 남기고
    앞글자는 모두 '#'로 대체하여
        사원 이름, 입사일, 급여를 조회하시오.  */
SELECT
    LPAD(SUBSTR(ename, -2), LENGTH(ename), '#') "사원 이름",
    hiredate 입사일, sal 급여
FROM
    emp;
/*
문제 6.
    'renjun@7dream.com' 이라는 메일에서
    ID부분은 세 번째 문자를 제외한 나머지 문자는 '*' 표시하고,
    @ 이후는 @와 .com 외의 부분은 '*' 로 표시해 조회하는 질의 명령을 작성하시오.  */
SELECT
    CONCAT(CONCAT(LPAD(SUBSTR('renjun@7dream.com',3,1),3,'*'),
    
    LPAD(SUBSTR('renjun@7dream.com', INSTR('renjun@7dream.com','@'), 1),
    LENGTH(SUBSTR('renjun@7dream.com', 4, INSTR('renjun@7dream.com','@')-3)), '*')),
    
    LPAD(SUBSTR('renjun@7dream.com', -4, 4),
    (LENGTH('renjun@7dream.com')-INSTR('renjun@7dream.com','@')), '*'))
    
FROM
    dual;

-- 쌤 풀이
SELECT
    CONCAT(CONCAT(RPAD(LPAD(SUBSTR('jennie@githrd.com', 3, 1), 3, '*'),
    INSTR('jennie@githrd.com', '@')-1, '*'), '@'),
    LPAD(
        SUBSTR('jennie@githrd.com', INSTR('jennie@githrd.com','.com')),
        LENGTH('jennie@githrd.com')-(INSTR('jennie@githrd.com','@')-1), '*')
    ) "제니 메일"
FROM
    dual;

/*      3. 날짜 함수
        
        + 사실 데이터 타입이 이 세가지 뿐인건 아니다...!
          CLOB  : 문자 데이터를 4GB까지 저장할 수 있는 타입
          BLOB  : 바이너리 코드를 4GB까지 저장할 수 있는 타입
          
          + 문자열 데이터타입의 최대 크기는 4KB이다.
*/