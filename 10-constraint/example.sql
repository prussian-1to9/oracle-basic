
/* ========================= [ 제약조건(constraint) 맛보기 ] ========================= */
-- 아래의 구문 실행 후 맛보기 쿼리를 실행해본다. --
-- ALTER, CREATE, DROP등의 DDL 명령은 11-ddl에서 자세히 다룸
ALTER TABLE emp
ADD CONSTRAINT EMP_DEPT_FK FOREIGN KEY (deptno) REFERENCES dept(deptno);

-- 해당 SQL을 실행한다면 emp 테이블의 외래키 조건 때문에 구동되지 않는다.
drop table dept;

/*
    emp 테이블에 '둘리' 사원을 입력
    (단, 입사일은 현재시간, 부서번호는 50번으로 설정)
*/
INSERT INTO emp(empno, ename, hiredate, deptno)
VALUES (
    (SELECT NVL((MAX(empno) + 1), 1001) FROM emp),
    '둘리', sysdate, 50
); -- dept 테이블엔 10, 20, 30, 40만 있으므로 입력 불가

/* ========================= [ CREATE TABLE : basic ] ========================= */
-- 'ez' 계정, ez 계정의 테이블 생성 --
-- ez 계정 생성
CREATE USER ez IDENTIFIED BY "pz" ACCOUNT UNLOCK; -- username : ez, password : pz
GRANT resource, connect to ez; -- resource : 테이블 생성 권한, connect : 접속 권한
ALTER USER ez DEFAULT TABLESPACE USERS; -- default tablespace 설정

-- ez 계정에 memb 테이블 생성
CREATE TABLE memb(
    mno         NUMBER(4),
    name        VARCHAR2(20 CHAR),
    id          VARCHAR2(15 CHAR),
    pw          VARCHAR2(15 CHAR),
    mail        VARCHAR2(50 CHAR),
    tel         VARCHAR2(13 CHAR),
    addr        VARCHAR2(100 CHAR),
    gen         CHAR(1),
    joindate    DATE DEFAULT sysdate,
    isShow      CHAR(1) DEFAULT 'Y'
); -- 제약조건이 없는 일반 테이블 생성

-- 삭제 후 PRIMARY 키를 등록하여 재생성
DROP TABLE if EXISTS memb;
CREATE TABLE memb(
    mno         NUMBER(4) PRIMARY KEY, -- 무명 제약조건으로 등록된 기본키(primary key)
    name        VARCHAR2(20 CHAR),
    id          VARCHAR2(15 CHAR),
    pw          VARCHAR2(15 CHAR),
    mail        VARCHAR2(50 CHAR),
    tel         VARCHAR2(13 CHAR),
    addr        VARCHAR2(100 CHAR),
    gen         CHAR(1),
    joindate    DATE DEFAULT sysdate,
    isShow      CHAR(1) DEFAULT 'Y' 
);
-- 데이터 입력 시도
INSERT INTO memb(mno, name)
VALUES (1001, '고길동');

INSERT INTO memb(name)
VALUES ('또치');  -- primary key가 없어 에러 발생

/* ========================= [ 필드 정의 시 제약조건 추가 ] ========================= */
DROP TABLE if EXISTS memb;
CREATE TABLE memb(
    mno NUMBER(4)
        constraint MEMB_NO_PK PRIMARY KEY,
    name VARCHAR2(20 CHAR)
        constraint MEMB_NAME_NN NOT NULL,
    id VARCHAR2(15 CHAR)
        constraint MEMB_ID_UK UNIQUE
        constraint MEMB_ID_NN NOT NULL,
    pw VARCHAR2(15 CHAR)
        constraint MEMB_PW_NN NOT NULL,
    mail VARCHAR2(50 CHAR)
        constraint MEMB_MAIL_UK UNIQUE
        constraint MEMB_MAIL_NN NOT NULL,
    tel VARCHAR2(13 CHAR)
        constraint MEMB_TEL_UK UNIQUE
        constraint MEMB_TEL_NN NOT NULL,
    addr VARCHAR2(100 CHAR)
        constraint MEMB_ADDR_NN NOT NULL,
    gen CHAR(1)
        constraint MEMB_GEN_CK CHECK(gen IN ('F', 'N'))
        constraint MEMB_GEN_NN NOT NULL,
    joindate DATE DEFAULT sysdate -- 기본값은 제약조건 표기 이전에 설정
        constraint MEMB_JOIN_NN NOT NULL,
    isShow CHAR(1) DEFAULT 'Y'
        constraint MEMB_SHOW_CK CHECK (isShow IN ('Y', 'N'))
        constraint MEMB_SHOW_NN NOT NULL
);

-- 게시판 테이블 : 동일 방식으로 작성
CREATE TABLE postinfo (
    pno NUMBER(6)
        constraint POST_NO_PK PRIMARY KEY,
    upno NUMBER(6)
        constraint POST_UNO_FK REFERENCES memb(mno)
        constraint POST_UNO_NN NOT NULL,
    bmno NUMBER(4)
        constraint POST_BNO_NN NOT NULL,
    title VARCHAR2(30 CHAR)
        constraint POST_TITLE_NN NOT NULL,
    body VARCHAR2(3000)
        constraint POST_BODY_NN NOT NULL,
    bdate DATE DEFAULT SYSDATE
        constraint POST_DATE_NN NOT NULL,
    edate DATE,
    click NUMBER(6) DEFAULT 0
        constraint POST_CLICK_NN NOT NULL,
    isShow CHAR(1) DEFAULT 'Y'
        constraint POST_SHOW_NN NOT NULL
        constraint POST_SHOW_CK CHECK (isShow IN ('Y', 'N'))
);

-- 파일 정보 테이블
CREATE TABLE fileinfo (
    fno NUMBER(7)
        constraint FILE_NO_PK PRIMARY KEY,
    postedno NUMBER(6)
        constraint FILE_PNO_FK REFERENCES postinfo(pno),
    oriname VARCHAR2(50 CHAR)
        constraint FILE_ORINAME_NN NOT NULL,
    fstore VARCHAR2(2000)
        constraint FILE_STORE_NN NOT NULL,
    fname VARCHAR2(50 CHAR)
        constraint FILE_NAME_NN NOT NULL
        constraint FILE_NAME_UK UNIQUE,
    scale NUMBER(12)
        constraint FILE_SCALE_NN NOT NULL,
    click NUMBER(6) DEFAULT 0
        constraint FILE_CLICK_NN NOT NULL,
    wasDeleted CHAR(1) DEFAULT 'N'
        constraint FILE_DELETE_NN NOT NULL
        constraint FILE_DELETE_CK CHECK (wasDeleted IN ('Y', 'N'))
);

/* ========================= [ 제약조건 확인하기 ] ========================= */
DESC USER_CONSTRAINTS; -- 테이블 구조 파악

-- memb, postinfo 테이블의 제약조건 확인
SELECT constraint_name "제약 조건 이름", constraint_type "제약 조건",
    table_name "테이블 이름"
FROM user_constraints
WHERE table_name IN ('MEMB', 'POSTINFO');