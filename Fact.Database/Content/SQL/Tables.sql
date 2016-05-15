-- Delete Fact Data

---- Delete AttributePath
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_AttributePath_Creator') AND parent_object_id = OBJECT_ID(N'dbo.AttributePath'))
	ALTER TABLE [dbo].[AttributePath] DROP CONSTRAINT [FK_AttributePath_Creator]
GO

IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_AttributePath_Attribute') AND parent_object_id = OBJECT_ID(N'dbo.AttributePath'))
	ALTER TABLE [dbo].[AttributePath] DROP CONSTRAINT [FK_AttributePath_Attribute]
GO

IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_AttributePath_OptionPhrase') AND parent_object_id = OBJECT_ID(N'dbo.AttributePath'))
	ALTER TABLE [dbo].[AttributePath] DROP CONSTRAINT [FK_AttributePath_OptionPhrase]
GO

---- Delete Fact
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_Fact_TitlePhrase') AND parent_object_id = OBJECT_ID(N'dbo.Fact'))
	ALTER TABLE [dbo].[Fact] DROP CONSTRAINT [FK_Fact_TitlePhrase]
GO

IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_Fact_DescriptionPhrase') AND parent_object_id = OBJECT_ID(N'dbo.Fact'))
	ALTER TABLE [dbo].[Fact] DROP CONSTRAINT [FK_Fact_DescriptionPhrase]
GO

---- Delete FactAttribute
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_FactAttribute_ValueTimePhrase') AND parent_object_id = OBJECT_ID(N'dbo.FactAttribute'))
	ALTER TABLE [dbo].[FactAttribute] DROP CONSTRAINT [FK_FactAttribute_ValueTimePhrase]
GO

IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_FactAttribute_ValueTimeDescriptionPhrase') AND parent_object_id = OBJECT_ID(N'dbo.FactAttribute'))
	ALTER TABLE [dbo].[FactAttribute] DROP CONSTRAINT [FK_FactAttribute_ValueTimeDescriptionPhrase]
GO

IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_FactAttribute_ValueTimeAgePhrase') AND parent_object_id = OBJECT_ID(N'dbo.FactAttribute'))
	ALTER TABLE [dbo].[FactAttribute] DROP CONSTRAINT [FK_FactAttribute_ValueTimeAgePhrase]
GO

IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_FactAttribute_ValueSeasonPhrase') AND parent_object_id = OBJECT_ID(N'dbo.FactAttribute'))
	ALTER TABLE [dbo].[FactAttribute] DROP CONSTRAINT [FK_FactAttribute_ValueSeasonPhrase]
GO

IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_FactAttribute_ValuePhrase') AND parent_object_id = OBJECT_ID(N'dbo.FactAttribute'))
	ALTER TABLE [dbo].[FactAttribute] DROP CONSTRAINT [FK_FactAttribute_ValuePhrase]
GO

IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_FactAttribute_Fact') AND parent_object_id = OBJECT_ID(N'dbo.FactAttribute'))
	ALTER TABLE [dbo].[FactAttribute] DROP CONSTRAINT [FK_FactAttribute_Fact]
GO

IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_FactAttribute_FactAttribute') AND parent_object_id = OBJECT_ID(N'dbo.FactAttribute'))
	ALTER TABLE [dbo].[FactAttribute] DROP CONSTRAINT [FK_FactAttribute_FactAttribute]
GO

---- Delete FactSet
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_FactSet_FactAttribute') AND parent_object_id = OBJECT_ID(N'dbo.FactSet'))
	ALTER TABLE [dbo].[FactSet] DROP CONSTRAINT [FK_FactSet_FactAttribute]
GO

IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_FactSet_Fact') AND parent_object_id = OBJECT_ID(N'dbo.FactSet'))
	ALTER TABLE [dbo].[FactSet] DROP CONSTRAINT [FK_FactSet_Fact]
GO

---- Delete Phrase
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_Phrase_FactPhrase') AND parent_object_id = OBJECT_ID(N'dbo.Phrase'))
	ALTER TABLE [dbo].[Phrase] DROP CONSTRAINT [FK_Phrase_FactPhrase]
GO

---- Delete Translation
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_Translation_PhraseTranslation') AND parent_object_id = OBJECT_ID(N'dbo.Translation'))
	ALTER TABLE [dbo].[Translation] DROP CONSTRAINT [FK_Translation_PhraseTranslation]
GO

IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_Translation_FactLanguage') AND parent_object_id = OBJECT_ID(N'dbo.Translation'))
	ALTER TABLE [dbo].[Translation] DROP CONSTRAINT [FK_Translation_FactLanguage]
