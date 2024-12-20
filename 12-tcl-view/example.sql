/* ========================= [ VIEW ] ========================= */
-- system 계정으로 작업해야 권한 부여 가능
GRANT CREATE VIEW TO scott;
GRANT CREATE VIEW TO ez;

-- 부서번호 별 grouping 한 view 생성
CREATE VIEW dnosal AS
    SELECT deptno dno, max(sal) max, min(sal) min,
        sum(sal) sum, avg(sal) avg, count(*) cnt
    FROM emp GROUP BY deptno;

-- 생성 확인
DESC user_views;
SELECT * FROM user_views WHERE VIEW_NAME = 'DNOSAL';

/*
    사원들의 이름, 부서번호, 부서 최대 급여, 부서원 수 조회
    (dnosal view 이용)
*/
SELECT ename "사원 이름", deptno "부서 번호", max "부서 최대 급여", cnt "부서원 수"
FROM emp e, dnosal v
WHERE e.deptno = v.dno; -- 테이블처럼 이용 가능

-- FORCE CREATE VIEW --
/*
    생성 예정인 게시판 테이블 board의
    글번호, 작성자번호, 글제목, 작성일, 클릭수를 조회하는 view 생성
*/
CREATE OR REPLACE FORCE VIEW brdlist AS
    SELECT bno, bmno, title, wdate, click
    FROM board; -- 컴파일 오류와 함께 뷰가 생성되었다고 한다.

-- view 삭제
DROP VIEW brdlist;