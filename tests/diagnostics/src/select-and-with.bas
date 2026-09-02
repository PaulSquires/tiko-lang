'' A CASE VALUE MUST BE THE SUBJECT'S KIND -- fbc error 24: a string subject with a numeric
'' case, or a numeric subject with a string case, in either spelling. And 'with' takes a
'' UDT VALUE: a number or a pointer -- even a pointer to a UDT -- is error 24, while a
'' dereference or a variable of the type is the ordinary subject.
type UDT
    i as integer
end type
dim s as string = "a", n as integer = 0
dim x as UDT, px as UDT ptr = @x

select case s
case "a"
end select
select case n
case 0, 1 to 3
end select
with x
end with
with *px
end with

select case s
case 0
end select
select case n
case "a"
end select
with 0
end with
with @x
end with
