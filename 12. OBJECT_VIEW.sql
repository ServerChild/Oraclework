/*
    [ 뷰(VIEW) ]
        - SELECT문을 저장해둘 수 있는 객체
            (자주 쓰는 긴 SELECT문을 저장해두면 긴 SELECT문을 매번 다시 기술할 필요 없음)
            
        - 임시테이블 같은 존재(실제 데이터가 담겨있는건 아님 = 논리적인 테이블)
*/
-- '한국'에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국';


----------------------------------------------------------------------------------------
/*
    < VIEW 생성 방법 >
    
    - 표현법 : CREATE VIEW 뷰명
                AS 서브쿼리문;
*/
-- VIEW를 생성할 수 있는 권한 부여(관리자 계정으로 실행)
GRANT CREATE VIEW TO AIE;

-- VIEW 생성(CREATE VIEW 권한이 없으면 생성 X)
CREATE VIEW VM_EMPLOYEE
    AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME FROM EMPLOYEE
            JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
            JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
            JOIN NATIONAL USING (NATIONAL_CODE);
        
-- VIEM 조회 : 실제로 저장되는 것이 아니기 때문에 VIEM 생성문을 그대로 가져와 조회
-- 뷰는 논리적인 가상테이블(실질적으로는 데이터를 저장하고 있지 않음)
SELECT * FROM VM_EMPLOYEE;

SELECT * FROM VM_EMPLOYEE WHERE NATIONAL_NAME = '한국';

SELECT * FROM VM_EMPLOYEE WHERE NATIONAL_NAME = '러시아';

SELECT * FROM VM_EMPLOYEE WHERE NATIONAL_NAME = '중국';


-- + 참고 + --
-- 생성한 뷰 확인
SELECT * FROM USER_VIEWS;


----------------------------------------------------------------------------------------
/*
    - 뷰 컬럼에 별칭 부여
        -> 서브쿼리의 SELECT절에 함수식이나 산술연산식이 기술되어있을 경우 반드시 별칭 지정   
        
    - CREATE OR REPLACE VIEW 뷰명 : 똑같은 이름의 VIEW가 존재할 경우 그 VIEW 갱신함(덮어쓰기)
*/
-- 전체 사원의 사번, 사원명, 직급명, 성별(남/여), 근무년수를 조회할 수 있는 VIEW(VM_EMP_JOB) 생성
-- 별칭을 지정하지 않아 오류
CREATE OR REPLACE VIEW VM_EMP_JOB
    AS SELECT EMP_ID, EMP_NAME, JOB_NAME
            , DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여')
            , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
            FROM EMPLOYEE
            JOIN JOB USING (JOB_CODE);
           
-- 별칭 지정하는 방법 1(지정할 컬럼 옆에 별칭 부여)
CREATE OR REPLACE VIEW VM_EMP_JOB
    AS SELECT EMP_ID, EMP_NAME, JOB_NAME
            , DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') "성별"
            , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) "근무년수"
            FROM EMPLOYEE
            JOIN JOB USING (JOB_CODE);
        
-- VIEW 조회
SELECT * FROM VM_EMP_JOB;


-- 별칭 지정하는 방법 2(뷰명 옆에 각 컬럼에 대한 별칭 나열하여 부여)
CREATE OR REPLACE VIEW VM_EMP_JOB(사번, 사원명, 직급명, 성별, 근무년수)
    AS SELECT EMP_ID, EMP_NAME, JOB_NAME
            , DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여')
            , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
            FROM EMPLOYEE
            JOIN JOB USING (JOB_CODE);
        
-- VIEW 조회
SELECT 사원명, 직급명 FROM VM_EMP_JOB WHERE 성별 = '여';

SELECT * FROM VM_EMP_JOB WHERE 근무년수 >= 20;


-- VIEW(뷰) 삭제
DROP VIEW VM_EMP_JOB;


----------------------------------------------------------------------------------------
-- 생성된 뷰를 이용하여 DML(INSERT, UPDATE, DELETE) 가능
-- 뷰를 통해 조작하면 실제 데이터가 담겨 있는 원래 데이터베이스 테이블에 반영됨
-- VIEW 생성
CREATE OR REPLACE VIEW VM_JOB AS (SELECT JOB_CODE, JOB_NAME FROM JOB);

-- VIEW 조회
SELECT * FROM VM_JOB; -- VIEW(뷰)
SELECT * FROM JOB; -- 원래 테이블(TABLE)

