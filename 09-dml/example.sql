/* ========================= [ Create : INSERT ] ========================= */
-- 연습용 테이블 복사 : emp -> smtown
CREATE TABLE smtown AS
SELECT * FROM emp WHERE 1 = 2; -- 테이블 구조만 복사

-- smtown에 태연 사원을 입력해보자.
INSERT INTO smtown
VALUES (
    1001, 'taeyeon', 'vocal', null, sysdate, 805, 309, 40
);

DESC smtown; -- 모든 column에서 null 값을 허용하고 있다. (nullable)

-- 기본값 설정 : 맛보기 포함 --
ALTER TABLE smtown
MODIFY hiredate DEFAULT sysdate; -- 입사일

ALTER TABLE smtown
ADD CONSTRAINT SM_NO_PK PRIMARY KEY(empno); -- 기본키를 설정하여 중복 방지, NULL값 비허용

DESC smtown; -- empno에 PK 제약조건이 걸렸으며, null값을 비허용 하고 있다. (not null)

-- smtown에 써니, 효연 사원을 입력해보자.
INSERT INTO smtown(empno, ename)
-- 입력하지 않은 값은 NULL 처리 된다.
VALUES (1002, 'sunny');

INSERT INTO smtown(ename, empno)
VALUES (
--  1003, 'HYO' -- 입력 순서, 데이터 타입이 맞지 않아 에러 출력
    'HYO', 1003
);

-- smtown에 유리 사원을 입력해보자
INSERT INTO emp1(ename, empno)
VALUES ('yuri', 1004);

/*
    입력 컬럼(field)를 지정하지 않을 경우
    create table 시 지정된 순서대로 입력해야 한다.
    smtown, emp 테이블의 경우
    empno, ename, job, mgr, hiredate, sal, comm, deptno 순서.
*/
INSERT INTO smtown
VALUES (0214, '이수만'); -- 데이터 형식, 순서, 개수 모두 불일치로 에러 발생

-- emp 테이블에서 'KING'의 데이터를 smtown 테이블에 복사할 수 있다.
INSERT INTO smtown (
    SELECT * FROM emp
    WHERE ename = 'KING'
);

/* ========================= [ Update : UPDATE ] ========================= */
-- 임시 테이블 smcnc 생성
CREATE TABLE smcnc AS -- DDL 명령 실행 시엔 별도 commit 불필요
SELECT * FROM smtown;
    
UPDATE emp2
SET job = 'CELEB'; -- 모두의 직급이 'CELEB'으로 바뀐다.

rollback; -- 변경 이력이 초기화된다. (DDL 명령인 create table은 유효)
desc smcnc; -- 원활히 조회되나, job = 'CELEB'이 적용되기 전의 상태이다.

UPDATE smcnc
SET job = 'DANCE'
WHERE ename = 'HYO';

-- 유리의 직급과 급여를 emp 테이블의 SMITH 데이터로 복사해 수정해 본다.
UPDATE smcnc
SET (job, sal) = (
        -- 데이터 확인용 급여 증가
        SELECT job, sal + 300 FROM emp
        WHERE ename = 'SMITH'
    )
WHERE ename = 'yuri';

commit; -- HYO 사원의 직급이 'DANCE'로 변경된다.
select * from smcnc; -- 변경사항이 잘 반영된 것을 확인할 수 있다.

/* ========================= [ Delete : DELETE(DML) & TRUNCATE(DDL) ] ========================= */
DELETE FROM smcnc;   -- 모든 데이터가 한꺼번에 삭제된다.
rollback;   -- DML 명령이기 때문에 복구는 가능하나, DELETE 명령 자체가 권장되지 않는다.

TRUNCATE smcnc; -- 테이블이 '잘렸다' 고 표현된다.

-- TRUNCATE vs DELETE : 성능 & rollback 가능여부
INSERT INTO smcnc VALUES (null, null, null, null, null, null, null, null);

rollback; -- rollback 하여도 아무것도 남아있지 않다.