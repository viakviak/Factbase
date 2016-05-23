-- FactData Programmability Cleanup

/****** Object:  UserDefinedFunction [dbo].[fn_MakePathItem]    Script Date: 4/27/2016 7:52:22 PM ******/
IF OBJECT_ID(N'fn_MakePathItem', N'FN') IS NOT NULL
	DROP FUNCTION [dbo].[fn_MakePathItem]
GO

/****** Object:  UserDefinedFunction dbo.fn_GetIntegerArrayCount    Script Date: 5/22/2016 7:54 PM ******/
IF OBJECT_ID(N'fn_GetIntegerArrayCount', N'FN') IS NOT NULL
	DROP FUNCTION dbo.fn_GetIntegerArrayCount
GO

/****** Object:  UserDefinedFunction dbo.fn_GetIntegerArrayItem    Script Date: 5/22/2016 7:58 PM ******/
IF OBJECT_ID(N'fn_GetIntegerArrayItem', N'FN') IS NOT NULL
	DROP FUNCTION dbo.fn_GetIntegerArrayItem
GO

/****** Object:  UserDefinedFunction [dbo].[fn_FindValueType]    Script Date: 5/2/2016 9:36 PM ******/
IF OBJECT_ID(N'fn_FindValueType', N'FN') IS NOT NULL
	DROP FUNCTION [dbo].[fn_FindValueType]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_FindFactID]    Script Date: 4/28/2016 7:34 PM ******/
IF OBJECT_ID(N'fn_FindFactID', N'FN') IS NOT NULL
	DROP FUNCTION [dbo].fn_FindFactID
GO

/****** Object:  UserDefinedFunction dbo.fn_GetAttributeValueTypes    Script Date: 5/20/2016 9:32 PM ******/
IF OBJECT_ID(N'fn_GetAttributeValueTypes', N'FN') IS NOT NULL
	DROP FUNCTION dbo.fn_GetAttributeValueTypes
GO

/****** Object:  StoredProcedure [dbo].p_ParseMoney    Script Date: 5/21/2016 8:20 PM ******/
IF OBJECT_ID(N'p_ParseMoney', N'P') IS NOT NULL
	DROP PROCEDURE [dbo].p_ParseMoney
GO

/****** Object:  StoredProcedure [dbo].[p_PhraseTranslation_Save]    Script Date: 5/1/2016 10:04 PM ******/
IF OBJECT_ID(N'p_PhraseTranslation_Save', N'P') IS NOT NULL
	DROP PROCEDURE [dbo].[p_PhraseTranslation_Save]
GO

/****** Object:  StoredProcedure [dbo].[p_AttributePath_Save]    Script Date: 4/29/2016 8:55 PM ******/
IF OBJECT_ID(N'p_AttributePath_Save', N'P') IS NOT NULL
	DROP PROCEDURE [dbo].[p_AttributePath_Save]
GO

/****** Object:  StoredProcedure [dbo].[p_FactAttribute_Modify]    Script Date: 5/1/2016 9:33 PM ******/
IF OBJECT_ID(N'p_FactAttribute_Modify', N'P') IS NOT NULL
	DROP PROCEDURE [dbo].[p_FactAttribute_Modify]
GO

/****** Object:  StoredProcedure [dbo].[p_FactAttribute_Save]    Script Date: 5/1/2016 9:33 PM ******/
IF OBJECT_ID(N'p_FactAttribute_Save', N'P') IS NOT NULL
	DROP PROCEDURE [dbo].[p_FactAttribute_Save]
GO

/****** Object:  StoredProcedure [dbo].[p_Fact_Save]    Script Date: 5/1/2016 8:46 PM ******/
IF OBJECT_ID(N'p_Fact_Save', N'P') IS NOT NULL
	DROP PROCEDURE [dbo].[p_Fact_Save]
GO

/****** Object:  StoredProcedure [dbo].[p_Fact_Import]    Script Date: 5/1/2016 2:39 PM ******/
IF OBJECT_ID(N'p_Fact_Import', N'P') IS NOT NULL
	DROP PROCEDURE [dbo].[p_Fact_Import]
GO

-- FactData Programmability

-- =============================================
-- Author:		ViakViak
-- Create date: 4/27/2016
-- Description:	Make Path Item From Integer ID
-- =============================================
CREATE FUNCTION [dbo].[fn_MakePathItem] 
(
	@id int
)
RETURNS varchar(10)
AS
BEGIN
	return FORMAT(@id, '|000000000');
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 5/2/2016
-- Description:	Get Array Size
-- =============================================
CREATE FUNCTION dbo.fn_GetIntegerArrayCount 
(
	@array varchar(max),
	@itemSize int
)
RETURNS int
AS
BEGIN
	if @array IS NULL
		return 0;
	return LEN(@array) / @itemSize;
END
GO


