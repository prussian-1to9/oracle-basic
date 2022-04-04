-- day07

/*
day06 리뷰~
    제약조건 추가하기
    
        형식 1.
        
        컬럼이름 데이터타입(길이) CONSTRAINT 제약조건이름 제약조건
        
        (일반적으로) 제약조건 이름 : 테이블이름_컬럼이름_제약조건
        
        
        형식 2.
        
        컬럼이름 데이터타입(길이)
        . . . (를 계속 나열 후)
        CONSTARINT 제약조건이름 제약조건(컬럼이름)
        
        컬럼이 만들어진 이후엔, not null 제약조건을 추가할 수 없다.
        ==> 제약조건 추가 없이 테이블을 만들면, 자동 nullable 처리가 된다.
            '추가'가 아닌 '수정'의 개념으로 접근해야 한다!
            
            
        형식 3. (제약조건 없이 테이블을 만들고 나중에 제약조건을 추가하는 경우)
        
        ALTER TABLE 테이블 이름
            ADD CONSTRAINT 제약조건이름 제약조건(컬럼이름)
*/
CREATE TABLE TMP(
    no NUMBER(2),
    name VARCHAR2(10 CHAR)
);

DESC TMP; -- 따로 not null 제약을 주지 않았기에, nullable 상태로 뜬다.

DROP TABLE TMP;


-- 엑셀의 테이블 명세서롤 이용해 테이블들을 만들어보자!
-- 참조해주는 테이블 부터 만들어야함...!

CREATE TABLE avatar(
    ano NUMBER(2),
    aname VARCHAR2(15 CHAR),
    oriname VARCHAR2(50 CHAR),
    savename VARCHAR2(50 CHAR),
    dir VARCHAR2(100 CHAR),
    len NUMBER,
    adate DATE DEFAULT sysdate,
    isShow CHAR(1) DEFAULT 'Y',
    
    -- 제약조건 기입 --
    CONSTRAINT AVT_NO_PK PRIMARY KEY(ano),
    CONSTRAINT AVT_SNAME_UK UNIQUE(savename),
    CONSTRAINT AVT_SHOW_CK CHECK(isShow IN ('Y', 'N'))
);

-- 제약조건 NOT NULL로 수정 --
-- 얘는 한번에 컬럼 하나밖에 못함...
ALTER TABLE avatar
MODIFY aname
    CONSTRAINT AVT_NAME_NNN NOT NULL
;

ALTER TABLE avatar
MODIFY oriname
    CONSTRAINT AVT_ONAME_NNN NOT NULL
;

ALTER TABLE avatar
MODIFY savename
    CONSTRAINT AVT_SNAME_NNN NOT NULL
;

ALTER TABLE avatar
MODIFY dir
    CONSTRAINT AVT_DIR_NNN NOT NULL
;

ALTER TABLE avatar
MODIFY len
    CONSTRAINT AVT_LEN_NNN NOT NULL
;

ALTER TABLE avatar
MODIFY adate
    CONSTRAINT AVT_DATE_NNN NOT NULL
;

ALTER TABLE avatar
MODIFY isShow
    CONSTRAINT AVT_SHOW_NNN NOT NULL
;

-- 회원 테이블 --
CREATE TABLE MEMBER(
    mno NUMBER(4)
        CONSTRAINT MB_NO_PK PRIMARY KEY,
    name VARCHAR2(20 CHAR)
        CONSTRAINT MB_NAME_NN NOT NULL,
    id VARCHAR2(15 CHAR)
        CONSTRAINT MB_ID_UK UNIQUE
        CONSTRAINT MB_ID_NN NOT NULL,
    pw VARCHAR2(15 CHAR)
        CONSTRAINT MB_PW_NN NOT NULL,
    mail VARCHAR2(50 CHAR)
        CONSTRAINT MB_MAIL_UK UNIQUE
        CONSTRAINT MB_MAIL_NN NOT NULL,
    tel VARCHAR2(13 CHAR)
        CONSTRAINT MB_TEL_UK UNIQUE
        CONSTRAINT MB_TEL_NN NOT NULL,
    addr VARCHAR2(50 CHAR)
        CONSTRAINT MB_ADDR_NN NOT NULL,
    gen CHAR(1)
        CONSTRAINT MB_GEN_NN NOT NULL
        CONSTRAINT MB_GEN_CK CHECK (gen IN ('F', 'M')),
    joindate DATE DEFAULT sysdate
        CONSTRAINT MB_DATE_NN NOT NULL,
    isShow CHAR(1) DEFAULT 'Y'
        CONSTRAINT MB_SHOW_NN NOT NULL
        CONSTRAINT MB_SHOW_CK CHECK (isShow IN ('Y', 'N')),
    avt NUMBER(2) DEFAULT 10
        CONSTRAINT MB_AVT_FK REFERENCES avatar(ano)
);

