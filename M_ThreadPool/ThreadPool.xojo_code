#tag Class
Class ThreadPool
Implements M_ThreadPool.ThreadPoolInterface
	#tag Method, Flags = &h21
		Private Sub AddThreadToPool()
		  var t as new M_ThreadPool.PThread
		  t.Type = Type
		  t.MyThreadPool = self
		  
		  AddHandler t.UserInterfaceUpdate, WeakAddressOf PThread_UserInterfaceUpdate
		  
		  t.Start
		  
		  Pool.Add t
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43616C6C207468697320746F20696E6469636174652074686174206E6F206D6F726520646174612077696C6C20626520616464656420746F2074686520717565756520666F722070726F63657373696E672E
		Sub Close()
		  if IsClosed or Pool.Count = 0 then
		    return
		  end if
		  
		  for each t as M_ThreadPool.PThread in Pool
		    t.IsClosed = true
		    if t.ThreadState = Thread.ThreadStates.Paused then
		      t.Resume
		    end if
		  next
		  
		  PoolCleaner = new Thread
		  AddHandler PoolCleaner.Run, AddressOf PoolCleaner_Run
		  
		  PoolCleaner.Start
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  DataQueue = new M_ThreadPool.Queuer
		  
		  RaiseQueueDrainedEventTimer = new Timer
		  RaiseQueueDrainedEventTimer.Period = 1
		  AddHandler RaiseQueueDrainedEventTimer.Action, WeakAddressOf RaiseQueueDrainedEventTimer_Action
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  #if DebugBuild
		    System.DebugLog "ThreadPool.Destructor"
		  #endif
		  
		  IsDestructing = true
		  Stop
		  
		  RaiseQueueDrainedEventTimer.RunMode = Timer.RunModes.Off
		  RemoveHandler RaiseQueueDrainedEventTimer.Action, WeakAddressOf RaiseQueueDrainedEventTimer_Action
		  RaiseQueueDrainedEventTimer = nil
		  
		  do
		  loop until Pool.Count = 0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetNextItem(ByRef item As Pair) As Boolean
		  if DataQueue.TryPop( item ) then
		    return true
		  end if
		  
		  if not IsClosed and not IsDestructing then
		    RaiseQueueDrainedEventTimer.RunMode = Timer.RunModes.Single
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetWeakRef() As WeakRef
		  if mWeakRef is nil then
		    mWeakRef = new WeakRef( self )
		  end if
		  
		  return mWeakRef
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PoolCleaner_Run(sender As Thread)
		  do
		    if Pool.Count = 0 then
		      DataQueue.RemoveAll
		      
		      if sender isa object then
		        RemoveHandler sender.Run, AddressOf PoolCleaner_Run
		        PoolCleaner = nil
		        
		        if not IsDestructing then
		          Timer.CallLater 1, AddressOf RaiseFinishedEvent
		        end if
		      end if
		      
		      exit
		    end if
		    
		    for i as integer = Pool.LastIndex downto 0
		      var t as M_ThreadPool.PThread = Pool( i )
		      
		      if t.ThreadState = Thread.ThreadStates.NotRunning then
		        RemoveThreadFromPool t
		      end if
		    next
		    
		    if sender isa object then
		      sender.Sleep 20, true
		    end if
		  loop
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PThread_UserInterfaceUpdate(sender As M_ThreadPool.PThread, data() As Dictionary)
		  #pragma unused sender
		  
		  RaiseEvent UserInterfaceUpdate( data )
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416464732074686520676976656E2060646174616020746F2074686520717565756520666F722070726F63657373696E672E20496620607461676020697320676976656E2C2069742077696C6C2062652072657475726E656420696E2074686520526573756C74417661696C61626C65206576656E742E204966206E6F7420676976656E2C206064617461602077696C6C206265207573656420617320746865207461672E
		Sub Queue(data As Variant, tag As Variant = Nil)
		  if IsClosed then
		    raise new UnsupportedOperationException( "Cannot queue data to a closed ThreadPool until all processes have completed" )
		  end if
		  
		  var awakened as boolean
		  
		  while QueueIsFull
		    if not awakened then
		      awakened = WakeAThread
		    end if
		  wend
		  
		  DataQueue.Add tag : data
		  wasQueueLoaded = true
		  
		  if not WakeAThread and ( Jobs <= 0 or Pool.Count < Jobs ) then
		    AddThreadToPool
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseFinishedEvent()
		  RaiseEvent Finished
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseProcessEvent(data As Variant, tag As Variant)
		  RaiseEvent Process( data, tag )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseQueueDrainedEventTimer_Action(sender As Timer)
		  #pragma unused sender
		  
		  if WasQueueLoaded and not IsClosed and DataQueue.Count = 0 then
		    WasQueueLoaded = false
		    RaiseEvent QueueDrained
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RemoveThreadFromPool(t As M_ThreadPool.PThread)
		  if t.ThreadState <> Thread.ThreadStates.NotRunning then
		    t.Stop
		  end if
		  
		  while t.ThreadState <> Thread.ThreadStates.NotRunning
		  wend
		  
		  RemoveHandler t.UserInterfaceUpdate, WeakAddressOf PThread_UserInterfaceUpdate
		  
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
		  DataQueue.RemoveAll
		  
		  for each t as M_ThreadPool.PThread in Pool
		    t.IsClosed = true
		    
		    #pragma BreakOnExceptions false
		    select case t.ThreadState
		    case Thread.ThreadStates.NotRunning
		      //
		      // Do nothing
		      //
		      
		    case Thread.ThreadStates.Paused
		      //
		      // The resume will end the Thread when there it sees there is no data left
		      //
		      t.Resume
		      
		    case else
		      t.Stop
		    end select
		    #pragma BreakOnExceptions default
		  next
		  
		  if not IsClosed then
		    PoolCleaner_Run( nil )
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5761697420756E74696C20616C6C20746872656164732061726520636F6D706C6574652E20496D706C69657320436C6F73652E
		Sub Wait()
		  Close
		  
		  while not IsFinished
		  wend
		  
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


	#tag Hook, Flags = &h0, Description = 416C6C2070726F63657373696E672068617320636F6E636C7564656420616674657220436C6F7365206F722053746F70207761732063616C6C65642E
		Event Finished()
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 496D706C656D656E7420746F2068616E646C652070726F63657373696E67206F66206F6E65206974656D206F6620646174612E
		Event Process(data As Variant, tag As Variant)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 52616973656420616674657220746865206C61737420646174612069732072656D6F7665642066726F6D2074686520717565756520616E642074686520546872656164506F6F6C20686173206E6F74206265656E20636C6F7365642E
		Event QueueDrained()
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 526169736564207768656E206120546872656164206973737565732041646455736572496E746572666163655570646174652E
		Event UserInterfaceUpdate(data() As Dictionary)
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

	#tag Property, Flags = &h21
		Private IsDestructing As Boolean
	#tag EndProperty

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
		Private mWeakRef As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Pool() As M_ThreadPool.PThread
	#tag EndProperty

	#tag Property, Flags = &h21
		Private PoolCleaner As Thread
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206D6178696D756D206E756D626572206F66206974656D7320617320646566696E65642062792051756575654C696D6974206172652077616974696E6720696E207468652071756575652E
		#tag Getter
			Get
			  return QueueLimit > 0 and DataQueue.Count >= QueueLimit
			  
			End Get
		#tag EndGetter
		QueueIsFull As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 4C696D69747320746865206E756D626572206F66206974656D732074686174206D617920626520696E2074686520717565756520617420616E79206F6E652074696D652E20557365207A65726F20666F7220756E6C696D697465642E
		QueueLimit As Integer = 8
	#tag EndProperty

	#tag Property, Flags = &h21
		Private RaiseQueueDrainedEventTimer As Timer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206E756D626572206F66206974656D732077616974696E6720746F2062652070726F6365737365642E
		#tag Getter
			Get
			  return DataQueue.Count
			End Get
		#tag EndGetter
		RemainingInQueue As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 5365747320746865207479706573206F662054687265616473206173207468657920617265206C61756E636865642E204368616E67696E67207468697320646F6573206E6F742061666665637420616C72656164792D72756E6E696E6720546872656164732E
		Type As Thread.Types = Thread.Types.Preemptive
	#tag EndProperty

	#tag Property, Flags = &h21
		Private WasQueueLoaded As Boolean
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
			Visible=true
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
			Visible=true
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
		#tag ViewProperty
			Name="Type"
			Visible=true
			Group="Behavior"
			InitialValue="Thread.Types.Preemptive"
			Type="Thread.Types"
			EditorType="Enum"
			#tag EnumValues
				"0 - Cooperative"
				"1 - Preemptive"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="RemainingInQueue"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
