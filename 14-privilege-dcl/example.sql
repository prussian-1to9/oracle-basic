/* ========================= [ 사용자 관리 ] ========================= */
/*
    활용성을 넓히기 위해 포트(9090번) 설정
    DBMS_XDB 패키지를 사용하여 Oracle XML DB의 HTTP 포트를 설정하는 방법

    ※ 이하 system 계정으로 실행 필요
*/
BEGIN dbms_xdb.sethttpport('9090');
END;

-- CREATE USER --
-- test02 계정 생성 (PW : 67890)
CREATE USER test02 IDENTIFIED BY 67890;

-- 접속 유저 검색
SHOW USER;

/* ========================= [ GRANT : with privileges ] ========================= */
-- test02에게 접속 권한 부여
GRANT CREATE SESSION TO test02;

-- test02에게 테이블 생성 권한 부여
GRANT UNLIMITED TABLESPACE, CREATE TABLE TO test02;

-- test02에게 scott.emp 테이블 조회 권한 부여
GRANT SELECT ON scott.emp TO test02 WITH GRANT OPTION;

-- test02에게 모든 계정의 테이블 조회 권한 부여
GRANT SELECT ANY TABLE TO test02;

-- test03 계정 생성 (PW : 12345) 후 접속 권한 부여
CREATE USER test03 IDENTIFIED BY 12345;
GRANT CREATE SESSION, UNLIMITED TABLESPACE TO test03;

/* ========================= [ DROP USERS ] ========================= */
-- test02, test03 계정 삭제(각각 일반 삭제, CASCADE 삭제)
DROP USER test02;
DROP USER test03 CASCADE;

/* ========================= [ GRANT : with roles ] ========================= */
-- test02, test03 계정 생성
CREATE USER test02 IDENTIFIED BY 67890;
CREATE USER test03 IDENTIFIED BY 12345;

-- test02 계정에게 접속 권한 부여
GRANT CONNECT TO test02; -- oracle 내장 ROLE

/*
    1. test03/12345 계정 생성
    2. table space, session 생성, CONNECT, RESOURCE의 권한을 갖는 userRole01 생성
    3. test03 계정에 userRole01 role 부여
*/
-- 1. test03 계정 생성
CREATE USER test03 IDENTIFIED BY 12345;

-- 2. userRole01 role 생성 및 권한 부여
CREATE ROLE userRole01;
GRANT CONNECT, RESOURCE, CREATE SESSION, UNLIMITED TABLESPACE, CREATE TABLE
TO userRole01;

-- 3. test03 계정에 userRole01 role 부여
GRANT userRole01 TO test03;
ALTER USER test03 ACCOUNT UNLOCK; -- unlock : 접속 허용

/* ========================= [ 권한 조회 ] ========================= */
DESC dba_sys_privs; -- 테이블 구조 조회

-- 1. 계정 권한 조회
SELECT grantee, privilege, admin_option
FROM dba_sys_privs
WHERE grantee = 'SCOTT'; -- 사용자 명 : 대문자 기재

-- 2. 객체 권한 조회(조회하고자 하는 계정으로 접속하여 실행)
SELECT * FROM user_tab_privs;

-- 3. 롤 권한 조회(조회하고자 하는 계정으로 접속하여 실행)
SELECT * FROM user_role_privs;

/*
    [심화1 : 2 + 3] 계정 일반권한 + 롤 권한 한눈에 보기
                    role 예제에서 다뤘던 userRole01 역할에 대한 권한 조회
*/
-- 
SELECT grantee, privilege
FROM dba_sys_privs
WHERE grantee = 'USERROLE01'
UNION -- 컬럼 이름은 상이하나, 동일한 타입으로 union 처리 가능
SELECT grantee, granted_role
FROM dba_role_privs
WHERE grantee = 'USERROLE01'
ORDER BY grantee ASC;

/*
    [심화2] 롤 안에 부여된 모든 권한 확인
            신규 생성한 userRole01,
            oracle 내장 role인 CONNECT, RESOURCE, DBA 권한 조회
*/
SELECT grantee, privilege
FROM dba_sys_privs
WHERE grantee IN ('USERROLE01', 'CONNECT', 'RESOURCE', 'DBA')
ORDER BY grantee ASC;

/* ========================= [ SYNONYM ] ========================= */
/*
    10-constraint 토픽의 연습문제에서 생성한 member 테이블, ez계정을 사용하므로
    member 테이블이 존재하지 않는다면 해당 토픽의 practice_01.sql 실행을 권장

    13-sequence-index에서 데이터를 입력해 주기도 했다.
*/
-- ez
INSERT INTO member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    membseq.NEXTVAL, '최성희', 'bada', '0228', 'bada@smtown.com',
    '010-6666-6666', 15, 'F'
);
INSERT INTO member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    membseq.NEXTVAL, '이민형', 'mark', '0802', 'onyourm__ark@smtown.com',
    '010-7777-7777', 11, 'M'
);
INSERT INTO member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    membseq.NEXTVAL, '임윤아', 'yoona', '0530', 'yoona@smtown.com',
    '010-8888-8888', 14, 'F'
);

-- member 테이블에 대한 동의어 buddy 생성
CREATE OR REPLACE VIEW buddy AS
SELECT mno, name, id, gen
FROM member;

SELECT * FROM buddy; -- member 테이블 노출 없이 정보 조회가 가능하다.

/*
    PUBLIC SYNONYM을 생성해 본다.
    1. scott 계정에서 PUBLIC SYNOMYM employee 생성
    2. 관리자 계정에서 employee 사용권한 부여
    3. 타 계정인 test03에서 사용
*/
-- 12-tcl-view 연습 문제에서 employee 테이블 생성하였으므로 실행
DROP TABLE employee IF EXISTS;

-- 1. PUBLIC SYNONYM 생성
CREATE OR REPLACE PUBLIC SYNONYM employee
FOR scott.emp; -- inline view 사용을 원할 경우 VIEW 생성 필요

-- 2. public 권한 부여(system 계정으로 실행)
GRANT SELECT ON employee TO PUBLIC;

-- 3. test03 계정에서 조회
SELECT * FROM employee;

SELECT * FROM user_properties; -- 번외 : 사용자 정보 조회