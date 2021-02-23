if not exists (select * from sys.databases where name = '����������')
Begin
	CREATE DATABASE [����������]
	ON PRIMARY
	(
	NAME=lib1,
	FILENAME='PATH\������������ ������ 6\lib1.mdf',
	SIZE=100 MB,
	MAXSIZE=UNLIMITED, FILEGROWTH=100%
	),
	(
	NAME=lib2,
	FILENAME='PATH\������������ ������ 6\lib2.mdf',
	SIZE=100 MB,
	MAXSIZE=UNLIMITED, FILEGROWTH=100%
	)
	LOG ON
	(
	NAME=lib_log,
	FILENAME='PATH\������������ ������ 6\lib_log.ldf',
	SIZE=50 MB,
	MAXSIZE=400 MB, FILEGROWTH=50 MB
	)
End

USE [����������]
Begin
	CREATE TABLE [�����_�����]
	(
	�����_������ int primary key,
	����_���������� date NOT NULL,
	����_���������� date NULL,
	������_��������� decimal(12,2)
	);
	CREATE TABLE [������]
	(
	���_������ int primary key,
	������������ nvarchar(65) not null,
	���������_������ decimal(9,2) not null
	);

	CREATE TABLE [����������_������]
	(
	�����_������ int not null,
	���_������ int not null,
	CONSTRAINT PK_Rabota PRIMARY KEY (�����_������, ���_������)
	);

	CREATE TABLE [�����������]
	(
	���_����������� int primary key,
	������� varchar(40) not null,
	��� varchar(40) not null,
	�������� varchar(40) not null,
	������������� varchar(40) not null,
	������� int not null,
	������� bigint not null,
	����_������_��_������ date not null,
	�������� decimal(12,2) not null
	);

	CREATE TABLE [����������_�����]
	(
	�����_������ int not null,
	���_������ int not null,
	���_����������� int not null,
	�������_�_���������� varchar(45) not null,
	CONSTRAINT PK_VipolnenieRabot PRIMARY KEY (�����_������, ���_������, ���_�����������)
	);

	-- �������� ������� ������ ��� ������
	ALTER TABLE [����������_������]
	 ADD CONSTRAINT FK_SodZak_Zakaz FOREIGN KEY (�����_������) 
	 REFERENCES [�����_�����] (�����_������)
	 ON DELETE NO ACTION
	 ON UPDATE NO ACTION

	ALTER TABLE [����������_������]
	 ADD CONSTRAINT FK_SodZak_Rabota FOREIGN KEY (���_������) 
	 REFERENCES [������] (���_������)
	 ON DELETE NO ACTION
	 ON UPDATE NO ACTION

	ALTER TABLE [����������_�����]
	 ADD CONSTRAINT FK_VipRab_SodZak FOREIGN KEY (�����_������, ���_������) 
	 REFERENCES [����������_������] (�����_������, ���_������)
	 ON DELETE NO ACTION
	 ON UPDATE NO ACTION

	ALTER TABLE [����������_�����]
	 ADD CONSTRAINT FK_VipRab_Ispoln FOREIGN KEY (���_�����������) 
	 REFERENCES [�����������] (���_�����������)
	 ON DELETE NO ACTION
	 ON UPDATE NO ACTION

end
