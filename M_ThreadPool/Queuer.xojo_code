#tag Class
Private Class Queuer
Inherits ThreadSafeVariantArray
	#tag Method, Flags = &h0
		Function TryAdd(data As Variant, limit As Integer) As Boolean
		  var result as boolean
		  
		  Locker.Enter
		  
		  if limit <= 0 or self.Data.Count < limit then
		    self.Data.Add data
		    result = true
		  end if
		  
		  Locker.Leave
		  
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TrySkim(ByRef data As Variant) As Boolean
		  var result as boolean
		  
		  Locker.Enter
		  
		  if self.Data.Count <> 0 then
		    data = self.Data( 0 )
		    self.Data.RemoveAt 0
		    result = true
		  end if
		  
		  Locker.Leave
		  
		  return result
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Count"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