-- 뷰를 통한 INSERT
INSERT INTO VM_JOB VALUES('J8', '인턴');

-- 뷰를 통한 UPDATE
UPDATE VM_JOB SET JOB_NAME =  '알바' WHERE JOB_CODE = 'J8';

-- 뷰를 통한 DELETE
DELETE FROM VM_JOB WHERE JOB_CODE = 'J8';


----------------------------------------------------------------------------------------
/*
    * 단, DML명령어로 조작이 불가능한 경우가 더 많음
        - 뷰에 정의되어있지 않은 컬럼을 조작하려는 경우
        - 뷰에 정의되어있는 컬럼 중에 원래 테이블 상에 NOT NULL 제약조건이 지정되어있는 경우
        - 산술연산식이나 함수식으로 정의되어 있는 경우
        - 그룹함수나 GROUP BY절이 포함되어 있는 경우
        - DISTINCT 구문이 포함된 경우
        - JOIN을 이용하여 여러 테이블을 연결시켜놓은 경우
*/
-- 뷰(VIEW) 정의
CREATE OR REPLACE VIEW VM_JOB 
    AS SELECT JOB_CODE FROM JOB;


--== 뷰에 정의되어 있지 않은 컬럼을 조작할 경우 ==--
-- NSERT(오류)
INSERT INTO VM_JOB(JOB_CODE, JOB_NAME) VALUES('J8', '인턴');

-- UPDATE(오류)
UPDATE VM_JOB SET JOB_NAME = '알바' WHERE JOB_CODE = 'J8';

-- DELETE(오류)
DELETE FROM VM_JOB WHERE JOB_NAME = '사원';


--== 뷰에 정의되어있는 컬럼 중에 원래 테이블 상에 NOT NULL 제약조건이 지정되어있는 경우 ==--
-- 뷰(VIEW) 생성
CREATE OR REPLACE VIEW VM_JOB 
    AS SELECT JOB_NAME FROM JOB;

-- INSERT(오류)
-- 실제 테이블에 INSERT할 때 VALUES(NULL, '사원')를 삽입할 수 없음(JOB_CODE는 PK라 NULL값 X) 
INSERT INTO VM_JOB VALUES('사원');

-- DELETE(오류)
-- 외래키(FK)가 설정되어 있는 경우 자식 테이블에서 사용하고 있으면 삭제안됨
DELETE FROM VM_JOB WHERE JOB_NAME = '사원';


--== 산술연산식이나 함수식으로 정의되어 있는 경우 ==--
-- 뷰(VIEW) 생성
CREATE OR REPLACE VIEW VM_EMP_SAL 
    AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY * 12 "연봉" FROM EMPLOYEE;

-- INSERT(오류)
-- "연봉"이 기존테이블에 없기 때문에 오류
INSERT INTO VM_EMP_SAL VALUES(600, '가나다', 3000000, 36000000);

-- UPDATE(오류)
-- "연봉"이 기존테이블에 없기 때문에 오류
UPDATE VM_EMP_SAL SET 연봉 = 40000000 WHERE EMP_ID = 301;

-- UPDATE(실행o)
-- 기존테이블에 있는 SALARY를 UPDATE 했기때문에 가능
UPDATE VM_EMP_SAL SET SALARY = 40000000 WHERE EMP_ID = 301;

SELECT * FROM VM_EMP_SAL ORDER BY 연봉;

-- DELETE(실행o)
DELETE FROM VM_EMP_SAL WHERE 연봉 = 16560000;


--== 그룹함수나 GROUP BY절이 포함되어 있는 경우 ==-- 
-- 뷰(VIEW) 생성
CREATE OR REPLACE VIEW VM_GROUP_DEPT 
    AS SELECT DEPT_CODE, SUM(SALARY) "합계", CEIL(AVG(SALARY)) "평균" 
        FROM EMPLOYEE GROUP BY DEPT_CODE;
        
SELECT * FROM VM_DEPT;

-- INSERT(오류)
INSERT INTO VM_GROUP_DEPT VALUES('D3', 8000000, 4000000);

-- UPDATE(오류)
UPDATE VM_GROUP_DEPT SET 합계 = 6000000 WHERE DEPT_CODE = 'D2';

-- DELETE(오류)
DELETE FROM VM_GROUP_DEPT WHERE 합계 = 17700000;


--== DISTINCT 구문이 포함된 경우 ==--
-- 해당하는 값이 하나일지 여러개일지 모르기 때문에 오류
-- 뷰(VIEW) 생성
CREATE OR REPLACE VIEW VM_JOB 
    AS SELECT DISTINCT JOB_CODE FROM EMPLOYEE;

