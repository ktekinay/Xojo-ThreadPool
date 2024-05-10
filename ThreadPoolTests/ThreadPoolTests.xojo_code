#tag Class
Protected Class ThreadPoolTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub CooperativeTest()
		  var tp as new ThreeN1ThreadPool
		  tp.Type = Thread.Types.Cooperative
		  
		  tp.Queue 1000
		  tp.Queue 2000
		  
		  tp.Wait
		  
		  Assert.IsTrue tp.IsFinished
		  Assert.AreEqual 2, tp.Result
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DestructorTest()
		  var tp as new ThreeN1ThreadPool
		  tp.QueueLimit = 0
		  
		  for i as integer = 1 to 1000
		    tp.Queue i
		  next
		  
		  var wr as new WeakRef( tp )
		  
		  tp = nil
		  
		  Assert.IsNil wr.Value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FinishedTest()
		  FinishedTester = new ThreeN1ThreadPool
		  AddHandler FinishedTester.Finished, AddressOf FinishedTester_Finished
		  
		  for i as integer = 1001 to 1010
		    FinishedTester.Queue i
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
		  Assert.IsTrue tp.IsFinished
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NoQueueLimitTest()
		  NoQueueLimitTester = new ThreeN1ThreadPool
		  NoQueueLimitTester.QueueLimit = 0
		  
		  AddHandler NoQueueLimitTester.Finished, AddressOf NoQueueLimitTester_Finished
		  
		  const kCount as integer = 20
		  const kStartValue as integer = 1000000
		  const kEndValue as integer = kStartValue + kCount - 1
		  
		  for i as integer = kStartValue to kEndValue
		    NoQueueLimitTester.Queue i
		  next
		  
		  Assert.IsFalse NoQueueLimitTester.QueueIsFull
		  
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
		  QueueDrainedTester = new ThreeN1ThreadPool
		  AddHandler QueueDrainedTester.QueueDrained, AddressOf QueueDrainedTester_QueueDrained
		  
		  for i as integer = 1001 to 1010
		    QueueDrainedTester.Queue i
		  next
		  
		  AsyncAwait 5
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub QueueDrainedTester_QueueDrained(sender As ThreadPool)
		  Assert.IsFalse sender.IsFinished
		  Assert.AreEqual 10, QueueDrainedTester.Result
		  
		  RemoveHandler QueueDrainedTester.QueueDrained, AddressOf QueueDrainedTester_QueueDrained
		  QueueDrainedTester = nil
		  
		  AsyncComplete
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub QueueIsFullTest()
		  var tp as new ThreeN1ThreadPool
		  tp.QueueLimit = 1
		  
		  tp.Queue 100000
		  tp.Queue 2000000
		  
		  Assert.IsTrue tp.QueueIsFull
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StopTest()
		  var stopTester as new EndlessThreadPool
		  
		  stopTester.Queue 1
		  
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
