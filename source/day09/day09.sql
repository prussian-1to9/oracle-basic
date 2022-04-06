-- day09

-- system계정으로 접속하고 실행
begin dbms_xdb.sethttpport('9090');
end;
/

/*
    사용자 관리는 system계정으로!
    
    그렇다면, 계정이란??
    ==> 통장과 같이, 한 사람이 사용할 수 있는 가장 작은 단위의 DB

[모두 DCL 소속 명령]  ==> 주석 안 문제들은 모두 cmd로 했음!
    1. 계정 생성
        1) 관리자모드로 접속
        
          + 계정없이 접속하는 방법
            cmd에서 sqlplus / as sysdba
            ==> 오류 없이 실행되면 관리자 계정으로 접속 성공!
            
        2) create user
            
            CREATE USER 계정이름 IDENTIFIED BY 비밀번호 [ACCOUNT UNLOCK];
            
            ACCOUNT UNLOCK : 계정의 잠금상태 해제 옵션, 생성과 동시에 활성화 됨.
            
            문제 1. test02 계정을 생성하시오. PW : 67890 ==> sqlplus에서 함!
            
          + 현재 접속 계정이 어떤 계정인지 알아보는 명령 : SHOW USER;
          
          계정을 만들게 되면 초기값은 권한이 아무것도 없는 상태이다.
          따라서 어떠한 작업도 불가능하며
          따로 권한을 주고, 활성화(unlock) 시켜줘야 한다.
          
          
    2. 권한 주기 
        GRANT 권한이름, 권한이름, . . . TO 계정이름;
            
        문제 2. test02에게 접속할 수 있는 권한을 부여하시오!
        
        기타권한은 위에서 지정한 형식에 의해 필요한 권한을 부여하면 된다.
        ex.
            테이블 생성 가능한 권한을 test01에게 부여하고자 하면
            GRANT UNLIMITED TABLESPACE, CREATE TABLE TO test01;
            
        문제 3. test02에게 테이블 생성 가능한 권한을 부여하시오.
        
      + session 이란???
        쉽게말해 oracle에 접속함을 의미.
        oracle에 접속할 때 제공되는 권리. oracle 가격에 따라 초기 제공개수가 달라짐.

      + DCL 명령의 갈래
            1) transaction 처리 명령
                commit, rollback, savepoint 등등...
                
            2) 권한 관련 명령
                grant, revoke 등등 ...
                
      + 권한을 부여할때 사용되는 옵션
      
        WITH ADMIN OPTION
        ==> 관리자 권한을 위임받을 수 있도록 하는 옵션.
*/
-- test02 계정에게 create view와 함께 관리자 권한을 포함해 부여하시오.
GRANT CREATE VIEW TO test02 WITH ADMIN OPTION;

--------------------------------------------------------------------------------
/*
    3. 다른계정의 테이블 사용하기
    ==> 원칙적으론 각 계정은 계정 내 테이블만 사용할 수 있다.
        but!!! 권한을 부여받으면 된다 이것이여.
        
        GRANT SELECT ON 계정.테이블이름 TO 권한받는계정이름;
*/
-- test02에게 scott 계정 emp 테이블을 조회할 수 있는 권한을 부여해보자.
GRANT SELECT ON scott.emp TO test02 WITH GRANT OPTION;    -- (test02 line 16로 넘어감)

-- test02에게 모든 계정 테이블 조회 권한을 부여해보자.
GRANT SELECT ANY TABLE TO test02;   -- (test02 line 26으로 넘어감)

--------------------------------------------------------------------------------
/*
    4. 관리자에게 부여받은 권한을 타 계정에 전파하기
    
        GRANT 권한이름 TO 계정
        WITH GRANT OPTION;
        
        (test02 line 33으로 넘어감)  
*/
-- (test02에서 넘어옴, test01 계정으로 권한 부여 실습)
CREATE USER test03 IDENTIFIED BY 12345;
GRANT CREATE SESSION, UNLIMITED TABLESPACE TO test03;

--------------------------------------------------------------------------------
/*
    5. 사용자 권한 수정
    ==> GRANT 명령을 사용하여 해당 계정에 권한을 부여하면 된다.
    
    6. 권한 회수
    
        REVOKE 권한이름 FROM 계정이름;

    7. 계정 삭제
        
        DROP USER 계정이름 [CASCADE];
        
        CASCADE : 관련된 모든 정보 삭제. (다른 계정과 연관이 있더라도)
*/
-- test01, test02. test03 계정을 삭제하시오.
DROP USER test01 CASCADE;
DROP USER test02 CASCADE;
DROP USER test03 CASCADE;

