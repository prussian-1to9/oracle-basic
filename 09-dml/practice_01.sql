/* ========================= [ 쿼리 연습 정답 ] ========================= */
-- example.sql의 명령, 아래의 명령 실행 후 문제풀이
drop table if EXISTS tmp;
create table tmp as select * from emp where 1 = 2;
alter table tmp modify job varchar2(15 char);
alter table tmp modify ename varchar2(15 char);

-- 데이터 입력 --
/*
    1.  tmp 테이블에 다음 데이터를 입력
        (기본키는 임의 설정)

        이름    - '둘리'
        직급    - '머슴'
        급여    - 10
        입사일  - 현재시간
*/
INSERT INTO tmp(empno, ename, job, hiredate, sal)
VALUES (1101, '둘리', '머슴', sysdate, 10);

/*
    2.  tmp 테이블에 다음 데이터를 입력
        (기본키는 임의 설정)

        이름    - 고길동
        직급    - 애완동물
        입사일  - 2022년 03월 21일
*/
INSERT INTO tmp (empno, ename, job, hiredate)
VALUES (1102, '고길동', '애완동물', '22/03/21');

/*
    3.  tmp 테이블에 다음 데이터를 입력
        (기본키는 임의 설정)

        이름    - 희동이
        직급    - 대장
        급여    - NULL
        입사일  - 2022년 01월 01
*/
INSERT INTO tmp (empno, ename, job, sal, hiredate)
VALUES (1103, '희동이', 'GENERAL', null, '22/01/01');

-- 데이터 수정 --
/*
    4.  smtown 테이블에서 다음 데이터를 수정
        - taeyeon, sunny 사원   : 이름 앞에 '[GG]'를 붙여 이름 수정
        - 나머지 사원들         : 이름 앞에 '[SMTOWN]'을 붙여 이름 수정
*/
UPDATE smtown
SET ename = DECODE(ename,
    'taeyeon', '[GG]'|| ename, 'sunny', '[GG]' || ename,
    '[SMTOWN]' || ename
);

/*
    5.  smwtown 테이블에서 81년 입사한 사원들의
        급여를 25% 인상하여 수정
        (단, 10단위 이하는 버림 처리)
*/
UPDATE smtown
SET sal = TRUNC(sal * 1.25, -1)
WHERE TO_CHAR(hiredate, 'YY') = '81';

-- 데이터 복사 --
/*
    6.  emp 테이블의 'SMITH' 사원의 데이터를 복사하여
        tmp 테이블에 입력
*/
INSERT INTO tmp (
    SELECT * FROM emp
    WHERE ename = 'SMITH'
);

-- 데이터 삭제 --
--  7.  tmp 테이블에서 부서번호가 10번인 사원들만 삭제
DELETE FROM tmp
WHERE deptno = 10;

--  8.  tmp 테이블에서 이름이 'H'로 끝나는 사원만 삭제
DELETE FROM tmp
where ename LIKE '%H';