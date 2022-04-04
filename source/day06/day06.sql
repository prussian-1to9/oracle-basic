/*
    제약조건
    ==> 데이터가 입력될 때 이상이 있는 데이터를 막는 기능의 oracle entity
    
    목적 : DB의 이상현상 제거
    
    종류
        기본키(primary key) 제약조건
        ==> 속성값으로 데이터를 구분할 수 있어야 한다.
            이 제약조건은 필수는 아니나, 되도록이면 추가하는 것이 좋다.
            
            primary key 제약조건=unique key + NOT NULL 제약조건
            
        유일키(unique) 제약조건
        ==> 기본키와 같이, 속성값으로 데이터를 구분할 수 있어야 한다.
            하지만 null 데이터가 입력 가능!
            
        참조키(외래키, foreign key) 제약조건
        ==> 반드시 참조하는 테이블의 key값을 사용해야 한다.
            입력되지 않은 key값은 입력되지 않게 막는다.
            
            테이블을 삭제하고자 한다면
            먼저 참조하고 있는 테이블을 삭제하고, 해당 테이블을 삭제해야 한다.
*/            
DROP table dept;    --> emp테이블에 참조되었기 때문에, 오류가 뜬다.
/*
        NOT NULL 제약조건
        ==> 속성값으로 null데이터가 오지 않게 막는다.
        
        CHECK 제약조건
        ==> 입력되어야 할 속성값이 정해져 있는 경우, (ex. 성별, 노출여부 등)
            정해진 속성값 외의 값이 입력되는 것을 막는다.
*/
-- emp 테이블에 둘리 사원을 입력하는데, 사원의 입사일은 현재시간으로 하시오.
-- 부서 번호는 50번으로 설정하시오.
INSERT INTO
    emp(empno, ename, hiredate, deptno)
VALUES (
    -- empno는 시퀀스 사용해봅시다.
    (
        SELECT
            NVL((MAX(empno)+1), 1001)
        FROM
            emp
    ),
    '둘리', sysdate, 50
);

/*
    oracle에서 데이터 형태
    
    1. 문자형
        CHAR(최대길이) : 고정길이형
        ==> 최대 길이가 4KB
        
        VARCAR2(최대길이) : 가변길이형
        ==> 최대 길이가 4KB
        
        LONG : 가변길이형
        ==> 최대 길이가 2GB
        
        CLOB : 가변길이형
        ==> 최대길이가 4GB
            4KB밖에 허용하지 못하는 VARCHAR2의 약점을 보완하기 위해 만들어졌음.
        
        + 고정길이 vs 가변길이
            고정길이 : 지정한 길이보다 적은 수의 문자열을 만들면
                        반드시 같은 길이의 문자로 만들어 준다.
                        대신 처리속도가 가변길이보다 빠르다.
                        
            
            가변길이 : 데이터의 길이를 알 수 없는 경우 주로 사용.
                    지정한 길이는 말 그대로 '최대'길이.
                    글자수가 적어도 따로 뭐가 추가되진 않는다.
                    
    2. 숫자형
        NUMBER(숫자1[, 숫자2])
        ==> 숫자 1 : 유효 자릿수
            숫자 2 : 소수 이하 자릿수
            
            ※ 유효 자릿수보다 큰 수는 입력받지 못하며,
              소수 이하 자릿수보다 더 많은 자릿수의 소수는 자동 반올림 된다.
    
    3. 날짜형
    
        DATE
    
    + DB에 따라 데이터의 형태도 달라진다.
      최근 하지만 ANSI 데이터 형태로, 모든 데이터에 적용 가능한 공통형태를
      표준화 협회에서 제시하고 있다.
*/

--------------------------------------------------------------------------------
/*
    1. 테이블 만들기
        CREATE TABLE 테이블 이름(
            필드이름 데이터타입(길이),
            필드이름 데이터타입(길이),
        );
        
        테이블이 만들어져 있는지 확인하는 방법 ! !
        
        SELECT tname FROM tab;
        
        (tab는 시스템이 갖는 테이블. 테이블을 생성하면 tab테이블에 테이블이 들어감)
        
        
        테이블 구조 간단 확인법 : DESC 테이블이름; DESCRIBE 테이블이름;  
*/

-- ez 계정 생성
CREATE USER ez IDENTIFIED BY "pz" ACCOUNT UNLOCK;
GRANT resource, connect to ez;
ALTER USER ez DEFAULT TABLESPACE USERS;

-- ez 계정에서 실행
CREATE TABLE memb(
    mno NUMBER(4),
    name VARCHAR2(20 CHAR),
    id VARCHAR2(15 CHAR),
    pw VARCHAR2(15 CHAR),
    mail VARCHAR2(50 CHAR),
    tel VARCHAR2(13 CHAR),
    addr VARCHAR2(100 CHAR),
    gen CHAR(1),
    joindate DATE DEFAULT sysdate,
    isShow CHAR(1) DEFAULT 'Y' 
);

/*
    제약조건 부여하는 방법
    *****1. 테이블 생성할때 추가
        
            1-1. 필드 정의시 추가
                ==> 필드이름 데이터타입(길이)
                        CONSTRAINT 제약조건이름1 제약조건1
                        CONSTRAINT 제약조건이름2 제약조건2
                        . . . 
                
                참조키 제약조건 (foreigner key)
                ==> CONSTRAINT 제약조건이름 REFERENCES 테이블이름(필드)
                
                체크 제약조건
                ==> CONSTRAINT 제약조건이름
                        CHECK (필드이름 IN (데이터1, 데이터2, ...))
                
            1-2. 필드는 미리 정의, 나중에 제약조건 추가.
            
            1-3. 무명 제약조건으로 등록 (권장하지 않음)
            
            + 제약조건에 이름 부여하는 규칙
              (보편적으로)
                테이블이름_필드이름_제약조건
*/

