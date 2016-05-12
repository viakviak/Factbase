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
		return -1;
	SET @valueTypeList = '|Boolean|Century|Currency|DayOfWeek|FactSet|File|GeoPoint|Integer|MonthNumber|Phrase|Real|Season|Text|Time|TimeAge|Uid|Year|';
	SET @itemIndex = (LEN(@path) / 10) - 1; -- ubound
	WHILE @itemIndex >= 0
		begin -- going through items in reverse order
		SET @itemValue = SUBSTRING(@path, @itemIndex * 10 + 2, 9); -- 1-based string without leading "|"
		SET @attributeID = convert(int, @itemValue);

		SELECT TOP 1 @valueType = ValueType FROM dbo.AttributePath WHERE AttributeID = @attributeID ORDER BY AttributePathID;-- first existing
		if @valueType IS NULL -- calculated
			SELECT TOP 1 @valueType = [Name]
			FROM	dbo.Attribute
			WHERE	AttributeID = @attributeID
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
		SELECT	@attributeID = AttributeID
		FROM	Attribute
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
-- =============================================
CREATE PROCEDURE [dbo].[p_AttributePath_Save]
	@attributeID int, -- output attribute id
	@attrBaseNameList nvarchar(max) = NULL, -- optional comma-delimited list of Base Parameter Names
	@creatorID int = NULL, -- creator id
	@uidNewAttributePath uniqueidentifier = null
AS
BEGIN
	DECLARE @iStart int;
	DECLARE @iStop int;
	DECLARE @length int;
	DECLARE @baseName nvarchar(2048);
	DECLARE @attrPath varchar(max);
	DECLARE @attrToken varchar(12); 
	DECLARE @valueType nvarchar(2048); -- name of the first attribute in path

	SET @attrToken = dbo.fn_MakePathItem(@attributeID);
	SET @length = LEN(COALESCE(@attrBaseNameList, ''));
	SET @iStart = 1;
	WHILE 1=1
		begin
		if @length <= 0
			SET @attrPath = @attrToken;
		else
			begin
			SET @iStop = CHARINDEX(',', @attrBaseNameList, @iStart);
			if @iStop <= 0
				SET @iStop = @length + 1;
			SET @baseName = LTRIM(RTRIM(SUBSTRING(@attrBaseNameList, @iStart, @iStop - @iStart)));

			-- find path of base attribute..
			SELECT	@attrPath = ap.[Path]
			FROM	Attribute a INNER JOIN
					AttributePath ap ON a.AttributeID = ap.AttributeID
			WHERE	a.[Name] = @baseName;
			if NOT @attrPath IS NULL
				SET @attrPath = @attrPath + @attrToken;
			SET @iStart = @iStop + 1; -- advance beyond found delimiter
			end	
		
		if NOT @attrPath IS NULL
			begin -- create new attribute path
			PRINT 'p_AttributePath_Save> calling fn_FindValueType. @attrPath: ' + @attrPath;
			SET @valueType = dbo.fn_FindValueType(@attrPath);
			PRINT 'p_AttributePath_Save> calling fn_FindValueType. @valueType: ' + @valueType;
			INSERT INTO dbo.AttributePath(AttributeID, [Path], ValueType, [Uid], CreatorID)
			VALUES(@attributeID, @attrPath, @valueType, COALESCE(@uidNewAttributePath, newid()), @creatorID);
			end

		if @iStart > @length
			 break;
		end
	return 0;
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 4/28/2016
-- Description:	Save Attribute
-- =============================================
CREATE PROCEDURE [dbo].[p_Attribute_Save]
	@attributeID int out, -- inout attribute id
	@languageID int, -- valid language id
	@attrName nvarchar(2048), -- valid name
	@creatorID int, -- valid creator id
	@attrBaseNameList nvarchar(max), -- comma-delimited list of Base Parameter Names on any language
	@attrTitle nvarchar(max) = NULL, -- optional title
	@attrDescription nvarchar(max) = NULL, -- optional description
	@optionDisplay nvarchar(max) = NULL, -- optional Option Display
	@optionValues nvarchar(max) = NULL, -- optional Option Values for new attribute
	@uidNewAttribute uniqueidentifier = NULL
