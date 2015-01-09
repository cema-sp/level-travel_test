# Добро пожаловать #

Это тестовое задание, выполненное [мной][s.a.pisarev] для [Level-Travel].

Разработка велась [BDD]-методикой, полностью через тестирование 
с использованием RSpec и Cucumber.  

| Название              | Ссылка                         |  
| --------------------- | ------------------------------ |  
| Покрытие кода тестами | [![Coverage Status]][coverage] |  
| Выполнение тестов     | [![Travis CI Status]][ci]      |  
| Репозиторий на GitHub | [cema-sp/level-travel_test]    |  
| Демо приложение       | [Heroku][demo]                 |  

В проекте использовались (согласно требованиям): 
* Typhoeus
* Sidekiq

Тестирование: 
* RSpec
* Cucumber
* Webmock

### Первое задание ###
Таблица продолжительности доступных туров по дням месяца в виде календаря. 
В таблицу выводится 31 день начиная с текущего. 
Цвет ячейки таблицы меняется в зависимости от количества 
туров относительно максимальному количеству за период.  
**Схема примера**:  
![Первое задание]  

### Второе задание ###
Отправка пользователю email-сообщения, содержащего список стран, 
в которые возможно поехать в указанное число на указанное количество дней. 
Приложение асинхронно запускает задачу, выполняющую запрос всех доступных стран 
у API. Задача параллельно выполняет запросы количества ночей 
по всем странам на искомую дату и запускает асинхронную отправку email-сообщения.  
**Схема примера**:  
![Второе задание]  

[s.a.pisarev]: mailto:s.a.pisarev@gmail.com "S.A. Pisarev"
[Level-Travel]: http://level.travel "Level-Travel"
[BDD]: http://en.wikipedia.org/wiki/Behavior-driven_development "BDD"
[Coverage Status]: https://coveralls.io/repos/cema-sp/level-travel_test/badge.png?branch=master "Coveralls"
[coverage]: https://coveralls.io/r/cema-sp/level-travel_test?branch=master "Coveralls"
[Travis CI Status]: https://travis-ci.org/cema-sp/level-travel_test.svg?branch=master "Travis-CI"
[ci]: https://travis-ci.org/cema-sp/level-travel_test "Travis-CI"
[cema-sp/level-travel_test]: https://github.com/cema-sp/level-travel_test "GitHub"
[demo]: https://level-travel-s-pisarev.herokuapp.com/ "Heroku"
[Первое задание]: app/assets/images/first_test.png "Схема примера"
[Второе задание]: app/assets/images/first_test.png "Схема примера"
