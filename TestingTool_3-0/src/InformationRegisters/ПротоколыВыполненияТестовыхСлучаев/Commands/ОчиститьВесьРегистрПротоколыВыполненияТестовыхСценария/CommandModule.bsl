
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОбработкаКомандыСервер();
	
КонецПроцедуры



&НаСервере
Процедура ОбработкаКомандыСервер()
	
	НаборЗаписей = РегистрыСведений.ПротоколыВыполненияТестовыхСлучаев.СоздатьНаборЗаписей();
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры
