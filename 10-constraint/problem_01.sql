/* ========================= [ 쿼리 연습 ] ========================= */
/*
    1.  첨부된 테이블 명세서를 이용해 테이블 생성
        (테이블 생성 순서에 유의)
        member  - 회원 테이블
        avatar  - 아바타 테이블

    2.  단, avatar 테이블은 NOT NULL 조건을 테이블 생성 이후에 추가한다.

    NOT NULL 조건 추가 구문 :
        ALTER TABLE tbl_name MODIFY col_name
            CONSTRAINT constraint_name NOT NULL;

    3.  테이블 생성 이후, memeber 테이블의 primary를 제거하고 다시 복구해 본다.
*/
