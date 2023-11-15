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
                                         
-- 단일행 서브쿼리로도 가능
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리' AND SALARY > (SELECT MIN(SALARY) FROM EMPLOYEE 
                                         JOIN JOB USING (JOB_CODE) 
                                         WHERE JOB_NAME = '과장');
                                         
                                         
-- 차장 직급임에도 과장직급의 급여보다 적게 받는 사원의 사번, 사원명, 직급명, 급여 조회
-- 서브쿼리 ANY 대신에 MAX 써도 됨
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '차장' AND SALARY < ANY(SELECT SALARY FROM EMPLOYEE
                                         JOIN JOB USING (JOB_CODE)
                                         WHERE JOB_NAME = '과장');
                                         
                                         
-- 과장 직급임에도 불구하고 차장 직급인 사원들의 모든 급여보다 많이 받는 사원들의 사번, 사원명, 직급명, 급여 조회
-- ANY : 가장 적은 값보다 큰 값을 얻어올때 -> MIN 사용 O
--  비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3

-- 차장 직급의 가장 적게 받는 급여보다 많이 받는 과장
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '과장' AND SALARY > ANY(SELECT SALARY FROM EMPLOYEE
                                         JOIN JOB USING (JOB_CODE)
                                         WHERE JOB_NAME = '차장');
                                                 
-- ALL : 가장 큰 값보다 큰 값을 얻어올 때 -> MAX 사용 O
--  비교대상 > 값1 AND 비교대상 > 값2 AND 비교대상 > 값3

-- 차장 직급의 가장 많이 받는 급여보다 많이 받는 과장
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '과장' AND SALARY > ALL(SELECT SALARY FROM EMPLOYEE
                                         JOIN JOB USING (JOB_CODE)
                                         WHERE JOB_NAME = '차장');
                                         
                                         
--------------------------------------------------------------------------------
/*
    [ 다중열 서브쿼리(MULTI COLUMN SUBQUERY) ]
        - 서브쿼리의 조회 결과값이 N열 일 때(1행 N열)
*/
-- '장정보'사원과 같은 부서코드, 직급코드에 해당하는 사원들의 사번, 사원명, 부서코드, 직급코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE
                    WHERE EMP_NAME = '장정보') 
    AND JOB_CODE = (SELECT JOB_CODE FROM EMPLOYEE
                    WHERE EMP_NAME = '장정보');
                    
-- 다중열 서브쿼리
-- '장정보' 정보 제외하고 출력 시 : AND EMP_NAME <> '장정보' 조건 추가
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE
                                WHERE EMP_NAME = '장정보');
                                
                                
-- '지정보'사원과 같은 직급코드, 사수를 가지고 있는 사원들의 사번, 사원명, 직급코드, 사수번호 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID FROM EMPLOYEE
                                 WHERE EMP_NAME = '지정보');
                                 
                                 
--------------------------------------------------------------------------------
/*
    [ 다중행 다중열 서브쿼리(MULTI ROW MULTI COLUMN SUBQUERY) ]
        - 서브쿼리의 조회 결과값이 N행, N열 일 때(N행 N열)
*/
-- 각 직급별 최소급여를 받는 사원의 사번, 이름, 직급코드, 급여 조회
-- 1. 각 직급별 최소급여를 받는 사원의 직급코드, 최소급여 조회
SELECT JOB_CODE, MIN(SALARY) FROM EMPLOYEE GROUP BY JOB_CODE;

-- 2. 최소급여를 받는 사원을 조회
--  방법 1. WHERE절에 "조건1 = 값1 AND 조건2 = 값2"를 통해 7개를 적어줘야 함
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE
WHERE JOB_CODE = 'J5' AND SALARY = 2200000
   OR JOB_CODE = 'J6' AND SALARY = 2000000;
   
--  방법 2. WHERE절에 "(조건1, 조건2) = (값1, 값2)"를 통해 7개를 적어줘야 함
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) = ('J5', 2200000);

-- 3. 다중행 다중열 서브쿼리
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY) FROM EMPLOYEE
                              GROUP BY JOB_CODE);


-- 각 부서별 최고급여를 받는 사원들의 사번, 사원명, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY) FROM EMPLOYEE
                               GROUP BY DEPT_CODE);
                               
                               
--------------------------------------------------------------------------------
/*
    [ 인라인 뷰(INLINE VIEW) ]
        - FROM절에 서브쿼리를 작성
        - 서브쿼리를 수행한 결과를 마치 테이블처럼 사용
*/
-- 사원들의 사번, 사원명, 보너스포함연봉, 부서코드 조회
--  조건1. 보너스 포함 연봉이 NULL이 나오지 않음
--  조건2. 보너스 포함 연봉이 3000만원 이상인 사원들만 조회

-- 풀이 1. WHERE절 사용
SELECT EMP_ID, EMP_NAME, (SALARY * NVL(1 + BONUS, 1)) * 12 "연봉", DEPT_CODE FROM EMPLOYEE
WHERE (SALARY * NVL(1 + BONUS, 1)) * 12 >= 30000000;

