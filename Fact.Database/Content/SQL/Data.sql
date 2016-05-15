PRINT '------------------------------------- Essential Facts: Domain Admin - creator of system data';
exec dbo.p_Fact_Import NULL, 1, N'Columns: Name, Title, Description, Fact Attributes, Base Attributes, Uid
Admin
';
PRINT '------------------------------------- Essential Facts: Languages';
exec dbo.p_Fact_Import NULL, 1, N'Columns: Name, Title, Description, Fact Attributes, Base Attributes, Uid
English
Russian
', 1;
PRINT '------------------------------------- Essential Attributes';
exec dbo.p_Fact_Import 2, 1, N'Columns: Name, Title, Description, Fact Attributes, Base Attributes, Uid
Attribute	Attribute	Category, Label		Attribute
Phrase	Phrase	Textual information on one or several languages		Attribute
Language	Language			Phrase
User	User			Phrase
', 1;
PRINT '------------------------------------- Essential Facts: Details (English)';
exec dbo.p_Fact_Import 2, 1, N'Columns: Name, Title, Description, Fact Attributes, Base Attributes, Uid
English	English	English language	Language
Russian	Russian	Russian language	Language
Admin	Administrator	Domain administrator	User
', 1;
PRINT '------------------------------------- Essential Facts: Details (Russian)';
exec dbo.p_Fact_Import 3, 1, N'Columns: Имя, Титул, Описание, Аттрибуты фактов, Базовые аттрибуты, ГУН
English	Английский	Английский язык
Russian	Русский	Русский язык
Admin	Администратор	Администратор домена
', 1;

PRINT '------------------------------------- Basic Attributes (English)';
exec dbo.p_Fact_Import 2, 1, N'Columns: Name, Title, Description, Fact Attributes, Base Attributes, Uid
Boolean	Boolean	Yes/No. The mere existence of the Fact Attribute		Attribute
Text	Text	Textual Information		Attribute
Integer	Integer	Simple Number		Attribute
IntegerOption	Numeric Option			Integer
Century	Century			Integer
Currency	Currency			Attribute
DayOfWeek	Day of Week			IntegerOption{display: "|Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday", values: "|0|1|2|3|4|5|6"}
FactSet	Fact Set	Group of ordered facts		Attribute
File	File	Uploaded file		Attribute
GeoPoint	Geo Point	Geographical Point, including comma-delimited latitude and longitude numbers.		Attribute
MonthNumber	Month Number			IntegerOption
Real	Real Number	Math number		Attribute
Season	Season	Season of a year		IntegerOption {display: "|Winter|Spring|Summer|Autumn", values: "|1|2|3|4"}
Time	Time	Date/time value		Attribute
TimeAge	Geological Age			Attribute
Uid	Uid	Auto-generated Globally Unique Identifier		Attribute
Year	Year			Integer
', 1;
PRINT '------------------------------------- Basic Attributes (Russian)';
exec dbo.p_Fact_Import 3, 1, N'Колонки: Имя, Титул, Описание, Аттрибуты фактов, Базовые аттрибуты, ГУН
Attribute	Атрибут	Категория, Метка
Boolean	Флаг	Да/Нет. Само существование записи Факта-Атрибута
Text	Текст	Текстовая информация
Integer	Целое Число
Century	Век	
Currency	Деньги
IntegerOption	Числовой выбор	Варианты чисел, включая диапазоны.
DayOfWeek	День Недели			IntegerOption{display: "|Понедельник|Вторник|Среда|Четверг|Пятница|Суббота|Воскресенье", values: "|1|2|3|4|5|6|0"}
FactSet	Факт-Группа	Отсортированная группа Фактов
File	Файл	Загруженный файл
GeoPoint	Гео Точка	широта и долгота
Language	Язык
MonthNumber	Номер месяца
Phrase	Фраза	Текстовая информация на одном или нескольких языках
Real	Реальное число	математическое число
Season	Сезон	Время Года		IntegerOption {display: "|Зима|Весна|Лето|Осень", values: "|1|2|3|4"}
Time	Время	Точное время
TimeAge	Эпоха
Uid	ГУН	Автоматически генерируемый глобально уникальный номер
User	Пользователь
Year	Год
', 1;
PRINT '------------------------------------- Geographical Attributes';
exec dbo.p_Fact_Import 2, 1, N'Columns: Name, Title, Description, Fact Attributes, Base Attributes, Uid
Geo	Geography	Geographical term		Attribute
Area	Area	Geographical Area		Geo
World	World			Geo
Land	Land			Geo
Water	Water			Geo
Lake	Lake			Water,Area
Sea	Sea			Water,Area
Region	Region			Land,Area
Continent	Continent			Land,Area
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
Settlement	Settlement			Land,Area
District	District			Land,Area
Village	Village			Land,Area
City	City			Settlement
Capital	Capital			City
State	State			Area
Country	Country			Area
', 1;
PRINT '------------------------------------- Geographical Attributes (Russian)';
exec dbo.p_Fact_Import 3, 1, N'Колонки: Имя, Титул, Описание, Аттрибуты фактов, Базовые аттрибуты, ГУН
Geo	Гео	Геогафия
Area	Площадь	Географическая площадь
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
--WHERE	ap.[Path] IS NOT NULL
ORDER BY a.FactID, a.[Name];

/*

SELECT	DISTINCT f.FactID, fTitle.LanguageID, f.[Name] as FactName, fTitle.ValueTranslation as FactTitle,
		fDescription.ValueTranslation as FactDescription, a.[Name] as AttrName,
		 aTitle.ValueTranslation as AttrTitle, aDescription.ValueTranslation as AttrDescription,
		 [Path] as AttrPath, ap.ValueType as AttrValueType, f.CreatorID
FROM	dbo.Fact f LEFT OUTER JOIN
		dbo.FactAttribute fa ON f.FactID = fa.FactAttributeID LEFT OUTER JOIN
		dbo.Attribute a ON fa.AttributeID = a.AttributeID LEFT OUTER JOIN
		dbo.AttributePath ap ON a.AttributeID = ap.AttributeID LEFT OUTER JOIN
		dbo.Translation fTitle ON f.TitlePhraseID = fTitle.PhraseID LEFT OUTER JOIN
		dbo.Translation fDescription ON f.DescriptionPhraseID = fDescription.PhraseID AND fTitle.LanguageID = fDescription.LanguageID LEFT OUTER JOIN
		dbo.Translation aTitle ON a.TitlePhraseID = aTitle.PhraseID AND fTitle.LanguageID = aTitle.LanguageID LEFT OUTER JOIN
		dbo.Translation aDescription ON a.DescriptionPhraseID = aDescription.PhraseID AND aTitle.LanguageID = aDescription.LanguageID 
ORDER BY f.FactID;
*/