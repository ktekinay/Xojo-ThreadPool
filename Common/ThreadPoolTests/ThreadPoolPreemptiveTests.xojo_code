#tag Class
Protected Class ThreadPoolPreemptiveTests
Inherits ThreadPoolBaseTests
	#tag Event
		Function GetType() As Thread.Types
		  return Thread.Types.Preemptive
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub DefaultQueueLimitTest()
		  var tp as new ThreadPool
		  Assert.AreEqual 0, tp.QueueLimit
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DefaultTypeTest()
		  var tp as new ThreadPool
		  Assert.IsTrue tp.Type = Thread.Types.Preemptive
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TypeChangeTest()
		  var tp as new EndlessThreadPool
		  tp.Add 1
		  
		  Assert.IsFalse tp.IsFinished
		  
		  tp.Type = Thread.Types.Preemptive
		  Assert.Pass "Ignores type change when not really a change"
		  
		  #pragma BreakOnExceptions false
		  try
		    tp.Type = Thread.Types.Cooperative
		    Assert.Fail "Allowed type change to cooperative"
		  catch err as RuntimeException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		  tp.Stop
		  
		End Sub
	#tag EndMethod


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