-- 풀이 2. 인라인 뷰(INLINE VIEW) 사용
-- 인라인 뷰에 있는 컬럼 내에서는 자유롭게 가져올 수 있으나, 없는 컬럼은 가져올 수 없음
SELECT * FROM (SELECT EMP_ID, EMP_NAME, (SALARY * NVL(1 + BONUS, 1)) * 12 "연봉", DEPT_CODE
                FROM EMPLOYEE)
    WHERE 연봉 >= 30000000;
    
    
-- 인라인 뷰를 주로 사용하는 곳 : TOP-N분석(상위 몇위만 가져오기)
-- 전 직원 중 급여 가장 높은 상위 5명만 조회
-- * ROWNUM : 오라클에서 제공해주는 컬럼, 조회된 순서대로 1부터 부여해줌 -> WHERE절에 기술
-- ROWNUM 예시
-- 순서때문에 원하는 결과가 나오지 않음
SELECT ROWNUM, EMP_NAME, SALARY FROM EMPLOYEE;

SELECT ROWNUM, EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY;

SELECT ROWNUM, EMP_NAME, SALARY FROM EMPLOYEE WHERE ROWNUM <= 5 ORDER BY SALARY;

-- 해결방법 : 먼저 정렬(ORDER BY)한 테이블을 만들고 그 테이블에 ROWNUM을 부여
-- 인라인 뷰의 모든컬럼과 다른 컬럼(오라클에서 제공해주는 컬럼)을 가져올때 테이블에 별칭 부여
SELECT ROWNUM, T.* FROM (SELECT EMP_NAME, SALARY, DEPT_CODE FROM EMPLOYEE
                                                  ORDER BY SALARY DESC) T;

-- 특정 컬럼 출력
SELECT ROWNUM, EMP_NAME, SALARY, DEPT_CODE FROM (SELECT EMP_NAME, SALARY, DEPT_CODE FROM EMPLOYEE
                                                  ORDER BY SALARY DESC);

-- 특정 ROWNUM까지 출력                       
SELECT ROWNUM, EMP_NAME, SALARY, DEPT_CODE FROM (SELECT EMP_NAME, SALARY, DEPT_CODE FROM EMPLOYEE
                                                  ORDER BY SALARY DESC)
    WHERE ROWNUM <= 5;
    
    
-- 가장 최근에 입사한 사원 5명의 사번, 사원명, 입사일 조회
SELECT ROWNUM, EMP_ID, EMP_NAME, HIRE_DATE 
    FROM (SELECT EMP_ID, EMP_NAME, HIRE_DATE FROM EMPLOYEE
          ORDER BY HIRE_DATE DESC)
    WHERE ROWNUM <= 5;
    
    
-- 각 부서별 평균급여가 높은 3개의 부서의 부서코드, 평균급여 조회
SELECT T.*
    FROM (SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
          FROM EMPLOYEE
          GROUP BY DEPT_CODE
          ORDER BY 평균급여 DESC) T
    WHERE ROWNUM <= 3;


--------------------------------------------------------------------------------
/*
    [ WITH ]
        - 서브쿼리에 이름을 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름으로 FROM절에 기술
        - 장점 : 같은 서브쿼리가 여러 번 사용될 경우 중복 작성을 피할 수 있음, 실행속도도 빨라짐
        - 형식 : WITH 테이블명 AS (SELECT문)
*/
WITH TOPN_SAL1 AS (SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여 FROM EMPLOYEE
                    GROUP BY DEPT_CODE ORDER BY 평균급여 DESC)
                    
SELECT * FROM TOPN_SAL1 WHERE ROWNUM <= 5;


--------------------------------------------------------------------------------
/*
    [ 순위 매기는 함수(WINDOW FUNCTION) ]
        - RANK() OVER(정렬기준) | DENSE_RANK() OVER(정렬기준)
            -> RANK() OVER(정렬기준) : 동일한 순위 이후 등수를 동일한 인원 수만큼 건너뛰고 순위 계산
                + 예시 : 공동 1순위가 3명이면 그 다음 순위는 4위
            -> DENSE_RANK() OVER(정렬기준) : 동일한 순위가 있어도 다음 등수는 무조건 1씩 증가
                + 예시 : 공동 1순위가 3명이면 그 다음 순위는 2위
        
        - 두 함수는 무조건 SELECT절에서만 사용 가능
*/
-- 급여가 높은 순서대로 순위를 매겨서 사원명, 급여, 순위 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위" FROM EMPLOYEE;

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) "순위" FROM EMPLOYEE;


-- 급여가 상위 5위안에 드는 사원의 사원명, 급여, 순위 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위" FROM EMPLOYEE;
-- WHERE 순위 <= 5 : 실행순서 때문에 오류
-- WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5 : RANK 함수는 SELECT절에서만 사용 가능하기 때문에 오류

-- 인라인 뷰 사용
SELECT * FROM (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위" FROM EMPLOYEE) WHERE 순위 <= 5;

-- WITH 사용
WITH TOPN_SAL2 AS (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위" FROM EMPLOYEE)

SELECT 순위, EMP_NAME, SALARY FROM TOPN_SAL2 WHERE 순위 <= 5;