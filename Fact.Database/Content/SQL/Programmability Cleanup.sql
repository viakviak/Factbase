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

/****** Object:  StoredProcedure [dbo].[p_Attribute_Save]    Script Date: 4/28/2016 7:20 PM ******/
IF OBJECT_ID(N'p_Attribute_Save', N'P') IS NOT NULL
	DROP PROCEDURE [dbo].[p_Attribute_Save]
GO

/****** Object:  StoredProcedure [dbo].[p_Attribute_Import]    Script Date: 4/30/2016 9:00 PM ******/
IF OBJECT_ID(N'p_Attribute_Import', N'P') IS NOT NULL
	DROP PROCEDURE [dbo].[p_Attribute_Import]
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
