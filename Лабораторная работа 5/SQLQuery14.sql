Use [Библиотека]
Go

Create Procedure FirstOne (@kode_komp int)
as
Begin
	With smth as (Select month(Дата_оформления) as Месяц, Код_сотрудника, count(*) as Количество
		From (Select Номер_заказа From Содержимое_заказа Where Код_компонента = @kode_komp) t1
		inner join Заказ on Заказ.Номер_заказа = t1.Номер_заказа
		Where year(Дата_оформления) = YEAR(Getdate())
		Group by month(Дата_оформления), Код_сотрудника)
	Select Код_сотрудника
	From 
		 smth as t1
	Where exists(select * from smth as t2 where t1.Код_сотрудника = t2.Код_сотрудника and t1.Месяц + 1 = t2.Месяц and t1.Количество * 3 = t2.Количество)
	Group by Код_сотрудника
	Having count(Код_сотрудника) + 1 =  MONTH(GETDATE()) - (MONTH(GETDATE()) - 3)
end
go

Declare @code int
Set @code = 1
Execute dbo.FirstOne @code
go

drop procedure FirstOne
go


-- Пример работы, а то забивать тонны дубликатов полный треш...
Declare @komponent nvarchar(30)
Set @komponent = 'GAYVIDIA RTX 3090 FE'

Declare @kode_komp int
Select @kode_komp = Код_компонента From Компоненты Where @komponent = Название

SELECT Код_сотрудника
FROM 
	(SELECT MONTH(Дата_оформления) AS Месяц, Код_сотрудника, COUNT(*) AS Количество
	 FROM (SELECT Номер_заказа FROM Содержимое_заказа WHERE Код_компонента = @kode_komp) t1
		INNER JOIN Заказ ON Заказ.Номер_заказа = t1.Номер_заказа
	 WHERE year(Дата_оформления) = YEAR(Getdate())
	 GROUP BY MONTH(Дата_оформления), Код_сотрудника) t2
WHERE exists(
(SELECT * 
 FROM
	(SELECT MONTH(Дата_оформления) AS Месяц, Код_сотрудника, COUNT(*) AS Количество
	 FROM (Select Номер_заказа FROM Содержимое_заказа WHERE Код_компонента = @kode_komp) t1
		inner join Заказ ON Заказ.Номер_заказа = t1.Номер_заказа
	 Where YEAR(Дата_оформления) = YEAR(Getdate()) AND Код_сотрудника = t2.Код_сотрудника AND MONTH(Дата_оформления) + 1 = t2.Месяц
	 GROUP BY MONTH(Дата_оформления), Код_сотрудника) t3
WHERE t3.Количество * 3 = t2.Количество))
GROUP BY Код_сотрудника
HAVING COUNT(Код_сотрудника) + 1 = MONTH(GETDATE()) - (MONTH(GETDATE()) - 3)
