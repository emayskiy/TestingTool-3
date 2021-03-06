
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РедактироватьКонструктором = Истина;
	ИдентификаторКонструктора = "ShortUITaskTestBuilder";
	МенеджерТестированияКонфигурацияТестирование = Истина;
	МенеджерТестирования = Справочники.ТестируемыеКлиенты.ТекущийКлиент1С;
	ПортТестирования = "1538"; 
	
	// Открыта форма редактирования
	Если ЗначениеЗаполнено(Параметры.Задание) Тогда		
		Задание = Параметры.Задание;
	КонецЕсли;
	
	Если Параметры.Свойство("ОбъектыНазначения") Тогда
		Если ТипЗнч(Параметры.ОбъектыНазначения) = Тип("Массив")
			И Параметры.ОбъектыНазначения.Количество()>0 Тогда			
			Задание = Параметры.ОбъектыНазначения[0];
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Задание) Тогда
		Элементы.СоздатьНовоеЗадание.Заголовок = "Применить изменения";
		Запрос = новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	Задания.Наименование,
		|	Задания.ID,
		|	Задания.Автор,
		|	Задания.ГруппаЗадания,
		|	Задания.Ответственный,
		|	Задания.ИдентификаторКонструктора,
		|	Задания.Родитель
		|ИЗ
		|	Справочник.Задания КАК Задания
		|ГДЕ
		|	Задания.Ссылка = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка",Задание);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			
			ВызватьИсключение "Ошибка редактирования запроса в конструкторе...";
			
		КонецЕсли;
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		                    		
		Наименование = Выборка.Наименование;
		TaskID = Выборка.ID; 
		Ответственный = Выборка.Ответственный;
		ГруппаЗадания = Выборка.ГруппаЗадания;
		Родитель =  Выборка.Родитель;
		
		// получим тест из регистра
		Запрос = новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ПеременныеЗаданий.ЗначениеПеременной КАК Значение
		|ИЗ
		|	РегистрСведений.ПеременныеЗаданий КАК ПеременныеЗаданий
		|ГДЕ
		|	ПеременныеЗаданий.Задание = &Задание
		|	И ПеременныеЗаданий.ИмяПеременной = &ИмяПеременной
		|	И ПеременныеЗаданий.ЭтоПараметрНастройки = ИСТИНА";
		Запрос.УстановитьПараметр("Задание",Задание);
		Запрос.УстановитьПараметр("ИмяПеременной",Справочники.ИменаПеременных.Тест);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			Тест = Выборка.Значение;
			ЭтоСценарныйТест = (Тест.ТипТеста=Перечисления.ТипыТестов.СценарныйТест);
			Элементы.ГруппаЕслиСценарныйТест.Видимость = ЭтоСценарныйТест;
		КонецЕсли;
		
		Запрос = новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ПеременныеЗаданий.ЗначениеПеременной КАК Значение
		|ИЗ
		|	РегистрСведений.ПеременныеЗаданий КАК ПеременныеЗаданий
		|ГДЕ
		|	ПеременныеЗаданий.Задание = &Задание
		|	И ПеременныеЗаданий.ИмяПеременной = &ИмяПеременной
		|	И ПеременныеЗаданий.ЭтоПараметрНастройки = ЛОЖЬ";
		Запрос.УстановитьПараметр("Задание",Задание);
		Запрос.УстановитьПараметр("ИмяПеременной","%ПортТестирования%");
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ПортТестирования = Выборка.Значение;
		КонецЕсли;
		
		Запрос = новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ПеременныеЗаданий.ЗначениеПеременной КАК Значение
		|ИЗ
		|	РегистрСведений.ПеременныеЗаданий КАК ПеременныеЗаданий
		|ГДЕ
		|	ПеременныеЗаданий.Задание = &Задание
		|	И ПеременныеЗаданий.ИмяПеременной = &ИмяПеременной
		|	И ПеременныеЗаданий.ЭтоПараметрНастройки = ИСТИНА";
		Запрос.УстановитьПараметр("Задание",Задание);
		Запрос.УстановитьПараметр("ИмяПеременной","НеИспользоватьСсылкуНаТест");
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			НеИспользоватьСсылкуНаТест = Выборка.Значение;
		КонецЕсли;
		
		Элементы.ГруппаСвойстваТеста.Видимость = НЕ НеИспользоватьСсылкуНаТест;		
		
		Запрос = новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ПеременныеЗаданий.ЗначениеПеременной КАК Значение
		|ИЗ
		|	РегистрСведений.ПеременныеЗаданий КАК ПеременныеЗаданий
		|ГДЕ
		|	ПеременныеЗаданий.Задание = &Задание
		|	И ПеременныеЗаданий.ИмяПеременной = &ИмяПеременной
		|	И ПеременныеЗаданий.ЭтоПараметрНастройки = ИСТИНА";
		Запрос.УстановитьПараметр("Задание",Задание);
		Запрос.УстановитьПараметр("ИмяПеременной",Справочники.ИменаПеременных.МенеджерТестирования);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			МенеджерТестирования = Выборка.Значение;
		КонецЕсли;
		
		Запрос = новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ПеременныеЗаданий.ЗначениеПеременной КАК Значение
		|ИЗ
		|	РегистрСведений.ПеременныеЗаданий КАК ПеременныеЗаданий
		|ГДЕ
		|	ПеременныеЗаданий.Задание = &Задание
		|	И ПеременныеЗаданий.ИмяПеременной = &ИмяПеременной
		|	И ПеременныеЗаданий.ЭтоПараметрНастройки = ИСТИНА";
		Запрос.УстановитьПараметр("Задание",Задание);
		Запрос.УстановитьПараметр("ИмяПеременной",Справочники.ИменаПеременных.ТестируемыйКлиент);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ТестируемыйКлиент = Выборка.Значение;
		КонецЕсли;
		
		// загрузка данных
		Запрос = новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ПеременныеЗаданий.ЗначениеПеременной КАК Значение
		|ИЗ
		|	РегистрСведений.ПеременныеЗаданий КАК ПеременныеЗаданий
		|ГДЕ
		|	ПеременныеЗаданий.Задание = &Задание
		|	И ПеременныеЗаданий.ИмяПеременной = &ИмяПеременной
		|	И ПеременныеЗаданий.ЭтоПараметрНастройки = ЛОЖЬ";
		Запрос.УстановитьПараметр("Задание",Задание);
		Запрос.УстановитьПараметр("ИмяПеременной","%ТестЗагрузкаДанных%");
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ТестЗагрузкиДанных = Выборка.Значение;
		КонецЕсли;		
		
		// загрузка данных
		Запрос = новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ПеременныеЗаданий.ЗначениеПеременной КАК Значение
		|ИЗ
		|	РегистрСведений.ПеременныеЗаданий КАК ПеременныеЗаданий
		|ГДЕ
		|	ПеременныеЗаданий.Задание = &Задание
		|	И ПеременныеЗаданий.ИмяПеременной = &ИмяПеременной
		|	И ПеременныеЗаданий.ЭтоПараметрНастройки = ЛОЖЬ";
		Запрос.УстановитьПараметр("Задание",Задание);
		Запрос.УстановитьПараметр("ИмяПеременной","%ТестУдалениеДанных%");
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ТестУдаленияДанных = Выборка.Значение;
		КонецЕсли;		
		
	Иначе
		
		//Элементы.Задание.Видимость = Ложь;
		
	КонецЕсли;
	
	// видимость 
	Элементы.ГруппаМенеджерТестирования.Видимость = НЕ МенеджерТестированияКонфигурацияТестирование;
	Если ЗначениеЗаполнено(ТестируемыйКлиент) Тогда
		Элементы.ДекорацияПредупрежедениеТестируемыйКлиент.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МенеджерТестирования) Тогда
		Элементы.ДекорацияПредупрежедениеМенеджерТестирования.Видимость = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.СтраницыОбработки.ОтображениеСтраниц=ОтображениеСтраницФормы.Нет;
	ОтработатьПеремещениеПоСтраницам();
