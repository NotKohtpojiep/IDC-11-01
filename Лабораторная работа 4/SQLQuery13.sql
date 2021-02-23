-- Первое задание
Create function f1(@zakaz int)
returns int
as
begin
	Declare @k int
	Select @k = Sum(Количество)
	From Содержимое_заказа 
	Where Номер_заказа = @zakaz
	return @k
end
go

Select dbo.f1(1)
go

-- Второе задание
Create function f2()
returns int
as
Begin
	Declare @Summa int
	Select @Summa = Sum(Стоимость * t1.Количество)
		From 
			(Select Содержимое_заказа.Код_компонента, Количество, Дата_оформления, Стоимость, Заказ.Номер_заказа
			From Заказ inner join Содержимое_заказа on
			Заказ.Номер_заказа = Содержимое_заказа.Номер_заказа inner join Компоненты on Содержимое_заказа.Код_компонента = Компоненты.Код_компонента
			Where Отметка_о_выполнении = 1) t1
	where Дата_оформления >= dateadd( month, -1, (select Max(Заказ.Дата_оформления) from Заказ))
	return @Summa
End
go

Select dbo.f2()
go

/*
Create function f3(@komponent int)
returns int
as
begin
	return 
	(Select Стоимость From Компоненты
	 Where Код_компонента = @komponent) * POWER (1.03, (SELECT COUNT(*) FROM Содержимое_заказа WHERE Код_компонента = @komponent))
end
go
*/

Create function f3()
returns @t table (Номер_заказа int, Наименование_компонента nvarchar(100), Стоимость int)
as
begin
	
	Insert @t
	Select Номер_заказа, Название, Стоимость * power(1.03, (select count(*) 
															From Содержимое_заказа inner join Заказ on Заказ.Номер_заказа = Содержимое_заказа.Номер_заказа
															Where t1.Дата_оформления > Заказ.Дата_оформления 
															and t1.Код_компонента = Содержимое_заказа.Код_компонента))
	From(
	Select Содержимое_заказа.Код_компонента, Содержимое_заказа.Номер_заказа, Название, Стоимость, Дата_оформления
				   From Компоненты inner join Содержимое_заказа on Компоненты.Код_компонента = Содержимое_заказа.Код_компонента
				   inner join Заказ on Заказ.Номер_заказа = Содержимое_заказа.Номер_заказа) t1
				   
	return
end
go

Select * from f3()
go

drop function f1
drop function f2
drop function f3