-- =============================================
-- Author:		ViakViak
-- Create date: 5/2/2016
-- Description:	Get Text Array Numeric Value (ID)
-- Remarks: returns negative value, if input is invalid
-- =============================================
CREATE FUNCTION dbo.fn_GetIntegerArrayItem 
(
	@itemIndex int, -- 0-based index
	@path varchar(max),
	@itemSize int
)
RETURNS int
AS
BEGIN
	DECLARE @count int;
	DECLARE @itemValue varchar(max);

	if @path IS NULL OR @itemSize <= 0
		return -1;
	SET @count = LEN(@path) / @itemSize;
	if @itemIndex < 0 OR @itemIndex >= @count
		return -2;
	SET @itemValue = SUBSTRING(@path, @itemIndex * @itemSize + 2, @itemSize - 1); -- without leading "|"
	return convert(int, @itemValue);
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 5/2/2016
-- Description:	Find Value Type
-- Remarks: Returns NULL, if not found
-- =============================================
CREATE FUNCTION dbo.fn_FindValueType
(
	@path varchar(max)
)
RETURNS nvarchar(2048)
AS
BEGIN
	DECLARE @valueTypeList varchar(512);
	DECLARE @itemIndex int;
	DECLARE @valueType nvarchar(2048);
	DECLARE @attributeID int;

	if @path IS NULL
		return NULL;
	SET @valueTypeList = '|Boolean|Century|Amount|DayOfWeek|FactSet|File|GeoPoint|Integer|Month|Phrase|RealNumber|Season|Text|Time|TimeAge|TimeDescription|TimePhrase|Uid|Year|';
	SET @itemIndex = dbo.fn_GetIntegerArrayCount(@path, 10) - 1; -- ubound
	WHILE @itemIndex >= 0
		begin -- going through items in reverse order
		SET @attributeID = dbo.fn_GetIntegerArrayItem(@itemIndex, @path, 10)

		SELECT TOP 1 @valueType = ValueType FROM dbo.AttributePath WHERE AttributeID = @attributeID ORDER BY AttributePathID;-- first existing
		if @valueType IS NULL -- calculated
			SELECT TOP 1 @valueType = [Name]
			FROM	dbo.Fact
			WHERE	FactID = @attributeID
			AND		0 < CHARINDEX('|' + [Name] + '|', @valueTypeList);

		if NOT @valueType IS NULL
			break;
		SET @itemIndex = @itemIndex - 1;
		end
	return @valueType;
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 4/28/2016
-- Description:	Find Attribute ID
-- Remarks: Returns NULL, if Attribute not found
-- =============================================
CREATE FUNCTION [dbo].fn_FindFactID 
(
	@factName nvarchar(max)
)
RETURNS int
AS
BEGIN
	DECLARE @attributeID int;

	if NOT @factName IS NULL AND LEN(@factName) > 0
		SELECT	@attributeID = FactID
		FROM	dbo.Fact
		WHERE	[Name] = @factName;
	return @attributeID;
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 5/20/2016
-- Description:	Gets a Name Collection of Attribute ValueTypes, sorted latest first.
-- Remarks: Returns blank string, if Attribute not found
-- =============================================
CREATE FUNCTION dbo.fn_GetAttributeValueTypes 
(
	@attributeID int
)
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE @separator nchar = '|';
	DECLARE @attrValueTypes AS nvarchar(max);
	DECLARE @valueType AS nvarchar(2048);
	DECLARE @attributePathCursor as CURSOR;

	SET @attributePathCursor = CURSOR FOR
	SELECT	ValueType
	FROM	dbo.AttributePath
	WHERE	AttributeID = @attributeID
	ORDER BY AttributePathID DESC;

	OPEN @attributePathCursor;

	SET @attrValueTypes = '';
	while 1=1
		begin
		FETCH NEXT FROM @attributePathCursor INTO @valueType;   
		if @@FETCH_STATUS != 0
			break;
		if LEN(@attrValueTypes) <= 0
			SET @attrValueTypes += @separator; -- first enclosing separator
		SET @valueType += @separator;
		if 0 >= CHARINDEX(@valueType + @separator, @attrValueTypes) -- is value type unique?
			SET @attrValueTypes += @valueType;
		end
	CLOSE @attributePathCursor;
	DEALLOCATE @attributePathCursor;
	return @attrValueTypes;
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 5/21/2016
-- Description:	Parses the specified textual Amount value into amount and (ISO 4217) 3-characters currency code
-- Examples: 16.27 USD, 26 EUR, 14.57 RUB
-- =============================================
CREATE PROCEDURE dbo.p_ParseMoney
	@amount money out, -- [output] amount
	@currencyCode nvarchar(3) out, -- [output] ISO 4217 3-characters currency code or null, if undefined
	@moneyValue nvarchar(max) -- currency text to parse
AS
BEGIN
	DECLARE @textLength int;
	DECLARE @codeLength int = 3; -- length of currency code
	 
	SET NOCOUNT ON;
	SET @textLength = LEN(COALESCE(@moneyValue, N''));
	if @textLength <= 0
		return 1;
	SET @moneyValue = RTRIM(@moneyValue);
	if N' ' != SUBSTRING(@moneyValue, @textLength - @codeLength, 1)
		begin -- no currency code
		SET @currencyCode = NULL;
		SET @amount = convert(money, @moneyValue);
		end
	else
		begin -- currency code is specified
		SET @currencyCode = SUBSTRING(@moneyValue, @textLength - @codeLength + 1, @codeLength);
		SET @amount = convert(money, SUBSTRING(@moneyValue, 1, @textLength - @codeLength - 1))
		end
	return 0;
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 5/1/2016
-- Description:	Saves Phrase translation
-- Remarks: If translation with the specified phrase id and language id already exists,
--          updates found translation or deletes it, if translation text is NULL or blank
-- =============================================
CREATE PROCEDURE [dbo].[p_PhraseTranslation_Save]
	@translationID int out, -- [out] translation ID (new or found)
	@phraseID int out, -- [inout] create new phrase if invalid
	@translationValue nvarchar(max), -- translation record will be deleted, if NULL or blank
	@languageID int = NULL, -- valid language ID for create
	@creatorID int = NULL, -- valid user id for create
	@newPhraseUid uniqueidentifier = NULL, -- optional uid for new phrase
	@newTranslationUid uniqueidentifier = NULL -- optional uid for new translation
