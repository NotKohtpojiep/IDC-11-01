Declare @words nvarchar(299)
Set @words = 'Я АОВЛАОВЫЛОВА АЛОВЫЛАОЫВЛ'

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
Set @chaa = 'Я АОВЛАОВЫЛОВА АЛОВЫЛАОЫВЛ 2002'
Select count(*) from STRING_SPLIT(@chaa, ' ')