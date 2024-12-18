CREATE TABLE dept(
    deptno  NUMBER(10),
    dname   VARCHAR2(14),
    loc     VARCHAR2(13) 
);

INSERT INTO dept (deptno, dname, loc) VALUES
(10, 'ACCOUNTING', 'NEW YORK'),
(20, 'RESEARCH',   'DALLAS'),
(30, 'SALES',      'CHICAGO'),
(40, 'OPERATIONS', 'BOSTON');

CREATE TABLE emp (
    empno               NUMBER(4) NOT NULL,
    ename               VARCHAR2(10),
    job                 VARCHAR2(9),
    mgr                 NUMBER(4) ,
    hiredate            DATE,
    sal                 NUMBER(7,2),
    comm                NUMBER(7,2),
    deptno              NUMBER(2)
        CONSTRAINT EMP_DEPT_FK REFERENCES DEPT(DEPTNO)
);

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES
(7839,  'KING',     'PRESIDENT',    NULL,   TO_DATE('1981-11-17', 'YYYY-MM-DD'),    5000,   NULL,   10),
(7698,  'BLAKE',    'MANAGER',      7839,   TO_DATE('1981-05-01', 'YYYY-MM-DD'),    2850,   NULL,   30),
(7782,  'CLARK',    'MANAGER',      7839,   TO_DATE('1981-05-09', 'YYYY-MM-DD'),    2450,   NULL,   10),
(7566,  'JONES',    'MANAGER',      7839,   TO_DATE('1981-04-01', 'YYYY-MM-DD'),    2975,   NULL,   20),
(7654,  'MARTIN',   'SALESMAN',     7698,   TO_DATE('1981-09-10', 'YYYY-MM-DD'),    1250,   1400,   30),
(7499,  'ALLEN',    'SALESMAN',     7698,   TO_DATE('1981-02-11', 'YYYY-MM-DD'),    1600,   300,    30),
(7844,  'TURNER',   'SALESMAN',     7698,   TO_DATE('1981-08-21', 'YYYY-MM-DD'),    1500,   0,      30),
(7900,  'JAMES',    'CLERK',        7698,   TO_DATE('1981-12-11', 'YYYY-MM-DD'),    950,    NULL,   30),
(7521,  'WARD',     'SALESMAN',     7698,   TO_DATE('1981-02-23', 'YYYY-MM-DD'),    1250,   500,    30),
(7902,  'FORD',     'ANALYST',      7566,   TO_DATE('1981-12-11', 'YYYY-MM-DD'),    3000,   NULL,   20),
(7369,  'SMITH',    'CLERK',        7902,   TO_DATE('1980-12-09', 'YYYY-MM-DD'),    800,    NULL,   20),
(7788,  'SCOTT',    'ANALYST',      7566,   TO_DATE('1982-12-22', 'YYYY-MM-DD'),    3000,   NULL,   20),
(7876,  'ADAMS',    'CLERK',        7788,   TO_DATE('1983-01-15', 'YYYY-MM-DD'),    1100,   NULL,   20),
(7934,  'MILLER',   'CLERK',        7782,   TO_DATE('1982-01-11', 'YYYY-MM-DD'),    1300,   NULL,   10);

COMMIT;