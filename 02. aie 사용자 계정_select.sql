-- 테이블 컬럼의 정보 조회 : SELECT
/*
    홑따옴표(') : 문자열일 때
    쌍따옴표(")  : 컬럼명일 때
    
    <SELECT> : 데이터를 조회할 때 사용하는 구문
        - RESULT SET : SELECT문을 통해 조회된 결과물(조회된 행의 집합)
        - 표현법 : SELECT 조회하려는_컬럼명, ... FROM 테이블명;
            -> 전체 컬럼을 조회 : *
*/

-- 테이블 모든 컬럼 조회
SELECT * FROM EMPLOYEE;

SELECT * FROM DEPARTMENT;


--====================================================--
-- 테이블 특정 컬럼 조회
-- EMPLOYEE 테이블에서 사번, 이름, 번호 조회
SELECT EMP_ID, EMP_NAME, PHONE FROM EMPLOYEE;

-- JOB 모든 컬럼 조회
SELECT * FROM JOB;

-- EMPLOYEE 테이블에서 사번, 이름, 급여, 입사일만 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE FROM EMPLOYEE;


--====================================================--
-- 문제 --
-- JOB 테이블에서 직급명만 조회
SELECT JOB_NAME FROM JOB;

-- DEPARTMENT 테이블의 모든 컬럼 조회
SELECT * FROM DEPARTMENT;

-- DEPARTMENT 테이블의 부서코드, 부서명만 조회
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;

-- EMPLOYEE 테이블에 사원명, 이메일, 전화번호, 입사일, 급여 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE, SALARY FROM EMPLOYEE;


--====================================================--
/*
    <컬럼값을 통한 산술연산>
        - SELECT절 컬럼명 작성부분에 산술연산 가능(산술연산된 결과 조회)
        - 산술연산 중 NULL이 존재하면 결과는 무조건 NULL, 별도 처리 가능
*/

-- EMPLOYEE에서 사원명, 사원의 연봉(급여 * 12) 조회
SELECT EMP_NAME, SALARY * 12 FROM EMPLOYEE;

-- EMPLOYEE에서 사원명, 급여, 보너스 조회
SELECT EMP_NAME, SALARY, BONUS FROM EMPLOYEE;

-- EMPLOYEE에서 사원명, 급여, 보너스, 연봉, 보너스를 포함한 연봉((급여 + (보너스 * 급여)) * 12) 조회
SELECT EMP_NAME, SALARY, BONUS, SALARY * 12, (SALARY + (SALARY * BONUS)) * 12 FROM EMPLOYEE;

-- EMPLOYEE에서 사원명, 입사일, 근무일수(오늘날짜 - 입사일) 조회
-- DATE형 끼리도 연산 가능 : 결과값은 일 단위, 함수로 DATE 날짜처리하면 초단위로 관리할 수 있음
-- 오늘 날짜 : SYSDATE
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE FROM EMPLOYEE;


--====================================================--
/*
    <컬럼명 별칭 지정>
        - 산술연산시 산술에 들어간 수식 그대로 컴럼명이 됨, 이때 별칭을 부여하면 깔끔하게 처리
        - 표현법 : 컬럼명 별칭 /컬럼명 AS 별칭 / 컬럼명 "별칭" / 컬럼명 AS "별칭"
        - 별칭에 띄어쓰기나 특수문자가 포함되면 반드시 쌍따옴표(")를 넣어줘야 함
*/

-- 예시 1
SELECT EMP_NAME 사원명, SALARY AS 급여, BONUS "보너스", SALARY * 12 "연봉(원)", (SALARY + (SALARY * BONUS)) * 12 "총 소득" FROM EMPLOYEE;

SELECT EMP_NAME AS 사원명, HIRE_DATE "입사일(일)", SYSDATE - HIRE_DATE AS "근무일수(일)" FROM EMPLOYEE;


--====================================================--
/*
    <리터럴>
        - 임의로 지정된 문자열(')
        - SELECT절에 리터럴을 제시하면 마치 테이블 상에 존재하는 데이터처럼 조회 가능
        - 조회된 RESULT SET의 모든 행에 반복적으로 출력
*/

-- EMPLOYEE에 사번, 사원명, 급여, 원 AS 단위조회
-- 숫자 정렬 기본값(오른쪽), 문자열 정렬 기본값(왼쪽)
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS 단위 FROM EMPLOYEE;


--====================================================--
/*
    <연결 연산자 : ||(버티컬바)>
        - 여러 컬럼값들을 마치 하나의 컬럼값인것처럼 연결하거나 컬럼값과 리터럴 연결
*/

-- EMPLOYEE에 사번, 사원명, 급여를 하나의 컬럼으로 조회
-- 띄워쓰기 하고 싶을때는 연결 연산자(||) 사이에 ' '(빈칸) 넣어줌
SELECT EMP_ID || ' ' || EMP_NAME || ' ' || SALARY FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SALARY, SALARY || '원' FROM EMPLOYEE;

-- 홍길동의 월급은 900000원 입니다. 출력
SELECT EMP_NAME || '의 월급은 ' || SALARY || '원 입니다.' FROM EMPLOYEE;

-- 홍길동의 전화번호는 PHONE이고 이메일은 EMAIL 입니다.
SELECT EMP_NAME || '의 전화번호는 ' || PHONE || '이고 이메일은 ' || EMAIL || '입니다.' FROM EMPLOYEE;


--====================================================--
/*
    <DISTINCT> : 컬럼의 중복된 값들을 한번씩만 표시하고자 할 때
        - 유의사항 : SELECT절에서 DISTINCT는 한번만 기술
*/
-- EMPLOYEE에서 직급코드 출력
SELECT JOB_CODE FROM EMPLOYEE;

-- EMPLOYEE에서 직급코드 중복제외하고 출력
SELECT DISTINCT JOB_CODE FROM EMPLOYEE; 

-- EMPLOYEE에서 부서코드 중복제외하고 출력
SELECT DISTINCT DEPT_CODE FROM EMPLOYEE;

-- DISTINCT는 한번만 기술할 수 있기 때문에 결과값이 제대로 출력 x
-- 두개의 컬럼에 대해 조합할 수 있는 경우의 수가 중복을 제외하고 한개씩 나옴
SELECT DISTINCT JOB_CODE, DEPT_CODE FROM EMPLOYEE;
-- SELECT DISTINCT JOB_CODE, DISTINCT DEPT_CODE FROM EMPLOYEE; // 오류


--====================================================--
/*
    <WHERE절> : 조회하고자 하는 테이블에서 특정 조건에 만족하는 데이터만 조회할 때
        - WHERE절에 조건식 제시
        - 표현법 : SELECT 컬럼명, 컬럼명, ... FROM 테이블명 WHERE 조건;
        - 비교연산자(>>), 대소비교(>, <, >=, <=), 같음(=), 같지않음(!=, ^=, <>)
*/
-- EMPLOYEE에서 부서코드가 'D9'인 사원들 모든 컬럼 조회
SELECT * FROM EMPLOYEE WHERE DEPT_CODE = 'D9';