-- day08

/*
    Sequence
    ==> 우리가 테이블을 만들면 primary key가 대부분 필수적으로 존재해야 한다.
        대부분 중복값을 피하기 위해, 일련번호로 하는 경우가 많다.
        
        시퀀스는 일련번호를 중복없이 자동적으로 발생시켜주는 도구이다.
        
        방법
            1. 시퀀스를 만들어 놓는다.
            2. DB에 일련번호의 입력이 필요하면
                만들어진 시퀀스에게 일련번호를 만들어달라고 요청한다.
                (수동으로 입력하지 않는다)
                
        
        생성
            CREATE SEQUENCE 시퀀스이름   -- 필요한 애들만 골라서 씀!
                START WITH 숫자       -- 미기입시 시작값 : 1
                INCREMENT BY 숫자     -- 미기입시 증가값 : 1
                MAXVALUE 숫자
                MINVALUE 숫자         -- 미기입시 NO처리
                
                [CYCLE or NOCYCLE]      -- 아래 두개는 미기입시 자동 NO처리
                ==> 숫자가 최대값 도달할 시, 다시 처음부터
                
                CACHE [숫자 or NOCACHE]
                ==> 일련번호 발생시 임시메모리를 사용할지.
                    (미리 일정개수 만들고, 메모리에 기억시킨 후 사용.)
                    사용시 속도는 증가하나 메모리가 줄어든다.
                    
        사용하기
            주로 INSERT에서 사용한다.
            
            시퀀스이름.NEXTVAL
            
            + 시퀀스가 마지막으로 만든 번호 확인하는 법
                시퀀스이름.CURRVAL
*/
-- 문제 1) 1에서 1씩 증가하는 시퀀스를 만들자. 단, 최대값은 10.
CREATE SEQUENCE test_seq
--  START WITH 1
--  INCREMENT BY 1
    MAXVALUE 10
;

SELECT test_seq.CURRVAL FROM dual;  -- 오류 뜸

SELECT test_seq.NEXTVAL 다음번호, test_seq.CURRVAL 마지막번호 FROM dual;
-- NEXTVAL이 호출되면 CURRVAL에 기억시키기 때문에 이건 오류뜨지 않음!

SELECT test_seq.CURRVAL FROM dual;  -- 똑같이 1뜸!

SELECT test_seq.NEXTVAL FROM dual;  -- 증가!

SELECT test_seq.CURRVAL FROM dual;  -- 얘는 걍 조회용인듯!

/*
시퀀스의 문제점
==> 시퀀스는 테이블에 독립적이다.
    즉, 한번 만든 시퀀스는 여러 테이블에서 사용 가능하다.
    어떤 테이블에서 사용하든, 다음 일련번호를 만든다.
    그래서 누락되는 번호가 생길 수 있다.
    
    + 시퀀스의 수정
        ALTER SEQUENCE 시퀀스이름
            INCREMENT BY 숫자
            MAXVALUE 숫자 [or NOMAXVALUE]
            MINVALUE 숫자 [or NOMINVALUE]
            CYCLE [or NOCYCLE]
            CACHE [or NOCACHE]          -- 시작값은 조정할 수 없다.
            
        자동으로 전에 만들어놓은 번호가 시작번호가 된다.
        
    + 시퀀스의 삭제
        DROP SEQUENCE 시퀀스이름;
        
    회원번호를 자동으로 만들어줄 시퀀스를 생성하시오.
    이름은 MEMBSEQ.
    시작값은 1001
    증가값은 1
    최대값은 9999
    다시 반복하여 만들지 않기로 하고
*/
CREATE SEQUENCE membseq
    START WITH 1001
    -- 증가값은 1이니까 생략 가능.
    MAXVALUE 9999
    -- NOCYCLE도 기본값이니 생략 가능.
;

-- 아바타테이블 데이터 추가
INSERT INTO
    avatar
VALUES(
    10, 'noimage', 'noimage.jpg', 'noimage.jpg', '/img/avatar/',
    6000, 'N', sysdate, 'Y'
);

INSERT INTO
    avatar
VALUES(
    11, 'man1', 'img_avatar1.png', 'img.avatar1.png', '/img/avatar/',
    8000, 'M', sysdate, 'Y'
);

INSERT INTO
    avatar
VALUES(
    12, 'man2', 'img_avatar2.png', 'img.avatar2.png', '/img/avatar/',
    8000, 'M', sysdate, 'Y'
);

INSERT INTO
    avatar
VALUES(
    13, 'man4', 'img_avatar3.png', 'img.avatar3.png', '/img/avatar/',
    8000, 'M', sysdate, 'Y'
);

INSERT INTO
    avatar
VALUES(
    14, 'woman1', 'img_avatar4.png', 'img.avatar4.png', '/img/avatar/',
    8000, 'F', sysdate, 'Y'
);

INSERT INTO
    avatar
