
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мОбъект = РеквизитФормыВЗначение("Объект");
	мОбъект.ДобавитьМеню(ЭтаФорма,"Behaviors");
	
	ЭтаФорма.КоманднаяПанель.Видимость = Ложь;
	ЭтаФорма.АвтоЗаголовок = Ложь;
	ЭтаФорма.Заголовок = "Behaviors";

	ЗаполнитьЗначенияСвойств(Объект,Параметры);
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаМеню(Команда)
	ИмяКоманды = Команда.Имя;
	мПараметры = новый Структура("Проверка,ТестируемыйКлиент",Объект.Проверка,Объект.ТестируемыйКлиент);
	ОткрытьФорму("ВнешняяОбработка.AllureSkin.Форма."+ИмяКоманды,мПараметры,ЭтаФорма,ЭтаФорма.УникальныйИдентификатор,ЭтаФорма.Окно);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗагрузитьНастройкиПользователя();
	СформироватьГрафикиТаблицы();
	
	Если НЕ ЗначениеЗаполнено(Фильтр_ИсторияВыполнения) Тогда
		Фильтр_ИсторияВыполнения="все";
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Фильтр_СтабильностьВыполненияТестов) Тогда
		Фильтр_СтабильностьВыполненияТестов="все";
	КонецЕсли;
	
	Фильтр_ИсторияВыполненияПриИзмененииФрагмент();
	Фильтр_СтабильностьВыполненияТестовПриИзмененииФрагмент();

КонецПроцедуры


&НаКлиенте
Процедура ПриПовторномОткрытии()
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиПользователя(ИмяНастройки="",ЗначениеНастройки="")
	
	мОбъект = РеквизитФормыВЗначение("Объект");
	мОбъект.СохранитьНастройкиПользователя(Объект,ИмяНастройки,ЗначениеНастройки);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиПользователя()
	
	мОбъект = РеквизитФормыВЗначение("Объект");
	
	МассивНаименованийНастроек = новый Массив;
	МассивНаименованийНастроек.Добавить("ВидГрафика_ИсторияИзменений");
	МассивНаименованийНастроек.Добавить("ВидГрафика_СоотношениеТестов");
	МассивНаименованийНастроек.Добавить("Фильтр_СтабильностьВыполненияТестов");
	МассивНаименованийНастроек.Добавить("Фильтр_ИсторияВыполнения");
	
	Для каждого ИмяНастройки из МассивНаименованийНастроек Цикл
		
		ЗначениеНастройки = мОбъект.ЗагрузитьНастройкиПользователя(Объект,ИмяНастройки);		
		Если ЗначениеНастройки<>Неопределено Тогда
			ЭтаФорма[ИмяНастройки] = ЗначениеНастройки;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьГрафикиТаблицы()
	
	СформироватьТаблицуСтабильностьВыполненияТестов();
	СформироватьГрафикИсторияИзменений();
	СформироватьГрафикИсторияИзмененийВремениВыполнения();
	СформироватьТаблицуИсторияВыполненияТестов();
	
	
КонецПроцедуры

