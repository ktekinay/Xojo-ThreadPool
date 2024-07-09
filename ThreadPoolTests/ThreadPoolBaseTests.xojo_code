#tag Class
Protected Class ThreadPoolBaseTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub ActiveJobsTest()
		  var tp as new EndlessThreadPool
		  tp.Type = GetType
		  
		  tp.MaximumJobs = 2
		  tp.QueueLimit = 0
		  
		  tp.Add 1
		  Assert.AreEqual 1, tp.ActiveJobs
		  
		  tp.Add 2
		  Assert.AreEqual 2, tp.ActiveJobs
		  
		  tp.Stop
		  
		  Assert.AreEqual 0, tp.ActiveJobs
		  Assert.IsTrue tp.IsFinished
		  
		  tp.Stop
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddTest()
		  var tp as new ThreeN1ThreadPool( CurrentMethodName )
		  tp.Type = GetType
		  
		  tp.QueueLimit = 2
		  tp.MaximumJobs = 1
		  
		  var expected as integer
		  for i as integer = 1051 to 1060
		    tp.Add i
		    expected = expected + i
		  next
		  
		  tp.Wait
		  
		  Assert.AreEqual expected, tp.Result
		  
		  if Assert.Failed then
		    tp.Inputs.Sort
		    for each i as integer in tp.Inputs
		      Assert.Message i.ToString
		    next
		  end if
		  
		  tp.Stop
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Delay(ms As Integer)
		  var now as double = System.Microseconds
		  var target as double = now + ( ms * 1000.0 )
		  
		  while System.Microseconds < target
		  wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DestructorTest()
		  var tp as new ThreeN1ThreadPool( CurrentMethodName )
		  tp.Type = GetType
		  
		  tp.QueueLimit = 0
		  
		  for i as integer = 1 to 1000
		    Assert.IsTrue tp.TryAdd( i )
		  next
		  
		  var wr as new WeakRef( tp )
		  
		  tp.Stop
		  tp = nil
		  
		  var start as integer = System.Ticks
		  while ( System.Ticks - start ) < 60 and wr.Value isa object
		  wend
		  
		  Assert.IsNil wr.Value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ElapsedMicrosecondsTest()
		  var tp as new ThreeN1ThreadPool( CurrentMethodName )
		  tp.Type = GetType
		  
		  Assert.IsTrue tp.ElapsedMicroseconds = 0.0
		  
		  tp.QueueLimit = 0
		  tp.MaximumJobs = System.CoreCount - 1
		  
		  for i as integer = 1051 to 1100
		    tp.Add i
		    Assert.IsTrue tp.ElapsedMicroseconds > 0.0
		  next
		  
		  tp.Wait
		  
		  var elapsed as double = tp.ElapsedMicroseconds
		  Assert.IsTrue elapsed > 0.0
		  
		  Delay 1
		  
		  Assert.AreEqual elapsed, tp.ElapsedMicroseconds
		  
		  tp.Stop
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EventsTest()
		  EventsTestIndex = 1
		  
		  EventsTester = new ThreeN1ThreadPool( CurrentMethodName )
		  EventsTester.Type = GetType
		  
		  EventsTester.MaximumJobs = 1
		  EventsTester.QueueLimit = 4
		  
		  AddHandler EventsTester.QueueAvailable, AddressOf EventsTester_QueueAvailable
		  AddHandler EventsTester.QueueDrained, AddressOf EventsTester_QueueDrained
		  AddHandler EventsTester.Finished, AddressOf EventsTester_Finished
		  
		  EventsTestFeeder
		  
		  AsyncAwait 5
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EventsTester_Finished(sender As ThreadPool)
		  #pragma unused sender
		  
		  Assert.AreEqual EventsTestExpected, EventsTester.Result, "Result"
		  Assert.AreEqual 11, EventsTestIndex, "Index"
		  
		  RemoveHandler EventsTester.QueueAvailable, AddressOf EventsTester_QueueAvailable
		  RemoveHandler EventsTester.QueueDrained, AddressOf EventsTester_QueueDrained
		  RemoveHandler EventsTester.Finished, AddressOf EventsTester_Finished
		  
		  EventsTester = nil
		  
		  sender.Stop
		  
		  AsyncComplete
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EventsTester_QueueAvailable(sender As ThreadPool)
		  EventsTestFeeder
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EventsTester_QueueDrained(sender As ThreadPool)
		  EventsTester.Wait
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EventsTestFeeder()
		  if EventsTestIndex > 10 then
		    Assert.Message "Queue is full, skipping feeder"
		    return
		  end if
		  
		  Assert.Message "Starting feeder (Queue has " + EventsTester.RemainingInQueue.ToString + " remaining)"
		  
		  while EventsTester.TryAdd( EventsTestIndex * 100000 )
		    EventsTestExpected = EventsTestExpected + ( EventsTestIndex * 100000 )
		    
		    Assert.Message "Added " + EventsTestIndex.ToString
		    
		    EventsTestIndex = EventsTestIndex + 1
		    if EventsTestIndex > 10 then
		      exit
		    end if
		  wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FinishedTest()
		  FinishedTester = new ThreeN1ThreadPool( CurrentMethodName )
		  FinishedTester.Type = GetType
		  
		  FinishedTester.QueueLimit = 0
		  FinishedTester.MaximumJobs = 1
		  
		  AddHandler FinishedTester.Finished, AddressOf FinishedTester_Finished
		  
		  for i as integer = 1001 to 1010
		    Assert.IsTrue FinishedTester.TryAdd( i )
		  next
		  
		  FinishedTester.Finish
		  
		  AsyncAwait 5
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub FinishedTester_Finished(sender As ThreadPool)
		  RemoveHandler FinishedTester.Finished, AddressOf FinishedTester_Finished
		  
		  var expected as integer
		  
		  for i as integer = 1001 to 1010
		    expected = expected + i
		  next
		  
		  Assert.AreEqual 0, sender.RemainingInQueue
		  Assert.AreEqual expected, FinishedTester.Result
		  
		  FinishedTester = nil
		  
		  AsyncComplete
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitializeTest()
		  var tp as new ThreadPool
		  tp.Type = GetType
		  
		  Assert.IsTrue tp.IsFinished
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NoQueueLimitTest()
		  NoQueueLimitTester = new ThreeN1ThreadPool( CurrentMethodName )
		  NoQueueLimitTester.Type = GetType
		  
		  NoQueueLimitTester.QueueLimit = 0
		  
		  AddHandler NoQueueLimitTester.Finished, AddressOf NoQueueLimitTester_Finished
		  
		  const kCount as integer = 20
		  const kStartValue as integer = 1000000
		  const kEndValue as integer = kStartValue + kCount - 1
		  
		  var expected as integer
		  
		  for i as integer = kStartValue to kEndValue
		    Assert.IsTrue NoQueueLimitTester.TryAdd( i )
		    expected = expected + i
		  next
		  
		  NoQueueLimitTester.Wait
		  Assert.AreEqual expected, NoQueueLimitTester.Result
		  
		  AsyncAwait 5
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub NoQueueLimitTester_Finished(sender As ThreadPool)
		  RemoveHandler sender.Finished, AddressOf NoQueueLimitTester_Finished
		  
		  NoQueueLimitTester = nil
		  
		  AsyncComplete
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub QueueIsFullTest()
		  var tp as new EndLessThreadPool( CurrentMethodName )
		  
		  tp.Type = GetType
		  
		  tp.QueueLimit = 1
		  tp.MaximumJobs = 1
		  
		  Assert.IsFalse tp.IsQueueFull
		  
		  call tp.TryAdd( 10 )
		  
		  while not tp.IsProcessing
		  wend
		  
		  for i as integer = 10000 to 20000
		    if tp.TryAdd( i ) = false then
		      exit
		    end if
		  next
		  
		  if not tp.IsQueueFull then
		    Assert.Fail "Queue is not full"
		  else
		    Assert.Pass
		  end if
		  
		  tp.StopIt = true
		  tp.Wait
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SlowFeedTest()
		  var tp as new ThreeN1ThreadPool( CurrentMethodName )
		  tp.Type = GetType
		  
		  tp.QueueLimit = 0
		  tp.MaximumJobs = 1
		  
		  tp.Add 1000
		  Delay 10
		  tp.Add 2000
		  
		  tp.Wait
		  
		  Assert.AreEqual 3000, tp.Result
		  
		  if Assert.Failed then
		    for each i as integer in tp.Inputs
		      Assert.Message i.ToString
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StopTest()
		  var stopTester as new EndlessThreadPool( CurrentMethodName )
		  stopTester.Type = GetType
		  
		  stopTester.Stop
		  Assert.IsTrue stopTester.IsFinished, "IsFinished"
		  
		  Assert.IsTrue stopTester.TryAdd( 1 ), "TryAdd"
		  
		  Assert.IsFalse StopTester.IsFinished, "IsFinished"
		  
		  var count as integer = stopTester.ActiveJobs
		  Assert.AreEqual 1, count, "Count"
		  
		  stopTester.Stop
		  
		  Assert.AreEqual 0, stopTester.RemainingInQueue, "RemainingInQueue"
		  
		  count = stopTester.ActiveJobs
		  Assert.AreEqual 0, count, "Count"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UserInterfaceUpdateTest()
		  UserInterfaceUpdateTester = new ThreeN1ThreadPool( CurrentMethodName )
		  UserInterfaceUpdateTester.Type = GetType
		  
		  AddHandler UserInterfaceUpdateTester.UserInterfaceUpdate, WeakAddressOf UserInterfaceUpdateTester_UserInterfaceUpdate
		  
		  Assert.IsTrue UserInterfaceUpdateTester.TryAdd( 1 )
		  
		  AsyncAwait 5
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UserInterfaceUpdateTester_UserInterfaceUpdate(sender As ThreadPool, data() As Dictionary)
		  #pragma unused sender
		  
		  var count as integer = data.Count
		  Assert.AreEqual 1, count
		  
		  var d as Dictionary = data.Pop
		  Assert.IsTrue d.HasKey( 1 )
		  
		  UserInterfaceUpdateTester.Stop
		  
		  RemoveHandler UserInterfaceUpdateTester.UserInterfaceUpdate, WeakAddressOf UserInterfaceUpdateTester_UserInterfaceUpdate
		  UserInterfaceUpdateTester = nil
		  
		  AsyncComplete
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WaitTest()
		  var tp as new ThreeN1ThreadPool( CurrentMethodName )
		  tp.Type = GetType
		  
		  tp.QueueLimit = 0
		  tp.MaximumJobs = 4
		  
		  var expected as integer
		  
		  for i as integer = 1000 to 100000 step 1000
		    Assert.IsTrue tp.TryAdd( i )
		    expected = expected + i
		  next
		  
		  tp.Wait
		  
		  Assert.IsTrue tp.IsFinished
		  Assert.AreEqual expected, tp.Result
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event GetType() As Thread.Types
	#tag EndHook


	#tag Property, Flags = &h21
		Private EventsTester As ThreeN1ThreadPool
	#tag EndProperty

	#tag Property, Flags = &h21
		Private EventsTestExpected As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private EventsTestIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ExceptionTester As ThreadPool
	#tag EndProperty

	#tag Property, Flags = &h21
		Private FinishedTester As ThreeN1ThreadPool
	#tag EndProperty

	#tag Property, Flags = &h21
		Private NoQueueLimitTester As ThreeN1ThreadPool
	#tag EndProperty

	#tag Property, Flags = &h21
		Private UserInterfaceUpdateTester As ThreeN1ThreadPool
	#tag EndProperty


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