AS
BEGIN
	SET NOCOUNT ON;

	PRINT('p_PhraseTranslation_Save> begin.. @translationValue: ' + COALESCE(@translationValue, ''));
	if @translationID IS NULL OR @translationID <= 0
		begin
		if @phraseID IS NULL OR @phraseID <= 0
			begin -- create new phrase
			if @translationValue IS NULL OR LEN(@translationValue) <= 0
				return 1; -- no valid parameters
			INSERT INTO dbo.Phrase(Uid, CreatorID) VALUES (COALESCE(@newPhraseUid, newid()), @creatorID);
			SET @phraseID = @@IDENTITY;
			end
		else -- look up for existing translation for the specified phrase and language ids
			SELECT @translationID = TranslationID FROM dbo.Translation WHERE PhraseID = @phraseID AND LanguageID = @languageID;
		end

	PRINT('p_PhraseTranslation_Save> @phraseID: ' + convert(nvarchar, @phraseID));
	if @translationID IS NULL OR @translationID <= 0
		begin -- create new translation, if translation text is valid
		if @translationValue IS NULL OR LEN(@translationValue) <= 0
			return 2; -- no valid parameters
		INSERT INTO dbo.Translation(PhraseID, LanguageID, ValueTranslation, [Uid], CreatorID)
		VALUES(@phraseID, @languageID, @translationValue, COALESCE(@newTranslationUid, newid()), @creatorID);
		SET @translationID = @@IDENTITY;
		end
	else
		begin -- translation alredy exists
		if NOT @translationValue IS NULL AND LEN(@translationValue) > 0 -- update translation
			UPDATE Translation SET ValueTranslation = @translationValue, ModifyDate = getdate() WHERE TranslationID = @translationID;
		else
			begin -- delete translationl
			DELETE FROM Translation WHERE TranslationID = @translationID;
			SET @translationID = 0; -- invalidate translation id
			end
		if @@ROWCOUNT < 1
			return 2;
		end
	PRINT('p_PhraseTranslation_Save> ..end');
	return 0;
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 4/29/2016
-- Description:	Save Attribute Path
-- Remarks: Any Fact could be used as Attribute. If Fact has associated Atribute Path, it is considered to be Attribute.
--          Attribute Path Options are specified in JSON format
/*
Examples Attribute Base List:
1. base1, base2, base3
2. Integer {display: "Winter|Spring|Summer|Autumn", values: "1|2|3|4"}
3. Integer {display: "Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday", values: "1|2|3|4|5|6|7"},
   Text {display: "Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday", values: "Mon|Tue|Wed|Thu|Fri|Sat|Sun"}
4. Integer {display: "|Father|Mother|Son|Daughter|Dog|Cat", values: "0|1|2|3|4|5|6"}, Phrase, Time
4. Phrase, Integer {display: "|Папа|Мама|Сын|Дочь|Собака|Кошка", values: "0|1|2|3|4|5|6"}, Time
*/
-- =============================================
CREATE PROCEDURE [dbo].[p_AttributePath_Save]
	@attributeID int, -- attribute (fact) id
	@factName nvarchar(1024),
	@attrBaseNameList nvarchar(max) = NULL, -- optional comma-delimited list of Base Attribute Names, NULL for root
	@languageID int, -- valid language id
	@creatorID int = NULL -- creator id
