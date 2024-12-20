# TCL(Transaction Control Language) & 뷰(View)

- TCL과 뷰(view)는 각각 **데이터의 무결성**을 지키기 위한 명령과 객체이다. 해당 관점으로 트랜잭션, TCL, 뷰를 살펴보는 것을 추천한다.
- 특히 **트랜잭션(transaction)**에 대한 이해는 DB 관리 시스템에 대한 이해, **BE 비즈니스 로직 작성 등에도 직간접적인 영향**을 줄 수 있다.

### 트랜잭션(transaction)

- oracle이 처리하는 **명령 단위**.
  - 기본적으로 **DML 명령**은 즉시 실행되지 않고 **buffer 메모리에 명령을 모아**둔다.
- 개발자의 **transaction 명령** : DML 명령을 적용하기 위해 transaction 명령을 내린다.
  - **DB 무결성 유지** : DB에서 가장 중요한 무결성을 유지하기 위해, 명령을 내렸을 때 transaction은 **한번만** 발생한다.

### 트랜잭션(transaction)과 롤백(rollback)의 종류

- transaction과 rollback은 각각 자동적, 수동적인 경우로 나뉜다.

#### 자동 transaction & rollback

- 자동 트랜잭션 : 그 이전에 작업했던 것들까지 모두 commit 처리된다.

  - DB 접속 도구(커맨드라인 툴, IDE, CLI 등)의 **정상 종료**
    - 도구 **내부에서 `exit` 명령을 하며 세션을 종료**하면 transaction 처리가 일어난다.
  - **DCL(Data Control Language), DDL(Data Definition Language) 명령** 실행 시

- 자동 롤백 : 버퍼(buffer memory)의 명령이 실행되지 못하는 경우 commit 이전으로 복구된다.
  - 정전 등의 사고로 인한 **시스템이 셧다운**
  - DB 접속 도구(커맨드라인 툴, IDE, CLI 등)의 **비정상적인 종료**

#### 수동 transaction & rollback

- 수동 transaction, rollback은 모두 **명령(어)를 통해** 이루어진다.
- DB와 연결된 **BE 서버에서** 작업 시 : DB **엔진 설정을 변경**하거나, 일시적으로 **auto commit 옵션**을 조정하여 수동 transaction 처리를 할 수 있다.
- 수동 트랜잭션 : `COMMIT;` 명령어를 통해 트랜잭션 처리
- 수동 롤백 : `ROLLBACK;` 명령어를 통한 롤백

## TCL(Transaction Control Language)

- DB의 명령 단위인 **트랜잭션을 제어**하는 명령
- DML 명령 후, **검토가 완료 되었다면 `COMMIT`**, 그렇지 않으면 `ROLLBACK` 명령을 내리는 식으로 사용한다.
- `COMMIT` : 모든 작업 정상 **반영**
- `ROLLBACK` : 모든 작업 **복구**
- `SAVEPOINT` : `COMMIT` 이전 **특정 시점까지 반영 또는 복구**

### `SAVEPOINT`

- `SAVEPOINT`는 transaction이 처리되면 자동 파기되어, 별도 **삭제 명령이 존재하지 않**는다.

```sql
SAVE POINT sp_name; -- save point 생성
ROLLBACK TO sp_name; -- save point로 돌아가기
```

- `ROLLBACK TO` : 해당 구문과 `SAVEPOINT` **사이의 작업이 모두 취소**된다.
- **예시** (이와 같은 예시는 정보처리기사, SQLD 등 자격증 시험에서도 종종 출제된다.)

  ```sql
  BEGIN TRANSACTION;
  SAVE POINT girls;
  /* DML 명령1 */
  SAVE POINT generation;
  /* DML 명령2 */
  SAVE POINT forever;
  /* DML 명령3 */
  SAVE POINT one;
  /* DML 명령4 */

  ROLLBACK TO forever; -- 명령 3, 4 분량 롤백
  ROLLBACK TO generation; -- 명령 2, 3, 4분량 롤백

  COMMIT; -- 최종적으로 실행된 DML 명령 : 명령1
  ```

---

## View

- 테이블과 유사하나, **DB에 물리적인 영향이 없**는 객체. (객체기 때문에 DDL을 사용)
- 자주 사용하는 **복잡한 질의 명령을 따로 저장**하고, **result set을 쉽게 처리**할 수 있게 하기 위해 만들어 졌다.
- **동적 생성** : view는 조회 할 때마다 기본 테이블을 바탕으로 재생성된다. 따라서 테이블 **데이터에 변화가 있어도 관점**(view, `SELECT` 명령 내용 자체)**유지**된다는 특징이 있다.

| view          | 설명                                                                       |
| :------------ | :------------------------------------------------------------------------- |
| **단순 view** | **1개의 테이블**만 이용해 만들어진 view.                                   |
|               | **_원칙적으로_** **모든 DML 명령이 가능**하나, 권장되진 않는다.            |
|               | **grouping**이 되어있는 경우 : `SELECT`를 제외한 **DML명령이 불가능**하다. |
| **복합 view** | **2개 이상**의 테이블을 이용해 만들어진 view.                              |
|               | `SELECT`를 제외한 **DML 명령이 불가능**하다.                               |

### View 생성/수정/삭제하기

- 생성인 경우 `CREATE`, 수정인 경우 `REPLACE`를 사용한다.

```sql
-- view 생성 / 수정
CREATE[ OR REPLACE] [FORCE] VIEW view_name AS -- 수정 시 REPLACE 구문 추가
/* SELECT sub query(inline view) */
[WITH /* 추가 설정... */]

-- 생성된 view 확인
SELECT * FROM user_views;

-- view 삭제
DROP VIEW view_name; -- 테이블과 동일
```

- `user_views` : 제약조건과 같이, oracle 시스템이 **생성된 뷰를 관리하는 테이블**
- `FORCE` 설정 시 : **참조 테이블 생성 전 view 생성**이 가능하다.
  - 추후 테이블을 만들어져야 view 사용 가능. 참조 테이블 생성 전엔 view는 작동하지 않는다.
- 대표적으로 사용되는 `추가 설정` :

  |        옵션         |           기능           |             제약조건             |          목적          |
  | :-----------------: | :----------------------: | :------------------------------: | :--------------------: |
  | `WITH CHECK OPTION` | 뷰 수정 시 정의조건 검사 | 뷰 **정의를 위반하는 수정 불가** | 데이터 **무결성** 유지 |
  |  `WITH READ ONLY`   |  뷰 수정 **완전 금지**   |       모든 수정 연산 불가        |    **데이터 보호**     |

  - 두 옵션에는 **검증된 수정사항만** 반영하는지(`CHECK OPTION`), **수정을 완전 차단**하는지(`READ ONLY`)의 차이가 있다.
