# GROUP BY

- 그룹 함수 사용 시 적용되는 범위(그룹, group)을 지정할 수 있다.
- `SELECT` 절 사용 시 대상을 grouping 하여 조회한다.

- 전체적인 SQL 질의 작성 순서 (3장 SELECT - `ORDER BY` 절에서 잠깐 언급하였음)

  ```sql
  SELECT /* 해당 구문 입력 */
  FROM /* 해당 구문 입력 */
  WHERE /* 해당 구문 입력 */
  GROUP BY
    col_name, /* CUBE() 등의 함수도 올 수 있음 */
  HAVING
    /* grouping 이후 데이터에 대한 필터링 조건 */
  ORDER BY col_name [ASC||DESC], col_name [ASC||DESC] ...
  ```

## 그룹 함수(group function)

- 여러 행의 데이터를 계산하여 반환하는 함수. `GROUP BY` 절을 사용했다면 해당 조건대로 grouping 한다.
- 항상 1개의 결과값을 가짐 : 여러 결과를 가질 수 있는 **_단일행 함수, 필드(field, column)등과 혼용할 수 없다_**.
  - \*단, grouping의 **_기준이 된 필드(column)은 사용 가능_**하며, **연산도 가능**하다.
- 사용은 `함수명(col_name)`으로 사용하며, 대부분 직관적인 이름을 갖고 있다.
- `NULL` 값은 자동으로 **0으로 치환**하여 연산한다.

| 함수 이름         | 설명                                                        |
| :---------------- | :---------------------------------------------------------- |
| `SUM()`           | 특정 컬럼의 합계 계산                                       |
| `AVG()`           | 특정 컬럼의 평균 계산                                       |
| `COUNT()`         | 특정 컬럼의 유효한 데이터 개수(`*`사용시 가장 큰 경우 반환) |
| `MAX()` & `MIN()` | 특정 컬럼의 최대값 & 최솟값 계산                            |
| `STDDEV()`        | 특정 컬럼의 표준편차 계산                                   |
| `VARIANCE()`      | 특정 컬럼의 분산 계산                                       |

- 표준편차, 분산을 도출하는 stddev, variance 함수는 자주 사용하진 않는다.

## `HAVING` 절

- grouping 된 데이터 중, **result set에 적용될 그룹을 지정**한다.
- `WHERE` vs `HAVING`
  - `WHERE` : **grouping 전** 데이터 필터링, 일반적으로 그룹함수 사용 X
  - `HAVING`: **grouping 후** 데이터 필터링, 일반적으로 그룹함수를 사용

---

## GROUP BY를 마치며...

- 쿼리의 **실행 순서**는 기본적으로 `FROM` - `WHERE` - `GROUP BY` - `HAVING` - `SELECT` - `ORDER BY`이다.
- 다만 세부적인 내용까지 들어가게 되면 **DBMS마다 다른 실행결과**가 나타날 수 있으니, 아래 사항을 가볍게 읽어보길 바란다.
- 추후 **쿼리 튜닝**을 하게 될 때, 쿼리 작동 순서를 알아 두면 유용하다.

|                   | `SELECT` | `DISTINCT` | `FROM` | `JOIN` | `WHERE` |    `GROUP BY`     | `HAVING` | `ORDER BY` | `LIMIT` & `OFFSET` |
| :---------------: | :------: | :--------: | :----: | :----: | :-----: | :---------------: | :------: | :--------: | :----------------: |
|  mySQL & mariaDB  |    6     |     7      |   1    |   2    |    3    | 4 (+ `ROLLUP` 등) |    5     |     8      |         9          |
|      ORACLE       |    6     |     7      |   1    |   2    |    3    |         4         |    5     |     8      |   9 (`FETCH ~`)    |
| MSSQL(SQL Server) |    6     |     7      |   1    |   2    |    3    |         4         |    5     |     8      |  9 (+ `FETCH ~`)   |
|    PostgreSQL     |    6     |     7      |   1    |   2    |    3    |         4         |    5     |     8      |         9          |
|      SQLite       |    6     |     7      |   1    |   2    |    3    |         4         |    5     |     8      |         9          |