&НаСервере
Процедура СформироватьТаблицуСтабильностьВыполненияТестов()
	
	Перем Запрос, СоответсвиеТестов, стр, стр_н, СтруктураСвойств, ТаблицаРезультата;
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 5
	|	ПротоколыВыполненияТестов.Проверка КАК Проверка
	|ПОМЕСТИТЬ ВтПоследниеПятьПроверок
	|ИЗ
	|	РегистрСведений.ПротоколыВыполненияТестов КАК ПротоколыВыполненияТестов
	|ГДЕ
	|	ПротоколыВыполненияТестов.ТестируемыйКлиент = &ТестируемыйКлиент
	|
	|УПОРЯДОЧИТЬ ПО
	|	Проверка.Код УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВтПоследниеПятьПроверок.Проверка) КАК Проверка
	|ПОМЕСТИТЬ ВтМаксимальная
	|ИЗ
	|	ВтПоследниеПятьПроверок КАК ВтПоследниеПятьПроверок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПротоколыВыполненияТестов.ТестируемыйКлиент КАК ТестируемыйКлиент,
	|	ПротоколыВыполненияТестов.Тест КАК Тест,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ПротоколыВыполненияТестов.Проверка = ВтМаксимальная.Проверка
	|				ТОГДА ПротоколыВыполненияТестов.ВремяВыполнения
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ПоследняяПродолжительность,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ПротоколыВыполненияТестов.Проверка = ВтМаксимальная.Проверка
	|				ТОГДА ВЫБОР
	|						КОГДА ПротоколыВыполненияТестов.КоличествоПровалов > 0
	|							ТОГДА 4
	|						КОГДА ПротоколыВыполненияТестов.КоличествоПровалов = 0
	|								И ПротоколыВыполненияТестов.КоличествоОшибок > 0
	|							ТОГДА 3
	|						КОГДА ПротоколыВыполненияТестов.КоличествоПровалов = 0
	|								И ПротоколыВыполненияТестов.КоличествоОшибок = 0
	|								И ПротоколыВыполненияТестов.КоличествоПропущенных < ПротоколыВыполненияТестов.КоличествоТестовыхСлучаев
	|							ТОГДА 1
	|						ИНАЧЕ 0
	|					КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ИндексКартинки,
	|	СРЕДНЕЕ(ПротоколыВыполненияТестов.ВремяВыполнения) КАК СреднееВремяВыполнения,
	|	СУММА(ВЫБОР
	|			КОГДА ПротоколыВыполненияТестов.КоличествоПровалов > 0
	|					ИЛИ ПротоколыВыполненияТестов.КоличествоОшибок > 0
	|				ТОГДА 0
	|			ИНАЧЕ 1
	|		КОНЕЦ) КАК ИндексКартинкиСтабильностиВыполнения
	|ИЗ
	|	РегистрСведений.ПротоколыВыполненияТестов КАК ПротоколыВыполненияТестов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтМаксимальная КАК ВтМаксимальная
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ПротоколыВыполненияТестов.ТестируемыйКлиент = &ТестируемыйКлиент
	|	И ПротоколыВыполненияТестов.Проверка В
	|			(ВЫБРАТЬ
	|				ВтПоследниеПятьПроверок.Проверка
	|			ИЗ
	|				ВтПоследниеПятьПроверок)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПротоколыВыполненияТестов.ТестируемыйКлиент,
	|	ПротоколыВыполненияТестов.Тест";
	
	
	Запрос.УстановитьПараметр("ТестируемыйКлиент",Объект.ТестируемыйКлиент);
	
	ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
	
	ТаблицаСтабильностьВыполненияТестов.Очистить();
	
	Для каждого стр из ТаблицаРезультата Цикл
		
		стр_н = ТаблицаСтабильностьВыполненияТестов.Добавить();
		ЗаполнитьЗначенияСвойств(стр_н,стр);
		Если стр_н.ИндексКартинкиСтабильностиВыполнения>4 Тогда
			стр_н.ИндексКартинкиСтабильностиВыполнения = 4;
		КонецЕсли;
		Если стр.ИндексКартинкиСтабильностиВыполнения = 5 Тогда
			стр_н.СтабильностьВыполнения = Перечисления.СтабильностьВыполненияЗаданий.СредиПоследнихЗаданийНетПровалившихся;
		ИначеЕсли стр.ИндексКартинкиСтабильностиВыполнения = 4 Тогда
			стр_н.СтабильностьВыполнения = Перечисления.СтабильностьВыполненияЗаданий.СредиПоследних5Провалилось1;
		ИначеЕсли стр.ИндексКартинкиСтабильностиВыполнения = 3 Тогда
			стр_н.СтабильностьВыполнения = Перечисления.СтабильностьВыполненияЗаданий.СредиПоследних5Провалилось2;
		ИначеЕсли стр.ИндексКартинкиСтабильностиВыполнения = 2 Тогда
			стр_н.СтабильностьВыполнения = Перечисления.СтабильностьВыполненияЗаданий.СредиПоследних5Провалилось3;
		ИначеЕсли стр.ИндексКартинкиСтабильностиВыполнения = 1 Тогда
			стр_н.СтабильностьВыполнения = Перечисления.СтабильностьВыполненияЗаданий.СредиПоследних5Провалилось4;
		ИначеЕсли стр.ИндексКартинкиСтабильностиВыполнения = 0 Тогда
			стр_н.СтабильностьВыполнения = Перечисления.СтабильностьВыполненияЗаданий.ВсеПослдениеЗаданияПровалились;
		КонецЕсли;
		
		Если стр.ИндексКартинки=0 Тогда
			стр_н.ПоследнийРезультатВыполнения = Перечисления.РезультатыВыполненияШагов.Неопределено;
		ИначеЕсли стр.ИндексКартинки=1 Тогда
			стр_н.ПоследнийРезультатВыполнения = Перечисления.РезультатыВыполненияШагов.Успешно;
		ИначеЕсли стр.ИндексКартинки=2 Тогда
			стр_н.ПоследнийРезультатВыполнения = Перечисления.РезультатыВыполненияШагов.Пропуск;
		ИначеЕсли стр.ИндексКартинки=3 Тогда
			стр_н.ПоследнийРезультатВыполнения = Перечисления.РезультатыВыполненияШагов.Ошибка;
		ИначеЕсли стр.ИндексКартинки=4 Тогда
			стр_н.ПоследнийРезультатВыполнения = Перечисления.РезультатыВыполненияШагов.Провал;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура СформироватьТаблицуИсторияВыполненияТестов()
	
	Перем Запрос, СоответсвиеТестов, стр, стр_н, СтруктураСвойств, ТаблицаРезультата;
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ &КоличествоПроверок
	|	ПротоколыВыполненияТестов.Проверка КАК Проверка
	|ПОМЕСТИТЬ ВтПоследниеПятьПроверок
	|ИЗ
	|	РегистрСведений.ПротоколыВыполненияТестов КАК ПротоколыВыполненияТестов
	|ГДЕ
	|	ПротоколыВыполненияТестов.ТестируемыйКлиент = &ТестируемыйКлиент
	|
	|УПОРЯДОЧИТЬ ПО
	|	Проверка.Код УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПротоколыВыполненияТестов.ТестируемыйКлиент КАК ТестируемыйКлиент,
	|	ПротоколыВыполненияТестов.Тест КАК Тест,
	|	ПротоколыВыполненияТестов.ВремяВыполнения КАК Продолжительность,
	|	ПротоколыВыполненияТестов.Проверка КАК Проверка,
	|	ВЫБОР
	|		КОГДА ПротоколыВыполненияТестов.КоличествоПровалов > 0
	|			ТОГДА 4
	|		КОГДА ПротоколыВыполненияТестов.КоличествоПровалов = 0
	|				И ПротоколыВыполненияТестов.КоличествоОшибок > 0
	|			ТОГДА 3
	|		КОГДА ПротоколыВыполненияТестов.КоличествоПровалов = 0
	|				И ПротоколыВыполненияТестов.КоличествоОшибок = 0
	|				И ПротоколыВыполненияТестов.КоличествоПропущенных < ПротоколыВыполненияТестов.КоличествоТестовыхСлучаев
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ИндексКартинки
	|ИЗ
	|	РегистрСведений.ПротоколыВыполненияТестов КАК ПротоколыВыполненияТестов
	|ГДЕ
	|	ПротоколыВыполненияТестов.ТестируемыйКлиент = &ТестируемыйКлиент
	|	И ПротоколыВыполненияТестов.Проверка В
	|			(ВЫБРАТЬ
	|				ВтПоследниеПятьПроверок.Проверка
	|			ИЗ
	|				ВтПоследниеПятьПроверок) 
	|УПОРЯДОЧИТЬ ПО
	|	Проверка.Код
	|ИТОГИ ПО
	|	Проверка";
	
	
	Запрос.УстановитьПараметр("ТестируемыйКлиент",Объект.ТестируемыйКлиент);
	
	
	ТаблицаИсторияВыполнения.Очистить();
	
	Если Элементы.НаПолныйЭкранОбратно_ИсторияВыполнения.ЦветФона = новый Цвет() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&КоличествоПроверок",5);
		Элементы.ТаблицаИсторияВыполненияИндексКартинки_6.Видимость = Ложь;
		Элементы.ТаблицаИсторияВыполненияИндексКартинки_7.Видимость = Ложь;
		Элементы.ТаблицаИсторияВыполненияИндексКартинки_8.Видимость = Ложь;
		Элементы.ТаблицаИсторияВыполненияИндексКартинки_9.Видимость = Ложь;
		Элементы.ТаблицаИсторияВыполненияИндексКартинки_10.Видимость = Ложь;
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&КоличествоПроверок",10);
		Элементы.ТаблицаИсторияВыполненияИндексКартинки_6.Видимость = Истина;
		Элементы.ТаблицаИсторияВыполненияИндексКартинки_7.Видимость = Истина;
		Элементы.ТаблицаИсторияВыполненияИндексКартинки_8.Видимость = Истина;
		Элементы.ТаблицаИсторияВыполненияИндексКартинки_9.Видимость = Истина;
		Элементы.ТаблицаИсторияВыполненияИндексКартинки_10.Видимость = Истина;
	КонецЕсли;
	
	
	
	ш=0;
	ВыборкаПроверки = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПроверки.Следующий() Цикл
		
		ш=ш+1;
		Выборка = ВыборкаПроверки.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			мОтбор = новый Структура("Тест,ТестируемыйКлиент",Выборка.Тест,Выборка.ТестируемыйКлиент);
			
			н_строки = ТаблицаИсторияВыполнения.НайтиСтроки(мОтбор);
			
			Если н_строки.Количество()=0 Тогда
				стр_н = ТаблицаИсторияВыполнения.Добавить();
				ЗаполнитьЗначенияСвойств(стр_н,Выборка);
			Иначе
				стр_н = н_строки[0];
			КонецЕсли;
			
			Элементы["ТаблицаИсторияВыполненияИндексКартинки_"+ш].Заголовок = Строка(Выборка.Проверка);

			стр_н["ИндексКартинки_"+ш] = Выборка.ИндексКартинки;
			
		КонецЦикла;
		
	КонецЦикла;



