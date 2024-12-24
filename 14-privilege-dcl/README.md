# 권한(Privilege) & DCL(Data Control Language)

## 사용자 관리

- **`system`(타 DBMS에서는 default `admin`) 계정**을 통해 사용자 계정을 관리할 수 있다.
- **사용자**와 사용자들이 사용하는 **권한 관리**를 수행하는 것이 **DCL 명령**.
- **사용자 계정** : oracle에서 한 사람이 사용할 수 있는 **가장 작은 단위의 DB**

### `CREATE USER` : 사용자 계정 생성

- 사용자 계정 또한 oracle **DB 객체**이기 때문에 **DDL 명령을 사용**한다.

1. 관리자 모드 접속
2. `CREATE USER` 실행

   ```sql
   CREATE USER user_name IDENTIFIED BY password [ACCOUNT UNLOCK] [WITH options...];

   -- 현재 계정 현황 조회
   SHOW USER;
   ```

   - **계정의 초기 생성** : oracle의 새 계정의 기본 값은 **아무 권한도 없는 상태**.
     - **접속 포함 모든 작업이 불가능**하며, 따로 `UNLOCK` 처리가 필요하다.
   - `ACCOUT UNLOCK` : 계정의 **잠금상태 해제** 옵션. 해당옵션 활성화시 생성과 동시에 계정이 활성화 된다.
     - 계정이 **접속 가능**해지며, 그 외엔 어떠한 권한도 부여되지 않는다.

### `DROP USER` : 사용자 계정 삭제

```sql
DROP USER user_name [CASCADE];

-- e.g. test_user 계정과, 관련된 모든 객체 삭제
DROP USER test_user CASCADE;
```

- `CASCADE` : 활성화 시 해당 계정과 관련된 **모든 객체, 권한을 함께 삭제**
- cascde 옵션 활성화 시 **_객체 간 종속성이 존재하는 경우 함께 삭제_** 되니, **_삭제 범위에 대한 명확한 파악이 중요_**하다.
  - FK 관계에 있는 타 계정의 테이블
  - 계정 내 테이블을 참조하는 index, view 등의 객체가 존재하는 경우

---

## DCL(Data Control Language)

- DCL은 **DB 내 데이터(유저 등)을 제어**하는 명령이다.
- 원칙적으로 사용자 계정은 관리자가 **허락한 명령만 실행할 수 있다**.

- `GRANT` : 권한 부여
  - oracle의 경우, **system(관리자) 계정에서 실행해야** 원활한 권한 부여가 가능하다.
  - DBMS에 따라 명칭은 다르지만, **최고 권한 계정**을 가진 **책임자가 부여**하는 경우가 일반적이다.
- `REVOKE` : 권한 박탈

### `GRANT` : 사용자 권한 부여

- **권한(privilege) 부여** : 관리자가 각 계정에 **각각의 권한을 지정**하여 처리하는 방식

```sql
-- 관리자 권한이 있는 계정으로 실행해야 함
GRANT privilege1, privilege2 ...
[ON obj_name]
TO (user_name|role_name) [WITH options...];

-- e.g. test01에게 테이블 생성 권한 부여
GRANT UNLIMITED TABLESPACE, CREATE TABLE TO test01;
```

