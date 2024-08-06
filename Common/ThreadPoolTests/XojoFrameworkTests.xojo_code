#tag Class
Protected Class XojoFrameworkTests
Inherits TestGroup
	#tag Event
		Sub Setup()
		  Locker = new Semaphore
		  Locker.Type = Thread.Types.Preemptive
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Sub BinaryStreamBigWriteRunner(index As Integer, data As Variant)
		  var p as pair = data
		  
		  var s as string = p.Left
		  var bs as BinaryStream = p.Right
		  
		  bs.Write s
		  
		  Store index, nil, true
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Sub BinaryStreamBigWriteTest()
		  var tp as new DelegateRunnerThreadPool( AddressOf BinaryStreamBigWriteRunner )
		  
		  const kFileName as string = "TPBinaryStreamBigWrite.txt"
		  
		  var file as FolderItem = SpecialFolder.Temporary.Child( kFileName )
		  
		  var bs as BinaryStream = BinaryStream.Create( file, true )
		  bs.LittleEndian = TargetLittleEndian
		  
		  const kTargetSize as integer = 8192 * 2
		  
		  for i as integer = 0 to kLastJobIndex
		    var s as string = i.ToString( "00" )
		    var l as integer = s.Bytes
		    
		    while l < kTargetSize
		      s = s + s
		      l = l + l
		    wend
		    
		    s = s + "|"
		    
		    var data as variant = s : bs
		    tp.Add i : data
		  next
		  
		  Assert.Message "ActiveJobs = " + tp.ActiveJobs.ToString
		  tp.Wait
		  
		  bs.Position = 0
		  var contents as string = bs.Read( bs.Length )
		  
		  bs.Close
		  bs = nil
		  
		  file.Remove
		  file = nil
		  
		  var arr() as string = contents.SplitBytes( "|" )
		  var arrLastIndex as integer = arr.LastIndex
		  Assert.AreEqual kLastJobIndex + 1, arrLastIndex
		  call arr.Pop
		  
		  arr.Sort
		  
		  var expected as integer = kTargetSize / 2 + 1
		  
		  for i as integer = 0 to kLastJobIndex
		    var item as string = arr( i )
		    var val as string = item.Left( 2 )
		    Assert.AreEqual i, val.ToInteger
		    
		    var parts() as string = item.Split( val )
		    var partCount as integer = parts.Count
		    Assert.AreEqual expected, partCount
		  next
		  
		  CheckResults
		  
		  Finally
		    if bs isa object then
		      bs.Close
		      bs = nil
		    end if
		    
		    if file isa object then
		      try
		        file.Remove
		      end try
		      file = nil
		    end if
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Sub BinaryStreamReadRunner(index As Integer, data As Variant)
		  #pragma unused index
		  
		  var bs as BinaryStream = data
		  
		  var readInt as integer = bs.ReadInt32
		  
		  Store readInt, nil, true
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Sub BinaryStreamReadTest()
		  var tp as new DelegateRunnerThreadPool( AddressOf BinaryStreamReadRunner )
		  
		  const kFileName as string = "TPBinaryStreamRead.txt"
		  
		  var file as FolderItem = SpecialFolder.Temporary.Child( kFileName )
		  var bs as BinaryStream = BinaryStream.Create( file, true )
		  
		  for i as integer = 0 to kLastJobIndex
		    bs.WriteInt32 i
		  next
		  
		  bs.Close
		  bs = nil
		  
		  bs = BinaryStream.Open( file )
		  
		  for i as integer = 0 to kLastJobIndex
		    tp.Add i : bs
		  next
		  
		  Assert.Message "ActiveJobs = " + tp.ActiveJobs.ToString
		  tp.Wait
		  
		  bs.Close
		  bs = nil
		  
		  file.Remove
		  file = nil
		  
		  CheckResults
		  
		  Finally
		    if bs isa object then
		      bs.Close
		      bs = nil
		    end if
		    
		    if file isa object then
		      try
		        file.Remove
		      end try
		      file = nil
		    end if
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Sub BinaryStreamWriteRunner(index As Integer, data As Variant)
		  var bs as BinaryStream = data
		  
		  bs.WriteInt32 index
		  
		  Store index, nil, true
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Sub BinaryStreamWriteTest()
		  var tp as new DelegateRunnerThreadPool( AddressOf BinaryStreamWriteRunner )
		  
		  const kFileName as string = "TPBinaryStreamWrite.txt"
		  
		  var file as FolderItem = SpecialFolder.Temporary.Child( kFileName )
		  
		  var bs as BinaryStream = BinaryStream.Create( file, true )
		  bs.LittleEndian = TargetLittleEndian
		  
		  for i as integer = 0 to kLastJobIndex
		    tp.Add i : bs
		  next
		  
		  Assert.Message "ActiveJobs = " + tp.ActiveJobs.ToString
		  tp.Wait
		  
		  bs.Position = 0
		  var mb as MemoryBlock = bs.Read( bs.Length )
		  mb.LittleEndian = TargetLittleEndian
		  
		  bs.Close
		  bs = nil
		  
		  file.Remove
		  file = nil
		  
		  var arr( kLastJobIndex ) as integer
		  
		  for i as integer = 0 to kLastJobIndex
		    var value as integer = mb.Int32Value( i * 4 )
		    arr( i ) = value
		  next
		  
		  arr.Sort
		  
		  for i as integer = 0 to arr.LastIndex
		    Assert.AreEqual i, arr( i )
		  next
		  
		  CheckResults
		  
		  Finally
		    if bs isa object then
		      bs.Close
		      bs = nil
		    end if
		    
		    if file isa object then
		      try
		        file.Remove
		      end try
		      file = nil
		    end if
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CheckResults()
		  for each p as pair in Results
		    Assert.IsTrue p.Right, p.Left
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DatabaseTestsRunner(index As Integer, data As Variant)
		  var db as Database = data
		  
		  if not db.Connect then
		    System.DebugLog "Could not connect"
		    return
		  end if
		  
		  db.ExecuteSQL "INSERT INTO preemptive_thread_test (id, s) VALUES ($1, $2)", index, index.ToString
		  
		  var rs as RowSet = db.SelectSQL( "SELECT id, s FROM preemptive_thread_test WHERE id = $1", index )
		  
		  var retrievedIndex as integer = rs.Column( "id" ).IntegerValue
		  var retrievedString as string = rs.Column( "s" ).StringValue
		  
		  if rs.RowCount = 1 and retrievedIndex = index and retrievedString = index.ToString then
		    Store index, nil, true
		  else
		    Store index, nil, false
		  end if
		  
		  db.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DictionariesFromParseJSONRunner(index As Integer, data As Variant)
		  var dict as Dictionary = data
		  
		  var found as integer 
		  for i as integer = 1 to 100
		    found = dict.Value( kDictKey )
		  next
		  
		  Store index, nil, found = index
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DictionariesFromParseJSONTest()
		  var tp as new DelegateRunnerThreadPool( AddressOf DictionariesFromParseJSONRunner )
		  
		  var arr() as Variant
		  
		  for i as integer = 0 to kLastJobIndex
		    var d as new Dictionary
		    d.Value( kDictKey ) = i
		    arr.Add d
		  next
		  
		  var j as string = GenerateJSON( arr )
		  arr = ParseJSON( j )
		  
		  for i as integer = 0 to kLastJobIndex
		    tp.Add i : arr( i )
		  next
		  
		  tp.Wait
		  
		  CheckResults
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DictionaryWithStaticRunner(index As Integer, data As Variant)
		  static key as string = kDictKey
		  
		  var dict as Dictionary = data
		  
		  var found as integer 
		  for i as integer = 1 to 100
		    found = dict.Value( key )
		  next
		  
		  Store index, nil, found = index
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DictionaryWithStaticTest()
		  var tp as new DelegateRunnerThreadPool( AddressOf DictionaryWithStaticRunner )
		  
		  var arr() as Variant
		  
		  for i as integer = 0 to kLastJobIndex
		    var d as new Dictionary
		    d.Value( kDictKey ) = i
		    tp.Add i : d
		  next
		  
		  tp.Wait
		  
		  CheckResults
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandledExceptionRunner(index As Integer, data As Variant)
		  #pragma BreakOnExceptions false
		  
		  var d as Dictionary
		  d.Value( 1 ) = nil
		  
		  #pragma BreakOnExceptions default
		  
		  Store index, data, false
		  
		  Exception err as RuntimeException
		    Store index, data, true
		    
		    #pragma BreakOnExceptions default
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HandledExceptionTest()
		  var tp as new DelegateRunnerThreadPool( AddressOf HandledExceptionRunner )
		  
		  for i as integer = 0 to kLastJobIndex
		    tp.Add i : nil
		  next
		  
		  Assert.Message "ActiveJobs = " + tp.ActiveJobs.ToString
		  tp.Wait
		  
		  CheckResults
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub MemoryBlockRunner(index As Integer, data As Variant)
		  var size as integer = System.Random.InRange( 1, 8 ) * 8
		  
		  var mb as new MemoryBlock( size )
		  var p as ptr = mb
		  
		  for loops as integer = 1 to 10
		    for i as integer = 0 to size - 1 step 8
		      p.Int64( i ) = i
		      mb.Int64Value( i ) = i
		    next
		    
		    for i as integer = 0 to size - 1 step 8
		      if p.Int64( i ) = i and mb.Int64Value( i ) = i then
		        // Good
		      else
		        Store index, data, false
		        return
		      end if
		    next
		  next
		  
		  Store index, data, true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MemoryBlockTest()
		  var tp as new DelegateRunnerThreadPool( AddressOf MemoryBlockRunner )
		  
		  for i as integer = 0 to kLastJobIndex
		    tp.Add i : nil
		  next
		  
		  Assert.Message "ActiveJobs = " + tp.ActiveJobs.ToString
		  tp.Wait
		  
		  CheckResults
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Sub PostgreSQLTest()
		  const kDatabaseName as string = "unittests"
		  const kUsername as string = "unittests"
		  const kPassword as string = "unittests"
		  const kHost as string = "localhost"
		  
		  var tp as new DelegateRunnerThreadPool( AddressOf DatabaseTestsRunner )
		  
		  var db as new PostgreSQLDatabase
		  db.DatabaseName = kDatabaseName
		  db.UserName = kUsername
		  db.Password = kPassword
		  db.Host = kHost
		  
		  if not db.Connect then
		    Assert.Message "A PostgreSQL database must be running locally. See test code for expected username/password."
		    return
		  end if
		  
		  db.ExecuteSQL( "CREATE TABLE IF NOT EXISTS preemptive_thread_test (id INTEGER PRIMARY KEY, s TEXT)" )
		  
		  for i as integer = 0 to kLastJobIndex
		    var threadDb as new PostgreSQLDatabase
		    threadDb.DatabaseName = kDatabaseName
		    threadDb.UserName = kUsername
		    threadDb.Password = kPassword
		    threadDb.Host = kHost
		    
		    tp.Add i : threadDb
		  next
		  
		  Assert.Message "ActiveJobs = " + tp.ActiveJobs.ToString
		  tp.Wait
		  
		  CheckResults
		  
		  for l as integer = 1 to 2
		    var rs as RowSet = db.SelectSQL( "SELECT id, s FROM preemptive_thread_test ORDER BY id" )
		    
		    Assert.AreEqual kLastJobIndex + 1, rs.RowCount, "rs.RowCount"
		    
		    var checkValue as integer
		    
		    for each row as DatabaseRow in rs
		      Assert.AreEqual rs.Column( "id" ).IntegerValue, checkValue
		      Assert.AreEqual rs.Column( "s" ).StringValue, checkValue.ToString
		      
		      checkValue = checkValue + 1
		    next
		    
		    db.Close
		    db = nil
		    
		    db = new PostgreSQLDatabase
		    db.DatabaseName = kDatabaseName
		    db.UserName = kUsername
		    db.Password = kPassword
		    db.Host = kHost
		    
		    Assert.IsTrue db.Connect
		  next
		  
		  Finally
		    if db isa object then
		      try
		        db.ExecuteSQL "DROP TABLE preemptive_thread_test"
		      end try
		      
		      db.Close
		      db = nil
		    end if
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RegExRunner(index As Integer, data As Variant)
		  var source as string = data.StringValue
		  
		  var rx as new RegEx
		  
		  rx.SearchPattern = source.Left( 2 )
		  
		  if rx.Search( source ) isa RegExMatch then
		    Store index, source, true
		  else
		    Store index, source,  false
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RegExTest()
		  var masterSource as string = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		  var masterSourceArray() as string = masterSource.Split( "" )
		  
		  var tp as new DelegateRunnerThreadPool( AddressOf RegExRunner )
		  
		  for i as integer = 0 to kLastJobIndex
		    masterSourceArray.Shuffle
		    var s as string = String.FromArray( masterSourceArray, "" )
		    tp.Add i : s
		  next
		  
		  Assert.Message "ActiveJobs = " + tp.ActiveJobs.ToString
		  tp.Wait
		  
		  CheckResults
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetAndroid and (Target64Bit))
		Private Sub RGBSurfaceRunner(index As Integer, data As Variant)
		  var p as Picture = data
		  
		  p.RGBSurface.Pixel( 0, index ) = &c0000FF00
		  
		  Store index, nil, true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetAndroid and (Target64Bit))
		Sub RGBSurfaceTest()
		  var p as new Picture( 1, kLastJobIndex + 1, 32 )
		  
		  var tp as new DelegateRunnerThreadPool( AddressOf RGBSurfaceRunner )
		  
		  for h as integer = 0 to kLastJobIndex
		    tp.Add h : p
		  next
		  
		  Assert.Message "ActiveJobs = " + tp.ActiveJobs.ToString
		  tp.Wait
		  
		  CheckResults
		  
		  for h as integer = 0 to kLastJobIndex
		    Assert.AreEqual &c0000FF00, p.RGBSurface.Pixel( 0, h )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SameMemoryBlockRunner(index As Integer, data As Variant)
		  var mb as MemoryBlock = data
		  var p as ptr = mb
		  
		  mb.Int64Value( index * 8 ) = index
		  
		  if not mb.Int64Value( index * 8 ) = index then
		    Store index, nil, false
		    return
		  end if
		  
		  p.Int64( index * 8 ) = index + kLastJobIndex + 1
		  Store index, nil, p.Int64( index * 8 ) = ( index + kLastJobIndex + 1 )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SameMemoryBlockTest()
		  var tp as new DelegateRunnerThreadPool( AddressOf SameMemoryBlockRunner )
		  
		  var mb as new MemoryBlock( ( kLastJobIndex + 1 ) * 8 )
		  
		  for i as integer = 0 to kLastJobIndex
		    tp.Add i : mb
		  next
		  
		  Assert.Message "ActiveJobs = " + tp.ActiveJobs.ToString
		  tp.Wait
		  
		  CheckResults
		  
		  for i as integer = 0 to kLastJobIndex
		    Assert.AreEqual i + kLastJobIndex + 1, mb.Int64Value( i * 8 )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLiteTest()
		  var tp as new DelegateRunnerThreadPool( AddressOf DatabaseTestsRunner )
		  
		  var folder as FolderItem
		  
		  #if TargetMobile then
		    folder = SpecialFolder.Documents
		  #else
		    folder = SpecialFolder.Temporary
		  #endif
		  
		  folder = folder.Child( System.Microseconds.ToString( "#0" ) )
		  folder.CreateFolder
		  
		  var file as FolderItem = folder.Child( "test.sqlite" )
		  
		  var db as new SQLiteDatabase
		  db.DatabaseFile = file
		  db.WriteAheadLogging = true
		  db.CreateDatabase()
		  
		  Assert.IsTrue db.Connect
		  
		  db.ExecuteSQL( "CREATE TABLE preemptive_thread_test (id INTEGER PRIMARY KEY, s TEXT)" )
		  
		  for i as integer = 0 to kLastJobIndex
		    var threadDb as new SQLiteDatabase
		    threadDb.WriteAheadLogging = true
		    threadDb.DatabaseFile = file
		    
		    tp.Add i : threadDb
		  next
		  
		  Assert.Message "ActiveJobs = " + tp.ActiveJobs.ToString
		  tp.Wait
		  
		  CheckResults
		  
		  for l as integer = 1 to 2
		    var rs as RowSet = db.SelectSQL( "SELECT id, s FROM preemptive_thread_test ORDER BY id" )
		    
		    Assert.AreEqual kLastJobIndex + 1, rs.RowCount
		    
		    var checkValue as integer
		    
		    for each row as DatabaseRow in rs
		      Assert.AreEqual rs.Column( "id" ).IntegerValue, checkValue
		      Assert.AreEqual rs.Column( "s" ).StringValue, checkValue.ToString
		      
		      checkValue = checkValue + 1
		    next
		    
		    db.Close
		    db = nil
		    
		    db = new SQLiteDatabase
		    db.DatabaseFile = file
		    db.WriteAheadLogging = true
		    
		    Assert.IsTrue db.Connect
		  next
		  
		  Finally
		    if db isa object then
		      db.Close
		      db = nil
		    end if
		    
		    folder.RemoveFolderAndContents
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Store(index As Integer, source As Variant, result As Boolean)
		  if Results.Count = 0 then
		    Locker.Signal
		    if Results.Count = 0 then
		      Results.ResizeTo kLastJobIndex
		    end if
		    Locker.Release
		  end if
		  
		  Results( index ) = source : result
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Locker As Semaphore
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Results() As Pair
	#tag EndProperty


	#tag Constant, Name = kDictKey, Type = String, Dynamic = False, Default = \"DictKey", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLastJobIndex, Type = Double, Dynamic = False, Default = \"49", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsRunning"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotImplementedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="TestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