AS
BEGIN
	DECLARE @iStart int;
	DECLARE @iStop int;
	DECLARE @iStartOptions int;
	DECLARE @iStopOptions int;
	DECLARE @length int;
	DECLARE @baseName nvarchar(2048);
	DECLARE @attrToken varchar(12); 
	DECLARE @valueType nvarchar(2048); -- name of the first attribute in path
	DECLARE @optionPhraseID int;
	DECLARE @options nvarchar(max);
	DECLARE @inserted int = 0;
	DECLARE @valueTypeList nvarchar(max) = 
	'|Attribute|Boolean|Century|Amount|DayOfWeek|FactSet|File|GeoPoint|Integer|IntegerOption|Month|Phrase|RealNumber|Season|Text|TextOption|Time|TimeAge|TimeDescription|TimePhrase|Uid|Year|';

	PRINT('p_AttributePath_Save> begin.. attrBaseNameList: ' + COALESCE(@attrBaseNameList, ''));
	SET @attrToken = dbo.fn_MakePathItem(@attributeID);
	if 0 < CHARINDEX('|' + @factName + '|', @valueTypeList)
		SET @valueType = @factName;
	SET @length = LEN(COALESCE(@attrBaseNameList, ''));
	SET @iStart = 1;
	WHILE 1=1
		begin
		SET @baseName = NULL;
		SET @options = NULL;
		if @length > 0
			begin
			-- search for a delimiter
			SET @iStop = CHARINDEX(',', @attrBaseNameList, @iStart);
			if @iStop <= 0
				SET @iStop = @length + 1;
			-- search for options data
			SET @iStartOptions = CHARINDEX('{', @attrBaseNameList, @iStart);
			if @iStartOptions <= 0
				SET @iStartOptions = @length + 1;
			if @iStartOptions >= @iStop
				SET @baseName = LTRIM(RTRIM(SUBSTRING(@attrBaseNameList, @iStart, @iStop - @iStart)));
			else -- found options data for the current item
				begin
				SET @baseName = LTRIM(RTRIM(SUBSTRING(@attrBaseNameList, @iStart, @iStartOptions - @iStart)));

				SET @iStopOptions = CHARINDEX('}', @attrBaseNameList, @iStartOptions + 1);
				if @iStopOptions <= 0
					SET @iStopOptions = @length + 1;
				else
					SET @iStopOptions += 1;-- include the closing brace

				SET @options = LTRIM(RTRIM(SUBSTRING(@attrBaseNameList, @iStartOptions, @iStopOptions - @iStartOptions)));
				-- search for a delimiter
				SET @iStop = CHARINDEX(',', @attrBaseNameList, @iStopOptions);
				end

			if @iStop <= 0
				SET @iStop = @length + 1;

			SET @iStart = @iStop + 1; -- advance beyond found delimiter
			end	
		
		PRINT 'p_AttributePath_Save> calling p_PhraseTranslation_Save. factName: ' + @factName + ', baseName: ' + @baseName;
		exec dbo.p_PhraseTranslation_Save null, @optionPhraseID out, @options, @languageID, @creatorID;
		if @factName = 'Attribute'
			begin
			INSERT INTO dbo.AttributePath(AttributeID, [Path], ValueType, OptionPhraseID, CreatorID)
			VALUES(@attributeID, @attrToken, N'Attribute', @optionPhraseID, @creatorID);
			SET @inserted += @@ROWCOUNT;
			break;
			end

		INSERT INTO dbo.AttributePath(AttributeID, [Path], ValueType, OptionPhraseID, CreatorID)
		SELECT	@attributeID, ap.[Path] + @attrToken, COALESCE(@valueType, ValueType), @optionPhraseID, @creatorID
		FROM	dbo.AttributePath ap INNER JOIN
				dbo.Fact f ON ap.AttributeID = f.FactID
		WHERE f.[Name] = @baseName AND NOT ap.[Path] IS NULL AND ap.[Path] NOT LIKE '%' + @attrToken + '%';
		SET @inserted += @@ROWCOUNT;

		if @iStart > @length
			 break;
		end
	PRINT('p_AttributePath_Save> ..end inserted: ' + convert(nvarchar, @inserted));
	return 0;
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 5/1/2016
-- Description:	Modify Fact-Attribute
-- Remarks: Avaialable Value Types:
/*
•	Boolean – (default) yes/no. Flag "Fact-Attribute is in effect/not disabled".
•	Century: Integer
•	Amount – Amount value and optional space separated 3 symbol code (ISO 4217)
•	DayOfWeek: IntegerOption
•	FactSet
•	File – uploaded file
•	GeoPoint – latitude and longitude
•	Integer – simple number
•	Month: IntegerOption
•	Phrase – textual information on one or several languages
•	RealNumber – math number
•	Season: IntegerOption
•	Text – textual information
•	Time – date/time value
•	TimeAge: Phrase
•	TimeDescription – date/time decription phrase
•	TimePhrase – date/time phrase
•	Uid – auto-generated Globally Unique Identifier assigned to a Fact
•	Year: Integer
*/
-- =============================================
CREATE PROCEDURE [dbo].[p_FactAttribute_Modify]
	@factAttributeID int out, -- [inout] fact-attribute id
	@factID int, -- fact id
	@attributeID int, -- attribute id
	@attributeValue nvarchar(max) = NULL, -- fact attribute value
	@valueType nvarchar(2048) = NULL, -- value type, if invalid then will try to get the first matching one from the attribute
	@languageID int = NULL, -- valid language id for value of text type
	@userID int = NULL, -- valid user id
	@uidNewFactAttribute uniqueidentifier = NULL
