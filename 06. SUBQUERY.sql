/*
    - 서브쿼리(SUBQUERY) : 하나의 SQL문 안에 포함된 또다른 SELECT문
        -> 메인 SQL문의 보조 역할을 하는 쿼리문
        -> 형식 : SELECT 출력할 컬럼 FROM 테이블명
                  WHERE 조건 (SELECT문);
*/
-- '박정보'사원과 같은 부서(D9)에 있는 사원 조회
--  1. 박정보 사원 부서코드 조회
SELECT DEPT_CODE 
FROM EMPLOYEE 
WHERE EMP_NAME = '박정보';

-- 2. 부서코드가 'D9'인 사원의 정보 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 두 쿼리문을 하나로 합침
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE 
                   FROM EMPLOYEE 
                   WHERE EMP_NAME = '박정보');
                   

-- 전 직원의 평균급여보다 더 많이 받는 사원의 사번, 사원명, 급여, 직급코드 조회
-- 출력 : 사원의 사번, 사원명, 급여, 직급코드
-- 조건 : 직원의 평균급여보다 더 많이 받는
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE 
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY)
                 FROM EMPLOYEE);

  
--===========================================================================--
/*
    - 서브쿼리의 구분 : 서브쿼리를 수행한 결과값이 몇 행 몇 열이냐에 따라 분류
        -> 단일행 서브쿼리 : 서브쿼리의 조회 결과값이 오로지 1개일 때(1행 1열)
        -> 다중행 서브쿼리 : 서브쿼리의 조회 결과값이 N행 일 때(N행 1열)
        -> 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 N열 일 때(1행 N열)
        -> 다중행 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 N행, N열 일 때(N행 N열)
        
    - 서브쿼리의 종류에 따라 서브쿼리 앞에 붙는 연산자가 달라짐
*/

/*
    [ 단일행 서브쿼리(SINGLE ROW SUBQUERY) ]
        - 서브쿼리의 조회 결과값이 오로지 1개일 때(1행 1열)
        - 일반 비교연산자 사용 : =, !=, >, < ...
*/
-- 전 직원의 평균급여보다 급여를 적게 받는 사원의 사원명, 급여 조회
SELECT EMP_NAME, SALARY FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                FROM EMPLOYEE)
ORDER BY EMP_NAME;


-- 최저 급여를 받는 사원의 사원명, 급여 조회
SELECT EMP_NAME, SALARY FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE);


-- '박정보'사원보다 급여를 더 많이 받는 사원의 사원명, 급여 조회
SELECT EMP_NAME, SALARY FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보');
                
                
--==== JOIN + SUBQUERY ====--
-- '박정보'사원보다 급여를 더 많이 받는 사원의 사번, 사원명, 부서코드, 부서이름, 급여 조회
-- 오라클 구문 --
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, SALARY FROM EMPLOYEE, DEPARTMENT
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보')
    AND DEPT_CODE = DEPT_ID;
    
-- ANSI 구문 --
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, SALARY FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보');