## Работа с уровнями изоляции транзакции в PostgreSQL

### Read committed

`````` sql
\set AUTOCOMMIT off
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
``````

![Отключаем автокоммит](files/step_01.png)

В первой сессии создаем запись в БД. В этой сессии изменения будут видны.
При этом во второй сессии этой записи не видно, до тех пор, пока транзакция первой сессии не будет завершена. Это 
обуславливается уровнем изоляции `Read committed`, который позволяет видеть зафиксированные изменения при перечитке 
данных в параллельных транзакциях до их завершения.

![Создаем запись в таблице в первой сессии, результат выборки во второй сессии](files/step_02.png)

![Результат выборки во второй сессии после завершения транзакции в первой сессии](files/step_03.png)

## Repeatable read

`````` sql
\set AUTOCOMMIT off
`SET TRANSACTION ISOLATION LEVEL REPEATABLE READ`
``````

В первой сессии создаем запись в БД. В этой сессии изменения будут видны. Во второй сессии новая запись видна не 
будет, как и при уровне `Read committed`.

![Создаем запись в таблице в первой сессии, результат выборки во второй сессии](files/step_04.png)

После завершения транзакции в первой сессии, результаты изменений во второй сессии до сих пор не видны, в отличие от 
уровня `Read committed`. 

![Закрываем транзакцию первой сессии. Выборка данных во второй не отражает данных первой сессии](files/step_05.png)

Данные, добавленные в первой сессии, будут видны во второй только после завершения 
транзакции второй сессии. Это обуславливается уровнем изоляции `Repeatable read`, который является более строгим по 
отношению к предыдущему уровню. 

![Выборка данных во второй сессии отражает данные первой только после завершения транзакции второй](files/step_06.png)

