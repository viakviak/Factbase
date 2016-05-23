PRINT '------------------------------------- Essential Facts And Basic Attributes';
exec dbo.p_Fact_Import 2, 1, N'Columns: Name, Title, Description, Fact Attributes, Base Attributes, Uid
Admin	//Fact #1
// Essential Facts: Languages
English	//Fact #2
Russian	//Fact #3
// Essential Attributes
Attribute	Attribute	Category, Label		Attribute
Phrase	Phrase	Textual information on one or several languages		Attribute
Language	Language			Phrase
User	User			Phrase
sysValue	Value	Actual value stored in Fact-Attribute		Attribute
Number	Number			sysValue
Quantity	Quantity			Number
Uom	Unit of Measure			Attribute
// Essential Facts: Details
English	English	English language	Language
Russian	Russian	Russian language	Language
Admin	Administrator	Domain administrator	User
// Data Formats
DataFormat	Data Format			Attribute
Array	Array	Array of fixed size elements		DataFormat
List	List	List of comma-separated values		DataFormat
Collection	Collection	Text Collection of pipe-enclosed values		DataFormat
IdArray	Id Array	Array of ids		Array,Integer
UidArray	Uid Array	Array of uids		Array,Uid
NameList	Name List	Comma-separated list of fact names		List,Text
KeyList	Key List	Comma-separated list of fact keys (names, ids, or uids)		List,Text
NameCollection	Name List	Pipe-enclosed list of names		Collection,Text
Xml	Xml	Xml data format		DataFormat,Phrase
Json	Json	Json data format		DataFormat, Phrase
// Core Attributes
Boolean	Boolean	Yes/No. The mere existence of the Fact Attribute		sysValue
Text	Text	Textual Information		sysValue
Integer	Integer	Simple Number		Number
Option	Options	Optional data in JSON format		Json
IntegerOption	Numeric Option			Integer, Option
TextOption	Text Option	Textual Information		Text, Option
Century	Century			Integer
Amount	Amount	Amount of money		sysValue
DayOfWeek	Day of Week			IntegerOption{display: "|Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday", values: "|0|1|2|3|4|5|6"}
FactSet	Fact Set	Group of ordered facts		Attribute
File	File	Uploaded file		Attribute
GeoPoint	Geo Point	Geographical Point, including comma-delimited latitude and longitude numbers.		Attribute
Month	Month Number			IntegerOption{display: "|January|February|March|April|May|June|July|August|September|November|December", values: "|1|2|3|4|5|6|7|8|9|10|11|12"}
RealNumber	Real Number	Math number		Number
Season	Season	Season of a year		IntegerOption {display: "|Winter|Spring|Summer|Autumn", values: "|1|2|3|4"}
Time	Time	Date/time value		sysValue
TimeAge	Geological Age			Uom
TimeDescription	Time Description			Phrase
TimePhrase	Time Phrase			Phrase
Uid	Uid	Auto-generated Globally Unique Identifier		Attribute
Year	Year			Integer
// Basic Attributes
Gravity	Gravity			Number
Mass	Mass			Gravity,Number
Weight	Weight			Mass
// Basic Physical Attributes
Color	Color			Attribute
Direction	Direction			Attribute
Angle	Angle			Number
Length	Length			Number
Depth	Depth			Length
Distance	Distance			Length
Size	Size			Length
Width	Width			Length
Area	Area			Length
Volume	Volume			Area
Density	Density	Mass of a unit of volume		Number
Vector	Vector			Direction,Number
Force	Force			Vector
Energy	Energy			Force,Distance
Pressure	Pressure			Number
Temperature	Temperature			Number
// Units of Measure
each	Each			Uom,Quantity
Currency	Currency			Uom
USD	US Dollar	US Currency		Currency
RUB	Ruble	Russian Currency		Currency
EUR	Euro	European Union Currency		Currency
m	Meter			Uom,Number
mm	Millimeter	One thousandth of a meter		m
km	Kilometer	Thousand meters		m
gm	Gram			Uom,Weight
kg	Kilogram	Thousand gramms		gm
ton	Ton	Thousand kilograms		kg
megaton	Megaton	Million tons		ton
sec	Second			Uom, Number
min	Minute	60 seconds		sec
hour	Hour	60 minutes		min
day	Day	24 hours		hour
// Geographical Attributes
Geo	Geography	Geographical term		Attribute
GeoArea	Geo Area	Geographical Area		Geo,Area
World	World			Geo
Land	Land			Geo
Water	Water			Geo
Lake	Lake			Water,GeoArea
Sea	Sea			Water,GeoArea
Region	Region			Land,GeoArea
Continent	Continent			Land,GeoArea
Landmark	Landmark			Land,GeoPoint
Headquarters	Headquarters			Landmark
House	House			Landmark
Path	Path			Geo
Road	Road			Land,Path
Railroad	Railroad			Road
Border	Border	Land Border		Land,Path
River	River			Water,Path
Channel	Channel			Water,Path
Strait	Strait			Water,Path
Settlement	Settlement			Land,GeoArea
District	District			Land,GeoArea
Village	Village			Land,GeoArea
City	City			Settlement
Capital	Capital			City
State	State			GeoArea
Country	Country			GeoArea
', 1;

