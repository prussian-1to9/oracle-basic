-- 기타 함수로 처리 --

/*
문제 1.
    사원들의
        사원 이름, 직급, 한글 직급 을 조회하시오.
        
    MANAGER : 팀장, SALESMAN : 영업 사원, CLERK : 일반 사원, PRESIDENT : 사장   */
SELECT
    ename "사원 이름", job 직급,
    DECODE(
    job, 'MANAGER', '팀장', 'SALESMAN', '영업 사원',
    'CLERK', '일반 사원', 'PRESIDENT', '사장', 'ANALYST', '분석가') "한글 직급"
FROM
    emp;
/*
문제 2.
    각 부서별 이번달 보너스를 조회하시오.
    보너스는
    10번 부서 : 급여의 10%
    20번 부서 : 급여의 15%
    30번 부서 : 급여의 30%
    이다.
    
    급여와 커미션을 더해 지급되며, 커미션이 없는 사원은 0으로 계산해 처리하시오.
    
    출력 내용 : 사원 이름, 부서번호, 급여, 지급 급여  */
SELECT
    ename "사원 이름", deptno "부서 번호", sal 급여,
    DECODE(deptno, 10, sal*0.1, 20, sal*0.15, 30, sal*0.3)
    +sal+NVL(comm, 0) "지급 급여"
FROM
    emp
ORDER BY
    deptno;
/*
문제 3.
    입사년도를 기준으로
        80년도 : A등급
        81년도 : B등급
        82년도 : C등급
        
    그 이후 입사한 사원들은 D등급으로 조회되게 하시오.
    
    출력 내용 : 사원 이름, 직급, 입사일, 등급  */
SELECT
    ename "사원 이름", job 직급, hiredate 입사일,
/*    CASE WHEN INSTR(hiredate, '80')>0 THEN 'A등급'
    WHEN INSTR(hiredate, '81')>0 THEN 'B등급'
    WHEN INSTR(hiredate, '82')>0 THEN 'C등급'
    ELSE 'D등급'
    END 등급      */
    DECODE(SUBSTR(hiredate, 0, 2),
    '80', 'A등급', '81', 'B등급', '82', 'C등급', 'D등급')
FROM
    emp
ORDER BY
    hiredate;
/*
문제 4.
    사원 이름이 4글자면 이름 앞에 'Mr.'를 붙이고,
    4글자가 아니면 뒤에 '님'을 붙여 조회되게 하시오.
    
    출력 내용 : 사원 이름, 이름 글자수, 조회 이름    */
SELECT
    ename "사원 이름", LENGTH(ename) "이름 글자 수",
    DECODE(LENGTH(ename), 
    4, CONCAT('Mr.', ename), CONCAT(ename, ' 님'))"조회 이름"
FROM
    emp
ORDER BY
    LENGTH(ename);
/*
문제 5.
    부서번호가 10 or 20 : 급여+커미션 으로 지급하고
    그 외의 부서는 급여만 지급하려고 한다.
    커미션이 없는 경우, 0으로 대체하여 지급한다.
    
    출력 내용 : 사원 이름, 직급, 부서번호, 급여, 커미션, 지급 급여 */
SELECT
    ename "사원 이름", job 직급, deptno "부서 번호", sal 급여, comm 커미션,
    CASE deptno
        WHEN 10 THEN sal+NVL(comm, 0)
        WHEN 20 THEN sal+NVL(comm, 0)
        ELSE sal
        END "지급 급여"
FROM
    emp
ORDER BY
    deptno;
/*
문제 6.
    입사요일이 주말인 사원은 급여의 20%,
    평일인 사원은 급여의 10%를 더해 지급하려고 한다.
    
    출력 내용 : 사원 이름, 급여, 입사일, 입사요일, 지급 급여
*/
SELECT
    ename "사원 이름", sal 급여, hiredate 입사일,
    TO_CHAR(hiredate, 'DAY') 입사요일,
    CASE TO_CHAR(hiredate, 'DAY')
        WHEN '토요일' THEN sal*1.2
        WHEN '일요일' THEN sal*1.2
        ELSE sal*1.1
        END "지급 급여"
FROM
    emp;
/*
문제 7.
    근무 개월 수가 490개월 이상인 사원은 500 추가,
    490개월 미만인 사원은 현재 커미션만 지급할 예정이다.
    커미션이 없는 사원은 0으로 계산한다.
    
    출력 내용 : 사원 이름, 커미션, 입사일, 근무 개월 수, 지급 커미션
*/
SELECT
    ename "사원 이름", comm 커미션, hiredate 입사일,
    FLOOR(sysdate-hiredate) "근무 개월 수",
    CASE WHEN
        FLOOR(sysdate-hiredate)>=490*12 THEN NVL2(comm, comm+500, 0)
   WHEN FLOOR(sysdate-hiredate)<490*12 THEN NVL(comm, 0)      
        END "지급 커미션"