AS
BEGIN
	DECLARE @titlePhraseID int;
	DECLARE @descriptionPhraseID int;
	DECLARE @optionDisplayPhraseID int;
	SET NOCOUNT ON;

	PRINT('p_Attribute_Save: begin...');
	if (@attributeID IS NULL OR @attributeID <= 0) AND NOT @attrName IS NULL AND LEN(@attrName) > 0
		begin-- if attribute invalid and name valid, use name to get get any existing phrase ids
		SELECT	@attributeID = AttributeID, @titlePhraseID = TitlePhraseID,
				@descriptionPhraseID = DescriptionPhraseID, @optionDisplayPhraseID = OptionDisplayPhraseID
		FROM	Attribute
		WHERE	[Name] = @attrName;
		PRINT('p_Attribute_Save: @attributeID: ' + convert(nvarchar, @attributeID));
		end
	else -- get any existing phrase ids to add a new translation
		begin
		SELECT	@attrName = [Name], @titlePhraseID = TitlePhraseID,
				@descriptionPhraseID = DescriptionPhraseID, @optionDisplayPhraseID = OptionDisplayPhraseID
		FROM	Attribute
		WHERE	AttributeID = @attributeID;
		PRINT('p_Attribute_Save: @attrName: ' + @attrName);
		end

	exec dbo.p_PhraseTranslation_Save null, @titlePhraseID out, @attrTitle, @languageID, @creatorID;
	exec dbo.p_PhraseTranslation_Save null, @descriptionPhraseID out, @attrDescription, @languageID, @creatorID;
	exec dbo.p_PhraseTranslation_Save null, @optionDisplayPhraseID out, @optionDisplay, @languageID, @creatorID;

	if @attributeID IS NULL OR @attributeID <= 0
		begin -- create
		PRINT('p_Attribute_Save> inserting attribute..');
		INSERT INTO dbo.Attribute([Name], TitlePhraseID, DescriptionPhraseID, OptionValues,
			OptionDisplayPhraseID, [Uid], CreatorID)
		VALUES(@attrName, @titlePhraseID, @descriptionPhraseID, @optionValues,
			@optionDisplayPhraseID, COALESCE(@uidNewAttribute, newid()), @creatorID);
		SET @attributeID = @@IDENTITY;
		exec dbo.p_AttributePath_Save @attributeID, @attrBaseNameList, @creatorID;
		end
	else -- modify
		begin
		UPDATE dbo.Attribute SET TitlePhraseID = @titlePhraseID, DescriptionPhraseID = @descriptionPhraseID,
		OptionValues = @optionDisplay, ModifyDate = getdate() WHERE AttributeID = @attributeID;
		if NOT @attrBaseNameList IS NULL AND LEN(@attrBaseNameList) > 0
			begin
			IF EXISTS(SELECT 1 FROM dbo.AttributePath WHERE AttributeID = @attributeID AND ValueType IS NULL)
				exec dbo.p_AttributePath_Save @attributeID, @attrBaseNameList, @creatorID;-- Attribute path had been never set before
			end
		end

	PRINT('p_Attribute_Save: ...end');
	return 0;
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 4/30/2016
-- Description:	Load Attributes flat file specification
-- Fields: Name, Base Names, Title, Description, OptionDisplay, OptionValues, Uid
-- Remarks: Base Names - comma-delimited list of base attribute names (any language)
-- =============================================
CREATE PROCEDURE [dbo].[p_Attribute_Import]
	@languageID int, -- valid language id
	@skipFirstLineCount int, -- number of first lines to skip
	@attrText nvarchar(max), -- Attribute flat file with standard columns
	@creatorID int = NULL -- valid creator id
