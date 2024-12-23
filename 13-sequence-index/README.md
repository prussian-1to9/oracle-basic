# 시퀀스(Sequence) & 인덱스(Index)

- 인덱스를 생성/수정/삭제하는 것은 메모리 할당과 schema(테이블)간의 관계에도 통달해야 하기 때문에, 대부분 **고연차의 DBA가 수행**한다.
- 때문에 해당 토픽에서는 **index를 사용하는 이유, 적절한 사용 방법에 중점**을 둔다.
- index에 대한 이해는 추후 **쿼리 튜닝을 시도할 경우에도 도움**이 된다.
  - 해당 레포지토리에서는 다루지 않지만, **적절한 index 사용**과 더불어 쿼리를 설명하는 **`EXPLAIN` 명령어**를 사용해 성능을 높여보는 것을 권장한다.

---

## 시퀀스 (Sequence)

- PK(기본키)로 사용되는 UID 등의 **일련번호를 자동적으로 발생**시기는 **객체**
- 중복값을 피하고 `UNIQUE` 제약조건을 만족 시키고 싶을 때 사용할 수 있다.
- DBMS 별, 버전 별 지원하는 **형태는 다르나** 시퀀스는 대부분의 **RDB에 존재**한다.

### 시퀀스의 활용

1. 시퀀스 **생성** : 뷰, 테이블과 같은 객체기 때문에, **DDL 명령**을 사용한다.

   ```sql
   CREATE SEQUENCE seq_name
       [START WITH st_val] -- default 1
       [INCREMENT BY step_val] -- default 1
       [MAXVALUE mx_val] -- default 00(무한대)
       [MINVALUE mn_val] -- default 1

       [CYCLE | NOCYCLE] -- default NOCYCLE
       [CACHE cache_length | NOCACHE] -- default 20
       [ORDER | NOORDER] -- default NOORDER
   ```

   - `START WITH` : 시퀀스의 시작 값 설정
   - `INCREMENT BY` : 시퀀스 사용에 따라 증가하는 값. **음수도 설정 가능**
   - `MAXVALUE`, `MINVALUE` : 시퀀스의 최대/최소값.
   - `CYCLE` 옵션 : 활성화한 상태에서 **최대, 최소값 도달 시** 다시 **`START WITH`에 설정한 값으로 초기화** 된다.
   - `CACHE` 옵션 : 시퀀스 값을 메모리에 cache하는 개수
   - 해당 옵션을 사용 시 **빠른 성능**이 보장되나, **메모리를 차지**한다는 특징을 지닌다.
   - `ORDER` 옵션 : 옵션 설정 시 시퀀스 값을 **순서대로 생성**한다.

2. DB 입력 등 필요 시 **시퀀스 호출**

   - 주로 `INSERT` 구문에서 사용되어, 아래의 예시를 든다.
   - PK `no` 단일 컬럼으로 구성된 `tmp` 테이블에 `INSERT` 시도 시

   ```sql
   INSERT INTO tmp (-- 예시
    seq_name.NEXTVAL -- 자동으로 시퀀스의 다음 값이 반환됨
   );
   ```

#### `NOCYCLE` 설정한 시퀀스가 최대/최소값에 도달한 상태에서 `NEXTVAL`을 호출하게 된다면?

- `CYCLE`을 통해 처음 값으로 돌아가지 않는 상태에서, 최대값이 도달한 상태이다.
- 해당 상태에서 `NEXTVAL`을 호출하게 되면 `MAXVALUE` + `INCREMENT BY`의 값을 반환해야 하는 상황이 된다.
- 이렇게 되면 `ORA-08004: sequence <seq_name> is out of bounds` 오류가 발생하며 `NEXTVAL` 호출이 불가하니, **신중한 초기설정이 중요**할 것이다.

### 시퀀스의 수정 & 삭제

- 시퀀스 **수정** : **생성 시와 동일 구문(syntax)을 사용**하나, **시작값(`START WITH`) 지정이 불가**
- 시퀀스 **삭제** : `DROP`을 이용하여 삭제

