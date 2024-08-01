#tag Class
Protected Class ThreadPoolPreemptiveTests
Inherits ThreadPoolBaseTests
	#tag Event
		Function GetType() As Variant
		  #if XojoVersion >= 2024.03 then
		    return Thread.Types.Preemptive
		  #else
		    return 1
		  #endif
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub ChangeTypeTest()
		  #if XojoVersion >= 2024.03 then
		    var tp as new EndlessThreadPool
		    tp.Type = Thread.Types.Preemptive
		    
		    tp.MaximumJobs = 1
		    tp.Add 1
		    
		    tp.Type = Thread.Types.Preemptive
		    Assert.Pass "No change to Type is fine"
		    
		    #pragma BreakOnExceptions false
		    try
		      tp.Type = Thread.Types.Cooperative
		      Assert.Fail "Did not raise expected exception"
		    catch err as RuntimeException
		      Assert.IsTrue err.Message.Contains( "type" )
		    end try
		    #pragma BreakOnExceptions default
		    
		    tp.Stop
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DefaultQueueLimitTest()
		  var tp as new ThreadPool
		  Assert.AreEqual 0, tp.QueueLimit
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DefaultTypeTest()
		  #if XojoVersion >= 2024.03 then
		    var tp as new ThreadPool
		    Assert.IsTrue tp.Type = Thread.Types.Preemptive
		  #endif
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
