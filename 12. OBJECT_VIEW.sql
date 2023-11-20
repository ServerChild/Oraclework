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
CREATE OR REPLACE VIEW VM_JOB AS (SELECT JOB_CODE FROM JOB);

--= 뷰에 정의되어 있지 않은 컬럼을 조작할 경우 =--
-- 뷰를 통해 INSERT
INSERT INTO VM_JOB(JOB_CODE, JOB_NAME) VALUES('J8', '인턴');

-- 뷰를 통해 UPDATE
UPDATE VM_JOB SET JOB_NAME = '알바' WHERE JOB_CODE = 'J8';

-- 뷰를 통해 DELETE
DELETE FROM VM_JOB WHERE JOB_NAME = '사원';