AS
BEGIN
	DECLARE @attrValueTypes AS nvarchar(max);
	DECLARE @attributePath varchar(max);
	DECLARE @id int;
	DECLARE @posStop int;
	DECLARE @separator nchar = N'|';
	DECLARE @amount money;
	DECLARE @currencyCode nvarchar(3); -- ISO 4217 3-characters currency code or null, if undefined

	SET @attrValueTypes = dbo.fn_GetAttributeValueTypes(@attributeID);
	if @attrValueTypes IS NULL OR LEN(@attrValueTypes) <= 0
		return 1; -- invalid attribute
	if @valueType IS NULL OR LEN(@valueType) <= 0
		begin
		SET @posStop = CHARINDEX(@separator, @attrValueTypes, 2); -- find a second separator
		if @posStop <= 0
			SET @posStop = LEN(@attrValueTypes);
		SET @valueType = LTRIM(RTRIM(SUBSTRING(@valueType, 2, @posStop - 2))); -- skip a first separator
		end
	else if 0 >= CHARINDEX(@separator + @valueType + @separator, @attrValueTypes)
		return 2; -- specified value type is not supported by the attribute

	if @factAttributeID IS NULL -- try to find the existing Fact-Attribute
		SELECT	@factAttributeID = FactAttributeID, @uidNewFactAttribute = [Uid]
		FROM	dbo.FactAttribute
		WHERE	FactID = @factID AND AttributeID = @attributeID;

	if @factAttributeID IS NULL
		begin -- insert a new fact-attribute
		if @uidNewFactAttribute IS NULL OR LEN(@uidNewFactAttribute) <= 0
			SET @uidNewFactAttribute = newid();
		if @attributeValue IS NULL
			INSERT INTO dbo.FactAttribute(FactID, AttributeID, CreatorID, [Uid])
			VALUES(@factID, @attributeID, @userID, @uidNewFactAttribute);
		else if @valueType = 'Boolean'
			INSERT INTO dbo.FactAttribute(ValueBoolean, FactID, AttributeID, CreatorID, [Uid])
			VALUES(convert(bit, @attributeValue), @factID, @attributeID, @userID, @uidNewFactAttribute);
		else if @valueType = 'Phrase'
			begin
			exec dbo.p_PhraseTranslation_Save null, @id out, @attributeValue, @languageID, @userID
			INSERT INTO dbo.FactAttribute(ValuePhraseID, FactID, AttributeID, CreatorID, [Uid])
			VALUES(@id, @factID, @attributeID, @userID, @uidNewFactAttribute);
			end
		else if @valueType = 'Integer'
			INSERT INTO dbo.FactAttribute(ValueInteger, FactID, AttributeID, CreatorID, [Uid])
			VALUES(convert(int, @attributeValue), @factID, @attributeID, @userID, @uidNewFactAttribute);
		else if @valueType = 'RealNumber'
			INSERT INTO dbo.FactAttribute(ValueReal, FactID, AttributeID, CreatorID, [Uid])
			VALUES(convert(real, @attributeValue), @factID, @attributeID, @userID, @uidNewFactAttribute);
		else if @valueType = 'Amount'
			begin
			exec dbo.p_ParseMoney @amount out, @currencyCode out, @attributeValue;
			INSERT INTO dbo.FactAttribute(ValueAmount, FactID, AttributeID, CreatorID, [Uid])
			VALUES(@amount, @factID, @attributeID, @userID, @uidNewFactAttribute);
			if NOT @currencyCode IS NULL -- recursive call:
				begin
				SET @id = dbo.fn_FindFactID(@currencyCode);
				exec p_FactAttribute_Modify NULL, @factID, @id, NULL, NULL, @languageID, @userID;
				end
			end
		else if @valueType = 'GeoPoint'
			INSERT INTO dbo.FactAttribute(ValueGeoPoint, FactID, AttributeID, CreatorID, [Uid])
			VALUES(geography::STPointFromText('POINT(' + REPLACE(@attributeValue, ',', ' ') + ')', 4326), @factID, @attributeID, @userID, @uidNewFactAttribute);
		else if @valueType = 'Time'
			INSERT INTO dbo.FactAttribute(ValueTime, FactID, AttributeID, CreatorID, [Uid])
			VALUES(convert(datetime, @attributeValue), @factID, @attributeID, @userID, @uidNewFactAttribute);
		else if @valueType = 'Season'
			INSERT INTO dbo.FactAttribute(ValueSeason, FactID, AttributeID, CreatorID, [Uid])
			VALUES(convert(int, @attributeValue), @factID, @attributeID, @userID, @uidNewFactAttribute);
		else if @valueType = 'DayOfWeek'
			INSERT INTO dbo.FactAttribute(ValueDayOfWeek, FactID, AttributeID, CreatorID, [Uid])
			VALUES(convert(int, @attributeValue), @factID, @attributeID, @userID, @uidNewFactAttribute);
		else if @valueType = 'Month'
			INSERT INTO dbo.FactAttribute(ValueMonth, FactID, AttributeID, CreatorID, [Uid])
			VALUES(convert(int, @attributeValue), @factID, @attributeID, @userID, @uidNewFactAttribute);
		else if @valueType = 'Year'
			INSERT INTO dbo.FactAttribute(ValueYear, FactID, AttributeID, CreatorID, [Uid])
			VALUES(convert(int, @attributeValue), @factID, @attributeID, @userID, @uidNewFactAttribute);
		else if @valueType = 'Century'
			INSERT INTO dbo.FactAttribute(ValueCentury, FactID, AttributeID, CreatorID, [Uid])
			VALUES(convert(int, @attributeValue), @factID, @attributeID, @userID, @uidNewFactAttribute);
		else if @valueType = 'Age'
			begin
			exec dbo.p_PhraseTranslation_Save null, @id out, @attributeValue, @languageID, @userID
			INSERT INTO dbo.FactAttribute(ValueTimeAgePhraseID, FactID, AttributeID, CreatorID, [Uid])
			VALUES(@id, @factID, @attributeID, @userID, @uidNewFactAttribute);
			end
		else if @valueType = 'TimePhrase'
			begin
			exec dbo.p_PhraseTranslation_Save null, @id out, @attributeValue, @languageID, @userID
			INSERT INTO dbo.FactAttribute(ValueTimePhraseID, FactID, AttributeID, CreatorID, [Uid])
			VALUES(@id, @factID, @attributeID, @userID, @uidNewFactAttribute);
			end
		else if @valueType = 'TimeDescription'
			begin
			exec dbo.p_PhraseTranslation_Save null, @id out, @attributeValue, @languageID, @userID
			INSERT INTO dbo.FactAttribute(ValueTimeDescriptionPhraseID, FactID, AttributeID, CreatorID, [Uid])
			VALUES(@id, @factID, @attributeID, @userID, @uidNewFactAttribute);
			end
		else if @valueType = 'Text'
			INSERT INTO dbo.FactAttribute(ValueText, FactID, AttributeID, CreatorID, [Uid])
			VALUES(@attributeValue, @factID, @attributeID, @userID, @uidNewFactAttribute);
		else if @valueType = 'Uid'
			INSERT INTO dbo.FactAttribute(ValueUid, FactID, AttributeID, CreatorID, [Uid])
			VALUES(convert(uniqueidentifier, @attributeValue), @factID, @attributeID, @userID, @uidNewFactAttribute);
		--else if @valueType = 'FactSet'
		SET @factAttributeID = @@IDENTITY;
		end -- @factAttributeID IS NULL
	else
		begin -- update the existing fact-attribute 
		if @valueType = 'Boolean'
			UPDATE	dbo.FactAttribute SET ValueBoolean = convert(bit, @attributeValue), UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
		else if @valueType = 'Phrase'
			begin
			exec dbo.p_PhraseTranslation_Save null, @id out, @attributeValue, @languageID, @userID
			UPDATE	dbo.FactAttribute SET ValuePhraseID = @id, UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
			end
		else if @valueType = 'Integer'
			UPDATE	dbo.FactAttribute SET ValueInteger = convert(int, @attributeValue), UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
		else if @valueType = 'RealNumber'
			UPDATE	dbo.FactAttribute SET ValueReal = convert(real, @attributeValue), UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
		else if @valueType = 'Amount'
			begin
			exec dbo.p_ParseMoney @amount out, @currencyCode out, @attributeValue;
			UPDATE	dbo.FactAttribute SET ValueAmount = @amount, UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
			if NOT @currencyCode IS NULL -- recursive call:
				begin
				SET @id = dbo.fn_FindFactID(@currencyCode);
				exec p_FactAttribute_Modify NULL, @factID, @id, NULL, NULL, @languageID, @userID;
				end
			end
		else if @valueType = 'GeoPoint'
			UPDATE	dbo.FactAttribute SET ValueGeoPoint = geography::STPointFromText('POINT(' + REPLACE(@attributeValue, ',', ' ') + ')', 4326),
					UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
		else if @valueType = 'Time'
			UPDATE	dbo.FactAttribute SET ValueTime = convert(datetime, @attributeValue), UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
		else if @valueType = 'Season'
			UPDATE	dbo.FactAttribute SET ValueSeason = convert(int, @attributeValue), UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
		else if @valueType = 'DayOfWeek'
			UPDATE	dbo.FactAttribute SET ValueDayOfWeek = convert(int, @attributeValue), UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
		else if @valueType = 'Month'
			UPDATE	dbo.FactAttribute SET ValueMonth = convert(int, @attributeValue), UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
		else if @valueType = 'Year'
			UPDATE	dbo.FactAttribute SET ValueYear = convert(int, @attributeValue), UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
		else if @valueType = 'Century'
			UPDATE	dbo.FactAttribute SET ValueCentury = convert(int, @attributeValue), UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
		else if @valueType = 'Age'
			begin
			exec dbo.p_PhraseTranslation_Save null, @id out, @attributeValue, @languageID, @userID;
			UPDATE	dbo.FactAttribute SET ValueTimeAgePhraseID = @id, UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
			end
		else if @valueType = 'TimePhrase'
			begin
			exec dbo.p_PhraseTranslation_Save null, @id out, @attributeValue, @languageID, @userID
			UPDATE	dbo.FactAttribute SET ValueTimePhraseID = @id, UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
			end
		else if @valueType = 'TimeDescription'
			begin
			exec dbo.p_PhraseTranslation_Save null, @id out, @attributeValue, @languageID, @userID
			UPDATE	dbo.FactAttribute SET ValueTimeDescriptionPhraseID = @id, UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
			end
		else if @valueType = 'Text'
			UPDATE	dbo.FactAttribute SET ValueText = @attributeValue, UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
		else if @valueType = 'Uid'
			UPDATE	dbo.FactAttribute SET ValueUid = convert(uniqueidentifier, @attributeValue), UserID = @userID, ModifyDate = getdate()
			WHERE	FactID = @factID AND AttributeID = @attributeID;
		--else if @valueType = 'FactSet'
		end -- else @factAttributeID IS NULL
	return 0;
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 5/1/2016
-- Description:	Save Fact-Attribute
-- =============================================
CREATE PROCEDURE [dbo].p_FactAttribute_Save
	@factAttributeID int out, -- output fact-attribute id
	@factID int, -- fact id
	@attributeList nvarchar(max), -- pipe-delimited list of Attribute groups <<name[:value[:type]]>>
	@creatorID int, -- valid creator id
	@languageID int = NULL, -- valid language id for attribute value
	@uidNewFactAttribute uniqueidentifier = NULL
