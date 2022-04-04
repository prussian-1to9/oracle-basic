-- 계층형 질의 (oracle에서만 사용 가능) --
/*
    댓글형 게시판의 경우
    목록을 꺼내올 때, 상위글 바로 다음에 해당 글의 댓글이 조회되어야 한다.
    
    oracle의 경우, 계층형 결과를 볼 수 있느 문법을 만들어 제공해 주고 있다.
    
    형식
        SELECT ~ FROM
        START WITH
            계층추적시작값...
        CONNECT BY
            계층추적조건
        ORDER SIBLINGS BY           order by 사이에 들어가는 거임~
            계층간정렬...
            
        + PRIOR
          이전이라는 의미로, 이전 계층을 의미.
*/
SELECT
    empno, ename, job, mgr, LEVEL, hiredate
FROM
    emp
START WITH
    mgr IS NULL -- 상사가 없는 사원이 1, 점점 값이 늘어남.
CONNECT BY
    mgr = PRIOR empno   -- 상사 사번과 이전 계층이 일치하는 값이 있다면 LEVEL++
ORDER SIBLINGS BY
    hiredate DESC    -- 등급이 같으면 입사 순서 내림차순 정렬
;

--------------------------------------------------------------------------------
/*
    CRUD
    ==> 데이터를 다루는 명령의 약자.
    
    DML 명령을 사용할 수 있는지를 이야기하는 것이 된다.
    
    우리가 배운 명령은 모두 CRUD 중 R에 해당하는 SELECT 질의 명령 뿐인데,
    약자들의 풀이는 다음과 같다.
    
        Create  : INSERT 명령
        Read    : SELECT 명령
        Update  : UPDATE 명령
        Delete  : DELETE 명령
        
    1. INSERT 명령
    ==> 이미 만들어진 테이블에 데이터를 추가하는 명령.
    
        INSERT INTO
            테이블이름[(필드이름1, 필드이름2, . . . .)]
        VALUES(
            필드이름 지정 : 필드 나열 순서대로 데이터 입력
            필드이름 미지정 : 모든 필드의 데이터 입력
        )
*/

-- 연습용 테이블 복사
-- emp 테이블을 구조만 복사해서 emp1으로 만듭시다.
CREATE TABLE emp1
AS
    SELECT * FROM emp WHERE 1=2;
    
-- emp1에 런쥔 사원을 입력해보자.
INSERT INTO
    emp1
VALUES (
    1001, 'renjun', 'vocal', null, sysdate, 825, 323, 40
);

DESC emp1; -- 모든 column에서 null 값을 허용한다.

-- 기본값 설정 --
ALTER TABLE emp1
MODIFY hiredate DEFAULT sysdate; -- 입사일

ALTER TABLE emp1
ADD CONSTRAINT EMP1_NO_PK PRIMARY KEY(empno);

DESC emp1;

-- emp1에 해찬 사원을 입력해보자.
INSERT INTO
    emp1(empno, ename)
VALUES (
    1002, 'haechan' -- 입력하지 않은 값은 null 처리 된다.
);

-- emp1에 제노 사원을 입력해보자.
INSERT INTO
    emp1(ename, empno)
VALUES (
--  1003, '제노'  입력 순서 맞지 않아 오류 뜸.
    'jeno', 1003
);

-- emp1에 재민 사원을 입력해보자
INSERT INTO
    emp1(ename, empno)
VALUES (
    'jaemin', 1004
);

INSERT INTO
    emp1    --> 미기입시 emp1(empno, ename, job, mgr,
            --  hiredate, sal, comm, deptno) 와 같아짐.
VALUES (
    0214, '이수만'     ---> 형식이 지정되지 않아 오류.
);

/*
    ***** DDL명령은 메모리 상에 확보한 세션공간에서만 작업이 이루어진다.
            (명령의 종류는 line 243에서 후술)
          -> DB에 적용은 안되어 있는 상태.
             작업 내용을 DB에 적용되길 원한다면 commint 이 필요함.
*/

-- emp에서 'KING'의 데이터를 emp1 테이블에 복사해보자!
INSERT INTO
    emp1
    
(
    SELECT
        *
    FROM
        emp
    WHERE
        ename='KING'
);

--------------------------------------------------------------------------------
/*
    2. UPDATE
    ==> 기존 데이터의 내용을 수정하는 명령
    
        UPDATE
            테이블이름
        SET
            필드이름=데이터, 필드이름=데이터 . . . .(필요한 만큼)
        [WHERE
            조건식]        --> 조건식이 없는 경우, 모든 데이터를 같은 내용으로 수정
        ;
*/
CREATE TABLE emp2   --> DML 소속 명령은 실행시 여태까지의 내용을 auto-commit 해줌.
AS
    SELECT * FROM emp1;
    
UPDATE
    emp2
SET
    job='NCT DREAM' --> 모두의 직급이 엔드림으로 바뀌었다.
;

rollback; --> 되돌리기

UPDATE
    emp2
SET
    job='VISUAL'
WHERE
    ename='jaemin';
    
commit; -- 한번 커밋해 줍시다.

