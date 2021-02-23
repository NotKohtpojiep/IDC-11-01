USE Библиотека;
go

-- Вроде бы и это
ALTER TRIGGER zadanie1 ON dbo.Заказ_наряд
AFTER INSERT, UPDATE
AS  
IF ((SELECT Полная_стоимость FROM inserted) < 100000)
BEGIN
	RAISERROR ('Невозможно сформировать заказ, общая стоимость которого менее 100000 рублей', 16, 1); 
	ROLLBACK
END
GO;

-- Тесты, скорее, скорее!
INSERT INTO Заказ_наряд VALUES (17, '2020-01-01', '2020-02-01', 10000.00)
GO;

-- Вроде бы и это
ALTER TRIGGER zadanie2 ON dbo.Выполнение_работ
AFTER INSERT, UPDATE 
AS
	IF (EXISTS (SELECT * FROM deleted))
	BEGIN
	SELECT Table_A.Код_исполнителя, Стоимость_работы --, SUM(Стоимость_работы) as Итоговая_стоимость
			FROM deleted AS Table_A
			INNER JOIN inserted AS Table_B
				ON Table_A.Код_исполнителя = Table_B.Код_исполнителя AND Table_A.Номер_заказа = Table_B.Номер_заказа AND Table_A.Код_работы = Table_B.Код_работы
			INNER JOIN Работа AS Table_C 
				ON Table_B.Код_работы = Table_C.Код_работы
			WHERE Table_A.Отметка_о_выполнении = 0 AND Table_B.Отметка_о_выполнении = 1
			--GROUP BY Table_A.Код_исполнителя
		UPDATE
			Исполнитель
		SET
			Зарплата += (SELECT CAST((Итоговая_стоимость) / 10 / (12 - MONTH(GETDATE())) as decimal(12,2)))
		FROM
			(SELECT Table_A.Код_исполнителя, SUM(Стоимость_работы) as Итоговая_стоимость
			FROM deleted AS Table_A
			INNER JOIN inserted AS Table_B
				ON Table_A.Код_исполнителя = Table_B.Код_исполнителя AND Table_A.Номер_заказа = Table_B.Номер_заказа AND Table_A.Код_работы = Table_B.Код_работы
			INNER JOIN Работа AS Table_C 
				ON Table_B.Код_работы = Table_C.Код_работы
			WHERE Table_A.Отметка_о_выполнении = 0 AND Table_B.Отметка_о_выполнении = 1
			GROUP BY Table_A.Код_исполнителя) as Result
		WHERE Исполнитель.Код_исполнителя = Result.Код_исполнителя
	END
	ELSE
	BEGIN
		UPDATE
			Исполнитель
		SET
			Зарплата += (SELECT CAST((Итоговая_стоимость) / 10 / (12 - MONTH(GETDATE())) as decimal(12,2)))
		FROM
			(SELECT Table_A.Код_исполнителя, SUM(Стоимость_работы) as Итоговая_стоимость
			FROM inserted AS Table_A
			INNER JOIN Работа AS Table_B
				ON Table_A.Код_работы = Table_B.Код_работы
			WHERE Table_A.Отметка_о_выполнении = 1
			GROUP BY Table_A.Код_исполнителя) as Result
		WHERE Исполнитель.Код_исполнителя = Result.Код_исполнителя
	END
GO

-- Тесты скорее, скорее!
BEGIN TRAN
	SELECT * FROM Исполнитель
	UPDATE Выполнение_работ SET Отметка_о_выполнении = 1  WHERE Код_работы = 4 and Код_исполнителя = 3
	SELECT * FROM Исполнитель
	ROLLBACK
COMMIT
GO;

