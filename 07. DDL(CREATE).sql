/*
    [ DDL(데이터 정의어) ]
        - 오라클에서 제공하는 객체를 만들고(CREATE), 구조를 변경하고(ALTER), 구조를 삭제(DROP)하는 언어
        - 즉, 실제 데이터 값이 아닌 구조 자체를 정의하는 언어
        - 주로 DB관리자, 설계자가 사용
        
        - 오라클 객체 : 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE), 인덱스(INDEX), 패키지(PACKAGE),
                        트리거(TRIGGER), 프로시저(PROCEDURE), 함수(FUNCTION), 동의어(SYNONYM), 사용자(USER)
*/
--===========================================================================--
/*
    < CREATE > : 객체를 생성하는 구문
*/
--------------------------------------------------------------------------------
/*
    - 테이블 생성
        -> 테이블(TABLE) : 행(ROW)과 열(COLUMN)로 구성되는 가장 기본적인 데이터베이스 객체
              + 모든 데이터들은 테이블을 통해 저장됨(DBMS 용어 중 하나로, 데이터를 일종의 표 형태로 표현한 것)
        
        -> 표현법 : CREATE TABLE 테이블명 (
                            컬럼명1 자료형(크기),
                            컬럼명2 자료형(크기),
                                   ...
                            );
                            
    * 자료형
        - 문자 : CHAR(바이트크기), VARCHAR2(바이트크기) -> 반드시 크기 지정을 해야 함
             -> CHAR : 최대 2000byte까지 지정 가능
                  + 고정길이(지정한 크기보다 더 적은 값이 들어와도 공백으로 채워서 지정한 크기만큼 고정)
                  + 고정된 데이터를 넣을 때 사용
             -> VARCHAR2 : 최대 4000byte까지 지정 가능
                  + 가변길이(담긴 값에 따라 공간의 크기가 맞춰짐)
                  + 글자 수가 정해지지 않았을 때 사용
            
        - 숫자 : NUMBER
        
        - 날짜 : DATE
             
*/
-- 회원 테이블(MEMBER) 생성
CREATE TABLE MEMBER (
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PW VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE
);

SELECT * FROM MEMBER;