КонецПроцедуры

&НаКлиенте
Процедура Вперед(Команда)
	Если Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаИнициализация Тогда
		Если НЕ ПроверитьНаличиеПодобноегоЗадания(Наименование,TaskID,Задание) Тогда
			Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаНастройкиВыполненияТеста;
		КонецЕсли;
	ИначеЕсли Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаНастройкиВыполненияТеста Тогда
		Если НЕ ЗначениеЗаполнено(Тест) И НЕ ЗначениеЗаполнено(ТестЗагрузкиДанных) 
			И НЕ ЗначениеЗаполнено(ТестУдаленияДанных) И НеИспользоватьСсылкуНаТест=Ложь Тогда
			Сообщить("Выберите тесты прежде!");
		Иначе
			Если НЕ ЗначениеЗаполнено(ТестируемыйКлиент) Тогда
				//Сообщить("Если не указать тестируемый клиент для этого задания, тогда не возможно его будет запустить самостоятельно!");
			КонецЕсли;
			// получим данные по существующему заданию
			Если ЗначениеЗаполнено(Задание) Тогда
				ПолучитьСоставПоЗаданию();
			КонецЕсли; 			
			Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаСоставЗадания;
		КонецЕсли;
	ИначеЕсли Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаСоставЗадания Тогда
		Если ПараметрыУказанияПараметровЗаданияКорректны() Тогда
			ОбобщениеHTML = СформироватьОписаниеСоздаваемогоЗдания();
			Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаИтого;
		КонецЕсли;
	ИначеЕсли Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаИтого Тогда
	КонецЕсли;
	
	ОтработатьПеремещениеПоСтраницам();
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	Если Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаИнициализация Тогда
	ИначеЕсли Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаНастройкиВыполненияТеста Тогда
		Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаИнициализация;
	ИначеЕсли Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаСоставЗадания Тогда
		Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаНастройкиВыполненияТеста;
	ИначеЕсли Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаИтого Тогда
		Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаСоставЗадания;
	КонецЕсли;	
	
	ОтработатьПеремещениеПоСтраницам();
