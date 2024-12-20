/*
    ========================= [ 아래 쿼리 실행 후 실습 진행 ] =========================
    10-constraint 토픽의 연습문제에서 생성한 avatar 테이블을 사용하므로
    avatar 테이블이 존재하지 않는다면 해당 토픽의 practice_01.sql 실행을 권장
*/
-- avatar 테이블 데이터 추가
INSERT INTO avatar
VALUES
    (10, 'noimage', 'noimage.jpg', 'noimage.jpg', '/img/avatar/', 6000, 'N', sysdate, 'Y'),
    (11, 'man1', 'img_avatar1.png', 'img.avatar1.png', '/img/avatar/', 8000, 'M', sysdate, 'Y'),
    (12, 'man2', 'img_avatar2.png', 'img.avatar2.png', '/img/avatar/', 8000, 'M', sysdate, 'Y'),
    (13, 'man4', 'img_avatar3.png', 'img.avatar3.png', '/img/avatar/', 8000, 'M', sysdate, 'Y'),
    (14, 'woman1', 'img_avatar4.png', 'img.avatar4.png', '/img/avatar/', 8000, 'F', sysdate, 'Y'),
    (15, 'woman2', 'img_avatar5.png', 'img.avatar5.png', '/img/avatar/', 8000, 'F', sysdate, 'Y'),
    (16, 'woman3', 'img_avatar6.png', 'img.avatar6.png', '/img/avatar/', 8000, 'F', sysdate, 'Y');



/* ========================= [ SEQUENCE ] ========================= */
-- 1부터 시작해 1씩 증가해, 최대 10까지 증가하는 시퀀스 생성
CREATE SEQUENCE test_seq
--  START WITH 1    -- default 값과 동일하여 생략
--  INCREMENT BY 1  -- default 값과 동일하여 생략
    MAXVALUE 10;

-- 시퀀스의 현재값 조회 시도
SELECT test_seq.CURRVAL FROM dual;  -- 오류 발생(CURRVAL은 NEXTVAL 호출 후에만 사용 가능)

-- 시퀀스의 다음값 조회 및 현재값 조회
-- NEXTVAL 호출 시 CURRVAL에 기억되어 조회 가능
SELECT test_seq.NEXTVAL 다음번호, test_seq.CURRVAL 마지막번호
FROM dual;

-- 반복하여 확인해본다.
SELECT test_seq.CURRVAL FROM dual; -- 1 (유지)

SELECT test_seq.NEXTVAL FROM dual; -- 2 (증가)

SELECT test_seq.CURRVAL FROM dual; -- 2 (유지)

