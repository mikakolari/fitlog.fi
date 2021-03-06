USE [fitlog.fi]
GO
/****** Object:  Table [dbo].[Meal]    Script Date: 28.10.2018 11.28.03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Meal](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Time] [datetimeoffset](7) NOT NULL,
	[Created] [datetimeoffset](7) NOT NULL,
	[Deleted] [datetimeoffset](7) NULL,
	[DefinitionId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Meal] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MealRow]    Script Date: 28.10.2018 11.28.03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MealRow](
	[Id] [uniqueidentifier] NOT NULL,
	[MealId] [uniqueidentifier] NOT NULL,
	[Index] [int] NOT NULL,
	[FoodId] [uniqueidentifier] NOT NULL,
	[PortionId] [uniqueidentifier] NULL,
	[Quantity] [decimal](18, 4) NULL,
	[Weight] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK_MealRow] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[PortionUsage]    Script Date: 28.10.2018 11.28.03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PortionUsage]
AS
SELECT        dbo.Meal.UserId, dbo.MealRow.FoodId, dbo.MealRow.PortionId, COUNT(*) AS UsageCount
FROM            dbo.Meal INNER JOIN
                         dbo.MealRow ON dbo.MealRow.MealId = dbo.Meal.Id
GROUP BY dbo.Meal.UserId, dbo.MealRow.FoodId, dbo.MealRow.PortionId
GO
/****** Object:  View [dbo].[FoodUsage]    Script Date: 28.10.2018 11.28.03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[FoodUsage]
AS
SELECT        dbo.Meal.UserId, dbo.MealRow.FoodId, COUNT(dbo.MealRow.MealId) AS UsageCount, MAX(dbo.Meal.Time) AS LatestUse
FROM            dbo.Meal INNER JOIN
                         dbo.MealRow ON dbo.MealRow.MealId = dbo.Meal.Id
WHERE        (dbo.Meal.Deleted IS NULL)
GROUP BY dbo.Meal.UserId, dbo.MealRow.FoodId
GO
/****** Object:  Table [dbo].[Workout]    Script Date: 28.10.2018 11.28.03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Workout](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Time] [datetimeoffset](7) NOT NULL,
	[Duration] [time](7) NULL,
	[Deleted] [datetimeoffset](7) NULL,
 CONSTRAINT [PK_Workout] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkoutSet]    Script Date: 28.10.2018 11.28.03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkoutSet](
	[Id] [uniqueidentifier] NOT NULL,
	[WorkoutId] [uniqueidentifier] NOT NULL,
	[Index] [int] NOT NULL,
	[ExerciseId] [uniqueidentifier] NOT NULL,
	[Reps] [int] NOT NULL,
	[Weights] [decimal](8, 3) NULL,
	[WeightsBW] [decimal](8, 3) NULL,
	[Load] [decimal](8, 3) NULL,
	[LoadBW] [decimal](8, 3) NULL,
 CONSTRAINT [PK_WorkoutSet_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ExerciseVolume]    Script Date: 28.10.2018 11.28.03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ExerciseVolume]
AS
SELECT        W.Id AS WorkoutId, WS.ExerciseId, SUM(WS.Reps * WS.Weights) AS Volume
FROM            dbo.Workout AS W INNER JOIN
                         dbo.WorkoutSet AS WS ON WS.WorkoutId = W.Id
GROUP BY W.Id, WS.ExerciseId
GO
/****** Object:  Table [dbo].[Nutrient]    Script Date: 28.10.2018 11.28.03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Nutrient](
	[Name] [nvarchar](50) NOT NULL,
	[ShortName] [nvarchar](50) NULL,
	[Unit] [nvarchar](50) NOT NULL,
	[FineliId] [nvarchar](50) NULL,
	[FineliClass] [nvarchar](50) NULL,
	[FineliGroup] [nvarchar](50) NULL,
	[Precision] [int] NULL,
	[DefaultOrder] [int] NULL,
	[DefaultHideSummary] [bit] NULL,
	[DefaultHideDetails] [bit] NULL,
	[Deleted] [datetimeoffset](7) NULL,
	[Computed] [bit] NOT NULL,
	[Id] [int] NOT NULL,
 CONSTRAINT [PK_Nutrient] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MealRowNutrient]    Script Date: 28.10.2018 11.28.03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MealRowNutrient](
	[MealRowId] [uniqueidentifier] NOT NULL,
	[MealId] [uniqueidentifier] NOT NULL,
	[Amount] [decimal](18, 4) NULL,
	[NutrientId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[MealNutrient]    Script Date: 28.10.2018 11.28.03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MealNutrient]
AS
SELECT        MRN.MealId, MRN.NutrientId, SUM(MRN.Amount) AS Amount
FROM            dbo.MealRowNutrient AS MRN RIGHT OUTER JOIN
                         dbo.Nutrient AS N ON N.Id = MRN.NutrientId AND N.Computed = 0
GROUP BY MRN.MealId, MRN.NutrientId
GO
/****** Object:  Table [auth].[Login]    Script Date: 28.10.2018 11.28.03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [auth].[Login](
	[LoginProvider] [nvarchar](450) NOT NULL,
	[ProviderKey] [nvarchar](450) NOT NULL,
	[ProviderDisplayName] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Login] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [auth].[Role]    Script Date: 28.10.2018 11.28.03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [auth].[Role](
	[Id] [uniqueidentifier] NOT NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[Name] [nvarchar](256) NULL,
	[NormalizedName] [nvarchar](256) NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [auth].[RoleClaim]    Script Date: 28.10.2018 11.28.03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [auth].[RoleClaim](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_RoleClaim] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [auth].[User]    Script Date: 28.10.2018 11.28.04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [auth].[User](
	[Id] [uniqueidentifier] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[NormalizedEmail] [nvarchar](256) NULL,
	[NormalizedUserName] [nvarchar](256) NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[UserName] [nvarchar](256) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [auth].[UserClaim]    Script Date: 28.10.2018 11.28.04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [auth].[UserClaim](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_UserClaim] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [auth].[UserRole]    Script Date: 28.10.2018 11.28.04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [auth].[UserRole](
	[UserId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [auth].[UserToken]    Script Date: 28.10.2018 11.28.04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [auth].[UserToken](
	[UserId] [uniqueidentifier] NOT NULL,
	[LoginProvider] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](450) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_UserToken] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[LoginProvider] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 28.10.2018 11.28.04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Activity]    Script Date: 28.10.2018 11.28.04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Activity](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[EnergyExpenditure] [decimal](8, 5) NOT NULL,
	[Created] [datetimeoffset](7) NOT NULL,
	[Deleted] [datetimeoffset](7) NULL,
 CONSTRAINT [PK_Activity] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ActivityPreset]    Script Date: 28.10.2018 11.28.04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActivityPreset](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Sleep] [decimal](8, 4) NOT NULL,
	[Inactivity] [decimal](8, 4) NOT NULL,
	[LightActivity] [decimal](8, 4) NOT NULL,
	[ModerateActivity] [decimal](8, 4) NOT NULL,
	[HeavyActivity] [decimal](8, 4) NOT NULL,
	[Factor] [decimal](8, 4) NOT NULL,
	[Monday] [bit] NOT NULL,
	[Tuesday] [bit] NOT NULL,
	[Wednesday] [bit] NOT NULL,
	[Thursday] [bit] NOT NULL,
	[Friday] [bit] NOT NULL,
	[Saturday] [bit] NOT NULL,
	[Sunday] [bit] NOT NULL,
	[Created] [datetimeoffset](7) NOT NULL,
	[Deleted] [datetimeoffset](7) NULL,
 CONSTRAINT [PK_ActivityPreset] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DailyIntake]    Script Date: 28.10.2018 11.28.04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DailyIntake](
	[Id] [uniqueidentifier] NOT NULL,
	[Gender] [int] NOT NULL,
	[StartAge] [decimal](4, 1) NOT NULL,
	[EndAge] [decimal](4, 1) NULL,
	[MinAmount] [decimal](18, 4) NULL,
	[MaxAmount] [decimal](18, 4) NULL,
	[NutrientId] [int] NOT NULL,
 CONSTRAINT [PK_DailyIntake] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Day]    Script Date: 28.10.2018 11.28.04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Day](
	[UserId] [uniqueidentifier] NOT NULL,
	[Date] [datetimeoffset](7) NOT NULL,
	[ActivityPresetId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Day] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EnergyExpenditure]    Script Date: 28.10.2018 11.28.04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnergyExpenditure](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Time] [datetimeoffset](7) NOT NULL,
	[ActivityId] [uniqueidentifier] NULL,
	[Duration] [time](7) NULL,
	[ActivityName] [nvarchar](50) NULL,
	[EnergyKcal] [decimal](8, 4) NOT NULL,
	[WorkoutId] [uniqueidentifier] NULL,
	[Created] [datetimeoffset](7) NOT NULL,
	[Deleted] [datetimeoffset](7) NULL,
 CONSTRAINT [PK_EnergyExpenditure] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Equipment]    Script Date: 28.10.2018 11.28.04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Equipment](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Deleted] [datetimeoffset](7) NULL,
 CONSTRAINT [PK_Equipment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Exercise]    Script Date: 28.10.2018 11.28.04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exercise](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NULL,
	[Name] [nvarchar](100) NOT NULL,
	[PercentageBW] [int] NULL,
	[Created] [datetimeoffset](7) NOT NULL,
	[Deleted] [datetimeoffset](7) NULL,
	[Type] [nvarchar](50) NULL,
 CONSTRAINT [PK_Exercise] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExerciseEquipment]    Script Date: 28.10.2018 11.28.04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExerciseEquipment](
	[ExerciseId] [uniqueidentifier] NOT NULL,
	[EquipmentId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ExerciseEquipment] PRIMARY KEY CLUSTERED 
(
	[ExerciseId] ASC,
	[EquipmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExerciseImage]    Script Date: 28.10.2018 11.28.04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExerciseImage](
	[Id] [uniqueidentifier] NOT NULL,
	[ExerciseId] [uniqueidentifier] NOT NULL,
	[Data] [varbinary](max) NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ExerciseImage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExerciseTarget]    Script Date: 28.10.2018 11.28.05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExerciseTarget](
	[ExerciseId] [uniqueidentifier] NOT NULL,
	[MuscleGroupId] [uniqueidentifier] NOT NULL,
	[Type] [nvarchar](50) NULL,
 CONSTRAINT [PK_ExerciseTarget] PRIMARY KEY CLUSTERED 
(
	[ExerciseId] ASC,
	[MuscleGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Feedback]    Script Date: 28.10.2018 11.28.05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feedback](
	[Id] [uniqueidentifier] NOT NULL,
	[Type] [nvarchar](50) NULL,
	[UserId] [uniqueidentifier] NULL,
	[Title] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[AdminComment] [nvarchar](max) NULL,
	[Locked] [bit] NOT NULL,
	[VoteCount] [int] NOT NULL,
	[Created] [datetimeoffset](7) NOT NULL,
	[Deleted] [datetimeoffset](7) NULL,
 CONSTRAINT [PK_Feedback] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FeedbackComment]    Script Date: 28.10.2018 11.28.05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FeedbackComment](
	[Id] [uniqueidentifier] NOT NULL,
	[FeedbackId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NULL,
	[Content] [nvarchar](max) NOT NULL,
	[Created] [datetimeoffset](7) NOT NULL,
	[Deleted] [datetimeoffset](7) NULL,
 CONSTRAINT [PK_FeedbackComment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FeedbackVote]    Script Date: 28.10.2018 11.28.05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FeedbackVote](
	[Id] [uniqueidentifier] NOT NULL,
	[FeedbackId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NULL,
	[Time] [datetimeoffset](7) NOT NULL,
 CONSTRAINT [PK_FeedbackVote] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Food]    Script Date: 28.10.2018 11.28.05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Food](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NULL,
	[Name] [nvarchar](100) NOT NULL,
	[IsRecipe] [bit] NOT NULL,
	[FineliId] [nvarchar](50) NULL,
	[Created] [datetimeoffset](7) NULL,
	[Deleted] [datetimeoffset](7) NULL,
	[CookedWeight] [decimal](18, 4) NULL,
	[NutrientPortionId] [uniqueidentifier] NULL,
	[Manufacturer] [nvarchar](100) NULL,
	[Ean] [nvarchar](50) NULL,
 CONSTRAINT [PK_Food] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FoodNutrient]    Script Date: 28.10.2018 11.28.05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoodNutrient](
	[FoodId] [uniqueidentifier] NOT NULL,
	[Amount] [decimal](18, 4) NULL,
	[PortionAmount] [decimal](18, 4) NULL,
	[NutrientId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FoodPortion]    Script Date: 28.10.2018 11.28.05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoodPortion](
	[Id] [uniqueidentifier] NOT NULL,
	[FoodId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Weight] [decimal](18, 4) NOT NULL,
	[Amount] [decimal](18, 4) NULL,
 CONSTRAINT [PK_FoodPortion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LogDuration]    Script Date: 28.10.2018 11.28.05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogDuration](
	[Time] [datetimeoffset](7) NOT NULL,
	[Message] [nvarchar](50) NOT NULL,
	[Duration] [time](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LogException]    Script Date: 28.10.2018 11.28.05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogException](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Time] [datetimeoffset](7) NOT NULL,
	[Method] [nvarchar](10) NULL,
	[Path] [nvarchar](500) NULL,
	[Body] [nvarchar](max) NULL,
	[Exception] [nvarchar](max) NULL,
	[StackTrace] [nvarchar](max) NULL,
 CONSTRAINT [PK_LogException] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MealDefinition]    Script Date: 28.10.2018 11.28.05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MealDefinition](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Start] [time](7) NULL,
	[End] [time](7) NULL,
	[Created] [datetimeoffset](7) NOT NULL,
	[Deleted] [datetimeoffset](7) NULL,
 CONSTRAINT [PK_MealDefinition] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Measure]    Script Date: 28.10.2018 11.28.05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Measure](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Unit] [nvarchar](50) NULL,
 CONSTRAINT [PK_Measure] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Measurement]    Script Date: 28.10.2018 11.28.05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Measurement](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[MeasureId] [uniqueidentifier] NOT NULL,
	[Time] [datetimeoffset](7) NOT NULL,
	[Value] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK_Measurement] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MuscleGroup]    Script Date: 28.10.2018 11.28.05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MuscleGroup](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NULL,
 CONSTRAINT [PK_MuscleGroup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NutrientSettings]    Script Date: 28.10.2018 11.28.06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NutrientSettings](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[HideSummary] [bit] NULL,
	[HideDetails] [bit] NULL,
	[Order] [int] NULL,
	[HomeOrder] [int] NULL,
	[NutrientId] [int] NOT NULL,
 CONSTRAINT [PK_NutrientSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NutritionGoal]    Script Date: 28.10.2018 11.28.06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NutritionGoal](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
	[Created] [datetimeoffset](7) NOT NULL,
	[Deleted] [datetimeoffset](7) NULL,
 CONSTRAINT [PK_NutritionGoal_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NutritionGoalMeal]    Script Date: 28.10.2018 11.28.06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NutritionGoalMeal](
	[NutritionGoalPeriodId] [uniqueidentifier] NOT NULL,
	[MealDefinitionId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_NutritionGoalMeal] PRIMARY KEY CLUSTERED 
(
	[NutritionGoalPeriodId] ASC,
	[MealDefinitionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NutritionGoalPeriod]    Script Date: 28.10.2018 11.28.06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NutritionGoalPeriod](
	[Id] [uniqueidentifier] NOT NULL,
	[NutritionGoalId] [uniqueidentifier] NOT NULL,
	[Index] [int] NOT NULL,
	[Monday] [bit] NOT NULL,
	[Tuesday] [bit] NOT NULL,
	[Wednesday] [bit] NOT NULL,
	[Thursday] [bit] NOT NULL,
	[Friday] [bit] NOT NULL,
	[Saturday] [bit] NOT NULL,
	[Sunday] [bit] NOT NULL,
	[ExerciseDay] [bit] NOT NULL,
	[RestDay] [bit] NOT NULL,
	[WholeDay] [bit] NOT NULL,
 CONSTRAINT [PK_NutritionGoalTime] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NutritionGoalValue]    Script Date: 28.10.2018 11.28.06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NutritionGoalValue](
	[NutritionGoalPeriodId] [uniqueidentifier] NOT NULL,
	[Min] [decimal](18, 4) NULL,
	[Max] [decimal](18, 4) NULL,
	[NutrientId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OneRepMax]    Script Date: 28.10.2018 11.28.06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OneRepMax](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ExerciseId] [uniqueidentifier] NOT NULL,
	[Time] [datetimeoffset](7) NOT NULL,
	[Max] [decimal](8, 3) NOT NULL,
	[MaxBW] [decimal](8, 3) NULL,
	[MaxInclBW] [decimal](8, 3) NULL,
 CONSTRAINT [PK_OneRepMax] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Profile]    Script Date: 28.10.2018 11.28.06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Profile](
	[UserId] [uniqueidentifier] NOT NULL,
	[DoB] [datetime] NULL,
	[Gender] [nvarchar](50) NULL,
	[Rmr] [decimal](10, 4) NULL,
	[Height] [decimal](10, 4) NULL,
	[Weight] [decimal](10, 4) NULL,
	[RefreshToken] [nvarchar](100) NULL,
 CONSTRAINT [PK_Profile] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RecipeIngredient]    Script Date: 28.10.2018 11.28.06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecipeIngredient](
	[Id] [uniqueidentifier] NOT NULL,
	[RecipeId] [uniqueidentifier] NOT NULL,
	[Index] [int] NOT NULL,
	[FoodId] [uniqueidentifier] NOT NULL,
	[Quantity] [decimal](18, 4) NOT NULL,
	[PortionId] [uniqueidentifier] NULL,
	[Weight] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK_RecipeIngredient_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Routine]    Script Date: 28.10.2018 11.28.06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Routine](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Created] [datetimeoffset](7) NOT NULL,
	[Deleted] [datetimeoffset](7) NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Routine] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoutineExercise]    Script Date: 28.10.2018 11.28.06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoutineExercise](
	[Id] [uniqueidentifier] NOT NULL,
	[RoutineWorkoutId] [uniqueidentifier] NOT NULL,
	[Index] [int] NOT NULL,
	[ExerciseId] [uniqueidentifier] NOT NULL,
	[Sets] [int] NOT NULL,
	[Reps] [int] NOT NULL,
	[LoadFrom] [decimal](8, 3) NULL,
	[LoadTo] [decimal](8, 3) NULL,
 CONSTRAINT [PK_RoutineSet] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoutineWorkout]    Script Date: 28.10.2018 11.28.06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoutineWorkout](
	[Id] [uniqueidentifier] NOT NULL,
	[RoutineId] [uniqueidentifier] NOT NULL,
	[Index] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Frequency] [decimal](8, 3) NULL,
 CONSTRAINT [PK_RoutineWorkout] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TrainingGoal]    Script Date: 28.10.2018 11.28.06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrainingGoal](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Created] [datetimeoffset](7) NOT NULL,
	[Deleted] [datetimeoffset](7) NOT NULL,
 CONSTRAINT [PK_TrainingGoal] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TrainingGoalExercise]    Script Date: 28.10.2018 11.28.07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrainingGoalExercise](
	[Id] [uniqueidentifier] NOT NULL,
	[TrainingGoalId] [uniqueidentifier] NOT NULL,
	[Index] [int] NOT NULL,
	[ExerciseId] [uniqueidentifier] NOT NULL,
	[Sets] [int] NOT NULL,
	[Reps] [int] NOT NULL,
	[Frequency] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK_TrainingGoalExercise] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Feedback] ADD  CONSTRAINT [DF_Feedback_Locked]  DEFAULT ((0)) FOR [Locked]
GO
ALTER TABLE [dbo].[Feedback] ADD  CONSTRAINT [DF_Feedback_VoteCount]  DEFAULT ((0)) FOR [VoteCount]
GO
ALTER TABLE [dbo].[FeedbackVote] ADD  CONSTRAINT [DF_FeedbackVote_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Nutrient] ADD  CONSTRAINT [DF_Nutrient_DefaultOrder]  DEFAULT ((0)) FOR [DefaultOrder]
GO
ALTER TABLE [auth].[Login]  WITH CHECK ADD  CONSTRAINT [FK_Login_User_UserId] FOREIGN KEY([UserId])
REFERENCES [auth].[User] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [auth].[Login] CHECK CONSTRAINT [FK_Login_User_UserId]
GO
ALTER TABLE [auth].[RoleClaim]  WITH CHECK ADD  CONSTRAINT [FK_RoleClaim_Role_RoleId] FOREIGN KEY([RoleId])
REFERENCES [auth].[Role] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [auth].[RoleClaim] CHECK CONSTRAINT [FK_RoleClaim_Role_RoleId]
GO
ALTER TABLE [auth].[UserClaim]  WITH CHECK ADD  CONSTRAINT [FK_UserClaim_User_UserId] FOREIGN KEY([UserId])
REFERENCES [auth].[User] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [auth].[UserClaim] CHECK CONSTRAINT [FK_UserClaim_User_UserId]
GO
ALTER TABLE [auth].[UserRole]  WITH CHECK ADD  CONSTRAINT [FK_UserRole_Role_RoleId] FOREIGN KEY([RoleId])
REFERENCES [auth].[Role] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [auth].[UserRole] CHECK CONSTRAINT [FK_UserRole_Role_RoleId]
GO
ALTER TABLE [auth].[UserRole]  WITH CHECK ADD  CONSTRAINT [FK_UserRole_User_UserId] FOREIGN KEY([UserId])
REFERENCES [auth].[User] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [auth].[UserRole] CHECK CONSTRAINT [FK_UserRole_User_UserId]
GO
ALTER TABLE [dbo].[DailyIntake]  WITH NOCHECK ADD  CONSTRAINT [FK_DailyIntake_Nutrient] FOREIGN KEY([NutrientId])
REFERENCES [dbo].[Nutrient] ([Id])
GO
ALTER TABLE [dbo].[DailyIntake] CHECK CONSTRAINT [FK_DailyIntake_Nutrient]
GO
ALTER TABLE [dbo].[Exercise]  WITH CHECK ADD  CONSTRAINT [FK_Exercise_Profile] FOREIGN KEY([UserId])
REFERENCES [dbo].[Profile] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Exercise] CHECK CONSTRAINT [FK_Exercise_Profile]
GO
ALTER TABLE [dbo].[ExerciseEquipment]  WITH CHECK ADD  CONSTRAINT [FK_ExerciseEquipment_Equipment] FOREIGN KEY([EquipmentId])
REFERENCES [dbo].[Equipment] ([Id])
GO
ALTER TABLE [dbo].[ExerciseEquipment] CHECK CONSTRAINT [FK_ExerciseEquipment_Equipment]
GO
ALTER TABLE [dbo].[ExerciseEquipment]  WITH CHECK ADD  CONSTRAINT [FK_ExerciseEquipment_Exercise] FOREIGN KEY([ExerciseId])
REFERENCES [dbo].[Exercise] ([Id])
GO
ALTER TABLE [dbo].[ExerciseEquipment] CHECK CONSTRAINT [FK_ExerciseEquipment_Exercise]
GO
ALTER TABLE [dbo].[ExerciseImage]  WITH CHECK ADD  CONSTRAINT [FK_ExerciseImage_Exercise] FOREIGN KEY([ExerciseId])
REFERENCES [dbo].[Exercise] ([Id])
GO
ALTER TABLE [dbo].[ExerciseImage] CHECK CONSTRAINT [FK_ExerciseImage_Exercise]
GO
ALTER TABLE [dbo].[ExerciseTarget]  WITH CHECK ADD  CONSTRAINT [FK_ExerciseTarget_Exercise] FOREIGN KEY([ExerciseId])
REFERENCES [dbo].[Exercise] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ExerciseTarget] CHECK CONSTRAINT [FK_ExerciseTarget_Exercise]
GO
ALTER TABLE [dbo].[ExerciseTarget]  WITH CHECK ADD  CONSTRAINT [FK_ExerciseTarget_MuscleGroup] FOREIGN KEY([MuscleGroupId])
REFERENCES [dbo].[MuscleGroup] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ExerciseTarget] CHECK CONSTRAINT [FK_ExerciseTarget_MuscleGroup]
GO
ALTER TABLE [dbo].[Feedback]  WITH CHECK ADD  CONSTRAINT [FK_Feedback_Profile] FOREIGN KEY([UserId])
REFERENCES [dbo].[Profile] ([UserId])
GO
ALTER TABLE [dbo].[Feedback] CHECK CONSTRAINT [FK_Feedback_Profile]
GO
ALTER TABLE [dbo].[FeedbackComment]  WITH CHECK ADD  CONSTRAINT [FK_FeedbackComment_Feedback] FOREIGN KEY([FeedbackId])
REFERENCES [dbo].[Feedback] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FeedbackComment] CHECK CONSTRAINT [FK_FeedbackComment_Feedback]
GO
ALTER TABLE [dbo].[FeedbackComment]  WITH CHECK ADD  CONSTRAINT [FK_FeedbackComment_Profile] FOREIGN KEY([UserId])
REFERENCES [dbo].[Profile] ([UserId])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[FeedbackComment] CHECK CONSTRAINT [FK_FeedbackComment_Profile]
GO
ALTER TABLE [dbo].[FeedbackVote]  WITH CHECK ADD  CONSTRAINT [FK_FeedbackVote_Feedback] FOREIGN KEY([FeedbackId])
REFERENCES [dbo].[Feedback] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FeedbackVote] CHECK CONSTRAINT [FK_FeedbackVote_Feedback]
GO
ALTER TABLE [dbo].[FeedbackVote]  WITH CHECK ADD  CONSTRAINT [FK_FeedbackVote_Profile] FOREIGN KEY([UserId])
REFERENCES [dbo].[Profile] ([UserId])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[FeedbackVote] CHECK CONSTRAINT [FK_FeedbackVote_Profile]
GO
ALTER TABLE [dbo].[Food]  WITH CHECK ADD  CONSTRAINT [FK_Food_Profile] FOREIGN KEY([UserId])
REFERENCES [dbo].[Profile] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Food] CHECK CONSTRAINT [FK_Food_Profile]
GO
ALTER TABLE [dbo].[FoodNutrient]  WITH CHECK ADD  CONSTRAINT [FK_FoodNutrient_Food] FOREIGN KEY([FoodId])
REFERENCES [dbo].[Food] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FoodNutrient] CHECK CONSTRAINT [FK_FoodNutrient_Food]
GO
ALTER TABLE [dbo].[FoodNutrient]  WITH NOCHECK ADD  CONSTRAINT [FK_FoodNutrient_Nutrient] FOREIGN KEY([NutrientId])
REFERENCES [dbo].[Nutrient] ([Id])
GO
ALTER TABLE [dbo].[FoodNutrient] CHECK CONSTRAINT [FK_FoodNutrient_Nutrient]
GO
ALTER TABLE [dbo].[FoodPortion]  WITH CHECK ADD  CONSTRAINT [FK_FoodPortion_Food] FOREIGN KEY([FoodId])
REFERENCES [dbo].[Food] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FoodPortion] CHECK CONSTRAINT [FK_FoodPortion_Food]
GO
ALTER TABLE [dbo].[Meal]  WITH NOCHECK ADD  CONSTRAINT [FK_Meal_MealDefinition] FOREIGN KEY([DefinitionId])
REFERENCES [dbo].[MealDefinition] ([Id])
GO
ALTER TABLE [dbo].[Meal] CHECK CONSTRAINT [FK_Meal_MealDefinition]
GO
ALTER TABLE [dbo].[Meal]  WITH NOCHECK ADD  CONSTRAINT [FK_Meal_Profile] FOREIGN KEY([UserId])
REFERENCES [dbo].[Profile] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Meal] CHECK CONSTRAINT [FK_Meal_Profile]
GO
ALTER TABLE [dbo].[MealDefinition]  WITH CHECK ADD  CONSTRAINT [FK_MealDefinition_Profile] FOREIGN KEY([UserId])
REFERENCES [dbo].[Profile] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MealDefinition] CHECK CONSTRAINT [FK_MealDefinition_Profile]
GO
ALTER TABLE [dbo].[MealRow]  WITH NOCHECK ADD  CONSTRAINT [FK_MealRow_Food] FOREIGN KEY([FoodId])
REFERENCES [dbo].[Food] ([Id])
GO
ALTER TABLE [dbo].[MealRow] CHECK CONSTRAINT [FK_MealRow_Food]
GO
ALTER TABLE [dbo].[MealRow]  WITH NOCHECK ADD  CONSTRAINT [FK_MealRow_FoodPortion] FOREIGN KEY([PortionId])
REFERENCES [dbo].[FoodPortion] ([Id])
GO
ALTER TABLE [dbo].[MealRow] CHECK CONSTRAINT [FK_MealRow_FoodPortion]
GO
ALTER TABLE [dbo].[MealRow]  WITH NOCHECK ADD  CONSTRAINT [FK_MealRow_Meal] FOREIGN KEY([MealId])
REFERENCES [dbo].[Meal] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MealRow] CHECK CONSTRAINT [FK_MealRow_Meal]
GO
ALTER TABLE [dbo].[MealRowNutrient]  WITH NOCHECK ADD  CONSTRAINT [FK_MealRowNutrient_MealRow] FOREIGN KEY([MealRowId])
REFERENCES [dbo].[MealRow] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MealRowNutrient] CHECK CONSTRAINT [FK_MealRowNutrient_MealRow]
GO
ALTER TABLE [dbo].[MealRowNutrient]  WITH NOCHECK ADD  CONSTRAINT [FK_MealRowNutrient_Nutrient] FOREIGN KEY([NutrientId])
REFERENCES [dbo].[Nutrient] ([Id])
GO
ALTER TABLE [dbo].[MealRowNutrient] CHECK CONSTRAINT [FK_MealRowNutrient_Nutrient]
GO
ALTER TABLE [dbo].[Measure]  WITH CHECK ADD  CONSTRAINT [FK_Measure_Profile] FOREIGN KEY([UserId])
REFERENCES [dbo].[Profile] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Measure] CHECK CONSTRAINT [FK_Measure_Profile]
GO
ALTER TABLE [dbo].[Measurement]  WITH CHECK ADD  CONSTRAINT [FK_Measurement_Measure] FOREIGN KEY([MeasureId])
REFERENCES [dbo].[Measure] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Measurement] CHECK CONSTRAINT [FK_Measurement_Measure]
GO
ALTER TABLE [dbo].[Measurement]  WITH CHECK ADD  CONSTRAINT [FK_Measurement_Profile] FOREIGN KEY([UserId])
REFERENCES [dbo].[Profile] ([UserId])
GO
ALTER TABLE [dbo].[Measurement] CHECK CONSTRAINT [FK_Measurement_Profile]
GO
ALTER TABLE [dbo].[NutrientSettings]  WITH NOCHECK ADD  CONSTRAINT [FK_NutrientSettings_Nutrient] FOREIGN KEY([NutrientId])
REFERENCES [dbo].[Nutrient] ([Id])
GO
ALTER TABLE [dbo].[NutrientSettings] CHECK CONSTRAINT [FK_NutrientSettings_Nutrient]
GO
ALTER TABLE [dbo].[NutrientSettings]  WITH CHECK ADD  CONSTRAINT [FK_NutrientSettings_Profile] FOREIGN KEY([UserId])
REFERENCES [dbo].[Profile] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NutrientSettings] CHECK CONSTRAINT [FK_NutrientSettings_Profile]
GO
ALTER TABLE [dbo].[NutritionGoal]  WITH NOCHECK ADD  CONSTRAINT [FK_NutritionGoal_Profile] FOREIGN KEY([UserId])
REFERENCES [dbo].[Profile] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NutritionGoal] CHECK CONSTRAINT [FK_NutritionGoal_Profile]
GO
ALTER TABLE [dbo].[NutritionGoalMeal]  WITH NOCHECK ADD  CONSTRAINT [FK_NutritionGoalMeal_MealDefinition] FOREIGN KEY([MealDefinitionId])
REFERENCES [dbo].[MealDefinition] ([Id])
GO
ALTER TABLE [dbo].[NutritionGoalMeal] CHECK CONSTRAINT [FK_NutritionGoalMeal_MealDefinition]
GO
ALTER TABLE [dbo].[NutritionGoalMeal]  WITH NOCHECK ADD  CONSTRAINT [FK_NutritionGoalMeal_NutritionGoalTime] FOREIGN KEY([NutritionGoalPeriodId])
REFERENCES [dbo].[NutritionGoalPeriod] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NutritionGoalMeal] CHECK CONSTRAINT [FK_NutritionGoalMeal_NutritionGoalTime]
GO
ALTER TABLE [dbo].[NutritionGoalPeriod]  WITH NOCHECK ADD  CONSTRAINT [FK_NutritionGoalTime_NutritionGoal] FOREIGN KEY([NutritionGoalId])
REFERENCES [dbo].[NutritionGoal] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NutritionGoalPeriod] CHECK CONSTRAINT [FK_NutritionGoalTime_NutritionGoal]
GO
ALTER TABLE [dbo].[NutritionGoalValue]  WITH NOCHECK ADD  CONSTRAINT [FK_NutritionGoalValue_Nutrient] FOREIGN KEY([NutrientId])
REFERENCES [dbo].[Nutrient] ([Id])
GO
ALTER TABLE [dbo].[NutritionGoalValue] CHECK CONSTRAINT [FK_NutritionGoalValue_Nutrient]
GO
ALTER TABLE [dbo].[NutritionGoalValue]  WITH NOCHECK ADD  CONSTRAINT [FK_NutritionGoalValue_NutritionGoalTime] FOREIGN KEY([NutritionGoalPeriodId])
REFERENCES [dbo].[NutritionGoalPeriod] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NutritionGoalValue] CHECK CONSTRAINT [FK_NutritionGoalValue_NutritionGoalTime]
GO
ALTER TABLE [dbo].[OneRepMax]  WITH CHECK ADD  CONSTRAINT [FK_OneRepMax_Exercise] FOREIGN KEY([ExerciseId])
REFERENCES [dbo].[Exercise] ([Id])
GO
ALTER TABLE [dbo].[OneRepMax] CHECK CONSTRAINT [FK_OneRepMax_Exercise]
GO
ALTER TABLE [dbo].[OneRepMax]  WITH CHECK ADD  CONSTRAINT [FK_OneRepMax_Profile] FOREIGN KEY([UserId])
REFERENCES [dbo].[Profile] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OneRepMax] CHECK CONSTRAINT [FK_OneRepMax_Profile]
GO
ALTER TABLE [dbo].[RecipeIngredient]  WITH CHECK ADD  CONSTRAINT [FK_RecipeIngredient_Food] FOREIGN KEY([FoodId])
REFERENCES [dbo].[Food] ([Id])
GO
ALTER TABLE [dbo].[RecipeIngredient] CHECK CONSTRAINT [FK_RecipeIngredient_Food]
GO
ALTER TABLE [dbo].[RecipeIngredient]  WITH CHECK ADD  CONSTRAINT [FK_RecipeIngredient_Recipe] FOREIGN KEY([RecipeId])
REFERENCES [dbo].[Food] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RecipeIngredient] CHECK CONSTRAINT [FK_RecipeIngredient_Recipe]
GO
ALTER TABLE [dbo].[Routine]  WITH NOCHECK ADD  CONSTRAINT [FK_Routine_Profile] FOREIGN KEY([UserId])
REFERENCES [dbo].[Profile] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Routine] CHECK CONSTRAINT [FK_Routine_Profile]
GO
ALTER TABLE [dbo].[RoutineExercise]  WITH CHECK ADD  CONSTRAINT [FK_RoutineExercise_Exercise] FOREIGN KEY([ExerciseId])
REFERENCES [dbo].[Exercise] ([Id])
GO
ALTER TABLE [dbo].[RoutineExercise] CHECK CONSTRAINT [FK_RoutineExercise_Exercise]
GO
ALTER TABLE [dbo].[RoutineExercise]  WITH CHECK ADD  CONSTRAINT [FK_RoutineExercise_RoutineWorkout] FOREIGN KEY([RoutineWorkoutId])
REFERENCES [dbo].[RoutineWorkout] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RoutineExercise] CHECK CONSTRAINT [FK_RoutineExercise_RoutineWorkout]
GO
ALTER TABLE [dbo].[RoutineWorkout]  WITH NOCHECK ADD  CONSTRAINT [FK_RoutineWorkout_Routine] FOREIGN KEY([RoutineId])
REFERENCES [dbo].[Routine] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RoutineWorkout] CHECK CONSTRAINT [FK_RoutineWorkout_Routine]
GO
ALTER TABLE [dbo].[TrainingGoal]  WITH NOCHECK ADD  CONSTRAINT [FK_TrainingGoal_Profile] FOREIGN KEY([UserId])
REFERENCES [dbo].[Profile] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TrainingGoal] CHECK CONSTRAINT [FK_TrainingGoal_Profile]
GO
ALTER TABLE [dbo].[TrainingGoalExercise]  WITH CHECK ADD  CONSTRAINT [FK_TrainingGoalExercise_Exercise] FOREIGN KEY([ExerciseId])
REFERENCES [dbo].[Exercise] ([Id])
GO
ALTER TABLE [dbo].[TrainingGoalExercise] CHECK CONSTRAINT [FK_TrainingGoalExercise_Exercise]
GO
ALTER TABLE [dbo].[TrainingGoalExercise]  WITH NOCHECK ADD  CONSTRAINT [FK_TrainingGoalExercise_TrainingGoal] FOREIGN KEY([TrainingGoalId])
REFERENCES [dbo].[TrainingGoal] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TrainingGoalExercise] CHECK CONSTRAINT [FK_TrainingGoalExercise_TrainingGoal]
GO
ALTER TABLE [dbo].[Workout]  WITH CHECK ADD  CONSTRAINT [FK_Workout_Profile] FOREIGN KEY([UserId])
REFERENCES [dbo].[Profile] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Workout] CHECK CONSTRAINT [FK_Workout_Profile]
GO
ALTER TABLE [dbo].[WorkoutSet]  WITH CHECK ADD  CONSTRAINT [FK_WorkoutSet_Exercise] FOREIGN KEY([ExerciseId])
REFERENCES [dbo].[Exercise] ([Id])
GO
ALTER TABLE [dbo].[WorkoutSet] CHECK CONSTRAINT [FK_WorkoutSet_Exercise]
GO
ALTER TABLE [dbo].[WorkoutSet]  WITH CHECK ADD  CONSTRAINT [FK_WorkoutSet_Workout] FOREIGN KEY([WorkoutId])
REFERENCES [dbo].[Workout] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WorkoutSet] CHECK CONSTRAINT [FK_WorkoutSet_Workout]
GO
/****** Object:  StoredProcedure [dbo].[BACKUP_FULL]    Script Date: 28.10.2018 11.28.07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[BACKUP_FULL]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Url NVARCHAR(MAX)
	SET @Url= CONCAT(N'https://mikakolari.blob.core.windows.net/fitlog-backup/fitlog.fi_backup_', FORMAT(GETDATE(),'yyyyMMddHHmmss'), '.bak')

    BACKUP DATABASE [fitlog.fi] TO  URL = @Url WITH NOFORMAT, NOINIT,  NAME = N'fitlog.fi-Full Database Backup', NOSKIP, NOREWIND, NOUNLOAD,  STATS = 10
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "W"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "WS"
            Begin Extent = 
               Top = 6
               Left = 262
               Bottom = 136
               Right = 448
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ExerciseVolume'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ExerciseVolume'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MRN"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "N"
            Begin Extent = 
               Top = 6
               Left = 262
               Bottom = 136
               Right = 481
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MealNutrient'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MealNutrient'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Meal"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MealRow"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PortionUsage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PortionUsage'
GO
