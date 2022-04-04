-- DML (INSERT, UPDATE, DELETE) --

/*
문제 1.
    emp1 테이블에 다음 데이터를 입력하시오.
        이름 : 둘리
        직급 : 머슴
        급여 : 10
        입사일 : 현재시간
*/
INSERT INTO
    emp1(empno, ename, job, hiredate, sal)
VALUES (
    1209, '둘리', '머슴', sysdate, 10
);  --기본 키가 없으면 데이터가 안만들어짐!!
/*
문제 2.
    emp1 테이블에 다음 데이터를 입력하시오.
        이름 : 고길동
        직급 : 애완동물
        입사일 : 2022년 03월 21일
*/
-- 데이터 타입 조정 --
ALTER TABLE emp1
MODIFY job VARCHAR2(15 CHAR);
ALTER TABLE emp1
MODIFY ename VARCHAR2(15 CHAR);

INSERT INTO
    emp1 (empno, ename, job, hiredate)
VALUES (
    1212, '고길동', 'PET', '22/03/21'
);
/*
문제 3.
    emp1테이블에 다음 데이터를 입력하시오.
        이름 : 희동이
        직급 : 대장
        급여 : NULL
        입사일 : 2022년 01월 01
*/

INSERT INTO
    emp1 (empno, ename, job, sal, hiredate)
VALUES (
    1225, '희동이', 'GENERAL', null, '22/01/01'
);
-- 데이터 수정
/*
문제 4.
    emp1 테이블에서 다음 데이터를 수정하시오.
        동런, 잼젠
    사원이 이름 앞에 'Mr.'를 붙여 이름이 만들어지게 수정하시오.
    
    나머지 사원들은 이름앞에 'Miss'이 붙어 만들어지게 수정하시오.
*/
UPDATE
    emp1
SET
    ename=DECODE(ename, 'renjun', 'Mr.'||ename,
        'haechan', 'Mr.'||ename, 'jeno', 'Mr.'||ename,
        'jaemin', 'Mr.'||ename, 'Miss '||ename
    )
;
/*
문제 5.
    emp1 테이블에서, 81년 입사한 사람만 급여를 올린다.
    25%인상을 하며, 10단위 이하는 버림으로 처리하시오.
*/
UPDATE
    emp1
SET
    sal=TRUNC(sal*1.25, -1)
WHERE
    TO_CHAR(hiredate, 'YY')='81'
;
-- 다른 테이블의 데이터 복사 --
/*
문제 6.
    emp 테이블의 'SMITH' 사원의 데이터를 복사해 emp1 테이블에 입력하시오.
*/
INSERT INTO
    emp1
(SELECT
    *
FROM
    emp
WHERE
    ename='SMITH'
);
-- 데이터 삭제 --
/*
문제 7.
    emp1 테이블에서 부서번호 10번인 사원만 삭제하시오.
*/
DELETE
FROM
    emp1
WHERE
    deptno=10
;
/*
문제 8.
    emp1 테이블에서 이름이 'H'로 끝나는 사원만 삭제하시오.
*/
DELETE
FROM
    emp1
WHERE
    ename LIKE '%H'
;