-- !!! Кодировка текста UTF-8
-- УСО 1. ПЛК А1.
-- таблица соответствия  дискретных выходов ПЛК и тегов (со свойствами).
-- ["A1_9.o1"] - описание выходного канала ( например: ПЛК А1_модуль в слоте 9.канал i1).
-- Tag - имя тега без указания источника (УСО, ПЛК и т.д.).
-- Comment - Текстовое описание тега. Применяется при формировании строки сообщений.
-- Txt_1 - текстовое описание сигнала, принявшего значение true.
-- Txt_0 - текстовое описание сигнала, принявшего значение false, если значение не требует описание - можно оставить пустым (например когда состояние объекта описавыется двумя сигналами).
-- InvFlag - признак инверсии сигнала. Когда принимает значение true - Txt_0 и Txt_1 меняются местами. Предусмотрен для сигналов, источник которых  - нормально закрытые контакты (НЗ). По умолчаниею ставить false (НО).
-- AlarmClass - класс сообщения. Может задаваться буквами ("a", "e", "w") или числами. Описано в таблице event. При отключении сообщения в строке событий принимает значение 0 ("disabled").
-- AlarmMsg -- текст тревожного сообщения в строке событий. Применимо для аварийных и предупредительных событий.
-- reliabilityFlag - признак достоверности сигнала. Не заполнять. По умолчанию принимает значение  true.
-- repaireFlag - признак вывода сигнала из опроса. Используется при выводе оборудования в ремонт. Не заполнять. По умолчанию принимает значение false.
--  relatedTag не используется (персппектива)
-- Fix_Con - признак типа выходного сигнала (импульсный/постоянная фиксация)

local DO_Signals=  -- таблица соответствия дискретных выходов тэгам - привязка тэгов и их свойств к конкретному каналу ПЛК в формате "ПЛК_Слот.Канал
	{
		-- адрес           тэг             оисание						состояние    состояние         инверсия       команда      тескст сообщения достоверность		ремонт			фиксация контакта после срабатывания
 		["A1_9.o1"]={Tag="Q1_2On", Comment="Выключатель Q1", Txt_1 =" включить", Txt_0="отключить", InvFlag=false, AlarmClass=100, AlarmMsg="", reliabilityFlag=true,repaireFlag=false, Fix_Con=false, Source="КТП №1. Выключатель Q1",},
	--	["A1_1.o2"]={Tag="Q1_OFF", Comment="Выключатель Q1", Txt_1=" отключен", Txt_0="", InvFlag=false, AlarmClass=10000, AlarmMsg="AlarmA_2!", reliabilityFlag=false,repaireFlag, relatedTag="Q1_ON",},
--		["A1_1.o3"]={Tag="Q1_Avar_OFF", Comment="", Txt_1="", Txt_0="", InvFlag=false, AlarmClass="w", AlarmMsg="", repaireFlag="",reliabilityTag="",  relatedTag="Q1_ON",},
	
} --DO_Signals

return DO_Signals;