/*
    등록된 제약조건 확인법
    ==> 등록된 제약조건은 oracle이 테이블을 이용해 관리한다.
        이 테이블 이름이 (day06에도 언급) USER_CONSTRAINTS 이다!
        
        이 테이블을 이용해 확인해봅쉬다.
*/
DESC USER_CONSTRAINTS;

-- 아바타 테이블의 제약조건을 조회해 봅시다.
SELECT
    constraint_name "제약 조건 이름", constraint_type "제약 조건",
    table_name "테이블 이름"
FROM
    user_constraints
WHERE
    table_name IN ('AVATAR', 'MEMBER')
;

/*
    CONSTRAINT_TYPE
    
        P   Primary key
        R   Referenced, foreign key
        U   Unique key
        C   Common(not null), Check
        
--------------------------------------------------------------------------------
    제약조건 삭제하기
    
    ALTER TABLE 테이블이름
        DROP CONSTRAINT 제약조건이름;
        
      + Primary key의 경우, 제약조건 이름을 몰라도 삭제할 수 있다. (하나밖에 없어서)
      
        ALTER TABLE 테이블이름 DROP PRIMARY KEY;
*/

-- member 테이블에서 primary key를 삭제해보자
ALTER TABLE MEMBER
    DROP PRIMARY KEY;
    
-- 돌아와~~~
ALTER TABLE MEMBER
    ADD CONSTRAINT MB_NO_PK PRIMARY KEY(mno);
    
-- tmp 테이블 만들기
CREATE TABLE tmp(
    no NUMBER(4)
);

/* 
    테이블 수정하기
    
        1. 필드 추가
            ALTER TABLE 테이블이름
            ADD (
                원래 필드 만들던 대로...
            );
*/

-- tmp 테이블에 name 필드 추가해보기
ALTER TABLE tmp ADD (
    name VARCHAR2(10 CHAR)
        CONSTRAINT TMP_NAME_NN NOT NULL
);

-- tmp 테이블 no 필드를 primary로 지정
ALTER TABLE tmp ADD
CONSTRAINT TMP_NO_PK PRIMARY KEY(no)
;

/*
        2. 필드 이름 변경
            ALTER TABLE 테이블이름 
            RENAME COLUMN 필드이름 TO 바뀔이름;
*/

-- tmp 테이블의 no를 tno로 변경해보자.
ALTER TABLE tmp RENAME COLUMN no TO tno;

/*
        3. 필드 길이 변경
            ALTER TABLE 테이블이름
            MODIFY 필드이름 데이터타입(길이) [DEFAULT 데이터];
            
            이 때, DEFAULT 값도 설정해 줄 수 있다.
            
          ※ 길이변경을 할 때, 길이를 축소시키는것은 불가능하다!!
          
          
        4. 필드 삭제하기
            ALTER TABLE 테이블이름
            DROP COLUMN 필드이름;
            
--------------------------------------------------------------------------------
테이블 자체를 수정하기~


    1. 테이블 이름 변경    
        ALTER TABLE 테이블이름 RENAME TO 변경될테이블이름;
        
        
    2. 테이블 삭제 : oracle은 자체적으로 휴지통이 존재한다.
    
        1) DROP TABLE 테이블이름; ==> 일반적인 drop
        
        2) DROP TABLE 테이블이름 PRUGE;
        ==> oracle 내 휴지통에 넣지 않고, 바로 폐기
        
        테이블과 테이블 내 모든 데이터가 삭제된다.
        DML 명령이 아닌, DDL 명령은 원칙적으로 복구가 불가능 하다.
        
      + 휴지통 개념은 언제부터? : 10g부터
      
      + 휴지통 관리
            휴지통 모두 비우기
            ==> PURGE RECYCLEBIN;
            
            휴지통 내 특정 테이블 지우기
            ==> PURGE TABLE 테이블이름;
            
            휴지통 내용 확인
            ==> SHOW RECYCLEBIN;
            
            휴지통 내 특정 테이블 복구
            ==> FLASHBACK TABLE 테이블명 TO BEFORE DROP;
            
*/
-- 휴지통 함 봐보까
show recyclebin;