КонецПроцедуры

&НаСервере
Процедура СформироватьГрафикИсторияИзменений()
	
	Перем Выборка, КоличествоОшибок, КоличествоПровалов, КоличествоПропущенных, КоличествоТестовыхСлучаев, КоличествоУспешных, СерияОшибки, СерияПадения, СерияПропуски, СерияУспешно, Статусы, ТочкаДиаграммы;
	
	Объект.Проверка = ПолучитьПоследнююПроверкуДляТестируемогоКлиента(Объект.ТестируемыйКлиент);
	
	Диаграмма_ИсторияИзменений.Очистить();

	
	// настройки графика
	Если НЕ ЗначениеЗаполнено(ВидГрафика_ИсторияИзменений) Тогда
		ВидГрафика_ИсторияИзменений="Гистограмма";
	КонецЕсли;
	Элементы.ВидГрафика_ИсторияИзменений.РежимВыбораИзСписка = Истина;
	Элементы.ВидГрафика_ИсторияИзменений.РедактированиеТекста = Ложь;
	Элементы.ВидГрафика_ИсторияИзменений.СписокВыбора.Очистить();
	Элементы.ВидГрафика_ИсторияИзменений.СписокВыбора.Добавить("Гистограмма");
	Элементы.ВидГрафика_ИсторияИзменений.СписокВыбора.Добавить("График");
	Элементы.ВидГрафика_ИсторияИзменений.СписокВыбора.Добавить("ГистограммаОбъемная");
	Элементы.ВидГрафика_ИсторияИзменений.СписокВыбора.Добавить("ГрафикСОбластями");
	

	Диаграмма_ИсторияИзменений.ТипДиаграммы=ТипДиаграммы[ВидГрафика_ИсторияИзменений];
	
	СерияПадения = Диаграмма_ИсторияИзменений.УстановитьСерию("Падения");
	СерияОшибки = Диаграмма_ИсторияИзменений.УстановитьСерию("Ошибки");
	СерияПропуски = Диаграмма_ИсторияИзменений.УстановитьСерию("Пропуски");
	СерияУспешно = Диаграмма_ИсторияИзменений.УстановитьСерию("Успешно");
	
	КоличествоПровалов = 0;
	КоличествоОшибок = 0;
	КоличествоПропущенных = 0;
	КоличествоУспешных = 0;
	КоличествоТестовыхСлучаев = 1;
	
	
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 5
	|	ПротоколыВыполненияТестов.Проверка КАК Проверка
	|ПОМЕСТИТЬ ВтПоследниеПятьПроверок
	|ИЗ
	|	РегистрСведений.ПротоколыВыполненияТестов КАК ПротоколыВыполненияТестов
	|ГДЕ
	|	ПротоколыВыполненияТестов.ТестируемыйКлиент = &ТестируемыйКлиент
	|
	|УПОРЯДОЧИТЬ ПО
	|	Проверка.Код УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПротоколыВыполненияТестов.Проверка КАК Проверка,
	|	ПротоколыВыполненияТестов.ТестируемыйКлиент КАК ТестируемыйКлиент,
	|	СУММА(ПротоколыВыполненияТестов.КоличествоТестовыхСлучаев) КАК КоличествоТестовыхСлучаев,
	|	СУММА(ПротоколыВыполненияТестов.КоличествоПровалов) КАК КоличествоПровалов,
	|	СУММА(ПротоколыВыполненияТестов.КоличествоОшибок) КАК КоличествоОшибок,
	|	СУММА(ПротоколыВыполненияТестов.КоличествоПропущенных) КАК КоличествоПропущенных,
	|	СУММА(ПротоколыВыполненияТестов.КоличествоТестовыхСлучаев - ПротоколыВыполненияТестов.КоличествоПровалов - ПротоколыВыполненияТестов.КоличествоОшибок - ПротоколыВыполненияТестов.КоличествоПропущенных) КАК КоличествоУспешных,
	|	СУММА(ПротоколыВыполненияТестов.ВремяВыполнения) КАК ВремяВыполнения
	|ИЗ
	|	РегистрСведений.ПротоколыВыполненияТестов КАК ПротоколыВыполненияТестов
	|ГДЕ
	|	ПротоколыВыполненияТестов.ТестируемыйКлиент = &ТестируемыйКлиент
	|	И ПротоколыВыполненияТестов.Проверка В
	|			(ВЫБРАТЬ
	|				ВтПоследниеПятьПроверок.Проверка
	|			ИЗ
	|				ВтПоследниеПятьПроверок)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПротоколыВыполненияТестов.Проверка,
	|	ПротоколыВыполненияТестов.ТестируемыйКлиент
	|
	|УПОРЯДОЧИТЬ ПО
	|	Проверка.Код";
	Запрос.УстановитьПараметр("ТестируемыйКлиент",Объект.ТестируемыйКлиент);
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	

	Пока Выборка.Следующий() Цикл
		
		ТочкаДиаграммы = Диаграмма_ИсторияИзменений.УстановитьТочку(Выборка.Проверка);
		
		КоличествоТестовыхСлучаев = Выборка.КоличествоТестовыхСлучаев;
		Если КоличествоТестовыхСлучаев=0 Тогда
			КоличествоТестовыхСлучаев = 1;
		КонецЕсли;
		КоличествоПровалов = Выборка.КоличествоПровалов/КоличествоТестовыхСлучаев*100;
		КоличествоОшибок = Выборка.КоличествоОшибок/КоличествоТестовыхСлучаев*100;
		КоличествоПропущенных = Выборка.КоличествоПропущенных/КоличествоТестовыхСлучаев*100;
		КоличествоУспешных = Выборка.КоличествоУспешных/КоличествоТестовыхСлучаев*100;
		
		
		Диаграмма_ИсторияИзменений.УстановитьЗначение(ТочкаДиаграммы,СерияПадения, КоличествоПровалов);
		Диаграмма_ИсторияИзменений.УстановитьЗначение(ТочкаДиаграммы,СерияОшибки, КоличествоОшибок);
		Диаграмма_ИсторияИзменений.УстановитьЗначение(ТочкаДиаграммы,СерияПропуски, КоличествоПропущенных);
		Диаграмма_ИсторияИзменений.УстановитьЗначение(ТочкаДиаграммы,СерияУспешно, КоличествоУспешных);
		
		СерияПадения.Цвет = новый Цвет(255,50,50);
		СерияОшибки.Цвет = новый Цвет(255,165,15);
		СерияУспешно.Цвет = новый Цвет(50,195,50);
		СерияПропуски.Цвет = новый Цвет(195,195,195);
		
	КонецЦикла;
	
	
	Диаграмма_ИсторияИзменений.ВидПодписей=ВидПодписейКДиаграмме.Процент;

