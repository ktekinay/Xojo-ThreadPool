#tag Class
Protected Class ThreadPoolTestBase
Inherits ThreadPool
	#tag Method, Flags = &h0
		Sub Constructor(testName As String)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  self.TestName = testName
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub InitializeTestGroups(controller As TestController)
		  Var group As TestGroup
		  
		  group = new ThreadPoolCooperativeTests( controller, "Cooperative ThreadPool" )
		  group = new ThreadPoolPreemptiveTests( controller, "Preemptive ThreadPool" )
		  'group.IncludeGroup = false
		  
		  group = new ThreadSafeVariantArrayTests( controller, "ThreadSafeVariantArray")
		  
		  group = new XojoFrameworkTests( controller, "Xojo Framework" )
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		TestName As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  static lock as Semaphore
			  
			  if lock is nil then
			    lock = new Semaphore
			    lock.Type = Thread.Types.Preemptive
			  end if
			  
			  return lock
			End Get
		#tag EndGetter
		Shared UniversalRowSetLock As Semaphore
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="MaximumJobs"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ActiveJobs"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ElapsedMicroseconds"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsQueueFull"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
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
		#tag ViewProperty
			Name="IsFinished"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="QueueLimit"
			Visible=false
			Group="Behavior"
			InitialValue="8"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RemainingInQueue"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