PRINT '------------------------------------- Основные Факты и Атрибуты';
exec dbo.p_Fact_Import 3, 1, N'Columns: Имя, Титул, Описание, Аттрибуты фактов, Базовые атрибуты, ГУН
// Основные Факты
Admin	Администратор	Администратор домена
English	Английский	Английский язык
Russian	Русский	Русский язык
// Основные Атрибуты
Attribute	Атрибут	Категория, Метка
Boolean	Флаг	Да/Нет. Само существование записи Факта-Атрибута
Text	Текст	Текстовая информация
Integer	Целое Число
Option	Дополнение	Дополнительные данные в формате JSON
IntegerOption	Числовой выбор	Варианты чисел, включая диапазоны.
TextOption	Текстовый выбор	Текстовые варианты
Century	Век	
Amount	Деньги
DayOfWeek	День Недели			IntegerOption{display: "|Понедельник|Вторник|Среда|Четверг|Пятница|Суббота|Воскресенье", values: "|1|2|3|4|5|6|0"}
FactSet	Факт-Группа	Отсортированная группа Фактов
File	Файл	Загруженный файл
GeoPoint	Гео Точка	широта и долгота
Language	Язык
Month	Месяц			IntegerOption {display: "|Январь|Февраль|Март|Апрель|Май|Июнь|Июль|Август|Сентябрь|Октябрь|Ноябрь|Декабрь", values: "|1|2|3|4|5|6|7|8|9|10|11|12"}
Phrase	Фраза	Текстовая информация на одном или нескольких языках
RealNumber	Реальное число	математическое число
Season	Сезон	Время Года		IntegerOption {display: "|Зима|Весна|Лето|Осень", values: "|1|2|3|4"}
Time	Время	Точное время
TimeAge	Эпоха
TimeDescription	Время (описание)	Описание времени
TimePhrase	Время (текст)	Текстовое представление времени
Uid	ГУН	Автоматически генерируемый глобально уникальный номер
User	Пользователь
Year	Год
// Географические Атрибуты
Geo	Гео	География
GeoArea	Площадь	Географическая площадь
World	Мир	Земной шар
Land	Суша	Земля
Water	Вода
Lake	Озеро
Sea	Море
Region	Регион	Область
Continent	Континент
Landmark	Ориентир	Географический знак
Headquarters	Центр	Главное управление
House	Дом
Path	Путь
Road	Дорога
Railroad	Железная дорога
Border	Граница
River	Река
Channel	Канал
Strait	Пролив
Settlement	Поселение	Населенный пункт
District	Район	Участок, зона
Village	Деревня	Поселок, городок	
City	City			Settlement
Capital	Столица
State	Штат	Государство
Country	Страна	Гоударство
', 1;

----- Attributes
SELECT	DISTINCT a.FactID as AttrID, a.[Name] as AttrName, aTitle.ValueTranslation as AttrTitle,
		ap.[Path] as AttrPath, ap.ValueType, aDescription.ValueTranslation as AttrDescription, a.CreatorID
FROM	dbo.Fact a INNER JOIN
		dbo.Translation aTitle ON a.TitlePhraseID = aTitle.PhraseID LEFT OUTER JOIN
		dbo.Translation aDescription ON a.DescriptionPhraseID = aDescription.PhraseID AND aTitle.LanguageID = aDescription.LanguageID LEFT OUTER JOIN
		dbo.AttributePath ap ON a.FactID = ap.AttributeID
WHERE	ap.[Path] IS NOT NULL
ORDER BY a.FactID, a.[Name];

----- Facts
SELECT	DISTINCT f.FactID as FactID, f.[Name] as FactName, fTitle.ValueTranslation as FactTitle, fTitle.LanguageID,
		fDescription.ValueTranslation as FactDescription, f.CreatorID, a.[Name] as AttrName,
		aTitle.ValueTranslation as AttrTitle, aDescription.ValueTranslation as AttrDescription,
		ap.ValueType, ap.[Path]
FROM	dbo.Fact f LEFT OUTER JOIN
		dbo.AttributePath fp ON f.FactID = fp.AttributeID LEFT OUTER JOIN
		dbo.Translation fTitle ON f.TitlePhraseID = fTitle.PhraseID LEFT OUTER JOIN
		dbo.Translation fDescription ON f.DescriptionPhraseID = fDescription.PhraseID AND fTitle.LanguageID = fDescription.LanguageID LEFT OUTER JOIN
		dbo.FactAttribute fa ON f.FactID = fa.FactID LEFT OUTER JOIN
		dbo.Fact a ON fa.AttributeID = a.FactID LEFT OUTER JOIN
		dbo.Translation aTitle ON a.TitlePhraseID = aTitle.PhraseID AND fTitle.LanguageID = aTitle.LanguageID LEFT OUTER JOIN
		dbo.Translation aDescription ON a.DescriptionPhraseID = aDescription.PhraseID AND fTitle.LanguageID = aDescription.LanguageID LEFT OUTER JOIN
		dbo.AttributePath ap ON a.FactID = ap.AttributeID
WHERE	fp.[Path] IS NULL
ORDER BY f.FactID, f.[Name];
