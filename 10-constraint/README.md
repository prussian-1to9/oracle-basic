# 제약조건(constraint)

- **DB의 이상현상 방지를 목적**으로, 데이터가 입력될 때 **조건에 위반하는 데이터를 차단**한다.
- 해당 토픽에서 만들 테이블들은 **이후 토픽에서도 사용**되므로, `example.sql`의 명령들을 한번씩 실행해 볼것을 권장한다.

## 데이터 타입 리뷰

- 제약조건과 11번째 토픽인 DDL을 이해하기 위해 지금까지 작게나마 언급했던 데이터 타입을 간단히 리뷰한다.

### 문자형 데이터 타입

|     데이터 타입     | 최대 길이 | 길이 |
| :-----------------: | :-------: | :--: |
|  `CHAR(char_len)`   |    2KB    | 고정 |
| `VARCHAR2(max_len)` |    4KB    | 가변 |
|       `LONG`        |  2**GB**  | 가변 |
|       `CLOB`        |  4**GB**  | 가변 |

- `LONG`, `CLOB`은 `VARCHAR`의 용량적 한계로 인해 나타난 타입들이다.

> #### 고정길이 vs 가변길이
>
> - **고정길이** : 지정한 것보다 적은 길이의 문자열이 입력되면 **남은 부분을 공백으로** 채운다.
>   - **메모리 낭비**가 발생할 수 있고,**`INSERT` / `UPDATE`가 빠르다**는 특징이 있다.
> - **가변길이** : 지정한 길이는 **최대 길이**로, 최대 적은 길이의 문자열이 입력되어도 **그대로 저장**된다.
>   - **길이 계산에 자원이 소모**되나, **메모리 활용을 효율적**으로 할 수 있다는 특징이 있다.

### 숫자형 & 날짜형 데이터 타입

- **`NUMBER(digit, below_deci_point_digit)`**
  - 유효 자릿수(`digit`)보다 큰 수는 입력 받을 수 없다.
  - 소수점 아래 자릿수(`below_deci_point_digit`)보다 아래의 자릿수는 자동 반올림하여 저장한다.
- **`DATE`** : ANSI에서 제안한 데이터 형태. 기본적으로 `yyyy-mm-dd` 형식으로 날짜를 표현한다.
  - DBMS 내의 날짜형 데이터는 각각 형태 차이가 크다.

---

## 제약조건의 종류

> 1. **기본키(primary key)** 제약조건 : 속성값으로 **데이터를 구분할 수 있게** 한다.
>    - DBMS상의 필수 사항은 아니나, **되도록이면 모든 테이블에 설정**하는 제약조건

> 2. **유일키(unique key)** 제약조건 : 기본키와 같이 속성값으로 데이터를 구분할 수 있게 한다.
>    - 쉽게 말하자면 **동일 컬럼(field) 내 데이터 중복 불가 조건**이다.
>    - `NULL` 설정이 불가능한 기본키와 달리 별도 설정이 없다면 **nullable(`NULL` 데이터 입력 가능) 설정**된다.

> 3. **참조키(외래키, foreign key)** 제약조건 : 참조하는 **타 테이블의 key값을 사용하여 데이터 무결성을 보장**한다.
>
>    - 외래키로 참조되는 원본 데이터는 반드시 **`UNIQUE`** 해야한다. (**기본키** 또한 UNIQUE 설정이 되어있음)
>    - 테이블 삭제를 원할 경우, 참조를 **하고** 있는 테이블을 삭제한 후 참조 **되는** 테이블을 삭제 해야한다. (`CASCADE CONSTRAINTS`로 제약조건 삭제를 겸한 `DROP`이 가능하나, 권장하지 않는다.)

> 4. **`NOT NULL`** 제약조건 : 속성값으로 **`NULL` 데이터가 오지 않게** 막는다.

> 5. **`CHECK`** 제약조건 : **정해진 속성값** 외 다른 값이 입력되는 것을 막는다.
>    - 성별, 데이터 노출/삭제 여부 등에 사용 가능.