--------------------------------------------------------------------------------
/*
    TRUNCATE
    ==> DML 명령의 DELETE 명령과 같이, 테이블 안의 모든 데이터를 삭제한다.
        DDL 명령이라 auto-commit이 된다는 점 주의. (rollback 불가)
        
        TRUNCATE TABLE 테이블이름;
        
    무결성 체크
    ==> DB는 프로그램 등 전산에서 작업할 때
        필요한 데이터를 제공해주는 보조 프로그램이다.
        따라서, DB는 항상 완벽한 데이터여야 하는데, 인간인지라 항상 완벽하긴 힘들다.
        
        무결성 체크는
        각 테이블에 입력 불가 데이터, 필수 데이터를 미리 정해놓고
        이상 데이터가 입력되지 않도록 방지하는 역할을 한다.
        (때문에 필수적일 필요는 없다.)
        
  + sub query로 테이블 만들기~
    CREATE TABLE 테이블이름
    AS
        서브질의
    ;
    
    근데 이 때, not null을 제외한 제약조건은 복사되지 않으며,
    심지어 not null 제약조건 이름도 oracle 맘대로 정해버린다!
    
    테이블의 구조만 복사하고 싶은 경우
        CREATE TABLE 테이블이름
        AS
            SELECT*FROM 테이블이름 WHERE 1=2;
        
    --> WHERE 절에 false값이 오게 되면 데이터를 가져오지 않는다.
        이 점을 이용한 복사법!
*/

-- sub query로 테이블 한번 만들어보자!!
CREATE TABLE memb02
AS
    SELECT * FROM memb  -- sub query
;

-- 제약조건이 다 날라가버렸쥬. primary key부터 정해줄까여?
ALTER TABLE memb02
ADD CONSTRAINT MEMB2_NO_PK PRIMARY KEY(mno);


/*
    sub query로 INSERT 명령도 가능함!!
    
        INSERT INTO 테이블이름
            subquery
        ;
*/
-- emp테이블의 사원 중, 부서번호가 10번인 사원들의 데이터만 emp2에 복사하시오.
INSERT INTO emp2
    SELECT
        *
    FROM
        emp
    WHERE
        deptno=10
;