FROM
    emp;
/*
문제 8.
    이름 글자 수가 5글자 이상인 사원은 이름을 네번째 자리 이후 글자를 *로 표시하고,
    4글자 이하인 사원은 그대로 출력할 예정이다.
    
    출력 내용 : 사원 이름, 이름 글자수, 조회 이름
*/
SELECT
    ename "사원 이름", LENGTH(ename) "이름 글자 수",
    DECODE(FLOOR(LENGTH(ename)/5),
    0, ename,
    RPAD(SUBSTR(ename, 0, 3), LENGTH(ename), '*')) "조회 이름"
FROM
    emp;

--------------------------------------------------------------------------------
-- group by

/*
문제 1.
    각 부서별 최소 급여를 조회하시오.
    출력 내용 : 부서번호, 최소 급여
*/
SELECT
    deptno "부서 번호", MIN(sal)"최소 급여"
FROM
    emp
GROUP BY
    deptno;
/*
문제 2.
    각 직급별 급여의 총액과 평균 급여를 직급과 함께 조회하시오.
*/
SELECT
    job 직급, SUM(sal) "총 급여", ROUND(AVG(sal), 1) "평균 급여"
FROM
    emp
GROUP BY
    job;
/*
문제 3.
    입사 년도별 평균 급여와 총 급여를 조회하시오.
*/
SELECT
    SUBSTR(hiredate, 0,2)||'년도' "입사 년도",
    AVG(sal) "평균 급여", SUM(sal) "총 급여"
FROM
    emp
GROUP BY
   SUBSTR(hiredate, 0,2)
ORDER BY
    SUBSTR(hiredate, 0,2);
/*
문제 4.
    각 년도마다 입사한 사원 수를 조회하시오.
*/
SELECT
    SUBSTR(hiredate, 0,2)||'년도' "입사 년도",
    COUNT(*) "입사 사원 수"
FROM
    emp
GROUP BY
    SUBSTR(hiredate, 0,2);
/*
문제 5.
    이름 글자수를 기준으로 그룹화 하여 조회하려고 한다.
    글자수가 4, 5글자인 사원의 수를 조회하시오.
*/
SELECT
    LENGTH(ename)||'글자' "이름 글자수", COUNT(*) 사원수
FROM
    emp
GROUP BY
    LENGTH(ename)
HAVING
    LENGTH(ename)=4 OR LENGTH(ename)=5;
/*
문제 6.
    81년도에 입사한 사원의 수를 직급별로 조회하시오.
*/
SELECT
    job 직급, COUNT(*) "사원 수"
FROM
    emp
WHERE
    INSTR(hiredate, '81')>0
GROUP BY
    job;
/*
문제 7.
    이름 글자수가 4, 5글자인 사원의 수를 부서별로 조회하시오.
    단, 사원수가 한사람 이하인 부서는 조회에서 제외하시오.
*/
SELECT
    deptno "부서 번호", LENGTH(ename)||'글자' "이름 글자 수",
    COUNT(*) 사원수
FROM
    emp
WHERE
    LENGTH(ename)=4 OR LENGTH(ename)=5
GROUP BY
    deptno, LENGTH(ename)
HAVING
    COUNT(*)>1;
/*
문제 8.
    81년도 입사한 사원의 전체 급여를 직급별로 조회하시오.
    단, 직급별 평균 급여가 1000 미만인 직급은 조회에서 제외하시오.
*/
SELECT
    job 직급, SUM(sal) "전체 급여"
FROM
    emp
WHERE
    INSTR(hiredate, '81')>0
GROUP BY
    job
HAVING
    SUM(sal)>1000;
/*
문제 9.
    81년도 입사한 사원의 총 급여를 구하시오.
    사원 이름의 글자수 대로 그룹화 해 조회하시오.
    
    단, 총 급여가 2000 미만인 경우는 조회에서 제외하고,
    총 급여를 내림차순으로 조회되게 하시오.
*/
SELECT
    LENGTH(ename)||'글자' "이름 글자 수", SUM(sal) "총 급여"
FROM
    emp
WHERE
    INSTR(hiredate, '81')>0
GROUP BY
    LENGTH(ename)
HAVING
    SUM(sal)>=2000
ORDER BY
    SUM(sal) DESC;
/*
문제 10.
    이름 길이가 4, 5글자인 사원의 부서별 사원수를 조회하시오.
    단, 사원 수가 0인 경우는 조회 결과에서 제외하고,
    부서 번호대로 조회되도록 하시오.
*/
SELECT
    deptno "부서 번호", COUNT(*) 사원수
FROM
    emp
WHERE
    LENGTH(ename)=4 OR LENGTH(ename)=5
GROUP BY
    deptno
HAVING
    COUNT(*)>0
ORDER BY
    deptno;