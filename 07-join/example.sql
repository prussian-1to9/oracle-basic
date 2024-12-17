/* ========================= [ join basic : cross join 예시 ] ========================= */
-- 아직 배우지 않은 구문들도 많으나, 예시를 통해 cross join을 이해해 본다.
-- 생성할 테이블이 존재하면 삭제 --
DROP TABLE IF EXISTS ecolor;
DROP TABLE IF EXISTS kcolor;

-- 테이블 생성 --
CREATE TABLE ecolor (   -- 영문 색상이름 테이블
    ceno NUMBER(3)      -- 영문 color 일련번호 : 세자리 숫자
        CONSTRAINT ECLR_NO_PK PRIMARY KEY, -- key 설정
    code VARCHAR2(7)    -- color 코드 값
        CONSTRAINT ECLR_CODE_UK UNIQUE -- oracle엔 '객체'로 등록되는 것들
        CONSTRAINT ECLR_CODE_NN NOT NULL,
    name VARCHAR2(20)
        CONSTRAINT ECLR_NAME_NN NOT NULL
);
CREATE TABLE kcolor (   -- 한글 색상이름 테이블 생성
    ckno NUMBER(3)
        CONSTRAINT KCLR_NO_PK PRIMARY KEY,
    code VARCHAR2(7)
        CONSTRAINT KCLR_CODE_UK UNIQUE
        CONSTRAINT KLCR_CODE_NN NOT NULL,
    name VARCHAR2(20)
        CONSTRAINT KCLR_NAME_NN NOT NULL
);

-- 데이터 추가
INSERT INTO ecolor
VALUES
(100, '#FF0000', 'red'),
(101, '#00FF00', 'green'),
(102, '#0000FF', 'blue'),
(103, '#800080', 'purple');

INSERT INTO kcolor
VALUES
(100, '#FF0000', '빨강'),
(101, '#00FF00', '초록'),
(102, '#0000FF', '파랑');

-- 영문 color 테이블 조회
SELECT * FROM ecolor;

COMMIT; -- 메모리의 작업 영역에서 작업한 DML 내용을 DB에 적용.

-- 데이터 조회
SELECT * FROM kcolor;

-- 두개를 이어서 추출한다면 : 정확하지 않은 데이터가 3분의 2
SELECT * FROM ecolor, kcolor;
-- 정확한 join을 위해서는 조건을 지정해 줘야 한다.

/* ========================= [ join basic : 예시 ] ========================= */
-- cross join에서 사용한 예시 테이블을 이용함.
-- 1. inner join --
SELECT ceno cno, e.code, e.name ename, k.name kname
FROM ecolor e, kcolor k  -- 별칭 구분
WHERE e.code = k.code; -- join 조건(equi join)
-- 기재되지 않은 103번은 출력되지 않음

-- 2. outer join --
SELECT ceno cno, e.code, e.name ename, k.name kname
FROM ecolor e, kcolor k
WHERE e.code = k.code(+); -- 기재되지 않은 103번은 null 값으로 출력됨

-- 3. self join --
-- 사원들의 사원 이름, 상사의 사번, 상사이름, 상사 급여 조회
CREATE table emp_super
as select * from emp;

SELECT e.ename "사원 이름", e.deptno "상사 사번",
    s.ename "상사 이름", e.sal "상사 급여"
FROM emp e, emp_super s
WHERE s.empno (+) = e.mgr; -- outer join(equi join) 혼용

-- 4. natural join --
-- 사원들의 사원 이름, 부서 이름 조회
SELECT ename "사원 이름", dname "부서 이름"
FROM emp NATURAL JOIN dept;

-- 5. using join --
-- 테스트용 cross join 테이블 생성
DROP TABLE IF EXISTS tmp;
CREATE TABLE tmp AS
SELECT e.*, dname FROM emp e, dept d
WHERE e.deptno = d.deptno;

/*
    tmp 테이블 부서정보 테이블을 이용해
    사원들의 사원이름, 부서위치 조회
*/
SELECT ename, loc
FROM tmp JOIN dept
USING (deptno);

/* ========================= [ join basic : 연습 ] ========================= */
-- non eq join : 사원들의 사원 이름, 직급, 급여, 급여 등급 조회
SELECT ename "사원 이름", job 직급, sal 급여, grade "급여 등급"
FROM emp, salgrade -- 이름이 겹치는 column X : 별칭 사용 X
WHERE sal BETWEEN losal AND hisal;

-- eq join : 사원들의 사번, 사원 이름, 직급, 부서 이름, 부서 위치 조회
SELECT empno 사번, ename "사원 이름", job 직급, dname "부서 이름", loc "부서 위치"
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- 81년 입사한 사원들의 이름, 직급, 입사년도, 부서 이름 조회
SELECT ename "사원 이름", job 직급,
    TO_CHAR(hiredate, 'YYYY"년"MM"월"DD"일"') 입사일, dname "부서 이름"
FROM emp, dept
WHERE emp.deptno = dept.deptno          -- join 조건 : 테이블 이름을 직접 기재 가능(oracle)
    AND TO_CHAR(hiredate, 'YY') = '81'; -- 일반 필터링 조건

/* ========================= [ ansi join ] ========================= */
-- CROSS JOIN --
-- 사원 정보와 부서정보 테이블을 cross join
SELECT * FROM emp CROSS JOIN dept; -- cartesian product(곱집합)가 생성됨
    
-- INNER JOIN --
-- 사원들의 이름, 직급, 부서번호, 부서 이름을 조회
SELECT ename "사원 이름", job 직급, e.deptno "부서 번호", dname "부서 이름"
FROM emp e INNER JOIN dept d
    ON e.deptno = d.deptno; -- join 조건

-- 81년 입사한 사원들의 이름, 직급, 입사년도, 부서 이름 조회
SELECT ename "사원 이름", job 직급,
    TO_CHAR(hiredate, 'YY') "입사 년도", dname "부서 이름"
FROM emp e INNER JOIN dept d
    ON e.deptno = d.deptno -- join 조건
WHERE TO_CHAR(hiredate, 'YY') = 81;  -- 일반 조건

-- 사원들의 사원 이름, 상사 이름 조회
SELECT e.ename "사원 이름", s.ename "상사 이름"
FROM emp e INNER jOIN emp s
ON e.mgr = s.empno;
-- inner join으로 설정했기 때문에
-- 상사가 없는(NULL) KING 사원은 출력되지 않음

-- OUTER JOIN --
-- 사원들의 사원 이름, 상사 이름 조회
SELECT e.ename "사원 이름", NVL(s.ename, '상사 없음') "상사 이름"
-- 방향은 데이터의 기준을 의미
-- 이 경우 'e'라는 alias를 가진 emp 테이블이 기준이 된다.
FROM emp e LEFT OUTER JOIN emp s
    ON e.mgr = s.empno; -- 상사가 없는 KING 사원도 출력됨

-- 사원들의 사원 이름, 부서이름, 급여, 급여 등급 조회
SELECT ename "사원 이름", dname "부서 이름" , sal 급여, grade "급여 등급"
FROM emp e JOIN dept d
    ON e.deptno = d.deptno
JOIN salgrade
    ON e.sal BETWEEN losal AND hisal;