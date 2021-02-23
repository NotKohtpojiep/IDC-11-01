/*
8 �������
...
...
...
*/
-- use [YourDatabaseName] EXEC sp_changedbowner 'sa'
-- ������� ��� ������� ������������ .-.

use ����������

BEGIN TRAN
	DECLARE @mark VARCHAR(50) -- ������� ������
	DECLARE @num_zakaz int -- ����� ������
	DECLARE @work_code int -- ��� ������
	DECLARE @worker_code int -- ��� �����������

	DECLARE @result_table TABLE(
		�����_������ INT NOT NULL,  
		���_������ INT NOT NULL,  
		������� NVARCHAR(60) NOT NULL)

	-- � ������� �����������!
	DECLARE db_cursor CURSOR FOR 
		(SELECT �����_������, ���_������, ���_�����������, �������_�_���������� from ����������_�����)

	-- ��������� ������
	OPEN db_cursor  
	FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark

	WHILE @@FETCH_STATUS = 0  
	BEGIN
		SELECT @mark = LOWER(@mark)	

		-- �������� ������ � �������� "�� ���������"
		IF (@mark = '�� ���������')
		BEGIN
			-- ���������, �������� �� ������������� ����� ������, � �������� ��� ������ �����������
			IF NOT EXISTS(SELECT DISTINCT �����_������ FROM ����������_����� 
				WHERE �����_������ NOT IN (SELECT �����_������ FROM ����������_����� WHERE ���_����������� = @worker_code))
			BEGIN
				PRINT('���������� �������������� �����: ' + CAST(@num_zakaz as nvarchar) + ' � ����� ��������: ' + CAST(@worker_code as nvarchar))
				FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark
				CONTINUE
			END
			-- �������� � ����������������
			IF (NOT EXISTS(SELECT * FROM ����������_����� WHERE �����_������ = @num_zakaz and LOWER(�������_�_����������) != '�� ���������'))
			BEGIN
				DECLARE @rand_num INT = (SELECT TOP 1 �����_������ 
										FROM ����������_����� 
										WHERE �����_������ NOT IN (SELECT �����_������ FROM ����������_����� WHERE ���_����������� = @worker_code) 
											AND LOWER(�������_�_����������) != '�� ���������' 
										ORDER BY NEWID())
				-- ������� ����� ������, ���� ������� ���, ����� ���������� ���������������� �����
				IF (NOT EXISTS(SELECT * FROM ����������_������ WHERE �����_������ = @rand_num AND ���_������ = @work_code))
				BEGIN
					INSERT INTO ����������_������ VALUES (@rand_num, @work_code)
				END
				UPDATE ����������_����� 
				SET �������_�_���������� = '�������������', 
						�����_������ = @rand_num
				WHERE �����_������ = @num_zakaz and ���_������ = @work_code and ���_����������� = @worker_code
				-- ������� ������, ���� �� ��� ����� �� ���������
				IF (NOT EXISTS(SELECT * FROM ����������_����� WHERE �����_������ = @num_zakaz AND ���_������ = @work_code))
				BEGIN
					DELETE ����������_������ WHERE �����_������ = @num_zakaz AND ���_������ = @work_code
				END
				FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark
				CONTINUE
			END
			-- �������� ���� ���������� ���� ���� ������ � ������� ���������
			ELSE
			BEGIN
				FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark
				CONTINUE
			END
		END


		IF (@mark = '����������')
		BEGIN
			-- ��������� ����������� ������ ��������� ��������� ������. ����� ���� �� ��������� ����� ���������
			IF ((SELECT SUM(���������_������) 
				 FROM ������ INNER JOIN ����������_����� on ������.���_������ = ����������_�����.���_������
				 WHERE �����_������ = @num_zakaz) > (SELECT ������_��������� FROM �����_����� WHERE �����_������ = @num_zakaz))
			BEGIN
				INSERT INTO @result_table SELECT @num_zakaz, ���_������, '����������' FROM ����������_����� WHERE �����_������ = @num_zakaz

				FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark
				CONTINUE
			END
			ELSE
			BEGIN
				FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark
				CONTINUE
			END
		END

		-- �������
		IF (@mark = '������� �������')
		BEGIN
			IF EXISTS(SELECT * FROM �����_����� WHERE �����_������ = @num_zakaz AND ����_���������� IS NULL)
			BEGIN
				INSERT INTO @result_table SELECT @num_zakaz, ���_������, '������� �������' FROM ����������_����� WHERE �����_������ = @num_zakaz

				FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark
				CONTINUE
			END
			ELSE
			BEGIN
				FETCH NEXT FROM db_cursor INTO @num_zakaz, @work_code, @worker_code, @mark
				CONTINUE
			END
		END

		IF (@mark = '��������� ����')
		BEGIN
			IF ((SELECT SUM(��������) 
				FROM ����������_����� INNER JOIN ����������� ON ����������_�����.���_����������� = �����������.���_�����������
				WHERE �����_������ = @num_zakaz AND ���_������ = @work_code) > (SELECT ���������_������ / 2 FROM ������ WHERE ���_������ = @work_code))
			BEGIN
				INSERT INTO @result_table SELECT @num_zakaz, ���_������, '��������� ����' FROM ����������_����� WHERE �����_������ = @num_zakaz
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
	SELECT DISTINCT * FROM @result_table ORDER BY �������
	SELECT * FROM ����������_�����
ROLLBACK

go
