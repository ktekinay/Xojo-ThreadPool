#tag Class
Private Class ThreadSafeVariantArrayIterator
Implements Iterator
	#tag Method, Flags = &h0
		Sub Constructor(data() As Variant)
		  self.Data = data
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MoveNext() As Boolean
		  if Index >= Data.LastIndex then
		    return false
		  else
		    Index = Index + 1
		    return true
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value() As Variant
		  return Data( Index )
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Data() As Variant
	#tag EndProperty

	#tag Property, Flags = &h0
		Index As Integer = -1
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
			Name="Data()"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