- `privileges` : oracle에서 지정된 예약어를 사용한다. [oracle privilege 문서](https://docs.oracle.com/database/timesten-18.1/TTSQL/privileges.htm#TTSQL338)를 참고하여 권한 지정 가능
- `obj_name` : oracle 내 **객체를 지정**한다. view, index, user 등이 올 수 있으며, 특정 계정 내 객체일 경우 `user_name.obj_name`으로 기재한다. [oracle privilege 문서](https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/GRANT.html)를 참고하여 옵션 지정 가능
  - `GRANT` 권한이 있는 계정이 계정 내 테이블 권한을 부여할 때도 **명시적으로 작성**해 주는 것을 추천
- `WITH options` : `ADMIN` 권한, `GRANT` 권한 등 함께 부여할 수 있는 권한을 기재한다.
  - `WITH ADMIN OPTION` : **관리자 권한** 위임 옵션
  - `WITH GRANT OPTION` : **_부여받은 권한의_** **전파 가능** 옵션

### `REVOKE` : 사용자 권한 박탈

- `REVOKE` 명령을 통해 권한 박탈, 회수
- `role_name` : 후술할 역할(role)에 해당, 사용자 계정과 같이 권한 회수 가능

```sql
-- 방법 1
REVOKE privilege1, privilege2 ...
[ON obj_name] TO (user_name|role_name); -- WITH 구문은 사용할 수 없다.

-- 방법 2
REVOKE sys_privilege1, sys_privilege2 ...
FROM (user_name|role_name);
```

### 존재하는 권한 조회

- oracle의 **`dba_sys_privs`, `user_tab_privs` 테이블 등**을 이용해 현재 사용자 계정, 역할 당 부여된 권한을 조회 가능 (**`example.sql` 필참**)
- `dba_sys_`로 시작하는 테이블 : **system 계정**에 귀속
- `user_`로 시작하는 테이블 : **계정 당** 귀속
- 이때, 검색할 role과 사용자 계정 명은 **대문자로 기재해야 검색 가능**

---

### 역할(`ROLE`)

- **역할(role)** : 관련 **권한을 묶은 세트**로, role을 통한 권한 부여 시 **여러개의 권한을 한번에** 부여 가능

### 대표적인 oracle 내장 Role

- `CONNECT` : 주로 **`CREATE` 관련** 권한 묶음
  - 포함된 권한 : `ALTER SESSION`(세션의 속성 변경) , `CREATE CLUSTER`, `CREATE DATABASE LINK`, `CREATE SEQUENCE`, `CREATE SESSION`, `CREATE SYNONYM`, `CREATE TABLE`, `CREATE VIEW`
- `RESOURCE` : 사용자 **객체(table, sequence 등) 생성 관련** 권한 묶음
  - 포함된 권한 : `CREATE CLUSTER`, `CREATE INDEXTYPE`, `CREATE OPERATOR`, `CREATE PROCEDURE`, `CREATE SEQUENCE`, `CREATE TABLE`, `CREATE TRIGGER`, `CREATE TYPE`
- `DBA` : **관리자 계정에서 처리 가능한 권한** 묶음
  - 포함된 권한 : **_모든 시스템 권한_**

### 커스텀 Role 생성, 권한 부여(`GRANT`)

```sql
-- 1. role 생성
CREATE ROLE role_name;

-- 2. role 권한 부여(생략 가능)
GRANT privilege1, privilege2 ...
[ON obj_name]
TO role_name [WITH options...]; -- GRANT USER와 동일

-- 3. 사용자 계정에 역할(role) 부여
GRANT role_name TO user_name;
```

- oracle 내장 role 등 **이미 존재하는 `ROLE` 사용** 시 `2. role 권한 부여` 단계 생략 가능
- **`ROLE` 권한 회수 및 삭제** : **사용자(`USER`)와 같은 방법**으로 가능하다.

---

## 동의어(`SYNONYM`)

- 쿼리가 끝난 뒤에도 사용 가능한, 별칭(alias)와 비슷한 개념
- 동의어 설정 시 **테이블에 대한 별칭**을 붙여 **여러 사용자가 사용 가능**하다.
- **목적** : **정보 보호**. **실제 DB객체**의 이름을 **은닉**해 객체 보호

```sql
CREATE [PUBLIC] SYNONYM syn_name
FOR tbl_name;
```

- `PUBLIC` : 생략 시 **동일 계정에서만** 사용 가능
  - **타 계정에서 사용**을 원하는 경우 **`PUBLIC` 설정 필요**
