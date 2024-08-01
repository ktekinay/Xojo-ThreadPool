#tag DesktopWindow
Begin DesktopWindow WndMain
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   Height          =   600
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   770703359
   MenuBarVisible  =   False
   MinimumHeight   =   400
   MinimumWidth    =   700
   Resizeable      =   True
   Title           =   "Converter TP"
   Type            =   0
   Visible         =   True
   Width           =   830
   Begin DesktopCanvas Canvas1
      AllowAutoDeactivate=   True
      AllowFocus      =   False
      AllowFocusRing  =   True
      AllowTabs       =   False
      Backdrop        =   0
      Enabled         =   True
      Height          =   508
      Index           =   -2147483648
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   2
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   13
      Transparent     =   True
      Visible         =   True
      Width           =   790
   End
   Begin DesktopButton BtnConvertTP
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "TP"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   690
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   2
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   560
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   120
   End
   Begin DesktopLabel LblElapsed
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "elapsed"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   533
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   100
   End
   Begin M_ThreadPool.ThreadPool ThreadPool1
      ActiveJobs      =   0
      ElapsedMicroseconds=   0.0
      Index           =   -2147483648
      IsFinished      =   False
      IsQueueFull     =   False
      LockedInPosition=   False
      MaximumJobs     =   0
      QueueLimit      =   0
      RemainingInQueue=   0
      Scope           =   2
      TabPanelIndex   =   0
   End
   Begin DesktopButton BtnConvert
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Main Thread"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   558
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   2
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   560
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   120
   End
   Begin DesktopButton BtnConvertSinglePThread
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Single PThread"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   426
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   2
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   560
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   120
   End
   Begin Thread PThread
      DebugIdentifier =   ""
      Index           =   -2147483648
      LockedInPosition=   False
      Priority        =   5
      Scope           =   2
      StackSize       =   0
      TabPanelIndex   =   0
      ThreadID        =   0
      ThreadState     =   0
   End
   Begin DesktopButton BtnConvertSingleCThread
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Single CThread"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   294
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   2
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   560
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   120
   End
   Begin DesktopButton BtnNewPicture
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "New"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   2
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   560
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   120
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Opening()
		  #if XojoVersion < 2024.03 then
		    BtnConvertSinglePThread.Enabled = false
		    BtnConvertSinglePThread.Visible = false
		  #endif
		  
		  ThreadPool1.QueueLimit = 64
		  'ThreadPool1.MaximumJobs = System.CoreCount - 1
		  'ThreadPool1.Type = Thread.Types.Preemptive
		  
		  MakeNewPicture
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resized()
		  MakeNewPicture
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Shared Function ConvertBlock(p As Picture, r As Xojo.Rect) As Picture
		  var slice as new Picture( r.Width, r.Height )
		  
		  slice.Graphics.DrawPicture p, 0, 0, slice.Width, slice.Height, r.Left, r.Top, r.Width, r.Height
		  
		  var rgb as RGBSurface = slice.RGBSurface
		  
		  var lastX as integer = slice.Width - 1
		  var lastY as integer = slice.Height - 1
		  
		  for x as integer = 0 to lastX
		    for y as integer = 0 to lastY
		      var c as Color = rgb.Pixel( x, y )
		      c = ConvertPixel( c )
		      rgb.Pixel( x, y ) = c
		    next
		  next
		  
		  return slice
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ConvertPixel(p As Color) As Color
		  'return Color.RGB( 255 - p.Red, 255 - p.Green, 255 - p.Blue, p.Alpha )
		  
		  var lastIndex as integer = ( p.Red + 1 ) * 4
		  
		  var r as integer = p.Red
		  var g as integer = p.Green
		  var b as integer = p.Blue
		  
		  for i as integer = 1 to lastIndex
		    'r = System.Random.InRange( 1, 10000 ) mod 256
		    g = ( r + g ) mod 256
		    b = ( g + b ) mod 256
		  next
		  
		  p = Color.RGB( r, g, b )
		  return p
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CopyToSourcePicture()
		  SourcePicture = new Picture( MyPicture.Width, MyPicture.Height )
		  SourcePicture.Graphics.DrawPicture MyPicture, 0, 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DoFinished(elapsedMicroseconds As Double)
		  Canvas1.Refresh
		  
		  var elapsed as double = elapsedMicroseconds / 1000.0
		  LblElapsed.Text = elapsed.ToString( "#,##0.00" ) + " ms"
		  
		  NextX = 0
		  NextY = 0
		  
		  SourcePicture = nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DoUserInterfaceUpdate(data() as Dictionary)
		  for each d as Dictionary in data
		    if d.HasKey( "done" ) then
		      DoFinished( System.Microseconds - StartMicroseconds )
		    else
		      var r as Xojo.Rect = d.Value( "rect" )
		      var slice as Picture = d.Value( "slice" )
		      
		      MyPicture.Graphics.DrawPicture slice, r.Left, r.Top, slice.Width, slice.Height
		      Canvas1.Refresh r.Left, r.Top, r.Width, r.Height
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub FeedThreadPool()
		  var r as Xojo.Rect = NextRect
		  
		  if r is nil then
		    ThreadPool1.Finish
		    return
		  end if
		  
		  while ThreadPool1.TryAdd( r )
		    NextX = NextX + kSquareSize
		    
		    r = NextRect
		    
		    if r is nil then
		      ThreadPool1.Finish
		      return
		    end if
		  wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub MakeNewPicture()
		  if not ThreadPool1.IsFinished then
		    ThreadPool1.Stop
		  end if
		  
		  if PThread.ThreadState <> Thread.ThreadStates.NotRunning then
		    PThread.Stop
		  end if
		  
		  var p as new Picture( Canvas1.Width, Canvas1.Height )
		  
		  var rgb as RGBSurface = p.RGBSurface
		  
		  for x as integer = 0 to p.Width - 1
		    for y as integer = 0 to p.Height - 1
		      var r as integer = x mod 256
		      var g as integer = y mod 256
		      var b as integer = ( x + y ) mod 256
		      
		      var c as Color = Color.RGB( r, g, b )
		      rgb.Pixel( x, y ) = c
		    next
		  next
		  
		  MyPicture = p
		  
		  NextX = 0
		  NextY = 0
		  
		  Canvas1.Refresh
		  LblElapsed.Text = "elapsed"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function NextRect() As Xojo.Rect
		  if NextX >= SourcePicture.Width then
		    NextX = 0
		    NextY = NextY + kSquareSize
		  end if
		  
		  if NextY >= SourcePicture.Height then
		    return nil
		  end if
		  
		  var endX as integer = min( NextX + kSquareSize - 1, MyPicture.Width - 1 )
		  var endY as integer = min( NextY + kSquareSize - 1, MyPicture.Height - 1 )
		  
		  var r as new Xojo.Rect( NextX, NextY, endX - NextX + 1, endY - NextY + 1 )
		  
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessInLoop(thd As Thread)
		  CopyToSourcePicture
		  
		  NextX = 0
		  NextY = 0
		  
		  var r as Rect = NextRect
		  
		  while r isa object
		    var slice as Picture = ConvertBlock( SourcePicture, r )
		    
		    if thd isa object then
		      thd.AddUserInterfaceUpdate "rect" : r, "slice" : slice
		    else
		      MyPicture.Graphics.DrawPicture slice, r.Left, r.Top, r.Width, r.Height
		    end if
		    
		    NextX = NextX + kSquareSize
		    
		    r = NextRect
		  wend
		  
		  if thd isa object then
		    thd.AddUserInterfaceUpdate "done" : nil
		  else
		    DoFinished( System.Microseconds - StartMicroseconds )
		  end if
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private MyPicture As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private NextX As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private NextY As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SourcePicture As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StartMicroseconds As Double
	#tag EndProperty


	#tag Constant, Name = kSquareSize, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events Canvas1
	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  if areas.Count = 0 then
		    areas.Add new Xojo.Rect( 0, 0, MyPicture.Width, MyPicture.Height )
		  else
		    // A place to break
		    areas = areas
		  end if
		  
		  for each r as Xojo.Rect in areas
		    g.DrawPicture MyPicture, r.Left, r.Top, r.Width, r.Height, r.Left, r.Top, r.Width, r.Height
		  next
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events BtnConvertTP
	#tag Event
		Sub Pressed()
		  CopyToSourcePicture
		  
		  FeedThreadPool
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ThreadPool1
	#tag Event , Description = 416674657220686176696E672066696C6C6564207468652071756575652C206120736C6F7420686173206265636F6D6520617661696C61626C6520666F72206D6F726520646174612E
		Sub QueueAvailable()
		  FeedThreadPool
		End Sub
	#tag EndEvent
	#tag Event , Description = 416C6C2070726F63657373696E672068617320636F6E636C7564656420616674657220436C6F7365206F722053746F70207761732063616C6C65642E
		Sub Finished()
		  DoFinished( me.ElapsedMicroseconds )
		End Sub
	#tag EndEvent
	#tag Event , Description = 526169736564207768656E206120546872656164206973737565732041646455736572496E746572666163655570646174652E
		Sub UserInterfaceUpdate(data() As Dictionary)
		  DoUserInterfaceUpdate( data )
		  
		End Sub
	#tag EndEvent
	#tag Event , Description = 496D706C656D656E7420746F2068616E646C652070726F63657373696E67206F66206F6E65206974656D206F6620646174612E
		Sub Process(data As Variant, currentThread As Thread)
		  #pragma unused currentThread
		  
		  var r as Xojo.Rect = data
		  var slice as Picture = ConvertBlock( SourcePicture, r )
		  
		  me.AddUserInterfaceUpdate "rect" : r, "slice" : slice
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events BtnConvert
	#tag Event
		Sub Pressed()
		  StartMicroseconds = System.Microseconds
		  
		  ProcessInLoop( nil )
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events BtnConvertSinglePThread
	#tag Event
		Sub Pressed()
		  #if XojoVersion >= 2024.03 then
		    StartMicroseconds = System.Microseconds
		    
		    PThread.Type = Thread.Types.Preemptive
		    PThread.Run
		  #endif
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PThread
	#tag Event
		Sub Run()
		  ProcessInLoop( me )
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub UserInterfaceUpdate(data() as Dictionary)
		  DoUserInterfaceUpdate( data )
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events BtnConvertSingleCThread
	#tag Event
		Sub Pressed()
		  StartMicroseconds = System.Microseconds
		  
		  #if XojoVersion >= 2024.03 then
		    PThread.Type = Thread.Types.Cooperative
		  #endif
		  PThread.Run
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events BtnNewPicture
	#tag Event
		Sub Pressed()
		  MakeNewPicture
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Window Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&cFFFFFF"
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="DesktopMenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
