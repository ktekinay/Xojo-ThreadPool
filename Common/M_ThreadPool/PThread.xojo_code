#tag Class
Private Class PThread
Inherits Thread
	#tag Event
		Sub Run()
		  var retrying as boolean
		  
		  do
		    var host as M_ThreadPool.ThreadPool = MyThreadPool
		    
		    if host is nil then
		      exit
		    end if
		    
		    var data as variant
		    if not ThreadPoolInterface( host ).GetNextItem( data ) then
		      if IsClosed then
		        if not retrying then
		          //
		          // Another data element might have been added, and the thread closed, 
		          // right after the check above, so we are going to look again just to make sure
		          //
		          retrying = true
		          continue
		        end if
		        
		        //
		        // If we get here, the thread was closed and we've already checked for more
		        // data
		        //
		        exit
		      end if
		      
		      //
		      // Drop references
		      //
		      host = nil
		      
		      Sleep 1
		      continue
		    end if
		    
		    retrying = false
		    
		    try
		      ThreadPoolInterface( host ).RaiseProcessEvent( data )
		    catch err as RuntimeException
		      if err isa EndException or err isa ThreadEndException then
		        raise err
		      end if
		      
		      var dict as new Dictionary
		      
		      dict.Value( ThreadPool.kExceptionKey ) = err
		      dict.Value( ThreadPool.kDataKey ) = data
		      
		      ThreadPoolInterface( host ).AddUserInterfaceUpdate dict
		    end try
		    
		  loop
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddUserInterfaceUpdate(data as Dictionary)
		  var host as ThreadPool = MyThreadPool
		  if host is nil then
		    return
		  end if
		  
		  ThreadPoolInterface( host ).AddUserInterfaceUpdate( data )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddUserInterfaceUpdate(ParamArray data() as Pair)
		  var host as ThreadPool = MyThreadPool
		  if host is nil then
		    return
		  end if
		  
		  ThreadPoolInterface( host ).AddUserInterfaceUpdate( data )
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		ID As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		IsClosed As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if MyThreadPoolWeakRef is nil then
			    return nil
			  end if
			  
			  var val as object = MyThreadPoolWeakRef.Value
			  
			  if val is nil then
			    return nil
			  else
			    var tp as M_ThreadPool.ThreadPool = M_ThreadPool.ThreadPool( val )
			    
			    return tp
			  end if
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if value is nil then
			    MyThreadPoolWeakRef = nil
			  else
			    MyThreadPoolWeakRef = ThreadPoolInterface( value).GetWeakRef
			  end if
			  
			End Set
		#tag EndSetter
		MyThreadPool As M_ThreadPool.ThreadPool
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private MyThreadPoolWeakRef As WeakRef
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
		#tag ViewProperty
			Name="IsClosed"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
