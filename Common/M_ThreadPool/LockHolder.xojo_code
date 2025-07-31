#tag Class
Private Class LockHolder
	#tag Method, Flags = &h21
		Private Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(cs As CriticalSection)
		  self.CS = cs
		  cs.Enter
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(s As Semaphore)
		  self.S = s
		  s.Signal
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  if S isa object then
		    try
		      S.Release
		      #if TargetMobile 
		    catch err as Xojo.Threading.IllegalLockingException
		      #else
		    catch err as IllegalLockingException
		      #endif
		      // Wasn't locked
		    end try
		    
		    S = nil
		  end if
		  
		  if CS isa object then
		    try
		      CS.Leave
		      #if TargetMobile 
		    catch err as Xojo.Threading.IllegalLockingException
		      #else
		    catch err as IllegalLockingException
		      #endif
		      // Wasn't locked
		    end try
		    
		    CS = nil
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function TryLock(cs As CriticalSection) As M_ThreadPool.LockHolder
		  if cs.TryEnter then
		    var lock as new LockHolder
		    lock.CS = cs
		    return lock
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function TryLock(s As Semaphore) As M_ThreadPool.LockHolder
		  if s.TrySignal then
		    var lock as new LockHolder
		    lock.S = s
		    return lock
		  end if
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private CS As CriticalSection
	#tag EndProperty

	#tag Property, Flags = &h21
		Private S As Semaphore
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
	#tag EndViewBehavior
End Class
#tag EndClass
