/* 
    HAVING 절 review
    ==> 그룹화한 결과를 필터링. WHERE 절과 달리, 그룹함수가 사용 가능하다.
    
    오늘 배울것은...
    관계형 데이터의 꽃,,,
    
    JOIN
    ==> Relation DataBase Managment System에선 데이터의 중복을 피하기 위해
        테이블을 분리하고, 관계를 형성한다.
        
        분리된 테이블에서 데이터를 추출할 때 사용하는 문법이 JOIN이다.
        
      + oracle 역시 ER형태의 DB이다.
      -> ER : Entity-Relationship. 엔티티(데이터)들 끼리의 관계이다.
                이런 관계로 테이블을 관리하는 DB를 관계형 DB라고 한다.
                
      + 관계형 DB에서 여러개의 테이블에서 동시 검색하는 기능이 이미 있다.
      ==> 하지만 동시 검색을 하면, Cartesian Product(cross join)가 만들어지는데,
        이 결과에 정확하지 않은 정보가 포함되어있다.
        이것을 필터링하는 작업이 JOIN.4
        
        
        종류
        Inner Join
        ==> 나열된 테이블들의 결과집합 안에서 꺼내오는 join
        
            ㄴEqui Join : 동등비교 연산자로 join 하는 경우
            ㄴNon Equi Join : 동등비교 연산자 외의 연산자로 join 하는 경우
        
        Outer Join
        ==> Catesian Product 에 포함되지 않는 데이터를 가져오는 join
            형식)
                테이블이름.필드이름=테이블이름.필드이름(+)
                
                (+)는 NULL 로 표현되어야 할 테이블에 붙여준다.
        Self Join
        ==> join을 하는데 대상테이블이 같은 테이블을 사용하는 join
*/

-- 일단 쌤을 따라해 보아용.
-- 영문색상이름 테이블
DROP TABLE ecolor;
CREATE TABLE ecolor (
    ceno NUMBER(3) -- 영문 color 일련번호
        CONSTRAINT ECLR_NO_PK PRIMARY KEY, -- key 설정
    code VARCHAR2(7) -- color 코드 값
        CONSTRAINT ECLR_CODE_UK UNIQUE -- 이런것들은 oracle의 객체로 등록됨
        CONSTRAINT ECLR_CODE_NN NOT NULL,
    name VARCHAR2(20)
        CONSTRAINT ECLR_NAME_NN NOT NULL
);

-- 데이터 추가
INSERT INTO
    ecolor
VALUES(
    100, '#FF0000', 'red'
);

INSERT INTO
    ecolor
VALUES(
    101, '#00FF00', 'green'
);

INSERT INTO
    ecolor
VALUES(
    102, '#0000FF', 'blue'
);

INSERT INTO
    ecolor
VALUES(
    103, '#800080', 'purple'
);

-- 영문 color 테이블 조회
SELECT * FROM ecolor;
COMMIT; -- 메모리의 작업 영역에서 작업한 내용을 DB에 적용.

-- 한글 color 테이블 생성
CREATE TABLE kcolor (
    ckno NUMBER(3) -- 세 자리 숫자
        CONSTRAINT KCLR_NO_PK PRIMARY KEY,
    code VARCHAR2(7)
        CONSTRAINT KCLR_CODE_UK UNIQUE
        CONSTRAINT KLCR_CODE_NN NOT NULL,
    name VARCHAR2(20)
        CONSTRAINT KCLR_NAME_NN NOT NULL
);

-- 데이터 추가
INSERT INTO
    kcolor
VALUES(
    100, '#FF0000', '빨강'
);

INSERT INTO
    kcolor
VALUES(
    101, '#00FF00', '초록'
);

INSERT INTO
    kcolor
VALUES(
    102, '#0000FF', '파랑'
);

-- 데이터 조회
SELECT * FROM kcolor;

-- 두개를 이어서 추출하려면..
SELECT * FROM ecolor, kcolor; -- 정확하지 않은 데이터가 3분의 2다!!

-- INNER JOIN을 이용
SELECT
    ceno cno, e.code, e.name ename, k.name kname
FROM
    ecolor e, kcolor k  -- 별칭 구분해주기.
WHERE
    e.code=k.code -- JOIN 조건
;

-- OUTER JOIN을 이용
SELECT
    ceno cno, e.code, e.name ename, k.name kname
FROM
    ecolor e, kcolor k
WHERE
    e.code=k.code(+)
;