GO

IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE
		object_id = OBJECT_ID(N'dbo.FK_Translation_FactCreator') AND parent_object_id = OBJECT_ID(N'dbo.Translation'))
	ALTER TABLE [dbo].[Translation] DROP CONSTRAINT [FK_Translation_FactCreator]
GO

/****** Object:  Table [dbo].[AttributePath]    Script Date: 4/17/2016 5:42:13 PM ******/
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'AttributePath') AND type = (N'U')) 
	DROP TABLE [dbo].[AttributePath]
GO

/****** Object:  Table [dbo].[Fact]    Script Date: 4/17/2016 5:49:08 PM ******/
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'Fact') AND type = (N'U')) 
	DROP TABLE [dbo].[Fact]
GO

/****** Object:  Table [dbo].[FactAttribute]    Script Date: 4/17/2016 5:51:00 PM ******/
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'FactAttribute') AND type = (N'U')) 
	DROP TABLE [dbo].[FactAttribute]
GO

/****** Object:  Table [dbo].[FactSet]    Script Date: 4/21/2016 9:49:55 PM ******/
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'FactSet') AND type = (N'U')) 
	DROP TABLE [dbo].[FactSet]
GO

/****** Object:  Table [dbo].[Phrase]    Script Date: 4/17/2016 6:13:54 PM ******/
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'Phrase') AND type = (N'U')) 
	DROP TABLE [dbo].[Phrase]
GO

/****** Object:  Table [dbo].[Translation]    Script Date: 4/24/2016 8:01:48 PM ******/
IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'Translation') AND type = (N'U')) 
	DROP TABLE [dbo].[Translation]
GO

-- Create Fact Data

