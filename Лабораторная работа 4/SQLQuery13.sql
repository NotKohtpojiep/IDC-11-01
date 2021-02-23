-- ������ �������
Create function f1(@zakaz int)
returns int
as
begin
	Declare @k int
	Select @k = Sum(����������)
	From ����������_������ 
	Where �����_������ = @zakaz
	return @k
end
go

Select dbo.f1(1)
go

-- ������ �������
Create function f2()
returns int
as
Begin
	Declare @Summa int
	Select @Summa = Sum(��������� * t1.����������)
		From 
			(Select ����������_������.���_����������, ����������, ����_����������, ���������, �����.�����_������
			From ����� inner join ����������_������ on
			�����.�����_������ = ����������_������.�����_������ inner join ���������� on ����������_������.���_���������� = ����������.���_����������
			Where �������_�_���������� = 1) t1
	where ����_���������� >= dateadd( month, -1, (select Max(�����.����_����������) from �����))
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
	(Select ��������� From ����������
	 Where ���_���������� = @komponent) * POWER (1.03, (SELECT COUNT(*) FROM ����������_������ WHERE ���_���������� = @komponent))
end
go
*/

Create function f3()
returns @t table (�����_������ int, ������������_���������� nvarchar(100), ��������� int)
as
begin
	
	Insert @t
	Select �����_������, ��������, ��������� * power(1.03, (select count(*) 
															From ����������_������ inner join ����� on �����.�����_������ = ����������_������.�����_������
															Where t1.����_���������� > �����.����_���������� 
															and t1.���_���������� = ����������_������.���_����������))
	From(
	Select ����������_������.���_����������, ����������_������.�����_������, ��������, ���������, ����_����������
				   From ���������� inner join ����������_������ on ����������.���_���������� = ����������_������.���_����������
				   inner join ����� on �����.�����_������ = ����������_������.�����_������) t1
				   
	return
end
go

Select * from f3()
go

drop function f1
drop function f2
drop function f3