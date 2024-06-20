#tag Class
Private Class LockHolder
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
		    catch err as IllegalLockingException
		      // Wasn't locked
		    end try
		    
		    S = nil
		  end if
		  
		  if CS isa object then
		    try
		      CS.Leave
		    catch err as IllegalLockingException
		      // Wasn't locked
		    end try
		    
		    CS = nil
		  end if
		  
		End Sub
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
		#tag ViewProperty
			Name="S"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