КонецПроцедуры

&НаСервере
Функция СоздатьНовоеЗаданиеНаСервере()
	
	Отказ = Ложь;	
	ЗаданиеОбъект = Неопределено;
	
	НачатьТранзакцию();
	
	// Создаем/ обновляем задание
	Если ЗначениеЗаполнено(Задание) Тогда
		ЗаданиеОбъект = Задание.ПолучитьОбъект();
	Иначе
		ЗаданиеОбъект = Справочники.Задания.СоздатьЭлемент();
	КонецЕсли;	
	
	ЗаданиеОбъект.Наименование = Наименование;
	ЗаданиеОбъект.ID = TaskID;
	ЗаданиеОбъект.Родитель = Родитель;
	ЗаданиеОбъект.ГруппаЗадания = ГруппаЗадания;
	ЗаданиеОбъект.РедактироватьКонструктором = РедактироватьКонструктором;
	ЗаданиеОбъект.ИдентификаторКонструктора = ИдентификаторКонструктора;
	ЗаданиеОбъект.Ответственный = Ответственный;
	Если НЕ ЗначениеЗаполнено(ЗаданиеОбъект.Автор) Тогда
		ЗаданиеОбъект.Автор = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Попытка
		ЗаданиеОбъект.Записать();
		Задание = ЗаданиеОбъект.Ссылка;
	Исключение
		ОтменитьТранзакцию();
		Отказ = Истина;
		Сообщить(ОписаниеОшибки());		
		Возврат НЕ Отказ;
	КонецПопытки;
	
	
	// обновляем регистр состав
	НаборЗаписей = РегистрыСведений.СоставЗаданий.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Задание.Установить(Задание);
	
	ПорядокВыполнения = 1;
	
	// загрузка данных
	// 1
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Задание = Задание;
	НоваяЗапись.ПорядокВыполнения = ПорядокВыполнения;
	НоваяЗапись.Действие = ДействиеВыполнитьТестЗагрузкиДанных;
	ПорядокВыполнения = ПорядокВыполнения +1;
	
	// 2
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Задание = Задание;
	НоваяЗапись.ПорядокВыполнения = ПорядокВыполнения;
	НоваяЗапись.Действие = ДействиеОжиданияВыполненияЗагрузкиДанных;
	ПорядокВыполнения = ПорядокВыполнения +1;
	
	// тест
	// 3
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Задание = Задание;
	НоваяЗапись.ПорядокВыполнения = ПорядокВыполнения;
	НоваяЗапись.Действие = ДействиеВыполнитьТест;
	ПорядокВыполнения = ПорядокВыполнения +1;
	
	// 4
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Задание = Задание;
	НоваяЗапись.ПорядокВыполнения = ПорядокВыполнения;
	НоваяЗапись.Действие = ДействиеОжиданияВыполненияТеста;
	ПорядокВыполнения = ПорядокВыполнения +1;
	
	Если ЗначениеЗаполнено(ДействиеЗакрытьПриложение) Тогда
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Задание = Задание;
		НоваяЗапись.ПорядокВыполнения = ПорядокВыполнения;
		НоваяЗапись.Действие = ДействиеЗакрытьПриложение;
		ПорядокВыполнения = ПорядокВыполнения +1;  		
	КонецЕсли;
	
	// 5
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Задание = Задание;
	НоваяЗапись.ПорядокВыполнения = ПорядокВыполнения;
	НоваяЗапись.Действие = ДействиеЗагрузкиЛога;
	ПорядокВыполнения = ПорядокВыполнения +1;
	
	Если ЗначениеЗаполнено(ДействиеЗакрытьПриложение) Тогда
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Задание = Задание;
		НоваяЗапись.ПорядокВыполнения = ПорядокВыполнения;
		НоваяЗапись.Действие = ДействиеЗакрытьПриложение;
		ПорядокВыполнения = ПорядокВыполнения +1;  		
	КонецЕсли;
	
	// удаление данных
	// 6
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Задание = Задание;
	НоваяЗапись.ПорядокВыполнения = ПорядокВыполнения;
	НоваяЗапись.Действие = ДействиеВыполнитьТестУдалениеДанных;
	ПорядокВыполнения = ПорядокВыполнения +1;
	
	// 7
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Задание = Задание;
	НоваяЗапись.ПорядокВыполнения = ПорядокВыполнения;
	НоваяЗапись.Действие = ДействиеОжиданияВыполненияУдаленияДанных;
	ПорядокВыполнения = ПорядокВыполнения +1;	
	
	НаборЗаписей.Записать();
	
	// создаем необходимые переменные
	НаборЗаписей = РегистрыСведений.ПеременныеЗаданий.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Задание.Установить(Задание);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Задание = Задание;
	НоваяЗапись.ИмяПеременной = Справочники.ИменаПеременных.Тест;
	НоваяЗапись.ЗначениеПеременной = Тест;
	НоваяЗапись.ЭтоПараметрНастройки = Истина;
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Задание = Задание;
	НоваяЗапись.ИмяПеременной = "%Тест%";
	НоваяЗапись.ЗначениеПеременной = Тест;
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Задание = Задание;
	НоваяЗапись.ИмяПеременной = "%ПутьКФайлуТеста%";
	НоваяЗапись.ЗначениеПеременной = Тест;
	НоваяЗапись.ИспользоватьФункцию = Истина;
	НоваяЗапись.ИмяФункции = "ПутьКФайлуТеста";
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Задание = Задание;
	НоваяЗапись.ИмяПеременной = "%ПортТестирования%";
	НоваяЗапись.ЗначениеПеременной = ПортТестирования;
	
	Если ЭтоСценарныйТест=Истина Тогда
		Если ЗначениеЗаполнено(МенеджерТестирования) Тогда
			
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Задание = Задание;
			НоваяЗапись.ИмяПеременной = Справочники.ИменаПеременных.МенеджерТестирования;
			НоваяЗапись.ЗначениеПеременной = МенеджерТестирования;
			НоваяЗапись.ЭтоПараметрНастройки = Истина;
			
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Задание = Задание;
			НоваяЗапись.ИмяПеременной = "%СтрокаСоединенияМенеджер%";
			НоваяЗапись.ЗначениеПеременной = МенеджерТестирования;
			НоваяЗапись.ИспользоватьФункцию = Истина;
			НоваяЗапись.ИмяФункции = "СтрокаСоединения";
			
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТестируемыйКлиент) Тогда
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Задание = Задание;
		НоваяЗапись.ИмяПеременной = Справочники.ИменаПеременных.ТестируемыйКлиент;
		НоваяЗапись.ЗначениеПеременной = ТестируемыйКлиент;
		НоваяЗапись.ЭтоПараметрНастройки = Истина;
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Задание = Задание;
		НоваяЗапись.ИмяПеременной = "%СтрокаСоединенияИБ%";
		НоваяЗапись.ЗначениеПеременной = ТестируемыйКлиент;
		НоваяЗапись.ИспользоватьФункцию = Истина;
		НоваяЗапись.ИмяФункции = "СтрокаСоединенияИБ";
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Задание = Задание;
		НоваяЗапись.ИмяПеременной = "%ИмяПользователя1С%";
		НоваяЗапись.ЗначениеПеременной = ТестируемыйКлиент;
		НоваяЗапись.ИспользоватьФункцию = Истина;
		НоваяЗапись.ИмяФункции = "ИмяПользователя1С";
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Задание = Задание;
		НоваяЗапись.ИмяПеременной = "%ПарольПользователя1С%";
		НоваяЗапись.ЗначениеПеременной = ТестируемыйКлиент;
		НоваяЗапись.ИспользоватьФункцию = Истина;
		НоваяЗапись.ИмяФункции = "ПарольПользователя1С";		
	КонецЕсли;
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Задание = Задание;
	НоваяЗапись.ИмяПеременной = "%НомерПроверки%";
	НоваяЗапись.ЗначениеПеременной = 0;

	// настройка задания
	Если НеИспользоватьСсылкуНаТест Тогда
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Задание = Задание;
		НоваяЗапись.ИмяПеременной = "НеИспользоватьСсылкуНаТест";
		НоваяЗапись.ЗначениеПеременной = НеИспользоватьСсылкуНаТест;
		НоваяЗапись.ЭтоПараметрНастройки = Истина;
	КонецЕсли;
	
	
	// загрузка данных
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Задание = Задание;
	НоваяЗапись.ИмяПеременной = "%ТестЗагрузкаДанных%";
	НоваяЗапись.ЗначениеПеременной = ТестЗагрузкиДанных;
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Задание = Задание;
	НоваяЗапись.ИмяПеременной = "%ПутьКФайлуТестаЗагрузкаДанных%";
	НоваяЗапись.ЗначениеПеременной = ТестЗагрузкиДанных;
	НоваяЗапись.ИспользоватьФункцию = Истина;
	НоваяЗапись.ИмяФункции = "ПутьКФайлуТеста";
	
	// удаление данных
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Задание = Задание;
	НоваяЗапись.ИмяПеременной = "%ТестУдалениеДанных%";
	НоваяЗапись.ЗначениеПеременной = ТестУдаленияДанных;
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Задание = Задание;
	НоваяЗапись.ИмяПеременной = "%ПутьКФайлуТестаУдалениеДанных%";
	НоваяЗапись.ЗначениеПеременной = ТестУдаленияДанных;
	НоваяЗапись.ИспользоватьФункцию = Истина;
	НоваяЗапись.ИмяФункции = "ПутьКФайлуТеста";
	
	НаборЗаписей.Записать();
	
	
	ЗафиксироватьТранзакцию();
	
	Возврат НЕ Отказ;
	