КонецПроцедуры

&НаСервере
Процедура СформироватьДиаграммуСоотношениеТестов()
	
	Перем Выборка, Запрос, КоличествоОшибок, КоличествоПровалов, КоличествоПропущенных, КоличествоТестовыхСлучаев, КоличествоУспешных, СерияОшибки, СерияПадения, СерияПропуски, СерияУспешно, ТочкаДиаграммы;
	
	
	// настройки графика
	Если НЕ ЗначениеЗаполнено(ВидГрафика_СоотношениеТестов) Тогда
		ВидГрафика_СоотношениеТестов="Гистограмма";
	КонецЕсли;
	Элементы.ВидГрафика_ИсторияИзмененийВремениВыполнения.РежимВыбораИзСписка = Истина;
	Элементы.ВидГрафика_ИсторияИзмененийВремениВыполнения.РедактированиеТекста = Ложь;
	Элементы.ВидГрафика_ИсторияИзмененийВремениВыполнения.СписокВыбора.Очистить();
	Элементы.ВидГрафика_ИсторияИзмененийВремениВыполнения.СписокВыбора.Добавить("Гистограмма");
	Элементы.ВидГрафика_ИсторияИзмененийВремениВыполнения.СписокВыбора.Добавить("График");
	Элементы.ВидГрафика_ИсторияИзмененийВремениВыполнения.СписокВыбора.Добавить("ГистограммаОбъемная");
	Элементы.ВидГрафика_ИсторияИзмененийВремениВыполнения.СписокВыбора.Добавить("ГрафикСОбластями");
	

	Диаграмма_СоотношениеТестов.ТипДиаграммы=ТипДиаграммы[ВидГрафика_СоотношениеТестов];
	СерияБыло =  Диаграмма_СоотношениеТестов.УстановитьСерию("Было");
	СерияСтало =  Диаграмма_СоотношениеТестов.УстановитьСерию("Стало");
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 2
	|	ПротоколыВыполненияТестов.Проверка КАК Проверка
	|ПОМЕСТИТЬ ВтПоследниеДвеПроверки
	|ИЗ
	|	РегистрСведений.ПротоколыВыполненияТестов КАК ПротоколыВыполненияТестов
	|ГДЕ
	|	ПротоколыВыполненияТестов.ТестируемыйКлиент = &ТестируемыйКлиент
	|	И ПротоколыВыполненияТестов.Проверка <= &Проверка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПротоколыВыполненияТестов.Проверка.Код УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Т.Проверка,
	|	Т.ТестируемыйКлиент,
	|	СУММА(Т.КоличествоТестовыхСлучаев) КАК КоличествоТестовыхСлучаев,
	|	СУММА(Т.КоличествоПровалов) КАК КоличествоПровалов,
	|	СУММА(Т.КоличествоОшибок) КАК КоличествоОшибок,
	|	СУММА(Т.КоличествоПропущенных) КАК КоличествоПропущенных,
	|	СУММА(Т.ВремяВыполнения) КАК ВремяВыполнения
	|ИЗ
	|	РегистрСведений.ПротоколыВыполненияТестов КАК Т
	|ГДЕ
	|	Т.ТестируемыйКлиент = &ТестируемыйКлиент
	|	И Т.Проверка В
	|			(ВЫБРАТЬ
	|				ВтПоследниеДвеПроверки.Проверка
	|			ИЗ
	|				ВтПоследниеДвеПроверки)
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.ТестируемыйКлиент,
	|	Т.Проверка";
	
	Запрос.УстановитьПараметр("ТестируемыйКлиент",Объект.ТестируемыйКлиент);
	Запрос.УстановитьПараметр("Проверка",Объект.Проверка);
	Выборка = Запрос.Выполнить().Выбрать();

	Диаграмма_СоотношениеТестов.Очистить();
		
	Пока Выборка.Следующий() Цикл
		
		//ТочкаДиаграммы = Диаграмма_СоотношениеТестов.УстановитьТочку("Количество");
		//Если НЕ Выборка.Проверка=Объект.Проверка Тогда
		//	Диаграмма_СоотношениеТестов.УстановитьЗначение(ТочкаДиаграммы,СерияБыло, Выборка.КоличествоТестовыхСлучаев);
		//Иначе		
		//	Диаграмма_СоотношениеТестов.УстановитьЗначение(ТочкаДиаграммы,СерияСтало, Выборка.КоличествоТестовыхСлучаев);
		//КонецЕсли;
		
		ТочкаДиаграммы = Диаграмма_СоотношениеТестов.УстановитьТочку("Провалов");
		Если НЕ Выборка.Проверка=Объект.Проверка Тогда
			Диаграмма_СоотношениеТестов.УстановитьЗначение(ТочкаДиаграммы,СерияБыло, Выборка.КоличествоПровалов);
		Иначе		
			Диаграмма_СоотношениеТестов.УстановитьЗначение(ТочкаДиаграммы,СерияСтало, Выборка.КоличествоПровалов);
		КонецЕсли;
		
		ТочкаДиаграммы = Диаграмма_СоотношениеТестов.УстановитьТочку("Ошибок");
		Если НЕ Выборка.Проверка=Объект.Проверка Тогда
			Диаграмма_СоотношениеТестов.УстановитьЗначение(ТочкаДиаграммы,СерияБыло, Выборка.КоличествоОшибок);
		Иначе		
			Диаграмма_СоотношениеТестов.УстановитьЗначение(ТочкаДиаграммы,СерияСтало, Выборка.КоличествоОшибок);
		КонецЕсли;
		
	КонецЦикла;
	