AS
BEGIN
	DECLARE @iStart int;
	DECLARE @iStop int;
	DECLARE @length int;
	DECLARE @attributeToken nvarchar(max);
	DECLARE @iStopNameDlm int;
	DECLARE @attributeName nvarchar(max);
	DECLARE @attributeValue nvarchar(max);
	DECLARE @attributeID int;
	DECLARE @attributePath varchar(max);
	DECLARE @valueType nvarchar(2048);

	if @attributeList IS NULL
		return 1;
	SET @length = LEN(@attributeList);
	if @length <= 0
		return 1;
	SET @iStart = 1;
	WHILE @iStart <= @length
		begin
		SET @valueType = NULL;
		SET @iStop = CHARINDEX('|', @attributeList, @iStart);
		if @iStop <= 0
			SET @iStop = @length + 1;
		SET @attributeToken = SUBSTRING(@attributeList, @iStart, @iStop - @iStart);

		-- process attribute (possibly group of name[:[(type)]value])
		SET @iStopNameDlm = CHARINDEX(':', @attributeToken);
		if @iStopNameDlm <= 0 -- attribute name only
			SET @attributeName = @attributeToken;
		ELSE
			begin -- name and value
			SET @attributeName = LTRIM(RTRIM(SUBSTRING(@attributeToken, 1, @iStopNameDlm)));
			SET @attributeValue = LTRIM(RTRIM(SUBSTRING(@attributeToken, @iStopNameDlm + 1, LEN(@attributeToken) - @iStopNameDlm)));
			if '(' = SUBSTRING(@attributeValue, 1, 1)
				begin -- casting to value type is specified
				SET @iStopNameDlm = CHARINDEX(')', @attributeValue);
				if @iStopNameDlm > 2
					SET @valueType = SUBSTRING(@attributeValue, 2, @iStopNameDlm - 2);
				end
			end

		-- find attribute id: 

		PRINT 'p_FactAttribute_Save> calling fn_FindFactID. @attrName: ' + @attributeName;
		SET @attributeID = dbo.fn_FindFactID(@attributeName);
		PRINT 'p_FactAttribute_Save> called fn_FindFactID. @attributeID: ' + convert(nvarchar, @attributeID);
		if NOT @attributeID IS NULL
			begin
			SELECT @factAttributeID = FactAttributeID FROM dbo.FactAttribute WHERE FactID = @factID AND AttributeID = @attributeID;
			exec dbo.p_FactAttribute_Modify @factAttributeID out, @factID, @attributeID,
					 @attributeValue, @valueType, @languageID, @creatorID, @uidNewFactAttribute;
			end

		SET @iStart = @iStop + 1; -- advance beyond found delimiter
		end
	return 0;
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 5/1/2016
-- Description:	Save Fact
-- =============================================
CREATE PROCEDURE [dbo].[p_Fact_Save]
	@factID int out, -- [inout] fact id
	@languageID int, -- valid language id
	@factName nvarchar(2048), -- unique name, if not specified, uid will be used or generated
	@creatorID int, -- valid creator id
	@attributeList nvarchar(max) = NULL, -- comma-delimited list of Attribute Names/Values
	@factTitle nvarchar(max) = NULL, -- optional title
	@factDescription nvarchar(max) = NULL, -- optional description
	@attrBaseNameList nvarchar(max) = NULL, -- [for attribute only] comma-delimited list of Base Attribute Names/Values on any language
	@uidNewFact uniqueidentifier = NULL
