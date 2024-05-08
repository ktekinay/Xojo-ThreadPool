#tag Class
Private Class PThread
Inherits Thread
	#tag Event
		Sub Run()
		  const kSleepMs as integer = 10
		  
		  static noData as new M_ThreadPool.NoDataAvailable
		  
		  self.Type = Thread.Types.Preemptive
		  
		  do
		    if self.Data is noData then
		      Pause
		      continue
		    end if
		    
		    var data as variant = self.Data
		    self.Data = noData
		    
		    var tag as variant = self.Tag
		    self.Tag = nil
		    
		    var result as variant
		    
		    try
		      result = RaiseEvent Process( data )
		    catch err as RuntimeException
		      if err isa EndException or err isa ThreadEndException then
		        raise err
		      end if
		      
		      result = new M_ThreadPool.ThreadPoolException( err )
		    end try
		    
		    AddUserInterfaceUpdate tag : result
		  loop
		End Sub
	#tag EndEvent


	#tag Hook, Flags = &h0
		Event Process(data As Variant) As Variant
	#tag EndHook


	#tag Property, Flags = &h0
		Data As Variant
	#tag EndProperty

	#tag Property, Flags = &h0
		Tag As Variant
	#tag EndProperty


	#tag ViewBehavior
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
			InitialValue=""
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
			Name="Priority"
			Visible=true
			Group="Behavior"
			InitialValue="5"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StackSize"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DebugIdentifier"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ThreadID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ThreadState"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="ThreadStates"
			EditorType="Enum"
			#tag EnumValues
				"0 - Running"
				"1 - Waiting"
				"2 - Paused"
				"3 - Sleeping"
				"4 - NotRunning"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Types"
			EditorType="Enum"
			#tag EnumValues
				"0 - Cooperative"
				"1 - Preemptive"
			#tag EndEnumValues
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
