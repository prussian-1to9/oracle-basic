/*
    java 주석 처리 부분. //와 /** 주석은 인식 불가능함~
    
    sql developer에서만 가능한 주석이당.
    
    -------------------------------------
    질의 명령?
    
    Database 관리 시스템에게 해당 데이터가 어디있는지 문의를 한다.
    -> ㄹㅇ 질의+명령
    -------------------------------------
    SQL : Structed Qurey Language
        구조화된 쿼리 언어라는 기다.
        
        이미 Structed. 구조화 되어있고
        명령을 사용해 데이터를 조작하다.
        새로운 프로그램 생성이 안되고, 있는 명령을 활용해야 함.
        
       ~명령 종류~
        1. DML 명령 (Data Maniqulation Language)
        ==> 데이터를 추가/수정/변경/조회 (데이터가 아닌, 다른건 조작하지 못함)
        
        -데이터를 조작하는 방법-
            의미      명령
            C reate : INSERT
            R ead   : SELECT
            U pload : UPDATE
            D elete : DELECT
        
        2. DDL 명령 (Data Definition Language
        ==> 개체를 만들고 수정
            (개체 : oracle에 등록 가능한 테이블, 사용자, 함수, 인덱스 등...)
        
            CREATE  : 개체 생성
            ALTER   : 개체 수정
            DROP    : 개체 삭제
            TRUNCATE: 테이블 자르기 (테이블의 데이터만 잘라서 버림)
        
        3. DCL 명령 (Data Control Language)
        ==> 작업을 적용시킨다든지 (TCL명령, Transaction Control Language)
            권한을 준다든지!

       *****COMMIT  
       *****ROLLBACK
            
            GRANT  
            REVOKE  

*/
-- 오라클 주석 == 얘는 어디든지 사용 가능.

select*from emp;

select
    empno, ename, job,mgr, hiredate, sal, comm, dname, loc -- select절
from
    emp e, dept d -- from절
where
    d.deptno=e.deptno; -- where절, 또는 조건절.
    
-- oracle의 명령은 java와 마찬가지로 명령 끝에 ;를 사용한다.

-- 맨 마지막에 오는 명령의 경우, ; 없이도 명령이 되지만, 웬만하면 해주는게 좋다.

select*from emp;
select*from dept;

-------------------------------------------------------------------------------
/*
    테이블 구조를 조회해보는 명령
    형식
        describe 테이블이름;
        desc 테이블이름;         밑에건 축약형임!
*/

-- emp 테이블의 구조를 조회해 봅시다.
describe emp;
desc emp;
/*
    오라클의 데이터 타입
        NUMBER, NUMBER(숫자) -> 숫자를 기입하면, 그 자릿수만큼 사용 가능
        NUMBER(유효자릿수, 소수 이하 자릿수)
        
        CHAR -> 고정 문자수 문자열 데이터타입
        ==> CHAR(숫자) -> 바이트 수 만큼 문자 기억
            CHAR(숫자 CHAR) -> 숫자 개수만큼의 문자 기억
            
        VARCHAR2 (1도 있는데 잘 안씀) -> 가변 문자수 문자열 데이터 타입
        ==> VARCHAR2(숫자), VARCHAR2(숫자 CHAR)
            모두 CHAR와 작동방식 동일.
            
        ex.
            CHAR(10)
            ==> 'A'입력 ==> 10byte 모두 사용
            VARCHAR2(10)
            ==> 'A'입력 ==> 1byte만 사용
            
        DATE (따로 크기 기입 안해줘도 OK)
*/
--------------------------------------------------------------------------------
/*
    데이터 조회 명령
    
    SELECT
        컬럼이름들...    (콤마 단위)
    FROM
        테이블이름들...   (콤마 단위)
    [WHERE
                ]
    [GROUP BY
                ]
    [HAVING
                ]
    [ORDER BY
                ];
*/

-- 부서 정보 테이블의 정보를 조회하세요.
SELECT
    deptno, dname, loc
FROM
    dept;


-- 1+4의 결과를 조회하시오.

select 1+4 from emp;
-- emp table의 row가 14개이므로 14줄이 뜬다.

