# JOIN

- RDBMS(관계형 데이터베이스 관리 시스템)에서는 데이터 중복을 피하기 위해 테이블을 분리하고, **관계**를 형성 한다.
- 분리된 **테이블들에서 관계를 이용하여 데이터를 추출**할 때 사용하는 문법이 `JOIN`이다.
- RDB에서 여러개의 테이블을 동시 검색하는 기능은 이미 존재하지만, 이 때는 **cross join**(곱집합, cartesian product)이 만들어져 **정확하지 않은 정보가 포함될 수 있**다.
- 여러 개의 테이블을 동시 검색할 때, 데이터 범위를 한정하고 정확한 정보를 추출하기 위해서는 `JOIN` 연산이 필요하다.

> - **ER & RDB**
>   - **ER** : Entity-Relationship으로, Entity(데이터) 간의 관계를 뜻함
>     - oracle 역시 E-R 형태의 DB
>   - 이렇게 **관계**로 테이블을 관리하는 DB를 관계형 DB(RDB)라고 일컫는다.

## JOIN의 종류

- 크게는 아래의 3가지 join으로 나뉜다.
- **inner join** : 나열된 테이블들의 **결과집합 내**에서 데이터 추출
  - SQL에서 **일반적인 join**이라는 표현과, 구문(syntax)들은 inner join을 뜻한다.
  - equi join : 동등비교 연산자(`=`)로 join하는 경우
  - non equi join : 동등 비교 연산자 외의 연산자로 join하는 경우
- **outer join** : catesian product에 포함되지 않는 데이터를 추출
- **self join** : join 대상 테이블이 동일한 경우
- 이 때, DBMS에 따라 테이블 별 **별칭(alias)가 필수인 경우도** 있으니 구문(syntax)에 주의해야 한다.

  - **oracle** : 2개 이상 테이블 참조 시 테이블 별칭은 필수가 아니다.
  - **mySQL** : 테이블 별칭을 **필수**로 기재하여야 하니 주의.

- join은 2개 이상의 여러 테이블을 중첩하여 조회할 수 있다.
- 조건을 생략할 경우 cartesion product(곱집합)을 반환하는 cross join을 시행하니, 정확한 조건 지정이 중요하다.

## 그 외의 join

- `NATURAL JOIN` : **oracle의 자체적**인 `JOIN` 구문으로, 같은 필드(column) 이름을 기준으로 join한다.
- `USING JOIN` : natural join과 비슷하게, 같은 필드 이름을 기준으로 join한다.
  - **차이점** : join에 사용할 필드 이름을 **직접 지정**하며, **2개 이상**의 필드를 지정할 수도 있다.
- **모아보기**

  ```sql
  SELECT /* ~ */
  FROM tbl1 NATURAL JOIN tbl2;

  SELECT /* ~ */
  FROM tbl1 CROSS JOIN tbl2
  USING (duplicate_col_name);
  ```

---

## ANSI JOIN

- oracle은 join을 포함하여 자체적인 질의 명령 구문들이 존재한다. (**타DB 호환X**)
- 때문에 **모든 DB에서 사용 가능한 ansi join**를 알아 두는 것이 좋다.

### ANSI 형식

- 미국 국립 표준협회(American National Standards Institute, ANSI)에서 공통의 질의 명령을 만들었다.
- **cross join** : cartesion product(곱집합)에 해당하는 result set을 조회
- **inner join** : 조건을 지정하여 테이블을 조회하는 가장 일반적인 join이기 때문에 `INNER` 구문을 생략하면 자동으로 inner join 처리 된다.
- **outer join** : cartesion product로 표현되지 않은 데이터를 조회
  - 일반적으로 `NULL`로 표현되지 않은 데이터가 있는 테이블의 방향을 따라간다.
  - 통용적으로 `LEFT OUTER JOIN`을 많이 사용한다.
- **모아보기**

  ```sql
  SELECT /* ~ */
  FROM tbl1 CROSS JOIN tbl2;

  SELECT /* ~ */
  FROM tbl1 [INNER] JOIN tbl2
    ON /* join 조건*/
  [WHERE /* 일반 필터링 조건 */]

  -- outer join --
  SELECT /* ~ */
  FROM tbl1 [LEFT|RIGHT] OUTER JOIN tbl2
    ON /* join 조건 */

  SELECT /* ~ */
  FROM tbl1 JOIN tbl2
    ON tbl1.col1 (+) = tbl2.col1
    -- 또는...
    ON tbl1.col1 = tbl2.col1 (+)
  ```