--------------------------------------------------------------------------------
/*
    ROLE을 이용한 권한 부여~~~
    ==> 권한 부여는 관리자가 각 계정에 권한 하나씩 지정하여 처리하는 방식을 취한다.
        ROLE은 다르다!
        관련된 권한을 묶어놓은 권한 세트로써, 여러개의 권한을 동시에 부여한다.
        
        방법~
        
            1. oracle 내 이미 만들어진 ROLE 이용
            (대표적인것만 꼽자면)
            
                1) CONNECT
                ==> 주로 CREATE와 관련된 권한 묶음
                
                2) RESOURCE
                ==> 사용자 객체 (테이블, 시퀀스 등) 생성에 관련된 권한 묶음
                
                3) DBA
                ==> 관리자 계정에서 처리할 수 있는 권한 묶음
                
                권한 부여는 2번 '직접 ROLE을 생성해 사용'의 3번으로 바로 간다.
                
            2. 직접 ROLE을 생성해 사용.
            ==> 롤 안에 그 롤에 필요한 권한을 지정해 부여.
            
            순서가 좀 있다...
                1) 롤만들기
                    CREATE ROLE 롤이름;
                     
                2) 롤에 권한부여
                    GRANT 권한이름, 권한이름, . . . TO 롤이름;
                    
                3) 그다음에 계정에 롤 부여!!! (있는 롤을 쓸 땐, 바로 이 단계로!)
                    GRANT 롤이름 TO 계정이름;
                
        
        부여된 ROLE 회수
        (권한 회수랑 똑같다!)
            REVOKE 롤이름 FROM 계정이름;
            
        ROLE 삭제
            DROP ROLE 롤이름;
*/
/*
    예제 1. test01/12345 계정을 만드시오.
    테이블스페이스, 세션 생성, CONNECT, RESOURCE의 권한을 갖는 USERROLE01을 만들고
    위 롤을 이용해 test01에게 권한을 부여하시오.
*/
CREATE USER test01 IDENTIFIED BY 12345;
CREATE ROLE userRole01;
GRANT CONNECT, RESOURCE, CREATE SESSION, UNLIMITED TABLESPACE,
    CREATE TABLE TO userRole01;
GRANT userRole01 TO test01;
-- unlock 해주기
ALTER USER test01 ACCOUNT UNLOCK;

--------------------------------------------------------------------------------
/*
    동의어(SYNONYM)
    ==> 별칭하고 비슷한 개념이지만, 질의명령이 끝나도 활용 가능하다.
        테이블 자체에 별칭을 부여하여
        여러 사용자가 각각의 이름으로 하나의 테이블을 사용하도록 하는 것.
        
        실제 객체(테이블, 시퀀스, 프로시저 등)의 이름을 감추고,
        사용자에겐 별칭을 부여해 객체를 보호할 수 있게 한다.
        정보 보호를 목적으로 사용한다.
        
*/
-- ez 계정으로 작업
INSERT INTO
    member(mno, name, id, pw, mail, tel, gen, avt)
VALUES(
    MEMBSEQ.nextval, 'mark', 'onyourm__ark', '0802',
    'mark@7dream.com', '010-0802-0825', 'M', 11
);

INSERT INTO
    member(mno, name, id, pw, mail, tel, gen, avt)
VALUES(
    MEMBSEQ.nextval, 'chenle', 'chenle.1122', '1122',
    'chenle@7dream.com', '010-1122-0825', 'M', 12
);

INSERT INTO
    member(mno, name, id, pw, mail, tel, gen, avt)
VALUES(
    MEMBSEQ.nextval, 'jisung', 'jisung.0205', '0205',
    'jisung@7dream.com', '010-0205-0825', 'M', 12
);


UPDATE
    member
SET
    name = '이민형'
WHERE
    name = 'mark'
;

UPDATE
    member
SET
    name = '종천러'
WHERE
    name = 'chenle'
;

UPDATE
    member
SET
    name = '박지성'
WHERE
    name = 'jisung'
;

CREATE OR REPLACE VIEW buddy
AS
    SELECT
        mno, name, id, gen
    FROM
        member
;

SELECT
    *
FROM
    buddy       -- 이러면 member 테이블이 노출되지 않는다.
;
/*
각설하고!

    SYNONYM 언제 쓰는데?
    ==> 주로 다른 계정을 이용하는 유저가 테이블 이름을 알면 곤란할 때,
        테이블 이름을 감추기 위한 목적으로 사용.
        
    생성하기
        CREATE [PUBLIC] SYNONYM 동의어이름
        FOR 실제이름;
        
      ※ PUBLIC 생략되면 같은 계정에서만 사용 가능하게 된다!
        public 동의어를 사용하기 위해선,
        해당 객체(synonym)에 대한 public 권한이 필요하다.
*/
-- 동의어 예제
-- ez 계정에게 scott의 emp 테이블을 조회할 수 있는 권한을 부여하시오.
GRANT SELECT ON scott.emp TO ez;    -- system 계정으로 실행

-- ez 계정으로 실행
SELECT
    *
FROM
    scott.emp;

-- create synonym 권한 주기
GRANT CREATE SYNONYM, CREATE PUBLIC SYNONYM TO ez;

-- 동의어 생성
CREATE SYNONYM eemp
FOR scott.emp;

CREATE PUBLIC SYNONYM pemp
FOR scott.emp;

-- 모두에게 열람 권한을 주고, 다른 계정으로도 조회해보자!
GRANT SELECT ON pemp TO PUBLIC;

/*
    public synonym summary
    
        1. synonym 만들 계정에서 public synonym 생성
        2. 관리자 계정에서 공개할 public synonym 사용권한 부여
        3. 타 계정에서 사용.
*/

-- 그럼 테이블 그대로 말고, 칼럼 몇개만 뺀 형태는 어떻게 만들까?

CREATE OR REPLACE VIEW tview
AS
    SELECT
        mno, name, id
    FROM
        member
;

CREATE PUBLIC SYNONYM tmp
FOR tview
/*(
  SELECT
        mno, name, id
    FROM
        member        -- 요게 안돼서 VIEW를 만들어줬삼.
)*/;

-- public 권한 부여
GRANT SELECT ON tmp TO PUBLIC;

