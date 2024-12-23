# 서브 쿼리

- sub query. 한국어로는 부(付) 질의라고도 부를 수 있으나, 일반적으로 서브 질의, **서브 쿼리**라는 명칭을 사용한다.
- **메인 질의 명령(main query, 메인 쿼리)** : 서브 쿼리를 감싸는 질의 명령(query)
- **일반 질의(query)와 똑같이 작성**하며, 괄호 `()`로 묶어 사용한다.
- 해당 토픽에 대해서는 `example.sql`을 필수적으로 열람하는 것을 권장.
- **맛보기** : 이름이 SMITH인 사원과 같은 부서의 모든 사원 정보 조회
  ```sql
  SELECT * FROM emp -- 1-1. main query : 정보 조회
  WHERE deptno = (  -- 1-2. main query : 조회 결과 필터링
    SELECT deptno FROM emp -- 2. sub query : SMITH의 부서 번호 조회, 필터링 조건값 반환
    WHERE ename = 'SMITH'
  );
  ```

## sub query의 위치에 따른 명칭, 결과

| 위치        | 명칭             | 영문 명칭        | 출력 포맷                                 |
| :---------- | :--------------- | :--------------- | :---------------------------------------- |
| `SELECT` 절 | 스칼라 서브 쿼리 | scalar sub query | 1 row / 1 column                          |
| `FROM` 절   | 인라인 뷰        | inline view      | 테이블 형태(**minimum** 1 row / 1 column) |
| `WHERE` 절  | 중첩 서브 쿼리   | nested sub query | 활용 방법에 따라 상이(후술)               |

- 출력 포맷에서 벗어날 경우, 에러가 발생하니 주의.
- 사실 상 인라인뷰 외에는 서브 쿼리(sub query)로 포괄하여 부르니, 명칭을 크게 신경 쓸 필요는 없다. **_중요한 것은 출력 포맷과 활용 능력_**이다.
- inline view의 경우 inline table이라고 불리는 경우도 있으며, **반드시 별칭(alias)와 함께 사용하여야** 한다.

### WHERE 절에서의 sub query

- `WHERE` 절에서의 서브 쿼리는 활용에 따라 함께 사용할 수 있는 연산자가 정해져 있다.
- 모든 연산자들은 `NOT`과 혼용이 가능하다.
- **단일 행 단일 필드** : **비교 연산자**(`=`, `BETWEEN ~ AND` 등)를 통해 결과를 비교하여 result set 필터링
- **다중행 다중 필드** : **`EXISTS` 연산자**를 통해 결과 비교, **result set의 존재 유무**에 따라 `true`, `false` 반환

#### **다중 행 단일 필드**

- 아래의 연산자를 이용하여 result set 필터링
  | 연산자 | 설명 | 동등비교 | 대소비교 |
  | :----- | :--------------------------------------------------------------- | :------- | :------- |
  | `IN` | 여러 데이터 중 **하나 이상이** **_일치_**하면 `true` | O | X |
  | `ANY` | 여러 데이터 중 **하나라도** **_비교조건이_** **만족**하면 `true` | O | O |
  | `ALL` | 여러 데이터 중 **_모든 비교조건이_** **만족**하면 `true` | X | O |

- `ANY`를 이용해 동등 비교 연산(`=`) 할 경우 **`IN`과 같은 기능**을 함

### SELECT 절에서의 inline view

- `SELECT` 명령을 내리면 발생하는 결과를 inline view라고 한다.
- `12-tcl-view` 토픽에서 다루는 뷰(view)가 **자주 사용하는 inline view를 DB 객체로** 등록한 것이라고 이해하면 쉽다.
- 이는 **실제 존재하지 않는 데이터**를 임의로 추가해서 **사용할 때 유용**하다.

```sql
-- inline view의 컬럼(field) 사용
SELECT empno, ename
FROM (SELECT * FROM emp);

-- inline view 내에 존재하지 않는 컬럼 이름은 사용할 수 없음
SELECT empno, ename, hiredate
FROM (SELECT empno, ename FROM emp);
```

- 2번째 쿼리에서 `hiredate`는 `emp` 테이블에 존재하는 필드(column)임에도, `SELECT` 대상인 **inline view엔 `empno`와 `ename` 뿐**이기 때문에 에러가 발생하며 접근할 수 없게 된다.

> #### `ROWNUM`
>
> - inline view와 함께 많이 쓰이는 oracle 내장 **가상의 필드**(column).
> - 데이터가 조회된 순서(**행 번호**)를 표시한다.
> - `ROWNUM`은 **`ORDER BY`보다 이전에 실행**되기 때문에, **정렬 이후 `ROWNUM` 값**을 활용하고 싶을 때엔 **inline view와 함께 사용**해야 한다.

---

## 계층형 질의(hierarchical query)

- **oracle에서만** 사용 가능한 구문이기에, 타 DBMS에선 사용할 수 없다.
- 댓글형 게시판이나, `emp` 테이블의 상사 번호와 같이 **데이터의 상-하 관계**가 나누어져 있는 경우 사용할 수 있다.
- 예시 구문은 기존과 달리, 이해도를 높이기 위해 한글로 작성한다.

```sql
SELECT /* ~ */
FROM target_tbl
START WITH
  -- 계층 추적 시작값...
CONNECT BY
  PRIOR -- 계층 추적 조건
ORDER SIBLINGS BY -- ORDER BY 절의 확장이라고 이해하면 쉽다.
  -- 계층 간 정렬 조건...
```

- 계층 간 정렬은 기본적으로 **`LEVEL`에 대한 오름차순 정렬**이다.
- `PRIOR` : 이전이라는 의미로, 이전 계층을 의미함. **`PRIOR`가 붙은 쪽이 높은 상하관계**를 갖는다. (`example.sql` 필참)