/****** Object:  Table [dbo].[AttributePath]    Script Date: 4/17/2016 5:42:13 PM ******/
CREATE TABLE [dbo].[AttributePath](
	[AttributePathID] [int] IDENTITY(1,1) NOT NULL,
	[AttributeID] [int] NOT NULL,
	[Path] [varchar](max) NOT NULL,
	[ValueType] [varchar](2048) NOT NULL, -- root attribute name
	[OptionPhraseID] [int] NULL,
	[Uid] [uniqueidentifier] NOT NULL CONSTRAINT DF_AttributePath_Uid DEFAULT newid(),
	[CreatorID] [int] NULL,
	[CreateDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifyDate] [datetime] NULL,
 CONSTRAINT [PK_AttributePath] PRIMARY KEY CLUSTERED 
(
	[AttributePathID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Fact]    Script Date: 4/17/2016 5:49:08 PM ******/
CREATE TABLE [dbo].[Fact](
	[FactID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](2048) NOT NULL,
	[TitlePhraseID] [int] NULL,
	[DescriptionPhraseID] [int] NULL,
	[Uid] [uniqueidentifier] NOT NULL CONSTRAINT DF_Fact_Uid DEFAULT newid(),
	[CreatorID] [int] NULL,
	[CreateDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifyDate] [datetime] NULL,
	[DeleteDate] [datetime] NULL,
 CONSTRAINT [PK_Fact] PRIMARY KEY CLUSTERED 
(
	[FactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  Table [dbo].[FactAttribute]    Script Date: 4/17/2016 5:51:00 PM ******/
CREATE TABLE [dbo].[FactAttribute](
	[FactAttributeID] [int] IDENTITY(1,1) NOT NULL,
	[FactID] [int] NOT NULL,
	[AttributeID] [int] NOT NULL,
	[ValuePhraseID] [int] NULL,
	[ValueInteger] [int] NULL,
	[ValueReal] [real] NULL,
	[ValueCurrency] [money] NULL,
	[ValueGeoPoint] [geography] NULL,
	[ValueTime] [datetime] NULL,
	[ValueSeasonPhraseID] [int] NULL,
	[ValueDayOfWeek] [int] NULL,
	[ValueMonthNumber] [int] NULL,
	[ValueYear] [int] NULL,
	[ValueCentury] [int] NULL,
	[ValueTimeAgePhraseID] [int] NULL,
	[ValueTimePhraseID] [int] NULL,
	[ValueTimeDescriptionPhraseID] [int] NULL,
	[ValueText] [nvarchar](max) NULL,
	[ValueUid] [uniqueidentifier] NOT NULL CONSTRAINT DF_FactAttribute_ValueUid DEFAULT newid(),
	[Uid] [uniqueidentifier] NOT NULL CONSTRAINT DF_FactAttribute_Uid DEFAULT newid(),
	[CreatorID] [int] NULL,
	[CreateDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifyDate] [datetime] NULL,
	[DeleteDate] [datetime] NULL,
 CONSTRAINT [PK_FactAttribute] PRIMARY KEY CLUSTERED 
(
	[FactAttributeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[FactSet](
	[FactSetID] [int] IDENTITY(1,1) NOT NULL,
	[FactAttributeID] [int] NOT NULL,
	[FactID] [int] NOT NULL,
	[Sequence] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_FactSet] PRIMARY KEY CLUSTERED 
(
	[FactSetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Phrase]    Script Date: 4/17/2016 6:13:54 PM ******/
CREATE TABLE [dbo].[Phrase](
	[PhraseID] [int] IDENTITY(1,1) NOT NULL,
	[Uid] [uniqueidentifier] NOT NULL CONSTRAINT DF_Phrase_Uid DEFAULT newid(),
	[CreatorID] [int] NULL,
	[CreateDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifyDate] [datetime] NULL,
	[DeleteDate] [datetime] NULL,
 CONSTRAINT [PK_Phrase] PRIMARY KEY CLUSTERED 
(
	[PhraseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Translation]    Script Date: 4/24/2016 8:01:48 PM ******/
CREATE TABLE [dbo].[Translation](
	[TranslationID] [int] IDENTITY(1,1) NOT NULL,
	[PhraseID] [int] NOT NULL,
	[LanguageID] [int] NULL,
	[ValueTranslation] [nvarchar](max) NULL,
	[Uid] [uniqueidentifier] NOT NULL CONSTRAINT DF_Translation_Uid DEFAULT newid(),
	[CreatorID] [int] NULL,
	[CreateDate] [datetime] NOT NULL DEFAULT (getdate()),
	[ModifyDate] [datetime] NULL,
 CONSTRAINT [PK_Translation] PRIMARY KEY CLUSTERED 
(
	[TranslationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

---- Create AttributePath
ALTER TABLE [dbo].[AttributePath]  WITH CHECK ADD  CONSTRAINT [FK_AttributePath_Attribute] FOREIGN KEY([AttributeID])
REFERENCES [dbo].[Fact] ([FactID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[AttributePath] CHECK CONSTRAINT [FK_AttributePath_Attribute]
GO

ALTER TABLE [dbo].[AttributePath]  WITH CHECK ADD  CONSTRAINT [FK_AttributePath_Creator] FOREIGN KEY([CreatorID])
REFERENCES [dbo].[Fact] ([FactID])
GO

ALTER TABLE [dbo].[AttributePath] CHECK CONSTRAINT [FK_AttributePath_Creator]
GO

ALTER TABLE [dbo].[AttributePath]  WITH CHECK ADD  CONSTRAINT [FK_AttributePath_OptionPhrase] FOREIGN KEY([OptionPhraseID])
REFERENCES [dbo].[Phrase] ([PhraseID])
GO

ALTER TABLE [dbo].[AttributePath] CHECK CONSTRAINT [FK_AttributePath_OptionPhrase]
GO

---- Create Fact
ALTER TABLE [dbo].[Fact]  WITH CHECK ADD  CONSTRAINT [FK_Fact_DescriptionPhrase] FOREIGN KEY([DescriptionPhraseID])
REFERENCES [dbo].[Phrase] ([PhraseID])
GO

ALTER TABLE [dbo].[Fact] CHECK CONSTRAINT [FK_Fact_DescriptionPhrase]
GO

ALTER TABLE [dbo].[Fact]  WITH CHECK ADD  CONSTRAINT [FK_Fact_TitlePhrase] FOREIGN KEY([TitlePhraseID])
REFERENCES [dbo].[Phrase] ([PhraseID])
GO

ALTER TABLE [dbo].[Fact] CHECK CONSTRAINT [FK_Fact_TitlePhrase]
GO

---- Create FactAttribute
ALTER TABLE [dbo].[FactAttribute]  WITH CHECK ADD  CONSTRAINT [FK_FactAttribute_Fact] FOREIGN KEY([FactID])
REFERENCES [dbo].[Fact] ([FactID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[FactAttribute] CHECK CONSTRAINT [FK_FactAttribute_Fact]
GO

ALTER TABLE [dbo].[FactAttribute]  WITH CHECK ADD  CONSTRAINT [FK_FactAttribute_ValuePhrase] FOREIGN KEY([ValuePhraseID])
REFERENCES [dbo].[Phrase] ([PhraseID])
GO

ALTER TABLE [dbo].[FactAttribute] CHECK CONSTRAINT [FK_FactAttribute_ValuePhrase]
GO

ALTER TABLE [dbo].[FactAttribute]  WITH CHECK ADD  CONSTRAINT [FK_FactAttribute_ValueSeasonPhrase] FOREIGN KEY([ValueSeasonPhraseID])
REFERENCES [dbo].[Phrase] ([PhraseID])
GO

ALTER TABLE [dbo].[FactAttribute] CHECK CONSTRAINT [FK_FactAttribute_ValueSeasonPhrase]
GO

ALTER TABLE [dbo].[FactAttribute]  WITH CHECK ADD  CONSTRAINT [FK_FactAttribute_ValueTimeAgePhrase] FOREIGN KEY([ValueTimeAgePhraseID])
REFERENCES [dbo].[Phrase] ([PhraseID])
GO

ALTER TABLE [dbo].[FactAttribute] CHECK CONSTRAINT [FK_FactAttribute_ValueTimeAgePhrase]
GO

ALTER TABLE [dbo].[FactAttribute]  WITH CHECK ADD  CONSTRAINT [FK_FactAttribute_ValueTimeDescriptionPhrase] FOREIGN KEY([ValueTimeDescriptionPhraseID])
REFERENCES [dbo].[Phrase] ([PhraseID])
GO

ALTER TABLE [dbo].[FactAttribute] CHECK CONSTRAINT [FK_FactAttribute_ValueTimeDescriptionPhrase]
GO

ALTER TABLE [dbo].[FactAttribute]  WITH CHECK ADD  CONSTRAINT [FK_FactAttribute_ValueTimePhrase] FOREIGN KEY([ValueTimePhraseID])
REFERENCES [dbo].[Phrase] ([PhraseID])
GO

ALTER TABLE [dbo].[FactAttribute] CHECK CONSTRAINT [FK_FactAttribute_ValueTimePhrase]
GO

ALTER TABLE [dbo].[FactAttribute]  WITH CHECK ADD  CONSTRAINT [FK_FactAttribute_FactAttribute] FOREIGN KEY([AttributeID])
REFERENCES [dbo].[Fact] ([FactID])
GO

ALTER TABLE [dbo].[FactAttribute] CHECK CONSTRAINT [FK_FactAttribute_FactAttribute]
GO

---- Create FactSet
ALTER TABLE [dbo].[FactSet]  WITH CHECK ADD  CONSTRAINT [FK_FactSet_Fact] FOREIGN KEY([FactID])
REFERENCES [dbo].[Fact] ([FactID])
GO

ALTER TABLE [dbo].[FactSet] CHECK CONSTRAINT [FK_FactSet_Fact]
GO

ALTER TABLE [dbo].[FactSet]  WITH CHECK ADD  CONSTRAINT [FK_FactSet_FactAttribute] FOREIGN KEY([FactAttributeID])
REFERENCES [dbo].[FactAttribute] ([FactAttributeID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[FactSet] CHECK CONSTRAINT [FK_FactSet_FactAttribute]
GO

---- Create Phrase
ALTER TABLE [dbo].[Phrase]  WITH CHECK ADD  CONSTRAINT [FK_Phrase_FactPhrase] FOREIGN KEY([CreatorID])
REFERENCES [dbo].[Fact] ([FactID])
GO

ALTER TABLE [dbo].[Phrase] CHECK CONSTRAINT [FK_Phrase_FactPhrase]
GO

---- Create Translation
ALTER TABLE [dbo].[Translation]  WITH CHECK ADD  CONSTRAINT [FK_Translation_FactCreator] FOREIGN KEY([CreatorID])
REFERENCES [dbo].[Fact] ([FactID])
GO

ALTER TABLE [dbo].[Translation] CHECK CONSTRAINT [FK_Translation_FactCreator]
GO

ALTER TABLE [dbo].[Translation]  WITH CHECK ADD  CONSTRAINT [FK_Translation_FactLanguage] FOREIGN KEY([LanguageID])
REFERENCES [dbo].[Fact] ([FactID])
GO

ALTER TABLE [dbo].[Translation] CHECK CONSTRAINT [FK_Translation_FactLanguage]
GO

ALTER TABLE [dbo].[Translation]  WITH CHECK ADD  CONSTRAINT [FK_Translation_PhraseTranslation] FOREIGN KEY([PhraseID])
REFERENCES [dbo].[Phrase] ([PhraseID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Translation] CHECK CONSTRAINT [FK_Translation_PhraseTranslation]
GO

