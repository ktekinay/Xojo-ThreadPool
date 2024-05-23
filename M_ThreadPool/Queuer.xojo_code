#tag Class
Private Class Queuer
Inherits ThreadSafeVariantArray
	#tag Method, Flags = &h0
		Function TryAdd(tag As Variant, data As Variant, limit As Integer) As Boolean
		  var result as boolean
		  
		  MySemaphore.Signal
		  
		  if limit <= 0 or self.Data.Count < limit then
		    self.Data.Add tag : data
		    result = true
		  end if
		  
		  MySemaphore.Release
		  
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TrySkim(ByRef data As Pair) As Boolean
		  var result as boolean
		  
		  MySemaphore.Signal
		  
		  if self.Data.Count <> 0 then
		    data = self.Data( 0 )
		    self.Data.RemoveAt 0
		    result = true
		  end if
		  
		  MySemaphore.Release
		  
		  return result
		End Function
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
End Class
#tag EndClass