VALUES(
    15, 'woman2', 'img_avatar5.png', 'img.avatar5.png', '/img/avatar/',
    8000, 'F', sysdate, 'Y'
);

INSERT INTO
    avatar
VALUES(
    16, 'woman3', 'img_avatar6.png', 'img.avatar6.png', '/img/avatar/',
    8000, 'F', sysdate, 'Y'
);

-- 만들어놓은 시퀀스를 이용해 회원 데이터 입력하기
INSERT INTO
    member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    1000, '황인준', 'yellow_3to3', '0323', 'renjun@7dream.com',
    '010-0323-0825', 11, 'M'
);

INSERT INTO
    member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    membseq.NEXTVAL, '최이지', 'prussian_1to9', '1209', 'iji@gwangya.com',
    '010-1209-0825', 16, 'F'
);

INSERT INTO
    member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    membseq.NEXTVAL, '이동혁', 'haechanahceah', '0606', 'haechan@7dream.com',
    '010-0606-0825', 12, 'M'
);

INSERT INTO
    member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    membseq.NEXTVAL, '나재민', 'na.jaemin0813', '0813', 'jaemin@7dream.com',
    '010-0813-0825', 13, 'M'
);

INSERT INTO
    member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    membseq.NEXTVAL, '이제노', 'jenolee.0423', '0423', 'jeno@7dream.com',
    '010-0423-0825', 13, 'M'
);

commit;

--------------------------------------------------------------------------------
-- 방명록 테이블 생성
CREATE TABLE guestboard(
    gno NUMBER(4)
        CONSTRAINT BOARD_NO_PK PRIMARY KEY,
    writer NUMBER(4)
        CONSTRAINT BOARD_MNO_NN NOT NULL
        CONSTRAINT BOARD_MNO_UK UNIQUE
        CONSTRAINT BOARD_MNO_FK REFERENCES member(mno),
    body VARCHAR2(4000)
        CONSTRAINT BOARD_BODY_NN NOT NULL,
    wdate DATE DEFAULT sysdate
        CONSTRAINT BOARD_DATE_NN NOT NULL,
    isShow CHAR(1) DEFAULT 'Y'
        CONSTRAINT BOARD_SHOW_NN NOT NULL
        CONSTRAINT BOARD_SHOW_CK CHECK(isShow IN('Y', 'N'))
);

-- 게시글 등록에 사용할 글 번호를 생성해주는 시퀀스
-- GBRDSEQ를 만드시오. 시작번호 1001, 최대값 9999, NO CYCLE, NO CHACHE
CREATE SEQUENCE gbrdseq
    START WITH 1001
    MAXVALUE 9999
;

-- 방명록에 GBRDSEQ를 이용해 글을 등록해보자
INSERT INTO
    guestboard(gno, writer, body)
VALUES(
    gbrdseq.NEXTVAL, 1001, '게시판 오픈 감축드립니다. 오예.'
);

INSERT INTO
    guestboard(gno, writer, body)
VALUES(
    gbrdseq.NEXTVAL, 1001, '나밖에 없냐?' -- 중복된 회원번호라 입력이 안됨
);

INSERT INTO
    guestboard(gno, writer, body)
VALUES(
    gbrdseq.NEXTVAL, 1000, '이지 미니홈피 잘 들렀다감~ 내 웨이보도 와줘'
);

INSERT INTO
    guestboard(gno, writer, body)
VALUES(
    gbrdseq.NEXTVAL, 1004, '(SNS를 안하는 제노는 소식이 없다.)'
);

commit;
-- 방명록에서 글번호, 작성자아이디, 작성자 성별,
-- 작성자 아바타 저장이름, 글내용, 작성일 을 조회하시오.
SELECT
    gno 글번호, writer "작성자 아이디", member.gen "작성자 성별",
    savename "아바타 저장이름", body 글내용,
    TO_CHAR(wdate, 'YYYY"년 " MM"월" DD"일"') 작성일
FROM
    guestboard, member, avatar
WHERE
    guestboard.writer=member.mno
    AND member.avt=avatar.ano
;

select*from guestboard;

-- 이동혁과 나재민 아이디만 알고있다는 가정하에
-- 방명록에 글을 등록하시오.
INSERT INTO
    guestboard(gno, writer, body)
VALUES(
    gbrdseq.NEXTVAL, (SELECT mno FROM member WHERE ID='haechanahceah'),
    '와앙 런쥔이당~'
);

INSERT INTO
    guestboard(gno, writer, body)
VALUES(
    gbrdseq.NEXTVAL, (SELECT mno FROM member WHERE ID='na.jaemin0813'),
    '우리 큐티뽀쨕 런~쥐니가 요기잉네?'
);

