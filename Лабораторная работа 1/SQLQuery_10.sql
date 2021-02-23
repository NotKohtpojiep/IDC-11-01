Declare @words nvarchar(299)
Set @words = 'ß ÀÎÂËÀÎÂÛËÎÂÀ ÀËÎÂÛËÀÎÛÂË'

Select count(*) from STRING_SPLIT(@words, ' ')

Declare @count int
Set @count = len(cast(@words as nvarchar))

Declare @chislo int
Set @chislo = 212314132423234

Declare @z int
Set @z = 0
While @z != @count
	begin 
		set @chislo = @chislo / 10
		set @z = @z + 1
	end
print @z


Declare @chaa nvarchar(299)
Set @chaa = 'ß ÀÎÂËÀÎÂÛËÎÂÀ ÀËÎÂÛËÀÎÛÂË 2002'
Select count(*) from STRING_SPLIT(@chaa, ' ')