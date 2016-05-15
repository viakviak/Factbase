-- FactData Programmability Cleanup

/****** Object:  UserDefinedFunction [dbo].[fn_MakePathItem]    Script Date: 4/27/2016 7:52:22 PM ******/
IF OBJECT_ID(N'fn_MakePathItem', N'FN') IS NOT NULL
	DROP FUNCTION [dbo].[fn_MakePathItem]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_GetPathCount]    Script Date: 5/2/2016 7:03 PM ******/
IF OBJECT_ID(N'fn_GetPathCount', N'FN') IS NOT NULL
	DROP FUNCTION [dbo].[fn_GetPathCount]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_GetPathId]    Script Date: 5/2/2016 7:03 PM ******/
IF OBJECT_ID(N'fn_GetPathId', N'FN') IS NOT NULL
	DROP FUNCTION [dbo].[fn_GetPathId]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_FindValueType]    Script Date: 5/2/2016 9:36 PM ******/
IF OBJECT_ID(N'fn_FindValueType', N'FN') IS NOT NULL
	DROP FUNCTION [dbo].[fn_FindValueType]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_FindAttributeID]    Script Date: 4/28/2016 7:34 PM ******/
IF OBJECT_ID(N'fn_FindAttributeID', N'FN') IS NOT NULL
	DROP FUNCTION [dbo].fn_FindAttributeID
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
-- Description:	Get Path Vector Size
-- =============================================
CREATE FUNCTION [dbo].[fn_GetPathCount] 
(
	@path varchar(max)
)
RETURNS int
AS
BEGIN
	if @path IS NULL
		return 0;
	return LEN(@path) / 10;
END
GO


-- =============================================
-- Author:		ViakViak
-- Create date: 5/2/2016
-- Description:	Get Path Item Numeric Value (ID)
-- Remarks: returns negative value, if input is invalid
-- =============================================
CREATE FUNCTION [dbo].[fn_GetPathId] 
(
	@path varchar(max),
	@itemIndex int -- 0-based index
)
RETURNS int
AS
BEGIN
	DECLARE @count int;
	DECLARE @itemValue varchar(10);

	if @path IS NULL
		return -1;
	SET @count = LEN(@path) / 10;
	if @itemIndex < 0 OR @itemIndex >= @count
		return -2;
	SET @itemValue = SUBSTRING(@path, @itemIndex * 10 + 2, 9); -- without leading "|"
	return convert(int, @itemValue);
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 5/2/2016
-- Description:	Find Value Type
-- Remarks: Returns NULL, if not found
-- =============================================
CREATE FUNCTION [dbo].fn_FindValueType
(
	@path varchar(max)
)
RETURNS nvarchar(2048)
AS
BEGIN
	DECLARE @valueTypeList varchar(512);
	DECLARE @itemIndex int;
	DECLARE @itemValue varchar(10);
	DECLARE @valueType nvarchar(2048);
	DECLARE @attributeID int;

	if @path IS NULL
		return NULL;
	SET @valueTypeList = '|Boolean|Century|Currency|DayOfWeek|FactSet|File|GeoPoint|Integer|MonthNumber|Phrase|Real|Season|Text|Time|TimeAge|Uid|Year|';
	SET @itemIndex = (LEN(@path) / 10) - 1; -- ubound
	WHILE @itemIndex >= 0
		begin -- going through items in reverse order
		SET @itemValue = SUBSTRING(@path, @itemIndex * 10 + 2, 9); -- 1-based string without leading "|"
		SET @attributeID = convert(int, @itemValue);

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
CREATE FUNCTION [dbo].fn_FindAttributeID 
(
	@attrName nvarchar(max)
)
RETURNS int
AS
BEGIN
	DECLARE @attributeID int;

	if NOT @attrName IS NULL AND LEN(@attrName) > 0
		SELECT	@attributeID = FactID
		FROM	dbo.Fact
		WHERE	[Name] = @attrName;
	return @attributeID;
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

	PRINT('p_PhraseTranslation_Save> begin..');
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
	@attrBaseNameList nvarchar(max) = NULL, -- optional comma-delimited list of Base Attribute Names
	@languageID int, -- valid language id
	@creatorID int = NULL, -- creator id
	@uidNewAttributePath uniqueidentifier = null
