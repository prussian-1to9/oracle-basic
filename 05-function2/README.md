# 함수 심화

- 함수는 데이터 형태에 따라 사용하는 함수가 달라진다.
- 함수 토픽에서 연장하여, 날짜 타입과 null 타입에 대한 handling

## 형변환 함수

- **사용하려는 함수가 데이터 타입과 일치하지 않을 때** 사용하는 것이 형변환 함수이다.
- **숫자-문자열-날짜 간의 변환이 가능**하며, 숫자-날짜간의 변환은 불가능하다.

### 형변환 함수의 종류

| 함수 종류     | 설명                                     |
| :------------ | :--------------------------------------- |
| `TO_CHAR()`   | 숫자, 날짜 데이터를 문자열 데이터로 변환 |
| `TO_DATE()`   | 문자열을 날짜 데이터로 변환              |
| `TO_NUMBER()` | 문자열을 숫자 데이터로 변환              |

- 세 함수 모두 변환 대상 **데이터는 필수**, **format_mask는 선택**값.
- 변환할 format_mask의 경우 다른 문자열이 포함될 수 있으며, 이 경우는 **큰따옴표(`""`)로 감싼다**.
- 이 외에도 `TO_CLOB()`, `TO_BLOB()`, `TO_TIMESTAMP_TZ()` 등의 함수들도 존재하나, 거의 쓰이지 않아 기재하지 않았다.
- 동일 문자 데이터라면 동일 format_mask를 사용한다.

- **모아보기**
  ```sql
  TO_CHAR(data1[, format_mask])
  TO_DATE(data1[, format_mask])
  TO_NUMBER(data1[, format_mask])
  ```

#### format mask : 숫자 형식

- `0`, `9`의 경우로 제한되며, 의미는 아래와 같다.

| 숫자 표현식 |               의미                |
| :---------: | :-------------------------------: |
|     `0`     | 무효한 숫자일 경우에도 **0 표시** |
|     `9`     | 무효한 숫자일 경우 **표시 않음**  |

#### format mask : 날짜 형식

- 자주 사용하는 표현만 정리

| 영여 표현식  |              의미               |
| :----------: | :-----------------------------: |
| `YYYY`, `YY` |        년도(각 4, 2자리)        |
|     `MM`     |          월(숫자 표기)          |
|    `MON`     |         월(알파벳 표기)         |
|    `DAY`     |              요일               |
|     `DY`     | 요일의 약자 표기(monday => `m`) |
|    `HH24`    |          시간(0 ~ 24)           |
| `HH`, `HH12` |          시간(0 ~ 12)           |
|     `MI`     |               분                |
|     `SS`     |               초                |

- `NLS_DATE_FORMAT` : 미리 지정한 DB 서버의 date format
  - format_mask를 이용하는 파라미터를 미지정할 경우, 해당 포맷에 맞게 출력된다.
  - 아래의 쿼리를 이용하여 조회/설정할 수 있다.
    ```sql
    -- 조회
    SELECT VALUE FROM NLS_SESSION_PARAMETERS WHERE PARAMETER = 'NLS_DATE_FORMAT';
    -- 설정
    ALTER SESSION SET NLS_DATE_FORMAT = 'new_date_format';
    ```

---

## oracle 날짜 데이터의 이해

- oracle은 **날짜 간의 뺄셈 연산**, **날짜-숫자간의 연산이 가능**하다.

### 날짜 간 뺄셈 연산

- **timestamp** : 대부분의 개발 환경에서 지원하는 날짜 개념으로, php, unix 시스템 등도 차용하는 단위이다.

  - 1970년 1월 1일 0시 0분 0초(1970.01.01 00:00:00) 기준으로 경과한 **초**를 의미
  - oracle에서 `날짜 - 날짜` 계산을 시도할 경우 timestamp를 기준으로 연산하게 된다.

- `SYSDATE` : 현재 **시스템의 시각**을 알려주는 `예약어`

### 날짜-숫자 간 연산

- 기본적으로, oracle 내에서의 날짜는 **하루가 정수 1**에 해당한다.
- 날짜 데이터와 숫자를 연산할 경우 아래와 같이 계산되는 것을 알 수 있다.

```sql
SELECT sysdate + 1 FROM dual; -- DB 서버의 하루 다음 시간
SELECT sysdate + 2/24 + 30/24/50 from dual; -- DB 서버의 2시간 30분 뒤 시간
```

---

## 날짜 관련 함수

- 데이터가 날짜인 경우에만 사용 가능.

### 날짜 연산 함수

- `ADD_MONTHS()` : 기준 날짜 + **지정한 개월 수를 더한 날짜**를 반환
  - 더할 개월 수를 음수로 지정시 뺄셈 연산
