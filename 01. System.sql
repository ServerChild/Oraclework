-- 한줄 주석 : ctrl + /
-- 한 줄(커서가 위치하는) 실행 : ctrl + enter

/*
    여러줄 주석 : alt + shift + c
*/

-- 나의 계정 보기
SHOW user;


-- 사용자 계정 조회
SELECT * FROM DBA_USERS;


-- 계정 만들기 : CREATE USER 사용자명 IDENTIFIED BY 비밀번호;
-- 오라클 12버전부터 일반사용자는 c##을 붙여 이름 설정
-- CREATE USER user1 IDENTIFIED BY 1234;
CREATE USER user1 IDENTIFIED BY "1234";
CREATE USER c##user2 IDENTIFIED BY user2;
CREATE USER user3 IDENTIFIED BY user3;


-- 사용자 이름에 c## 붙이는 것을 생략하는 방법
ALTER SESSION set "_oracle_script" = true;


-- 사용자 이름은 대소문자를 가리지 않음
-- 사용자 생성 시 필수 : 사용자 생성, 권한 부여, 테이블 스페이스 부여
CREATE USER aie IDENTIFIED BY aie;


-- 사용자 권한 부여 : GRANT 권한1, 권한2, ... TO 사용자명;
-- RESOURCE(데이터 가져오기, 생성, 수정, 삭제 등), CONNECT(데이터베이스 연결 - 로그인)
GRANT RESOURCE, CONNECT TO aie;


-- 테이블 스페이스에 얼만큼의 영역을 할당할 것인지를 부여하는 방법
-- DEFAULT TABLESPACE : 테이블 기본값(default)
-- QUOTA UNLIMITED : 제한 없이 할당
ALTER USER aie DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;


-- 테이블 스페이스의 영역을 특정 용량만큼 할당하는 방법
-- QUOTA 특정용량(단위) : 지정한 용량만큼만 할당
ALTER USER user1 QUOTA 30M ON USERS;


-- 사용자 삭제(테이블 없는 상태) : DROP USER 사용자명;
-- 사용자 삭제(테이블 있는 상태) : DROP USER 사용자명 CASCADE;
DROP USER c##user2;
DROP USER user3;

-- 숙제용 사용자 생성
ALTER SESSION set "_oracle_script" = true;
create user workbook identified by workbook;
grant RESOURCE, CONNECT to workbook;
alter user workbook default TABLESPACE users quota UNLIMITED on users;