-- memb 테이블 삭제
DROP TABLE memb;

-- 무명 제약조건으로 등록해보기
CREATE TABLE memb(
    mno NUMBER(4) PRIMARY KEY,
    name VARCHAR2(20 CHAR),
    id VARCHAR2(15 CHAR),
    pw VARCHAR2(15 CHAR),
    mail VARCHAR2(50 CHAR),
    tel VARCHAR2(13 CHAR),
    addr VARCHAR2(100 CHAR),
    gen CHAR(1),
    joindate DATE DEFAULT sysdate,
    isShow CHAR(1) DEFAULT 'Y' 
);

INSERT INTO
    memb(mno, name)
VALUES (
    1001, '고길동'
);

INSERT INTO
    memb(name)
VALUES ('또치');  -- primary key가 없어 오류남

DROP TABLE memb;

--------------------------------------------------------------------------------
/*
    전술한 1-1 (필드 정의시 제약조건 추가) 방법으로 만들어보자!
*/
CREATE TABLE memb(
    mno NUMBER(4)
        CONSTRAINT MEMB_NO_PK PRIMARY KEY,
    name VARCHAR2(20 CHAR)
        CONSTRAINT MEMB_NAME_NN NOT NULL,
    id VARCHAR2(15 CHAR)
        CONSTRAINT MEMB_ID_UK UNIQUE
        CONSTRAINT MEMB_ID_NN NOT NULL,
    pw VARCHAR2(15 CHAR)
        CONSTRAINT MEMB_PW_NN NOT NULL,
    mail VARCHAR2(50 CHAR)
        CONSTRAINT MEMB_MAIL_UK UNIQUE
        CONSTRAINT MEMB_MAIL_NN NOT NULL,
    tel VARCHAR2(13 CHAR)
        CONSTRAINT MEMB_TEL_UK UNIQUE
        CONSTRAINT MEMB_TEL_NN NOT NULL,
    addr VARCHAR2(100 CHAR)
        CONSTRAINT MEMB_ADDR_NN NOT NULL,
    gen CHAR(1)
        CONSTRAINT MEMB_GEN_CK CHECK(gen IN ('F', 'N'))
        CONSTRAINT MEMB_GEN_NN NOT NULL,
    joindate DATE DEFAULT sysdate -- DEFAULT 들어간건 이 이후에 제약조건 표기
        CONSTRAINT MEMB_JOIN_NN NOT NULL,
    isShow CHAR(1) DEFAULT 'Y'
        CONSTRAINT MEMB_SHOW_CK CHECK (isShow IN ('Y', 'N'))
        CONSTRAINT MEMB_SHOW_NN NOT NULL
);

-- 같은 방법으로 작성해보자
-- 게시판 테이블
CREATE TABLE postinfo (
    pno NUMBER(6)
        CONSTRAINT POST_NO_PK PRIMARY KEY,
    upno NUMBER(6)
        CONSTRAINT POST_UNO_FK REFERENCES memb(mno)
        CONSTRAINT POST_UNO_NN NOT NULL,
    bmno NUMBER(4)
        CONSTRAINT POST_BNO_NN NOT NULL,
    title VARCHAR2(30 CHAR)
        CONSTRAINT POST_TITLE_NN NOT NULL,
    body VARCHAR2(3000)
        CONSTRAINT POST_BODY_NN NOT NULL,
    bdate DATE DEFAULT SYSDATE
        CONSTRAINT POST_DATE_NN NOT NULL,
    edate DATE,
    click NUMBER(6) DEFAULT 0
        CONSTRAINT POST_CLICK_NN NOT NULL,
    isShow CHAR(1) DEFAULT 'Y'
        CONSTRAINT POST_SHOW_NN NOT NULL
        CONSTRAINT POST_SHOW_CK CHECK (isShow IN ('Y', 'N'))
);
-- 파일 정보 테이블
CREATE TABLE fileinfo (
    fno NUMBER(7)
        CONSTRAINT FILE_NO_PK PRIMARY KEY,
    postedno NUMBER(6)
        CONSTRAINT FILE_PNO_FK REFERENCES postinfo(pno),
    oriname VARCHAR2(50 CHAR)
        CONSTRAINT FILE_ORINAME_NN NOT NULL,
    fstore VARCHAR2(2000)
        CONSTRAINT FILE_STORE_NN NOT NULL,
    fname VARCHAR2(50 CHAR)
        CONSTRAINT FILE_NAME_NN NOT NULL
        CONSTRAINT FILE_NAME_UK UNIQUE,
    scale NUMBER(12)
        CONSTRAINT FILE_SCALE_NN NOT NULL,
    click NUMBER(6) DEFAULT 0
        CONSTRAINT FILE_CLICK_NN NOT NULL,
    wasDeleted CHAR(1) DEFAULT 'N'
        CONSTRAINT FILE_DELETE_NN NOT NULL
        CONSTRAINT FILE_DELETE_CK CHECK (wasDeleted IN ('Y', 'N'))
);