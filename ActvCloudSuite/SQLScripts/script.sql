USE [master]
GO
/****** Object:  Database [ACTV.NET_DB.MDF]    Script Date: 07/28/2015 07:29:54 ******/
CREATE DATABASE [ACTV.NET_DB.MDF] ON  PRIMARY 
( NAME = N'JukeBox.Net_DB', FILENAME = N'D:\ActvDb\ACTV.Net_DB.mdf' , SIZE = 17664KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'JukeBox.Net_DB_log', FILENAME = N'D:\ActvDb\ACTV.Net_DB_log.ldf' , SIZE = 560KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET COMPATIBILITY_LEVEL = 90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ACTV.NET_DB.MDF].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET ANSI_NULLS OFF
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET ANSI_PADDING OFF
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET ARITHABORT OFF
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET AUTO_CLOSE ON
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET AUTO_SHRINK ON
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET  DISABLE_BROKER
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET  READ_WRITE
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET RECOVERY SIMPLE
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET  MULTI_USER
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [ACTV.NET_DB.MDF] SET DB_CHAINING OFF
GO
USE [ACTV.NET_DB.MDF]
GO
/****** Object:  User [Jayachandra]    Script Date: 07/28/2015 07:29:54 ******/
CREATE USER [Jayachandra] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[MobileInfo]    Script Date: 07/28/2015 07:29:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MobileInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MacId] [varchar](50) NOT NULL,
	[EmpId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_DeviceInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MobileCollection]    Script Date: 07/28/2015 07:29:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MobileCollection](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RecieptNo] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Amount] [int] NOT NULL,
	[CollectionDate] [date] NOT NULL,
	[EmpId] [int] NOT NULL,
	[GpsLocation] [varchar](50) NULL,
	[LedgerUpdated] [varchar](1) NOT NULL,
 CONSTRAINT [PK_MobileCollection] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_MobileCollection] UNIQUE NONCLUSTERED 
(
	[RecieptNo] ASC,
	[CollectionDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[login_info]    Script Date: 07/28/2015 07:29:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[login_info](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NULL,
	[password] [varchar](50) NULL,
	[usertype] [varchar](50) NULL,
	[empid] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ACTVTransact]    Script Date: 07/28/2015 07:29:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ACTVTransact](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TransactId] [int] NOT NULL,
	[ReceiptNo] [int] NOT NULL,
	[AccountNo] [varchar](50) NOT NULL,
	[CollectionAmount] [int] NOT NULL,
	[CollectionDate] [datetime] NOT NULL,
	[InstalmentAmount] [int] NOT NULL,
	[Cancel] [varchar](2) NOT NULL,
	[AgentCode] [varchar](50) NOT NULL,
	[CollectionTime] [varchar](50) NULL,
	[LedgerUpdated] [varchar](3) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmployeeTable]    Script Date: 07/28/2015 07:29:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmployeeTable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeName] [varchar](50) NOT NULL,
	[MobileNumber] [varchar](50) NULL,
	[Address] [varchar](255) NULL,
 CONSTRAINT [PK_EmployeeTable] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_EmployeeTable] ON [dbo].[EmployeeTable] 
(
	[EmployeeName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConnectionStatusChangeTable]    Script Date: 07/28/2015 07:29:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ConnectionStatusChangeTable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerCode] [int] NOT NULL,
	[OldCustomerCode] [int] NOT NULL,
	[CustomerName] [varchar](255) NOT NULL,
	[AgentCode] [varchar](50) NOT NULL,
	[AgentName] [varchar](255) NOT NULL,
	[AreaCode] [int] NOT NULL,
	[AreaName] [varchar](255) NOT NULL,
	[OldAgentCode] [varchar](50) NOT NULL,
	[OldAgentName] [varchar](255) NOT NULL,
	[OldAreaCode] [int] NOT NULL,
	[OldAreaName] [varchar](255) NOT NULL,
	[Balance] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[Comments] [varchar](max) NOT NULL,
	[SfitingOrDisconnected] [varchar](1) NOT NULL,
	[StatusChangeDay] [int] NOT NULL,
	[StatusChangeMonth] [int] NOT NULL,
	[StatusChangeYear] [int] NOT NULL,
 CONSTRAINT [PK_ConnectionStatusChangeTable] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CompanyTable]    Script Date: 07/28/2015 07:29:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CompanyTable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [varchar](255) NOT NULL,
	[FinancialYear] [varchar](50) NOT NULL,
	[StartMonth] [int] NOT NULL,
	[EndMonth] [int] NOT NULL,
	[LastUpdateDate] [varchar](50) NOT NULL,
 CONSTRAINT [PK_CompanyTable] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_CompanyTable] UNIQUE NONCLUSTERED 
(
	[CompanyName] ASC,
	[FinancialYear] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BillingFrequncyTable]    Script Date: 07/28/2015 07:29:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BillingFrequncyTable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FrequncyName] [varchar](50) NULL,
	[NumberOfMonths] [int] NOT NULL,
 CONSTRAINT [PK_BillingFrequncyTable] PRIMARY KEY CLUSTERED 
(
	[NumberOfMonths] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AreaDetailsTable]    Script Date: 07/28/2015 07:29:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AreaDetailsTable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AreaCode] [int] NOT NULL,
	[AreaName] [varchar](255) NULL,
 CONSTRAINT [PK_AreaDetailsTable] PRIMARY KEY CLUSTERED 
(
	[AreaCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AgentDetailsTable]    Script Date: 07/28/2015 07:29:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AgentDetailsTable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AgentCode] [varchar](50) NOT NULL,
	[AreaCode] [int] NOT NULL,
	[EmpNum] [int] NOT NULL,
 CONSTRAINT [PK_AgentDetailsTable] PRIMARY KEY CLUSTERED 
(
	[AgentCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BillingCategoryTable]    Script Date: 07/28/2015 07:29:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BillingCategoryTable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryCode] [varchar](50) NOT NULL,
	[Amount] [int] NOT NULL,
	[Frequency] [int] NOT NULL,
	[OldID] [int] NOT NULL,
	[BillingPlan] [varchar](1) NULL,
 CONSTRAINT [PK_BillingCategoryTable] PRIMARY KEY CLUSTERED 