AS
BEGIN
	DECLARE @iStart int;
	DECLARE @iStop int;
	DECLARE @iStartOptions int;
	DECLARE @iStopOptions int;
	DECLARE @length int;
	DECLARE @baseName nvarchar(2048);
	DECLARE @attrPath varchar(max);
	DECLARE @attrToken varchar(12); 
	DECLARE @valueType nvarchar(2048); -- name of the first attribute in path
	DECLARE @optionPhraseID int;
	DECLARE @options nvarchar(max);

	if @attrBaseNameList IS NULL
		return 1;

	SET @attrToken = dbo.fn_MakePathItem(@attributeID);
	SET @length = LEN(COALESCE(@attrBaseNameList, ''));
	SET @iStart = 1;
	WHILE 1=1
		begin
		SET @options = NULL;
		if @length <= 0
			SET @attrPath = @attrToken;
		else
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

			-- find path of base attribute..
			SELECT	@attrPath = ap.[Path]
			FROM	Fact a INNER JOIN
					AttributePath ap ON a.FactID = ap.AttributeID
			WHERE	a.[Name] = @baseName;
			if @attrPath IS NULL
				SET @attrPath = @attrToken;
			else
				SET @attrPath += @attrToken;

			SET @iStart = @iStop + 1; -- advance beyond found delimiter
			end	
		
		if NOT @attrPath IS NULL
			begin -- found base attribute, create new attribute path
			PRINT 'p_AttributePath_Save> calling fn_FindValueType. @attrPath: ' + @attrPath;
			SET @valueType = COALESCE(dbo.fn_FindValueType(@attrPath), @factName); -- in absence of base attributes, take its own name as value type
			PRINT 'p_AttributePath_Save> calling fn_FindValueType. @valueType: ' + @valueType;
			exec dbo.p_PhraseTranslation_Save null, @optionPhraseID out, @options, @languageID, @creatorID;
			INSERT INTO dbo.AttributePath(AttributeID, [Path], ValueType, OptionPhraseID, [Uid], CreatorID)
			VALUES(@attributeID, @attrPath, @valueType, @optionPhraseID, COALESCE(@uidNewAttributePath, newid()), @creatorID);
			end

		if @iStart > @length
			 break;
		end
	return 0;
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 5/1/2016
-- Description:	Modify Fact-Attribute
-- Remarks: Avaialable Value Types:
/*
•	Boolean – (default) yes/no. The mere existence of the Fact-Attribute.
•	Century: Integer
•	Currency – Currency type and value
•	DayOfWeek: IntegerOption
•	File – uploaded file
•	GeoPoint – latitude and longitude
•	Integer – simple number
•	MonthNumber: IntegerOption
•	Phrase – textual information on one or several languages
•	Real – math number
•	Season: Phrase
•	Text – textual information
•	Time – date/time value
•	TimeAge: Phrase
•	Uid – auto-generated Globally Unique Identifier assigned to a Fact
•	Year: Integer
*/
-- =============================================
CREATE PROCEDURE [dbo].[p_FactAttribute_Modify]
	@factAttributeID int, -- fact-attribute id
	@attributeID int, -- attribute id
	@attributeValue nvarchar(max), -- fact attribute value
	@valueType nvarchar(2048) = NULL, -- optional value type (default: Boolean)
	@languageID int = NULL, -- valid language id for value of text type
	@creatorID int = NULL -- valid user id for create
