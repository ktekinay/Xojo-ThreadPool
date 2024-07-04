#tag Class
Class ThreadPool
Implements M_ThreadPool.ThreadPoolInterface
	#tag Method, Flags = &h0, Description = 416464206461746120746F207468652071756575652E204966207468652071756575652069732066756C6C2C20746869732077696C6C20706175736520756E74696C20616E20736C6F7420697320617661696C61626C652E205573652054727941646420696E737465616420776865726520706F737369626C652E
		Sub Add(data As Variant)
		  while not TryAdd( data )
		    #if DebugBuild
		      System.DebugLog "Queue is full, trying again"
		    #endif
		    Thread.SleepCurrent 5
		  wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddThreadToPool()
		  var t as new M_ThreadPool.PThread
		  t.Type = Type
		  t.MyThreadPool = self
		  
		  t.Start
		  
		  var lock as new LockHolder( PoolLock )
		  Pool.Add t
		  lock = nil
		  
		  while t.ThreadState = Thread.ThreadStates.NotRunning
		  wend
		  
		  #if DebugBuild
		    System.DebugLog "Added Thread to pool"
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddUserInterfaceUpdate(data As Dictionary)
		  var dict as new Dictionary
		  
		  var keys() as variant = data.Keys
		  var values() as variant = data.Values
		  
		  for i as integer = 0 to keys.LastIndex
		    dict.Value( keys( i ) ) = values( i )
		  next
		  
		  var lock as new LockHolder( UIUpdatesLock )
		  
		  UIUpdates.Add dict
		  
		  lock = nil
		  
		  StartUserInteraceUpdateTimer
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddUserInterfaceUpdate(ParamArray data() As Pair)
		  AddUserInterfaceUpdate data
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddUserInterfaceUpdate(data() As Pair)
		  var dict as new Dictionary
		  
		  for each p as pair in data
		    dict.Value( p.Left ) = p.Right
		  next
		  
		  var lock as new LockHolder( UIUpdatesLock )
		  
		  UIUpdates.Add dict
		  
		  lock = nil
		  
		  StartUserInteraceUpdateTimer
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  CreateQueuer
		  
		  PoolLock = new Semaphore
		  UIUpdatesLock = new Semaphore
		  UIUpdatesLock.Type = Type
		  RaiseQueueEventsTimerLock = new Semaphore
		  RaiseQueueEventsTimerLock.Type = Type
		  
		  RaiseQueueEventsTimer = new Timer
		  AddHandler RaiseQueueEventsTimer.Action, WeakAddressOf RaiseQueueEventsTimer_Action
		  
		  RaiseQueueEventsTimer.Period = 1
		  
		  RaiseUserInterfaceUpdateTimer = new Timer
		  AddHandler RaiseUserInterfaceUpdateTimer.Action, WeakAddressOf RaiseUserInterfaceUpdateTimer_Action
		  
		  RaiseUserInterfaceUpdateTimer.Period = 50
		  
		  QueueLimit = max( TrueMaximumJobs * 2, 8 )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CreateQueuer()
		  DataQueue = new M_ThreadPool.Queuer( Type )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  #if DebugBuild
		    System.DebugLog "ThreadPool.Destructor"
		  #endif
		  
		  IsDestructing = true
		  Stop
		  
		  var lock as new LockHolder( RaiseQueueEventsTimerLock )
		  RaiseQueueEventsTimer.RunMode = Timer.RunModes.Off
		  lock = nil
		  
		  RemoveHandler RaiseQueueEventsTimer.Action, WeakAddressOf RaiseQueueEventsTimer_Action
		  RaiseQueueEventsTimer = nil
		  
		  RaiseUserInterfaceUpdateTimer.RunMode = Timer.RunModes.Off
		  RemoveHandler RaiseUserInterfaceUpdateTimer.Action, WeakAddressOf RaiseUserInterfaceUpdateTimer_Action
		  
		  do
		  loop until ActiveJobs = 0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 43616C6C207468697320746F20696E6469636174652074686174206E6F206D6F726520646174612077696C6C20626520616464656420746F2074686520717565756520666F722070726F63657373696E672E
		Sub Finish()
		  if IsClosed or ActiveJobs = 0 then
		    return
		  end if
		  
		  for each t as M_ThreadPool.PThread in Pool
		    t.IsClosed = true
		  next
		  
		  PoolCleaner = new Thread
		  AddHandler PoolCleaner.Run, AddressOf PoolCleaner_Run
		  
		  PoolCleaner.Start
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetNextItem(ByRef data As Variant) As Boolean
		  var result as boolean
		  
		  if DataQueue.TrySkim( data ) then
		    result = true
		  end if
		  
		  var lock as new LockHolder( RaiseQueueEventsTimerLock )
		  
		  if not IsClosed and not DataQueue.IsDenyed and not IsDestructing and _
		    RaiseQueueEventsTimer.RunMode = Timer.RunModes.Off then
		    RaiseQueueEventsTimer.RunMode = Timer.RunModes.Multiple
		  end if
		  
		  lock = nil
		  
		  return result
		  
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
		    var lock as new LockHolder( PoolLock )
		    
		    if Pool.Count = 0 then // ActiveJobs will also attempt to lock so don't use it here
		      EndMicroseconds = System.Microseconds
		      
		      DataQueue = new Queuer
		      
		      if sender isa object then
		        RemoveHandler sender.Run, AddressOf PoolCleaner_Run
		        PoolCleaner = nil
		        
		        if not IsDestructing then
		          Timer.CallLater 1, AddressOf RaiseFinishedEvent
		        end if
		      end if
		      
		      RaiseUserInterfaceUpdateTimer.RunMode = Timer.RunModes.Single
		      
		      exit
		    end if
		    
		    for i as integer = Pool.LastIndex downto 0
		      var t as M_ThreadPool.PThread = Pool( i )
		      
		      if t.ThreadState = Thread.ThreadStates.NotRunning then
		        RemoveThreadFromPool t
		      end if
		    next
		    
		    if Pool.Count = 0 then
		      continue
		    end if
		    
		    lock = nil
		    
		    if sender isa object then
		      sender.Sleep 20, true
		    end if
		  loop
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseFinishedEvent()
		  RaiseEvent Finished
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseProcessEvent(data As Variant, sender As Thread)
		  RaiseEvent Process( data, sender )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseQueueEventsTimer_Action(sender As Timer)
		  var lock as new LockHolder( RaiseQueueEventsTimerLock )
		  
		  sender.RunMode = Timer.RunModes.Off
		  
		  lock = nil
		  
		  if IsClosed or IsDestructing then
		    return
		  end if
		  
		  if WasFull and not IsQueueFull then
		    WasFull = false
		    RaiseEvent QueueAvailable
		  end if
		  
		  if WasQueueLoaded and DataQueue.Count = 0 then
		    WasQueueLoaded = false
		    RaiseEvent QueueDrained
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseUserInterfaceUpdateTimer_Action(sender As Timer)
		  #pragma unused sender
		  
		  var lock as new LockHolder( UIUpdatesLock )
		  
		  if UIUpdates.Count <> 0 then
		    var uiUpdates() as Dictionary = self.UIUpdates
		    var cleanArr() as Dictionary
		    self.UIUpdates = cleanArr
		    
		    lock = nil
		    
		    RaiseEvent UserInterfaceUpdate( uiUpdates )
		  end if
		  
		  lock = nil
		  
		  if IsFinished then
		    RaiseUserInterfaceUpdateTimer.RunMode = Timer.RunModes.Off
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RemoveThreadFromPool(t As M_ThreadPool.PThread)
		  //
		  // Caller should lock the Pool
		  //
		  
		  while t.ThreadState <> Thread.ThreadStates.NotRunning
		  wend
		  
		  for i as integer = 0 to Pool.LastIndex
		    if Pool( i ) is t then
		      Pool.RemoveAt i
		      exit
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub StartUserInteraceUpdateTimer()
		  if RaiseUserInterfaceUpdateTimer.RunMode = Timer.RunModes.Off then
		    RaiseUserInterfaceUpdateTimer.RunMode = Timer.RunModes.Multiple
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53746F70732070726F63657373696E6720696D6D6564696174656C7920616E6420636C6F7365732074686520546872656164506F6F6C2E
		Sub Stop()
		  DataQueue.IsDenyed = true
		  
		  for each t as M_ThreadPool.PThread in Pool
		    t.IsClosed = true
		  next
		  
		  DataQueue.RemoveAll // When is succeeds, no thread will be able to attempt to lock the queue
		  
		  for each t as M_ThreadPool.PThread in Pool
		    #pragma BreakOnExceptions false
		    select case t.ThreadState
		    case Thread.ThreadStates.NotRunning
		      //
		      // Do nothing
		      //
		      
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

	#tag Method, Flags = &h0, Description = 417474656D70747320746F206164642074686520676976656E2060646174616020616E6420607461676020746F2074686520717565756520666F722070726F63657373696E672E2057696C6C2072657475726E2046616C7365206966207468652071756575652069732066756C6C2E
		Function TryAdd(data As Variant) As Boolean
		  if IsClosed then
		    raise new UnsupportedOperationException( "Cannot queue data after calling Finish until all processes have completed" )
		  end if
		  
		  if ActiveJobs = 0 then
		    StartMicroseconds = System.Microseconds
		    EndMicroseconds = 0.0
		  end if
		  
		  var added as boolean = DataQueue.TryAdd( data, QueueLimit )
		  WasFull = not added or ( QueueLimit > 0 and DataQueue.Count >= QueueLimit )
		  
		  if added and ActiveJobs < TrueMaximumJobs and DataQueue.Count <> 0 then
		    AddThreadToPool
		  end if
		  
		  WasQueueLoaded = WasQueueLoaded or added
		  
		  return added
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5761697420756E74696C20616C6C20746872656164732061726520636F6D706C6574652E20496D706C69657320436C6F73652E
		Sub Wait()
		  Finish
		  
		  while not IsFinished
		  wend
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0, Description = 416C6C2070726F63657373696E672068617320636F6E636C7564656420616674657220436C6F7365206F722053746F70207761732063616C6C65642E
		Event Finished()
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 496D706C656D656E7420746F2068616E646C652070726F63657373696E67206F66206F6E65206974656D206F6620646174612E
		Event Process(data As Variant, currentThread As Thread)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 416674657220686176696E672066696C6C6564207468652071756575652C206120736C6F7420686173206265636F6D6520617661696C61626C6520666F72206D6F726520646174612E
		Event QueueAvailable()
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 52616973656420616674657220746865206C61737420646174612069732072656D6F7665642066726F6D2074686520717565756520616E642074686520546872656164506F6F6C20686173206E6F74206265656E20636C6F7365642E
		Event QueueDrained()
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 526169736564207768656E206120546872656164206973737565732041646455736572496E746572666163655570646174652E
		Event UserInterfaceUpdate(data() As Dictionary)
	#tag EndHook


	#tag ComputedProperty, Flags = &h0, Description = 546865206E756D626572206F6620546872656164732063757272656E746C792072756E6E696E672E
		#tag Getter
			Get
			  var lock as new LockHolder( PoolLock )
			  var count as integer = Pool.Count
			  lock = nil
			  
			  return count
			  
			End Get
		#tag EndGetter
		ActiveJobs As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private DataQueue As M_ThreadPool.Queuer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206E756D626572206F66206D6963726F7365636F6E64732073696E63652070726F63657373696E6720737461727465642E
		#tag Getter
			Get
			  if StartMicroseconds = 0.0 then
			    return 0.0
			  end if
			  
			  var endMicroseconds as double = self.EndMicroseconds
			  
			  if endMicroseconds = 0.0 then
			    endMicroseconds = System.Microseconds
			  end if
			  
			  return endMicroseconds - StartMicroseconds
			  
			End Get
		#tag EndGetter
		ElapsedMicroseconds As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private EndMicroseconds As Double
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
			  return ActiveJobs = 0
			  
			End Get
		#tag EndGetter
		IsFinished As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return QueueLimit > 0 and DataQueue.Count >= QueueLimit
			  
			End Get
		#tag EndGetter
		IsQueueFull As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 546865206D6178696D756D206E756D626572206F66205468726561647320746F2072756E20617420616E7920676976656E2074696D652E2044656661756C742069732053797374656D2E436F7265436F756E74202D20312E
		MaximumJobs As Integer
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5365747320746865207479706573206F662054687265616473206173207468657920617265206C61756E636865642E204368616E67696E67207468697320646F6573206E6F742061666665637420616C72656164792D72756E6E696E6720546872656164732E
		Private mType As Thread.Types = Thread.Types.Preemptive
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

	#tag Property, Flags = &h21
		Private PoolLock As Semaphore
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4C696D69747320746865206E756D626572206F66206974656D732074686174206D617920626520696E2074686520717565756520617420616E79206F6E652074696D652E20557365207A65726F20666F7220756E6C696D697465642E
		QueueLimit As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private RaiseQueueEventsTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private RaiseQueueEventsTimerLock As Semaphore
	#tag EndProperty

	#tag Property, Flags = &h21
		Private RaiseUserInterfaceUpdateTimer As Timer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206E756D626572206F66206974656D732077616974696E6720746F2062652070726F6365737365642E
		#tag Getter
			Get
			  return DataQueue.Count
			End Get
		#tag EndGetter
		RemainingInQueue As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private StartMicroseconds As Double
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if MaximumJobs > 0 then
			    return MaximumJobs
			  elseif System.CoreCount = 1 then
			    return 1
			  else
			    return System.CoreCount - 1
			  end if
			  
			End Get
		#tag EndGetter
		Private TrueMaximumJobs As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mType
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if mType = value then
			    return
			  end if
			  
			  if not IsFinished then
			    raise new RuntimeException( "Cannot change Type while the ThreadPool is running." )
			  end if
			  
			  mType = value
			  
			  UIUpdatesLock.Type = value
			  RaiseQueueEventsTimerLock.Type = value
			  
			  CreateQueuer
			  
			End Set
		#tag EndSetter
		Type As Thread.Types
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private UIUpdates() As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private UIUpdatesLock As Semaphore
	#tag EndProperty

	#tag Property, Flags = &h21
		Private WasFull As Boolean
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
			Name="MaximumJobs"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
			InitialValue=""
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
			Name="IsQueueFull"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Thread.Types"
			EditorType="Enum"
			#tag EnumValues
				"0 - Cooperative"
				"1 - Preemptive"
			#tag EndEnumValues
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