select '이지쨩' from emp;  -- oracle에선 문자와 문자열을 구분하지 않는다.

/* oracle에서 table 이름이나 컬럼이름, 연산자, , 명령어, 함수이름들은
    대소문자를 구분하지 않는다.
    
    ※ 하지만 데이터 자체는 대/소문자 구분이 필요!!!   */
    
-- 조건 검색
/*
    SELECT
        컬럼이름
    FROM
        테이블이름
    WHERE
        조건
        
    조건 비교 : 비교연산자 사용.
    (java와 다른 것만 기술하였음)
    
         =  같다
        <>  다르다 (!= 와 동일)
        
    java와 마찬가지로, 동시에 크기를 비교할 수 없다.
    
    + oracle은 데이터의 형태를 매우 중요시 한다.
      원칙적으로 같은 형태끼리만 비교가 가능한데,
      날짜는 예외다!!
      
      날짜데이터-문자데이터의 비교가 아니라
      날짜데이터로 변환된 문자데이터-날짜데이터 의 비교만 가능하다.
      
    + oracle에서 문자의 크기비교 : ascii코드값으로 됨
    
    + oracle은 문자와 문자열의 구분이 없는 대신,
      문자열 데이터의 대소문자는 구분해 처리해야 함
      
    + 조건을 비교하는 방법
      oracle이 한 줄을 출력할 때 마다
      그 행이 조건에 맞는지 확인한 후
      조건에 부합하면 출력한다.
      
    + 조건절의 조건이 여러개일 경우
      AND, OR 연산자를 이용해 나열한다.
*/

--사원 이름이 smith인 사원의 급여 검색
SELECT
    sal
FROM
    emp
WHERE
--  ename='smith'; 소문자이기 때문에 안됨.
    ename='SMITH';
    
-- 사원 중 직급이 manager이고, 부서번호가 10번인 사원의 이름을 조회하시오.
SELECT
    ename
FROM
    emp
WHERE
    job='MANAGER'
    AND deptno=10;  -- 맨 위의 조건을 가장 많이 거르는 것으로 하는게 좋다.

--------------------------------------------------------------------------------
/*
    문제를 냅니다이.
    
    empno       : 사원 번호
    ename       : 이름
    job         : 직급
    mgr         : 상사 번호
    hiredate    : 입사일
    sal         : 급여
    comm        : 커미션
    deptno      : 부서 번호

/*
    사원 이름이 smith인 사원의
        이름, 직급, 입사일 을 조회하시오. */

SELECT
    ename, job, hiredate
FROM
    emp
WHERE
    ename='SMITH';

/*
    직급이 manager인 상원의
        이름, 직급, 급여 를 조회하시오. */

SELECT
    ename, job, sal
FROM
    emp
WHERE
    job='MANAGER';
    
/*
    급여가 1500을 넘는 사원들의
        이름, 직급, 급여율 을 조회하시오 */

SELECT
    ename, job, sal
FROM
    emp
WHERE
    sal>1500;
    
/*
    이름이 's'이후의 문자로 시작하는 사원들의
        이름, 직급, 급여 를 조회하시오  */
        
SELECT
    ename, job, sal
FROM
    emp
WHERE
    ename>'S';
    
/*
    입사일이 81년 8월 이전에 입사한 사원들의
        이름, 입사일, 급여를 조회하시오. */
    
SELECT
    ename, hiredate, sal
FROM
    emp
WHERE
    hiredate < '81/08/01';

-- 부서 번호가 10번 또는 30번인 사원의 이름, 직급, 부서번호를 조회하시오
SELECT
    ename, job, deptno
FROM
    emp
WHERE
--  deptno=10 OR deptno=30;
    deptno IN(10, 30);-- 일케 쓸수도 있대.
    
/*
    NOT 연산자
    ==> 조건식의 결과 부정
    
        NOT 조건식     */
        
--부서번호가 10번이 아닌 사원들의 이름, 직급, 부서 번호를 조회하시오.
SELECT
    ename, job, deptno
FROM
    emp
WHERE
--  NOT deptno=10;
--  deptno!=10;
    deptno<>10;
--------------------------------------------------------------------------------
/*
    5.
        급여가 1000~3000인 사원들의
            이름, 직급, 급여 를 조회하시오. */