AS
BEGIN
	DECLARE @attributePath varchar(max);
	DECLARE @phraseID int;

	SET @valueType = LTRIM(RTRIM(@valueType));
	if @valueType IS NULL OR LEN(@valueType) <= 0
		SET @valueType = 'Boolean';

	if NOT EXISTS(SELECT 1 FROM dbo.AttributePath WHERE AttributeID = @attributeID AND ValueType = @valueType)
		return -1; -- invalid value type

	if NOT @attributeValue IS NULL
		begin
		if @valueType = 'Century'
			UPDATE dbo.FactAttribute SET ValueCentury = convert(int, @attributeValue) WHERE FactAttributeID = @factAttributeID;
		else if @valueType = 'Currency'
			UPDATE dbo.FactAttribute SET ValueCurrency = convert(money, @attributeValue) WHERE FactAttributeID = @factAttributeID;
		else if @valueType = 'DayOfWeek'
			UPDATE dbo.FactAttribute SET ValueDayOfWeek = convert(int, @attributeValue) WHERE FactAttributeID = @factAttributeID;
		else if @valueType = 'GeoPoint'
			UPDATE dbo.FactAttribute
			SET ValueGeoPoint = geography::STPointFromText('POINT(' + REPLACE(@attributeValue, ',', ' ') + ')', 4326)
			WHERE FactAttributeID = @factAttributeID;
		else if @valueType = 'Integer'
			UPDATE dbo.FactAttribute SET ValueInteger = convert(int, @attributeValue) WHERE FactAttributeID = @factAttributeID;
		else if @valueType = 'MonthNumber'
			UPDATE dbo.FactAttribute SET ValueMonthNumber = convert(int, @attributeValue) WHERE FactAttributeID = @factAttributeID;
		else if @valueType = 'Real'
			UPDATE dbo.FactAttribute SET ValueReal = convert(real, @attributeValue) WHERE FactAttributeID = @factAttributeID;
		else if @valueType = 'Season'
			begin
			exec dbo.p_PhraseTranslation_Save null, @phraseID out, @attributeValue, @languageID, @creatorID
			UPDATE dbo.FactAttribute SET ValueSeasonPhraseID = @phraseID WHERE FactAttributeID = @factAttributeID;
			end
		else if @valueType = 'Text'
			UPDATE dbo.FactAttribute SET ValueText = @attributeValue WHERE FactAttributeID = @factAttributeID;
		else if @valueType = 'Uid'
			UPDATE dbo.FactAttribute SET ValueUid = convert(uniqueidentifier, @attributeValue) WHERE FactAttributeID = @factAttributeID;
		else if @valueType = 'Year'
			UPDATE dbo.FactAttribute SET ValueYear = convert(int, @attributeValue) WHERE FactAttributeID = @factAttributeID;
		end
	return 0;
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 5/1/2016
-- Description:	Save Fact-Attribute
-- =============================================
CREATE PROCEDURE [dbo].[p_FactAttribute_Save]
	@factAttributeID int out, -- output fact-attribute id
	@factID int, -- fact id
	@attributeList nvarchar(max), -- pipe-delimited list of Attribute Names/Values
	@creatorID int, -- valid creator id
	@languageID int = NULL, -- valid language id for attribute value
	@uidNewFactAttribute uniqueidentifier = null
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

	if @attributeList IS NULL
		return 1;
	SET @length = LEN(@attributeList);
	if @length <= 0
		return 1;
	SET @iStart = 1;
	WHILE @iStart <= @length
		begin
		SET @iStop = CHARINDEX('|', @attributeList, @iStart);
		if @iStop <= 0
			SET @iStop = @length + 1;
		SET @attributeToken = SUBSTRING(@attributeList, @iStart, @iStop - @iStart);

		-- process attribute (possibly pair of name/value)
		SET @iStopNameDlm = CHARINDEX(':', @attributeToken);
		if @iStopNameDlm <= 0 -- attribute name only
			SET @attributeName = @attributeToken;
		ELSE
			begin -- name and value
			SET @attributeName = LTRIM(RTRIM(SUBSTRING(@attributeToken, 1, @iStopNameDlm)));
			SET @attributeValue = LTRIM(RTRIM(SUBSTRING(@attributeToken, @iStopNameDlm + 1, LEN(@attributeToken) - @iStopNameDlm)));
			end

		-- find attribute id: 

		PRINT 'p_FactAttribute_Save> calling fn_FindAttributeID. @attrName: ' + @attributeName;
		SET @attributeID = dbo.fn_FindAttributeID(@attributeName);
		PRINT 'p_FactAttribute_Save> called fn_FindAttributeID. @attributeID: ' + convert(nvarchar, @attributeID);
		if NOT @attributeID IS NULL
			begin
			SELECT @factAttributeID = FactAttributeID FROM dbo.FactAttribute WHERE FactID = @factID AND AttributeID = @attributeID;
			if @factAttributeID IS NULL
				INSERT INTO dbo.FactAttribute(FactID, AttributeID, CreatorID, [Uid])
				VALUES(@factID, @attributeID, @creatorID, COALESCE(@uidNewFactAttribute, newid()));
				SET @factAttributeID = @@IDENTITY;
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
	@attrBaseNameList nvarchar(max) = NULL, -- [for attribute only] comma-delimited list of Base Attribute Names on any language
	@uidNewFact uniqueidentifier = NULL
AS
BEGIN
	DECLARE @titlePhraseID int;
	DECLARE @descriptionPhraseID int;
	DECLARE @optionDisplayPhraseID int;
	DECLARE @isUpdate bit = 0;
	SET NOCOUNT ON;

	PRINT 'p_Fact_Save> begin..';
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

	if NOT @attrBaseNameList IS NULL AND LEN(@attrBaseNameList) > 0
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
