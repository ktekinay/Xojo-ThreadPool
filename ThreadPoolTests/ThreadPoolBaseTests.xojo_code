#tag Class
Protected Class ThreadPoolBaseTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub DestructorTest()
		  var tp as new ThreeN1ThreadPool
		  tp.Type = GetType
		  
		  tp.QueueLimit = 0
		  
		  for i as integer = 1 to 1000
		    Assert.IsTrue tp.TryAdd( i )
		  next
		  
		  var wr as new WeakRef( tp )
		  
		  tp = nil
		  
		  Assert.IsNil wr.Value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FinishedTest()
		  FinishedTester = new ThreeN1ThreadPool
		  FinishedTester.Type = GetType
		  
		  AddHandler FinishedTester.Finished, AddressOf FinishedTester_Finished
		  
		  for i as integer = 1001 to 1010
		    Assert.IsTrue FinishedTester.TryAdd( i )
		  next
		  
		  FinishedTester.Close
		  
		  AsyncAwait 5
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub FinishedTester_Finished(sender As ThreadPool)
		  RemoveHandler FinishedTester.Finished, AddressOf FinishedTester_Finished
		  
		  Assert.AreEqual 0, sender.RemainingInQueue
		  Assert.AreEqual 10, FinishedTester.Result
		  
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
		  NoQueueLimitTester = new ThreeN1ThreadPool
		  NoQueueLimitTester.Type = GetType
		  
		  NoQueueLimitTester.QueueLimit = 0
		  
		  AddHandler NoQueueLimitTester.Finished, AddressOf NoQueueLimitTester_Finished
		  
		  const kCount as integer = 20
		  const kStartValue as integer = 1000000
		  const kEndValue as integer = kStartValue + kCount - 1
		  
		  for i as integer = kStartValue to kEndValue
		    Assert.IsTrue NoQueueLimitTester.TryAdd( i )
		  next
		  
		  NoQueueLimitTester.Wait
		  Assert.AreEqual kCount, NoQueueLimitTester.Result
		  
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
		Sub QueueDrainedTest()
		  QueueDrainedTestIndex = 1
		  
		  QueueDrainedTester = new ThreeN1ThreadPool
		  QueueDrainedTester.Type = GetType
		  
		  QueueDrainedTester.QueueLimit = 2
		  
		  AddHandler QueueDrainedTester.QueueDrained, AddressOf QueueDrainedTester_QueueDrained
		  AddHandler QueueDrainedTester.Finished, AddressOf QueueDrainedTester_Finished
		  
		  QueueDrainedTestFeeder
		  
		  AsyncAwait 5
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub QueueDrainedTester_Finished(sender As ThreadPool)
		  #pragma unused sender
		  
		  Assert.AreEqual 4, QueueDrainedTester.Result, "Result"
		  Assert.AreEqual 5, QueueDrainedTestIndex, "Index"
		  
		  RemoveHandler QueueDrainedTester.QueueDrained, AddressOf QueueDrainedTester_QueueDrained
		  RemoveHandler QueueDrainedTester.Finished, AddressOf QueueDrainedTester_Finished
		  
		  QueueDrainedTester = nil
		  
		  AsyncComplete
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub QueueDrainedTester_QueueDrained(sender As ThreadPool)
		  Assert.IsFalse sender.IsFinished
		  QueueDrainedTestFeeder
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub QueueDrainedTestFeeder()
		  while QueueDrainedTester.TryAdd( QueueDrainedTestIndex )
		    QueueDrainedTestIndex = QueueDrainedTestIndex + 1
		    if QueueDrainedTestIndex > 4 then
		      QueueDrainedTester.Close
		      exit
		    end if
		  wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub QueueIsFullTest()
		  var tp as new EndLessThreadPool
		  tp.Type = GetType
		  
		  tp.QueueLimit = 1
		  tp.Jobs = 1
		  
		  Assert.IsTrue tp.TryAdd( 100000 )
		  Assert.IsTrue tp.TryAdd( 300000 )
		  Assert.IsFalse tp.TryAdd( 2000000 )
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StopTest()
		  var stopTester as new EndlessThreadPool
		  stopTester.Type = GetType
		  
		  Assert.IsTrue stopTester.TryAdd( 1 )
		  
		  Assert.IsFalse StopTester.IsFinished
		  
		  var spy as new ObjectSpy( stopTester )
		  var pool() as object = spy.Pool
		  var count as integer = pool.Count
		  Assert.AreEqual 1, count
		  
		  stopTester.Stop
		  
		  Assert.AreEqual 0, stopTester.RemainingInQueue
		  
		  count = pool.Count
		  Assert.AreEqual 0, count
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UserInterfaceUpdateTest()
		  UserInterfaceUpdateTester = new ThreeN1ThreadPool
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
		  var tp as new ThreeN1ThreadPool
		  tp.Type = GetType
		  
		  Assert.IsTrue tp.TryAdd( 1000 )
		  Assert.IsTrue tp.TryAdd( 2000 )
		  
		  tp.Wait
		  
		  Assert.IsTrue tp.IsFinished
		  Assert.AreEqual 2, tp.Result
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event GetType() As Thread.Types
	#tag EndHook


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
		Private QueueDrainedTester As ThreeN1ThreadPool
	#tag EndProperty

	#tag Property, Flags = &h21
		Private QueueDrainedTestIndex As Integer
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
