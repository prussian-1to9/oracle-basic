# 함수(function)

- oracle 기준, 데이터를 가공하기 위해 DBMS가 제시한 명령 또는 개체
  - DBMS는 **DB 밴더(Vendor) 기업마다** 다르며, **특히 함수의 차이가 가장 크다**는 것을 고지한다.

## oracle의 함수 종류

| 함수 종류       | 실행 횟수           | 함수 결과의 개수                                 |
| :-------------- | :------------------ | :----------------------------------------------- |
| **단일행 함수** | row마다             | **출력 데이터 개수(result set의 row 수)와 동일** |
| **그룹 함수**   | 1번 (여러행이 모임) | 1개                                              |

- 그룹 함수에는 **집계함수**들이 포함 : `MAX()`, `MIN()`, `SUM()`, `AVG()`, `COUNT()` 등...
- **그룹 함수**는 단일행 함수, 일반 필드와 **_절대 혼용할 수 없다!!!_**

---

## 문자열 관련 함수

- 데이터가 **문자열**이거나 **문자꼴로 변환된** 날짜 데이터, 숫자 데이터에만 사용 가능.

### 문자열 관련 기본적인 함수의 종류

- `CONCAT()` : 결합 연산자 `||`와 같은 기능
- `CHAR()` : 입력된 ascii 코드에 해당하는 문자 반환
- `ASCII()` : 입력된 문자의 ascii 코드 반환

  - 입력된 문자열의 길이가 1보다 크다면 **첫글자의 ascii코드만** 반환된다.

- **모아보기**

  ```sql
  CONCAT(str1, str2)
  CHAR(ascii_code)
  ASCII(ori_str)
  ```

### `LENGTH()`

- 문자열의 **문자 수**를 반환해 주는 함수
- length는 문자 수, **lengthb는 바이트 수를 반환**한다.

```sql
SELECT length('최이지') 문자수, lengthb('최이지') 바이트수
from dual
-- 출력 결과 : 문자수 - 3, 바이트수 - 6
```

### index를 활용한 문자열 관련 함수들

- **공통 주의사항**

  - 일반 프로그래밍언어와 달리, DB에서의 **문자열 index는 1부터** 시작한다.
  - 시작 위치가 음수일 경우, 문자열의 끝에서부터 계산한다.
  - `B` 함수의 경우 **입출력 index의 단위 또한 바이트 수**에 해당.

- `SUBSTR()`, `SUBSTRB()` : 문자열 중, **특정 위치의 문자열만 추출**하여 반환한다.

  - 추출 **길이를 미지정할 경우 st_idx부터 마지막까지**의 문자열을 추출한다.

- `INSTR()`, `INSTRB()` : 문자열 중 원하는 문자열의 **index 검색**

  - `occurence` : 문자열이 여러개 검색될 경우, **몇 번째 검색되는 문자열**을 찾을지
    - default : 첫번쨰 검색되는 문자열

- **모아보기**

  ```sql
  SUBSTR(ori_str, st_idx[, str_length])
  SUBSTRB(ori_str, st_idx[, byte_length])

  INSTR(ori_str, data2[, st_idx][, occurence])
  INSTRB(ori_str, data2[, st_idx][, occurence])
  ```

### 문자열 변환 함수

- `REPLACE()` : **target 문자열의 모든 부분**을 다른 문자열로 대체하여 반환
- `TRANSLATE()` : **target 문자열을 mapping**하여 다른 문자열로 **치환**. **_예제 필참_**
- `LPAD()`, `RPAD()` : **지정된 길이**의 **남는 공간을 지정한 문자로** 채운 문자열을 반환

  - `PAD`는 padding을, `L`, `R`은 padding의 방향을 뜻함.

- **모아보기**

  ```sql
  REPLACE(ori_str, target_str, repalce_str)
  TRANSLATE(ori_str, target_str, replace_str)
  LPAD(ori_str, str_length, pad_char)
  RPAD(ori_str, str_length, pad_char)

  -- e.g. : TRANSLATE()
  SELECT TRANSLATE('ADBC', 'ABCD', '1234')
  FROM dual;
  -- 이 경우, A => 1, B => 2, C => 3, D => 4
  -- 출력 : 1432
  ```

#### 대/소문자 관련 함수

- 함수 이름에서 유추할 수 있는 것이 대부분이다.
- `LOWER()` : 소문자 변환
- `UPPER()` : 대문자 변환
- `INITCAP()` : 첫글자 대문자 변환(**per word**)

```sql
SELECT
    lower(ename) "소문자 이름", upper(lower(ename)) "대문자 이름",
    initcap(ename) "첫 글자만 대문자"
FROM emp;

SELECT initcap('hello world!') from dual; -- Hello World! 출력
```

#### 문자열의 공백 제거 함수

- `TRIM()`

  - 문자열 중 앞/뒤의 **지정한 문자를 삭제**하여 반환
    - 같은 문자가 **연속으로 있다면 모두 삭제**처리
    - 데이터 앞, 뒤의 공백 문자가 많은 경우 많이 쓰인다.
  - 문자열 중간의 문자를 삭제할 순 없으며, 이 경우 `REPLACE()`를 권장한다.

- `LTRIM()`, `RTRIM()` : 각각 좌, 우의 특정 문자를 삭제한다.

- **모아보기**
  ```sql
  TRIM([target_str FROM] ori_str)
  LTRIM(ori_str, target_str)
  RTRIM(ori_str, target_str)
  ```

---

## 숫자 관련 함수

- 데이터가 숫자인 경우에만 사용 가능.
- **'자릿수'를 음수**로 지정할 경우, **소수점 위** 자리수를 뜻하게 된다.

### 숫자 관련 기본적인 함수의 종류

- 자릿수가 지정되지 않을 경우, 모두 소수 첫째자리에서 연산하여 **정수 형태를 반환**한다.
- `ABS()` : **절대값** 반환
- `ROUND()` : 지정 자릿수에서 **반올림**한 값을 반환
- `FLOOR()` : 소수점 이하 **무조건 버림**
- `TRUNC()` : 지정 자릿수 이하 버림
- `MOD()` : 나머지 연산(modulo), 타 프로그래밍 언어의 `%`와 같다.

- **모아보기**

  ```sql
  ABS(데이터 | col_name | 연산식)
  -- 이하의 '데이터'는 특정 값, 필드 이름, 연산식을 포괄함
  ROUND(데이터[, 자릿수])
  FLOOR(데이터)
  TRUNC(데이터[, 자릿수])
  MOD(데이터, 나눌숫자)
  ```
