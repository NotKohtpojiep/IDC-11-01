if not exists (select * from sys.databases where name = '����������')
Begin
	CREATE DATABASE [����������]
	ON PRIMARY
	(
	NAME=lib1,
	FILENAME='PATH\������������ ������ 2\lib1.mdf',
	SIZE=400 MB,
	MAXSIZE=1500 MB, FILEGROWTH=300 MB
	),
	(
	NAME=lib2,
	FILENAME='PATH\������������ ������ 2\lib2.mdf',
	SIZE=400 MB,
	MAXSIZE=1500 MB, FILEGROWTH=300 MB
	)
	LOG ON
	(
	NAME=lib_log,
	FILENAME='PATH\������������ ������ 2\lib_log.ldf',
	SIZE=500 MB,
	MAXSIZE=Unlimited, FILEGROWTH=100 MB
	)
End
Go 

USE [����������]
if ((select count(*) from INFORMATION_SCHEMA.Tables) != 7)
Begin
	CREATE TABLE [����������]
	(
	���_���������� int primary key,
	���_���������� varchar(20) NOT NULL,
	�������� varchar(30) NOT NULL,
	�������������� varchar(250),
	��������� int not null
	);

	CREATE TABLE [����������_������]
	(
	�����_������ int not null,
	���_���������� int not null,
	���������� int not null
	CONSTRAINT PK_SodZakaza PRIMARY KEY (�����_������, ���_����������),
	);

	CREATE TABLE [���������]
	(
	���_���������� int primary key,
	������� varchar(30) not null,
	��� varchar(30) not null,
	�������� varchar(30) not null,
	������������� varchar(45) not null,
	����������� varchar(50) not null,
	����_������_��_������ date not null,
	����� varchar(100) not null,
	������� bigint not null,
	);
	CREATE TABLE [�����]
	(
	�����_������ int primary key,
	����_���������� date not null,
	�����_���������� time not null,
	����_������ date not null,
	�����_����������_��������� int not null,
	�������_�_���������� bit not null,
	���_���������� int,
	���_������� int
	);

	CREATE TABLE [������]
	(
	���_������� int primary key,
	������� varchar(30) not null,
	��� varchar(30) not null,
	�������� varchar(30) not null,
	����������_������ bigint not null,
	����� varchar(100) not null,
	������� bigint not null
	);

	CREATE TABLE [�����������_����]
	(
	���_������� int primary key,
	��������_����������� varchar(60) not null,
	�����_����������� varchar(100) not null,
	������� bigint not null
	);

	-- �������� ������� ������ ��� ������� �������
	ALTER TABLE [����������_������]
	 ADD CONSTRAINT FK_SodZak_Zakaz FOREIGN KEY (�����_������) 
	 REFERENCES [�����] (�����_������)
	 ON DELETE NO ACTION
	 ON UPDATE NO ACTION
	ALTER TABLE [����������_������]
	 ADD CONSTRAINT FK_SodZak_Komponent FOREIGN KEY (���_����������) 
	 REFERENCES [����������] (���_����������)
	 ON DELETE CASCADE
	 ON UPDATE CASCADE

	 ALTER TABLE [�����]
	  ADD CONSTRAINT FK_Zakaz_Sotrudnik FOREIGN KEY (���_����������) 
	  REFERENCES [���������] (���_����������)
	  ON DELETE NO ACTION
	  ON UPDATE NO ACTION
	 ALTER TABLE [�����]
	  ADD CONSTRAINT FK_Zakaz_Klient FOREIGN KEY (���_�������) 
	  REFERENCES [������] (���_�������)
	  ON DELETE NO ACTION
	  ON UPDATE NO ACTION

	 ALTER TABLE [�����������_����]
	  ADD CONSTRAINT FK_Zakaz_UrLitso FOREIGN KEY (���_�������) 
	  REFERENCES [������] (���_�������)
	  ON DELETE NO ACTION
	  ON UPDATE NO ACTION
end
