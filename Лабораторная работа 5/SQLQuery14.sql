Use [����������]
Go

Create Procedure FirstOne (@kode_komp int)
as
Begin
	With smth as (Select month(����_����������) as �����, ���_����������, count(*) as ����������
		From (Select �����_������ From ����������_������ Where ���_���������� = @kode_komp) t1
		inner join ����� on �����.�����_������ = t1.�����_������
		Where year(����_����������) = YEAR(Getdate())
		Group by month(����_����������), ���_����������)
	Select ���_����������
	From 
		 smth as t1
	Where exists(select * from smth as t2 where t1.���_���������� = t2.���_���������� and t1.����� + 1 = t2.����� and t1.���������� * 3 = t2.����������)
	Group by ���_����������
	Having count(���_����������) + 1 =  MONTH(GETDATE()) - (MONTH(GETDATE()) - 3)
end
go

Declare @code int
Set @code = 1
Execute dbo.FirstOne @code
go

drop procedure FirstOne
go


-- ������ ������, � �� �������� ����� ���������� ������ ����...
Declare @komponent nvarchar(30)
Set @komponent = 'GAYVIDIA RTX 3090 FE'

Declare @kode_komp int
Select @kode_komp = ���_���������� From ���������� Where @komponent = ��������

SELECT ���_����������
FROM 
	(SELECT MONTH(����_����������) AS �����, ���_����������, COUNT(*) AS ����������
	 FROM (SELECT �����_������ FROM ����������_������ WHERE ���_���������� = @kode_komp) t1
		INNER JOIN ����� ON �����.�����_������ = t1.�����_������
	 WHERE year(����_����������) = YEAR(Getdate())
	 GROUP BY MONTH(����_����������), ���_����������) t2
WHERE exists(
(SELECT * 
 FROM
	(SELECT MONTH(����_����������) AS �����, ���_����������, COUNT(*) AS ����������
	 FROM (Select �����_������ FROM ����������_������ WHERE ���_���������� = @kode_komp) t1
		inner join ����� ON �����.�����_������ = t1.�����_������
	 Where YEAR(����_����������) = YEAR(Getdate()) AND ���_���������� = t2.���_���������� AND MONTH(����_����������) + 1 = t2.�����
	 GROUP BY MONTH(����_����������), ���_����������) t3
WHERE t3.���������� * 3 = t2.����������))
GROUP BY ���_����������
HAVING COUNT(���_����������) + 1 = MONTH(GETDATE()) - (MONTH(GETDATE()) - 3)
