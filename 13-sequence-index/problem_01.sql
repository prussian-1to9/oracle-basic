/* ========================= [ 쿼리 연습 ] ========================= */
/*
    10-constraint 토픽의 연습문제에서 생성한 member 테이블을 사용하므로
    member 테이블이 존재하지 않는다면 해당 토픽의 practice_01.sql 실행을 권장
*/
-- 아래의 명령 실행 후 문제풀이 : 방명록 테이블 생성
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
/*
    1.  회원번호를 자동으로 생성할 시퀀스 membseq 생성
        (단, 최대값 도달 시 시퀀스를 반복하지 않음)
        시퀀스 설정 :
            시작값      - 1001
            증가값      - 1
            최대값      - 9999
*/

/*
    2.  아래의 쿼리 실행 후,
        시퀀스를 이용하여 데이터 4번 추가 입력
        (마지막 입력 시퀀스 값은 1004로, 가장 큰 mno가 1004라면 성공)
*/
-- 실행 쿼리
INSERT INTO member(mno, name, id, pw, mail, tel, avt, gen)
VALUES(
    1000, '최이지', 'prussian-1to9', '1209', 'iji@smtown.com',
    '010-1111-1111', 16, 'F'
);

/*
    3.  방명록 글번호를 자동으로 생성할 시퀀스 gbrdseq 생성
        (단, 최대값 도달 시 시퀀스를 반복하지 않음, 캐시 사용 안 함)
        시퀀스 설정 :
            시작값      - 1001
            증가값      - 1
            최대값      - 9999
*/

/*
    4.  시퀀스를 이용하여 방명록 데이터 4번 입력
        writer값은 member.mno를 참조한다.
        (마지막 입력 시퀀스 값은 1004로, 가장 큰 gno가 1004라면 성공)
*/

commit; -- 문제 풀이 후 무조건 실행

/*
    5.  4번까지 생성한 데이터를 이용하여
        방명록의 글 번호, 작성자 아이디, 작성자 성별,
        아바타 저장 이름, 글 내용, 작성일일 조회
*/

/*
    6.  2번째, 3번쨰 입력한 회원의 아이디만 알고 있다는 가정 하에
        각각 방명록 글 등록 처리
*/