КонецПроцедуры

&НаСервере
Процедура СформироватьГрафикИсторияИзмененийВремениВыполнения()
	
	Перем Выборка, КоличествоОшибок, КоличествоПровалов, КоличествоПропущенных, КоличествоТестовыхСлучаев, КоличествоУспешных, СерияОшибки, СерияПадения, СерияПропуски, СерияУспешно, Статусы, ТочкаДиаграммы;
	
	Объект.Проверка = ПолучитьПоследнююПроверкуДляТестируемогоКлиента(Объект.ТестируемыйКлиент);

	Диаграмма_ИсторияИзмененийВремениВыполнения.Очистить();

	
	// настройки графика
	Если НЕ ЗначениеЗаполнено(ВидГрафика_ИсторияИзмененийВремениВыполнения) Тогда
		ВидГрафика_ИсторияИзмененийВремениВыполнения="График";
	КонецЕсли;
	Элементы.ВидГрафика_ИсторияИзмененийВремениВыполнения.РежимВыбораИзСписка = Истина;
	Элементы.ВидГрафика_ИсторияИзмененийВремениВыполнения.РедактированиеТекста = Ложь;
	Элементы.ВидГрафика_ИсторияИзмененийВремениВыполнения.СписокВыбора.Очистить();
	Элементы.ВидГрафика_ИсторияИзмененийВремениВыполнения.СписокВыбора.Добавить("Гистограмма");
	Элементы.ВидГрафика_ИсторияИзмененийВремениВыполнения.СписокВыбора.Добавить("График");
	Элементы.ВидГрафика_ИсторияИзмененийВремениВыполнения.СписокВыбора.Добавить("ГистограммаОбъемная");
	Элементы.ВидГрафика_ИсторияИзмененийВремениВыполнения.СписокВыбора.Добавить("ГрафикСОбластями");
	

	Диаграмма_ИсторияИзмененийВремениВыполнения.ТипДиаграммы=ТипДиаграммы[ВидГрафика_ИсторияИзмененийВремениВыполнения];
	
	СерияПродолжительность = Диаграмма_ИсторияИзмененийВремениВыполнения.УстановитьСерию("Продолжительность");

	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 5
	|	ПротоколыВыполненияТестов.Проверка КАК Проверка
	|ПОМЕСТИТЬ ВтПоследниеПятьПроверок
	|ИЗ
	|	РегистрСведений.ПротоколыВыполненияТестов КАК ПротоколыВыполненияТестов
	|ГДЕ
	|	ПротоколыВыполненияТестов.ТестируемыйКлиент = &ТестируемыйКлиент
	|
	|УПОРЯДОЧИТЬ ПО
	|	Проверка.Код УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПротоколыВыполненияТестов.Проверка КАК Проверка,
	|	ПротоколыВыполненияТестов.ТестируемыйКлиент КАК ТестируемыйКлиент,
	|	СУММА(ПротоколыВыполненияТестов.КоличествоТестовыхСлучаев) КАК КоличествоТестовыхСлучаев,
	|	СУММА(ПротоколыВыполненияТестов.КоличествоПровалов) КАК КоличествоПровалов,
	|	СУММА(ПротоколыВыполненияТестов.КоличествоОшибок) КАК КоличествоОшибок,
	|	СУММА(ПротоколыВыполненияТестов.КоличествоПропущенных) КАК КоличествоПропущенных,
	|	СУММА(ПротоколыВыполненияТестов.КоличествоТестовыхСлучаев - ПротоколыВыполненияТестов.КоличествоПровалов - ПротоколыВыполненияТестов.КоличествоОшибок - ПротоколыВыполненияТестов.КоличествоПропущенных) КАК КоличествоУспешных,
	|	СУММА(ПротоколыВыполненияТестов.ВремяВыполнения) КАК ВремяВыполнения
	|ИЗ
	|	РегистрСведений.ПротоколыВыполненияТестов КАК ПротоколыВыполненияТестов
	|ГДЕ
	|	ПротоколыВыполненияТестов.ТестируемыйКлиент = &ТестируемыйКлиент
	|	И ПротоколыВыполненияТестов.Проверка В
	|			(ВЫБРАТЬ
	|				ВтПоследниеПятьПроверок.Проверка
	|			ИЗ
	|				ВтПоследниеПятьПроверок)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПротоколыВыполненияТестов.Проверка,
	|	ПротоколыВыполненияТестов.ТестируемыйКлиент
	|
	|УПОРЯДОЧИТЬ ПО
	|	Проверка";
	Запрос.УстановитьПараметр("ТестируемыйКлиент",Объект.ТестируемыйКлиент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ТочкаДиаграммы = Диаграмма_ИсторияИзмененийВремениВыполнения.УстановитьТочку(Выборка.Проверка);
		
		Диаграмма_ИсторияИзмененийВремениВыполнения.УстановитьЗначение(ТочкаДиаграммы,СерияПродолжительность, Выборка.ВремяВыполнения);
		
	КонецЦикла;
	
	СерияПродолжительность.Цвет = новый Цвет(50,50,215);
	Диаграмма_ИсторияИзмененийВремениВыполнения.ВидПодписей=ВидПодписейКДиаграмме.Значение;

	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПоследнююПроверкуДляТестируемогоКлиента(Знач ТестируемыйКлиент)
	
	Проверка = Справочники.Проверки.ПустаяСсылка();
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	Т.Проверка КАК Проверка
	|ИЗ
	|	РегистрСведений.ПротоколыВыполненияТестов КАК Т
	|ГДЕ
	|	Т.ТестируемыйКлиент = &ТестируемыйКлиент
	|
	|УПОРЯДОЧИТЬ ПО
	|	Т.Проверка.Код УБЫВ";
	Запрос.УстановитьПараметр("ТестируемыйКлиент",ТестируемыйКлиент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Если Выборка.Следующий() Тогда
			Проверка = Выборка.Проверка;
		КонецЕсли;
		
	КонецЕсли;
	
	
	Возврат Проверка;
	
КонецФункции

&НаКлиенте
Процедура ТестируемыйКлиентПриИзменении(Элемент)
	СохранитьНастройкиПользователя();
	СформироватьГрафикиТаблицы();
КонецПроцедуры

&НаКлиенте
Процедура ВидГрафика_ИсторияИзмененийПриИзменении(Элемент)
	СформироватьГрафикИсторияИзменений();
	СохранитьНастройкиГрафика(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВидГрафика_ИсторияИзмененийВремениВыполненияПриИзменении(Элемент)
	СформироватьГрафикИсторияИзмененийВремениВыполнения();
	СохранитьНастройкиГрафика(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиГрафика(Элемент)
	
	Если Элемент=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяЭлемента = Элемент.Имя;
	СохранитьНастройкиПользователя(ИмяЭлемента,ЭтаФорма[ИмяЭлемента]);	
	
КонецПроцедуры

&НаКлиенте
Процедура НаПолныйЭкранОбратно(Команда)
	
	Если Команда.Имя="НаПолныйЭкранОбратно_ИсторияВыполнения" Тогда
		
		Если Элементы.НаПолныйЭкранОбратно_ИсторияВыполнения.ЦветФона = новый Цвет() Тогда
			Элементы.НаПолныйЭкранОбратно_ИсторияВыполнения.ЦветФона = новый Цвет(155,155,155);
			
			Элементы.Группа3.Видимость = Ложь;
			Элементы.Группа4.Видимость = Ложь;
			Элементы.Группа6.Видимость = Ложь;		
			
		Иначе
			Элементы.НаПолныйЭкранОбратно_ИсторияВыполнения.ЦветФона = новый Цвет();
			
			Элементы.Группа3.Видимость = Истина;
			Элементы.Группа4.Видимость = Истина;
			Элементы.Группа6.Видимость = Истина;		
			
		КонецЕсли;
		
		СформироватьТаблицуИсторияВыполненияТестов();
		
		ИмяПоля = "ИндексКартинки_5";
		Если НЕ Элементы.НаПолныйЭкранОбратно_ИсторияВыполнения.ЦветФона = новый Цвет() Тогда
			ИмяПоля = "ИндексКартинки_10";
		КонецЕсли;
		УстановитьФильтр(Фильтр_ИсторияВыполнения,ИмяПоля,"ТаблицаИсторияВыполнения");
		
		
	ИначеЕсли Команда.Имя="НаПолныйЭкранОбратно_СтабильностьВыполнения" Тогда
		
		Если Элементы.НаПолныйЭкранОбратно_СтабильностьВыполнения.ЦветФона = новый Цвет() Тогда
			Элементы.НаПолныйЭкранОбратно_СтабильностьВыполнения.ЦветФона = новый Цвет(155,155,155);
			
			Элементы.Группа3.Видимость = Ложь;
			Элементы.Группа4.Видимость = Ложь;
			Элементы.Группа7.Видимость = Ложь;		
			
		Иначе
			Элементы.НаПолныйЭкранОбратно_СтабильностьВыполнения.ЦветФона = новый Цвет();
			
			Элементы.Группа3.Видимость = Истина;
			Элементы.Группа4.Видимость = Истина;
			Элементы.Группа7.Видимость = Истина;		
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВсе(Команда)
	СформироватьГрафикиТаблицы();
КонецПроцедуры


&НаКлиенте
Процедура Фильтр_ИсторияВыполненияПриИзменении(Элемент)
	Фильтр_ИсторияВыполненияПриИзмененииФрагмент();
	СохранитьНастройкиГрафика(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Фильтр_ИсторияВыполненияПриИзмененииФрагмент()
	
	Перем ИмяПоля;
	
	ИмяПоля = "ИндексКартинки_5";
	Если НЕ Элементы.НаПолныйЭкранОбратно_ИсторияВыполнения.ЦветФона = новый Цвет() Тогда
		ИмяПоля = "ИндексКартинки_10";
	КонецЕсли;
	УстановитьФильтр(Фильтр_ИсторияВыполнения,ИмяПоля,"ТаблицаИсторияВыполнения");

КонецПроцедуры

&НаКлиенте
Процедура Фильтр_СтабильностьВыполненияТестовПриИзменении(Элемент)
	Фильтр_СтабильностьВыполненияТестовПриИзмененииФрагмент();
	СохранитьНастройкиГрафика(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Фильтр_СтабильностьВыполненияТестовПриИзмененииФрагмент()
	
	УстановитьФильтр(Фильтр_СтабильностьВыполненияТестов,"ИндексКартинки","ТаблицаСтабильностьВыполненияТестов");

КонецПроцедуры

&НаКлиенте
Процедура УстановитьФильтр(КодОтбора,ИмяПоля,ИмяТаблицы)
	
	СтруктураОтбора = новый Структура();
	ФиксОтбор = Неопределено;
	
	Если НЕ ЗначениеЗаполнено(ИмяПоля) Тогда
		Возврат;
	КонецЕсли;
	
	Если КодОтбора="падения" Тогда
		СтруктураОтбора.Вставить(ИмяПоля,4);
		ФиксОтбор = новый ФиксированнаяСтруктура(СтруктураОтбора);		
	иначеЕсли КодОтбора="ошибки" Тогда
		СтруктураОтбора.Вставить(ИмяПоля,3);
		ФиксОтбор = новый ФиксированнаяСтруктура(СтруктураОтбора);		
	иначеЕсли КодОтбора="пропуски" Тогда
		СтруктураОтбора.Вставить(ИмяПоля,0);
		ФиксОтбор = новый ФиксированнаяСтруктура(СтруктураОтбора);		
	иначеЕсли КодОтбора="успешно" Тогда
		СтруктураОтбора.Вставить(ИмяПоля,1);
		ФиксОтбор = новый ФиксированнаяСтруктура(СтруктураОтбора);		
	КонецЕсли;
	
	Элементы[ИмяТаблицы].ОтборСтрок = ФиксОтбор;
	
КонецПроцедуры


