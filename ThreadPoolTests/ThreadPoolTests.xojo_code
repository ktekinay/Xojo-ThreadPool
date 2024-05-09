#tag Class
Protected Class ThreadPoolTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub ExceptionTest()
		  return
		  
		  ExceptionTester = new ExceptionThreadPool
		  ExceptionTester.Queue 1
		  
		  self.AsyncAwait 1
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ExceptionTester_Error(sender As ThreadPool, error As RuntimeException, tag As Variant)
		  #pragma unused sender
		  
		  Assert.AreEqual "General Exception", error.Message
		  Assert.AreEqual 1, tag.IntegerValue
		  
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
		Sub StopTest()
		  StopTester = new EndlessThreadPool
		  StopTester.Queue 1
		  
		  Assert.IsFalse StopTester.IsFinished
		  
		  var spy as new ObjectSpy( StopTester )
		  var pool() as object = spy.Pool
		  var count as integer = pool.Count
		  Assert.AreEqual 1, count
		  
		  AddHandler StopTester.Finished, WeakAddressOf StopTester_Finished
		  StopTester.Stop
		  
		  AsyncAwait 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub StopTester_Finished(sender As ThreadPool)
		  var spy as new ObjectSpy( sender )
		  var pool() as object = spy.Pool
		  
		  var count as integer = pool.Count
		  Assert.AreEqual 0, count
		  Assert.IsTrue sender.IsFinished
		  
		  StopTester = nil
		  
		  AsyncComplete
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private ExceptionTester As ThreadPool
	#tag EndProperty

	#tag Property, Flags = &h21
		Private NoQueueLimitTester As ThreeN1ThreadPool
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StopTester As ThreadPool
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
