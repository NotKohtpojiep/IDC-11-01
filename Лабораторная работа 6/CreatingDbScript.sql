if not exists (select * from sys.databases where name = 'Библиотека')
Begin
	CREATE DATABASE [Библиотека]
	ON PRIMARY
	(
	NAME=lib1,
	FILENAME='PATH\Лабораторная работа 6\lib1.mdf',
	SIZE=100 MB,
	MAXSIZE=UNLIMITED, FILEGROWTH=100%
	),
	(
	NAME=lib2,
	FILENAME='PATH\Лабораторная работа 6\lib2.mdf',
	SIZE=100 MB,
	MAXSIZE=UNLIMITED, FILEGROWTH=100%
	)
	LOG ON
	(
	NAME=lib_log,
	FILENAME='PATH\Лабораторная работа 6\lib_log.ldf',
	SIZE=50 MB,
	MAXSIZE=400 MB, FILEGROWTH=50 MB
	)
End

USE [Библиотека]
Begin
	CREATE TABLE [Заказ_наряд]
	(
	Номер_заказа int primary key,
	Дата_оформления date NOT NULL,
	Дата_выполнения date NULL,
	Полная_стоимость decimal(12,2)
	);
	CREATE TABLE [Работа]
	(
	Код_работы int primary key,
	Наименование nvarchar(65) not null,
	Стоимость_работы decimal(9,2) not null
	);

	CREATE TABLE [Содержимое_заказа]
	(
	Номер_заказа int not null,
	Код_работы int not null,
	CONSTRAINT PK_Rabota PRIMARY KEY (Номер_заказа, Код_работы)
	);

	CREATE TABLE [Исполнитель]
	(
	Код_исполнителя int primary key,
	Фамилия varchar(40) not null,
	Имя varchar(40) not null,
	Отчество varchar(40) not null,
	Специальность varchar(40) not null,
	Возраст int not null,
	Телефон bigint not null,
	Дата_приема_на_работу date not null,
	Зарплата decimal(12,2) not null
	);

	CREATE TABLE [Выполнение_работ]
	(
	Номер_заказа int not null,
	Код_работы int not null,
	Код_исполнителя int not null,
	Отметка_о_выполнении varchar(45) not null,
	CONSTRAINT PK_VipolnenieRabot PRIMARY KEY (Номер_заказа, Код_работы, Код_исполнителя)
	);

	-- Создание внешних ключей для таблиц
	ALTER TABLE [Содержимое_заказа]
	 ADD CONSTRAINT FK_SodZak_Zakaz FOREIGN KEY (Номер_заказа) 
	 REFERENCES [Заказ_наряд] (Номер_заказа)
	 ON DELETE NO ACTION
	 ON UPDATE NO ACTION

	ALTER TABLE [Содержимое_заказа]
	 ADD CONSTRAINT FK_SodZak_Rabota FOREIGN KEY (Код_работы) 
	 REFERENCES [Работа] (Код_работы)
	 ON DELETE NO ACTION
	 ON UPDATE NO ACTION

	ALTER TABLE [Выполнение_работ]
	 ADD CONSTRAINT FK_VipRab_SodZak FOREIGN KEY (Номер_заказа, Код_работы) 
	 REFERENCES [Содержимое_заказа] (Номер_заказа, Код_работы)
	 ON DELETE NO ACTION
	 ON UPDATE NO ACTION

	ALTER TABLE [Выполнение_работ]
	 ADD CONSTRAINT FK_VipRab_Ispoln FOREIGN KEY (Код_исполнителя) 
	 REFERENCES [Исполнитель] (Код_исполнителя)
	 ON DELETE NO ACTION
	 ON UPDATE NO ACTION

end