КонецФункции

&НаКлиенте
Процедура СоздатьНовоеЗадание(Команда)
	Если СоздатьНовоеЗаданиеНаСервере()=Истина Тогда
		ЭтаФорма.Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтработатьПеремещениеПоСтраницам()
	
	Если Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаИнициализация Тогда
		Элементы.Назад.Видимость = Ложь;
		Элементы.Вперед.Видимость = Истина;
		Элементы.СоздатьНовоеЗадание.Видимость = Ложь;
	ИначеЕсли Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаНастройкиВыполненияТеста Тогда
		Элементы.Назад.Видимость = Истина;
		Элементы.Вперед.Видимость = Истина;
		Элементы.СоздатьНовоеЗадание.Видимость = Ложь;
	ИначеЕсли Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаСоставЗадания Тогда
		Элементы.Назад.Видимость = Истина;
		Элементы.Вперед.Видимость = Истина;
		Элементы.СоздатьНовоеЗадание.Видимость = Ложь;
	ИначеЕсли Элементы.СтраницыОбработки.ТекущаяСтраница=Элементы.СтраницаИтого Тогда
		Элементы.Назад.Видимость = Истина;
		Элементы.Вперед.Видимость = Ложь;
		Элементы.СоздатьНовоеЗадание.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Если НЕ ЗначениеЗаполнено(TaskID) Тогда
		TaskID = СценарноеТестированиеКлиентСервер.СформироватьАвтоматическиИдентификаторТеста(Наименование);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьНаличиеПодобноегоЗадания(Знач Наименование,Знач TaskID,Знач Задание)   	
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		Сообщить("Укажите наименование нового задания!");
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(TaskID) Тогда
		Сообщить("Укажите идентификатор нового задания!");
		Возврат Истина;
	КонецЕсли;
	
	// проверим, есть ли такое задание
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Задания.Ссылка,
	|	Задания.ID,
	|	Задания.Наименование
	|ИЗ
	|	Справочник.Задания КАК Задания
	|ГДЕ
	|	(Задания.Наименование = &Наименование
	|			ИЛИ Задания.ID = &TaskID)
	|	И НЕ Задания.Ссылка = &Задание";
	
	Запрос.УстановитьПараметр("Наименование",Наименование);
	Запрос.УстановитьПараметр("TaskID",TaskID);
	Запрос.УстановитьПараметр("Задание",Задание);

	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Сообщить("Уже существет задание с подобным именем или идентификатором. Измените вводимые данные! Наименование - " +Выборка.Наименование+" Идентификатор - "+Выборка.ID);
		
	КонецЦикла;
	
	
	Возврат Истина;
	
	
