
&НаКлиенте
Процедура ОК(Команда)
	ВыполнитьФоновоеЗадание();
КонецПроцедуры

&НаСервере
Процедура ВыполнитьФоновоеЗадание()
	Попытка	
	    ФоновоеЗадание = ФоновыеЗадания.Выполнить(ИмяМетода,, Ключ, Наименование);
		Закрыть(ФоновоеЗадание.УникальныйИдентификатор);
	Исключение	
		Сообщить(ОписаниеОшибки(), СтатусСообщения.Внимание);
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаданиеИД = Параметры.ИдентификаторЗадания;
	ДанныйОбъект = РеквизитФормыВЗначение("ОбработкаОбъект");
	ФоновоеЗадание = ДанныйОбъект.ПолучитьОбъектФоновогоЗадания(ЗаданиеИД);
	Если ФоновоеЗадание <> Неопределено Тогда
		ИмяМетода = ФоновоеЗадание.ИмяМетода;
		Наименование = ФоновоеЗадание.Наименование;
		Ключ = ФоновоеЗадание.Ключ;
	Иначе
		//Ключ = Новый УникальныйИдентификатор;
	КонецЕсли;
КонецПроцедуры
