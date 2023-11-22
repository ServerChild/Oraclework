/*
    < ALTER >
        - 객체를 변경하는 구문
    
        - 표현식 : ALTER TABLE 테이블명 변경할내용;
    
        * 변경할 내용
          1) 컬럼 추가 / 수정 / 삭제
          2) 제약조건 추가 / 삭제   -> 수정 불가(수정하고자하면 삭제 후 새로 추가)
          3) 컬럼명 / 제약조건명 / 테이블명 변경
*/  
--=== 컬럼 추가 / 수정 / 삭제 ===--
--= 컬럼 추가 (ADD) : ADD 컬럼명 데이터타입 [DEFAULT 기본값] =--

-- DEPT_COPY테이블에 CNAME 컬럼 추가
-- 새로운 컬럼이 만들이지고 기본적으로 NULL로 채워짐
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);


-- DEPT_COPY테이블에 LNAME 컬럼 추가, 기본값은 한국으로 추가
-- 새로운 컬럼이 만들이지고 내가 지정한 기본값으로 채워짐
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '한국';


--= 컬럼 수정 (MODIFY) =-- 
-- 데이터 타입 수정 : MODIFY 컬럼명 바꾸고자하는데이터타입
-- DEFAULT값 수정 : MODIFY 컬럼명 DEFAULT 바꾸고자하는기본값

-- DEPT_COPY테이블의 DEPT_ID의 데이터 타입을 CHAR(3)으로 수정
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);


-- DEPT_COPY테이블의 DEPT_ID의 데이터 타입을 NUMBER으로 수정
-- 오류발생 : 컬럼값에 영문이 있음. 또한 컬럼의 데이터 타입을 변경하기 위해서는 해당 컬럼의 값을 모두 지워야 변경 가능
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER;


-- DEPT_COPY테이블의 DEPT_TITLE의 데이터 타입을 VARCHAR2(10) 수정
-- 오류발생 : 컬럼의 값이 10BYTE가 넘는 데이터가 들어있음
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(10);


-- DEPT_TITLE : VARCAHR2(40)
-- LOCATION_ID : VARCHAR2(2)
-- LNAME : '미국'으로 변경


-- 다중변경
ALTER TABLE DEPT_COPY
    MODIFY DEPT_TITLE VARCHAR2(40)
    MODIFY LOCATION_ID VARCHAR2(2)
    MODIFY LNAME DEFAULT '미국';


--= 컬럼 삭제(DROP COLUMN) =--
-- 표현법 : ALTER TABLE 테이블명 DROP COLUMN 컬럼명;
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY;


-- DEPT_COPY2 테이블에서 LNMAE 컬럼 삭제
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;


-- 컬럼 삭제는 다중 안됨
ALTER TABLE DEPT_COPY2
    DROP COLUMN DEPT_TITLE
    DROP COLUMN LNAME;


ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID;

-- 오류발생 : 최소 한개의 컬럼은 존재해야 함
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;


--------------------------------------------------------------------------------
--=== 제약조건 추가 / 삭제 ===--
--= 제약조건 추가 =--
/*
    * ALTER TABLE 테이블명 변경할내용;
       - PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명);
       - FOREIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명[(참조할컬럼명)];
       - UNIQUE : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명);
       - CHECK : ALTER TABLE 테이블명 ADD CHECK(컬럼에 대한 조건식);
       - NOT NULL : ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;
*/

--= 제약조건 삭제 ==-
-- 표현법 : ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건;
--          ALTER TABLE 테이블명 MODIFY 컬럼명 NULL;  // NULL일때는 수정

ALTER TABLE EMPLOYEE DROP CONSTRAINT F_JOB;

ALTER TABLE EMP_DEPT MODIFY EMP_NAME NULL; 


--------------------------------------------------------------------------------
--=== 컬럼명 / 제약조건명 / 테이블명 변경 (RENAME) ===--
--= 컬럼명 변경 : RENAME COLUMN 기존컬럼명 TO 바꿀컬럼명 =--
-- DEPT_COPY 테이블의 DEPT_TITLE를 DEPT_NAME 으로  컬럼명 변경
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

--= 제약조건명 변경 : RENAME CONSTRAINT 기존제약조건명 TO 바꿀제약조건명 ==-
-- EMPLOYEE_COPY테이블의 기본키의 제약조건의 이름 변경
ALTER TABLE EMPLOYEE_COPY RENAME CONSTRAINT SYS_C007417 TO EC_PK;

--= 테이블명 변경 :  [기존테이블명] RENAME TO 바꿀테이블명 =--
-- DEPT_COPY => DEPT_TEST
ALTER TABLE DEPT_COPY RENAME  TO DEPT_TEST;


--------------------------------------------------------------------------------
-- 테이블 삭제 : DROP TABLE 테이블명;
/*
    - 조건
        -> 어딘가에서 참조되고 있는 부모테이블은 함부로 삭제 안됨
        -> 만약 삭제를 하고싶다면
            + 방법1. 자식테이블을 먼저 삭제 후 부모테이블 삭제
            + 방법2. 그냥 부모테이블만 삭제하는데 제약조건까지 같이 삭제하는 방법
                             DROP TABLE 테이블명 CASCADE CONSTRINT;
*/
DROP TABLE DEPT_TEST;