КонецФункции

&НаКлиенте
Функция ПараметрыУказанияПараметровЗаданияКорректны()
	
	Отказ = Ложь;
	
	// основной тест
	Если НЕ ЗначениеЗаполнено(ДействиеВыполнитьТест) Тогда
		Сообщить("Укажите действие 'Выполнить тест'");
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДействиеОжиданияВыполненияТеста) Тогда
		Сообщить("Укажите действие 'Ожидание выполнения теста'");
		Отказ = Истина;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(ДействиеЗагрузкиЛога) Тогда
		Сообщить("Укажите действие 'Загрузка лога'");
		Отказ = Истина;
	КонецЕсли;
	
	// загрузка и удаление данных
	Если НЕ ЗначениеЗаполнено(ДействиеОжиданияВыполненияЗагрузкиДанных) Тогда
		Сообщить("Укажите действие 'Ожидание выполнения (загрузка данных)'");
		Отказ = Истина;
	КонецЕсли;	

	Если НЕ ЗначениеЗаполнено(ДействиеОжиданияВыполненияУдаленияДанных) Тогда
		Сообщить("Укажите действие 'Ожидание выполнения (удаление данных)'");
		Отказ = Истина;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(ДействиеВыполнитьТестЗагрузкиДанных) Тогда
		Сообщить("Укажите действие 'выполнение загрузки данных'");
		Отказ = Истина;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(ДействиеВыполнитьТестУдалениеДанных) Тогда
		Сообщить("Укажите действие 'выполнение удаления данных'");
		Отказ = Истина;
	КонецЕсли;	
	
	Возврат НЕ Отказ;
	