-- SELF JOIN을 이용
-- 사원들의 사원 이름, 상사의 사번, 상사 이름, 상사 급여를 조회하시오.
SELECT
    e.ename "사원 이름", e.deptno "상사 사번",
    s.ename "상사 이름", e.sal "상사 급여"
FROM
    emp e, sangsa s
WHERE
    s.empno(+)=e.mgr    -- outer join 혼용
;

CREATE table sangsa
as
    select * from emp;
    
-- 사원들의 사원 이름, 직급, 급여, 급여 등급을 조회하시오.
SELECT
    ename "사원 이름", job 직급, sal 급여, grade "급여 등급"
FROM
    emp, salgrade -- 이름이 겹치는 column이 없기 때문에 별칭 사용X
WHERE
    sal BETWEEN losal AND hisal; -- NON EQUI JOIN
    
-- 응용 ) 사원들의 사번, 사원 이름, 직급, 부서 이름, 부서 위치를 조회하시오.
SELECT
    empno 사번, ename "사원 이름", job 직급, dname "부서 이름", loc "부서 위치"
FROM
    emp e, dept d
WHERE
    e.deptno=d.deptno;
    
/* 81년도 입사한 사원의
    사원 이름, 직급, 입사일, 부서이름을 조회하시오.    */
SELECT
    ename "사원 이름", job 직급,
    TO_CHAR(hiredate, 'YYYY"년"MM"월"DD"일"') 입사일, dname "부서 이름"
FROM
    emp, dept
WHERE
    emp.deptno=dept.deptno  -- join 조건
    AND TO_CHAR(hiredate, 'YY')='81'    -- 일반 조건
;
--------------------------------------------------------------------------------
/*
    ANSI JOIN
    ==> oracle에선 자체적인 질의 명령(+ join)이 존재하는데, 타 DB와는 호환이 안됨.
        그래서 제시한 것이
        
        ANSI 형식
        미국 국립 표준협회 ANSI에서 공통의 질의 명령을 만들었다.
        따라서 DBMS를 가리지 않고 실행이 가능하다.
        
--------------------------------------------------------------------------------
    1. Cross Join
    ==> oracle의 cartesion product 를 생성하는 join
    
        SELECT
            필드 이름, . . .
        FROM
            테이블1 CROSS JOIN 테이블2;
        
    2. Inner Join
    ==> Equi Join,Non Equi Join, Self Join
    
        SELECT
            필드 이름, . . .
        FROM
            테이블1 [INNER] JOIN 테이블2
        ON
            join조건
        [WHERE
            일반조건]
            
        + inner join이 가장 일반적이기 때문에 inner 라는 구문을 생략해도 된다.
        -> 자동으로 inner join으로 처리
            
    3. Outer Join
    ==> cartesion product에 없는 결과를 조회하는 join
    
        SELECT
            필드 이름, . . .
        FROM
            테이블1 LEFT [또는 RIGHT 또는 FULL] OUTER JOIN 테이블2
        OM
            join조건
            
        방향은 null 로 표현되지 않은 데이터가 있는 쪽 테이블이다.
        
      + join이 중첩되는 경우도 있다.
      
        SELECT
            필드 이름, . . .
        FROM
            테이블1 JOIN 테이블2
        ON
            join조건1
        JOIN
            테이블3
        ON
            join조건2;
*/

-- ANSI JOIN --
-- Cross Join : 사원 정보와 부서정보를 cross join 하시오.
SELECT
    *
FROM
    emp CROSS JOIN dept;
    
-- INNER JOIN --
-- 사원들의 이름, 직급, 부서번호, 부서 이름을 조회하시오.
SELECT
    ename "사원 이름", job 직급, e.deptno "부서 번호", dname "부서 이름"
FROM
    emp e INNER JOIN dept d
ON -- join 조건절
    e.deptno=d.deptno;
    
-- 81년 입사한 사원들의 이름, 직급, 입사년도, 부서 이름을 조회하시오.
SELECT
    ename "사원 이름", job 직급, TO_CHAR(hiredate, 'YY') "입사 년도",
    dname "부서 이름"
FROM
    emp e INNER JOIN dept d
ON -- join 조건
    e.deptno=d.deptno
WHERE -- 일반 조건
    TO_CHAR(hiredate, 'YY')=81;
    
-- 사원들의 사원 이름, 상사 이름을 조회하시오.
SELECT
    e.ename "사원 이름", s.ename "상사 이름"
FROM
    emp e INNER jOIN emp s
ON
    e.mgr=s.empno; -- 상사가 없는 king 은 출력되지 않는다. (null 값)
    
