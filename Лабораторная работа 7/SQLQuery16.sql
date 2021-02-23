USE ����������;
go

-- ����� �� � ���
ALTER TRIGGER zadanie1 ON dbo.�����_�����
AFTER INSERT, UPDATE
AS  
IF ((SELECT ������_��������� FROM inserted) < 100000)
BEGIN
	RAISERROR ('���������� ������������ �����, ����� ��������� �������� ����� 100000 ������', 16, 1); 
	ROLLBACK
END
GO;

-- �����, ������, ������!
INSERT INTO �����_����� VALUES (17, '2020-01-01', '2020-02-01', 10000.00)
GO;

-- ����� �� � ���
ALTER TRIGGER zadanie2 ON dbo.����������_�����
AFTER INSERT, UPDATE 
AS
	IF (EXISTS (SELECT * FROM deleted))
	BEGIN
	SELECT Table_A.���_�����������, ���������_������ --, SUM(���������_������) as ��������_���������
			FROM deleted AS Table_A
			INNER JOIN inserted AS Table_B
				ON Table_A.���_����������� = Table_B.���_����������� AND Table_A.�����_������ = Table_B.�����_������ AND Table_A.���_������ = Table_B.���_������
			INNER JOIN ������ AS Table_C 
				ON Table_B.���_������ = Table_C.���_������
			WHERE Table_A.�������_�_���������� = 0 AND Table_B.�������_�_���������� = 1
			--GROUP BY Table_A.���_�����������
		UPDATE
			�����������
		SET
			�������� += (SELECT CAST((��������_���������) / 10 / (12 - MONTH(GETDATE())) as decimal(12,2)))
		FROM
			(SELECT Table_A.���_�����������, SUM(���������_������) as ��������_���������
			FROM deleted AS Table_A
			INNER JOIN inserted AS Table_B
				ON Table_A.���_����������� = Table_B.���_����������� AND Table_A.�����_������ = Table_B.�����_������ AND Table_A.���_������ = Table_B.���_������
			INNER JOIN ������ AS Table_C 
				ON Table_B.���_������ = Table_C.���_������
			WHERE Table_A.�������_�_���������� = 0 AND Table_B.�������_�_���������� = 1
			GROUP BY Table_A.���_�����������) as Result
		WHERE �����������.���_����������� = Result.���_�����������
	END
	ELSE
	BEGIN
		UPDATE
			�����������
		SET
			�������� += (SELECT CAST((��������_���������) / 10 / (12 - MONTH(GETDATE())) as decimal(12,2)))
		FROM
			(SELECT Table_A.���_�����������, SUM(���������_������) as ��������_���������
			FROM inserted AS Table_A
			INNER JOIN ������ AS Table_B
				ON Table_A.���_������ = Table_B.���_������
			WHERE Table_A.�������_�_���������� = 1
			GROUP BY Table_A.���_�����������) as Result
		WHERE �����������.���_����������� = Result.���_�����������
	END
GO

-- ����� ������, ������!
BEGIN TRAN
	SELECT * FROM �����������
	UPDATE ����������_����� SET �������_�_���������� = 1  WHERE ���_������ = 4 and ���_����������� = 3
	SELECT * FROM �����������
	ROLLBACK
COMMIT
GO;

