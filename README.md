# OracleBaisc

- RDB 중 하나인 orcale의 기본적인 것들에 대해 다룹니다.
- 각 디렉토리는 **`번호`-`토픽`으로 네이밍** 되며 각 파일은 아래와 같이 구성됩니다.
  | 구성 파일 | 설명 |
  |:-|:-|
  | README.md | 해당 토픽에 대한 **개념**적인 부분 |
  | example.sql | 해당 토픽에 대한 **예시 SQL**문 |
  | practice\_`번호`.sql | 연습용 쿼리(**정답 포함**) |
  | problem\_`번호`.sql | **연습용 쿼리의 문제만**을 기술 |

  - \*경우에 따라 problem\_`번호`.xlsx 등 **문제 풀이에 필요한 추가 파일**이 첨부될 수 있음.

- `mock.sql` : 실습 시 사용할 `emp`, `dept` 테이블을 생성하고, 기본 데이터를 입력하는 SQL 스크립트입니다.
- 수식에서의 모든 `[]`는 선택값, `{}` 기호 및 미기재는 필수값을 의미합니다.
- 사용자의 임의 설정 값은 `소문자`, SQL의 구문적인 요소는 `대문자`로 기재합니다.
- 해당 repository는 oracle의 기본적인 사항을 다루므로, PL/SQL과 사용자 정의 변수 및 프로시저 등의 **심화 개념을 다루지 않습니다**.
  - 심화 개념은 [`oracle-tunning` 레포지토리](https://github.com/prussian-1to9/oracle-tunning)에서 설명합니다.

## 목차

- **01-query** : 질의 **명령의 종류**, **`SELECT` 절** 소개, 주석
- **02-data-type** : oracle의 **데이터 타입**, **`WHERE` 절** 소개, 기본적인 연산자
- **03-select** : `NULL` 검색, **`ORDER BY`절** 소개, **집합(set) 연산자**
- **04-function1** : oracle의 함수 종류, **문자열** 관련 함수, **숫자** 관련 함수
- **05-function2** : 데이터 **형변환** 함수, **날짜** 관련 함수, **null handling**, **조건** 처리 함수
- **06-group-by** : **`GROUP BY`, `HAVING` 절** 소개, **그룹함수**
- **07-join** : **`JOIN`** 소개, natural join, using join, **ANSI JOIN**
- **08-sub-query** : **서브 쿼리** 소개, inline view, `ROWNUM`, **계층형 질의**(oracle)
- **09-dml** : `SELECT` 절을 제외한 **DML 명령** 소개, `COMMIT`의 필요성
  - 토막 지식 : 테이블 설계, 정규화 과정
- **10-constraint** : 데이터 타입 리뷰, **제약조건** 소개, `tab` 테이블
- **11-ddl** : **`CREATE` & `ALTER` & `DROP` & `TRUNCATE`** 소개, 서브쿼리를 통한 `CREATE` & `INSERT`, oracle `recyclebin`, 무결성 체크
- **12-tcl-view** : **TCL 명령** 소개, **_트랜잭션(transaction)_**, **view**
- **13-sequence-index** : **sequence** 소개, `CYCLE`, **index** 소개, index 설정이 **유리/불리한 경우**
- **14-privilege-dcl** : 사용자 관리, **DCL 명령** 소개, **역할(role)**, 동의어(`SYNONYM`)

## 권장 선수 지식

- 타 프로그래밍 언어의 기본 지식(stirng handling, 데이터 타입, 조건문 등)
- 인코딩 관련 지식
- 자료구조, 탐색 알고리즘

---

## 기본 개념

- **테이블** : oracle이 데이터를 보관하는 단위. 데이터베이스 개체(Entity)라고도 알려진다.
- **ERD**(Entity-Relation Diagram) : 테이블 간의 관계를 도식화 한 다이어그램

### DBMS(DataBase Management System)

- 관계형 데이터베이스(RDB) 기준, 개체(Entity)들의 관계를 형성하여 DB를 관리하는(Management) 시스템(System).
- oracle은 테이블 간의 관계를 형성하여 데이터를 저장하는데, 이런 **DB 관리 시스템**을 DBMS라 일컫는다.
- **DBMS의 종류**
  - **정형 DB** : 관계형 DB라는 뜻의 RDB(Relational DataBase)라고도 불린다.
    - 데이터 추가 시 **형태가 갖춰져야** 추가가 가능한 데이터
  - **비정형 DB** : SQL을 사용하지 않는다는 뜻의 NoSQL이라고도 불린다.
    - 데이터 추가 시 **형태가 갖춰지지 않아도** 추가가 가능한 데이터.
  - 어떤게 좋다기보단 **각각의 특징과 장단점, 적합한 상황 등**을 갖고 있으며, 최근에는 RDB와 NoSQL의 특징을 부분적으로 지닌 DBMS도 출현하고 있다.

### RDB : 테이블의 구성 요소

- **테이블** : field와 record로 구성되어 DB를 보관하는 가장 작은 단위
- **필드(field)** : 같은 **개념**의 데이터 모임
  - 다른 이름 : 컬럼, 열(column), 칸(cell)...
  - **필드 이름**, **컬럼 이름** : 원칙적으로 항목마다 붙여진 이름
  - **_원칙적으로_** record는 각 행을 구분하는 방법이 존재하지 않는다.
- **레코드(record)** : 같은 **목적**을 가진 데이터 모임
  - 다른 이름 : 로우, 행(row)...

### '세션이 열렸다'?

- DBMS를 실행했을 때 **접속자에게 메모리를 할당한 상태**를 뜻한다.
- **세션(session)** : DBMS가 **접속을 표현하는 단어**이며, **확보된 메모리 내에서만 작업**(명령)이 가능하다.
  - oracle의 경우 플랜 가격에 따라 초기 제공 개수가 정해진다.
- 최종적으로 DB에 적용시키는 작업은 별도 TCL(Transaction Control Language, 01-query 참고) 명령이 필요하다.
- 우리가 다룰 oracle에서는 **동일 계정의 동시접속이 가능**하다.
  - 이 때, 확보된 **메모리 공간은 서로 공유하지 않**는다.
  - 내가 접속한 계정의 테이블 이름 조회
    ```sql
    SELECT tname FROM tab;
    ```