--------------------------------------------------------------------------------
/*
    DCL명령 (Data Control Language)
    
    Transaction 처리
    ==> 교과서적인 의미론 oracle이 처리하는 명령 단위를 의미한다.
    
        하지만 DML명령은 transcation 단위가 달라진다.
        (INSERT, UPDATE, DELETE 등등. . .)
        DML명령은 바로 실행되지 않고, buffer memory에 명령을 모아둔다.
        (실질적으로 transaction이 실행되진 않는다.)
        
        그래서 우린 강제로 transaction 실행 명령을 내려주는데,
        이 때 transaction은 한 번만 일어난다.
        
        WHY?!
            DB에서 가장 중요한 개념은 무결성이다.
        데이터를 변경하는 DML명령이 한 순간에 transaction 처리가 된다면
        이 무결성이 깨질 수 있기 때문.
        
        
        자동 transaction : 그 이전에 작업했던것 까지 모두 commit 된다.
        ==> SQL plus를 정상적으로 종료할 때.
            exit명령으로 세션을 정상적으로 닫으면 transaction 처리가 일어난다.
            (닫기 버튼을 누르는 것은 정상종료에 속하지 않는다.)
            
        ==> DDL명령, DCL명령이 내려질 때.
        
        수동 transaction(commit)
        ==> commit; 명령
        
          + Buffer에 모아놓은 명령이 실행되지 않는 순간이 있다.
            (transaction 처리가 되지 못하고 rollback 될 때)
            
            자동 rollback
            ==> 정전등에 의해 시스템이 shutdown 됐을 때
            ==> sqlplus를 비정상 종료
            
            수동 rollback
            ==> rollback;
            
    *** 결론
        DML명령을 내린 후, 검토 했어도 완벽한 명령이라고 판단 되면
        commit, 그렇지 않으면 rollback 명령을 해주면 된다.
        
        save point 만들기
            SAVEPOINT 책갈피이름;
            
        save point를 이용해 rollback 하는 법
            ROLLBACK TO 책갈피이름;
            
        transaction이 처리되면 save point는 자동 파기된다.
        ex.
            SAVEPOINT 요;
            (DML 명령 어쩌구 저쩌구)
            SAVEPOINT 드림;
            (DML 명령 어쩌구 저쩌구)
            SAVEPOINT 쩗쭓짧;
            (DML 명령 어쩌구 저쩌구)        일 때,
            
            ROLL BACK TO 쩗쭓짧;     ==> 파이팅 이후 명령 취소
            ROLL BACK TO 드림;       ==> 드림 이후 명령 취소
*/
--------------------------------------------------------------------------------
/*
    CREATE 명령으로 만들 수 있는 것
    
    CREATE VIEW
    ==> 테이블과 유사하지만, DB에 물리적인 영향이 가지 않는다.
        결과가 발생하는 질의명령의, 일부분만 볼 수 있는 view를 생성하는 것.
        
        자주 사용되는 복잡한 질의명령을 따로 저장해 놓고
        이 질의 명령의 결과를 손쉽게 처리할 수 있도록 하는 것.
        
        
        종류
            1. 단순 view
            ==> 하나의 테이블만 이용해서 만들어진 view.
                원칙적으로 DML명령이 가능!
                
                하나의 테이블을 이용하였더라도, grouping이 되어있다면
                DML명령이 사용 불가능하다.
            
            2. 복합 view
            ==> 두 개 이상의 테이블을 join하여 만들어진 view
                DML명령이 불가! (SELECT 명령만 가능)

--------------------------------------------------------------------------------
    
  + 원칙적으로 사용자 계정은 관리자가 허락한 일만 할 수 있다.
    VIEW는 따로 권한을 줄 필요가 있다.
    
    권한 부여하는 방법 : system(관리자) 계정에서 줘야 함.
    
        GRANT 권한이름, 권한이름, . . . TO 계정이름;
*/
-- system계정으로 작업
GRANT CREATE VIEW TO scott;
GRANT CREATE VIEW TO ez;
/*
    how to create VIEW : 1
        CREATE[ or REPLACE] VIEW 뷰이름
        AS
            subquery                        --> 고칠 경우엔 replace 이용
        ;
        
  + 만들어진 VIEW 확인 법
    user_constraints 테이블 처럼 user_views라는 테이블이 존재한다!
    요걸로 보면 됨!
*/
CREATE VIEW dnosal  -- create 명령이라 실무에선 잘 안쓰긴 한대...
AS
    SELECT
        deptno dno, max(sal) max, min(sal) min, sum(sal) sum, avg(sal) avg,
        count(*) cnt
    FROM
        emp
    GROUP BY
        deptno
;                   -- emp 테이블의 데이터 변화가 있어도 view (관점)은 그대로다.

DESC user_views;

SELECT * FROM user_views WHERE VIEW_NAME='DNOSAL';

-- 사원들의 이름, 부서번호, 부서 최대 급여, 부서원 수를 조회하시오.
-- (아까 만든 view dnosal을 이용해보자구요!!)
SELECT
    ename "사원 이름", deptno "부서 번호", max "부서 최대 급여", cnt "부서원 수"
FROM
    emp, dnosal
WHERE
    deptno=dno -- 이용할 때는 테이블처럼 이용한다!
;

-- 연습문제 1 : emp 테이블 사원들의 사번, 이름, 부서번호, 부서 이름, 부서위치
-- 를 조회하는 view 'EMP_DNO'를 만드시오.
CREATE VIEW
    emp_dno