- **모아보기**
  | 제약조건 | `UNIQUE` | `NOT NULL` |
  | :---------: | :------------------: | :--------: |
  | primary key | O | O |
  | unique | O | **X** |
  | foreign key | 참조되는 원본 데이터 | △ |
  | not null | X | O |

---

## 제약조건 부여하기

1. **필드(column) 정의 시** 추가 : **테이블 생성 시점**에 제약조건을 추가한다.
2. 필드 **정의 이후** 제약조건 추가 : **테이블 생성 후**, 데이터를 활용하는 중 제약조건을 추가한다.
   - 단, **`NOT NULL`** 제약조건은 테이블 생성 이후 **_추가가 불가능_** 하다. 이는 **_수정의 개념_** 으로 접근해야 한다.
3. **무명(unsigned) 제약조건**으로 등록 (**_권장하지 않음_**) : 보편적으로는 **`{tbl_name}_{col_name}_{constrinat}`의 이름으로 네이밍** 하여 제약조건을 부여한다.

```sql
-- 테이블 생성 시 제약조건 추가 :
CREATE TABLE tbl_name (
    col_name /* data_type[(length)] */
        CONSTRAINT constraint_name1 /* constraint_type1 */,
        ...
        -- 참조키(forign key) 제약조건
        CONSTRAINT constraint_name FOREIGN KEY (new_col_name)
            REFERENCES table_name(target_col_pk_or_uk)

        -- CHECK 제약조건
        CONSTRAINT constraint_name CHECK (col_name IN (value1[, value2, ...]))
)

-- 테이블 생성 이후 제약조건 추가 :
ALTER TABLE tbl_name
    ADD CONSTRAINT constraint_name /* 제약조건... */(col_name)
```

## 제약조건 확인하기

- 제약조건은 `USER_CONSTRAINTS` 테이블을 이용하여 그 정보를 확인할 수 있다.

  ```sql
  SELECT /* 컬럼(field)명 나열 : constraint_name, constraint_type 등...*/
  FROM user_constraints
  [WHERE table_name IN (/* 검색할 테이블 이름 나열 */)]
  ```

- **`USER_CONSTRAINTS`** : oracle이 시스템 내 테이블로, 등록된 **제약조건을 관리하는 테이블**
- **`constraint_type`** : `USER_CONSTRAINTS`에서 제약조건의 타입을 표기하는 컬럼(field). 값의 의미는 아래와 같다.
  | `constraint_type` | 의미 |
  | :-: | :-: |
  | P | primary key |
  | R | referenced, foreign key |
  | U | unique key |
  | C | Common(not null), `CHECK` |

## 제약조건 삭제하기

```sql
ALTER TABLE tbl_name
    DROP CONSTRAINT constraint_name;
```

- 위의 SQL문에 적절한 **테이블 이름(`tbl_name`), 제약조건 이름(`constraint_name`)을 기입**하여 제약조건을 삭제할 수 있다.
- **예외 케이스 : 기본키(primary key)**
  - 기본키의 경우, 제약조건 이름을 알 수 없어도 삭제가 가능하다.
  - 이는 테이블 별 기본키가 **한 컬럼(field)만 존재**하기 때문에 가능한 syntax이다.
  ```sql
  ALTER TABLE tbl_name DROP PRIMARY KEY;
  ```

---

## 제약조건을 마치며...

- 제약조건은 **DDL과 함께 사용**하게 되는 것이 필연적이다. **후속 토픽인 DDL**에서 제약조건 개념은 계속 등장할 예정이므로, 해당 토픽과 함께 개념을 확인할 것을 권장한다.
- `CREATE TABLE` 맛보기

  ```sql
  CREATE TABLE tbl_name (
      col1_name data_type[(length)],
      col2_name data_type[(length)],
      ...
  )

  -- 테이블 생성여부 확인
  SELCET tname FROM tab;

  -- 테이블 구조 확인
  DESC tbl_name; -- 축약형
  DESCRIBE tbl_name;
  ```

  - `tab` 테이블 : oracle 시스템 내의 테이블로, 테이블 생성 시 `tab` 테이블에 테이블 정보가 입력된다.
