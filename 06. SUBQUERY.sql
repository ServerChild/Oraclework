/*
    - 서브쿼리(SUBQUERY) : 하나의 SQL문 안에 포함된 또다른 SELECT문
        -> 메인 SQL문의 보조 역할을 하는 쿼리문
        -> 형식 : SELECT 출력할 컬럼 FROM 테이블명
                  WHERE 조건 (SELECT문);
*/
-- '박정보'사원과 같은 부서(D9)에 있는 사원 조회
--  1. 박정보 사원 부서코드 조회
SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '박정보';

-- 2. 부서코드가 'D9'인 사원의 정보 조회
SELECT EMP_NAME FROM EMPLOYEE WHERE DEPT_CODE = 'D9';

-- 3. 두 쿼리문을 하나로 합침
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
--------------------------------------------------------------------------------
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
                
                
--============ JOIN + SUBQUERY ===========--
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
                

-- '왕정보'사원과 같은 부서원들의 사번, 사원명, 전화번호, 부서명 조회(단, 왕정보는 제외)
-- 오라클 구문 --
SELECT EMP_ID, EMP_NAME, PHONE, DEPT_TITLE FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID 
    AND DEPT_CODE = (SELECT DEPT_CODE
                     FROM EMPLOYEE
                     WHERE EMP_NAME = '왕정보')
    AND EMP_NAME <> '왕정보';

-- ANSI 구문 --
SELECT EMP_ID, EMP_NAME, PHONE, DEPT_TITLE FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_CODE = (SELECT DEPT_CODE
                     FROM EMPLOYEE
                     WHERE EMP_NAME = '왕정보')
    AND EMP_NAME <> '왕정보';
    
    
--============ GROUP + SUBQUERY ============--
-- 부서별 급여합이 가장 큰 부서의 부서코드, 급여합 조회
-- 부서별 급여합 목록 조회 
SELECT DEPT_CODE, SUM(SALARY) "급여합" FROM EMPLOYEE GROUP BY DEPT_CODE ORDER BY "급여합" DESC;

-- 1. 부서별 급여합 중 가장 큰 값 조회
SELECT MAX(SUM(SALARY)) FROM EMPLOYEE GROUP BY DEPT_CODE;

-- 2. 부서별 급여합이 17,700,000인 부서 조회
-- HAVING에 별칭으로 지정해주면 아직 SELECT문이 실행되지 않았으므로 별칭 적용이 되지않아 실행 X
SELECT DEPT_CODE, SUM(SALARY) "급여합" FROM EMPLOYEE GROUP BY DEPT_CODE HAVING SUM(SALARY) = 17700000;

-- 3. 두 쿼리문을 하나로 합침
SELECT DEPT_CODE, SUM(SALARY) "급여합" FROM EMPLOYEE
GROUP BY DEPT_CODE HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY)) 
                                         FROM EMPLOYEE 
                                         GROUP BY DEPT_CODE);


--------------------------------------------------------------------------------
/*
    [ 다중행 서브쿼리(MULTI ROW SUBQUERY) ]
        - 서브쿼리의 조회 결과값이 N행 일 때(N행 1열)
        - 일반 비교연산자 사용 : =, !=, >, < ...
        
        - IN 서브쿼리 : 여러개의 결과값 중 한개라도 일치하는 값이 있을 경우
        
        - > ANY 서브쿼리 : 여러개의 결과값 중 "한개라도" 클 경우
            (여러개의 결과값 중 가장 작은 값보다 클 경우)
        - < ANY 서브쿼리 : 여러개의 결과값 중 "한개라도" 작은 경우
            (여러개의 결과값 중 가장 큰값 값보다 작을 경우)
        - 형식 : 비교대상 > ANY(값1, 값2, 값3)(= '비교대상 > 값1' OR '비교대상 > 값2' OR '비교대상 > 값3')
*/
-- '조정연' 또는 '전지연'과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여를 조회
-- 1. '조정연' 또는 '전지연'의 직급 조회
SELECT JOB_CODE FROM EMPLOYEE WHERE EMP_NAME IN('조정연', '전지연');

-- 2. 직급코드가 'J3', 'J7'인 사원들의 사번, 사원명, 직급코드, 급여를 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE WHERE JOB_CODE IN('J3', 'J7');

-- 3. 두 쿼리문을 하나로 합침
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE 
WHERE JOB_CODE IN(SELECT JOB_CODE 
                  FROM EMPLOYEE 
                  WHERE EMP_NAME IN('조정연', '전지연'));
                  
                  
-- 직급 순서 : 대표 -> 부사장 -> 부장 -> 차장 -> 과장 -> 대리 -> 사원
-- 대리직급임에도 불구하고 과장직급의 급여들 중 최소 급여보다 많이 받는 직원의 사번, 사원명, 직급명, 급여 조회
-- 1. 과장직급의 급여 조회 : 220, 240, 376만
SELECT SALARY FROM EMPLOYEE JOIN JOB USING (JOB_CODE) WHERE JOB_NAME = '과장';

-- 2. 직급이 대리이면서 급여가 위의 목록값 중에 하나라도 큰 사원
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리' AND SALARY > ANY(2200000, 2400000, 3760000);

-- 3. 두 쿼리문을 하나로 합침
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리' AND SALARY > ANY(SELECT SALARY FROM EMPLOYEE 
                                         JOIN JOB USING (JOB_CODE) 
                                         WHERE JOB_NAME = '과장');