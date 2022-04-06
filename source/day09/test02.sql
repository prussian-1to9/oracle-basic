-- test02로 접속
CREATE OR REPLACE VIEW showno
AS
    SELECT
        no
    FROM
        test01
;

-- 어드민 권한이 있으니까 다른 user에게 grant도 가능!
GRANT CREATE VIEW TO test01;

-- 하지만 create view에 한해 관리자 권한을 부여받은 것이기에, 다른 권한은 부여 불가.
GRANT SELECT ANY TABLE TO test01;

-- (day09 line 77에서 넘어옴)
-- emp 테이블에서 SELECT 해보자!
SELECT
    *
FROM
    scott.emp       -- 타 계정의 테이블을 쓸 땐 소속을 밝혀줘야 사용 가능!
WHERE
    deptno=10
;

-- ez계정 member 테이블도 SELECT 해보자!
SELECT
    *
FROM
    ez.member
;

-- 실습을 위해 test01에게 줬던 권한 회수
REVOKE CREATE VIEW FROM test01;

-- test01에게 권한을 전파하는 권한까지 포함해,
-- scott.emp 조회 권한을 다시 부여한다.
GRANT SELECT ON scott.emp TO test01 WITH GRANT OPTION;

-- (day09 line 112에서 day02 계정 삭제)