КонецФункции

&НаСервере
Процедура ПолучитьСоставПоЗаданию()
	
	Запрос = новый Запрос;
	ЗАпрос.Текст = "ВЫБРАТЬ
	|	СоставЗаданий.Действие  как Ссылка
	|ИЗ
	|	РегистрСведений.СоставЗаданий КАК СоставЗаданий
	|ГДЕ
	|	СоставЗаданий.Задание = &Задание
	|
	|УПОРЯДОЧИТЬ ПО
	|	СоставЗаданий.ПорядокВыполнения";
	Запрос.УстановитьПараметр("Задание",Задание);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ДействиеВыполнитьТестЗагрузкиДанных = Выборка.Ссылка;
	КонецЕсли;	

	Если Выборка.Следующий() Тогда
		ДействиеОжиданияВыполненияЗагрузкиДанных = Выборка.Ссылка;
	КонецЕсли;	
	
	Если Выборка.Следующий() Тогда
		ДействиеВыполнитьТест = Выборка.Ссылка;
	КонецЕсли;	
	
	Если Выборка.Следующий() Тогда
		ДействиеОжиданияВыполненияТеста = Выборка.Ссылка;
	КонецЕсли;
	
	Если Выборка.Количество()>7 И Выборка.Следующий() Тогда
		ДействиеЗакрытьПриложение = Выборка.Ссылка;
	КонецЕсли;	
	
	Если Выборка.Следующий() Тогда
		ДействиеЗагрузкиЛога = Выборка.Ссылка;
	КонецЕсли;
	
	Если Выборка.Следующий() Тогда
		ДействиеВыполнитьТестУдалениеДанных = Выборка.Ссылка;
	КонецЕсли;	

	Если Выборка.Следующий() Тогда
		ДействиеОжиданияВыполненияУдаленияДанных = Выборка.Ссылка;
	КонецЕсли;	
	
	
	
КонецПроцедуры

