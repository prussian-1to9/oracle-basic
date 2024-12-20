# 시퀀스(Sequence) & 인덱스(Index)

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
