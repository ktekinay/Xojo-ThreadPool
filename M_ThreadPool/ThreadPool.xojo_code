#tag Class
Class ThreadPool
	#tag Method, Flags = &h0, Description = 43616C6C207468697320746F20696E6469636174652074686174206E6F206D6F726520646174612077696C6C20626520616464656420746F2074686520717565756520666F722070726F63657373696E672E
		Sub Close()
		  IsClosed = true
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetThread() As M_ThreadPool.PThread
		  var t as M_ThreadPool.PThread
		  
		  for i as integer = Pool.LastIndex downto 0
		    var candidate as M_ThreadPool.PThread = Pool( i )
		    
		    if candidate.ThreadState = Thread.ThreadStates.NotRunning then
		      //
		      // Somehow this Thread died
		      //
		      RemoveHandler candidate.Process, AddressOf PThread_Process
		      RemoveHandler candidate.UserInterfaceUpdate, AddressOf PThread_UserInterfaceUpdate
		      
		      Pool.RemoveAt i
		      continue
		    end if
		    
		    if candidate.ThreadState = Thread.ThreadStates.Running then
		      continue
		    end if
		    
		    t = candidate
		    exit
		  next
		  
		  if t is nil and ( Jobs <= 0 or Pool.Count < Jobs ) then
		    t = new M_ThreadPool.PThread
		    AddHandler t.Process, AddressOf PThread_Process
		    AddHandler t.UserInterfaceUpdate, AddressOf PThread_UserInterfaceUpdate
		  end if
		  
		  return t
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessQueue()
		  DataQueueSemaphore.Signal
		  
		  var queue() as pair = DataQueue
		  
		  var empty() as pair
		  DataQueue = empty
		  
		  for each p as pair in queue
		    var t as M_ThreadPool.PThread = GetThread
		    if t is nil then
		      DataQueue.Add p
		      continue
		    end if
		    
		    t.Tag = p.Left
		    t.Data = p.Right
		    if t.ThreadState = Thread.ThreadStates.NotRunning then
		      t.Start
		    else
		      t.Resume
		    end if
		  next
		  
		  DataQueueSemaphore.Release
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function PThread_Process(sender As M_ThreadPool.PThread, data As Variant) As Variant
		  #pragma unused sender
		  
		  return RaiseEvent Process( data )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PThread_UserInterfaceUpdate(sender As M_ThreadPool.PThread, data() As Dictionary)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416464732074686520676976656E2060646174616020746F2074686520717565756520666F722070726F63657373696E672E20496620607461676020697320676976656E2C2069742077696C6C2062652072657475726E656420696E2074686520526573756C74417661696C61626C65206576656E742E204966206E6F7420676976656E2C206064617461602077696C6C206265207573656420617320746865207461672E
		Sub Queue(data As Variant, tag As Variant = Nil)
		  if IsFinished then
		    raise new UnsupportedOperationException( "Cannot reuse a finished ThreadPool" )
		  end if
		  
		  if tag is nil then
		    tag = data
		  end if
		  
		  DataQueueSemaphore.Signal
		  DataQueue.Add tag : data
		  DataQueueSemaphore.Release
		  
		  ProcessQueue
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Process(data As Variant) As Variant
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ResultAvailable(result As Variant, tag As Variant)
	#tag EndHook


	#tag Property, Flags = &h21
		Private DataQueue() As Pair
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  static s as new Semaphore
			  return s
			  
			End Get
		#tag EndGetter
		Private DataQueueSemaphore As Semaphore
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private IsClosed As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 53657420746F2054727565206F6E636520436F6D706C6574652069732063616C6C656420616E6420616C6C20726573756C74732068617665206265656E2072657475726E65642E
		#tag Getter
			Get
			  return mIsFinished
			End Get
		#tag EndGetter
		IsFinished As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 546865206D6178696D756D206E756D626572206F66205468726561647320746F2072756E20617420616E7920676976656E2074696D652E203020697320756E6C696D6974656420736F2061206E6577205468726561642077696C6C2062652073746172746564206966206E6F206578697374696E672054687265616420697320617661696C61626C652E
		Jobs As Integer = 4
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsFinished As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Pool() As M_ThreadPool.PThread
	#tag EndProperty


	#tag ViewBehavior
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
			Name="Jobs"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
