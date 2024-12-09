# 질의 명령 & 주석

## 질의 명령이란

- **SQL** : Structured Query Language

  - 이미 구조화(Structured)되어 있어 새로운 **프로그램 생성이 불가능**하고,
  - 명령(Query Language)을 통해 데이터를 조작한다.

- SQL 또한 타 언어와 마찬가지로 **세미콜론(`;`)**을 이용해 질의명령을 마무리한다.
- SQL 파일의 마지막에 오는 질의의 경우 세미콜론을 붙이지 않아도 작동하지만, **세미콜론을 포함한 질의(Query)를 실행하는 것을 권장**한다.

---

## 질의 명령의 종류

### DML(Data Manipulation Language)

- **데이터**를 추가/수정/변경/조회하는 명령
- 데이터 외의 것은 조작할 수 없다(스키마, 권한 등)
- DML에서 사용 가능한 SQL : **CRUD**
  - 많이들 이야기하는 CRUD의 뜻은 아래와 같다.
    | 의미 | 해당 DML 명령 |
    |:-:|:-:|
    | Create | `INSERT` |
    | Read | `SELECT` |
    | Update | `UPDATE` |
    | Delete | `DELETE` |

### DDL(Data Definition Language)

- **개체**(Entity)를 만들고 수정하는 명령
  - 개체(Entity) : DB에 등록 가능한 테이블, 사용자, 함수, 인덱스 등
    | DDL 명령 | 의미 |
    |:-:|:-:|
    | `CREATE` | 개체 생성 |
    | `ALTER` | 개체 수정 |
    | `DROP` | 개체 삭제 |
    | `RENAME` | 개체 이름 변경 |
    | `TRUNCATE` | 테이블 데이터 삭제 |

#### `TRUNCATE` vs `DELETE`

- 모든 데이터를 삭제할 때, **truncate가** delete보다 비교적 **빠르다**.
- delete로 삭제 후 commit 한 데이터는 복구가 힘들지만, truncate는 비교적 **데이터 복구가 쉽다**.

### DCL(Data Control Language)

- DB에 대한 **권한**, **트랜잭션**(transaction) 조작 등을 **관리**하는 명령
  | DCL 명령 | 의미 |
  |:-:|:-:|
  | `GRANT` | 권한 부여 |
  | `REVOKE` | 권한 박탈 |

### TCL(Transaction Control Language)

- **트랜잭션을 제어**하는 명령
  | TCL 명령 | 의미 |
  |:-:|:-:|
  | `COMMIT` | 모든 작업 정상 **반영** |
  | `ROLLBACK` | 모든 작업 **복구** |
  | `SAVEPOINT` | commit 이전 **특정 시점까지 반영 또는 복구** |

#### 트랜잭션(transaction) 관리

- 모든 명령어는 하나의 transaction으로 구분될 수 있으며, 해당 단위를 **효율적으로 설정하는 것이 중요**하다.
- 예를 들어, 어떤 플랫폼에서 구독형 서비스를 결제한 회원이 있을때 트랜잭션은 아래와 같이 구성할 수 있다.
  1. 회원의 결제 처리 : 결제 정보 `INSERT`
  2. 구독형 서비스 구독 처리 : 회원 정보 `UDPATE`
  3. 결제 이후 서비스 접근 : 구독형 서비스 정보 `SELECT`
  - 이 때 결제 처리가 정상적으로 완료되지 않았는데 회원 정보가 갱신된다면 이는 **시스템의 결함**이 된다.
  - 이를 하나의 transaction으로 묶어 제어하면 위같은 경우를 방지할 수 있다.

> **주석(comment)**
>
> - SQL에서 사용할 수 있는 주석은 다음과 같다.
>
>   ```sql
>   /*
>       다행 주석
>    */
>
>   -- 단일행 주석
>   # mysql 주석
>   ```
>
> - 타 언어의 document 주석인 `/** */` 주석, 단일행 주석인 `//` 등은 **사용이 불가능**하다.

## 앞으로 사용할 데이터

### emp

- 사원 정보 테이블
  | logical name | physical name |
  |:-:|:-:|
  | empno | 사원 번호 |
  | enmae | 사원 이름 |
  | job | 사원 직급 |
  | mgr | 상사 번호 |
  | hiredate | 입사일 |
  | sal | 급여 |
  | comm | 커미션 |
  | deptno | 부서 번호 |

### dept

