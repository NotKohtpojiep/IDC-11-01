if not exists (select * from sys.databases where name = 'Библиотека')
Begin
	CREATE DATABASE [Библиотека]
	ON PRIMARY
	(
	NAME=lib1,
	FILENAME='PATH\Лабораторная работа 2\lib1.mdf',
	SIZE=400 MB,
	MAXSIZE=1500 MB, FILEGROWTH=300 MB
	),
	(
	NAME=lib2,
	FILENAME='PATH\Лабораторная работа 2\lib2.mdf',
	SIZE=400 MB,
	MAXSIZE=1500 MB, FILEGROWTH=300 MB
	)
	LOG ON
	(
	NAME=lib_log,
	FILENAME='PATH\Лабораторная работа 2\lib_log.ldf',
	SIZE=500 MB,
	MAXSIZE=Unlimited, FILEGROWTH=100 MB
	)
End
Go 

USE [Библиотека]
if ((select count(*) from INFORMATION_SCHEMA.Tables) != 7)
Begin
	CREATE TABLE [Компоненты]
	(
	Код_компонента int primary key,
	Тип_компонента varchar(20) NOT NULL,
	Название varchar(30) NOT NULL,
	Характеристики varchar(250),
	Стоимость int not null
	);

	CREATE TABLE [Содержимое_заказа]
	(
	Номер_заказа int not null,
	Код_компонента int not null,
	Количество int not null
	CONSTRAINT PK_SodZakaza PRIMARY KEY (Номер_заказа, Код_компонента),
	);

	CREATE TABLE [Сотрудник]
	(
	Код_сотрудника int primary key,
	Фамилия varchar(30) not null,
	Имя varchar(30) not null,
	Отчество varchar(30) not null,
	Специальность varchar(45) not null,
	Образование varchar(50) not null,
	Дата_приема_на_работу date not null,
	Адрес varchar(100) not null,
	Телефон bigint not null,
	);
	CREATE TABLE [Заказ]
	(
	Номер_заказа int primary key,
	Дата_оформления date not null,
	Время_выполнения time not null,
	Дата_оплаты date not null,
	Номер_платежного_документа int not null,
	Отметка_о_выполнении bit not null,
	Код_сотрудника int,
	Код_клиента int
	);

	CREATE TABLE [Клиент]
	(
	Код_клиента int primary key,
	Фамилия varchar(30) not null,
	Имя varchar(30) not null,
	Отчество varchar(30) not null,
	Паспортные_данные bigint not null,
	Адрес varchar(100) not null,
	Телефон bigint not null
	);

	CREATE TABLE [Юридическое_лицо]
	(
	Код_клиента int primary key,
	Название_организации varchar(60) not null,
	Адрес_организации varchar(100) not null,
	Телефон bigint not null
	);

	-- Создание внешних ключей для таблицы Договор
	ALTER TABLE [Содержимое_заказа]
	 ADD CONSTRAINT FK_SodZak_Zakaz FOREIGN KEY (Номер_заказа) 
	 REFERENCES [Заказ] (Номер_заказа)
	 ON DELETE NO ACTION
	 ON UPDATE NO ACTION
	ALTER TABLE [Содержимое_заказа]
	 ADD CONSTRAINT FK_SodZak_Komponent FOREIGN KEY (Код_компонента) 
	 REFERENCES [Компоненты] (Код_компонента)
	 ON DELETE CASCADE
	 ON UPDATE CASCADE

	 ALTER TABLE [Заказ]
	  ADD CONSTRAINT FK_Zakaz_Sotrudnik FOREIGN KEY (Код_сотрудника) 
	  REFERENCES [Сотрудник] (Код_сотрудника)
	  ON DELETE NO ACTION
	  ON UPDATE NO ACTION
	 ALTER TABLE [Заказ]
	  ADD CONSTRAINT FK_Zakaz_Klient FOREIGN KEY (Код_клиента) 
	  REFERENCES [Клиент] (Код_клиента)
	  ON DELETE NO ACTION
	  ON UPDATE NO ACTION

	 ALTER TABLE [Юридическое_лицо]
	  ADD CONSTRAINT FK_Zakaz_UrLitso FOREIGN KEY (Код_клиента) 
	  REFERENCES [Клиент] (Код_клиента)
	  ON DELETE NO ACTION
	  ON UPDATE NO ACTION
end
