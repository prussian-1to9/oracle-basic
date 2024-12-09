# 데이터 타입 & 연산자

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

### `NULL` 데이터

- 필드 내 데이터가 없는 경우, `NULL`이라는 데이터가 저장된다.
- `NULL` 데이터는 모든 연산에서 제외되나, **그룹함수 등에서는 예외**다.
- `NULL` 값이 있는 경우를 방지하기 위해 `NVL()` 함수를 사용할 수 있다.
  ```sql
  NVL(col_name, data) -- col_name의 값이 NULL일 경우 data값으로 대체된다.
  ```

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

---

## 연산자

- 아래의 연산자는 `SELECT`의 컬럼 부분에서도 범용적으로 사용할 수 있다.
  | 연산자 | 의미 |
  |:-|:-|
  | `+` | 더하기 |
  | `-` | 빼기 |
  | `*` | 곱하기 |
  | `/` | 나누기(실수 연산) |
  | `%` | 나머지 연산(**oracle엔 없음**) |
  | `=` | 같음(**`==`를 사용하지 않**는다.) |
  | `\|\|` | 데이터 결합 연산자 |
  | `!=`, `<>` | 다름 |
  | `<`, `>` | 비교 연산자 |
  | `NOT` | 논리 부정 연산자 |
- 비교 연산자의 경우, **같은 데이터 타입 간의 비교만 가능**하다.

  - 단, **날짜 데이터의 경우 문자열로 변환 되어 있다면 문자 데이터와 비교 가능** (이 경우 ASCII 코드 값으로 대소구분)

### where 절에 조건을 명시할 경우

- **row마다** 그 행의 조건이 맞는지 **확인** => 조건 **부합 시 출력**
- 여러 조건이 이어질 경우 `AND`, `OR` 연산자를 이용하여 나열

### 특별한 조건 연산자

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
