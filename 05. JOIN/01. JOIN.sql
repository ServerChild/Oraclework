/*
    <JOIN> : 두개 이상의 테이블에서 데이터를 조회할 때 사용하는 구문
        - 조회 결과는 하나의 결과물(RESULT SET)로 나옴
        - 관계형 데이터베이스에서 SQL문을 이용한 테이블간의 "관계"를 맺는 방법
        
        - 관계형 데이터베이스는 최소한 데이터로 각각 테이블에 담고 있음
            -> 중복을 최소화하기 위해 최대한 나누어서 관리
        
        - "오라클전용구문"과 "ANSI(미국국립표준협회) 구문"으로 나뉨
        
        - [용어 정리]
        
            오라클 전용 구문                              ANSI
        ---------------------------------------------------------------------------      
          등가조인(EQUAL JOIN)              내부조인(INNER JOIN) => JOIN USING / ON
                                            자연조인(NATURL JOIN) => JOIN USIN
        ---------------------------------------------------------------------------
          포괄조인(LEFT JOIN)                왼쪽조인(LEFT OUTER JOIN)
                 (RIGHT JOIN)                오른쪽조인(RIGHT OUTER JOIN)
                                             전체 외부 조인(FULL OUTER JOIN)
        ---------------------------------------------------------------------------
          셀프조인(SELF JOIN)                            JOIN ON
          비등가 조인(NON EQUL JOIN)      
        ---------------------------------------------------------------------------
          카테시안 곱(CARTESIAN PRODUCT)             교차 조인(CROSS JOIN)
*/
-- 전체 사원들의 사번, 사원명, 부서코드, 부서명 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE;

SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;


--===========================================================================--
/*
    [ 등가 조인(EQUAL JOIN) / 내부조인(INNER JOIN) ]
        - 연결시키고자 하는 컬럼 값이 "일치하는 행"들만 조인되어 조회
            -> 일치하는 값이 없으면 조회에서 제외
*/

--=== 오라클 전용 구문 ===--
/*
    SELECT 조회하고자 하는 컬럼명 모두 
    FROM 조회하고자하는 테이블들을 나열(, 구분자로)
    WHERE 매칭시킬 컬럼(연결고리)에 대한 조건 제시
*/
-- 연결할 두 컬럼명이 다른 경우(EMPLOYEE : DEPT_CODE, DEPARTMENT : DEPT_ID)
-- 전체 사원들의 사번, 사원명, 부서코드, 부서명 조회
-- 일치하는 값이 없는 행은 조회에서 제외(NULL값 제외)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE FROM EMPLOYEE, DEPARTMENT WHERE DEPT_CODE = DEPT_ID;


-- 연결할 두 컬럼명이 같은 경우(EMPLOYEE : JOB_CODE, JOB : JOB_CODE)
-- 전체 사원들의 사번, 사원명, 직급코드, 직급명 조회
--SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME FROM EMPLOYEE, JOB WHERE JOB_CODE = JOB_CODE; // 오류

-- 해결방법 1. 테이블명을 이용하는 방법
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 해결방법 2. 테이블에 별칭을 부여하여 이용하는 방법
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;


--=== ANSI 구문 ===--
/*
    SELECT 조회하고자 하는 컬럼명 모두 
    FROM 기준이 되는 테이블을 하나만 기술
    JOIN 같이 조회하고자 하는 테이블 기술 + 매칭시킬 컬럼(연결고리)에 대한 조건 제시
        -> JOIN USING, JOIN ON 사용
        
    - JOIN ON 형식 : JOIN 같이 조회하고자 하는 테이블 ON 매칭시킬 컬럼에 대한 조건 -> 컬럼명이 다를 때 주로 사용
    
    - JOIN USING 형식 : JOIN 같이 조회하고자 하는 테이블 USING (공통인 컬럼명) -> 컬럼명이 같을 때 주로 사용
*/
-- 연결할 두 컬럼명이 다른 경우(EMPLOYEE : JOB_CODE, JOB : JOB_CODE) => JOIN ON만 사용 가능
-- 전체 사원들의 사번, 사원명, 부서코드, 부서명 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;


-- 연결할 두 컬럼명이 같은 경우(EMPLOYEE : JOB_CODE, JOB : JOB_CODE) => JOIN ON, JOIN USING 사용 가능
-- 전체 사원들의 사번, 사원명, 직급코드, 직급명 조회
--SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME FROM EMPLOYEE JOIN JOB ON (JOB_CODE = JOB_CODE); // 오류

-- 해결 방법 1. 테이블에 별칭을 이용하는 방법(JOIN ON)
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE;

-- 해결 방법 2. JOIN USING 구문을 사용하는 방법(두 컬럼명이 일치할 때만 사용 가능)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME FROM EMPLOYEE JOIN JOB USING (JOB_CODE);


--++ 참고 사항 ++--
-- 자연조인(NATURAL JOIN) : 각 테이블마다 동일한 컬럼이 한개만 존재할 경우
-- 형식 : SELECT 가져올 컬럼명 FROM 테이블명1 NATURAL JOIN 테이블명2;
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME FROM EMPLOYEE NATURAL JOIN JOB;

-- 추가적인 조건도 제시 가능
-- 직급이 '대리'인 사원의 사번, 사원명, 직급명, 급여 조회
--== 오라클 전용 구문 ==-- 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND JOB_NAME = '대리';

--== ANSI 구문 ==--
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY FROM EMPLOYEE
JOIN JOB USING (JOB_CODE) WHERE JOB_NAME = '대리';