AS
BEGIN
	DECLARE @titlePhraseID int;
	DECLARE @descriptionPhraseID int;
	DECLARE @optionDisplayPhraseID int;
	DECLARE @isUpdate bit = 0;
	SET NOCOUNT ON;

	PRINT 'p_Fact_Save> begin.. @factName: ' + COALESCE(@factName, '');
	-- find a record
	if NOT @factID IS NULL AND @factID > 0 -- by id
		SELECT	@factID = FactID, @factName = [Name], @titlePhraseID = TitlePhraseID,
				@descriptionPhraseID = DescriptionPhraseID, @uidNewFact = [Uid]
		FROM	Fact
		WHERE	FactID = @factID;
	else if NOT @factName IS NULL AND LEN(@factName) > 0 -- by name
		SELECT	@factID = FactID, @titlePhraseID = TitlePhraseID, @descriptionPhraseID = DescriptionPhraseID, @uidNewFact = [Uid]
		FROM	Fact
		WHERE	[Name] = @factName;
	else if NOT @uidNewFact IS NULL -- by uid
		SELECT	@factID = FactID, @factName = [Name], @titlePhraseID = TitlePhraseID, @descriptionPhraseID = DescriptionPhraseID
		FROM	Fact
		WHERE	[Uid] = @uidNewFact;

	exec dbo.p_PhraseTranslation_Save null, @titlePhraseID out, @factTitle, @languageID, @creatorID;
	exec dbo.p_PhraseTranslation_Save null, @descriptionPhraseID out, @factDescription, @languageID, @creatorID;

	if NOT @factID IS NULL AND @factID > 0 -- update
		UPDATE	dbo.Fact SET TitlePhraseID = @titlePhraseID, DescriptionPhraseID = @descriptionPhraseID
		WHERE	FactID = @factID
	else -- create
		begin
		if @uidNewFact IS NULL
			SET @uidNewFact = COALESCE(@uidNewFact, newid());
		if @factName IS NULL OR LEN(@factName) <= 0
			SET @factName = @uidNewFact;
		INSERT INTO dbo.Fact([Name], TitlePhraseID, DescriptionPhraseID, [Uid], CreatorID)
		VALUES(@factName, @titlePhraseID, @descriptionPhraseID, @uidNewFact, @creatorID);
		SET @factID = @@IDENTITY;
		end

	if NOT @factID IS NULL AND NOT @attributeList IS NULL AND LEN(@attributeList) > 0
		exec dbo.p_FactAttribute_Save null, @factID, @attributeList, @creatorID, @languageID

	if NOT @attrBaseNameList IS NULL AND LEN(@attrBaseNameList) > 0 OR @factName = 'Attribute' -- only for attributes
		exec dbo.p_AttributePath_Save @factID, @factName, @attrBaseNameList, @languageID, @creatorID;

	PRINT 'p_Fact_Save> ..end';
	return 0;
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 4/30/2016
-- Description:	Load Facts flat file specification
-- Fields: Name, Title, Description, Fact Attributes, Base Attributes, Uid
-- Remarks: line starting with '//' is considered to be a comment
--			field starting with '//' is considered to be a beginning of the comment and the rest of the line is skipped
-- Example of Fact Attributes: Birthday:(Year)1971|Birthday:(Month)7|Amount:56.06 EUR
-- =============================================
CREATE PROCEDURE [dbo].[p_Fact_Import]
	@languageID int, -- valid language id
	@skipFirstLineCount int, -- number of first lines to skip
	@factText nvarchar(max), -- Fact flat file with standard columns
	@creatorID int = NULL -- valid creator id