```sql
-- 시퀀스 수정
ALTER SEQUENCE seq_name
       [INCREMENT BY step_val] -- default 1
       [MAXVALUE mx_val] -- default 00(무한대)
       [MINVALUE mn_val] -- default 1

       [CYCLE | NOCYCLE] -- default NOCYCLE
       [CACHE cache_length | NOCACHE] -- default 20
       [ORDER | NOORDER] -- default NOORDER

-- 시퀀스 삭제
DROP SEQUENCE seq_name;
```

### 시퀀스의 문제점?

- 시퀀스는 **테이블에 독립적**이다.
- 때문에 여러 테이블에서 사용 가능하며, **호출 스키마(table, schema)과 무관하게 다음 값을 생성**한다.
- **누락 번호가 생길 가능성**이 있으므로, 시퀀스 사용시에는 사용 범위와 문제 발생 시 해결 방안을 고려해야 한다.

---

## 색인, 인덱스(Index)

- 검색(`SELECT`) 속도를 증가시키기 위해 만들어진 **`B-Tree` 형태**의 색인(index) **DB 객체**.

> - **index의 자동 생성**
>   - **`PRIMARY KEY` 또는 `UNIQUE` 제약조건**을 부여할 경우 자동으로 인덱스가 생성된다.

### 경우에 따른 index 사용

- index는 메모리 공간을 소모하기 때문에, 생성에 있어 신중해야 한다.
- 적절한 index 사용은 **`SELECT` 쿼리 성능 향상**에 큰 도움을 준다.

#### index 생성이 유리한 경우

1. **join에 많이 이용**되는 필드(field)가 있을 때
2. **`WHERE` 절에 많이 이용**되는 필드(field)가 있을 때
3. `NULL` 값이 많이 존재하는경우

#### index 생성이 불리한 경우

1. 데이터 양이 너무 적을 때
   - 오히려 **속도가 저하**될 수 있음
2. 데이터 입출력이 빈번한 경우
   - index는 테이블 **데이터와 동기화된 상태를 유지**해야 한다.
   - 이 경우, **입출력마다 index가 수정**되어 마찬가지로 속도가 저하될 수 있다.

### index 종류

#### 1. 일반 인덱스(Non-unique Index)

- 데이터 중복을 허용하는 기본 인덱스

```sql
CREATE INDEX idx_name ON tbl_name(col_name)
```

#### 2. 유일 인덱스(Unique Index)

- 인덱스에 사용되는 데이터가 **_`UNIQUE`하다는 보장이 있는 경우_**에 생성하는 인덱스
- **이진 검색(binary search)** 사용 : 기본 인덱스보다 **빠른 속도**

```sql
CREATE UNIQUE INDEX idx_name
ON tbl_name(col_name);
```

#### 3. 결합 인덱스

- **여러 필드를 결합**하여 만든 하나의 인덱스
- **_생성을 위한 전제 조건_**
  - 사용하는 **필드의 조합이 모두 기본키(`PRIMARY KEY`)**이다.

```sql
-- 결합 인덱스 일반 생성
CREATE UNIQUE INDEX idx_name
ON tbl_name(col1_name, col2_name, ...)

-- 제약조건으로 추가
CREATE TABLE tbl_name(
   col_name data_type[(length)]
      CONSTRAINT constraint_name PRIMARY KEY(col1_name, col2_name, ...)
)
```

#### 4. Bitmap Index(비트맵 인덱스)

- 주로 **도메인이 정해져 있는** 경우 사용하는 인덱스

```sql
CREATE BITMAP INDEX idx_name
ON tbl_name(col_name);
```

> - **지정된 도메인**이란?
>   - **데이터가 지정된 값 중 하나**가 되는 경우
>   - `'F'`, `'M'`, `'N'`만 입력 가능하도록 `CHECK` 되어있는 `gen` 필드(field)
>   - `10`, `20`, `30`, `40`만 입력되어있는 `deptno` 필드