SELECT
    ename, job, sal
FROM
    emp
WHERE
    sal<=3000 AND sal>=1000;
    
/*
    6.
        직급이 manager 이면서 급여가 1000이상인 사원들의
            이름, 직급, 입사일, 급여 를 조회하시오.    */
SELECT
    ename, job, hiredate, sal
FROM
    emp
WHERE
    job='MANAGER'
    AND sal>=1000;
--------------------------------------------------------------------------------
/*
    특별한 조건 연산자
    
    1. BETWEEN ~ AND
    ==> 데이터가 특정 범위 안에 있는지 확인
        형식
            컬럼이름 BETWEEN 데이터1 AND 데이터2
            
        ※ 값이 작은 데이터가 데이터1에 와야 한다.
          부정이 필요한 경우 BETWEEN 앞에 NOT을 붙인다.
        
        ex.
            급여가 1000~3000인 사원들의
            이름, 급여를 조회하시오.  */
SELECT
    ename, sal
FROM
    emp
WHERE
    sal BETWEEN 1000 AND 3000;
    
/*  2. IN
    ==> 데이터가 주어진 데이터들 중 하나인지 확인
    형식
        필드 IN(데이터1, 데이터2 ...)
    
    ※ NOT이 필요할 경우, IN 앞에 붙인다.
        
    ex 1.
        부서 번호가 10, 30번인 사원들의
            이름, 직급, 부서 번호를 조회하시오.   */
SELECT
    ename, job, deptno
FROM
    emp
WHERE
    deptno IN (10, 30);
    
/*
    직급이 manager, salesman이 아닌 사원들의
        이름, 직급, 급여 를 조회하시오. */
SELECT
    ename, job, sal
FROM
    emp
WHERE
    job NOT IN ('MANAGER', 'SALESMAN');

/*
    3. LIKE
    ==> 문자열을 처리하는 경우에만 사용.
        문자열의 일부분을 와일드 카드 처리하여 조건식을 제시
        형식
            필드 LIKE '와일드 카드'
        
        의미 : 데이터가 지정한 문자열 형식과 동일한지 판단.
        
       ~와일드 카드 사용법~
        
        _   : 한 개당 한글자만을 와일드카드로 지정
        %   : 글자 수 무관, 모든 문자 포함하는 와일드카드
        
        ex.
            'M%'    : M으로 시작하는 모든 문자열
            'M__'   : M으로 시작하는 3글자 문자열
            '%M%'   : M이 포함된 모든 문자열
            '%M'    : M으로 끝나는 모든 문자열
*/
--------------------------------------------------------------------------------
-- LIKE
/*
    이름이 5글자인 사원들의
        이름, 직급 을 조회하시오. */
SELECT
    ename, job
FROM
    emp
WHERE
    ename LIKE '_____';
    
/*
    입사일이 1월인 사원들의
        이름, 입사일 을 조회하시오  */
SELECT
    ename, hiredate
FROM
    emp
WHERE
    hiredate LIKE '__/01/__';
/* 정확하게는
    TO_CHAR(hiredate, 'YY/MM/DD') LIKE '__/01/__';  래유. */
--------------------------------------------------------------------------------
/*
    조회되는 칼럽에 별칭도 만들 수 있다!
    
    형식
        칼럼이름 별칭
        칼럼이름 AS 별칭
        
    ※ 별칭에 공백이 포함된 경우, 별칭에 ""을 꼭 써주어야 한다.
*/    
--------------------------------------------------------------------------------
--문제 갑니데이~
/*
    1.
        부서번호가 10번인 사원들의
            이름, 직급, 입사일, 부서번호 를 조회하시오.  */
SELECT
    ename "사원 이름", job 직급, hiredate, deptno "부서 번호"
FROM
    emp
WHERE
    deptno=10;

/*
    2.
        직급이 salesman인 사원들의
            이름, 직급, 급여 를 조회하시오.
            단, 필드 이름은 제시한 이름으로 조회하게 하세요.    */
SELECT
    ename "사원 이름", job 직급, sal 급여
FROM
    emp
WHERE
    job='SALESMAN';
    
