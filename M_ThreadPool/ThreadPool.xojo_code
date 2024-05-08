#tag Class
Class ThreadPool
	#tag Method, Flags = &h21
		Private Sub AddThreadToPool()
		  var t as new M_ThreadPool.PThread
		  
		  t.DataQueue = self.DataQueue
		  
		  AddHandler t.Process, AddressOf PThread_Process
		  AddHandler t.UserInterfaceUpdate, AddressOf PThread_UserInterfaceUpdate
		  
		  t.Start
		  
		  Pool.Add t
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43616C6C207468697320746F20696E6469636174652074686174206E6F206D6F726520646174612077696C6C20626520616464656420746F2074686520717565756520666F722070726F63657373696E672E
		Sub Close()
		  if IsClosed then
		    return
		  end if
		  
		  for each t as M_ThreadPool.PThread in Pool
		    t.IsClosed = true
		  next
		  
		  PoolCleaner = new Timer
		  AddHandler PoolCleaner.Action, AddressOf PoolCleaner_Action
		  
		  PoolCleaner.Period = 20
		  PoolCleaner.RunMode = Timer.RunModes.Multiple
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  DataQueue = new M_ThreadPool.Queuer
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PoolCleaner_Action(sender As Timer)
		  if Pool.Count = 0 then
		    DataQueue.RemoveAll
		    
		    sender.RunMode = Timer.RunModes.Off
		    RemoveHandler sender.Action, AddressOf PoolCleaner_Action
		    PoolCleaner = nil
		    
		    return
		  end if
		  
		  for i as integer = Pool.LastIndex downto 0
		    var t as M_ThreadPool.PThread = Pool( i )
		    
		    if t.ThreadState = Thread.ThreadStates.NotRunning then
		      RemoveThreadFromPool t
		    end if
		  next
		  
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
		  #pragma unused sender
		  
		  for each dict as Dictionary in data
		    var tags() as variant = dict.Keys
		    var results() as variant = dict.Values
		    
		    for i as integer = 0 to tags.LastIndex
		      var tag as variant = tags( i )
		      var result as variant = results( i )
		      
		      if result isa M_ThreadPool.ThreadPoolException then
		        RaiseEvent Error( M_ThreadPool.ThreadPoolException( result ).WrappedException, tag )
		      else
		        RaiseEvent ResultAvailable( result, tag )
		      end if
		    next
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416464732074686520676976656E2060646174616020746F2074686520717565756520666F722070726F63657373696E672E20496620607461676020697320676976656E2C2069742077696C6C2062652072657475726E656420696E2074686520526573756C74417661696C61626C65206576656E742E204966206E6F7420676976656E2C206064617461602077696C6C206265207573656420617320746865207461672E
		Sub Queue(data As Variant, tag As Variant = Nil)
		  if IsClosed then
		    raise new UnsupportedOperationException( "Cannot queue data to a closed ThreadPool until all processes have completed" )
		  end if
		  
		  if tag is nil then
		    tag = data
		  end if
		  
		  var awakened as boolean
		  
		  while QueueIsFull
		    if not awakened then
		      awakened = WakeAThread
		    end if
		  wend
		  
		  DataQueue.Add tag : data
		  
		  if not WakeAThread and ( Jobs <= 0 or Pool.Count < Jobs ) then
		    AddThreadToPool
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RemoveThreadFromPool(t As M_ThreadPool.PThread)
		  if t.ThreadState <> Thread.ThreadStates.NotRunning then
		    t.Stop
		  end if
		  
		  RemoveHandler t.Process, AddRessOf PThread_Process
		  RemoveHandler t.UserInterfaceUpdate, AddressOf PThread_UserInterfaceUpdate
		  
		  for i as integer = 0 to Pool.LastIndex
		    if Pool( i ) is t then
		      Pool.RemoveAt i
		      exit
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53746F70732070726F63657373696E6720696D6D6564696174656C7920616E6420636C6F7365732074686520546872656164506F6F6C2E
		Sub Stop()
		  Close
		  
		  for each t as M_ThreadPool.PThread in Pool
		    if t.ThreadState <> Thread.ThreadStates.NotRunning then
		      #pragma BreakOnExceptions false
		      try
		        t.Stop
		      end try
		      #pragma BreakOnExceptions default
		    end if
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function WakeAThread() As Boolean
		  for each t as M_ThreadPool.PThread in Pool
		    if t.ThreadState = Thread.ThreadStates.Paused then
		      t.Resume
		      return true
		    end if
		  next
		  
		  return false
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0, Description = 52657475726E73207468652052756E74696D65457863657074696F6E2074686174206F63637572726564207768696C652070726F63657373696E672074686520676976656E207461672E
		Event Error(error As RuntimeException, tag As Variant)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 496D706C656D656E7420746F2068616E646C652070726F63657373696E67206F66206F6E65206974656D206F6620646174612E
		Event Process(data As Variant) As Variant
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 52657475726E732074686520726573756C742066726F6D2070726F63657373696E67207468652064617461206173736F63696174656420776974682074686520676976656E207461672E
		Event ResultAvailable(result As Variant, tag As Variant)
	#tag EndHook


	#tag Property, Flags = &h21
		Private DataQueue As M_ThreadPool.Queuer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  return PoolCleaner isa object
			  
			End Get
		#tag EndGetter
		Private IsClosed As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 52657475726E732054727565207768656E206E6F2054687265616473206172652072756E6E696E672E
		#tag Getter
			Get
			  return Pool.Count = 0
			  
			End Get
		#tag EndGetter
		IsFinished As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 546865206D6178696D756D206E756D626572206F66205468726561647320746F2072756E20617420616E7920676976656E2074696D652E203020697320756E6C696D6974656420736F2061206E6577205468726561642077696C6C2062652073746172746564206966206E6F206578697374696E672054687265616420697320617661696C61626C652E
		Jobs As Integer = 4
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Pool() As M_ThreadPool.PThread
	#tag EndProperty

	#tag Property, Flags = &h21
		Private PoolCleaner As Timer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  var queueLimit as integer = self.QueueLimit
			  
			  if queueLimit > 0 and queueLimit < Jobs then
			    queueLimit = Jobs
			  end if
			  
			  return queueLimit > 0 and DataQueue.Count >= queueLimit
			  
			End Get
		#tag EndGetter
		QueueIsFull As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 4C696D69747320746865206E756D626572206F66206974656D732074686174206D617920626520696E2074686520717565756520617420616E79206F6E652074696D652E205768656E20616464696E6720616E6F74686572206974656D2C20746869732077696C6C2068616E6720756E74696C2069742063616E2062652070726F6365737365642E0A0A4D757374206265207A65726F2028756E6C696D6974656429206F72206174206C6561737420746865206E756D626572206F66204A6F62732E
		QueueLimit As Integer = 8
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
			InitialValue="4"
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
			Name="QueueIsFull"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