AS
BEGIN
	DECLARE @fieldCount int = 6;
	DECLARE @lineDelimiter nvarchar(2) = CHAR(13) + CHAR(10); -- 2 chars long
	DECLARE @fieldDelimiter nvarchar(1) = CHAR(9); -- 1 char long
	DECLARE @textLength int;
	DECLARE @iLineStart int;
	DECLARE @iLineStop int;
	DECLARE @lineLength int;
	DECLARE @lineText nvarchar(max);
	DECLARE @iFieldStart int;
	DECLARE @iFieldStop int;
	DECLARE @fieldValue nvarchar(max);
	DECLARE @fieldIndex int;
	DECLARE @factName nvarchar(2048); -- attribute name
	DECLARE @attributeList nvarchar(max); -- list of Attributes
	DECLARE @factTitle nvarchar(max); -- title
	DECLARE @factDescription nvarchar(max); -- description
	DECLARE @attrBaseNameList nvarchar(max); -- list of base attributes
	DECLARE @uidNewFact uniqueidentifier;

	PRINT 'p_Fact_Import> begin..';
	if @factText IS NULL
		return 1;
	SET @textLength = LEN(@factText);
	if @textLength <= 0
		return 1;
	SET @iLineStart = 1;
	WHILE @iLineStart <= @textLength
		begin -- parse lines
		SET @iLineStop = CHARINDEX(@lineDelimiter, @factText, @iLineStart);
		if @iLineStop <= 0
			SET @iLineStop = @textLength + 1;
		if @skipFirstLineCount > 0
			SET @skipFirstLineCount = @skipFirstLineCount - 1;
		else
			begin
			SET @lineLength = @iLineStop - @iLineStart;
			SET @lineText = SUBSTRING(@factText, @iLineStart, @lineLength);
			if '//' != SUBSTRING(@lineText, 1, 2)
				begin -- fetch line fields..
				SET @fieldIndex = 0;
				SET @iFieldStart = 1;
				SET @factName = NULL;
				SET @attributeList = NULL;
				SET @factTitle = NULL;
				SET @factDescription = NULL;
				SET @attrBaseNameList = NULL;
				SET @uidNewFact = newid();
				WHILE @iFieldStart <= @lineLength AND @fieldIndex < @fieldCount
					begin
					SET @iFieldStop = CHARINDEX(@fieldDelimiter, @lineText, @iFieldStart);
					if @iFieldStop <= 0
						SET @iFieldStop = @lineLength + 1;
					SET @fieldValue = LTRIM(RTRIM(SUBSTRING(@lineText, @iFieldStart, @iFieldStop - @iFieldStart)));
					if '//' = SUBSTRING(@fieldValue, 1, 2)
						break; -- skip the rest of the line

					if @fieldIndex = 0
						SET @factName = @fieldValue;
					else if @fieldIndex = 1
						SET @factTitle = @fieldValue;
					else if @fieldIndex = 2
						SET @factDescription = @fieldValue;
					else if @fieldIndex = 3
						SET @attributeList = @fieldValue;
					else if @fieldIndex = 4
						SET @attrBaseNameList = @fieldValue;
					else if @fieldIndex = 5
						SET @uidNewFact = CONVERT(uniqueidentifier, @fieldValue);

					SET @fieldIndex = @fieldIndex + 1; -- increment field index
					SET @iFieldStart = @iFieldStop + 1; -- advance beyond found field delimiter
					end
		
				exec dbo.p_Fact_Save null, @languageID, @factName, @creatorID, @attributeList,
										@factTitle, @factDescription, @attrBaseNameList, @uidNewFact;
				end
			end
		SET @iLineStart = @iLineStop + 2; -- advance beyond found line delimiter
		end
	PRINT 'p_Fact_Import> ..end';
END
GO
