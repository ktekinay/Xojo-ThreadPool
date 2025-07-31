#tag Interface
Private Interface ThreadPoolInterface
	#tag Method, Flags = &h0
		Sub AddUserInterfaceUpdate(data As Dictionary)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddUserInterfaceUpdate(data() As Pair)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetNextItem(ByRef data As Variant) As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetWeakRef() As WeakRef
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RaiseProcessEvent(data As Variant)
		  
		End Sub
	#tag EndMethod


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
End Interface
#tag EndInterface
