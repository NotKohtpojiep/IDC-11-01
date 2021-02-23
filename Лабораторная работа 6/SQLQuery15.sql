/*
8 вариант
...
...
...
*/
-- use [YourDatabaseName] EXEC sp_changedbowner 'sa'
-- надоело эту команду использовать .-.

use Библиотека

BEGIN TRAN
	DECLARE @mark VARCHAR(50) -- отметка работы
	DECLARE @num_zakaz int -- номер заказа
	DECLARE @work_code int -- код работы
	DECLARE @worker_code int -- код исполнителя

	DECLARE @result_table TABLE(
		Номер_заказа INT NOT NULL,  
		Код_работы INT NOT NULL,  
		Отметка NVARCHAR(60) NOT NULL)

	-- Я объявил курсорррррр!
	DECLARE db_cursor CURSOR FOR 
		(SELECT Номер_заказа, Код_работы, Код_исполнителя, Отметка_о_выполнении from Выполнение_работ)

	-- Открываем курсор
	OPEN db_cursor  
	FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark

	WHILE @@FETCH_STATUS = 0  
	BEGIN
		SELECT @mark = LOWER(@mark)	

		-- Проверка записи с пометкой "Не выполнено"
		IF (@mark = 'не выполнено')
		BEGIN
			-- Проверяем, возможно ли сгенерировать номер заказа, у которого нет такого исполнителя
			IF NOT EXISTS(SELECT DISTINCT Номер_заказа FROM Выполнение_работ 
				WHERE Номер_заказа NOT IN (SELECT Номер_заказа FROM Выполнение_работ WHERE Код_исполнителя = @worker_code))
			BEGIN
				PRINT('Невозможно расформировать заказ: ' + CAST(@num_zakaz as nvarchar) + ' с кодом рабочего: ' + CAST(@worker_code as nvarchar))
				FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark
				CONTINUE
			END
			-- Действия с расформированием
			IF (NOT EXISTS(SELECT * FROM Выполнение_работ WHERE Номер_заказа = @num_zakaz and LOWER(Отметка_о_выполнении) != 'не выполнено'))
			BEGIN
				DECLARE @rand_num INT = (SELECT TOP 1 Номер_заказа 
										FROM Выполнение_работ 
										WHERE Номер_заказа NOT IN (SELECT Номер_заказа FROM Выполнение_работ WHERE Код_исполнителя = @worker_code) 
											AND LOWER(Отметка_о_выполнении) != 'не выполнено' 
										ORDER BY NEWID())
				-- Создаем новую запись, если таковой нет, чтобы разместить расформированный заказ
				IF (NOT EXISTS(SELECT * FROM Содержимое_заказа WHERE Номер_заказа = @rand_num AND Код_работы = @work_code))
				BEGIN
					INSERT INTO Содержимое_заказа VALUES (@rand_num, @work_code)
				END
				UPDATE Выполнение_работ 
				SET Отметка_о_выполнении = 'Расформирован', 
						Номер_заказа = @rand_num
				WHERE Номер_заказа = @num_zakaz and Код_работы = @work_code and Код_исполнителя = @worker_code
				-- Удаляем запись, если на нее никто не ссылается
				IF (NOT EXISTS(SELECT * FROM Выполнение_работ WHERE Номер_заказа = @num_zakaz AND Код_работы = @work_code))
				BEGIN
					DELETE Содержимое_заказа WHERE Номер_заказа = @num_zakaz AND Код_работы = @work_code
				END
				FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark
				CONTINUE
			END
			-- Покидаем зону извержения если есть заказы с другими статусами
			ELSE
			BEGIN
				FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark
				CONTINUE
			END
		END


		IF (@mark = 'перерасход')
		BEGIN
			-- Стоимость выполняемой работы превышает стоимость сделки. Такие вещи мы покрываем малым респектом
			IF ((SELECT SUM(Стоимость_работы) 
				 FROM Работа INNER JOIN Выполнение_работ on Работа.Код_работы = Выполнение_работ.Код_работы
				 WHERE Номер_заказа = @num_zakaz) > (SELECT Полная_стоимость FROM Заказ_наряд WHERE Номер_заказа = @num_zakaz))
			BEGIN
				INSERT INTO @result_table SELECT @num_zakaz, Код_работы, 'Перерасход' FROM Выполнение_работ WHERE Номер_заказа = @num_zakaz

				FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark
				CONTINUE
			END
			ELSE
			BEGIN
				FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark
				CONTINUE
			END
		END

		-- доделоц
		IF (@mark = 'возврат средств')
		BEGIN
			IF EXISTS(SELECT * FROM Заказ_наряд WHERE Номер_заказа = @num_zakaz AND Дата_выполнения IS NULL)
			BEGIN
				INSERT INTO @result_table SELECT @num_zakaz, Код_работы, 'Возврат средств' FROM Выполнение_работ WHERE Номер_заказа = @num_zakaz

				FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark
				CONTINUE
			END
			ELSE
			BEGIN
				FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark
				CONTINUE
			END
		END

		IF (@mark = 'возможный долг')
		BEGIN
			IF ((SELECT SUM(Зарплата) 
				FROM Выполнение_работ INNER JOIN Исполнитель ON Выполнение_работ.Код_исполнителя = Исполнитель.Код_исполнителя
				WHERE Номер_заказа = @num_zakaz AND Код_работы = @work_code) > (SELECT Стоимость_работы / 2 FROM Работа WHERE Код_работы = @work_code))
			BEGIN
				INSERT INTO @result_table SELECT @num_zakaz, Код_работы, 'Возможный долг' FROM Выполнение_работ WHERE Номер_заказа = @num_zakaz
			END
			ELSE
			BEGIN
				FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark
				CONTINUE
			END
		END

		FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark
	END 

	CLOSE db_cursor  

	DEALLOCATE db_cursor
	SELECT DISTINCT * FROM @result_table ORDER BY Отметка
	SELECT * FROM Выполнение_работ
ROLLBACK

go
