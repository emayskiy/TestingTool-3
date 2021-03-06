&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мОбъект = РеквизитФормыВЗначение("Объект");
	мОбъект.ДобавитьМеню(ЭтаФорма,"Logs");
	
	ЭтаФорма.КоманднаяПанель.Видимость = Ложь;
	ЭтаФорма.АвтоЗаголовок = Ложь;
	ЭтаФорма.Заголовок = "Logs";
	
	ЗаполнитьЗначенияСвойств(Объект,Параметры);
	
	СписокЛогиВыполненияЗаданий.Параметры.УстановитьЗначениеПараметра("Задание",Справочники.Задания.ПустаяСсылка());
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаМеню(Команда)
	ИмяКоманды = Команда.Имя;
	мПараметры = новый Структура();
	ОткрытьФорму("ВнешняяОбработка.JenkinsSkin.Форма."+ИмяКоманды,мПараметры,ЭтаФорма,ЭтаФорма.УникальныйИдентификатор,ЭтаФорма.Окно);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗагрузитьНастройкиПользователя();
	СформироватьОписаниеПанелей();
	
	СписокЛогиВыполненияЗаданий.Параметры.УстановитьЗначениеПараметра("Задание",ОтборЗадание);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьОписаниеПанелей()

	
КонецПроцедуры



&НаСервере
Процедура СохранитьНастройкиПользователя()
	
	мОбъект = РеквизитФормыВЗначение("Объект");
	мОбъект.СохранитьНастройкиПользователя(Объект);
	мОбъект.СохранитьНастройкиПользователя(Объект,"Задание",ОтборЗадание);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиПользователя()
	
	мОбъект = РеквизитФормыВЗначение("Объект");
	мОбъект.ЗагрузитьНастройкиПользователя(Объект);
	ОтборЗадание = мОбъект.ЗагрузитьНастройкиПользователя(Объект,"Задание");
	
КонецПроцедуры

&НаКлиенте
Процедура Отбор_ЗаданиеПриИзменении(Элемент)
	СохранитьНастройкиПользователя();
	СписокЛогиВыполненияЗаданий.Параметры.УстановитьЗначениеПараметра("Задание",ОтборЗадание);
КонецПроцедуры


