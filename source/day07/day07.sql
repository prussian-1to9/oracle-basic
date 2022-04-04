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