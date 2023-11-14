-- [ JOIN + SUBQUERY 문제 ] --
-- 1. 70년대생(1970~1979) 중 여자이면서 전씨인 사원의 이름과, 주민번호, 부서명, 직급 조회
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE SUBSTR(EMP_NO,1, 2) BETWEEN 70 AND 79
AND SUBSTR(EMP_NO, 8, 1) IN('2', '4')
AND EMP_NAME LIKE '전%';


-- 2. 나이가 가장 막내인 사번, 사원명, 나이, 부서명, 직급명 조회
SELECT EMP_ID, EMP_NAME, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RRRR')) "나이", DEPT_TITLE, JOB_NAME 
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RRRR')) = (SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RRRR'))) FROM EMPLOYEE);


-- 3. 이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE EMP_NAME LIKE '%하%';


-- 4. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급, 부서코드, 부서명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE DEPT_CODE IN('D5', 'D6');


-- 5. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE BONUS IS NOT NULL;


-- 6. 사원명, 직급, 부서명, 지역명 조회


-- 7. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회 


-- 8. 한 사원과 같은 부서에서 일하는 사원의 이름 조회


-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 이름, 직급, 급여 조회 (NVL 이용)


-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회