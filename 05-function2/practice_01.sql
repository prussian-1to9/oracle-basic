/* ========================= [ 쿼리 연습 정답 ] ========================= */
/*
    1.  사원들의 사원 이름, 직급, 한글 직급 조회

    한글 직급 매핑 :
        MANAGER     - 팀장
        SALESMAN    - 영업 사원
        CLERK       - 일반 사원
        PRESIDENT   - 사장
*/
SELECT ename "사원 이름", job 직급,
    DECODE(
    job, 'MANAGER', '팀장', 'SALESMAN', '영업 사원',
    'CLERK', '일반 사원', 'PRESIDENT', '사장', 'ANALYST', '분석가') "한글 직급"
FROM emp;

/*
    2.  사원들의 보너스 조회
        출력 : 사원 이름, 부서 번호, 급여, 보너스

    보너스 계산 :
        부서 별 다음과 같이 처리
        (단, 커미션이 없는 경우 0으로 처리하여 계산)
        10번 부서 - 급여의 10% + 커미션
        20번 부서 - 급여의 15% + 커미션
        30번 부서 - 급여의 30% + 커미션
*/
SELECT
    ename "사원 이름", deptno "부서 번호", sal 급여,
    DECODE(
        deptno,
        10, sal * 1.1, 20, sal * 1.15, 30, sal * 1.3
    ) + NVL(comm, 0) "보너스"
FROM emp
ORDER BY deptno;

/*
    3.  사원들의 사원 이름, 직급, 입사일, 등급 조회
        출력 : 사원 이름, 직급, 입사일, 등급
        (단, 입사일 오름차순 출력)

    등급 매핑 :
        입사년도 별 다음과 같이 처리
            80년 입사       - A등급
            81년 입사       - B등급
            82년 입사       - C등급
            83년 이후 입사  - D등급
*/
SELECT
    ename "사원 이름", job 직급, hiredate 입사일,
    DECODE(
        SUBSTR(hiredate, 0, 2),
        '80', 'A등급', '81', 'B등급', '82', 'C등급', 'D등급'
    ) 등급
FROM emp
ORDER BY hiredate;
-- 다른 풀이
SELECT
    ename "사원 이름", job 직급, hiredate 입사일,
    CASE
        WHEN INSTR(hiredate, '80') > 0 THEN 'A등급'
        WHEN INSTR(hiredate, '81') > 0 THEN 'B등급'
        WHEN INSTR(hiredate, '82') > 0 THEN 'C등급'
        ELSE 'D등급'
    END 등급
FROM emp
ORDER BY hiredate;

/*
    4.  사원들의 사원 이름, 이름 글자 수, 조회 이름 조회
        (단, 이름 글자 수의 오름차순 조회)

    조회 이름 규칙 :
        사원 이름의 글자 수 별 다음과 같이 처리
        4글자   - 이름 앞에 'Mr.' 붙여 조회
        그 외   - 이름 뒤에 '님' 붙여 조회
*/
SELECT ename "사원 이름", LENGTH(ename) "이름 글자 수",
    DECODE(
        LENGTH(ename),
        4, CONCAT('Mr.', ename), CONCAT(ename, ' 님')
    ) "조회 이름"
FROM emp
ORDER BY LENGTH(ename);

/*
    5.  사원들의 사원 이름, 부서 번호, 급여, 커미션, 지급 급여 조회

    지급 급여 계산 :
        부서 번호 별 다음과 같이 처리
        (단, 커미션이 없는 경우 0으로 처리하여 계산)
            10 or 20    - 급여 + 커미션
            그 외       - 급여만
*/
SELECT ename "사원 이름", job 직급, deptno "부서 번호",
    sal 급여, comm 커미션,
    CASE deptno
        WHEN 10 THEN sal + NVL(comm, 0)
        WHEN 20 THEN sal + NVL(comm, 0)
        ELSE sal
    END "지급 급여"
FROM emp
ORDER BY deptno;

/*
    6.  사원들의 입사 요일에 따른 지급 급여 조회
        출력 : 사원 이름, 급여, 입사일, 입사요일, 지급 급여

    지급 급여 계산 :
        입사요일 별 다음과 같이 처리
            주말    - 급여의 20% 인상액
            평일    - 급여의 10% 인상액
*/
SELECT ename "사원 이름", sal 급여, hiredate 입사일,
    TO_CHAR(hiredate, 'DAY') 입사요일,
    CASE TO_CHAR(hiredate, 'DAY')
        WHEN '토요일' THEN sal * 1.2
        WHEN '일요일' THEN sal * 1.2
        ELSE sal * 1.1
    END "지급 급여"
FROM emp;

/*
    7.  사원들의 사원 이름, 커미션, 입사일, 근무 개월 수, 지급 커미션 조회
        (단, 근무 개월 수는 현재 DB 시간을 기준으로 함)

    지급 커미션 계산 :
        근무 개월 수 별 다음과 같이 처리
        (단, 커미션이 없는 사원은 0으로 처리하여 계산)
            490개월 이상 - 500 추가
            490개월 미만 - 현재 커미션만
*/
SELECT ename "사원 이름", comm 커미션, hiredate 입사일,
    FLOOR(sysdate - hiredate) "근무 개월 수",
    CASE
        WHEN FLOOR(sysdate - hiredate) >= 490 * 12 THEN NVL2(comm, comm + 500, 0)
        WHEN FLOOR(sysdate - hiredate) < 490 * 12 THEN NVL(comm, 0)      
    END "지급 커미션"
FROM emp;

/*
    8.  사원들의 사원 이름, 이름 글자 수, 조회 이름 조회

    조회 이름 규칙 :
        사원 이름의 글자수 별 다음과 같이 처리
            5글자 이상  - 이름의 4번쨰 자리 이후 글자를 * 로 표시
            4글자 이하  - 그대로 출력
*/
SELECT ename "사원 이름", LENGTH(ename) "이름 글자 수",
    DECODE(
        FLOOR(LENGTH(ename) / 5),
        0, ename, RPAD(SUBSTR(ename, 0, 3), LENGTH(ename), '*')
    ) "조회 이름"
FROM emp;
