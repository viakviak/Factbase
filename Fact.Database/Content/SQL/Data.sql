PRINT '------------------------------------- Essential Facts And Basic Attributes';
exec dbo.p_Fact_Import 2, 1, N'Columns: Name, Title, Description, Fact Attribute Collection, Base Attribute Name List, Uid
syAdmin	//Fact #1
// Essential Facts: Languages
syEnglish	//Fact #2
syRussian	//Fact #3
// Essential Attributes
syAttribute	Attribute	Category, Label		syAttribute
syPhrase	Phrase	Textual information on one or several languages		syAttribute
syLanguage	Language			syPhrase
syUser	User			syPhrase
syValue	Value	Actual value stored in Fact-Attribute		syAttribute
syNumber	Number			syValue
syQuantity	Quantity			syNumber
syUom	Unit of Measure			syAttribute
// Essential Facts: Details
syEnglish	English	English language	syLanguage
syRussian	Russian	Russian language	syLanguage
syAdmin	Administrator	Domain administrator	syUser
// Core Data Formats
syDataFormat	Data Format			syAttribute
syArray	Array	Array of fixed size elements		syDataFormat
syList	List	List of comma-separated values		syDataFormat
syCollection	Collection	Text Collection of pipe-enclosed values		syDataFormat
syJson	Json	Json data format		syDataFormat, syPhrase
// Core Attributes
syBoolean	Boolean	Yes/No. The mere existence of the Fact Attribute		syValue
syText	Text	Textual Information		syValue
syInteger	Integer	Simple Number		syNumber
syOption	Options	Optional data in JSON format		syJson
syIntegerOption	Numeric Option			syInteger, syOption
syTextOption	Text Option	Textual Information		syText, syOption
syPhraseOption	Phrase Option	Language-specific Textual Information		syPhrase, syOption
syCentury	Century			syInteger
syAmount	Amount	Amount of money		syValue
syDayOfWeek	Day of Week			syIntegerOption{display: "|Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday", values: "|0|1|2|3|4|5|6"}
syFactSet	Fact Set	Group of ordered facts		syAttribute
syFile	File	Uploaded file		syAttribute
syGeoPoint	Geo Point	Geographical Point, including comma-delimited latitude and longitude numbers.		syAttribute
syMonth	Month Number			syIntegerOption{display: "|January|February|March|April|May|June|July|August|September|November|December", values: "|1|2|3|4|5|6|7|8|9|10|11|12"}
syRealNumber	Real Number	Math number		syNumber
sySeason	Season	Season of a year		syIntegerOption {display: "|Winter|Spring|Summer|Autumn", values: "|1|2|3|4"}
syTime	Time	Date/time value		syValue
syTimeAge	Geological Age			syUom
syTimeDescription	Time Description			syPhrase, syValue
syTimePhrase	Time Phrase			syPhrase, syValue
syUid	Uid	Auto-generated Globally Unique Identifier		syValue
syYear	Year			syInteger
// Data Formats
syIdArray	Id Array	Array of ids		syArray,syInteger
syUidArray	Uid Array	Array of uids		syArray,syUid
syNameList	Name List	Comma-separated list of fact names		syList,syText
syKeyList	Key List	Comma-separated list of fact keys ("names" (default), [ids], or {uids})		syList,syText
syNameCollection	Name Collection	Pipe-enclosed list of names		syCollection,syText
syPhraseCollection	Phrase Collection	Pipe-enclosed list of phrase translations		syCollection,syPhrase
syFactAttributeCollection	Fact-Attribute Collection	Collection of names with optional values and types, delimited by colon		syNameCollection
syXml	Xml	Xml data format		syDataFormat,syPhrase
// Basic Attributes
Gravity	Gravity			syAttribute
Mass	Mass			Gravity,syRealNumber
Weight	Weight			Mass
syAlias	Alias	Another assumed identity		syAttribute
// Basic Physical Attributes
Color	Color			syAttribute
Direction	Direction	Guidence instructions		syAttribute
syMagnitude	Magnitude			syRealNumber
Angle	Angle			syMagnitude
Length	Length			syMagnitude
Depth	Depth			syMagnitude
Distance	Distance			syMagnitude
Size	Size			syMagnitude
Width	Width			syMagnitude
syCoordinate	Coordinate			syMagnitude
syX-Coordinate	X Coordinate	One of the axis of a coordinate system		syCoordinate
syY-Coordinate	Y Coordinate	One of the axis of a coordinate system		syCoordinate
syZ-Coordinate	Z Coordinate	One of the axis of a coordinate system		syCoordinate
syPoint	Point	Set of coordinates		syFactSet,syCoordinate
syPoint2D	2D Point	2D Point	|syX-Coordinate|syY-Coordinate|	syPoint
syPoint3D	3D Point	3D Point	|syX-Coordinate|syY-Coordinate|syZ-Coordinate|	syPoint
Area	Area			syMagnitude
Volume	Volume			Area
Density	Density	Mass of a unit of volume		syMagnitude
Vector	Vector		|Direction|syMagnitude|	FactSet
Force	Force			Vector
Energy	Energy			syMagnitude
Pressure	Pressure			syMagnitude
Temperature	Temperature			syMagnitude
// Units of Measure
each	Each			syUom,syQuantity
Currency	Currency			syUom
USD	US Dollar	US Currency		Currency
RUB	Ruble	Russian Currency		Currency
EUR	Euro	European Union Currency		Currency
m	Meter			syUom,Length
mm	Millimeter	One thousandth of a meter		m
km	Kilometer	Thousand meters		m
gm	Gram			syUom,Weight
kg	Kilogram	Thousand gramms		gm
ton	Ton	Thousand kilograms		kg
megaton	Megaton	Million tons		ton
sec	Second			syUom, Length
min	Minute	60 seconds		sec
hour	Hour	60 minutes		min
day	Day	24 hours		hour
// Geographical Attributes
Geo	Geography	Geographical term		syAttribute
GeoArea	Geo Area	Geographical Area		Geo,Area
World	World			Geo
Land	Land			Geo
Water	Water			Geo
Lake	Lake			Water,GeoArea
Sea	Sea			Water,GeoArea
Region	Region			Land,GeoArea
Continent	Continent			Land,GeoArea
Landmark	Landmark			Land,syGeoPoint
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
exec dbo.p_Fact_Import 3, 1, N'Поля: Имя, Титул, Описание, Аттрибуты фактов, Базовые атрибуты, ГУН
// Основные Факты
syAdmin	Администратор	Администратор домена
syEnglish	Английский	Английский язык
syRussian	Русский	Русский язык
// Основные Атрибуты
syAttribute	Атрибут	Категория, Метка
syBoolean	Флаг	Да/Нет. Само существование записи Факта-Атрибута
syText	Текст	Текстовая информация
syInteger	Целое Число
syOption	Дополнение	Дополнительные данные в формате JSON
syIntegerOption	Числовой выбор	Варианты чисел, включая диапазоны.
syTextOption	Текстовый выбор	Текстовые варианты
syCentury	Век	
syAmount	Деньги
syDayOfWeek	День Недели			syIntegerOption{display: "|Понедельник|Вторник|Среда|Четверг|Пятница|Суббота|Воскресенье", values: "|1|2|3|4|5|6|0"}
syFactSet	Факт-Группа	Отсортированная группа Фактов
syFile	Файл	Загруженный файл
syGeoPoint	Гео Точка	широта и долгота
syLanguage	Язык
syMonth	Месяц			syIntegerOption {display: "|Январь|Февраль|Март|Апрель|Май|Июнь|Июль|Август|Сентябрь|Октябрь|Ноябрь|Декабрь", values: "|1|2|3|4|5|6|7|8|9|10|11|12"}
syPhrase	Фраза	Текстовая информация на одном или нескольких языках
syRealNumber	Реальное число	математическое число
sySeason	Сезон	Время Года		syIntegerOption {display: "|Зима|Весна|Лето|Осень", values: "|1|2|3|4"}
syTime	Время	Точное время
syTimeAge	Эпоха
syTimeDescription	Время (описание)	Описание времени
syTimePhrase	Время (текст)	Текстовое представление времени
syUid	ГУН	Автоматически генерируемый глобально уникальный номер
syUser	Пользователь
syYear	Год
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
