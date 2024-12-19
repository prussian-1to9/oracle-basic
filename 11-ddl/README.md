# DDL(Data Definition Language)

- DDL은 테이블 등 **객체에 대한 작업**을 할 수 있는 SQL의 명령 중 하나이다.

## Create : `CREATE`

- `10-constraint` 제약조건 토픽에서 많이 가장 많이 등장한 DDL.
- 신규 테이블을 생성하는 명령으로, 전체 syntax 구조는 다음과 같다.

```sql
CREATE TABLE tbl_name (
    col_name data_type[(length)] [DEFAULT default_value] [NOT NULL]
        [CONSTRAINT constraint_name constraint_type]
    ...
);
```

- 이 때, **`CONSTRAINT` 구문(syntax)**을 사용하는 부분은 컬럼(field) **선언부와 분리되어도 괜찮다**.

### 서브쿼리(sub query)를 통한 `CREATE`

- `CREATE` 명령 시 서브 쿼리를 이용하면 테이블 구조와 **특정 데이터까지 복사**할 수 있다.

```sql
CREATE TABLE tbl_name AS
    /* SELECT sub query(inline view) */;

-- 응용 : 테이블 구조만 복사할 때
CREATE TABLE tbl_name AS
    SELECT * FROM ori_tbl WHERE 1 = 2;
-- 1=2는 무조건 false로, 해당하는 데이터가 존재하지 않아 구조만 복사된다.
```

- 다만, `NOT NULL`을 제외한 **제약조건은 복사되지 않으**므로 주의해야 한다.
  - `NOT NULL` 제약조건 또한 **제약조건 이름**은 oracle 내부에서 **임의로 결정**된다.

#### 번외 : 서브쿼리를 통한 `INSERT`

```sql
INSERT INTO tbl_name
  /* SELECT sub query (inline view) */

-- e.g. 부서번호가 10번인 사원들의 데이터로 emp2 테이블에 복사
INSERT INTO emp2
SELECT * FROM emp
WHERE deptno = 10;
```

## Update : `ALTER`

- `ALTER` **_기존 테이블_**이나 기존 테이블의 **필드(column), 그리고 그 제약조건에 관련**하여 여러가지를 조작할 수 있다.
- DDL은 객체에 대한 명령으로, 객체인 테이블의 **내부 구성요소인 필드의 변경**, 객체인 **테이블의 변경사항**은 **`ALTER`로 처리**하지만 테이블 자체의 생성/삭제는 `CREATE`와 `DELETE`로 처리함을 기억한다.

1. **필드 추가**
   ```sql
   ALTER TABLE tbl_name
   ADD ( -- create와 동일
       col_name data_type[(length)] [DEFAULT default_value] [NOT NULL]
           [CONSTRAINT constraint_name constraint_type]
   );
   ```
2. 테이블, 필드 **이름 변경**

   ```sql
   -- 테이블 이름 변경
   ALTER TABLE tbl_name RENAME TO new_tbl_name;

   -- 필드 이름 변경
   ALTER TABLE tbl_name
   RENAME COLUMN col_name TO new_col_name;
   ```

3. **필드 길이 변경**

   ```sql
    ALTER TABLE tbl_name
    MODIFY col_name data_type[(length)] [DEFAULT default value];
   ```

   - \*길이 **축소는 불가**능하다. 이미 **지정된 만큼의 메모리가 확보** 되었기 때문이다.

4. **필드 삭제**
   ```sql
   -- 필드 삭제
   ALTER TABLE tbl_name DROP COLUMN col_name;
   ```
   - 테이블 삭제는 `DROP` 명령을 이용한다.

## Delete : `DROP`, `TRUNCATE`

### `DROP` : 테이블 삭제

```sql
DROP TABLE tbl_name;
DROP TABLE tbl_name PRUGE; -- 휴지통에 넣지 않고 바로 폐기
```

### oracle의 휴지통(recycle bin)

- oracle 내에는 자체적으로 **휴지통(recycle bin) 개념이 존재**한다. (oracle 10g 이후 버전)
- DDL 명령은 원칙적으로 복구가 불가능하지만, 서버 설정과 recycle bin을 이용해 일부 경우는 데이터 복구가 가능하다.

```sql
-- 휴지통 내 특정 테이블 복구
FLASHBACK TABLE tbl_name TO BEFORE DROP;

-- 휴지통 내용 확인
SHOW recyclebin;

-- 휴지통 내 특정 테이블 지우기
PURGE TABLE tbl_name;

-- 휴지통 모두 비우기
PURGE recyclebin;
```

### `TRUNCATE` : 테이블 데이터 일괄 삭제

- `DELETE`(DML 명령) : 조건을 지정하지 않을 경우 일괄 삭제한다.
  - `09-dml` 토픽 참고. `TRUNCATE`와의 차이점 또한 서술하였음.
- `TRUNCATE`(DDL 명령) : **무조건 `DELETE`와 동일**하나, DDL명령이기 때문에 **_rollback이 불가능_**하다.

```sql
TRUNCATE TABLE tbl_name;
```

- recycle bin으로 이동하는 `DROP` 명령과 달리, 별도로 recycle bin에서 관리하는 사항이 없으므로, 오히려 `DROP`보다 **_신중하게 실행해야 하는 명령_**이다.

---

## DDL을 마치며...

### 토막 지식 : 무결성 체크

- 각 테이블에 입력 **불가/필수 데이터를 미리 정하고** 이상 데이터가 입력되지 않도록 **방지하는 역할**을 한다.
- DBMS는 프로그램 등 전산 작업 시 필요한 데이터를 제공하는 **보조 프로그램**이다.
- DB는 항상 **무결해야하며**, 개발자의 실수를 방지하기 위해 개발된 DBMS의 기능이다.