- 부서 정보 테이블
  | logical name | physical name |
  |:-:|:-:|
  | deptno | 부서 번호 |
  | dname | 부서 이름 |
  | loc | 부서 위치 |

#### 처음 보는 테이블 살펴 보기

- `desc`, `describe`을 통해 테이블 구조를 조회할 수 있다. (`tbl_name`은 테이블 이름)
  ```sql
  DESC tbl_name; -- 축약형
  DESCRIBE tbl_name;
  ```

---

## SELECT 절

- 기본적인 쿼리

  ```sql
  -- 기본 전체 컬럼 조회
  SELECT * FROM emp;
  SELECT * FROM dept;

  SELECT empno, ename, job,mgr, hiredate, sal, comm, dname, loc -- select 절
  FROM emp e, dept d
  WHERE e.deptno = d.deptno; -- where절(조건절)
  ```

  - 전체적인 `SELECT` 절의 구성

    ```sql
    /* 필수 기재 사항 */
    SELECT -- column, scalar sub query 등 나열
    FROM -- table, inline view 등 나열

    /* 선택 기재 사항 */
    WHERE -- 검색 조건, nested sub query 등 나열
    GROUP BY -- grouping 조건
    HAVING -- grouping 후 필터링 조건
    ORDER BY -- result set 정렬 조건
    ```

- **select 절** 실행 후 나오는 **결과 값**을 result set이라고 일컫는다.
  - 엑셀 프로그램과 비슷하게 숫자는 오른쪽, 문자는 왼쪽 정렬
- select 절에서 column 이름 대신 **`*`을 사용할 경우 row 전체 값이 조회**된다.
  - **_민감한 정보가 있는 테이블에선 사용을 주의해야_** 한다.

### select 쿼리 시 주의할 점 : 대소문자 구분

- **대소문자 구분 X** : 여러가지 이름 (table / column / 연산자 / 명령어 / 함수 등)
- **대소문자 구분 O** : 테이블 내 저장된 **데이터**

  - 데이터
    ```sql
    -- 사원 이름이 smith인 사원의 급여 검색 시
    -- 데이터는 'SMITH'로 저장되어 있음
    SELECT sAL -- 가능
    FROM emp
    WHERE
    --  ename = 'smith'; 소문자 : 검색되지 않음
        ename = 'SMITH'; -- 검색 가능
    ```

### `DISTINCT`

- distinct 구문을 통해 **중복된 데이터를 한번만 조회** 할 수 있다.
- distinct 질의 명령 시 **한 번만 사용해야**하며, 조회된 데이터의 **각 행 값이 같은 경우만 적용된**다.
  - 각 column의 데이터가 **하나라도 다를 경우 중복으로 인정 X**
- distinct() 등 괄호를 포함하여 사용할 수 있으나 **권장되지 않**는다.

```sql
SELECT distinct deptno "부서 번호"
FROM emp;
```

### 별칭(alias) 사용하기

- select로 조회되는 컬럼에 별칭을 붙일 수 있다.
- `AS`로 정의할 수 있으며, **컬럼명 뒤에 바로 별칭**을 붙여 사용할 수도 있다.
- 단, 별칭에 **공백이 포함**된 경우 반드시 `""` 등을 통해 **문자열임을 명시**해 주어야 한다.
  ```sql
  SELECT col_name alias -- 또는
  SELECT col_name "column alias"
  ```

### `DUAL` 테이블

- select 절 활용 시 기본적으로 테이블 내 데이터를 필터링(where 절) 이용한다.
- 하지만, 특정 **상수값을 조회**하게 되면 필터링 된 **개수 만큼 값이 출력**된다.
- dual 테이블은 **1개만의 row**를 가지며, **간단한 계산식**, 프로시저의 **결과값** 등을 **확인하고 싶은 경우 사용**할 수 있다.
- oracle만의 가상 테이블이며, 데이터가 물리적으로 저장되지 않는다.

```sql
-- 아래의 경우 emp의 row만큼 값이 조회됨
SELECT '최이지' FROM emp;
-- dual 테이블을 사용하면 한개의 row만 조회됨
SELECT '최이지' FROM dual;

-- 셋팅한 timezone의 시간이 한 줄에 조회된다.
SELECT sysdate FROM dual;
```

- `sysdate` : 현지(timezone)의 시간을 반환해 주는 연산자
  - SQL은 기본적으로 **날짜, 시각을 분리해 기억하지 않**으니 유의