AS
BEGIN
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
	DECLARE @attrName nvarchar(2048); -- attribute name
	DECLARE @attrBaseNameList nvarchar(max); -- comma-delimited list of Base Parameter Names
	DECLARE @attrTitle nvarchar(max); -- title
	DECLARE @attrDescription nvarchar(max); -- description
	DECLARE @optionDisplay nvarchar(max); -- Option Display
	DECLARE @optionValues nvarchar(max); -- Option Values for new attribute
	DECLARE @uidNewAttribute uniqueidentifier;

	if @attrText IS NULL
		return 1;
	SET @textLength = LEN(@attrText);
	if @textLength <= 0
		return 1;
	PRINT 'p_Attribute_Import> begin...';
	SET @iLineStart = 1;
	WHILE @iLineStart <= @textLength
		begin -- parse lines
		SET @iLineStop = CHARINDEX(@lineDelimiter, @attrText, @iLineStart);
		if @iLineStop <= 0
			SET @iLineStop = @textLength + 1;
		PRINT 'p_Attribute_Import> @textLength: ' + convert(nvarchar, @textLength) + '. iLineStop: ' + convert(nvarchar, @iLineStop);
		if @skipFirstLineCount > 0
			begin
			SET @skipFirstLineCount = @skipFirstLineCount - 1;
			PRINT 'p_Attribute_Import> line skipped';
			end
		else
			begin
			SET @lineLength = @iLineStop - @iLineStart;
			SET @lineText = SUBSTRING(@attrText, @iLineStart, @lineLength);
			PRINT 'p_Attribute_Import> line: ' + @lineText;

			-- fetch line fields..
			SET @attrName = NULL;
			SET @attrBaseNameList = NULL;
			SET @attrTitle = NULL;
			SET @attrDescription = NULL;
			SET @optionDisplay = NULL;
			SET @optionValues = NULL;
			SET @uidNewAttribute = newid();
			SET @fieldIndex = 0;
			SET @iFieldStart = 1;
			WHILE @iFieldStart <= @lineLength
				begin
				SET @iFieldStop = CHARINDEX(@fieldDelimiter, @lineText, @iFieldStart);
				if @iFieldStop <= 0
					SET @iFieldStop = @lineLength + 1;
				PRINT 'p_Attribute_Import> iFieldStop: ' + convert(nvarchar, @iFieldStop);
				SET @fieldValue = LTRIM(RTRIM(SUBSTRING(@lineText, @iFieldStart, @iFieldStop - @iFieldStart)));
				PRINT 'p_Attribute_Import> fieldValue: ' + @fieldValue;
				if @fieldIndex = 0
					SET @attrName = @fieldValue;
				else if @fieldIndex = 1
					SET @attrBaseNameList = @fieldValue;
				else if @fieldIndex = 2
					SET @attrTitle = @fieldValue;
				else if @fieldIndex = 3
					SET @attrDescription = @fieldValue;
				else if @fieldIndex = 4
					SET @optionDisplay = @fieldValue;
				else if @fieldIndex = 5
					SET @optionValues = @fieldValue;
				else if @fieldIndex = 6
					SET @uidNewAttribute = COALESCE(CONVERT(uniqueidentifier, @fieldValue), newid());

				SET @fieldIndex = @fieldIndex + 1; -- increment field index
				SET @iFieldStart = @iFieldStop + 1; -- advance beyond found field delimiter
				end
		
			PRINT 'p_Attribute_Import> saving: ' + @attrName;
			exec dbo.p_Attribute_Save null, @languageID, @attrName, @creatorID, @attrBaseNameList,
									@attrTitle, @attrDescription, @optionDisplay, @optionValues, @uidNewAttribute;
			PRINT 'p_Attribute_Import> saved: ' + @attrName;
			end
		SET @iLineStart = @iLineStop + 2; -- advance beyond found line delimiter
		end
	PRINT 'p_Attribute_Import> ...end';
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
	@factID int out, -- inout fact id
	@languageID int, -- valid language id
	@factName nvarchar(2048), -- valid name
	@creatorID int, -- valid creator id
	@attributeList nvarchar(max), -- comma-delimited list of Attribute Names/Values
	@factTitle nvarchar(max) = NULL, -- optional title
	@factDescription nvarchar(max) = NULL, -- optional description
	@uidNewFact uniqueidentifier = NULL