(
	[CategoryCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[ComanyYearView]    Script Date: 07/28/2015 07:29:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ComanyYearView]
AS
SELECT        ID, CompanyName + '-' + FinancialYear AS CompanyYear
FROM            dbo.CompanyTable
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
         Begin Table = "CompanyTable"
            Begin Extent = 
               Top = 18
               Left = 56
               Bottom = 222
               Right = 308
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 1245
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 630
         Or = 1245
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ComanyYearView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ComanyYearView'
GO
/****** Object:  Table [dbo].[CustomerDetailsTable]    Script Date: 07/28/2015 07:29:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomerDetailsTable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerCode] [int] NOT NULL,
	[CustomerName] [varchar](255) NOT NULL,
	[AgentCode] [varchar](50) NOT NULL,
	[AreaCode] [int] NOT NULL,
	[BillingCategory] [varchar](50) NOT NULL,
	[Address] [varchar](255) NOT NULL,
	[MobileNum] [varchar](50) NOT NULL,
	[ConnectionDate] [varchar](50) NOT NULL,
	[InitialBalance] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[Comments] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_CustomerDetailsTable_1] PRIMARY KEY CLUSTERED 
(
	[CustomerCode] ASC,
	[AreaCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CustomerDetailsTable] ON [dbo].[CustomerDetailsTable] 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CollectionTable]    Script Date: 07/28/2015 07:29:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CollectionTable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AgentCode] [varchar](50) NOT NULL,
	[CollectionAmount] [int] NOT NULL,
	[CollectionDate] [datetime] NOT NULL,
	[AmountPaid] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AmountCollectionTable]    Script Date: 07/28/2015 07:29:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AmountCollectionTable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmpID] [int] NOT NULL,
	[AgentCode] [varchar](50) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[CollectionAmount] [int] NOT NULL,
	[BillNum] [int] NOT NULL,
	[BillBookNum] [int] NULL,
	[CollectionDate] [varchar](50) NOT NULL,
 CONSTRAINT [PK__AmountCollection__72B0FDB1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TestCustomer]    Script Date: 07/28/2015 07:29:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestCustomer](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerNumber] [int] NULL,
 CONSTRAINT [PK_TestCustomer] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SMSTable]    Script Date: 07/28/2015 07:29:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMSTable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CustID] [int] NOT NULL,
	[CustMobNo] [varchar](13) NOT NULL,
	[SMSText] [varchar](200) NULL,
	[SMSDateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LedgerTable_Anuradha_Cable_TV_2014]    Script Date: 07/28/2015 07:29:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CustID] [int] NOT NULL,
	[CustCode] [int] NOT NULL,
	[AreaCode] [int] NOT NULL,
	[AgentCode] [varchar](50) NOT NULL,
	[OldBalance] [int] NOT NULL,
	[OldBalancePaymentDetails] [varchar](max) NULL,
	[NumOfMonthsBal] [int] NOT NULL,
	[TotalBalance] [int] NOT NULL,
	[TotalAmtPaid] [int] NOT NULL,
	[Bill_1] [varchar](50) NOT NULL,
	[Bill_2] [varchar](50) NOT NULL,
	[Bill_3] [varchar](50) NOT NULL,
	[Bill_4] [varchar](50) NOT NULL,
	[Bill_5] [varchar](50) NOT NULL,
	[Bill_6] [varchar](50) NOT NULL,
	[Bill_7] [varchar](50) NOT NULL,
	[Bill_8] [varchar](50) NOT NULL,
	[Bill_9] [varchar](50) NOT NULL,
	[Bill_10] [varchar](50) NOT NULL,
	[Bill_11] [varchar](50) NOT NULL,
	[Bill_12] [varchar](50) NOT NULL,
	[Amt_1] [varchar](100) NULL,
	[Amt_2] [varchar](100) NULL,
	[Amt_3] [varchar](100) NULL,
	[Amt_4] [varchar](100) NULL,
	[Amt_5] [varchar](100) NULL,
	[Amt_6] [varchar](100) NULL,
	[Amt_7] [varchar](100) NULL,
	[Amt_8] [varchar](100) NULL,
	[Amt_9] [varchar](100) NULL,
	[Amt_10] [varchar](100) NULL,
	[Amt_11] [varchar](100) NULL,
	[Amt_12] [varchar](100) NULL,
	[Date_1] [varchar](100) NULL,
	[Date_2] [varchar](100) NULL,
	[Date_3] [varchar](100) NULL,
	[Date_4] [varchar](100) NULL,
	[Date_5] [varchar](100) NULL,
	[Date_6] [varchar](100) NULL,
	[Date_7] [varchar](100) NULL,
	[Date_8] [varchar](100) NULL,
	[Date_9] [varchar](100) NULL,
	[Date_10] [varchar](100) NULL,
	[Date_11] [varchar](100) NULL,
	[Date_12] [varchar](100) NULL,
	[Bal_1] [varchar](100) NULL,
	[Bal_2] [varchar](100) NULL,
	[Bal_3] [varchar](100) NULL,
	[Bal_4] [varchar](100) NULL,
	[Bal_5] [varchar](100) NULL,
	[Bal_6] [varchar](100) NULL,
	[Bal_7] [varchar](100) NULL,
	[Bal_8] [varchar](100) NULL,
	[Bal_9] [varchar](100) NULL,
	[Bal_10] [varchar](100) NULL,
	[Bal_11] [varchar](100) NULL,
	[Bal_12] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LedgerTable_Anuradha_Cable_TV_2013]    Script Date: 07/28/2015 07:29:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CustID] [int] NOT NULL,
	[CustCode] [int] NOT NULL,
	[AreaCode] [int] NOT NULL,
	[AgentCode] [varchar](50) NOT NULL,
	[OldBalance] [int] NOT NULL,
	[OldBalancePaymentDetails] [varchar](max) NULL,
	[NumOfMonthsBal] [int] NOT NULL,
	[TotalBalance] [int] NOT NULL,
	[TotalAmtPaid] [int] NOT NULL,
	[Bill_1] [varchar](50) NOT NULL,
	[Bill_2] [varchar](50) NOT NULL,
	[Bill_3] [varchar](50) NOT NULL,
	[Bill_4] [varchar](50) NOT NULL,
	[Bill_5] [varchar](50) NOT NULL,
	[Bill_6] [varchar](50) NOT NULL,
	[Bill_7] [varchar](50) NOT NULL,
	[Bill_8] [varchar](50) NOT NULL,
	[Bill_9] [varchar](50) NOT NULL,
	[Bill_10] [varchar](50) NOT NULL,
	[Bill_11] [varchar](50) NOT NULL,
	[Bill_12] [varchar](50) NOT NULL,
	[Amt_1] [varchar](100) NULL,
	[Amt_2] [varchar](100) NULL,
	[Amt_3] [varchar](100) NULL,
	[Amt_4] [varchar](100) NULL,
	[Amt_5] [varchar](100) NULL,
	[Amt_6] [varchar](100) NULL,
	[Amt_7] [varchar](100) NULL,
	[Amt_8] [varchar](100) NULL,
	[Amt_9] [varchar](100) NULL,
	[Amt_10] [varchar](100) NULL,
	[Amt_11] [varchar](100) NULL,
	[Amt_12] [varchar](100) NULL,
	[Date_1] [varchar](100) NULL,
	[Date_2] [varchar](100) NULL,
	[Date_3] [varchar](100) NULL,
	[Date_4] [varchar](100) NULL,
	[Date_5] [varchar](100) NULL,
	[Date_6] [varchar](100) NULL,
	[Date_7] [varchar](100) NULL,
	[Date_8] [varchar](100) NULL,
	[Date_9] [varchar](100) NULL,
	[Date_10] [varchar](100) NULL,
	[Date_11] [varchar](100) NULL,
	[Date_12] [varchar](100) NULL,
	[Bal_1] [varchar](100) NULL,
	[Bal_2] [varchar](100) NULL,
	[Bal_3] [varchar](100) NULL,
	[Bal_4] [varchar](100) NULL,
	[Bal_5] [varchar](100) NULL,
	[Bal_6] [varchar](100) NULL,
	[Bal_7] [varchar](100) NULL,
	[Bal_8] [varchar](100) NULL,
	[Bal_9] [varchar](100) NULL,
	[Bal_10] [varchar](100) NULL,
	[Bal_11] [varchar](100) NULL,
	[Bal_12] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LedgerTable_Anuradha_Cable_TV_2012]    Script Date: 07/28/2015 07:29:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CustID] [int] NOT NULL,
	[CustCode] [int] NOT NULL,
	[AreaCode] [int] NOT NULL,
	[AgentCode] [varchar](50) NOT NULL,
	[OldBalance] [int] NOT NULL,
	[OldBalancePaymentDetails] [varchar](max) NULL,
	[NumOfMonthsBal] [int] NOT NULL,
	[TotalBalance] [int] NOT NULL,
	[TotalAmtPaid] [int] NOT NULL,
	[Bill_1] [varchar](50) NOT NULL,
	[Bill_2] [varchar](50) NOT NULL,
	[Bill_3] [varchar](50) NOT NULL,
	[Bill_4] [varchar](50) NOT NULL,
	[Bill_5] [varchar](50) NOT NULL,
	[Bill_6] [varchar](50) NOT NULL,
	[Bill_7] [varchar](50) NOT NULL,
	[Bill_8] [varchar](50) NOT NULL,
	[Bill_9] [varchar](50) NOT NULL,
	[Bill_10] [varchar](50) NOT NULL,
	[Bill_11] [varchar](50) NOT NULL,
	[Bill_12] [varchar](50) NOT NULL,
	[Amt_1] [varchar](100) NULL,
	[Amt_2] [varchar](100) NULL,
	[Amt_3] [varchar](100) NULL,
	[Amt_4] [varchar](100) NULL,
	[Amt_5] [varchar](100) NULL,
	[Amt_6] [varchar](100) NULL,
	[Amt_7] [varchar](100) NULL,
	[Amt_8] [varchar](100) NULL,
	[Amt_9] [varchar](100) NULL,
	[Amt_10] [varchar](100) NULL,
	[Amt_11] [varchar](100) NULL,
	[Amt_12] [varchar](100) NULL,
	[Date_1] [varchar](100) NULL,
	[Date_2] [varchar](100) NULL,
	[Date_3] [varchar](100) NULL,
	[Date_4] [varchar](100) NULL,
	[Date_5] [varchar](100) NULL,
	[Date_6] [varchar](100) NULL,
	[Date_7] [varchar](100) NULL,
	[Date_8] [varchar](100) NULL,
	[Date_9] [varchar](100) NULL,
	[Date_10] [varchar](100) NULL,
	[Date_11] [varchar](100) NULL,
	[Date_12] [varchar](100) NULL,
	[Bal_1] [varchar](100) NULL,
	[Bal_2] [varchar](100) NULL,
	[Bal_3] [varchar](100) NULL,
	[Bal_4] [varchar](100) NULL,
	[Bal_5] [varchar](100) NULL,
	[Bal_6] [varchar](100) NULL,
	[Bal_7] [varchar](100) NULL,
	[Bal_8] [varchar](100) NULL,
	[Bal_9] [varchar](100) NULL,
	[Bal_10] [varchar](100) NULL,
	[Bal_11] [varchar](100) NULL,
	[Bal_12] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LedgerTable_Anuradha_Cable_TV_2011]    Script Date: 07/28/2015 07:29:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CustID] [int] NOT NULL,
	[CustCode] [int] NOT NULL,
	[AreaCode] [int] NOT NULL,
	[AgentCode] [varchar](50) NOT NULL,
	[OldBalance] [int] NOT NULL,
	[OldBalancePaymentDetails] [varchar](max) NULL,
	[NumOfMonthsBal] [int] NOT NULL,
	[TotalBalance] [int] NOT NULL,
	[TotalAmtPaid] [int] NOT NULL,
	[Bill_1] [varchar](50) NOT NULL,
	[Bill_2] [varchar](50) NOT NULL,
	[Bill_3] [varchar](50) NOT NULL,
	[Bill_4] [varchar](50) NOT NULL,
	[Bill_5] [varchar](50) NOT NULL,
	[Bill_6] [varchar](50) NOT NULL,
	[Bill_7] [varchar](50) NOT NULL,
	[Bill_8] [varchar](50) NOT NULL,
	[Bill_9] [varchar](50) NOT NULL,
	[Bill_10] [varchar](50) NOT NULL,
	[Bill_11] [varchar](50) NOT NULL,
	[Bill_12] [varchar](50) NOT NULL,
	[Amt_1] [varchar](100) NULL,
	[Amt_2] [varchar](100) NULL,
	[Amt_3] [varchar](100) NULL,
	[Amt_4] [varchar](100) NULL,
	[Amt_5] [varchar](100) NULL,
	[Amt_6] [varchar](100) NULL,
	[Amt_7] [varchar](100) NULL,
	[Amt_8] [varchar](100) NULL,
	[Amt_9] [varchar](100) NULL,
	[Amt_10] [varchar](100) NULL,
	[Amt_11] [varchar](100) NULL,
	[Amt_12] [varchar](100) NULL,
	[Date_1] [varchar](100) NULL,
	[Date_2] [varchar](100) NULL,
	[Date_3] [varchar](100) NULL,
	[Date_4] [varchar](100) NULL,
	[Date_5] [varchar](100) NULL,
	[Date_6] [varchar](100) NULL,
	[Date_7] [varchar](100) NULL,
	[Date_8] [varchar](100) NULL,
	[Date_9] [varchar](100) NULL,
	[Date_10] [varchar](100) NULL,
	[Date_11] [varchar](100) NULL,
	[Date_12] [varchar](100) NULL,
	[Bal_1] [varchar](100) NULL,
	[Bal_2] [varchar](100) NULL,
	[Bal_3] [varchar](100) NULL,
	[Bal_4] [varchar](100) NULL,
	[Bal_5] [varchar](100) NULL,
	[Bal_6] [varchar](100) NULL,
	[Bal_7] [varchar](100) NULL,
	[Bal_8] [varchar](100) NULL,
	[Bal_9] [varchar](100) NULL,
	[Bal_10] [varchar](100) NULL,
	[Bal_11] [varchar](100) NULL,
	[Bal_12] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LedgerTable_Anuradha_Cable_TV_2010]    Script Date: 07/28/2015 07:29:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CustID] [int] NOT NULL,
	[CustCode] [int] NOT NULL,
	[AreaCode] [int] NOT NULL,
	[AgentCode] [varchar](50) NOT NULL,
	[OldBalance] [int] NOT NULL,
	[OldBalancePaymentDetails] [varchar](max) NULL,
	[NumOfMonthsBal] [int] NOT NULL,
	[TotalBalance] [int] NOT NULL,
	[TotalAmtPaid] [int] NOT NULL,
	[Bill_1] [varchar](50) NOT NULL,
	[Bill_2] [varchar](50) NOT NULL,
	[Bill_3] [varchar](50) NOT NULL,
	[Bill_4] [varchar](50) NOT NULL,
	[Bill_5] [varchar](50) NOT NULL,
	[Bill_6] [varchar](50) NOT NULL,
	[Bill_7] [varchar](50) NOT NULL,
	[Bill_8] [varchar](50) NOT NULL,
	[Bill_9] [varchar](50) NOT NULL,
	[Bill_10] [varchar](50) NOT NULL,
	[Bill_11] [varchar](50) NOT NULL,
	[Bill_12] [varchar](50) NOT NULL,
	[Amt_1] [varchar](50) NULL,
	[Amt_2] [varchar](50) NULL,
	[Amt_3] [varchar](50) NULL,
	[Amt_4] [varchar](50) NULL,
	[Amt_5] [varchar](50) NULL,
	[Amt_6] [varchar](50) NULL,
	[Amt_7] [varchar](50) NULL,
	[Amt_8] [varchar](50) NULL,
	[Amt_9] [varchar](50) NULL,
	[Amt_10] [varchar](50) NULL,
	[Amt_11] [varchar](50) NULL,
	[Amt_12] [varchar](50) NULL,
	[Date_1] [varchar](50) NULL,
	[Date_2] [varchar](50) NULL,
	[Date_3] [varchar](50) NULL,
	[Date_4] [varchar](50) NULL,
	[Date_5] [varchar](50) NULL,
	[Date_6] [varchar](50) NULL,
	[Date_7] [varchar](50) NULL,
	[Date_8] [varchar](50) NULL,
	[Date_9] [varchar](50) NULL,
	[Date_10] [varchar](50) NULL,
	[Date_11] [varchar](50) NULL,
	[Date_12] [varchar](50) NULL,
	[Bal_1] [varchar](50) NULL,
	[Bal_2] [varchar](50) NULL,
	[Bal_3] [varchar](50) NULL,
	[Bal_4] [varchar](50) NULL,
	[Bal_5] [varchar](50) NULL,
	[Bal_6] [varchar](50) NULL,
	[Bal_7] [varchar](50) NULL,
	[Bal_8] [varchar](50) NULL,
	[Bal_9] [varchar](50) NULL,
	[Bal_10] [varchar](50) NULL,
	[Bal_11] [varchar](50) NULL,
	[Bal_12] [varchar](50) NULL,
 CONSTRAINT [PK__LedgerTable_Anur__64CCF2AE] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LedgerTable]    Script Date: 07/28/2015 07:29:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LedgerTable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CustID] [int] NOT NULL,
	[CustCode] [int] NOT NULL,
	[AreaCode] [int] NOT NULL,
	[AgentCode] [varchar](50) NOT NULL,
	[OldBalance] [int] NOT NULL,
	[NumOfMonthsBal] [int] NOT NULL,
	[TotalBalance] [int] NOT NULL,
	[TotalAmtPaid] [int] NOT NULL,
	[Bill_1] [varchar](50) NOT NULL,
	[Bill_2] [varchar](50) NOT NULL,
	[Bill_3] [varchar](50) NOT NULL,
	[Bill_4] [varchar](50) NOT NULL,
	[Bill_5] [varchar](50) NOT NULL,
	[Bill_6] [varchar](50) NOT NULL,
	[Bill_7] [varchar](50) NOT NULL,
	[Bill_8] [varchar](50) NOT NULL,
	[Bill_9] [varchar](50) NOT NULL,
	[Bill_10] [varchar](50) NOT NULL,
	[Bill_11] [varchar](50) NOT NULL,
	[Bill_12] [varchar](50) NOT NULL,
	[Amt_1] [nchar](100) NULL,
	[Amt_2] [nchar](100) NULL,
	[Amt_3] [nchar](100) NULL,
	[Amt_4] [nchar](100) NULL,
	[Amt_5] [nchar](100) NULL,
	[Amt_6] [nchar](100) NULL,
	[Amt_7] [nchar](100) NULL,
	[Amt_8] [nchar](100) NULL,
	[Amt_9] [nchar](100) NULL,
	[Amt_10] [nchar](100) NULL,
	[Amt_11] [nchar](100) NULL,
	[Amt_12] [nchar](100) NULL,
	[Date_1] [nchar](100) NULL,
	[Date_2] [nchar](100) NULL,
	[Date_3] [nchar](100) NULL,
	[Date_4] [nchar](100) NULL,
	[Date_5] [nchar](100) NULL,
	[Date_6] [nchar](100) NULL,
	[Date_7] [nchar](100) NULL,
	[Date_8] [nchar](100) NULL,
	[Date_9] [nchar](100) NULL,
	[Date_10] [nchar](100) NULL,
	[Date_11] [nchar](100) NULL,
	[Date_12] [nchar](100) NULL,
	[Bal_1] [nchar](100) NULL,
	[Bal_2] [nchar](100) NULL,
	[Bal_3] [nchar](100) NULL,
	[Bal_4] [nchar](100) NULL,
	[Bal_5] [nchar](100) NULL,
	[Bal_6] [nchar](100) NULL,
	[Bal_7] [nchar](100) NULL,
	[Bal_8] [nchar](100) NULL,
	[Bal_9] [nchar](100) NULL,
	[Bal_10] [nchar](100) NULL,
	[Bal_11] [nchar](100) NULL,
	[Bal_12] [nchar](100) NULL,
 CONSTRAINT [PK_LedgerTable] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[LedgerCustomerView]    Script Date: 07/28/2015 07:29:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[LedgerCustomerView]
AS
SELECT        dbo.LedgerTable_test123_2009.CustCode, dbo.CustomerDetailsTable.CustomerCode, dbo.CustomerDetailsTable.CustomerName, 
                         dbo.CustomerDetailsTable.AgentCode, dbo.CustomerDetailsTable.BillingCategory, dbo.CustomerDetailsTable.AreaCode, dbo.LedgerTable_test123_2009.OldBalance, 
                         dbo.LedgerTable_test123_2009.NumOfMonthsBal, dbo.LedgerTable_test123_2009.TotalBalance, dbo.LedgerTable_test123_2009.TotalAmtPaid, 
                         dbo.LedgerTable_test123_2009.Bill_1
FROM            dbo.LedgerTable_test123_2009 INNER JOIN
                         dbo.CustomerDetailsTable ON dbo.LedgerTable_test123_2009.CustCode = dbo.CustomerDetailsTable.CustomerCode
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
         Begin Table = "LedgerTable_test123_2009"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CustomerDetailsTable"
            Begin Extent = 
               Top = 6
               Left = 262
               Bottom = 135
               Right = 437
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
      Begin ColumnWidths = 11
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'LedgerCustomerView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'LedgerCustomerView'
GO
/****** Object:  View [dbo].[LedgerCustomerbillingCategoryView]    Script Date: 07/28/2015 07:29:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[LedgerCustomerbillingCategoryView]
AS
SELECT        dbo.CustomerDetailsTable.CustomerCode, dbo.CustomerDetailsTable.BillingCategory, dbo.BillingCategoryTable.CategoryCode, 
                         dbo.CustomerDetailsTable.CustomerName, dbo.BillingCategoryTable.Amount, dbo.BillingCategoryTable.Frequency, dbo.LedgerTable_test123_2009.CustID, 
                         dbo.LedgerTable_test123_2009.CustCode, dbo.LedgerTable_test123_2009.AreaCode, dbo.LedgerTable_test123_2009.AgentCode, 
                         dbo.LedgerTable_test123_2009.OldBalance, dbo.LedgerTable_test123_2009.NumOfMonthsBal, dbo.LedgerTable_test123_2009.TotalBalance, 
                         dbo.LedgerTable_test123_2009.TotalAmtPaid, dbo.LedgerTable_test123_2009.Bill_1, dbo.LedgerTable_test123_2009.Bill_2, dbo.LedgerTable_test123_2009.Bill_3, 
                         dbo.LedgerTable_test123_2009.Bill_4, dbo.LedgerTable_test123_2009.Bill_5, dbo.LedgerTable_test123_2009.Bill_6, dbo.LedgerTable_test123_2009.Bill_7, 
                         dbo.LedgerTable_test123_2009.Bill_8, dbo.LedgerTable_test123_2009.Bill_9, dbo.LedgerTable_test123_2009.Bill_10, dbo.LedgerTable_test123_2009.Bill_11, 
                         dbo.LedgerTable_test123_2009.Bill_12, dbo.LedgerTable_test123_2009.Bal_1, dbo.LedgerTable_test123_2009.Bal_2, dbo.LedgerTable_test123_2009.Bal_3, 
                         dbo.LedgerTable_test123_2009.Bal_4, dbo.LedgerTable_test123_2009.Bal_5, dbo.LedgerTable_test123_2009.Bal_6, dbo.LedgerTable_test123_2009.Bal_7, 
                         dbo.LedgerTable_test123_2009.Bal_8, dbo.LedgerTable_test123_2009.Bal_9, dbo.LedgerTable_test123_2009.Bal_10, dbo.LedgerTable_test123_2009.Bal_11, 
                         dbo.LedgerTable_test123_2009.Bal_12
FROM            dbo.CustomerDetailsTable INNER JOIN
                         dbo.BillingCategoryTable ON dbo.CustomerDetailsTable.BillingCategory = dbo.BillingCategoryTable.CategoryCode INNER JOIN
                         dbo.LedgerTable_test123_2009 ON dbo.CustomerDetailsTable.CustomerCode = dbo.LedgerTable_test123_2009.CustCode
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
         Begin Table = "CustomerDetailsTable"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 213
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BillingCategoryTable"
            Begin Extent = 
               Top = 6
               Left = 251
               Bottom = 135
               Right = 421
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LedgerTable_test123_2009"
            Begin Extent = 
               Top = 6
               Left = 459
               Bottom = 135
               Right = 645
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
      Begin ColumnWidths = 11
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'LedgerCustomerbillingCategoryView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'LedgerCustomerbillingCategoryView'
GO
/****** Object:  Default [DF_MobileCollection_LedgerUpdated]    Script Date: 07/28/2015 07:29:57 ******/
ALTER TABLE [dbo].[MobileCollection] ADD  CONSTRAINT [DF_MobileCollection_LedgerUpdated]  DEFAULT ('f') FOR [LedgerUpdated]
GO
/****** Object:  Default [DF__login_inf__empid__70C8B53F]    Script Date: 07/28/2015 07:29:57 ******/
ALTER TABLE [dbo].[login_info] ADD  DEFAULT ((-1)) FOR [empid]
GO
/****** Object:  Default [DF_CompanyTable_StartMonth]    Script Date: 07/28/2015 07:29:57 ******/
ALTER TABLE [dbo].[CompanyTable] ADD  CONSTRAINT [DF_CompanyTable_StartMonth]  DEFAULT ((1)) FOR [StartMonth]
GO
/****** Object:  Default [DF_CompanyTable_EndMonth]    Script Date: 07/28/2015 07:29:57 ******/
ALTER TABLE [dbo].[CompanyTable] ADD  CONSTRAINT [DF_CompanyTable_EndMonth]  DEFAULT ((12)) FOR [EndMonth]
GO
/****** Object:  Default [DF_CompanyTable_LastUpdateDate]    Script Date: 07/28/2015 07:29:57 ******/
ALTER TABLE [dbo].[CompanyTable] ADD  CONSTRAINT [DF_CompanyTable_LastUpdateDate]  DEFAULT ('-') FOR [LastUpdateDate]
GO
/****** Object:  Default [DF_BillingCategoryTable_OldID]    Script Date: 07/28/2015 07:29:57 ******/
ALTER TABLE [dbo].[BillingCategoryTable] ADD  CONSTRAINT [DF_BillingCategoryTable_OldID]  DEFAULT ((1)) FOR [OldID]
GO
/****** Object:  Default [DF__BillingCa__Billi__30AE302A]    Script Date: 07/28/2015 07:29:57 ******/
ALTER TABLE [dbo].[BillingCategoryTable] ADD  DEFAULT ('') FOR [BillingPlan]
GO
/****** Object:  Default [DF_CustomerDetailsTable_InitialBalance]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[CustomerDetailsTable] ADD  CONSTRAINT [DF_CustomerDetailsTable_InitialBalance]  DEFAULT ((0)) FOR [InitialBalance]
GO
/****** Object:  Default [DF_CustomerDetailsTable_Active]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[CustomerDetailsTable] ADD  CONSTRAINT [DF_CustomerDetailsTable_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  Default [DF__LedgerTab__OldBa__7E22B05D]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ((0)) FOR [OldBalance]
GO
/****** Object:  Default [DF__LedgerTab__OldBa__7F16D496]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [OldBalancePaymentDetails]
GO
/****** Object:  Default [DF__LedgerTab__Bill___000AF8CF]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('-1') FOR [Bill_1]
GO
/****** Object:  Default [DF__LedgerTab__Bill___00FF1D08]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('-1') FOR [Bill_2]
GO
/****** Object:  Default [DF__LedgerTab__Bill___01F34141]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('-1') FOR [Bill_3]
GO
/****** Object:  Default [DF__LedgerTab__Bill___02E7657A]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('-1') FOR [Bill_4]
GO
/****** Object:  Default [DF__LedgerTab__Bill___03DB89B3]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('-1') FOR [Bill_5]
GO
/****** Object:  Default [DF__LedgerTab__Bill___04CFADEC]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('-1') FOR [Bill_6]
GO
/****** Object:  Default [DF__LedgerTab__Bill___05C3D225]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('-1') FOR [Bill_7]
GO
/****** Object:  Default [DF__LedgerTab__Bill___06B7F65E]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('-1') FOR [Bill_8]
GO
/****** Object:  Default [DF__LedgerTab__Bill___07AC1A97]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('-1') FOR [Bill_9]
GO
/****** Object:  Default [DF__LedgerTab__Bill___08A03ED0]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('-1') FOR [Bill_10]
GO
/****** Object:  Default [DF__LedgerTab__Bill___09946309]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('-1') FOR [Bill_11]
GO
/****** Object:  Default [DF__LedgerTab__Bill___0A888742]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('-1') FOR [Bill_12]
GO
/****** Object:  Default [DF__LedgerTab__Amt_1__0B7CAB7B]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Amt_1]
GO
/****** Object:  Default [DF__LedgerTab__Amt_2__0C70CFB4]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Amt_2]
GO
/****** Object:  Default [DF__LedgerTab__Amt_3__0D64F3ED]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Amt_3]
GO
/****** Object:  Default [DF__LedgerTab__Amt_4__0E591826]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Amt_4]
GO
/****** Object:  Default [DF__LedgerTab__Amt_5__0F4D3C5F]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Amt_5]
GO
/****** Object:  Default [DF__LedgerTab__Amt_6__10416098]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Amt_6]
GO
/****** Object:  Default [DF__LedgerTab__Amt_7__113584D1]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Amt_7]
GO
/****** Object:  Default [DF__LedgerTab__Amt_8__1229A90A]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Amt_8]
GO
/****** Object:  Default [DF__LedgerTab__Amt_9__131DCD43]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Amt_9]
GO
/****** Object:  Default [DF__LedgerTab__Amt_1__1411F17C]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Amt_10]
GO
/****** Object:  Default [DF__LedgerTab__Amt_1__150615B5]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Amt_11]
GO
/****** Object:  Default [DF__LedgerTab__Amt_1__15FA39EE]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Amt_12]
GO
/****** Object:  Default [DF__LedgerTab__Date___16EE5E27]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Date_1]
GO
/****** Object:  Default [DF__LedgerTab__Date___17E28260]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Date_2]
GO
/****** Object:  Default [DF__LedgerTab__Date___18D6A699]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Date_3]
GO
/****** Object:  Default [DF__LedgerTab__Date___19CACAD2]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Date_4]
GO
/****** Object:  Default [DF__LedgerTab__Date___1ABEEF0B]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Date_5]
GO
/****** Object:  Default [DF__LedgerTab__Date___1BB31344]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Date_6]
GO
/****** Object:  Default [DF__LedgerTab__Date___1CA7377D]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Date_7]
GO
/****** Object:  Default [DF__LedgerTab__Date___1D9B5BB6]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Date_8]
GO
/****** Object:  Default [DF__LedgerTab__Date___1E8F7FEF]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Date_9]
GO
/****** Object:  Default [DF__LedgerTab__Date___1F83A428]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Date_10]
GO
/****** Object:  Default [DF__LedgerTab__Date___2077C861]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Date_11]
GO
/****** Object:  Default [DF__LedgerTab__Date___216BEC9A]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Date_12]
GO
/****** Object:  Default [DF__LedgerTab__Bal_1__226010D3]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Bal_1]
GO
/****** Object:  Default [DF__LedgerTab__Bal_2__2354350C]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Bal_2]
GO
/****** Object:  Default [DF__LedgerTab__Bal_3__24485945]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Bal_3]
GO
/****** Object:  Default [DF__LedgerTab__Bal_4__253C7D7E]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Bal_4]
GO
/****** Object:  Default [DF__LedgerTab__Bal_5__2630A1B7]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Bal_5]
GO
/****** Object:  Default [DF__LedgerTab__Bal_6__2724C5F0]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Bal_6]
GO
/****** Object:  Default [DF__LedgerTab__Bal_7__2818EA29]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Bal_7]
GO
/****** Object:  Default [DF__LedgerTab__Bal_8__290D0E62]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Bal_8]
GO
/****** Object:  Default [DF__LedgerTab__Bal_9__2A01329B]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Bal_9]
GO
/****** Object:  Default [DF__LedgerTab__Bal_1__2AF556D4]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Bal_10]
GO
/****** Object:  Default [DF__LedgerTab__Bal_1__2BE97B0D]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Bal_11]
GO
/****** Object:  Default [DF__LedgerTab__Bal_1__2CDD9F46]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014] ADD  DEFAULT ('') FOR [Bal_12]
GO
/****** Object:  Default [DF__LedgerTab__OldBa__3E3D3572]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ((0)) FOR [OldBalance]
GO
/****** Object:  Default [DF__LedgerTab__OldBa__3F3159AB]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [OldBalancePaymentDetails]
GO
/****** Object:  Default [DF__LedgerTab__Bill___40257DE4]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('-1') FOR [Bill_1]
GO
/****** Object:  Default [DF__LedgerTab__Bill___4119A21D]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('-1') FOR [Bill_2]
GO
/****** Object:  Default [DF__LedgerTab__Bill___420DC656]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('-1') FOR [Bill_3]
GO
/****** Object:  Default [DF__LedgerTab__Bill___4301EA8F]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('-1') FOR [Bill_4]
GO
/****** Object:  Default [DF__LedgerTab__Bill___43F60EC8]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('-1') FOR [Bill_5]
GO
/****** Object:  Default [DF__LedgerTab__Bill___44EA3301]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('-1') FOR [Bill_6]
GO
/****** Object:  Default [DF__LedgerTab__Bill___45DE573A]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('-1') FOR [Bill_7]
GO
/****** Object:  Default [DF__LedgerTab__Bill___46D27B73]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('-1') FOR [Bill_8]
GO
/****** Object:  Default [DF__LedgerTab__Bill___47C69FAC]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('-1') FOR [Bill_9]
GO
/****** Object:  Default [DF__LedgerTab__Bill___48BAC3E5]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('-1') FOR [Bill_10]
GO
/****** Object:  Default [DF__LedgerTab__Bill___49AEE81E]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('-1') FOR [Bill_11]
GO
/****** Object:  Default [DF__LedgerTab__Bill___4AA30C57]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('-1') FOR [Bill_12]
GO
/****** Object:  Default [DF__LedgerTab__Amt_1__4B973090]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Amt_1]
GO
/****** Object:  Default [DF__LedgerTab__Amt_2__4C8B54C9]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Amt_2]
GO
/****** Object:  Default [DF__LedgerTab__Amt_3__4D7F7902]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Amt_3]
GO
/****** Object:  Default [DF__LedgerTab__Amt_4__4E739D3B]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Amt_4]
GO
/****** Object:  Default [DF__LedgerTab__Amt_5__4F67C174]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Amt_5]
GO
/****** Object:  Default [DF__LedgerTab__Amt_6__505BE5AD]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Amt_6]
GO
/****** Object:  Default [DF__LedgerTab__Amt_7__515009E6]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Amt_7]
GO
/****** Object:  Default [DF__LedgerTab__Amt_8__52442E1F]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Amt_8]
GO
/****** Object:  Default [DF__LedgerTab__Amt_9__53385258]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Amt_9]
GO
/****** Object:  Default [DF__LedgerTab__Amt_1__542C7691]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Amt_10]
GO
/****** Object:  Default [DF__LedgerTab__Amt_1__55209ACA]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Amt_11]
GO
/****** Object:  Default [DF__LedgerTab__Amt_1__5614BF03]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Amt_12]
GO
/****** Object:  Default [DF__LedgerTab__Date___5708E33C]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Date_1]
GO
/****** Object:  Default [DF__LedgerTab__Date___57FD0775]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Date_2]
GO
/****** Object:  Default [DF__LedgerTab__Date___58F12BAE]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Date_3]
GO
/****** Object:  Default [DF__LedgerTab__Date___59E54FE7]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Date_4]
GO
/****** Object:  Default [DF__LedgerTab__Date___5AD97420]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Date_5]
GO
/****** Object:  Default [DF__LedgerTab__Date___5BCD9859]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Date_6]
GO
/****** Object:  Default [DF__LedgerTab__Date___5CC1BC92]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Date_7]
GO
/****** Object:  Default [DF__LedgerTab__Date___5DB5E0CB]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Date_8]
GO
/****** Object:  Default [DF__LedgerTab__Date___5EAA0504]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Date_9]
GO
/****** Object:  Default [DF__LedgerTab__Date___5F9E293D]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Date_10]
GO
/****** Object:  Default [DF__LedgerTab__Date___60924D76]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Date_11]
GO
/****** Object:  Default [DF__LedgerTab__Date___618671AF]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Date_12]
GO
/****** Object:  Default [DF__LedgerTab__Bal_1__627A95E8]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Bal_1]
GO
/****** Object:  Default [DF__LedgerTab__Bal_2__636EBA21]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Bal_2]
GO
/****** Object:  Default [DF__LedgerTab__Bal_3__6462DE5A]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Bal_3]
GO
/****** Object:  Default [DF__LedgerTab__Bal_4__65570293]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Bal_4]
GO
/****** Object:  Default [DF__LedgerTab__Bal_5__664B26CC]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Bal_5]
GO
/****** Object:  Default [DF__LedgerTab__Bal_6__673F4B05]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Bal_6]
GO
/****** Object:  Default [DF__LedgerTab__Bal_7__68336F3E]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Bal_7]
GO
/****** Object:  Default [DF__LedgerTab__Bal_8__69279377]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Bal_8]
GO
/****** Object:  Default [DF__LedgerTab__Bal_9__6A1BB7B0]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Bal_9]
GO
/****** Object:  Default [DF__LedgerTab__Bal_1__6B0FDBE9]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Bal_10]
GO
/****** Object:  Default [DF__LedgerTab__Bal_1__6C040022]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Bal_11]
GO
/****** Object:  Default [DF__LedgerTab__Bal_1__6CF8245B]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013] ADD  DEFAULT ('') FOR [Bal_12]
GO
/****** Object:  Default [DF__LedgerTab__OldBa__06ED0088]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ((0)) FOR [OldBalance]
GO
/****** Object:  Default [DF__LedgerTab__OldBa__07E124C1]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [OldBalancePaymentDetails]
GO
/****** Object:  Default [DF__LedgerTab__Bill___08D548FA]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('-1') FOR [Bill_1]
GO
/****** Object:  Default [DF__LedgerTab__Bill___09C96D33]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('-1') FOR [Bill_2]
GO
/****** Object:  Default [DF__LedgerTab__Bill___0ABD916C]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('-1') FOR [Bill_3]
GO
/****** Object:  Default [DF__LedgerTab__Bill___0BB1B5A5]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('-1') FOR [Bill_4]
GO
/****** Object:  Default [DF__LedgerTab__Bill___0CA5D9DE]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('-1') FOR [Bill_5]
GO
/****** Object:  Default [DF__LedgerTab__Bill___0D99FE17]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('-1') FOR [Bill_6]
GO
/****** Object:  Default [DF__LedgerTab__Bill___0E8E2250]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('-1') FOR [Bill_7]
GO
/****** Object:  Default [DF__LedgerTab__Bill___0F824689]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('-1') FOR [Bill_8]
GO
/****** Object:  Default [DF__LedgerTab__Bill___10766AC2]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('-1') FOR [Bill_9]
GO
/****** Object:  Default [DF__LedgerTab__Bill___116A8EFB]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('-1') FOR [Bill_10]
GO
/****** Object:  Default [DF__LedgerTab__Bill___125EB334]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('-1') FOR [Bill_11]
GO
/****** Object:  Default [DF__LedgerTab__Bill___1352D76D]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('-1') FOR [Bill_12]
GO
/****** Object:  Default [DF__LedgerTab__Amt_1__1446FBA6]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Amt_1]
GO
/****** Object:  Default [DF__LedgerTab__Amt_2__153B1FDF]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Amt_2]
GO
/****** Object:  Default [DF__LedgerTab__Amt_3__162F4418]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Amt_3]
GO
/****** Object:  Default [DF__LedgerTab__Amt_4__17236851]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Amt_4]
GO
/****** Object:  Default [DF__LedgerTab__Amt_5__18178C8A]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Amt_5]
GO
/****** Object:  Default [DF__LedgerTab__Amt_6__190BB0C3]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Amt_6]
GO
/****** Object:  Default [DF__LedgerTab__Amt_7__19FFD4FC]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Amt_7]
GO
/****** Object:  Default [DF__LedgerTab__Amt_8__1AF3F935]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Amt_8]
GO
/****** Object:  Default [DF__LedgerTab__Amt_9__1BE81D6E]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Amt_9]
GO
/****** Object:  Default [DF__LedgerTab__Amt_1__1CDC41A7]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Amt_10]
GO
/****** Object:  Default [DF__LedgerTab__Amt_1__1DD065E0]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Amt_11]
GO
/****** Object:  Default [DF__LedgerTab__Amt_1__1EC48A19]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Amt_12]
GO
/****** Object:  Default [DF__LedgerTab__Date___1FB8AE52]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Date_1]
GO
/****** Object:  Default [DF__LedgerTab__Date___20ACD28B]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Date_2]
GO
/****** Object:  Default [DF__LedgerTab__Date___21A0F6C4]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Date_3]
GO
/****** Object:  Default [DF__LedgerTab__Date___22951AFD]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Date_4]
GO
/****** Object:  Default [DF__LedgerTab__Date___23893F36]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Date_5]
GO
/****** Object:  Default [DF__LedgerTab__Date___247D636F]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Date_6]
GO
/****** Object:  Default [DF__LedgerTab__Date___257187A8]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Date_7]
GO
/****** Object:  Default [DF__LedgerTab__Date___2665ABE1]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Date_8]
GO
/****** Object:  Default [DF__LedgerTab__Date___2759D01A]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Date_9]
GO
/****** Object:  Default [DF__LedgerTab__Date___284DF453]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Date_10]
GO
/****** Object:  Default [DF__LedgerTab__Date___2942188C]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Date_11]
GO
/****** Object:  Default [DF__LedgerTab__Date___2A363CC5]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Date_12]
GO
/****** Object:  Default [DF__LedgerTab__Bal_1__2B2A60FE]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Bal_1]
GO
/****** Object:  Default [DF__LedgerTab__Bal_2__2C1E8537]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Bal_2]
GO
/****** Object:  Default [DF__LedgerTab__Bal_3__2D12A970]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Bal_3]
GO
/****** Object:  Default [DF__LedgerTab__Bal_4__2E06CDA9]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Bal_4]
GO
/****** Object:  Default [DF__LedgerTab__Bal_5__2EFAF1E2]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Bal_5]
GO
/****** Object:  Default [DF__LedgerTab__Bal_6__2FEF161B]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Bal_6]
GO
/****** Object:  Default [DF__LedgerTab__Bal_7__30E33A54]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Bal_7]
GO
/****** Object:  Default [DF__LedgerTab__Bal_8__31D75E8D]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Bal_8]
GO
/****** Object:  Default [DF__LedgerTab__Bal_9__32CB82C6]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Bal_9]
GO
/****** Object:  Default [DF__LedgerTab__Bal_1__33BFA6FF]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Bal_10]
GO
/****** Object:  Default [DF__LedgerTab__Bal_1__34B3CB38]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Bal_11]
GO
/****** Object:  Default [DF__LedgerTab__Bal_1__35A7EF71]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012] ADD  DEFAULT ('') FOR [Bal_12]
GO
/****** Object:  Default [DF__LedgerTab__OldBa__73DA2C14]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011] ADD  DEFAULT ((0)) FOR [OldBalance]
GO
/****** Object:  Default [DF__LedgerTab__Bill___74CE504D]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011] ADD  DEFAULT ('-1') FOR [Bill_1]
GO
/****** Object:  Default [DF__LedgerTab__Bill___75C27486]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011] ADD  DEFAULT ('-1') FOR [Bill_2]
GO
/****** Object:  Default [DF__LedgerTab__Bill___76B698BF]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011] ADD  DEFAULT ('-1') FOR [Bill_3]
GO
/****** Object:  Default [DF__LedgerTab__Bill___77AABCF8]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011] ADD  DEFAULT ('-1') FOR [Bill_4]
GO
/****** Object:  Default [DF__LedgerTab__Bill___789EE131]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011] ADD  DEFAULT ('-1') FOR [Bill_5]
GO
/****** Object:  Default [DF__LedgerTab__Bill___7993056A]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011] ADD  DEFAULT ('-1') FOR [Bill_6]
GO
/****** Object:  Default [DF__LedgerTab__Bill___7A8729A3]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011] ADD  DEFAULT ('-1') FOR [Bill_7]
GO
/****** Object:  Default [DF__LedgerTab__Bill___7B7B4DDC]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011] ADD  DEFAULT ('-1') FOR [Bill_8]
GO
/****** Object:  Default [DF__LedgerTab__Bill___7C6F7215]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011] ADD  DEFAULT ('-1') FOR [Bill_9]
GO
/****** Object:  Default [DF__LedgerTab__Bill___7D63964E]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011] ADD  DEFAULT ('-1') FOR [Bill_10]
GO
/****** Object:  Default [DF__LedgerTab__Bill___7E57BA87]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011] ADD  DEFAULT ('-1') FOR [Bill_11]
GO
/****** Object:  Default [DF__LedgerTab__Bill___7F4BDEC0]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011] ADD  DEFAULT ('-1') FOR [Bill_12]
GO
/****** Object:  Default [DF__LedgerTab__OldBa__65C116E7]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010] ADD  CONSTRAINT [DF__LedgerTab__OldBa__65C116E7]  DEFAULT ((0)) FOR [OldBalance]
GO
/****** Object:  Default [DF__LedgerTab__Bill___66B53B20]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010] ADD  CONSTRAINT [DF__LedgerTab__Bill___66B53B20]  DEFAULT ('-1') FOR [Bill_1]
GO
/****** Object:  Default [DF__LedgerTab__Bill___67A95F59]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010] ADD  CONSTRAINT [DF__LedgerTab__Bill___67A95F59]  DEFAULT ('-1') FOR [Bill_2]
GO
/****** Object:  Default [DF__LedgerTab__Bill___689D8392]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010] ADD  CONSTRAINT [DF__LedgerTab__Bill___689D8392]  DEFAULT ('-1') FOR [Bill_3]
GO
/****** Object:  Default [DF__LedgerTab__Bill___6991A7CB]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010] ADD  CONSTRAINT [DF__LedgerTab__Bill___6991A7CB]  DEFAULT ('-1') FOR [Bill_4]
GO
/****** Object:  Default [DF__LedgerTab__Bill___6A85CC04]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010] ADD  CONSTRAINT [DF__LedgerTab__Bill___6A85CC04]  DEFAULT ('-1') FOR [Bill_5]
GO
/****** Object:  Default [DF__LedgerTab__Bill___6B79F03D]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010] ADD  CONSTRAINT [DF__LedgerTab__Bill___6B79F03D]  DEFAULT ('-1') FOR [Bill_6]
GO
/****** Object:  Default [DF__LedgerTab__Bill___6C6E1476]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010] ADD  CONSTRAINT [DF__LedgerTab__Bill___6C6E1476]  DEFAULT ('-1') FOR [Bill_7]
GO
/****** Object:  Default [DF__LedgerTab__Bill___6D6238AF]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010] ADD  CONSTRAINT [DF__LedgerTab__Bill___6D6238AF]  DEFAULT ('-1') FOR [Bill_8]
GO
/****** Object:  Default [DF__LedgerTab__Bill___6E565CE8]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010] ADD  CONSTRAINT [DF__LedgerTab__Bill___6E565CE8]  DEFAULT ('-1') FOR [Bill_9]
GO
/****** Object:  Default [DF__LedgerTab__Bill___6F4A8121]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010] ADD  CONSTRAINT [DF__LedgerTab__Bill___6F4A8121]  DEFAULT ('-1') FOR [Bill_10]
GO
/****** Object:  Default [DF__LedgerTab__Bill___703EA55A]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010] ADD  CONSTRAINT [DF__LedgerTab__Bill___703EA55A]  DEFAULT ('-1') FOR [Bill_11]
GO
/****** Object:  Default [DF__LedgerTab__Bill___7132C993]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010] ADD  CONSTRAINT [DF__LedgerTab__Bill___7132C993]  DEFAULT ('-1') FOR [Bill_12]
GO
/****** Object:  Default [DF_LedgerTable_OldBalance]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable] ADD  CONSTRAINT [DF_LedgerTable_OldBalance]  DEFAULT ((0)) FOR [OldBalance]
GO
/****** Object:  Default [DF_LedgerTable_Bill_1]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable] ADD  CONSTRAINT [DF_LedgerTable_Bill_1]  DEFAULT ('-1') FOR [Bill_1]
GO
/****** Object:  Default [DF_LedgerTable_Bill_2]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable] ADD  CONSTRAINT [DF_LedgerTable_Bill_2]  DEFAULT ('-1') FOR [Bill_2]
GO
/****** Object:  Default [DF_LedgerTable_Bill_3]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable] ADD  CONSTRAINT [DF_LedgerTable_Bill_3]  DEFAULT ('-1') FOR [Bill_3]
GO
/****** Object:  Default [DF_LedgerTable_Bill_4]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable] ADD  CONSTRAINT [DF_LedgerTable_Bill_4]  DEFAULT ('-1') FOR [Bill_4]
GO
/****** Object:  Default [DF_LedgerTable_Bill_5]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable] ADD  CONSTRAINT [DF_LedgerTable_Bill_5]  DEFAULT ('-1') FOR [Bill_5]
GO
/****** Object:  Default [DF_LedgerTable_Bill_6]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable] ADD  CONSTRAINT [DF_LedgerTable_Bill_6]  DEFAULT ('-1') FOR [Bill_6]
GO
/****** Object:  Default [DF_LedgerTable_Bill_7]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable] ADD  CONSTRAINT [DF_LedgerTable_Bill_7]  DEFAULT ('-1') FOR [Bill_7]
GO
/****** Object:  Default [DF_LedgerTable_Bill_8]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable] ADD  CONSTRAINT [DF_LedgerTable_Bill_8]  DEFAULT ('-1') FOR [Bill_8]
GO
/****** Object:  Default [DF_LedgerTable_Bill_9]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable] ADD  CONSTRAINT [DF_LedgerTable_Bill_9]  DEFAULT ('-1') FOR [Bill_9]
GO
/****** Object:  Default [DF_LedgerTable_Bill_10]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable] ADD  CONSTRAINT [DF_LedgerTable_Bill_10]  DEFAULT ('-1') FOR [Bill_10]
GO
/****** Object:  Default [DF_LedgerTable_Bill_11]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable] ADD  CONSTRAINT [DF_LedgerTable_Bill_11]  DEFAULT ('-1') FOR [Bill_11]
GO
/****** Object:  Default [DF_LedgerTable_Bill_12]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable] ADD  CONSTRAINT [DF_LedgerTable_Bill_12]  DEFAULT ('-1') FOR [Bill_12]
GO
/****** Object:  ForeignKey [FK_AgentDetailsTable_AgentDetailsTable]    Script Date: 07/28/2015 07:29:57 ******/
ALTER TABLE [dbo].[AgentDetailsTable]  WITH CHECK ADD  CONSTRAINT [FK_AgentDetailsTable_AgentDetailsTable] FOREIGN KEY([AreaCode])
REFERENCES [dbo].[AreaDetailsTable] ([AreaCode])
GO
ALTER TABLE [dbo].[AgentDetailsTable] CHECK CONSTRAINT [FK_AgentDetailsTable_AgentDetailsTable]
GO
/****** Object:  ForeignKey [FK_AgentDetailsTable_EmployeeTable]    Script Date: 07/28/2015 07:29:57 ******/
ALTER TABLE [dbo].[AgentDetailsTable]  WITH CHECK ADD  CONSTRAINT [FK_AgentDetailsTable_EmployeeTable] FOREIGN KEY([EmpNum])
REFERENCES [dbo].[EmployeeTable] ([ID])
GO
ALTER TABLE [dbo].[AgentDetailsTable] CHECK CONSTRAINT [FK_AgentDetailsTable_EmployeeTable]
GO
/****** Object:  ForeignKey [FK_BillingCategoryTable_BillingFrequncyTable]    Script Date: 07/28/2015 07:29:57 ******/
ALTER TABLE [dbo].[BillingCategoryTable]  WITH CHECK ADD  CONSTRAINT [FK_BillingCategoryTable_BillingFrequncyTable] FOREIGN KEY([Frequency])
REFERENCES [dbo].[BillingFrequncyTable] ([NumberOfMonths])
GO
ALTER TABLE [dbo].[BillingCategoryTable] CHECK CONSTRAINT [FK_BillingCategoryTable_BillingFrequncyTable]
GO
/****** Object:  ForeignKey [FK_CustomerDetailsTable_AgentDetailsTable]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[CustomerDetailsTable]  WITH CHECK ADD  CONSTRAINT [FK_CustomerDetailsTable_AgentDetailsTable] FOREIGN KEY([AgentCode])
REFERENCES [dbo].[AgentDetailsTable] ([AgentCode])
GO
ALTER TABLE [dbo].[CustomerDetailsTable] CHECK CONSTRAINT [FK_CustomerDetailsTable_AgentDetailsTable]
GO
/****** Object:  ForeignKey [FK_CustomerDetailsTable_AreaDetailsTable]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[CustomerDetailsTable]  WITH CHECK ADD  CONSTRAINT [FK_CustomerDetailsTable_AreaDetailsTable] FOREIGN KEY([AreaCode])
REFERENCES [dbo].[AreaDetailsTable] ([AreaCode])
GO
ALTER TABLE [dbo].[CustomerDetailsTable] CHECK CONSTRAINT [FK_CustomerDetailsTable_AreaDetailsTable]
GO
/****** Object:  ForeignKey [FK_CustomerDetailsTable_BillingCategoryTable]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[CustomerDetailsTable]  WITH CHECK ADD  CONSTRAINT [FK_CustomerDetailsTable_BillingCategoryTable] FOREIGN KEY([BillingCategory])
REFERENCES [dbo].[BillingCategoryTable] ([CategoryCode])
GO
ALTER TABLE [dbo].[CustomerDetailsTable] CHECK CONSTRAINT [FK_CustomerDetailsTable_BillingCategoryTable]
GO
/****** Object:  ForeignKey [FK__Collectio__Agent__7B4643B2]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[CollectionTable]  WITH CHECK ADD FOREIGN KEY([AgentCode])
REFERENCES [dbo].[AgentDetailsTable] ([AgentCode])
GO
/****** Object:  ForeignKey [FK__AmountCol__Agent__73A521EA]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[AmountCollectionTable]  WITH CHECK ADD  CONSTRAINT [FK__AmountCol__Agent__73A521EA] FOREIGN KEY([AgentCode])
REFERENCES [dbo].[AgentDetailsTable] ([AgentCode])
GO
ALTER TABLE [dbo].[AmountCollectionTable] CHECK CONSTRAINT [FK__AmountCol__Agent__73A521EA]
GO
/****** Object:  ForeignKey [FK_TestCustomer_TestCustomer]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[TestCustomer]  WITH CHECK ADD  CONSTRAINT [FK_TestCustomer_TestCustomer] FOREIGN KEY([ID])
REFERENCES [dbo].[CustomerDetailsTable] ([ID])
GO
ALTER TABLE [dbo].[TestCustomer] CHECK CONSTRAINT [FK_TestCustomer_TestCustomer]
GO
/****** Object:  ForeignKey [FK__SMSTable__CustID__3B60C8C7]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[SMSTable]  WITH CHECK ADD FOREIGN KEY([CustID])
REFERENCES [dbo].[CustomerDetailsTable] ([ID])
GO
/****** Object:  ForeignKey [FK__LedgerTab__Agent__2DD1C37F]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014]  WITH CHECK ADD FOREIGN KEY([AgentCode])
REFERENCES [dbo].[AgentDetailsTable] ([AgentCode])
GO
/****** Object:  ForeignKey [FK__LedgerTab__AreaC__2EC5E7B8]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014]  WITH CHECK ADD FOREIGN KEY([AreaCode])
REFERENCES [dbo].[AreaDetailsTable] ([AreaCode])
GO
/****** Object:  ForeignKey [FK__LedgerTab__CustI__2FBA0BF1]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2014]  WITH CHECK ADD FOREIGN KEY([CustID])
REFERENCES [dbo].[CustomerDetailsTable] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
/****** Object:  ForeignKey [FK__LedgerTab__Agent__6DEC4894]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013]  WITH CHECK ADD FOREIGN KEY([AgentCode])
REFERENCES [dbo].[AgentDetailsTable] ([AgentCode])
GO
/****** Object:  ForeignKey [FK__LedgerTab__AreaC__6EE06CCD]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013]  WITH CHECK ADD FOREIGN KEY([AreaCode])
REFERENCES [dbo].[AreaDetailsTable] ([AreaCode])
GO
/****** Object:  ForeignKey [FK__LedgerTab__CustI__6FD49106]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2013]  WITH CHECK ADD FOREIGN KEY([CustID])
REFERENCES [dbo].[CustomerDetailsTable] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
/****** Object:  ForeignKey [FK__LedgerTab__Agent__369C13AA]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012]  WITH CHECK ADD FOREIGN KEY([AgentCode])
REFERENCES [dbo].[AgentDetailsTable] ([AgentCode])
GO
/****** Object:  ForeignKey [FK__LedgerTab__AreaC__379037E3]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012]  WITH CHECK ADD FOREIGN KEY([AreaCode])
REFERENCES [dbo].[AreaDetailsTable] ([AreaCode])
GO
/****** Object:  ForeignKey [FK__LedgerTab__CustI__38845C1C]    Script Date: 07/28/2015 07:29:58 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2012]  WITH CHECK ADD FOREIGN KEY([CustID])
REFERENCES [dbo].[CustomerDetailsTable] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
/****** Object:  ForeignKey [FK__LedgerTab__Agent__004002F9]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011]  WITH CHECK ADD FOREIGN KEY([AgentCode])
REFERENCES [dbo].[AgentDetailsTable] ([AgentCode])
GO
/****** Object:  ForeignKey [FK__LedgerTab__AreaC__01342732]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011]  WITH CHECK ADD FOREIGN KEY([AreaCode])
REFERENCES [dbo].[AreaDetailsTable] ([AreaCode])
GO
/****** Object:  ForeignKey [FK__LedgerTab__CustI__02284B6B]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2011]  WITH CHECK ADD FOREIGN KEY([CustID])
REFERENCES [dbo].[CustomerDetailsTable] ([ID])
GO
/****** Object:  ForeignKey [FK__LedgerTab__Agent__7226EDCC]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010]  WITH CHECK ADD  CONSTRAINT [FK__LedgerTab__Agent__7226EDCC] FOREIGN KEY([AgentCode])
REFERENCES [dbo].[AgentDetailsTable] ([AgentCode])
GO
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010] CHECK CONSTRAINT [FK__LedgerTab__Agent__7226EDCC]
GO
/****** Object:  ForeignKey [FK__LedgerTab__AreaC__731B1205]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010]  WITH CHECK ADD  CONSTRAINT [FK__LedgerTab__AreaC__731B1205] FOREIGN KEY([AreaCode])
REFERENCES [dbo].[AreaDetailsTable] ([AreaCode])
GO
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010] CHECK CONSTRAINT [FK__LedgerTab__AreaC__731B1205]
GO
/****** Object:  ForeignKey [FK__LedgerTab__CustI__740F363E]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010]  WITH CHECK ADD  CONSTRAINT [FK__LedgerTab__CustI__740F363E] FOREIGN KEY([CustID])
REFERENCES [dbo].[CustomerDetailsTable] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LedgerTable_Anuradha_Cable_TV_2010] CHECK CONSTRAINT [FK__LedgerTab__CustI__740F363E]
GO
/****** Object:  ForeignKey [FK_LedgerTable_AgentDetailsTable]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable]  WITH CHECK ADD  CONSTRAINT [FK_LedgerTable_AgentDetailsTable] FOREIGN KEY([AgentCode])
REFERENCES [dbo].[AgentDetailsTable] ([AgentCode])
GO
ALTER TABLE [dbo].[LedgerTable] CHECK CONSTRAINT [FK_LedgerTable_AgentDetailsTable]
GO
/****** Object:  ForeignKey [FK_LedgerTable_AreaDetailsTable]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable]  WITH CHECK ADD  CONSTRAINT [FK_LedgerTable_AreaDetailsTable] FOREIGN KEY([AreaCode])
REFERENCES [dbo].[AreaDetailsTable] ([AreaCode])
GO
ALTER TABLE [dbo].[LedgerTable] CHECK CONSTRAINT [FK_LedgerTable_AreaDetailsTable]
GO
/****** Object:  ForeignKey [FK_LedgerTable_CustomerDetailsTable]    Script Date: 07/28/2015 07:29:59 ******/
ALTER TABLE [dbo].[LedgerTable]  WITH CHECK ADD  CONSTRAINT [FK_LedgerTable_CustomerDetailsTable] FOREIGN KEY([CustID])
REFERENCES [dbo].[CustomerDetailsTable] ([ID])
GO
ALTER TABLE [dbo].[LedgerTable] CHECK CONSTRAINT [FK_LedgerTable_CustomerDetailsTable]
GO