--------------------------------------------------------------------------------
/*
    Index
    ==> 검색속도를 빠르게 하기 위해서 B-Tree기법으로 색인을 만들어
        SELECT를 바른 속도로 처리할 수 있게 하는 것.
        
        index를 만들면 나쁜 경우
      
        1. 데이터 양이 너무 적을때 : 오히려 속도 저하.
        2. 데이터의 입출력이 빈번한 경우 : 그때마다 index수정하니 속도 저하.
        
        index를 만들면 좋은 경우
      
        1. join등에 많이 사용되는 필드가 존재하는 경우
        2. null 값이 많이 존재하는 경우
        3. where 조건절에 많이 사용되는 필드가 존재하는 경우.
        
      + 제약조건을 추가할 때
        primary key, unique 를 부여하면, 해당 필드에 자동적으로 index처리 됨.
        
    index 생성 방법
    
        1. 일반 인덱스 만들기 (NON UNIQUE INDEX)
        CREATE INDEX 인덱스이름
        ON
            테이블이름(사용할필드이름)
        
        일반 인덱스는 데이터가 중복되어도 괜찮다.
        
        
        2. UNIQUE INDEX 만들기
        ==> 인텍스에 쓸 데이터들이 반드시 UNIQUE하다는 보장이 있는 경우만 생성.
        
        CREATE UNIQUE INDEX 인텍스이름
        ON
            테이블이름(필드이름)
            
        이 때, 지정한 필드는 반드시 UNIQUE하다는 보장이 있어야 한다.
        
        UNIQUE INDEX의 장점 : 이진 검색을 사용하기에, 일반 INDEX보다 빠르다.
        
        
        3. 결합 인덱스
        ==> 여러개의 필드를 결합해 하나의 인덱스를 만든다.
            전제조건 : 사용되는 필드의 조합이 반드시 PRIMARY여야(복합키) 한다.
            
            하나의 필드로 UNIQUE 인덱스를 만들지 못하는 경우,
            여러개의 필드를 합쳐서 UNIQE INDEX를 만드는 방법.
            
            CREATE UNIQUE INDEX 인덱스이름
            ON
                테이블이름(필드이름, 필드이름, . . . )
            
          + 복합 키 제약조건 추가하기
            CREATE TABLE 테이블이름(
                필드 데이터타입(길이),
                . . .
                CONSTRAINT 제약조건이름 PRIMARY KEY(필드이름, 필드이름, . . .)
            )
            
            
        4. 비트 인덱스
        ==> 주로 그 안에 들어있는 데이터가 몇 가지 중 하나인 경우 많이 사용.
            ex.
                GEN 필드엔 F, M, N만 입력되게 CHECK되어 있다.
                DEPTNO필드엔 10, 20, 30, 40만 입력되어 있다.
                
            처럼 domain이 정해져 있는 경우만 사용 가능하다.
            
            CREATE BITMAP IDNEX 인덱스이름
            ON
                테이블이름(필드이름)
*/
-- 회원 테이블의 이름을 이용해 인덱스를 만드시오.
CREATE INDEX name_idx
ON
    member(name);
    
--------------------------------------------------------------------------------
/*
    Inline View
    ==> SELECT명령을 내리면 발생하는 결과를 inline view라고 이야기한다.
    
        즉, view는 자주 사용하는 inline view를 등록해서 사용하는 개념이 된다.
        
        근데 view든 inline view든 구조 자체는 테이브로가 비슷하기 때문에,
        테이블을 사용해야 하는 곳에 대신 사용할 수도 있다.
        
        왜쓰는디?
            실제 테이블에 존재하지 않는 데이터를 추가해서 사용해야 하는 경우
*/
-- 예제 1) 
SELECT
    mno, name
FROM
    (SELECT*FROM member) -- inline view의 결과 중, mno와 name만 꺼냄.
;

-- 예제 2) 에러가 발생하는 경우
SELECT
    mno, id, name, joindate -- 없는 데이터는 못뽑는다!!
FROM
    (SELECT mno, id, name, mail FROM member)
;

/*
  + ROWNUM
    ==> 가상의 필드. 데이터가 조회된 순서를 표시한다.
*/
SELECT
    *
FROM (
    SELECT
        ROWNUM rno, g.*
    FROM (
        SELECT
            gno, writer, body, wdate
        FROM
            guestboard
        WHERE
            isShow='Y'
        ORDER BY
            wdate DESC
    ) g
)
WHERE
    rno between 2 and 4  -- 조회 돼야 rownum +1인디.. 안되니까 무조건 false
    -- 그래서 위의 SELECT 명령을 또 inline view로 밀어넣는다!!
;

-- 예제 문제
-- 회원테이블의 회원들을 조회하시오.
-- rownum 기준으로 4번째부터 6번째 회원만 조회하시오.
-- 단, 정렬은 이름기준 내림차순.
SELECT
    *
FROM
    (
    SELECT
        ROWNUM r, mno, name, id, mail, tel, gen, joindate, avt, savename
    FROM
        (
        SELECT
            mno, name, id, mail, tel, member.gen, joindate, avt, savename
        FROM
            member, avatar
        WHERE
            ano=avt
        ORDER BY
            name DESC
        )
    )
WHERE
    r between 4 and 6
;