AS
BEGIN
	DECLARE @titlePhraseID int;
	DECLARE @descriptionPhraseID int;
	DECLARE @optionDisplayPhraseID int;
	DECLARE @isUpdate bit = 0;
	SET NOCOUNT ON;

	PRINT 'p_Fact_Save> begin..';
	if (@factID IS NULL OR @factID <= 0) AND NOT @factName IS NULL AND LEN(@factName) > 0
		-- if attribute invalid and name valid, use name to get get any existing phrase ids
		SELECT	@factID = FactID, @titlePhraseID = TitlePhraseID, @descriptionPhraseID = DescriptionPhraseID
		FROM	Fact
		WHERE	[Name] = @factName;
	else -- get any existing phrase ids to add a new translation
		SELECT	@factName = [Name], @titlePhraseID = TitlePhraseID, @descriptionPhraseID = DescriptionPhraseID
		FROM	Fact
		WHERE	FactID = @factID;

	exec dbo.p_PhraseTranslation_Save null, @titlePhraseID out, @factTitle, @languageID, @creatorID;
	exec dbo.p_PhraseTranslation_Save null, @descriptionPhraseID out, @factDescription, @languageID, @creatorID;

	if @factID IS NULL OR @factID <= 0
		begin -- create
		INSERT INTO dbo.Fact([Name], TitlePhraseID, DescriptionPhraseID, [Uid], CreatorID)
		VALUES(@factName, @titlePhraseID, @descriptionPhraseID, COALESCE(@uidNewFact, newid()), @creatorID);
		SET @factID = @@IDENTITY;
		end
	else
		begin -- update
		UPDATE	dbo.Fact SET TitlePhraseID = @titlePhraseID, DescriptionPhraseID = @descriptionPhraseID
		WHERE	FactID = @factID
		end

	if NOT @factID IS NULL AND NOT @attributeList IS NULL
		exec dbo.p_FactAttribute_Save null, @factID, @attributeList, @creatorID, @languageID

	PRINT 'p_Fact_Save> ..end';
	return 0;
END
GO

-- =============================================
-- Author:		ViakViak
-- Create date: 4/30/2016
-- Description:	Load Facts flat file specification
-- Fields: Name, Fact Attributes, Title, Description, Uid
-- =============================================
CREATE PROCEDURE [dbo].[p_Fact_Import]
	@languageID int, -- valid language id
	@skipFirstLineCount int, -- number of first lines to skip
	@factText nvarchar(max), -- Fact flat file with standard columns
	@creatorID int = NULL -- valid creator id
AS
BEGIN
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

			-- fetch line fields..
			SET @fieldIndex = 0;
			SET @iFieldStart = 1;
			SET @factName = NULL;
			SET @attributeList = NULL;
			SET @factTitle = NULL;
			SET @factDescription = NULL;
			SET @uidNewFact = newid();
			WHILE @iFieldStart <= @lineLength
				begin
				SET @iFieldStop = CHARINDEX(@fieldDelimiter, @lineText, @iFieldStart);
				if @iFieldStop <= 0
					SET @iFieldStop = @lineLength + 1;
				SET @fieldValue = LTRIM(RTRIM(SUBSTRING(@lineText, @iFieldStart, @iFieldStop - @iFieldStart)));

				if @fieldIndex = 0
					SET @factName = @fieldValue;
				else if @fieldIndex = 1
					SET @attributeList = @fieldValue;
				else if @fieldIndex = 2
					SET @factTitle = @fieldValue;
				else if @fieldIndex = 3
					SET @factDescription = @fieldValue;
				else if @fieldIndex = 4
					SET @uidNewFact = COALESCE(CONVERT(uniqueidentifier, @fieldValue), newid());

				SET @fieldIndex = @fieldIndex + 1; -- increment field index
				SET @iFieldStart = @iFieldStop + 1; -- advance beyond found field delimiter
				end
		
			exec dbo.p_Fact_Save null, @languageID, @factName, @creatorID, @attributeList,
									@factTitle, @factDescription, @uidNewFact;
			end
		SET @iLineStart = @iLineStop + 2; -- advance beyond found line delimiter
		end
	PRINT 'p_Fact_Import> ..end';
END
GO