/*
    sub query를 이용해 데이터를 수정할 수 있다.
    이 때, 여러개의 필드를 꺼내 질의명령의 결과로 대체하고자 한다면
    
    UPDATE
    
    SET
        (필드1, 필드2) = (
            SELECT
                꺼낼필드1, 꺼낼필드2
            FROM
                테이블이름
            WHERE
                조건식
        )
    WHERE
        조건식
        
      + 수정을 원하지 않는 데이터지만 어쩔 수 없이 UPDATE명령을 사용해야 한다면?
        SET 이후 오는 부분을
            필드=필드       로 해주면 데이터가 유지된다. (순서 무관)
*/

-- 제노의 직급과 급여를 emp 테이블의 SMITH 데이터로 복사해 수정하시오.
UPDATE
    emp2
SET
    (job, sal)=(
        SELECT
            job, sal+300
        FROM
            emp
        WHERE
            ename='SMITH'
    )
WHERE
    ename='jeno'
;

--------------------------------------------------------------------------------
/*
    3. DELETE
    ==> 현재 테이터 중, 불필요한 데이터를 삭제하는 명령.
        (row 하나를 통째로 날려버린다~~!)
        
        DELETE
        FROM
            테이블이름
        [WHERE
            조건식]
            
    *** 조건식 미기입 시, 테이블 하나의 내용 전체가 날아가버린다~~!!! (어마무시)
    
      + 이 명령은 웬만해선 사용하지 않을 것이 권장된다.
        -> 현업에선
            isShow CHAR(1)라는 필드를 준비해 두고,
        
                기본 값은           'Y' (노출되는 필드)
                삭제가 필요한 값은  'N' (비공개되는 필드)
        
            로 데이터를 수정한다. 그리고 조회 질의 명령에선 반드시
            WHERE
                isShow='Y'  를 추가하여 조회한다.
            
            이 때, Y와 N을 제외한 다른 글자가 들어올 경우를 대비해
            check명령을 사용하는데, 언젠가 언급하겠다.
*/
DELETE FROM emp2;   -- 5개 행이 한꺼번에 날아가 버린다!!
rollback;   -- 복구

--------------------------------------------------------------------------------
/*
    ~ 쉬어가기 ~
    테이블 설계
        
      - oracle은 정형DB!
        oracle은 어떤 데이터를 기억할지 정해 놓고, (정규화 데이터)
        그 규격에 맞는 데이터만 기억하도록 한다.
        
    DB 설계 과정
        
        1. 개념적 설계
        ==> 추상적인 개념 설계
            개념적 데이터 모델을 만든다.
        
        2. 논리적 설계
        ==> 개념적 데이터 모델을 기반으로
            물리적 저장장치에 저장할 수 있도록
            특정 DB가 지원하는 논리적인 자료구조로 변환.
            
            데이터타입과 데이터들간의 관계가 여기서 표현된다.
            
            ER-D, 테이블 명세서   가 결과로 도출 될 수 있다.
        
        3. 물리적 설계
        ==> 논리적 설계의 결과를 물리적으로 구현한다.
            (= DDL 질의명령 작성)
            
            SQL 문서  가 결과로 도출될 수 있다.
        
    정규화 과정
        
        1. 제1 정규화
        ==> entity가 갖는 속성은 원자값을 가져야 한다.
            (다른 형태로 나눌 수 없어야 한다.)
            
            제 1 정규형     이 결과로 도출될 수 있다.
            
        2. 제2 정규화
        ==> 기본 키에 대해 모든 키는 완전 함수 종속이여야 한다.
            
            뭔말이냐?
                기본 키 : 특정 row를 구분할 수 있는 데이터.
                완전 함수 종속 : 기본키를 알면 특정 row를 꺼낼 수 있는 상태.
            기본키 정해주라는거임~
                
            제 2 정규형     이 결과로 도출될 수 있다.
            
        3. 제3 정규화
        ==> 이행적 함수 종속에서 벗어나야 한다.
            
            이행적 함수 종속?
            특정 필드의 데이터을 알면
            같은 row, 다른 필드의 데이터들도 연계되어 결정되는 상태.
        
        4. BCNF 정규화
        5. 제4 정규화       --> 실무에서도 안쓴대용.
        
        ...더보기
--------------------------------------------------------------------------------
        
    DB 명령의 종류
    
        1. DML
        ==> CRUD (SELECT는 query라고 따로 부르기도 한다.)
        
        2. DDL (Data Definition Language)
        ==> 데이터 자체가 아닌, 테이블의 구조적인 것에 대해 작업할 때 사용.
            (DB 개체에 관련된 명령, 명령 즉시 auto-commit 되며, rollback 불가.)
            
            CREATE / ALTER  : 개체 생성 / 수정
            DROP            : 개체 삭제
            TRUNCATE        : 테이블 내 데이터 즉시 모두 삭제
                              (테이블 외 타 객체엔 사용 불가)   */
                              
TRUNCATE emp2;  -- 테이블이 '잘렸다' 고 표현된다.
-- DELETE 명령과의 차이는, rollback이 가능한지 여부이다.
INSERT INTO emp2 VALUES (null, null, null, null, null, null, null, null);

rollback; -- 후술할 DCL 소속 명령.
/*      3. DCL
        ==> 
        
        4. 관리자 모드 처리
        5. PL/SQL           --> 수업시간엔 다루지 않는다.
*/