-- OUTER JOIN --
-- 사원들의 사원 이름, 상사 이름을 조회하시오.
SELECT
    e.ename "사원 이름", NVL(s.ename, '상사 없음') "상사 이름"
FROM
    emp e LEFT OUTER JOIN emp s -- 방향은 데이터의 기준을 의미함.
ON
    e.mgr=s.empno; -- 상사가 없는 king 도 출력된다 (null 값이여도 출력된다.)
    
-- 사원들의 사원 이름, 부서이름, 급여, 급여 등급을 조회하시오.
SELECT
    ename "사원 이름", dname "부서 이름" , sal 급여, grade "급여 등급"
FROM
    emp e JOIN dept d
ON
    e.deptno=d.deptno
    
    JOIN
        salgrade
    ON
        e.sal BETWEEN losal AND hisal
;

--------------------------------------------------------------------------------
/*
    NATURAL JOIN
    ==> 자동 join
        반드시 조인 조건식에 사용하는 필드 이름이 동일하고
        동일한 필드가 한개 일 때 사용할 수 있는 join (ANSI join의 문법이다.)
        
        자동으로 중복되는 필드를 인식해, 그 필드를 기준으로 join 시켜준다.
        
        SELECT
            필드 이름, . . .
        FROM
            테이블1 NATURAL JOIN 테이블2;
            
    USING JOIN
    ==> natural join과 마찬가지로, 동명의 필드가 있어야 하며,
        그것을 기준으로 join 시켜준다.
        
        같은 이름의 필드가 여러개 존재해도 무방하다.
        USING 구절을 이용해 기준이 될 필드를 지정해 줄 수 있다.
        
        SELECT
            필드 이름, . . .
        FROM
            테이블1 JOIN 테이블2
        USING
            (join에 사용할 필드이름);
*/

-- 사원들의 사원 이름, 부서 이름을 조회하시오.
SELECT
    ename "사원 이름", dname "부서 이름"
FROM
    emp NATURAL JOIN dept
;

CREATE TABLE tmp
AS
    SELECT
        e.*, dname
    FROM
        emp e, dept d
    WHERE
        e.deptno = d.deptno
;

-- TMP 테이블과  부서정보테이블을 이용해서 
-- 사원들의 사원이름, 부서위치를 조회하세요.
SELECT
    ename, loc
FROM
    tmp
JOIN
    dept
USING
    (deptno);
    
--------------------------------------------------------------------------------
/*
    부 질의 (付 질의, SUB QUERY)
    ==> 질의명령 안에 다시 질의명령을 포함하는 경우
        포함되는 그 질의 명령을 서브질의, 혹은 서브 쿼리라고 함.
        
        ex.
            이름이 SMITH인 사원과 같은 부서에 있는 사원들의 정보 조회.
            ==> 1. SMITH의 부서번호 알아 내는 질의 명령
                2. 해당 부서번호를 이용, 정보 조회
                
        + 서브 쿼리를 감싸는 질의 명령을 메인 질의 명령이라고 함.  */
SELECT
    *
FROM
    emp
WHERE
    deptno=(
        SELECT
            deptno
        FROM
            emp
        WHERE
            ename='SMITH'
    )
;
/*  sub query의 위치에 따른 결과
    
        1. SELECT 절
        ==> 이 부분에서 사용되는 질의 명령은 결과가 반드시 한 행, 한 필드가 나와야함
        
        2. FROM 절
        ==> 여기엔 테이블이 나열되어야 한다.
            조회 질의 명령의 결과는 테이블과 같아서, 이걸 이용할 수도 있다.
            
            이 때 FROM절 안에 들어가는 sub query가 테이블 역할을 하기 때문에
            INLINE TABLE 이라고 부른다.
            
            사용할 땐, 질의명령을 보낼 때 사용한 별칭을 사용해야 한다.
            
        3. WHERE 절
            1) 단일행 단일필드로 결과 발생
            ==> 결과를 비교해 사용한다.
            
            2) 다중행 단일 필드로 결과 발생
                
                사용할 수 있는 연산자
                    
                    IN : 여러개의 데이터 중 하나이상이 일치
                    ==> 묵시적으로 동등비교 처리
                    
                    ANY : 여러 개의 데이터 중 하나만 맞음
                    ==> 대소비교 연산자도 가능
                    
                    ALL : 여러 개의 데이터 모두가 일치
                    ==> 동등비교X, 대소비교 O
                    
            3) 다중행 다중 필드로 결과 발생
            
                EXISTS : 결과가 존재하면 true, 없으면 false
*/
-- 사원들의 사원 이름, 부서번호, 부서이름, 부서위치
SELECT
    ename "사원 이름", deptno "부서 번호",
    (
        SELECT
            dname
        FROM
            dept
        WHERE
            deptno=e.deptno
    ) "부서 이름",(
        SELECT
            loc
        FROM
            dept
        WHERE
            deptno=e.deptno
    ) "부서 위치"
