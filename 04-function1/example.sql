/* ========================= [ function : string handling ] ========================= */
-- LENGTH() --
/*
    사원들의 사원 이름, 직급, 급여 조회
    (단, 이름의 길이가 짧은 사람 우선 출력. 같은 길의의 이름이라면 알파벳 오름차순 정렬)
*/
SELECT ename "사원 이름", job 직급, sal 급여
FROM emp
ORDER BY LENGTH(ename), ename;

-- 사원들의 사원 이름, 이름의 문자수 조회
SELECT ename "사원 이름", LENGTH(ename) "이름 문자수"
FROM emp;

-- CONCAT() --
/*
    사원들의 이름, 직급, 급여 조회하시오.
    (단, 출력 형식은 각각 'Mr.이름', '직급 직급', '급여$')
*/
SELECT CONCAT('Mr.',ename) "사원 이름",
    CONCAT(job, ' 직급'), CONCAT(sal, '$') 급여
FROM emp;

-- CHAR(), ASCII() --
SELECT ASCII('buff') 코드값, -- b의 ascii값
    CHR(ASCII('buff')) -- b
FROM dual;

-- SUBSTR() --
SELECT SUBSTR('Hello World!', 1, 5) "문자열 추출" FROM dual;

SELECT SUBSTR('Hello World!', -6, 6) "문자열 추출" FROM dual;

-- INSTR() --
SELECT INSTR ('welcome to my world', 'y', 2, 2) FROM dual; -- 15

-- LPAD() / RPAD() --
/*
    사원들의 이름 조회
    (단, 모두 10글자로 만들고, 빈공간은 *으로 채워 오른쪽/왼쪽 정렬의 두가지 경우 조회)
*/
SELECT LPAD(ename, 10, '*') "오른쪽 정렬", RPAD(ename, 10, '*') "왼쪽 정렬"
FROM emp;

/*
    사원들의 이름 조회
    (단, 이름의 앞 두글자만 표시 후 나머지는 * 처리)
*/    
SELECT
    RPAD(SUBSTR(ename, 1, 2), LENGTH(ename), '*') "꺼내 온 이름",
    ename "원래 이름" -- 비교용
FROM emp;

-- REPLACE() --
SELECT REPLACE('forserver1', 'ser', 'e') "소녀시대 포에버원"
FROM dual;

-- TRIM(), LTRIM(), RTRIM() --
SELECT TRIM(' ' FROM '   girls generation   ') -- 출력 : 'girls generation'
FROM dual;

SELECT LTRIM('ttaeyeontt', 't') "왼쪽 제거", RTRIM('ttaeyeontt', 't') "오른쪽 제거"
FROM dual;
-- 왼쪽 제거 : 'aeyeontt', 오른쪽 제거 : 'ttaeyeon'

-- 종합 --
/*
    'taeyeon@smtown.com' 이라는 메일에서
    ID부분은 세 번째 문자를 제외한 나머지 문자는 '*' 표시하고,
    @ 이후는 @와 .com 외의 부분은 '*' 로 표시해 조회하는 질의 명령을 작성하시오.
*/
SELECT
    CONCAT(CONCAT(LPAD(SUBSTR('taeyeon@smtown.com', 3, 1), 3, '*'),
    
    LPAD(SUBSTR('taeyeon@smtown.com', INSTR('taeyeon@smtown.com', '@'), 1),
    LENGTH(SUBSTR('taeyeon@smtown.com', 4, INSTR('taeyeon@smtown.com', '@') - 3)), '*')),
    
    LPAD(SUBSTR('taeyeon@smtown.com', -4, 4),
    (LENGTH('taeyeon@smtown.com')-INSTR('taeyeon@smtown.com', '@')), '*'))
    
FROM dual;

-- 모범답안
SELECT
    CONCAT(CONCAT(RPAD(LPAD(SUBSTR('taeyeon@smtown.com', 3, 1), 3, '*'),
    INSTR('taeyeon@smtown.com', '@')-1, '*'), '@'),
    LPAD(
        SUBSTR('taeyeon@smtown.com', INSTR('taeyeon@smtown.com', '.com')),
        LENGTH('taeyeon@smtown.com') - (INSTR('taeyeon@smtown.com', '@') - 1), '*')
    ) "태연 메일"
FROM dual;

/* ========================= [ function : number handling ] ========================= */
-- ABS() --
SELECT ABS(-3.14) pi FROM dual;

-- TRUNC() --
SELECT TRUNC(3.14) FROM dual;

-- MOD() --
SELECT MOD(10, 3) "10을 3으로 나눈 나머지" FROM dual;

-- 종합 --
-- 사원들의 15% 인상된 급여 조회
SELECT ename "사원 이름", sal 원급여,
    (sal * 1.15) 계산값, ROUND(sal * 1.15) "인상 급여",
    FLOOR(sal * 1.15) 버림함수, TRUNC(sal * 1.15, -1) "자릿수 지정 버림"
FROM emp;

/*
    사원들 중 급여가 짝수인 사원의
    사원 이름, 직급, 급여 조회
*/
SELECT ename "사원 이름", job 직급, sal 급여
FROM emp
WHERE MOD(sal, 2) = 0;

/* ========================= [ 이후 토픽 맛보기 ] ========================= */
-- COUNT() --
-- 10번 부서 사원들의 사원 수 조회
SELECT count(*) "사원 수"
FROM emp
WHERE deptno = 10;

-- 커미션이 없는 사원들의 수 조회
SELECT count(*) "커미션 없는 사원 수"
FROM emp
WHERE comm IS NULL;

/*
    NULL 데이터는 모든 연산에서 제외되며,
    count() 함수에서도 미집계 처리된다.
*/
SELECT (count(*) - count(comm)) "커미션 없는 사원 수"
FROM emp;