&НаКлиенте
Функция СформироватьОписаниеСоздаваемогоЗдания()
	
	Html = "<html><head></head><body>";
	Html = Html + "<h3>Свойства задания</h3>";
	Html = Html + "<b>Наименование:</b>  <span color='blue'>"+Наименование+"</span></br>";
	Html = Html + "<b>Идентификатор задания:</b> <span color='blue'>"+TaskID+"</span></br>";
	Html = Html + "<b>Тест:</b> <span color='blue'>"+Тест+"</span></br>";
	Html = Html + "Ответственный: "+?(ЗначениеЗаполнено(Ответственный),Ответственный,"---")+"</br>";
	Html = Html + "Родитель: "+?(ЗначениеЗаполнено(Родитель),Родитель,"---")+"</br>";
	Html = Html + "ГруппаЗадания: "+?(ЗначениеЗаполнено(ГруппаЗадания),ГруппаЗадания,"---")+"</br>";
	Html = Html + "<h4>Структура действий (загрузка данных)</h4>";
	Html = Html + "<b>Действие запуска (загрузка данных):</b> <span color='blue'>"+ДействиеВыполнитьТестЗагрузкиДанных+"</span></br>";
	Html = Html + "<b>Действие ожидания (загрузка данных):</b> <span color='blue'>"+ДействиеОжиданияВыполненияЗагрузкиДанных+"</span></br>";
	Html = Html + "<h4>Структура действий (выполнение теста)</h4>";
	Html = Html + "<b>Действие запуска выполнения теста:</b> <span color='blue'>"+ДействиеВыполнитьТест+"</span></br>";
	Html = Html + "<b>Действие ожидания выполнения теста:</b> <span color='blue'>"+ДействиеОжиданияВыполненияТеста+"</span></br>";
	Html = Html + "<b>Действие загрузки лога:</b> <span color='blue'>"+ДействиеЗагрузкиЛога+"</b></br>";
	Html = Html + "Действие закрытия приложения: "+ДействиеЗакрытьПриложение+"</br>";
	Html = Html + "<h4>Структура действий (удаление данных)</h4>";
	Html = Html + "<b>Действие запуска (удаление данных):</b> <span color='blue'>"+ДействиеВыполнитьТестУдалениеДанных+"</span></br>";
	Html = Html + "<b>Действие ожидания (удаление данных):</b> <span color='blue'>"+ДействиеОжиданияВыполненияУдаленияДанных+"</span></br>";
	Html = Html + "<h4>Дополнительно</h4>";
	Html = Html + "<b>Порт тестирования:</b> <span color='blue'>"+ПортТестирования+"</span></br>";
	Html = Html+"</body></html>";
	
	Возврат Html;
	
КонецФункции

&НаКлиенте
Процедура МенеджерТестированияКонфигурацияТестированиеПриИзменении(Элемент)
	Элементы.ГруппаМенеджерТестирования.Видимость = НЕ МенеджерТестированияКонфигурацияТестирование;
КонецПроцедуры

&НаСервере
Процедура ТестПриИзмененииСервер()
	
	Если ЗначениеЗаполнено(Тест) Тогда
		ЭтоСценарныйТест = (Тест.ТипТеста=Перечисления.ТипыТестов.СценарныйТест);
		Элементы.ГруппаЕслиСценарныйТест.Видимость = ЭтоСценарныйТест;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТестПриИзменении(Элемент)
	ТестПриИзмененииСервер();	
КонецПроцедуры

&НаКлиенте
Процедура НеИспользоватьСсылкуНаТестПриИзменении(Элемент)
	Элементы.ГруппаСвойстваТеста.Видимость = НЕ НеИспользоватьСсылкуНаТест;
КонецПроцедуры

&НаКлиенте
Процедура ТестируемыйКлиентПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ТестируемыйКлиент) Тогда
		Элементы.ДекорацияПредупрежедениеТестируемыйКлиент.Видимость = Ложь;
	Иначе
		Элементы.ДекорацияПредупрежедениеТестируемыйКлиент.Видимость = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МенеджерТестированияПриИзменении(Элемент)
	Если ЗначениеЗаполнено(МенеджерТестирования) Тогда
		Элементы.ДекорацияПредупрежедениеМенеджерТестирования.Видимость = Ложь;
	Иначе
		Элементы.ДекорацияПредупрежедениеМенеджерТестирования.Видимость = Истина;
	КонецЕсли;
КонецПроцедуры