- `MONTH_BETWEEN()` : 두 날짜 데이터 간의 **개월 수 차이**를 계산
- `LAST_DAY()` : 지정한 날짜 기준 **달의 마지막 날짜**를 반환
- `NEXT_DAY()` : 지정한 날짜 이후, **가장 가까운 지정 요일의 날짜** 반환
  - **oracle의 셋팅에 따라** 지정 요일의 format이 달라진다.
    - 한글 설정 시 : '월', '월요일' 등...
    - 영문 설정 시 : 'MON', 'MONDAY' etc...
- `ROUND()` : 지정한 단위에서 **날짜를 반올림**하여 반환
- **모아보기**

  ```sql
  ADD_MONTHS(ori_date, add_month)
  MONTH_BETWEEN(date1, date2)
  LAST_DAY(target_date)
  NEXT_DAY(date1, target_day)

  ROUND(target_date, YEAR|MONTH|DAY|HOUR|MINUTE|SECOND)
  ```

---

## null handling

### `NVL()`, `NVL2()` 함수

- 두 함수 모두 `NULL` 값을 인식하여 데이터를 대체한다.
- **차이점**

  - `NVL()` : `NULL`이면 대체 데이터(`replace_data`), 아니면 원본값(`ori_data`)을 그대로 반환
    - nvl 함수는 지정한 데이터와 원본 데이터의 **데이터 형식이 일치해야** 한다.
  - `NVL2()` : `NULL`이면 `ifnull_data`, 아니라면 `default_data` 반환

- **모아보기**
  ```sql
  NVL(ori_data, replace_data)
  NVL2(target_data, default_data, ifnull_data)
  ```

### 그 외 함수

- `NULLIF()` : 두 데이터가 같으면 `NULL`, 다르면 `data1` 반환
- `COALESCE()` : 파라미터로 데이터 나열 시 **첫 번째로 `NULL`이 아닌 값**을 반환
- **모아보기**
  ```sql
  NULLIF(data1, data2)
  COALESCE(data1, data2, data3 ...)
  ```

---

## 조건 처리 함수

- 함수(function) 와 명령(구문, syntax)가 혼용 되어 있다.
  - **`(파라미터)`**가 있는 것은 **함수**, 별도 `(파라미터)` 입력 없이 기재하는 것들은 **구문**으로 이해하면 쉽다.
  - 해당 문서에서는 `()`가 있으면 함수, `~`가 있으면 구문으로 이해하면 된다.
- C에 뿌리를 둔 언어들이 사용하는 switch-case문, if문을 대체할 수 있는 것들이다.

### `DECODE()`

- switch-case 문에 해당하는 SQL의 **함수**.
- 해당 함수 내부에는 **조건문이 올 수 없다**.
- **default 값**은 모든 케이스가 입력되고 **마지막에 기재**한다.

```sql
DECODE(col_name, case1, data1, case2, data2 ..., default_value)
```

### `CASE ~ WHEN`

- if-else 문에 해당하는 SQL의 **구문**.
- 두 가지 형태로 작성할 수 있으니, 예시 코드를 참고 바람
  - 대문자는 구문, 소문자는 데이터.
- `END` 구문은 필수. 누락 시 syntax error가 발생할 수 있다.
- `WHEN` 구문 뒤에 적힌 조건`case{n}`의 경우, 타 프로그래밍 언어처럼 **첫번째 조건부터 연산**한다.

```sql
-- 1. 조건으로 비교
--    이 경우 WHEN 제거, CASE를 IF로 치환하여 if ~ else 구문으로 사용할 수도 있다.
CASE
  WHEN case1 THEN data1
  WHEN case2 THEN data2
  ...
  ELSE default_data
END -- 필수

-- 2. 단일 필드 / SQL 내부 변수에 대한 값 비교
--    이 경우 무조건 동등 비교를 진행한다.
CASE col_name
  WHEN val1 THEN data1
  WHEN val2 THEN data2
  ...
  ELSE default_data
END
```

### `IF()`

- 프로그래밍 언어의 3항 연산자에 해당하는 SQL의 **함수**.
- **여러 조건**에 대한 분기가 **불가능**하며, 단순 true / false의 경우의 값이 분기된다.
- `IF()`를 이용해 다중 분기처리를 하고 싶다면, `true_value`, `false_value` 등에 `IF()`문을 다시 사용할 수 있지만, 권장하는 방법은 아니다.

```sql
IF(case1, ture_value, false_value)
```

---

## '함수 심화'를 마치며...

- 함수에서는 문자열, 숫자, 날짜 데이터를 주로 다뤘으나 **이외의 데이터 타입이 존재**한다.
- `CLOB` : 문자 데이터를 4GB까지 저장할 수 있는 타입
- `BLOB` : 바이너리 코드를 4GB까지 저장할 수 있는 타입
- **토막지식** : 문자열 데이터 타입의 최대 크기는 4KB(4,000 byte)이다.