AS
    SELECT  -- VIEW는 나중에 이용할걸 생각해서, 한글 이름을 권장하지 않는다!
        empno, ename, emp.deptno, dname, loc
    FROM
        emp, dept
    WHERE
        emp.deptno=dept.deptno
;

-- 데이터 추가 : 구문상 문제가 없어도 복합 view라서 DML 명령이 불가능!
INSERT INTO
    emp_dno
VALUES (
    8000, 'RENJUN', 40, 'OPERATIONS', 'BOSTON'
);

-- 연습문제 2 : 10번 부서 사원들의 사번, 이름, 급여, 커미션을 조회하는
-- view 'DNO10'을 만드시오
CREATE VIEW
    dno10
AS
    SELECT
        empno, ename, sal, comm
    FROM
        emp
    WHERE
        deptno=10
;

-- 똑같이! 데이터 입력해봅시다.
INSERT INTO
    dno10
VALUES (
    8000, 'RENJUN', 7000, 1209
);                              -- 요러면 emp테이블에 런쥔쨔응이 들어간다굿 5252

rollback;
/*
    how to create VIEW : 2
    ==> DML명령으로 데이터를 변경할 때, 기본 테이블에만 반영이 되므로
        view 입장에선 그 데이터를 실제로 사용할 수 없게되는 경우가 있다.
        
        CREATE [or REPLACE] VIEW 뷰이름
        AS
            질의명령
        WITH CHECK OPITON;
        
        
    how to create VIEW : 3
    ==> view를 이용해 데이터를 변경하면, view를 사용하지 않는 데이터는 변경이 불가.
        원본 테이블 입장에선 문제가 발생할 수 있다.
        view를 통해 데이터를 수정하지 못하도록 방지하는 형식은
        
        CREATE [or REPLACE] VIEW 뷰이름
        AS
            질의명령
        WITH READ ONLY;
*/

/*  
문제 3.
    emp 테이블을 복사하여 employee 테이블을 만드시오.
    테이블 생성시 기본키 제약조건과 참조키 제약조건을 추가하시오.
    
    그리고 view dno10을 만들고, view를 만드는 조건으로
    column의 데이터는 수정하지 못하도록 하시오.
*/
-- employee 테이블 생성
CREATE TABLE employee
AS
    SELECT
        *
    FROM
        emp
;

-- PK
ALTER TABLE employee ADD
CONSTRAINT EMPLO_NO_PK PRIMARY KEY(empno)
;


-- FK
ALTER TABLE employee ADD
CONSTRAINT EMPLO_DNO_FK FOREIGN KEY(deptno) REFERENCES dept(deptno);

-- create VIEW
CREATE OR REPLACE VIEW
    dno10
AS
    SELECT
        empno, ename, sal, comm, deptno
    FROM
        employee
    WHERE
        deptno=10
WITH CHECK OPTION
;

-- dno10 봐봅쉬다
SELECT * FROM dno10;

-- CLARK의 커미션을 500으로 올려봅시다.
UPDATE
    dno10
SET
    comm=NVL(comm+500, 500)
WHERE
    ename='CLARK'
;

-- 이번엔 KING 쏴장의 부서번호를 40번으로 바꿔보자구.
UPDATE
    dno10
SET
    deptno=40
WHERE
    ename='KING'        -- check option에 걸린다고 오류가 뜨죵.
;

/*
    + 기본 테이블이 없어도 view를 만들 수 있다! (급할 때 임시방편)
      
        CREATE [OR REPLACE] FORCE VIEW 뷰이름
        AS
            질의 명령
            . . .
        ;
        
        참조하는 테이블이 없으면 (당연하게도) view는 작동하지 않는다.
        나중에 테이블을 만들어주면 그 때 불러올 데이터가 생긴다.
*/

-- 게시판 테이블(BOARD)의 글번호, 작성자번호, 글제목, 작성일, 클릭수
-- 를 조회하는 view를 작성하시오.
CREATE OR REPLACE FORCE VIEW brdlist
AS
    SELECT
        bno, bmno, title, wdate, click
    FROM
        board   -- compile 오류와 함께 뷰가 생성되었다고 뜬다!
;

-- 삭제합쉬다.
DROP VIEW brdlist;
