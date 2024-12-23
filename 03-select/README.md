# SELECT

## SELECT 심화

### `IS` : `NULL` 검색

- `NULL` 데이터는 모든 **연산**에서 제외되는데, 비교 연산자 또한 제외 범위에 포함된다.
- 따라서 `NULL`에 대한 비교 연산 시 `IS`, `IS NOT` 키워드를 이용해야 정상적인 조회가 가능하다.

```sql
-- 커미션이 없는 사원들의 이름, 급여, 커미션 조회
SELECT ename "사원 이름", sal 급여, comm 커미션
FROM emp
WHERE
--  comm = NULL;    -- 연산 불가
    comm IS NULL;   -- 연산 가능
```

### result set 정렬 : `ORDER BY`

- 원칙적으로 DB는 DBMS 종류에 별 각각의 기준(index)에 따라 데이터를 조회함
  - 이는 **입력순서를 따르지 않**으며, 출력 순서는 개발자가 알 수 없다.
  - **기본 index 기준 정렬**되나, key가 많을 수록 result set의 정렬은 예측이 불가능해 진다. (`13-sequence-index` 토픽 참고)
- 이 **불확실성을 방지**하고, 원하는 대로 result set을 출력할 수 있게 하는 절이 `ORDER BY` 절이다.

```sql
SELECT /* 해당 구문 입력 */
FROM /* 해당 구문 입력 */
WHERE /* 해당 구문 입력 */
ORDER BY col_name [ASC||DESC], col_name [ASC||DESC] ...
```

- `ASC`, `DESC`은 각각 오름차순(ASCendent), 내림차순(DESCendent)이며
  - **\[선택값\]**이며, 기본 값은 오름차순인 `ASC`
- order by 절은 `SELECT`, `FROM` 절 등 이전 전술된 명령의 **result set을 정렬**하기 때문에 **최하단에 기술되어야** 한다.

---

### 집합(set) 연산자

- **2개 이상**의 `SELECT` 절을 이용하여, 그 **결과의 집합**을 얻어낸다.

  ```sql
  SELECT /* select1 */ FROM /* from1 */
  {UNION | UNION ALL | INTERSECT | MINUS }
  SELECT /* select2 */ FROM /* from2 */

  -- e.g.
  SELECT ename "사원 이름", sal 급여 -- 필드 이름은 첫 번째 SELECT 절이 기준이 된다.
  FROM emp
  UNION
  SELECT job 직급, comm 커미션
  FROM emp;
  ```

- **집합 연산자의 종류**
  | 집합 연산자 | 수학 기호 | 수학적 개념 | 설명 |
  |:-|:-|:-|:-|
  | `UNION` | $\cup$ | 합집합 | 두 가지 result set을 하나로 합쳐 조회 |
  | `UNION ALL` | " | " | `UNION`과 같은 개념이나, **중복 데이터를 그대로** 출력 |
  | `INTERSECT` | $\cap$ | 교집합 | result set 중, 양쪽 **모두 존재하는 결과만** 출력 |
  | `MINUS` | $-$ | 차집합 | 앞의 result set - 뒤의 result set을 출력 |

- **공통적인 측징**
  - 두 `SELECT` 절의 result set은 **field(column) 개수가 일치**해야 한다.
  - 두 `SELECT` 절의 result set은 **field(column)의 데이터 형태가 일치**해야 한다.