SELECT * FROM VM_JOB;
 
-- INSERT(오류)
INSERT INTO VM_JOB VALUES('J8');

-- UPDATE(오류)
UPDATE VM_JOB SET JOB_CODE = 'J8' WHERE JOB_CODE = 'J1';

-- DELETE(오류)
DELETE FROM VM_JOB WHERE JOB_CODE = 'J1';


--== JOIN을 이용하여 여러 테이블을 연결시켜놓은 경우 ==--
-- 뷰(VIEW) 생성
CREATE OR REPLACE VIEW VM_JOIN 
    AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE FROM EMPLOYEE
        JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
        
SELECT * FROM VM_JOIN;
                
-- INSERT(오류)
INSERT INTO VM_JOIN VALUES(700, '아무개', '총무부');

-- UPDATE(실행o)
UPDATE VM_JOIN SET EMP_NAME = '김새로이' WHERE EMP_ID = 200;

-- UPDATE(오류)
-- JOIN을 통해 부서를 가져왔기 때문에 EMPLOYEE테이블의 DEPT_CODE는 변경x
UPDATE VM_JOIN SET DEPT_TITLE = '인사관리부' WHERE EMP_ID = 200;

-- DELETE(실행o)
DELETE FROM VM_JOIN WHERE EMP_ID = 200;

ROLLBACK;


----------------------------------------------------------------------------------------
/*
    * VIEW 옵션
        - 표현식
            -> CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰명 AS 서브쿼리 [WITH CHECK OPTION]
                                                                          [WITH READ ONLY]
        
        + OR REPLACE : 기존에 동일 뷰가 있으면 갱신시키고, 없으면 새로 생성
        + FORCE | NOFORCE
            -> FORCE : 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰 생성
            -> NOFORCE : 서브쿼리에 기술된 테이블이 존재해야만 뷰 생성(생략시 기본값)
        + WITH CHECK OPTION : DML시 서브쿼리에 기술된 조건에 부합하는 값으로만 DML이 가능하도록 함
        + WITH READ ONLY : 뷰에 대해 조회만 가능(DML문(SELECT 제외) 불가)
*/
--== FORCE | NOFORCE ==-- 
-- NOFORCE
CREATE OR REPLACE NOFORCE VIEW VM_EMP 
    AS SELECT TCODE, TNAME, TCOUNT FROM TT;

-- FORCE
CREATE OR REPLACE FORCE VIEW VM_EMP 
    AS SELECT TCODE, TNAME, TCOUNT FROM TT;

-- 경고와 함께 뷰는 생성이 되지만, TT 테이블을 생성해야만 VIEW 활용할 수 있음
CREATE TABLE TT (
    TCODE NUMBER, 
    TNAME VARCHAR2(20), 
    TCOUNT NUMBER
);

SELECT * FROM VM_EMP;


--== WITH CHECK OPTION ==--
-- WITH CHECK OPTION 없이 VIEW 생성
CREATE OR REPLACE VIEW VM_EMP 
    AS SELECT * FROM EMPLOYEE WHERE SALARY >= 3000000;

SELECT * FROM VM_EMP;

-- 200번 사원의 급여를 200만원으로 변경
-- 실행 전(9명) / 실행 후(8명)
UPDATE VM_EMP SET SALARY = 2000000 WHERE EMP_ID = 200;


-- WITH CHECK OPTION 사용해 VIEW 생성
CREATE OR REPLACE VIEW VM_EMP_CH 
    AS SELECT * FROM EMPLOYEE WHERE SALARY >= 3000000 WITH CHECK OPTION;

-- 오류 : 서브쿼리에 기술된 조건에 부합되지 않기 때문에 변경되지 않음
UPDATE VM_EMP_CH SET SALARY = 2000000 WHERE EMP_ID = 201;

-- 실행o
UPDATE VM_EMP_CH SET SALARY = 4000000 WHERE EMP_ID = 202;


--== WITH READ ONLY ==--
CREATE OR REPLACE VIEW VM_EMP_READ
    AS SELECT EMP_ID, EMP_NAME, BONUS FROM EMPLOYEE WHERE BONUS IS NOT NULL WITH READ ONLY;

-- 검색만 가능
SELECT * FROM VM_EMP_READ;

-- 오류
DELETE FROM VM_EMP_READ WHERE EMP_ID = 200;