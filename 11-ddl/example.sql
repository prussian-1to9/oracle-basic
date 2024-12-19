/* ========================= [ CREATE ] ========================= */
-- 서브쿼리를 이용한 테이블 생성 --
-- 10-constraint의 example.sql 실행 후 아래의 코드 실행 가능
CREATE TABLE memb02
AS SELECT * FROM memb; -- 짧은 sub query
-- 제약조건이 모두 없어진 것을 확인할 수 있다.

/* ========================= [ ALTER ] ========================= */
-- memb02 테이블에 기본키 설정
ALTER TABLE memb02
    ADD CONSTRAINT MEMB2_NO_PK PRIMARY KEY(mno);
    
-- 테스트용 tmp 테이블 생성
DROP TABLE if EXISTS tmp;
CREATE TABLE tmp(no NUMBER(4));

-- tmp 테이블에 NOT NULL 설정한 name 필드 추가
ALTER TABLE tmp ADD (
    name VARCHAR2(10 CHAR)
        CONSTRAINT TMP_NAME_NN NOT NULL
);

-- no 필드를 기본키(primary key)로 설정
ALTER TABLE tmp ADD CONSTRAINT
    TMP_NO_PK PRIMARY KEY(no);

-- no 필드의 이름을 tno로 변경
ALTER TABLE tmp RENAME COLUMN no TO tno;

/* ========================= [ DROP & TRUNCATE ] ========================= */
-- 휴지통 조회 --
show recyclebin;

