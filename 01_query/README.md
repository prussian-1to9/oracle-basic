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

### `DISTINCT` 연산자

- distinct 연산자를 통해 중복을 제거한, **유일 값을 select** 할 수 있다.
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

---

## 데이터 타입(Orcale)

- DBMS 마다 데이터 타입이 존재하며, **일부 타입은 각 DBMS 별 상이**할 수 있다.
- 아래의 타입들은 RDBMS인 **oracle의 기본적인 데이터 타입**이다.
  | 데이터 타입 | 예시 syntax | 설명 |
  |:-:|:-:|:-:|
  | number | `NUMBER(유효_자릿수, 소숫점_이하_자릿수)` | 숫자 기입 시 자릿수 만큼 메모리 할당 |
  | char | `CHAR(숫자)` | 숫자 만큼의 **byte** 할당 |
  | | `CHAR(숫자 CHAR)` | 숫자 만큼의 **문자** 메모리 할당 |
  | varchar | `VARCHAR(숫자)`, `VARCAHR(숫자 CHAR)` | char와 동일한 매커니즘 |
  | date | `DATE` | 별도 **길이를 지정하지 않**으며, **7byte(고정)가 할당**된다. |

- oracle에서는 **문자(char)와 문자열(string)의 구분이 없**다. (대소문자는 구분)
- 일반 `VARCHAR`도 존재하며, `VARCHAR2`와 똑같이 사용할 수 있다.
  - 그러나 일반 `VARCHAR`의 경우, 데이터 타입(string / number...)이 규제되지 않는 경우도 있기 때문에 **`VARCHAR2`의 사용이 권장**된다.

### 메모리 할당과 실제 저장되는 데이터의 크기는 다르다

- varchar(가변길이), char(고정길이)를 예시로 들 수 있다. 똑같이 **20byte의 크기를 예약**하고, **3byte만 저장**할 경우를 예로 든다.
  | 데이터 타입 | 메모리 할당 | 실제 저장 용량 |
  |:-:|:-:|:-:|
  | varchar | 20 byte | **3 byte** |
  | char | 20 byte | 20 byte |
  - char는 **나머지 17 byte를 공백**으로 채운다.
- 그렇다고 **무조건 varchar가 이득인 것은 아니다**. 고정길이인 char는 데이터를 그대로 사용하면 되는 반면, varchar는 추후 데이터 사용 시 추가적인 연산이 필요하다. 이는 **적절한 데이터 타입을 고려해야 할 경우 선택에 영향**을 미칠 것이다.

### date가 7 byte 고정 할당 되는 이유

- date는 아래와 같이 메모리가 할당된다.
  | SQL date format | 의미 | 할당 byte |
  |:-:|:-:|:-:|
  | %Y | 년 | 2 |
  | %m | 월 | 1 |
  | %d | 일 | 1 |
  | %H | 시 | 1 |
  | %i | 분 | 1 |
  | %S | 초 | 1 |
  - SQL date format의 경우 더 다양하게 존재하지만, 대표적인 것들로 기재하였다.

---

## where 절

- `SELECT`, `UPDATE`, `DELETE`등의 명령에서 `WHERE` 절을 이용하여 조건을 지정할 수 있다.
- `WHERE` 절은 일반적으로 필수적인 질의명령의 바로 뒤에 작성한다.

  ```sql
  -- select 절
  SELECT * FROM emp WHERE deptno = 20; -- deptno == 20인 데이터만 조회

  -- udpate 절
  UPDATE emp SET deptno = 40 WHERE deptno = 20; -- deptno == 20인 데이터만 40으로 변경

  -- delete 절
  DELETE emp
  WHERE deptno = 20; -- depto == 20인 데이터만 삭제
  ```

### 연산자

- 아래의 연산자는 `SELECT`의 컬럼 부분에서도 범용적으로 사용할 수 있다.
  | 연산자 | 의미 |
  |:-|:-|
  | `+` | 더하기 |
  | `-` | 빼기 |
  | `*` | 곱하기 |
  | `/` | 나누기(소숫점 반환) |
  | `%` | 나머지 연산 |
  | `=` | 같음(**`==`를 사용하지 않**는다.) |
  | `\|\|` | 데이터 결합 연산자 |
  | `!=`, `<>` | 다름 |
  | `<`, `>` | 비교 연산자 |
  | `NOT` | 논리 부정 연산자 |
- 비교 연산자의 경우, **같은 데이터 타입 간의 비교만 가능**하다.

  - 단, **날짜 데이터의 경우 문자열로 변환 되어 있다면 문자 데이터와 비교 가능** (이 경우 ASCII 코드 값으로 대소구분)

#### where 절에 조건을 명시할 경우

- **row마다** 그 행의 조건이 맞는지 **확인** => 조건 **부합 시 출력**
- 여러 조건이 이어질 경우 `AND`, `OR` 연산자를 이용하여 나열

#### 특별한 조건 연산자

1. **`BETWEEN` ~ `AND` 연산자** : 데이터가 **특정 범위** 안에 있는지 확인

- 해당 범위의 여집합을 찾고 싶을 경우 `NOT`을 혼용할 수 있다.

```sql
col_name [NOT] BETWEEN range_start AND range_end

-- e.g. 급여가 1000 ~ 3000 사이인 사원들의 이름, 급여 조회
SELECT ename, sal
FROM emp
WHERE sal BETWEEN 1000 AND 3000;
```

2. `IN` 연산자 : 데이터가 **주어진 데이터 중 하나인지** 확인

- `BETWEEN` ~ `AND`와 같이 `NOT`을 혼용할 수 있다.

```sql
col_name [NOT] IN (data1, data2, data3...)

-- e.g.1 부서 번호가 10, 30인 사원들의 이름, 직급, 부서 번호 조회
SELECT ename, job, deptno
FROM emp
WHERE deptno IN (10, 30);

-- e.g.2 직급이 MANAGER, SALESMAN이 아닌 사원들의 이름, 직급, 급여 조회
SELECT ename, job, sal
FROM emp
WHERE job NOT IN ('MANAGER', 'SALESMAN');
```

3. `LIKE` 연산자

- **문자열에만** 적용 가능한 조건 연산.
- 문자열의 일부분을 wild-card 처리하여 조건식 제시
  ```sql
  col_name LIKE '_search-text%'
  ```
- 와일드 카드 사용 법
  | 기호 | 의미 |
  |:-|:-|
  | `_` | 언더바(`_`) 하나 장 한글자만을 와일드카드로 지정 |
  | `%` | 글자수 무관, 모든 문자를 포함하는 와일드카드
- e.g.
  1.  **`M%`** : M으로 **시작하는 모든** 문자열
  2.  **`M__`** : M으로 시작하는 **3글자** 문자열
  3.  **`%M%`** : M이 **포함된 모든** 문자열
  4.  **`%M`** : M으로 **끝나는 모든** 문자열
