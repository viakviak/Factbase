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