FROM
    emp e;
    
-- 부서번호가 10번인 사원들의 직급별 평균 급여를 조회하시오.
SELECT
    job 직급, ROUND(AVG(sal)) "직급 급여 평균"
FROM
    emp
WHERE
/*
    job IN (
        SELECT
            job
        FROM
            emp
        WHERE
            deptno=10       이렇게 하면 10번 부서에 존재하는 직급의
    )                       (부서 불문) 직급 평균들이 계산된다.
*/
    deptno=10
GROUP BY
    job
;
--------------------------------------------------------------------------------
-- IN
/* 직급이 MANAGER인 사원과 같은 부서에 속한 사원들의
    사원 이름, 직급, 부서번호 를 조회하시오.
*/
SELECT
    ename "사원 이름", job 직급, deptno "부서 번호"
FROM
    emp
WHERE
    /*NOT은 여기에!*/ deptno /*혹은 여기에!*/ IN (
        SELECT
            deptno
        FROM
            emp
        WHERE
            job='MANAGER'
        )
;
-- ANY
/* 각 부서의 평균 급여 중 하나 이상 급여가 높은 사원들의
    사원 이름, 급여, 부서 번호 를 조회하시오.
*/
SELECT
    ename "사원 이름", sal 급여, deptno "부서 번호"
FROM
    emp
WHERE -- 조건에 GROUP BY가 들어가야 함.
    /*NOT은 여기에!*/ sal> any ( -- 어떤 하나 이상의 값만 커도 됨. any
        SELECT
            AVG(sal)
        FROM
            emp
        GROUP BY
            deptno
    )
;
    
-- 각 부서의 평균 급여보다 높은 급여를 받는 사원의
-- 이름, 급여, 부서 번호 를 조회하시오.
SELECT
    ename "사원 이름", sal 급여, deptno "부서 번호"
FROM
    emp
WHERE
    /*NOT은 여기에!*/ sal > ALL ( -- 괄호 안 모든 값보다 커야함.
        SELECT
            AVG(sal)
        FROM
            emp
        GROUP BY
            deptno
    )
;

-- 사원중 40번 부서 사원이 존재하면,
-- 해당하는 모든 사원들의 사원 이름, 부서 번호를 조회하시오.
SELECT
    ename "사원 이름", deptno "부서 번호"
FROM
    /*scott.*/emp
    /*
        테이블을 가리킬 때 원칙은
            계정.테이블이름
        의 형식으로 사용해야 한다.
        하지만 접속 계정이 갖고있는 테이블에 한해서는
        테이블 이름만 기술해도 된다.
    */
WHERE
    EXISTS(-- 부정은 NOT EXISTS
        SELECT
            ename, sal, deptno
        FROM
            emp
        WHERE
            deptno=40
    )
;

--------------------------------------------------------------------------------
/* 사원들의
    사원 이름, 부서 번호,
    부서원 수, 부서 평균 급여, 부서 급여 합계 를 조회하시오.
*/
SELECT
    ename "사원 이름", deptno "부서 번호",
    cnt "부서원 수", avg "부서 평균 급여", sum "부서 급여 합계"
FROM
    emp,
    (
        SELECT
            deptno dno, COUNT(*) cnt-- 에러 안나려면 별칭 써줘야 함.
            , ROUND(AVG(sal), 2) as avg, sum(sal) as sum
        FROM
            emp
        GROUP BY
            deptno
    )
WHERE
    deptno=dno
;

/* 회사 평균 급여보다 적게 받는 사원들의
    사원 이름, 직급, 입사일, 급여 를 조회하시오.
*/
SELECT
    ename "사원 이름", job 직급, hiredate 입사일, sal 급여
FROM
    emp
WHERE
    sal< (
        SELECT
            ROUND(avg(sal))
        FROM
            emp
    )
;

/*
    <day05에서 보충>
    IN과 ANY의 차이
    
        NO IN (10, 20, 30) 의 의미는
        NO =(10, 20, 30) 과 같지만
        
        NO 대소비교연산자 ANY (10, 20, 30)
        은 대소비교연산자 그대로의 의미는 아니다.
        
        true값 기준으로 봤을 때,
        ALL이 ANY의 확장형, 반대로 ANY는 ALL의 축소형이라고 보면 될듯.
*/