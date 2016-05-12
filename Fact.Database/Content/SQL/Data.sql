PRINT '------------------------------------- Essential Facts: Domain Admin - creator of system data';
exec dbo.p_Fact_Import NULL, 1, N'Columns: Name, Fact Attributes, Title, Description, Uid
Admin
';
PRINT '------------------------------------- Essential Facts: Languages';
exec dbo.p_Fact_Import NULL, 1, N'Columns: Name, Fact Attributes, Title, Description, Uid
English
Russian
', 1;
PRINT '------------------------------------- Essential Attributes';
exec dbo.p_Attribute_Import 2, 1, N'Columns: Name, Base Names, Title, Description, OptionDisplay, OptionValues, Uid
Phrase		Phrase	Textual information on one or several languages
Language	Phrase	Language
User	Phrase	User
', 1;
PRINT '------------------------------------- Essential Facts: Details (English)';
exec dbo.p_Fact_Import 2, 1, N'Columns: Name, Fact Attributes, Title, Description, Uid
English	Language	English	English Language
Russian	Language	Russian	Russian Language
Admin	User	Administrator	Domain Administrator
', 1;
PRINT '------------------------------------- Essential Facts: Details (Russian)';
exec dbo.p_Fact_Import 3, 1, N'Columns: Имя, Аттрибуты фактов, Титул, Описание, ГУН
English		Английский	Английский язык
Russian		Русский	Русский язык
Admin		Администратор	Администратор домена
', 1;
PRINT '------------------------------------- Basic Attributes (English)';
exec dbo.p_Attribute_Import 2, 1, N'Columns: Name, Base Names, Title, Description, OptionDisplay, OptionValues, Uid
Boolean		Boolean	Yes/No. The mere existence of the Fact Attribute
Text		Text	Textual Information
Integer		Integer	Simple Number
IntegerOption	Integer	Numeric Option
Century	Integer	Century
Currency		Currency
DayOfWeek	IntegerOption	Day of Week
FactSet		Fact Set	Group of ordered facts
File		File	Uploaded file
GeoPoint		Geo Point	Geographical Point, including comma-delimited latitude and longitude numbers.
MonthNumber	IntegerOption	Month Number
Real		Real Number	Math number
Season	Phrase	Season	Season of a year
Time		Time	Date/time value
TimeAge		Geological Age
Uid		Uid	Auto-generated Globally Unique Identifier
Year	Integer	Year
', 1;
PRINT '------------------------------------- Basic Attributes (Russian)';
exec dbo.p_Attribute_Import 3, 1, N'Колонки: Имя, Базовые атрибуты, Титул, Описание, Титулы вариантов, Значения вариантов, ГУН
Boolean		Флаг	Да/Нет. Само существование записи Факта-Атрибута
Text		Текст	Текстовая информация
Integer		Целое Число
Century		Век	
Currency		Деньги
IntegerOption	Integer	Числовой выбор	Варианты чисел, включая диапазоны.
DayOfWeek		День Недели
FactSet		Факт-Группа	Отсортированная группа Фактов
File		Файл	Загруженный файл
GeoPoint		Гео Точка	широта и долгота
Language		Язык
MonthNumber		Номер месяца
Phrase		Фраза	Текстовая информация на одном или нескольких языках
Real		Реальное число	математическое число
Season		Время Года
Time		Время	точное время
TimeAge		Эпоха
Uid		ГУН	Автоматически генерируемый глобально уникальный номер
User		Пользователь
Year		Год
', 1;

PRINT '------------------------------------- Geographical Attributes';
exec dbo.p_Attribute_Import 2, 1, N'Columns: Name, Base Names, Title, Description, OptionDisplay, OptionValues, Uid
Geo		Geography	Geographical term
Area	Geo	Area	Geographical Area
World	Geo	World
Land	Geo	Land
Water	Geo	Water
Lake	Water,Area	Lake
Sea	Water,Area	Sea
Region	Land,Area	Region
Continent	Land,Area	Continent
Landmark	Land,GeoPoint	Landmark
Headquarters	Landmark	Headquarters
House	Landmark	House
Path	Geo	Path
Road	Land,Path	Road
Railroad	Road	Railroad
Border	Land,Path	Border	Land Border
River	Water,Path	River
Channel	Water,Path	Channel
Strait	Water,Path	Strait
Settlement	Land,Area	Settlement
District	Land,Area	District
Village	Land,Area	Village
City	Settlement	City
Capital	City	Capital
State	Area	State
Country	Area	Country
', 1;

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
		
SELECT	DISTINCT a.AttributeID, a.[Name] as AttrName, aTitle.ValueTranslation as AttrTitle,
		ap.[Path] as AttrPath, ap.ValueType, aDescription.ValueTranslation as AttrDescription, a.CreatorID
FROM	dbo.Attribute a INNER JOIN
		dbo.Translation aTitle ON a.TitlePhraseID = aTitle.PhraseID LEFT OUTER JOIN
		dbo.Translation aDescription ON a.DescriptionPhraseID = aDescription.PhraseID AND aTitle.LanguageID = aDescription.LanguageID LEFT OUTER JOIN
		dbo.AttributePath ap ON a.AttributeID = ap.AttributeID
ORDER BY a.AttributeID, a.[Name];
