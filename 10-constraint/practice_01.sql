/* ========================= [ 쿼리 연습 정답 ] ========================= */
/*
    1.  첨부된 테이블 명세서를 이용해 테이블 생성
        (테이블 생성 순서에 유의)
        sheet1 : member  - 회원 테이블
        avatar  - 아바타 테이블

    2.  단, avatar 테이블은 NOT NULL 조건을 테이블 생성 이후에 추가한다.

    NOT NULL 조건 추가 구문 :
        ALTER TABLE tbl_name MODIFY col_name
            CONSTRAINT constraint_name NOT NULL;

    3.  테이블 생성 이후, memeber 테이블의 primary를 제거하고 다시 복구해 본다.
*/

-- 1-1. avatar 테이블 생성
CREATE TABLE avatar(
    ano         NUMBER(2),
    aname       VARCHAR2(15 CHAR),
    oriname     VARCHAR2(50 CHAR),
    savename    VARCHAR2(50 CHAR),
    dir         VARCHAR2(100 CHAR),
    len         NUMBER,
    gen CHAR(1)
        CONSTRAINT AVT_GEN_CK CHECK (gen IN ('F','M', 'N')),
    adate   DATE DEFAULT sysdate,
    isShow  CHAR(1) DEFAULT 'Y',
    
    -- 제약조건 기입 --
    CONSTRAINT AVT_NO_PK PRIMARY KEY(ano),
    CONSTRAINT AVT_SNAME_UK UNIQUE(savename),
    CONSTRAINT AVT_SHOW_CK CHECK(isShow IN ('Y', 'N'))
);

-- 2. avatar 테이블 not null 조건 추가
ALTER TABLE avatar MODIFY aname
    CONSTRAINT AVT_NAME_NN NOT NULL;

ALTER TABLE avatar MODIFY oriname
    CONSTRAINT AVT_ONAME_NN NOT NULL;

ALTER TABLE avatar MODIFY savename
    CONSTRAINT AVT_SNAME_NN NOT NULL;

ALTER TABLE avatar MODIFY dir
    CONSTRAINT AVT_DIR_NN NOT NULL;

ALTER TABLE avatar MODIFY len
    CONSTRAINT AVT_LEN_NN NOT NULL;

ALTER TABLE avatar MODIFY gen
    CONSTRAINT AVT_GEN_NN NOT NULL;

ALTER TABLE avatar MODIFY adate
    CONSTRAINT AVT_DATE_NN NOT NULL;

ALTER TABLE avatar MODIFY isShow
    CONSTRAINT AVT_SHOW_NN NOT NULL;

-- 1-2. member 테이블
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

-- 3-1. member 테이블 primary key 제거
ALTER TABLE member DROP PRIMARY KEY;

-- 3-2. member 테이블 primary key 복구
ALTER TABLE member ADD CONSTRAINT MB_NO_PK PRIMARY KEY(mno);