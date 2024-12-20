/*
    Index
    ==> 검색속도를 빠르게 하기 위해서 B-Tree기법으로 색인을 만들어
        SELECT를 바른 속도로 처리할 수 있게 하는 것.
        
        index를 만들면 나쁜 경우
      
        1. 데이터 양이 너무 적을때 : 오히려 속도 저하.
        2. 데이터의 입출력이 빈번한 경우 : 그때마다 index수정하니 속도 저하.
        
        index를 만들면 좋은 경우
      
        1. join등에 많이 사용되는 필드가 존재하는 경우
        2. null 값이 많이 존재하는 경우
        3. where 조건절에 많이 사용되는 필드가 존재하는 경우.
        
      + 제약조건을 추가할 때
        primary key, unique 를 부여하면, 해당 필드에 자동적으로 index처리 됨.
        
    index 생성 방법
    
        1. 일반 인덱스 만들기 (NON UNIQUE INDEX)
        CREATE INDEX 인덱스이름
        ON
            테이블이름(사용할필드이름)
        
        일반 인덱스는 데이터가 중복되어도 괜찮다.
        
        
        2. UNIQUE INDEX 만들기
        ==> 인텍스에 쓸 데이터들이 반드시 UNIQUE하다는 보장이 있는 경우만 생성.
        
        CREATE UNIQUE INDEX 인텍스이름
        ON
            테이블이름(필드이름)
            
        이 때, 지정한 필드는 반드시 UNIQUE하다는 보장이 있어야 한다.
        
        UNIQUE INDEX의 장점 : 이진 검색을 사용하기에, 일반 INDEX보다 빠르다.
        
        
        3. 결합 인덱스
        ==> 여러개의 필드를 결합해 하나의 인덱스를 만든다.
            전제조건 : 사용되는 필드의 조합이 반드시 PRIMARY여야(복합키) 한다.
            
            하나의 필드로 UNIQUE 인덱스를 만들지 못하는 경우,
            여러개의 필드를 합쳐서 UNIQE INDEX를 만드는 방법.
            
            CREATE UNIQUE INDEX 인덱스이름
            ON
                테이블이름(필드이름, 필드이름, . . . )
            
          + 복합 키 제약조건 추가하기
            CREATE TABLE 테이블이름(
                필드 데이터타입(길이),
                . . .
                CONSTRAINT 제약조건이름 PRIMARY KEY(필드이름, 필드이름, . . .)
            )
            
            
        4. 비트 인덱스
        ==> 주로 그 안에 들어있는 데이터가 몇 가지 중 하나인 경우 많이 사용.
            ex.
                GEN 필드엔 F, M, N만 입력되게 CHECK되어 있다.
                DEPTNO필드엔 10, 20, 30, 40만 입력되어 있다.
                
            처럼 domain이 정해져 있는 경우만 사용 가능하다.
            
            CREATE BITMAP IDNEX 인덱스이름
            ON
                테이블이름(필드이름)
*/
-- 회원 테이블의 이름을 이용해 인덱스를 만드시오.
CREATE INDEX name_idx ON member(name);