/*
    3.
        급여가 1000보다 적은 사원들의
            이름, 직급, 급여를 조회하세요 (별칭 붙여서)  */
SELECT
    ename "사원 이름", job 직급, sal 급여
FROM
    emp
WHERE
    sal<1000;
/*
    4.
        사원 이름이 'M'이전의 문자로 시작하는 사원들의
            이름, 직급, 급여 를 조회하시오. (별칭 붙여서)    */
SELECT
    ename "사원 이름", job 직급, sal 급여
FROM
    emp
WHERE
    ename<='M';
/*
    5.
        입사일이 81년 9월 8일 입사한 사원의
            이름, 직급, 입사일 을 조회하시오. (별칭 붙여서)    */
SELECT
    ename "사원 이름", job 직급, hiredate 입사일
FROM
    emp
WHERE
    hiredate='81/09/08';
/*
    6.
        사원 이름이 'M'이후 문자로 시작하는 사원 중
        급여가 1000 이상인 사원의
            이름, 급여, 직급을 조회하시오.  (별칭 붙여서)    */
SELECT
    ename "사원 이름", sal 급여, job 직급
FROM
    emp
WHERE
    ename>='M';
/*
    7.
        직급이 manager이며 급여가 1000보다 크고
        부서번호가 10번인 사원의
            이름, 직급, 급여, 부서번호를 조회하시오. (별칭 붙여서)   */
SELECT
    ename "사원 이름", job 직급, sal 급여, deptno "부서 번호"
FROM
    emp
WHERE
    job='MANAGER'
    AND sal>1000;
/*
    8.
        직급이 manager인 사원을 제외한 사원들의
            이름, 직급, 입사일 을 조회하시오.
        (단, NOT 연산자를 사용할 것, 별칭을 붙일 것.)  */
SELECT
    ename "사원 이름", job 직급, hiredate 입사일
FROM
    emp
WHERE
    NOT job='MANAGER';
/*
    9.
        사원이름이 'C'로 시작하는 것보다 크고
        'M'으로 시작하는것 보다 작은 사원만
            이름, 직급, 급여 를 조회하시오
        (단, BETWEEN 연산자를 사용하며, 별칭을 붙일 것)    */
SELECT
    ename "사원 이름", job 직급, sal 급여
FROM
    emp
WHERE
    ename BETWEEN 'C' AND 'M';
/*
    10.
        급여가 800, 950이 아닌 사원들의
            이름, 직급, 급여를 조회하시오.
        (단, IN 연산자를 사용하며, 별칭을 붙일 것) */
SELECT
    ename "사원 이름", job 직급, sal 급여
FROM
    emp
WHERE
    sal NOT IN (800, 950);
/*
    11.
        사원 이름이 'S'로 시작하고, 5글자인 사원들의
            이름, 직급, 급여 를 조회하시오. (별칭 사용)  */
SELECT
    ename "사원 이름", job 직급, sal 급여
FROM
    emp
WHERE
    ename LIKE 'S____';
/*
    12.
        입사일이 3일인 사원들의
            이름, 직급, 입사일 을 조회하시오. (별칭 사용)    */
SELECT
    ename "사원 이름", job 직급, hiredate 입사일
FROM
    emp
WHERE
    hiredate LIKE '__/__/03';
/*
    13.
        사원 이름의 글자수가 4글자이거나 5글자인 사원들의
            이름, 직급을 조회하시오. (별칭 사용)   */
SELECT
    ename "사원 이름", job 직급
FROM
    emp
WHERE
    ename LIKE '____'
    OR ename LIKE'_____';
/*
    14.
        입사년도가 81년도이거나 82년도인 사원들의
            이름, 급여, 입사일 을 조회하시오. (별칭 사용) */
SELECT
    ename "사원 이름", sal 급여, hiredate 입사일
FROM
    emp
WHERE
    hiredate LIKE '81/__/__'
    OR hiredate LIKE '82/__/__';
/*
    15.
        사원 이름이 'S'로 끝나는 사원의
            이름, 급여, 커미션 을 조회하시오. (별칭 사용) */
SELECT
    ename "사원 이름", sal 급여, COMM 커미션
FROM
    emp
WHERE
    ename LIKE '%S';
