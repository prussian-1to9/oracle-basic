/* ========================= [ 쿼리 연습 정답 ] ========================= */
/*
    1.  test01 계정에 view 생성 권한, 접속 권한과 관리자 권한 부여
        (test01 계정이 존재하지 않다면 생성, 암호 자유)
*/
CREATE USER test01 IDENTIFIED BY test01;
GRANT CREATE VIEW, CONNECT, CREATE SESSION TO test01 WITH ADMIN OPTION;

/*
    2.  test_01 계정에게 모든 테이블 조회 권한 부여 후
        test01 계정 접속, test01 계정에 test_view 생성

        test_view   : emp, dept 테이블을 natural join한 결과
*/
GRANT SELECT ANY TABLE TO test01;

-- CONNECT test01/test01; -- IDE 환경 별 유저 변환 조건 상이하므로 주석처리

CREATE OR REPLACE VIEW test_view
AS SELECT * FROM scott.emp NATURAL JOIN scott.dept;

/*
    3.  test_01 계정에서 아래의 쿼리 실행
            - 10번 부서에 속한 사원들의 모든 정보 조회
            - ez.member 테이블의 모든 회원 정보 조회
*/
SELECT * from scott.emp WHERE deptno = 10;

SELECT * FROM ez.member;

/*
    4.  test01 계정에게 부여한 view 생성 권한 회수 후
        권한을 전파하는 권한까지 포함하여 scott.emp 조회 권한 부여
*/
-- system 계정으로 실행
REVOKE CREATE VIEW FROM test01;
GRANT SELECT ON scott.emp TO test01 WITH GRANT OPTION;

/*
    5.  scott 계정에서 ez계정에게 emp 테이블 조회 권한을 부여하고,
        ez 계정에서 emp 테이블 조회
*/
GRANT SELECT ON scott.emp TO ez;
-- ez 계정으로 실행
SELECT * FROM scott.emp;

/*
    6.  아래의 내용 수행

        i.  system 계정에서 ez 계정에게 동의어, 공용 동의어 생성 권한을 부여하고,
        ii. scott.emp 테이블에 대한 동의어, 공용 동의어를 각각 생성
            (동의어 이름 형식은 자유)

        iii.test01 계정으로 공용 동의어를 사용하여 emp 테이블 조회
            (동의어 조회 권한이 없다면 별도 부여)
*/
GRANT CREATE SYNONYM, CREATE PUBLIC SYNONYM TO ez;
CREATE SYNONYM emp_syn
FOR scott.emp;

CREATE PUBLIC SYNONYM emp_pub
FOR scott.emp;

-- 모두에게 열람 권한 부여
GRANT SELECT ON emp_pub TO PUBLIC;
-- test01 계정으로 실행
SELECT * FROM emp_pub;