/*
    <GROUP BY절> : 그룹을 기준으로 제시할 수 있는 구문(여러 그룹기준별로 여러 그룹을 묶을 수 있음)
        - 여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
*/
-- 전체 사원을 하나의 그룹으로 묶어서 총합 구함
SELECT SUM(SALARY) FROM EMPLOYEE;


-- 각 부서별 총 급여 합 조회
SELECT DEPT_CODE "부서코드", SUM(SALARY) "급여합계" FROM EMPLOYEE GROUP BY DEPT_CODE;


-- 각 부서별 사원의 수 조회
SELECT DEPT_CODE "부서코드", COUNT(*) "부서별 사원 수" FROM EMPLOYEE GROUP BY DEPT_CODE;


-- 각 부서별 급여 합계와 사원수 조회
SELECT DEPT_CODE "부서코드", SUM(SALARY) "급여합계", COUNT(*) "부서별 사원 수" FROM EMPLOYEE 
GROUP BY DEPT_CODE ORDER BY DEPT_CODE;


-- 각 직급별 사원수, 급여 합계 조회. 직급별 내림차순으로 정렬
SELECT JOB_CODE "직급", COUNT(*) "직급별 사원 수", SUM(SALARY) "급여합계" FROM EMPLOYEE
GROUP BY JOB_CODE ORDER BY "직급" DESC;


-- 각 직급별 총 사원수, 보너스를 받는 사원수, 급여합, 평균급여, 최저급여, 최고급여 조회(직급별 오름차순 정렬)
-- ORDER BY 숫자 : 해당 순서(숫자)에 있는 컬럼을 기준으로 정렬 -> 1(첫번째 컬럼) .. N(N번째 컬럼)
SELECT JOB_CODE "직급", COUNT(*) "총 사원수", COUNT(BONUS) "보너스를 받는 사원수", SUM(SALARY) "급여합"
       , ROUND(AVG(SALARY)) "평균급여", MIN(SALARY) "최저급여", MAX(SALARY) "최고급여"
FROM EMPLOYEE GROUP BY JOB_CODE ORDER BY 1;


-- GROUP BY절에 함수식도 기술 가능
-- 여성별, 남성별 사원의 수 조회
-- 풀이 1. SUBSTR 사용해서 조회
SELECT SUBSTR(EMP_NO, 8, 1) "성별", COUNT(*) "사원수" FROM EMPLOYEE GROUP BY SUBSTR(EMP_NO, 8, 1);

-- 풀이 2. DECODE 사용해서 성별별칭 출력 + 조회
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') "성별", COUNT(*) "사원수" 
FROM EMPLOYEE GROUP BY SUBSTR(EMP_NO, 8, 1);


-- 부서코드, 직급코드 별 사원수, 급여합 조회
SELECT DEPT_CODE "부서코드", JOB_CODE "직급코드", COUNT(*) "사원수", SUM(SALARY) "급여합" FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE ORDER BY 1;


--===========================================================================--
/*
    <HAVING 절> : 그룹에 대한 조건을 제시할 때 사용하는 구문
        - 주로 그룹함수식을 가지고 조건을 제시할 때 사용
        - 그룹함수에서는 조건 제시시 WHERE절에서는 안됨
*/
-- 각 부서별 평균급여를 조회(부서코드, 평균급여)
SELECT DEPT_CODE "부서코드", ROUND(AVG(SALARY)) "평균급여" FROM EMPLOYEE GROUP BY DEPT_CODE;

-- 각 부서별 평균 급여가 300만원 이상인 부서만 조회
SELECT DEPT_CODE 부서코드, ROUND(AVG(SALARY)) 평균급여 FROM EMPLOYEE
GROUP BY DEPT_CODE HAVING ROUND(AVG(SALARY)) >= 3000000;


--===========================================================================--
/*
    <SELECT문 순서>
      1. FROM
      2. WHERE
      3. GROUP BY
      4. HAVING
      5. SELECT
      6. ORDER BY
*/

-- 문제 --
-- 직급별 총 급여액(단, 직급별 급여합이 1000만원 이상인 직급만 조회) - 직급코드, 급여합
SELECT JOB_CODE "직급코드", SUM(SALARY) "급여합" FROM EMPLOYEE 
GROUP BY JOB_CODE HAVING SUM(SALARY) >= 10000000;


-- 부서별 보너스를 받는 사원이 없는 부서만 부서코드 조회 - 부서코드
SELECT DEPT_CODE "부서코드", COUNT(BONUS) "보너스 받는 사람" FROM EMPLOYEE 
GROUP BY DEPT_CODE HAVING COUNT(BONUS) = 0;


--===========================================================================--
/*
    <집계함수> : 그룹별로 산출된 결과값에 중간집계를 계산해주는 함수
        - ROLLUP, CUBE : GROUP BY절에 기술하는 함수
            -> ROLLUP(컬럼1, 컬럼2) : 컬럼1을 가지고 중간집계를 내는 함수
            -> CUBE(컬럼1, 컬럼2) : 컬럼1을 가지고 중간집계를 내고, 컬럼2를 가지고 중간집계를 내는 함수
*/
-- 각 직급별 급여합
SELECT JOB_CODE, SUM(SALARY) FROM EMPLOYEE GROUP BY JOB_CODE ORDER BY 1;


-- 컬럼이 1개일 때는 집계함수를 사용할 필요 없음
SELECT JOB_CODE, SUM(SALARY) FROM EMPLOYEE GROUP BY ROLLUP(JOB_CODE) ORDER BY 1;

-- 그룹지어서 출력
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY) FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE ORDER BY 1;

-- CUBE, ROLLUP의 차이점을 보려면 그룹기준이 컬럼 2개는 있어야 가능함
-- ROLLUP(컬럼1, 컬럼2) : 컬럼1을 기준으로 중간집계값
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY) FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE) ORDER BY 1;

-- CUBE(컬럼1, 컬럼2) : 컬럼1 중간집계값 + 컬럼2 중간집계값
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY) FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE) ORDER BY 1;


--===========================================================================--
/*
    < 집합연산자 == SET OPERATION >
        - 여러개의 쿼리문을 가지고 하나의 쿼리문으로 만드는 연산자
            -> UNION : OR | 합집합(두 쿼리문을 수행한 결과값을 더한 후 중복되는 값은 한번만 더해줌)
            -> INTERSECT : AND | 교집합(두 쿼리문을 수행한 결과값의 중복된 결과값)
            -> UNION ALL : 합집합 + 교집합(중복되는 값은 두번 표현됨)
            -> MINUS : 차집합(첫번째 집합에서 두번째 집합의 값을 뺀 나머지)
            
        - 주의 사항 : 집합 연산자를 사용할 경우, 컬럼의 개수와 컬럼명이 동일해야 해야함
*/
--=== UNION ===--
-- 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원 조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5'; 

-- 급여가 300만원 초과인 사원
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE SALARY > 3000000; 


-- UNION
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE SALARY > 3000000;

-- OR절 사용가능
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5' OR SALARY > 3000000;


--=== UNION ===--
-- 부서코드가 D5인 사원이면서 급여가 300만원 초과인 사원 조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE SALARY > 3000000;

-- AND 사용가능
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5' AND SALARY > 3000000;


--=== UNION ALL ===--
-- 부서코드가 D5인 사원이면서 급여가 300만원 초과인 사원을 조회(중복값 모두)
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE SALARY > 3000000; 


--=== MINUS ===--
-- 부서코드가 D5인 사원들 중에서 급여가 300만원 초과인 사원을 제외하고 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE SALARY > 3000000;

-- AND 사용가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5' AND SALARY <= 3000000;
